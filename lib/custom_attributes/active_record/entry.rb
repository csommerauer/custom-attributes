module CustomAttributes
	
	class Entry < ActiveRecord::Base
	  self.table_name="custom_attribute_entries"

	  belongs_to :custom_attributable, :polymorphic => true
	  delegate :custom_attribute_fields, :to=> :custom_attributable, :prefix=>false

	  belongs_to :custom_attribute_field, :class_name => "CustomAttributes::Field"
	  delegate :name, :field_type, :to => :custom_attribute_field, :prefix => false

	  belongs_to :custom_value, :polymorphic => true, :dependent => :destroy
	  delegate :value, :to=> :custom_value, :prefix => false
	  accepts_nested_attributes_for :custom_value, 
      :reject_if=> proc { |attr|  attr['id'].blank? && attr['value'].blank? && attr['attachment'].blank? }
    default_scope includes(:custom_value)

	  validates :custom_attribute_field_id,
	  	:custom_attributable_id, :custom_attributable_type, :presence => true

	  validates_inclusion_of :custom_attribute_field_id, 
	  	:in => ->(entry) { entry.custom_attribute_fields.map(&:id) },
	  	:unless => ->(entry) { !entry.custom_attributable.present? }

    validates_uniqueness_of :custom_attribute_field_id, :scope=>[:custom_attributable_id,:custom_attributable_type] 

    attr_accessible :custom_attribute_field_id, :custom_value_attributes

    def explicitly_build_custom_value
      self.custom_value ||= return_custom_value_type.constantize.new()
    end

	  protected

  	def build_custom_value(params, assignment_options)
  		#raise ArgumentError, "Wrong custom_value_type for #{self.field_type}" unless validate_input
      self.custom_value = return_custom_value_type.constantize.new(params)
  	end

  	private

    def return_custom_value_type
      CustomAttributes::Mapper::Configuration.custom_value_type(self.field_type)
    end

  	#def validate_input
  	#	if self.field_type == "textfield" && self.custom_value_type == "CustomAttributes::Textfield"
  	#		true
  	#	else
  	#		false
  	#	end
  	#end
	end
end