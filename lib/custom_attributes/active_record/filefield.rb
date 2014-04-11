module CustomAttributes 
  class Filefield < ActiveRecord::Base
    include Paperclip::Glue
    self.table_name="custom_attribute_filefields"

    enable_custom_attribute_custom_value_base

    attr_accessible :attachment

    has_attached_file :attachment

    #validates :value, :presence =>true, :if => "entry.present? && entry.required"
    validates_attachment_presence :attachment, :if => :entry_present_and_required?
    do_not_validate_attachment_file_type :attachment
    
    before_validation :create_token, :on => :create

    private 
    def entry_present_and_required?
      entry.present? && entry.required
    end

    def create_token
      self.token = SecureRandom.hex(16)
    end
  end
end