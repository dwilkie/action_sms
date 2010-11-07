require 'spec_helper'

describe ActionSms::Base do

  describe "#connection" do
    it "should set the connection" do
      adapter = mock("adapter")
      ActionSms::Base.connection = adapter
      ActionSms::Base.connection.should == adapter
      ActionSms::Base.should be_connected
    end
  end

  describe "#establish_connection" do
    context "adapter is specified in the configuration" do
      let (:adapter_name) { "my_adapter" }
      let (:adapter_connection) { adapter_name + "_connection" }
      context "and is defined" do
        let (:adapter) { mock("adapter") }
        before do
          ActionSms::Base.stub!(:respond_to?).with(
            adapter_connection
          ).and_return(true)
          ActionSms::Base.stub!(
            adapter_connection
          ).and_return(adapter)
        end
        it "should be connected" do
          ActionSms::Base.establish_connection(:adapter => adapter_name)
          ActionSms::Base.should be_connected
        end
      end
      context "but is not defined" do
        before do
          ActionSms::Base.stub!(:respond_to?).with(
            adapter_connection
          ).and_return(false)
        end
        it "should raise and 'AdapterNotFound' error" do
          expect {
            ActionSms::Base.establish_connection(:adapter => adapter_name)
          }.to raise_error(ActionSms::AdapterNotFound)
        end
      end
    end
    context "adapter is not specified in the configuration" do
      it "should raise an 'AdapterNotSpecified' error" do
        expect {
          ActionSms::Base.establish_connection({})
        }.to raise_error(ActionSms::AdapterNotSpecified)
      end
    end
  end

  context "adapter helper methods" do
    let(:active_concrete_adapter) {
      mock("active_concrete_adapter")
    }

    let(:another_concrete_adapter) {
      mock("another_concrete_adapter")
    }

    before do
      ActionSms::Base.should_receive(
        :connection
      ).and_return(active_concrete_adapter)

      ActionSms::Base.stub!(
        :instance_methods
      ).and_return([:another_concrete_adapter_connection])

      ActionSms::Base.stub!(:send).with(
        :another_concrete_adapter_connection
      ).and_return(another_concrete_adapter)
    end

    describe "#authenticate" do
      before do
        active_concrete_adapter.stub!(:send).with(
          :authenticate, *anything
        )
      end
      context "active connection authenticates the message" do
        before do
          active_concrete_adapter.should_receive(:send).with(
            :authenticate, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.authenticate("anything").should == "something"
        end
      end

      context "another adapter authenticates the message" do
        before do
          another_concrete_adapter.stub!(:send).with(
            :authenticate, *anything
           ).and_return("something else")
          another_concrete_adapter.stub!(:authenticate)
        end

        it "should return the other adapter's response" do
          ActionSms::Base.authenticate("anything").should == "something else"
        end
      end

      context "no adapters authenticate the message" do
        it "should return nil" do
          ActionSms::Base.authenticate("anything").should be_nil
        end
      end
    end

    describe "#authentication_key" do
      it "should call 'authentication_key' on the connection" do
        active_concrete_adapter.should_receive(:authentication_key)
        ActionSms::Base.authentication_key
      end
    end

    describe "#authentication_key=" do
      it "should call 'authentication_key=' on the connection" do
        active_concrete_adapter.should_receive(
          :authentication_key=
        ).with("something")
        ActionSms::Base.authentication_key = "something"
      end
    end

    describe "#deliver" do
      it "should call 'deliver' on the connection" do
        sms = mock("sms")
        options = {:my_options => "something"}
        active_concrete_adapter.should_receive(:deliver).with(sms, options)
        ActionSms::Base.deliver(sms, options)
      end
    end

    describe "#delivery_request_successful?" do
      it "should call 'delivery_request_successful?' on the connection" do
        gateway_response = mock("gateway_response")
        active_concrete_adapter.should_receive(
          :delivery_request_successful?
        ).with(gateway_response)
        ActionSms::Base.delivery_request_successful?(gateway_response)
      end
    end

    describe "#message_id" do
      before do
        active_concrete_adapter.stub!(:send).with(
          :message_id, *anything
        )
      end
      context "active connection returns the message id" do
        before do
          active_concrete_adapter.should_receive(:send).with(
            :message_id, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.message_id("anything").should == "something"
        end
      end

      context "another adapter returns the message id" do
        before do
          another_concrete_adapter.stub!(:send).with(
            :message_id, *anything
           ).and_return("something else")
          another_concrete_adapter.stub!(:message_id)
        end

        it "should return the other adapter's response" do
          ActionSms::Base.message_id("anything").should == "something else"
        end
      end

      context "no adapters return the message id" do
        it "should return nil" do
          ActionSms::Base.message_id("anything").should be_nil
        end
      end
    end

    describe "#message_text" do
      before do
        active_concrete_adapter.stub!(:send).with(
          :message_text, *anything
        )
      end
      context "active connection returns the message text" do
        before do
          active_concrete_adapter.should_receive(:send).with(
            :message_text, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.message_text("anything").should == "something"
        end
      end

      context "another adapter returns the message text" do
        before do
          another_concrete_adapter.stub!(:send).with(
            :message_text, *anything
           ).and_return("something else")
          another_concrete_adapter.stub!(:message_text)
        end

        it "should return the other adapter's response" do
          ActionSms::Base.message_text("anything").should == "something else"
        end
      end

      context "no adapters return the message text" do
        it "should return nil" do
          ActionSms::Base.message_text("anything").should be_nil
        end
      end
    end

    describe "#sender" do
      before do
        active_concrete_adapter.stub!(:send).with(
          :sender, *anything
        )
      end
      context "active connection returns the sender" do
        before do
          active_concrete_adapter.should_receive(:send).with(
            :sender, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.sender("anything").should == "something"
        end
      end

      context "another adapter returns the sender" do
        before do
          another_concrete_adapter.stub!(:send).with(
            :sender, *anything
           ).and_return("something else")
          another_concrete_adapter.stub!(:sender)
        end

        it "should return the other adapter's response" do
          ActionSms::Base.sender("anything").should == "something else"
        end
      end

      context "no adapters return the sender" do
        it "should return nil" do
          ActionSms::Base.sender("anything").should be_nil
        end
      end
    end

    describe "#service_url" do
      it "should call 'service_url' on the connection" do
        active_concrete_adapter.should_receive(:service_url)
        ActionSms::Base.service_url
      end
    end

    describe "#status" do
      before do
        active_concrete_adapter.stub!(:send).with(
          :status, *anything
        )
      end
      context "active connection returns the status" do
        before do
          active_concrete_adapter.should_receive(:send).with(
            :status, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.status("anything").should == "something"
        end
      end

      context "another adapter returns the sender" do
        before do
          another_concrete_adapter.stub!(:send).with(
            :status, *anything
           ).and_return("something else")
          another_concrete_adapter.stub!(:status)
        end

        it "should return the other adapter's response" do
          ActionSms::Base.status("anything").should == "something else"
        end
      end

      context "no adapters return the status" do
        it "should return nil" do
          ActionSms::Base.status("anything").should be_nil
        end
      end

      describe "#use_ssl" do
        it "should call 'use_ssl' on the connection" do
          active_concrete_adapter.should_receive(:use_ssl)
          ActionSms::Base.use_ssl
        end
      end

      describe "#use_ssl=" do
        it "should call 'use_ssl=' on the connection" do
          active_concrete_adapter.should_receive(
            :use_ssl=
          ).with("something")
          ActionSms::Base.use_ssl = "something"
        end
      end
    end

    # Test Helper Methods

    describe "#sample_configuration" do
      it "should call 'sample_configuration' on the connection" do
        active_concrete_adapter.should_receive(:sample_configuration)
        ActionSms::Base.sample_configuration
      end
      context "with options" do
        it "should pass on the options" do
          options = {:my_option => "12345"}
          active_concrete_adapter.should_receive(
            :sample_configuration
          ).with(options)
          ActionSms::Base.sample_configuration(options)
        end
      end
    end

    describe "#sample_delivery_receipt" do
      it "should call 'sample_delivery_receipt' on the connection" do
        active_concrete_adapter.should_receive(:sample_delivery_receipt)
        ActionSms::Base.sample_delivery_receipt
      end
      context "with options" do
        it "should pass on the options" do
          options = {:my_option => "12345"}
          active_concrete_adapter.should_receive(
            :sample_delivery_receipt
          ).with(options)
          ActionSms::Base.sample_delivery_receipt(options)
        end
      end
    end

    describe "#sample_delivery_response" do
      it "should call 'sample_delivery_response' on the connection" do
        active_concrete_adapter.should_receive(:sample_delivery_response)
        ActionSms::Base.sample_delivery_response
      end
      context "with options" do
        it "should pass on the options" do
          options = {:my_option => "12345"}
          active_concrete_adapter.should_receive(
            :sample_delivery_response
          ).with(options)
          ActionSms::Base.sample_delivery_response(options)
        end
      end
    end

    describe "#sample_incoming_sms" do
      it "should call 'sample_incoming_sms' on the connection" do
        active_concrete_adapter.should_receive(:sample_incoming_sms)
        ActionSms::Base.sample_incoming_sms
      end
      context "with options" do
        it "should pass on the options" do
          options = {:my_option => "12345"}
          active_concrete_adapter.should_receive(
            :sample_incoming_sms
          ).with(options)
          ActionSms::Base.sample_incoming_sms(options)
        end
      end
    end

    describe "#sample_message_id" do
      it "should call 'sample_message_id' on the connection" do
        active_concrete_adapter.should_receive(:sample_message_id)
        ActionSms::Base.sample_message_id
      end
      context "with options" do
        it "should pass on the options" do
          options = {:my_option => "12345"}
          active_concrete_adapter.should_receive(
            :sample_message_id
          ).with(options)
          ActionSms::Base.sample_message_id(options)
        end
      end
    end
  end
end

