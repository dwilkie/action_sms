module ActionSms
  class InitializerGenerator < Rails::Generators::Base

    def self.source_root
       @source_root ||= File.join(File.dirname(__FILE__), 'templates')
    end

    def copy_initializer
      template "action_sms.rb", "config/initializers/action_sms.rb"
    end

    private

    def built_in_adapter_configurations
      output = ""
      adapters = ActionSms::Base.adapters(
        :sample_configuration, :environment => "test"
      )
      adapters.each do |adapter|
        config = adapter.sample_configuration
        output << "## " << config[:adapter].titleize << "\n\n" <<
        "# ActionSms::Base.establish_connection(" << "\n" <<
          pretty_print_adapter_configuration(config) << "\n" <<
        "# )"
        output << "\n\n" unless adapters.last == adapter
      end
      output
    end

    def pretty_print_adapter_configuration(config)
      output = ""
      config.each do |key, value|
        output << "#   " << ":#{key}" << " => " << "\"#{value}\""
        output << ",\n" unless config.keys.last == key
      end
      output
    end
  end
end

