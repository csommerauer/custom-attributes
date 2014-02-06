class CreateCustomAttributesFieldsTable < ActiveRecord::Migration
   
   def self.up
		create_table :custom_attribute_fields do |t|
	  	t.string :name
	  	t.string :field_type
	  	t.boolean :required, :default => false
	  	t.string :error_message
	  	t.integer :position
	  	t.integer :custom_configurable_id
	  	t.string :custom_configurable_type
	  	t.timestamps
  	end

    add_index :custom_attribute_fields, [:custom_configurable_id, :custom_configurable_type], :name => :custom_attribute_fields_custom_configurable
  end

  def self.down
    drop_table :custom_attribute_fields
  end
end