class AddUniqueIndexToCustomAttributesEntries < ActiveRecord::Migration
  def self.up
    add_index :custom_attribute_entries,
      [:custom_attribute_field_id, :custom_attributable_id, :custom_attributable_type], 
      :name=>:custom_attribute_entries_unique_custom_attribute_field_id,
      :unique => true
  end

  def self.down
    remove_index :custom_attribute_entries, 
      :name => :custom_attribute_entries_unique_custom_attribute_field_id
  end
end