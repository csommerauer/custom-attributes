require 'spec_helper'

describe "CustomAttributes::Datefield" do 
  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) {AttributeHolder.first}

  before :each do
    @custom_field = config_holder.custom_attribute_fields.create!(:name=>"a_date", :field_type=>"datefield")
  end

  context "instance creation" do

    it "should be valid with a valid has_one association that represents a textfield" do
      entry = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"22/12/2013"})
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
      # a invalid date string is set to 0 therefore use anything else than a string or a valid date
      CustomAttributes::Datefield.count.should eql 0
      ca = attr_holder.custom_attributes.build(:custom_attribute_field_id=>@custom_field.id,:custom_value_attributes=>{:value=>''})
      ca.custom_value.value=1
      expect {
        ca.save!
      }.to raise_error
    end
  end

  context "instance deletion" do
    it "should be delete if entry is deleted" do
      entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:value=>"22/12/2013"})
      expect {entry.destroy}.to change CustomAttributes::Datefield, :count
    end
  end

  context "validation" do
    before :each do
      @entry = attr_holder
    end

    it "empty is valid if not required" do  
      @entry.custom_attributes_populate
      expect(@entry.custom_attributes[0]).to be_valid
    end

    it "empty is not valid if required" do  
      @custom_field.update_attribute(:required,true)
      @entry.custom_attributes_populate
      expect(@entry.custom_attributes[0]).not_to be_valid
    end

    it "valid with a value if required" do  
      @custom_field.update_attribute(:required,true)
      @entry.custom_attributes_populate
      @entry.custom_attributes[0].custom_value.value= Date.today
      expect(@entry.custom_attributes[0]).to be_valid
    end
  end
 end