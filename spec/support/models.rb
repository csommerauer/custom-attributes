class ConfigHolder < ActiveRecord::Base
  enable_custom_attribute_fields
end 

class AttributeHolder < ActiveRecord::Base
  belongs_to :config_holder
  attr_accessible :text, :config_holder_id
  enable_custom_attributes :config_holder => :config_holder
end 