require 'spec_helper'

describe ActionSms::ConnectionAdapters::AbstractAdapter do
  let(:adapter) { ActionSms::ConnectionAdapters::AbstractAdapter.new }

  # Interesting methods

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

  describe "#authentication_key" do
    it "should set the authentication key" do
      adapter.authentication_key = "my_secret_key"
      adapter.authentication_key.should == "my_secret_key"
    end
  end

  describe "#configuration" do
    it "should set the configuration" do
      adapter.configuration = {:config_key => "some config value"}
      adapter.configuration.should == {:config_key => "some config value"}
    end
  end

  describe "#use_ssl" do
    it "it should use ssl" do
      adapter.use_ssl = true
      adapter.use_ssl.should == true
    end
  end
end

