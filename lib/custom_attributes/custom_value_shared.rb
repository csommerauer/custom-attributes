module CustomAttributes
  module CustomValueShared
    module ClassMethods
      ::ActiveRecord::Base.has_one :entry, :class_name=>::CustomAttributes::Entry, :as => :custom_value
      ::ActiveRecord::Base.validates :entry, :associated=>true, :presence=> true      
      ::ActiveRecord::Base.attr_accessible :value
    end
  end
end