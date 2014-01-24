class CreateCustomAttributesDatefieldsTable < ActiveRecord::Migration

  def self.up
  	create_table :custom_attribute_datefields do |t|
  	    t.date :value
  	    t.timestamps
  	 end
  end

  def self.down
    drop_table :custom_attribute_datefields
  end
end