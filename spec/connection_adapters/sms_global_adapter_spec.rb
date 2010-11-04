require 'spec_helper'

describe ActionSms::ConnectionAdapters::SMSGlobalAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::SMSGlobalAdapter.new }

  describe "#deliver" do
    let(:sms) { mock("sms").as_null_object }
    before do
      adapter.stub!(:send_http_request)
    end

    it "should try to send the sms to the correct url" do
      adapter.should_receive(:send_http_request).with(
        "http://smsglobal.com.au/http-api.php",
        anything
      )
      adapter.deliver(sms)
    end

    it "should try to send the sms with the correct 'action' value" do
      adapter.should_receive(:send_http_request).with(
        anything,
        hash_including(:action => "sendsms")
      )
      adapter.deliver(sms)
    end

    it "should try to send the sms with the 'user' configuration value" do
      adapter.should_receive(:send_http_request).with(
        anything,
        hash_including(:user)
      )
      adapter.deliver(sms)
    end

    it "should try to send the sms with the 'password' configuration value" do
      adapter.should_receive(:send_http_request).with(
        anything,
        hash_including(:password)
      )
      adapter.deliver(sms)
    end

    it "should try to send the sms with the correct 'maxsplit' value" do
      adapter.should_receive(:send_http_request).with(
        anything,
        hash_including(:maxsplit => "19")
      )
      adapter.deliver(sms)
    end

    context "sms' responds to '#from'" do
      before do
        sms.stub!(:from).and_return("anybody")
      end
      it "should try to send the sms with the result from 'sms#from'" do
        adapter.should_receive(:send_http_request).with(
          anything,
          hash_including(:from => "anybody")
        )
        adapter.deliver(sms)
      end
    end

    context "sms does not respond to '#from'" do
      before do
        sms.stub!(:respond_to?).and_return(false)
      end
      it "should try to send the sms with 'from' set to 'reply2email'" do
        adapter.should_receive(:send_http_request).with(
          anything,
          hash_including(:from => "reply2email")
        )
        adapter.deliver(sms)
      end
    end

    it "should try to send the sms with the result from 'sms#recipient'" do
      adapter.should_receive(:send_http_request).with(
        anything,
        hash_including(:to)
      )
      adapter.deliver(sms)
    end

    context "sms#body is not nil" do
      it "should try to send the sms with the sms' body" do
        adapter.should_receive(:send_http_request).with(
          anything,
          hash_including(:text)
        )
        adapter.deliver(sms)
      end
    end

    context "sms#body is nil" do
      before do
        sms.stub!(:body).and_return(nil)
      end

      it "should try to send the sms with blank text" do
        adapter.should_receive(:send_http_request).with(
          anything,
          hash_including(:text => "")
        )
        adapter.deliver(sms)
      end
    end

    context "sms responds to #userfield" do
      it "should try to send the sms with the result from 'sms#userfield'" do
        adapter.should_receive(:send_http_request).with(
          anything,
          hash_including(:userfield)
        )
        adapter.deliver(sms)
      end
    end

    context "sms does not respond to #userfield" do
      before do
        sms.stub!(:respond_to?).and_return(false)
      end
      it "should try to send the sms with the 'userfield' parameter" do
        adapter.should_receive(:send_http_request).with(
          anything,
          hash_not_including(:userfield)
        )
        adapter.deliver(sms)
      end
    end
  end

  describe "#delivery_request_successful?" do
    context "the gateway response was successful" do
      let (:delivery_response) {
        "OK: 0; Sent queued message ID: 86b1a945370734f4 SMSGlobalMsgID: 6942744494999745"
      }
      it "should not return nil" do
        adapter.delivery_request_successful?(delivery_response).should_not be_nil
      end
    end
    context "the gateway response was not successful" do
      let (:delivery_response) { "ERROR: No action requested" }
      it "should return nil" do
        adapter.delivery_request_successful?(delivery_response).should be_nil
      end
    end
  end

  describe "#message_id" do
    context "argument is a String" do
      context "and includes an SMSGlobal message id" do
        it "should return the message id with an SMSGlobal prefix" do
          adapter.message_id("Blah blah blah SMSGlobalMsgID:  123556blah").should == "SMSGlobalMsgID:123556"
        end
      end
      context "but does not include an SMSGlobal message id" do
        it "should return nil" do
          adapter.message_id("Blah blah blah SMSGlobalMsID:  123556blah").should be_nil
        end
      end
    end
    context "argument is a Hash" do
      context "that includes an SMSGlobal message id" do
        it "should return the message id with the SMSGlobal prefix" do
          adapter.message_id(
            {
              "msgid" => "12345"
            }
          ).should == "SMSGlobalMsgID:12345"
        end
      end
      context "that does not include an SMSGlobal message id" do
        it "should return nil" do
          adapter.message_id(
            {
              "something" => "12345"
            }
          ).should be_nil
        end
      end
    end
  end

  describe "#message_text" do
    let (:request_params) { {} }
    context "given valid incoming message request params" do
      before do
        request_params["msg"] = "ANYTHING"
      end
      it "should return the message" do
        adapter.message_text(request_params).should_not be_nil
      end
    end
    context "given invalid incoming message request params" do
      it "should return nil" do
        adapter.message_text(request_params).should be_nil
      end
    end
  end

  describe "#sender" do
    let (:request_params) { {} }
    context "given valid incoming message request params" do
      before do
        request_params["from"] = "ANYTHING"
      end
      it "should return the message" do
        adapter.sender(request_params).should_not be_nil
      end
    end
    context "given invalid incoming message request params" do
      it "should return nil" do
        adapter.sender(request_params).should be_nil
      end
    end
  end

  describe "#service_url" do
    it "should be the SMS Global service url" do
      adapter.service_url.should == "http://smsglobal.com.au/http-api.php"
    end
  end

  describe "#status" do
    let (:delivery_receipt) { {} }
    context "given a valid delivery receipt" do
      before do
        delivery_receipt["dlrstatus"] = "ANYTHING"
      end
      it "should return the delivery status" do
        adapter.status(delivery_receipt).should_not be_nil
      end
    end
    context "given a invalid delivery receipt" do
      it "should return nil" do
        adapter.status(delivery_receipt).should be_nil
      end
    end
  end
end

