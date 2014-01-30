class AddAttachmentColumnsToCustomAttributesFilefields < ActiveRecord::Migration
  def self.up
    add_attachment :custom_attribute_filefields, :attachment
  end

  def self.down
    remove_attachment :custom_attribute_filefields, :attachment
  end
end