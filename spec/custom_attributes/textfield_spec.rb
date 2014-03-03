require 'spec_helper'

describe "CustomAttributes::Textfield" do 
  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) {AttributeHolder.first}

  before :each do
      @custom_field = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
    end

  context "instance creation" do

    it "should be valid with a valid has_one association that represents a textfield" do
      expect{ 
        attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"textfield"})
        }.to change(CustomAttributes::Textfield, :count).from(0).to(1)

    end

    it "is not valid with if the value is empty and the field is required" do
      @custom_field = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield", :required=> true)
      expect { 
        attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>""})
      }.not_to change(CustomAttributes::Textfield, :count)
    end


  end 

  context "instance deletion" do
    it "should be delete if entry is deleted" do
      entry = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"textfield"})
      expect { 
        entry.destroy }.to change(CustomAttributes::Textfield, :count).from(1).to(0)
    end
  end 
end