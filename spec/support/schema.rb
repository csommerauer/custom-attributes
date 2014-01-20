ActiveRecord::Schema.define do
  self.verbose = false

  create_table :config_holders, :force => true do |t|
    t.string :text
    t.timestamps
  end

  create_table :attribute_holders, :force => true do |t|
  	t.integer :config_holder_id
    t.string :text
    t.timestamps
  end

  create_table :custom_attribute_fields, :force=>true do |t|
  	t.string :name
  	t.string :field_type
  	t.boolean :mandatory, :default => false
  	t.string :error_message
  	t.integer :position
  	t.integer :custom_configurable_id
  	t.string :custom_configurable_type
  	t.timestamps
  end

  create_table :custom_attribute_entries, :force=>true do |t|
  	t.integer :custom_attributable_id
  	t.string :custom_attributable_type
    t.string :value
    t.integer :custom_attribute_field_id
  	t.timestamps
  end
end
