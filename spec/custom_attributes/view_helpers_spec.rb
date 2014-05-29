require 'action_view'
require 'action_view/helpers'
require 'active_support'
require 'custom_attributes/action_view/view_helpers'
require 'spec_helper'
require 'paperclip'

describe 'CustomAttributes::ViewHelpers' do
  include ActionView::Helpers
  include ActionView::Helpers::UrlHelper
  include CustomAttributes::ViewHelpers
  include ERB::Util

  let(:config_holder) { ConfigHolder.first}
  let(:attr_holder) {AttributeHolder.first}

  describe "textfield" do
    before :each do
      @custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textfield")
      @textfield = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id, :custom_value_attributes=>{:value=>"textfield"})
    end
      
    it "#custom_attribute_html simply returns value" do
      custom_attribute_html(@textfield).should eql @textfield.value
    end
  end

  describe "textarea" do
    before :each do
      @custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"textarea")
      @textarea = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id, 
        :custom_value_attributes=>{:value=>"some text\nwith newline"})
    end
      
    it "#custom_attribute_html returns html_safe string" do
      custom_attribute_html(@textarea).html_safe?.should be_true
    end

    it "#custom_attribute_html replaces CR with </br> " do
      custom_attribute_html(@textarea).should eql "some text<br/>with newline"
    end

    it "#custom_attribute_html returns nil if value is empty" do
      @textarea.custom_value.value = nil
      custom_attribute_html(@textarea).should eql ""
    end    
  end

  describe "datefield" do
    before :each do
      @custom_attribute = config_holder.custom_attribute_fields.create!(:name=>"testfield", :field_type=>"datefield")
      @datefield = attr_holder.custom_attributes.create(:custom_attribute_field_id=>@custom_attribute.id, 
        :custom_value_attributes=>{:value=>Date.today})
    end
      
    it "#custom_attribute_html returns date in dd/mm/YY" do
      custom_attribute_html(@datefield).should eql Date.today.strftime("%d/%m/%Y")
    end

    it "#custom_attribute_html returns nil if value is empty" do
      @datefield.custom_value.value = nil
      custom_attribute_html(@datefield).should eql ""
    end    
  end

  describe "filefield" do
    before :each do
      Paperclip::Attachment.default_options[:path] = PAPERCLIP_PATH
      @custom_field = config_holder.custom_attribute_fields.create!(:name=>"file", :field_type=>"filefield")
      @file = File.new("#{RSPEC_ROOT}/fixtures/files/car.jpg")
      @filefield =attr_holder.custom_attributes.create!(:custom_attribute_field_id=>@custom_field.id, :custom_value_attributes=>{:attachment=>@file})
    end

    after :each do
      CustomAttributes::Filefield.destroy_all
    end
      
    it "#custom_attribute_html returns a link" do
      custom_attribute_html(@filefield).should eql %Q{<a href="#{@filefield.value.url}">Link to Document</a>}
    end

    it "#custom_attribute_html returns nil if value is empty" do
      @filefield.custom_value.attachment = nil
      custom_attribute_html(@filefield).should eql ""
    end    
  end 



end

