require 'rails/generators'
module ActionSms
  class NotifierGenerator < Rails::Generators::Base

    def self.source_root
       @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_notifier_file
      copy_file "sms_notifier.rb", "app/notifiers/sms_notifier.rb"
    end
  end
end

