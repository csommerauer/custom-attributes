class AddTokenToCustomAttributesFilefield < ActiveRecord::Migration
  def change
    add_column :custom_attribute_filefields, :token, :string
  end
end