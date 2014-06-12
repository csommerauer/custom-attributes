class CreateCustomAttributesCheckboxesTable < ActiveRecord::Migration

  def self.up
    create_table :custom_attribute_checkboxes do |t|
        t.boolean :value
        t.timestamps
     end
  end

  def self.down
    drop_table :custom_attribute_checkboxes
  end
end