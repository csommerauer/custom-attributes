require 'spec_helper'
require 'rails'

describe "CustomAttributes::Filefield" do 


	let(:config_holder) { ConfigHolder.first}
	let(:attr_holder) {AttributeHolder.first}

	before :each do
			Paperclip::Attachment.default_options[:path] = PAPERCLIP_PATH
			@custom_field = config_holder.custom_attribute_fields.create!(:name=>"file", :field_type=>"filefield")
			@file = File.new("#{RSPEC_ROOT}/fixtures/files/car.jpg")
		end

	context "instance creation" do

		it "should be valid with a valid has_one association that represents a filefield" do
			expect { 
				attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:attachment=>@file}) 
				}.to change CustomAttributes::Filefield, :count
		end

	end	

	context "instance deletion" do
		it "should be delete if entry is deleted" do

			entry = attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:attachment=>@file})
			expect {entry.destroy}.to change CustomAttributes::Filefield, :count
		end
	end	
end