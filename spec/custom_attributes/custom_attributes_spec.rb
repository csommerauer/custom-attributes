require 'spec_helper'

describe "CustomAttributes" do
 
  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) { AttributeHolder.first }

  context "Configuration Holder" do
	  context "Class method #enable_custom_attribute_fields" do
	    it "is added to active record class" do
	      ConfigHolder.public_methods.should include :enable_custom_attribute_fields
	    end

	     it "adds a has_many custom_attributes_fields relation ship" do
	      config_holder.custom_attribute_fields.should == []
	    end
	  end

	  context "#has_custom_attribute_fields?" do
	  	it "is false is no custom_attribute_fields are defined" do
	  	  config_holder.has_custom_attribute_fields?.should eq false
	  	end

	  	it "is true if more than 1 custom_attribute_fields are defined" do
	  		config_holder.custom_attribute_fields.create(:name=>"something", :field_type => "textarea")
	  	  config_holder.has_custom_attribute_fields?.should eq true
	  	end
	  end
	end


	context "Attribute Holder" do
	  context "Class method #enable_custom_attributes" do
	    it "is added to active record class" do
	      AttributeHolder.public_methods.should include :enable_custom_attributes
	    end

	    it "adds a has_many custom_attributes relation ship" do
	      attr_holder.custom_attributes.should == []
	    end

	    it "should add a has_many custom_attribute_fields relationship" do
	    	attr_holder.custom_attribute_fields.should == []
	    end
	  end

		context "custom_attribute_fields relationship" do
		 	it "a custom_attribute_field of attr_holder is the same as from config_holder" do
		 		custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"text_field")
		 		attr_holder.custom_attribute_fields.first.should eq custom_attribute
		 	end
	  end

	  context "saving entries using nested attributes" do
	  	it "works when updating a field" do
	  		custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"text_field")
	  		attr_holder.update_attributes(:custom_attributes_attributes => [
	  			{:custom_attribute_field_id=>attr_holder.custom_attribute_fields.first.id}])

	  		attr_holder.reload.custom_attributes.count.should == 1
	  	end
	  end
	end


end
