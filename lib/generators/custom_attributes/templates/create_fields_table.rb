class CreateFieldsTable < ActiveRecord::Migration
   
   def self.up
		create_table :custom_attribute_fields do |t|
	  	t.string :name
	  	t.string :field_type
	  	t.boolean :mandatory, :default => false
	  	t.string :error_message
	  	t.integer :position
	  	t.integer :custom_configurable_id
	  	t.string :custom_configurable_type
	  	t.timestamps
  	end
  end

  def self.down
    drop_table :custom_attribute_fields
  end
end