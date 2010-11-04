require 'spec_helper'

describe ActionSms::ConnectionAdapters::SMSGlobalAdapter do
  let (:adapter_name) { "sms_global" }
  context "is not in test mode" do
    let(:adapter) {
      ActionSms::Base.sms_global_connection(
        :adapter => adapter_name
      )
    }
    it "should not respond to #sample_incoming_sms" do
      adapter.should_not be_respond_to(:sample_incoming_sms)
    end

    it "should not respond to #sample_delivery_response" do
      adapter.should_not be_respond_to(:sample_delivery_response)
    end

    it "should not respond to #sample_message_id" do
      adapter.should_not be_respond_to(:sample_message_id)
    end

    it "should not respond to #sample_delivery_receipt" do
      adapter.should_not be_respond_to(:sample_delivery_receipt)
    end
  end

  context "is in test mode" do
    let(:adapter) {
      ActionSms::Base.sms_global_connection(
        :adapter => adapter_name,
        :environment => "test"
      )
    }

    describe "#sample_incoming_sms" do
      context "with no options" do
        it "should return the default values" do
          adapter.sample_incoming_sms.should include(
            "msg", "to", "from", "date"
          )
        end
      end
      context "with options" do
        context "'authentic'" do
          it "should include an authentication key" do
            adapter.sample_incoming_sms(:authentic => true).should include(
              "authentication_key"
            )
          end
        end
        context "'message'" do
          it "should include the option" do
            adapter.sample_incoming_sms(:message => "hello").should include(
              "msg" => "hello"
            )
          end
        end
        context "'to'" do
          it "should include the option" do
            adapter.sample_incoming_sms(:to => "someone").should include(
              "to" => "someone"
            )
          end
        end
        context "'from'" do
          it "should include the option" do
            adapter.sample_incoming_sms(:from => "anyone").should include(
              "from" => "anyone"
            )
          end
        end
        context "'date'" do
          it "should include the option" do
            adapter.sample_incoming_sms(:date => "today").should include(
              "date" => "today"
            )
          end
        end
      end
    end

    describe "#sample_delivery_response" do
      context "with no options" do
        it "should return a successful delivery response" do
          adapter.sample_delivery_response.should == "OK: 0; Sent queued message ID: 86b1a945370734f4 SMSGlobalMsgID:6942744494999745"
        end
      end
      context "with options" do
        context "'failed'" do
          it "should return a failed delivery response" do
            adapter.sample_delivery_response(:failed => true).should == "ERROR: No action requested"
          end
        end
        context "'message_id'" do
          it "should include the option" do
            adapter.sample_delivery_response(:message_id => "12345").should =~ /SMSGlobalMsgID:12345/
          end
        end
      end
    end

    describe "#sample_message_id" do
      context "with no options" do
        it "should return a default message id" do
          adapter.sample_message_id.should == "SMSGlobalMsgID:6942744494999745"
        end
      end
      context "with options" do
        context "'message_id'" do
          it "should include the option" do
            adapter.sample_message_id(:message_id => "12345").should == "SMSGlobalMsgID:12345"
          end
        end
      end
    end

    describe "#sample_delivery_receipt" do
      context "with no options" do
        it "should return the default values" do
          adapter.sample_delivery_receipt.should include(
            "msgid", "dlrstatus", "dlr_err", "donedate"
          )
        end
      end
      context "with options" do
        context "'message_id'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :message_id => "SMSGlobalMsgID:12345"
            ).should include("msgid" => "12345")
          end
        end
        context "'status'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :status => "no good"
            ).should include("dlrstatus" => "no good")
          end
        end
        context "'error'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :error => "some error"
            ).should include("dlr_err" => "some error")
          end
        end
        context "'date'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :date => "today"
            ).should include("donedate" => "today")
          end
        end
      end
    end
  end
end

