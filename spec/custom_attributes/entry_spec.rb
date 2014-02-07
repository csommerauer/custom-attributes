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

    it "#value returns the custom_value value" do
      entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id,
        :custom_value_type=>"CustomAttributes::Textfield", 
        :custom_value_attributes=>{:value=>"something meaningful"})
      entry.value.should == "something meaningful"
    end   

  end   
end