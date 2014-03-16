module CustomAttributes
  
  class Entry < ActiveRecord::Base
    self.table_name="custom_attribute_entries"

    belongs_to :custom_attributable, :polymorphic => true
    delegate :custom_attribute_fields, :to=> :custom_attributable, :prefix=>false

    belongs_to :custom_attribute_field, :class_name => "CustomAttributes::Field"
    delegate :name, :field_type, :required, :to => :custom_attribute_field, :prefix => false

    belongs_to :custom_value, :polymorphic => true, :dependent => :destroy
    #delegate :value, :to=> :custom_value, :prefix => false
    
    accepts_nested_attributes_for :custom_value, :update_only =>true
    default_scope includes(:custom_value)

    # VALIDATIONS
    validates :custom_attribute_field_id, :custom_attributable, :presence=>:true

    #  :custom_attributable_id, :custom_attributable_type, :presence => true

    validates_inclusion_of :custom_attribute_field_id, 
      :in => ->(entry) { entry.custom_attribute_fields.map(&:id) },
      :unless => ->(entry) { !entry.custom_attributable.present? }

    validates_uniqueness_of :custom_attribute_field_id, :scope=>[:custom_attributable_id,:custom_attributable_type]
    # VALIDATIONS

    attr_accessible :custom_attribute_field_id, :custom_value_attributes

    def explicitly_build_custom_value
      if self.custom_value
        self.custom_value.entry = self
        self.custom_value
      else
        build_custom_value({},{})
      end
    end

    def value
      if field_type == "filefield"
        custom_value.attachment
      else
        custom_value.value
      end
    end

    protected

    def build_custom_value(params, assignment_options)
      self.custom_value = return_custom_value_type.constantize.new(params)
      self.custom_value.entry = self
      self.custom_value
    end

    private

    def return_custom_value_type
      CustomAttributes::Mapper::Configuration.custom_value_type(self.field_type)
    end

  end
end

