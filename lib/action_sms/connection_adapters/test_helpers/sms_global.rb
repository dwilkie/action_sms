module ActionSms
  module ConnectionAdapters
    module TestHelpers
      module SMSGlobal
        def sample_incoming_sms(options = {})
          options[:message] ||= "Endia kasdf ofeao"
          options[:to]      ||= "61447100308"
          options[:from]    ||= "61447100399"
          options[:date]    ||= "2010-05-13 23:59:11"
          sample = {
            "to" => options[:to],
            "from" => options[:from],
            "msg"=> options[:message],
            "date" => options[:date]
          }
          sample.merge!(
            "authentication_key" => @config[:authentication_key]
          ) if options[:authentic]
          sample
        end

        def sample_delivery_response(options = {})
          options[:failed] ||= false
          options[:message_id] ||= "6942744494999745"
          options[:failed] ? "ERROR: No action requested" : "OK: 0; Sent queued message ID: 86b1a945370734f4 #{sample_message_id(:message_id => options[:message_id])}"
        end

        def sample_message_id(options = {})
          options[:message_id] ||= "6942744494999745"
          "SMSGlobalMsgID:#{options[:message_id]}"
        end

        def sample_delivery_receipt(options = {})
          options[:message_id] ||= "6942744494999745"
          options[:message_id].gsub!("SMSGlobalMsgID:", "")
          options[:status] ||= "DELIVRD"
          options[:error] ||= "000"
          options[:date] ||= "1005132312"
          {
            "msgid"=> options[:message_id],
            "dlrstatus"=> options[:status],
            "dlr_err"=> options[:error],
            "donedate"=> options[:date]
          }
        end
      end
    end
  end
end

