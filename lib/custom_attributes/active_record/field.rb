module CustomAttributes
  
  class Field < ActiveRecord::Base
    self.table_name="custom_attribute_fields"

    default_scope -> { order("position ASC") }

    belongs_to :custom_configurable, :polymorphic => true
    has_many :custom_attribute_entries, :class_name => "CustomAttributes::Entry", :foreign_key=> :custom_attribute_field_id, :dependent=> :destroy

    validates :custom_configurable_type, :custom_configurable_id, :field_type,
      :presence =>true

    validates :name, :format => /\A[0-9a-z_]+\z/, :presence => true

    validates_inclusion_of :field_type,  :in => CustomAttributes::Mapper::Configuration.available_fields

    attr_accessible :name, :field_type, :position, :error_message, :required  
  end

end