require 'spec_helper'

describe "CustomAttributes::Entry" do 
  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) {AttributeHolder.first}

  before :each do
    @custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
  end
  
  context "instance creation" do

    it "is valid when created through the :custom_attributable belongs_to associaton and it references the custom_attribute_fields" do
      attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id).should be_valid
    end

    it "is not valid without custom_attribute_field_id" do
      attr_holder.custom_attributes.create.should_not be_valid
    end

    it "is not valid without belongs_to association" do 
      CustomAttributes::Entry.create(:custom_attribute_field_id=>@custom_attribute.id).should_not be_valid
    end

    it "is not valid if custom_attribute_field is not part of custom_attribute_fields of the :custom_attributable assiociation" do
      attr_holder.custom_attributes.create(:custom_attribute_field_id=>99).should_not be_valid
    end

    it "can't be created twice for the same :custom_attribute_field_id" do
      attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id).should be_valid
      attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id).should_not be_valid
    end

    it "can be created for the same :custom_attribute_field_id for another attribute holder" do
      attr_holder2 = AttributeHolder.create!(:title=>"something else", :config_holder_id=>attr_holder.config_holder_id )
      attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id).should be_valid
      attr_holder2.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id).should be_valid
    end
  end

  context "instance deletion" do
    before :each do
      attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
    end

    it "is deleted if the attr_holder is deleted" do
      expect { attr_holder.destroy }.to change{ CustomAttributes::Entry.count}.from(1).to(0)
    end

    it "is deleted if the custom_attribute_field is deleted" do
      expect { @custom_attribute.destroy }.to change{ CustomAttributes::Entry.count}.from(1).to(0) 
    end

    it "can be deleted through the attr_holder" do
      expect { attr_holder.update_attributes( :custom_attributes_attributes => {
        :"0" => {
          :id => attr_holder.custom_attributes.first.id, 
          :_destroy => 1 } 
        }) 
      }.to change{ CustomAttributes::Entry.count}.from(1).to(0)
    end
  end

  context "methods" do
    before :each do
      @entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
    end

    it "#custom_attribute_fields method that returns the available fields" do
      @entry.custom_attribute_fields.first.should eq  @custom_attribute
    end 

    it "#name returns the custom_attribute_field name" do
      @entry.name.should == @custom_attribute.name
    end

    it "#field_type returns the custom_attribute_field field_type" do
      @entry.field_type.should == @custom_attribute.field_type
    end

    context "#value" do
      it "returns the custom_value value" do
        entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id,
          :custom_value_type=>"CustomAttributes::Textfield", 
          :custom_value_attributes=>{:value=>"something meaningful"})
        entry.value.should == "something meaningful"
      end

      it "returns the custom_value attachemnt for filefield" do
        Paperclip::Attachment.default_options[:path] = PAPERCLIP_PATH
        custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"filefield")
        entry = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>custom_attribute.id,
          :custom_value_type=>"CustomAttributes::Filefield", 
          :custom_value_attributes=>{:attachment=>File.new("#{RSPEC_ROOT}/fixtures/files/car.jpg")})
        expect(entry.value).to be_instance_of Paperclip::Attachment 
      end      
    end
  end

  context "#required_custom_attributes_persisted_and_valid? which validates all required custom_attributes" do
    it "exists" do
      expect(attr_holder.public_methods.include?(:required_custom_attributes_persisted_and_valid?)).to be_true
    end

    it "return true if there is no required field" do
      expect(attr_holder.required_custom_attributes_persisted_and_valid?).to be_true
    end

    context "at least one required_field" do
      before :each do
        @custom_attribute.update_attribute(:required, true)
      end
      
      it "returns false if a required field is new_record?" do
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).not_to be_true
      end

      it "return false if custom_value is nil" do
        @entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
        expect(@entry.custom_value).to be_nil
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).not_to be_true
      end

      it "return false if custom_value is a new_record?" do
        @entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
        @entry.custom_value=CustomAttributes::Textfield.new({:value=>"xxx"})
        expect(@entry.custom_value.new_record?).to be_true
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).not_to be_true
      end

      it "returns false if a required field is !valid?" do
        ca = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id, :custom_value_attributes=>{:value=>"sss"})
        ca.custom_value.update_attribute(:value,"")
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).not_to be_true
      end

      it "returns true if a required field is !new_record? and !changed? and valid?" do
        ca = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_attribute.id, :custom_value_attributes=>{:value=>"sss"})
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).to be_true
      end

      it "returns true even if one custom_attribute is not required for a valid required attribute" do
        @custom_attribute2 = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
        expect(attr_holder.custom_attribute_fields.count).to be 2
        ca = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_attribute.id, :custom_value_attributes=>{:value=>"sss"})
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).to be_true
      end

      it "returns false if one required custom_attribute is not valid" do
        @custom_attribute2 = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield", :required=>true)
        expect(attr_holder.custom_attribute_fields.count).to be 2
        ca = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_attribute.id, :custom_value_attributes=>{:value=>"sss"})
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).to be_false
      end

      it "returns true if both required custom_attribute are valid" do
        @custom_attribute2 = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield", :required=>true)
        expect(attr_holder.custom_attribute_fields.count).to be 2
        attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_attribute.id, :custom_value_attributes=>{:value=>"sss"})
        attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_attribute2.id, :custom_value_attributes=>{:value=>"sss"})
        expect(attr_holder.required_custom_attributes_persisted_and_valid?).to be_true
      end
    end
  end
     
end