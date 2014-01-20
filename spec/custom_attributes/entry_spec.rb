require 'spec_helper'

describe "CustomAttributes::Entry" do 
	let(:config_holder) { ConfigHolder.first}
	let(:attr_holder) {AttributeHolder.first}

	context "instance creation" do
		before :each do
			@custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"text_field")
		end

		it "is valid when created through the belongs_to associaton and it references the custom_attribute_fields" do
			attr_holder.custom_attributes.create(:custom_attribute_field_id=>attr_holder.custom_attribute_fields.first.id).should be_valid
		end

		it "is not valid without custom_attribute_field_id" do
			attr_holder.custom_attributes.create.should_not be_valid
		end

		it "is not valid without belongs_to association" do 
			CustomAttributes::Entry.create(:custom_attribute_field_id=>attr_holder.custom_attribute_fields.first.id).should_not be_valid
		end
	end		
end