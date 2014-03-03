module CustomAttributes
  module ClassMethods
    def enable_custom_attribute_fields
      has_many :custom_attribute_fields, :class_name=> CustomAttributes::Field, :as => :custom_configurable, :dependent=>:destroy
      include CustomAttributes::ConfigHolderInstanceMethods
    end

    def enable_custom_attribute_custom_value      
      attr_accessible :value

      after_validation :handle_entry_errors, :on => :create

      validates :value, :presence =>true, :if => "entry.present? && entry.required"
      
      enable_custom_attribute_custom_value_base

      include CustomAttributes::CustomValueInstanceMethods
    end

    def enable_custom_attribute_custom_value_base
      has_one :entry, :class_name=>::CustomAttributes::Entry, :as => :custom_value
      validates :entry, :associated=>true, :presence=> true, :on => :create
    end


    def enable_custom_attributes(options={})
        
      has_many :custom_attributes, 
        :class_name=> CustomAttributes::Entry, 
        :as => :custom_attributable, 
        :dependent => :destroy

      accepts_nested_attributes_for :custom_attributes, :allow_destroy=> true
      attr_accessible :custom_attributes_attributes

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
  

  module CustomValueInstanceMethods
    def handle_entry_errors
      if entry && !entry.valid_attribute?(:custom_attribute_field_id)
        errors.add(:value, "the entry is not valid")
      end
    end
  end  

  module ConfigHolderInstanceMethods
    def has_custom_attribute_fields?
      !self.custom_attribute_fields.reload.empty?
    end
  end
  
  module AttributeHolderInstanceMethods
    def self.included(base)
      def custom_attributes_configured?
        !self.custom_attribute_fields.reload.empty?
      end

      def custom_attributes_populate
        if custom_attributes_configured?
          existing_custom_attribute_fields = custom_attributes.map{| ca | ca.custom_attribute_field_id}
          custom_attribute_fields.each do |field|
            if existing_custom_attribute_fields.include?(field.id)
              custom_attributes[existing_custom_attribute_fields.index(field.id)].explicitly_build_custom_value
            else
              build_new_custom_attribute(field.id)
            end
          end 
        end
        
        return custom_attributes
      end

      def custom_attribute_or_build(field)
        custom_attribute = custom_attributes.find_by_custom_attribute_field_id(field.id) || custom_attributes.build(:custom_attribute_field_id=>field.id)
        custom_attribute.explicitly_build_custom_value
        custom_attribute 
      end

      def build_new_custom_attribute(field_id)
        custom_attribute = custom_attributes.build(:custom_attribute_field_id=>field_id)
        custom_attribute.explicitly_build_custom_value
        custom_attribute
      end
    end
  end
 
  
  def self.included(base)
    base.send :extend, ClassMethods
  end
end

class ActiveRecord::Base
  include CustomAttributes

  def valid_attribute?(attribute_name)
    self.valid?
    self.errors.messages.delete_if {|k,v| k != attribute_name }
    self.errors[attribute_name].blank?
  end
end