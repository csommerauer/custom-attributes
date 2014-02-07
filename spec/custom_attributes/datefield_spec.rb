require 'spec_helper'

describe "CustomAttributes::Datefield" do 
  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) {AttributeHolder.first}

  before :each do
    @custom_field = config_holder.custom_attribute_fields.create!(:name=>"a_date", :field_type=>"datefield")
  end

  context "instance creation" do

    it "should be valid with a valid has_one association that represents a textfield" do
      entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"22/12/2013"})
      expect {entry.custom_value(true) }.to_not eq nil
      entry.custom_value(true).id.should_not == nil
    end

    it "should only allow proper dates i.e '22/12/2013' to be saved" do
      CustomAttributes::Datefield.count.should eql 0
      expect {
        attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"22/12/2013"}) 
      }.to_not raise_error
      CustomAttributes::Datefield.count.should eql 1
    end

    it "should raise error for strings not representing a date" do
      CustomAttributes::Datefield.count.should eql 0
      expect {
       attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"xxxyyy"}) 
      }.to raise_error
    end
  end

  context "instance deletion" do
    it "should be delete if entry is deleted" do
      entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"22/12/2013"})
      expect {entry.destroy}.to change CustomAttributes::Datefield, :count
    end
  end
end