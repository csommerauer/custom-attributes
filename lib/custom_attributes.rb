require "custom_attributes/version"
require 'active_record'

module CustomAttributes
  module ClassMethods
  	def enable_custom_attribute_fields
      has_many :custom_attribute_fields, :class_name=> CustomAttributes::Field, :as => :custom_configurable
      include CustomAttributes::ConfigHolderInstanceMethods
    end

    def enable_custom_attributes(options={})
    	has_many :custom_attribute_fields, :through => options[:config_holder]
    	has_many :custom_attributes, :class_name=> CustomAttributes::Entry, :as => :custom_attributable
      accepts_nested_attributes_for :custom_attributes
      #include CustomAttributes::AttributeHolderInstanceMethods
    end
  end
 
  module ConfigHolderInstanceMethods
  	def has_custom_attribute_fields?
  		!self.custom_attribute_fields.empty?
  	end
  end

  module AttributeHolderInstanceMethods
    def self.included(included_class)
      included_class.instance_eval do
          # from here to the end of this block, imagine that you are in the class
          # source itself. Add associations or instance methods, for example
      end
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