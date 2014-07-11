require 'spec_helper'

describe "CustomAttributes" do

  let(:config_holder) { ConfigHolder.first }
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
        config_holder.custom_attribute_fields.create(:name=>"something", :field_type => "textfield")
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
        custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
        attr_holder.custom_attribute_fields.first.should eq custom_attribute
      end
    end

    context "#custom_attributes_hash" do
      before :each do
        @custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
      end
      
      it "exists" do
        expect(attr_holder).to respond_to :custom_attributes_hash
      end

      it "returns empty hash if no custom attributes been added" do
        attr_holder.custom_attributes_hash.should == {}
      end

      it "creates the instance_variable @ca_hash when called" do
        ah = attr_holder
        ah.instance_variable_defined?(:@ca_hash).should be_false
        ah.custom_attributes_hash
        ah.instance_variable_get(:@ca_hash).should == {}
      end

      it "returns empty hash if no custom attributes been added" do
        attr_holder.custom_attributes_hash.should == {}
      end

      it "returns hash with the custom attributes as entry and the name as the key" do
        entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
        attr_holder.custom_attributes_hash.has_key?(@custom_attribute.name).should be_true
        attr_holder.custom_attributes_hash[@custom_attribute.name].should equal entry
      end


    end

    context "saving entries using nested attributes" do
      before :each do
        @custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
      end
      it "works when updating a field" do
        attr_holder.update_attributes(:custom_attributes_attributes => [
          {:custom_attribute_field_id=>attr_holder.custom_attribute_fields.first.id}])

        attr_holder.reload.custom_attributes.count.should == 1
      end

      context "#custom_attributes_configured?" do
        it "returns false if config_holder has no custom_attribute_fields defined" do       
          config_holder.custom_attribute_fields.first.destroy
          attr_holder.custom_attributes_configured?.should be_false
        end

        it "returns true if config_holder custom_attribute_fields defined" do
          attr_holder.custom_attributes_configured?.should be_true
        end
      end

      context "#custom_attributes_populate" do
        it "returns an empty array when no custom_attribute_fields are defined" do
          config_holder.custom_attribute_fields.first.destroy
          attr_holder.custom_attributes_populate.should eql []
        end

        context "if custom_attribute_fields are defined" do
          it "returns an array with new custom_attributes when attr_holder has no custom_attributes" do
            attr_holder.custom_attributes.length.should eql 0
            attr_holder.custom_attributes_populate.length.should eql 1
            attr_holder.custom_attributes.first.new_record?.should be_true
          end 

          it "returns existing custom_attributes" do
            entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
            cs = attr_holder.custom_attributes_populate
            cs.length.should eq 1
            cs.first.should eql entry
            cs.first.new_record?.should be_false
          end

          it "returns existing custom_attributes and creates new associations if not " do   
            entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
            config_holder.custom_attribute_fields.create!(:name=>"testfield2", :field_type=>"textfield")
            cs = attr_holder.custom_attributes_populate
            cs.length.should eq 2
            cs.first.should eql entry
            cs.first.new_record?.should be_false
            cs.last.new_record?.should be_true
          end

          it "new custom_attributes also have the custom_value set to a new instance" do
            cs = attr_holder.custom_attributes_populate
            cs.first.custom_value.class.to_s.should == "CustomAttributes::Textfield"
            cs.first.custom_value.new_record?.should be_true
          end 

          it "existing custom_attributes also have the custom_value set to a new instance if not yet set" do
            entry = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id)
            cs = attr_holder.custom_attributes_populate
            cs.first.custom_value.class.to_s.should == "CustomAttributes::Textfield"
            cs.first.custom_value.new_record?.should be_true
          end

          it "existing custom_attributes also have the custom_value set if " do
            entry = attr_holder.custom_attributes.create!(
              :custom_attribute_field_id=>@custom_attribute.id,
              :custom_value_attributes=>{:value=>"something meaningful"})
            cs = attr_holder.custom_attributes_populate
            cs.first.custom_value.class.to_s.should == "CustomAttributes::Textfield"
            cs.first.custom_value.new_record?.should be_false
          end
        end
      end  
    end
  end

end
