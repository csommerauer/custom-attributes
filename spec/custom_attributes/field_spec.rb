require 'spec_helper'

describe "CustomAttributes::Field" do 
	let(:config_holder) {ConfigHolder.first}

	context "instance creation" do
		it "is valid with :name, :field_type and created through the belongs_to associaton" do
			config_holder.custom_attribute_fields.create(:field_type=>"textarea",:name=>"whatever").should be_valid
		end

		it "is not valid without :name" do
			config_holder.custom_attribute_fields.create(:field_type=>"textarea").should_not be_valid
		end

		it "is not valid without :field_type" do
			config_holder.custom_attribute_fields.create(:name=>"whatever").should_not be_valid
		end

		it "is not valid without belongs_to association" do
			CustomAttributes::Field.create(:field_type=>"textarea", :name=>"whatever").should_not be_valid
		end
	end		
end