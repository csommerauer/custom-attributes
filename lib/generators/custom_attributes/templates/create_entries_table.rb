class CreateEntriesTable < ActiveRecord::Migration

  def self.up
		create_table :custom_attribute_entries do |t|
			t.integer :custom_attributable_id
			t.string :custom_attributable_type
			t.integer :custom_value_id
			t.string :custom_value_type
			t.integer :custom_attribute_field_id
			t.timestamps
		end
  end

  def self.down
    drop_table :custom_attribute_entries
  end
end