module ActionSms
  module ConnectionAdapters
    module TestHelpers
      module Tropo

        def sample_configuration(options = {})
          config = {
            :adapter => "tropo",
            :outgoing_token => "Tropo Outgoing Token"
          }
          config.merge!(
            :authentication_key => "My Unique Authentication Key"
          ) if options[:authentication_key]
          config
        end

        def sample_delivery_response(options = {})
          options[:failed] ? "success=false&token=abcde3214&reason=Invalid+token" : "success=true&token=abcde3214&id=9865abcde"
        end

        def sample_incoming_sms(options = {})
          options[:message] ||= "Endia kasdf ofeao"
          options[:to]      ||= "61447100308"
          options[:from]    ||= "61447100399"
          options[:date]    ||= "Mon Oct 11 09:21:38 UTC 2010"
          params = {
            "session" => {
              "id"=>"12349516546e59746d6a89a990466789",
              "account_id"=>"12345",
              "timestamp"=> options[:date],
              "user_type"=>"HUMAN",
              "initial_text"=> options[:message],
              "call_id"=>"123e71195545ad204bdd99f2070a7d86",
              "to"=>{
                "id"=> options[:to],
                "name"=>"unknown",
                "channel"=>"TEXT",
                "network"=>"SMS"
              },
              "from" => {
                "id"=> options[:from],
                "name"=>"unknown",
                "channel"=>"TEXT",
                "network"=>"SMS"
              },
              "headers" => {
                "_max-_forwards"=>"70",
                "_content-_length"=>"124",
                "_contact"=>"<sip:11.8.93.101:5066;transport=udp>",
                "_to"=>"<sip:1231454582@10.6.69.203:5061;to=#{options[:to]}>",
                "_c_seq"=>"1 INVITE",
                "_via"=>"SIP/2.0/UDP 11.8.93.101:5066;branch=h0hG4bKk5sy1e",
                "_call-_i_d"=>"ieeg18",
                "_content-_type"=>"application/sdp",

          "_from"=>"<sip:15EB6BAB-99DF-44C2-871DFBA75C319776@11.8.93.201;channel=private;user=#{options[:to]};msg=#{options[:message]};network=SMS;step=1>;tag=zm13kt"
              }
            }
          }
          params.merge!("authentication_key" => @config[:authentication_key]) unless options[:authentic] == false
          params
        end
      end
    end
  end
end

