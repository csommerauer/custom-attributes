require 'spec_helper'

describe "CustomAttributes::Checkbox" do 
  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) {AttributeHolder.first}

  before :each do
    @custom_field = config_holder.custom_attribute_fields.create!(:name=>"checkbox", :field_type=>"checkbox")
  end

  context "instance creation" do

    it "should be valid with a valid has_one association that represents a checkbox" do
      expect{ 
        attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>true})
        }.to change(CustomAttributes::Checkbox, :count).from(0).to(1)
    end
    
    it "is not valid with if the value is empty and the field is required" do
      @custom_field = config_holder.custom_attribute_fields.create!(:name=>"checkbox", :field_type=>"checkbox", :required=> true)
      expect { 
        attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>""})
      }.not_to change(CustomAttributes::Checkbox, :count)
    end

  end 

  context "instance deletion" do
    it "should be delete if entry is deleted" do
      entry = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"true"})
      expect { 
        entry.destroy }.to change(CustomAttributes::Checkbox, :count).from(1).to(0)
    end
  end 


  context "validating" do
    before :each do
      @entry = attr_holder
    end

    context "not required" do
      it "empty is valid if not required" do  
        @entry.custom_attributes_populate
        expect(@entry.custom_attributes[0]).to be_valid
      end

      it "is valid and true when value is set to true" do
        @entry.custom_attributes_populate
        @entry.custom_attributes[0].custom_value.value= true
        expect(@entry.custom_attributes[0]).to be_valid
        expect(@entry.custom_attributes[0].value).to be_true
      end

      it "is valid and true when value is set to string 'true'" do
        @entry.custom_attributes_populate
        @entry.custom_attributes[0].custom_value.value= "true"
        expect(@entry.custom_attributes[0]).to be_valid
        expect(@entry.custom_attributes[0].value).to be_true
      end

      it "is valid and false when value is set but not true or 'true'" do
        @entry.custom_attributes_populate
        @entry.custom_attributes[0].custom_value.value = "somnething"
        expect(@entry.custom_attributes[0]).to be_valid
        expect(@entry.custom_attributes[0].value).to be_false
      end
    end

    context "required" do
      it "is valid with true value" do  
        @custom_field.update_attribute(:required,true)
        @entry.custom_attributes_populate
        @entry.custom_attributes[0].custom_value.value=true
        expect(@entry.custom_attributes[0]).to be_valid
      end

      it "empty is not valid" do  
        @custom_field.update_attribute(:required,true)
        @entry.custom_attributes_populate
        expect(@entry.custom_attributes[0]).not_to be_valid
      end

      it "not valid with a false value" do  
        @custom_field.update_attribute(:required,true)
        @entry.custom_attributes_populate
        @entry.custom_attributes[0].custom_value.value=false
        expect(@entry.custom_attributes[0]).not_to be_valid
      end

      it "not valid with a random string value" do  
        @custom_field.update_attribute(:required,true)
        @entry.custom_attributes_populate
        @entry.custom_attributes[0].custom_value.value="randomstring"
        expect(@entry.custom_attributes[0]).not_to be_valid
      end
    end
  end
end