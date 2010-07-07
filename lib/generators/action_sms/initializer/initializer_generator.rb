require 'rails/generators'
module ActionSms
  class InitializerGenerator < Rails::Generators::Base

    def self.source_root
       @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_conversation_file
      copy_file "action_sms.rb", "config/initializers/action_sms.rb"
    end
  end
end

