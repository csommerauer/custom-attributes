class CreateCustomAttributesTextareasTable < ActiveRecord::Migration

  def self.up
    create_table :custom_attribute_textareas do |t|
        t.text :value
        t.timestamps
     end
  end

  def self.down
    drop_table :custom_attribute_textareas
  end
end