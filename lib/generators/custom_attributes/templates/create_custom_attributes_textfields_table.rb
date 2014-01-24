class CreateCustomAttributesTextfieldsTable < ActiveRecord::Migration

  def self.up
  	create_table :custom_attribute_textfields do |t|
  	    t.string :value
  	    t.timestamps
  	 end
  end

  def self.down
    drop_table :custom_attribute_textfields
  end
end