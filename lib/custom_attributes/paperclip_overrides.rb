Paperclip.interpolates :token do |attachment, style|
  attachment.instance.token
end

Paperclip::Attachment.default_options[:url] = "/:attachment/:id_partition/:token:style.:extension"