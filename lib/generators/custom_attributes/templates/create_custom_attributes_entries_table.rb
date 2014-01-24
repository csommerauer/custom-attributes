class CreateCustomAttributesEntriesTable < ActiveRecord::Migration

  def self.up
		create_table :custom_attribute_entries do |t|
			t.integer :custom_attributable_id
			t.string :custom_attributable_type
			t.integer :custom_value_id
			t.string :custom_value_type
			t.integer :custom_attribute_field_id
			t.timestamps
		end

    add_index :custom_attribute_entries, [:custom_attributable_id,:custom_attributable_type], :name=>:custom_attribute_entries_custom_attributable
    add_index :custom_attribute_entries, [:custom_value_id,:custom_value_type], :name=>:custom_attribute_entries_custom_value
    add_index :custom_attribute_entries, :custom_attribute_field_id
  end

  def self.down
    drop_table :custom_attribute_entries
  end
end