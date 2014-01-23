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
	end

	context "instance deletion" do
		it "is deleted if the attr_holder is deleted" do
			attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
			CustomAttributes::Entry.count.should eq 1
			attr_holder.destroy
			CustomAttributes::Entry.count.should eq 0
		end

		it "is deleted if if the custom_attribute_field is deleted" do
			attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
			CustomAttributes::Entry.count.should eq 1
			@custom_attribute.destroy
			CustomAttributes::Entry.count.should eq 0
		end
	end

	context "methods" do
		it "#custom_attribute_fields method that returns the available fields" do
			entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
			entry.custom_attribute_fields.first.should eq  @custom_attribute
		end	

		it "#name returns the custom_attribute_field name" do
			entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
			entry.name.should == @custom_attribute.name
		end

		it "#field_type returns the custom_attribute_field field_type" do
			entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
			entry.field_type.should == @custom_attribute.field_type
		end

		it "#value returns the custom_value value" do
			entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id,
				:custom_value_type=>"CustomAttributes::Textfield", 
				:custom_value_attributes=>{:value=>"something meaningful"})
			entry.value.should == "something meaningful"
		end		

	end		
end