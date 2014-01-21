module CustomAttributes
	
	class Field < ActiveRecord::Base
	  self.table_name="custom_attribute_fields"
	  belongs_to :custom_configurable, :polymorphic => true

	  validates :custom_configurable_type, 
	  	:custom_configurable_id, 
	  	:name,
	  	:field_type,
	  	:presence =>true

	  attr_accessible :name, :field_type, :position, :mandatory, :error_message  
	
	end

end