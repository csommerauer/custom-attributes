require 'spec_helper'

describe "CustomAttributes::Textfield" do 
  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) {AttributeHolder.first}

  before :each do
      @custom_field = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
    end

  context "instance creation" do

    it "should be valid with a valid has_one association that represents a textfield" do
      expect(
        attr_holder.custom_attributes.build(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"textfield"})
        ).to be_valid

      #expect {entry.custom_value(true) }.to_not eq nil
      #entry.custom_value(true).id.should_not == nil
    end

    it "is not valid with if the value is empty" do
      expect(attr_holder.custom_attributes.build(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>""})).not_to be_valid
    end


  end 

  context "instance deletion" do
    it "should be delete if entry is deleted" do
      entry = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"textfield"})
      expect {entry.destroy}.to change(CustomAttributes::Textfield, :count).from(1).to(0)
    end
  end 
end