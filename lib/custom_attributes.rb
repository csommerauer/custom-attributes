require "custom_attributes/version"
require 'active_record'

module CustomAttributes
  module ClassMethods
  	def enable_custom_attribute_fields
      has_many :custom_attribute_fields, :class_name=> CustomAttributes::Field, :as => :custom_configurable, :dependent=>:destroy
      include CustomAttributes::ConfigHolderInstanceMethods
    end

    def enable_custom_attributes(options={})
        
    	has_many :custom_attributes, 
        :class_name=> CustomAttributes::Entry, 
        :as => :custom_attributable, 
        :dependent => :destroy
      accepts_nested_attributes_for :custom_attributes

      class_eval do 
        def self.add_custom_attribute_fields(options)
          define_method :custom_attribute_fields do
            self.send(options[:config_holder]).custom_attribute_fields
          end
        end
      end

      add_custom_attribute_fields(options)

      include CustomAttributes::AttributeHolderInstanceMethods
    end

  end
 
  
  module ConfigHolderInstanceMethods
  	def has_custom_attribute_fields?
  		!self.custom_attribute_fields.empty?
  	end
  end

  
  module AttributeHolderInstanceMethods
    def self.included(base)

    end
  end
 
  
  def self.included(base)
    base.send :extend, ClassMethods
  end
end

class ActiveRecord::Base
  include CustomAttributes
end


require "custom_attributes/field"
require "custom_attributes/entry"
require "custom_attributes/textfield"