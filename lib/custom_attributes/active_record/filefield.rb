module CustomAttributes 
  class Filefield < ActiveRecord::Base
    include Paperclip::Glue
    self.table_name="custom_attribute_filefields"

    enable_custom_attribute_custom_value_base
    
    attr_accessible :attachment
    has_attached_file :attachment

    #validates :value, :presence =>true, :if => "entry.present? && entry.required"
    validates_attachment_presence :attachment, :if => :entry_present_and_required?

    private 
    def entry_present_and_required?
      entry.present? && entry.required
    end
  end
end