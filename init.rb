# Include hook code here
ActiveSupport.on_load(:active_record) { include ArchivalRecordCore::ArchivalRecordActiveRecordMethods }
ActiveSupport.on_load(:active_record) { include ArchivalRecordCore::ArchivalRecord }
