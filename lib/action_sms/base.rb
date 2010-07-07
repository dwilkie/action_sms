module ActionSms #:nodoc#
  class Base
    @@logger = nil
    cattr_accessor :logger

    def self.deliver(sms)
      self.connection.deliver(sms)
    end
  end
end

