require 'spec_helper'

describe ActionSms::ConnectionAdapters::TropoAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::TropoAdapter.new }

  describe "#deliver" do
    let(:sms) { mock("sms").as_null_object }
    let(:response) { "<session><success>true</success><token>my_secret_token</token></session>" }
    before do
      adapter.stub!(:send_http_request).and_return(response)
    end

    it "should try to send the sms to the correct url" do
      adapter.should_receive(:send_http_request).with(
        "http://api.tropo.com/1.0/sessions",
        anything
      )
      adapter.deliver(sms)
    end

    it "should try to send the sms with the 'outgoing_token' configuration value" do
      config = adapter.instance_variable_get(:@config)
      adapter.instance_variable_set(
        :@config, config.merge(:outgoing_token => "my_token")
      )
      adapter.should_receive(:send_http_request).with(
        anything,
        /my_token/
      )
      adapter.deliver(sms)
    end

    it "should try to send the sms with the result from 'sms#recipient'" do
      sms.stub!(:recipient).and_return("somebody")
      adapter.should_receive(:send_http_request).with(
        anything,
        /somebody/
      )
      adapter.deliver(sms)
    end

    context "sms#body is not nil" do
      before do
        sms.stub!(:body).and_return("something")
      end

      it "should try to send the sms with the sms' body" do
        adapter.should_receive(:send_http_request).with(
          anything,
          /something/
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
          /text/
        )
        adapter.deliver(sms)
      end
    end

    context "sms' responds to '#from'" do
      before do
        sms.stub!(:from).and_return("anybody")
      end
      it "should try to send the sms with the result from 'sms#from'" do
        adapter.should_receive(:send_http_request).with(
          anything,
          /anybody/
        )
        adapter.deliver(sms)
      end
    end

    context "sms does not respond to '#from'" do
      before do
        sms.stub!(:respond_to?).and_return(false)
      end
      it "should try to send the sms without 'from'" do
        adapter.should_receive(:send_http_request).with(
          anything,
          /^((?!from).)*$/
        )
        adapter.deliver(sms)
      end
    end

    context ":filter_response => true" do
      it "should not return the token" do
        adapter.deliver(
          sms, :filter_response => true
        ).should == "<session><success>true</success></session>"
      end
    end

    context ":filter_response => false" do
      it "should return the token" do
        adapter.deliver(
          sms, :filter_response => false
        ).should == response
      end
    end
  end

  describe "#delivery_request_successful?" do
    context "the gateway response was successful" do
      let (:delivery_response) {
        "<session><success>true</success></session>"
      }
      it "should not return nil" do
        adapter.delivery_request_successful?(delivery_response).should_not be_nil
      end
    end
    context "the gateway response was not successful" do
      let (:delivery_response) { "<session><success>false</success><token></token><reason>FAILED TO ROUTE TOKEN</reason></session>" }
      it "should return nil" do
        adapter.delivery_request_successful?(delivery_response).should be_nil
      end
    end
  end

  describe "#message_id" do
    it "should return nil" do
      adapter.message_id("any text").should be_nil
    end
  end

  describe "#message_text" do
    let (:request_params) { { "session" => {} } }
    context "given valid incoming message request params" do
      before do
        request_params["session"]["initial_text"] = "ANYTHING"
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
    let (:request_params) { {"session" => { "from" => {} }}}
    context "given valid incoming message request params" do
      before do
        request_params["session"]["from"]["id"] = "ANYTHING"
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
    it "should be the tropo sessions url" do
      adapter.service_url.should == "http://api.tropo.com/1.0/sessions"
    end
  end

  describe "#status" do
    it "should return nil" do
      adapter.status({"status" => "success"}).should be_nil
    end
  end
end

