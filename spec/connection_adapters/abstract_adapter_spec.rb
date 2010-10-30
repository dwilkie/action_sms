require 'spec_helper'

describe ActionSms::ConnectionAdapters::AbstractAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::AbstractAdapter.new }

  describe "#authenticate" do
    let (:request_params) { {} }
    context "the incoming message's 'authentication_key' query parameter value is the same as the adapter's authentication key" do
      before do
        adapter.authentication_key = "my_secret_key"
        request_params["authentication_key"] = "my_secret_key"
      end
      it "should not be nil" do
        adapter.authenticate(request_params).should_not be_nil
      end
      it "should remove the key from the request params hash" do
        adapter.authenticate(request_params)
        request_params["userfield"].should be_nil
      end
    end
    context "the incoming message's 'authentication_key' query parameter value is different from the adapter's authentication key" do
      before do
        request_params["authentication_key"] = "invalid_key"
      end
      it "should return nil" do
        adapter.authenticate(request_params).should be_nil
      end
      it "should not remove the key from the request params hash" do
        adapter.authenticate(request_params)
        request_params["authentication_key"].should_not be_nil
      end
    end
  end

  describe "#service_url" do
    context "using ssl" do
      before do
        adapter.use_ssl = true
      end
      it "should return the service url as https" do
        URI.parse(
          adapter.service_url("http://service-url.com")
        ).scheme.should == "https"
      end
    end
    context "without using ssl" do
      it "should return the service url as http" do
        URI.parse(
          adapter.service_url("http://service-url.com")
        ).scheme.should == "http"
      end
    end
  end
end

