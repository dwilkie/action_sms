require 'spec_helper'

describe ActionSms::ConnectionAdapters::TropoAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::TropoAdapter.new }

  def response(success = true)
    success ?
    "success=true&token=abcde3214&id=9865abcde" :
    "success=false&token=abcde3214&reason=Invalid+token"
  end

  describe "#deliver" do
    let(:sms) { mock("sms").as_null_object }
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
        hash_including("token" => "my_token")
      )
      adapter.deliver(sms)
    end

    it "should try to send the sms with the result from 'sms#recipient'" do
      sms.stub!(:recipient).and_return("somebody")
      adapter.should_receive(:send_http_request).with(
        anything,
        hash_including("to" => "somebody")
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
          hash_including("text" => "something")
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
          hash_including("text" => "")
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
          hash_including("from" => "anybody")
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
          hash_not_including("from")
        )
        adapter.deliver(sms)
      end
    end

    context ":filter_response => true" do
      it "should not return the token" do
        adapter.deliver(
          sms, :filter_response => true
        ).should == "success=true&id=9865abcde"
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
        response
      }
      it "should not return nil" do
        adapter.delivery_request_successful?(delivery_response).should_not be_nil
      end
    end
    context "the gateway response was not successful" do
      let (:delivery_response) { response(false) }
      it "should return nil" do
        adapter.delivery_request_successful?(delivery_response).should be_nil
      end
    end
  end

  describe "#message_id" do
    context "the gateway response was successful" do
      let(:delivery_response) { response }
      it "should return the id" do
        adapter.message_id(delivery_response).should == "9865abcde"
      end
    end
    context "the gateway response was not successful" do
      let(:delivery_response) { response(false) }
      it "should return nil" do
        adapter.message_id(delivery_response).should be_nil
      end
    end
  end

  describe "#message_text" do
    context "given valid incoming message request params" do
      let(:request_params) { { "session" => {} } }
      before do
        request_params["session"]["initial_text"] = "ANYTHING"
      end
      it "should return the message" do
        adapter.message_text(request_params).should_not be_nil
      end
    end
    context "given invalid incoming message request params" do
      let(:request_params) { {} }
      it "should return nil" do
        adapter.message_text(request_params).should be_nil
      end
    end
  end

  describe "#sender" do
    context "given valid incoming message request params" do
      let(:request_params) { {"session" => { "from" => {} }}}
      before do
        request_params["session"]["from"]["id"] = "ANYTHING"
      end
      it "should return the message" do
        adapter.sender(request_params).should_not be_nil
      end
    end
    context "given invalid incoming message request params" do
      let(:request_params) { {} }
      it "should return nil" do
        adapter.sender(request_params).should be_nil
      end
    end
  end

  describe "#service_url" do
    it "should be the Tropo service url" do
      adapter.service_url.should == "http://api.tropo.com/1.0/sessions"
    end
    context "#use_ssl=false" do
      before do
        adapter.use_ssl = false
      end
      it "should be 'http'" do
        URI.parse(adapter.service_url).scheme.should == "http"
      end
    end
    context "#use_ssl=true" do
      before do
        adapter.use_ssl = true
      end
      it "should be 'https'" do
        URI.parse(adapter.service_url).scheme.should == "https"
      end
    end
  end

  describe "#status" do
    it "should return nil" do
      adapter.status({"status" => "success"}).should be_nil
    end
  end
end

