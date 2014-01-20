module CustomAttributes
	
	class Entry < ActiveRecord::Base
	  self.table_name="custom_attribute_entries"
	  belongs_to :custom_attributable, :polymorphic => true
	  belongs_to :custom_attribute_field, :class_name => CustomAttributes::Field

	  validates :custom_attribute_field_id,
	  	:custom_attributable_id, :custom_attributable_type, :presence => true
	end
end