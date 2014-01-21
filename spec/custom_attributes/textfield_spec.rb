require 'spec_helper'

describe "CustomAttributes::Textfield" do 
	let(:config_holder) { ConfigHolder.first}
	let(:attr_holder) {AttributeHolder.first}

	context "instance creation" do
		
		it "should be valid with a valid has_one association that represents a textfield" do
			custom_field = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
			entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>custom_field.id,:custom_value_type=>"CustomAttributes::Textfield", :custom_value_attributes=>{:value=>"textfield"})
			expect {entry.custom_value(true) }.to_not eq nil
			entry.custom_value(true).id.should_not == nil
		end

		it "should not be valid with a valid has_one association that represents something else than a textfield" do
			custom_field = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textarea")
			expect { attr_holder.custom_attributes.create(
				:custom_attribute_field_id=>custom_field.id,
				:custom_value_type=>"CustomAttributes::Textfield", 
				:custom_value_attributes=>{:value=>"textfield"})}.to raise_error ArgumentError
		end
	end	

	context "instance deletion" do
		it "should be delete if entry is deleted" do
			custom_field = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
			entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>custom_field.id,:custom_value_type=>"CustomAttributes::Textfield", :custom_value_attributes=>{:value=>"textfield"})
			CustomAttributes::Textfield.count.should eq 1
			entry.destroy
			CustomAttributes::Textfield.count.should eq 0

		end
	end	
end