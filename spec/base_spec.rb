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
    let(:active_adapter) {
      mock("active_adapter")
    }

    let(:another_adapter) {
      mock("another_adapter")
    }

    before do
      ActionSms::Base.stub!(
        :connection
      ).and_return(active_adapter)

      ActionSms::Base.stub!(
        :methods
      ).and_return([:another_adapter_connection])

      ActionSms::Base.stub!(
        :another_adapter_connection
      ).and_return(another_adapter)

      active_adapter.stub!(:configuration)
    end

    describe "#authenticate" do
      before do
        active_adapter.stub!(:respond_to?).with(
          :authenticate
        ).and_return(true)
      end
      context "active connection authenticates the message" do
        before do
          active_adapter.stub!(
            :authenticate
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.authenticate("anything").should == "something"
        end
      end
      context "active connection does not authenticate the message" do
        before do
          active_adapter.stub!(:authenticate)
        end
        context "another adapter authenticates the message" do
          before do
            another_adapter.stub!(
              :authenticate
             ).and_return("something else")
          end
          it "should return the other adapter's response" do
            ActionSms::Base.authenticate("anything").should == "something else"
          end
        end
        context "no other adapter authenticates the message" do
          it "should return nil" do
            ActionSms::Base.authenticate("anything").should be_nil
          end
        end
      end
    end

    describe "#authentication_key" do
      it "should call 'authentication_key' on the connection" do
        active_adapter.should_receive(:authentication_key)
        ActionSms::Base.authentication_key
      end
    end

    describe "#authentication_key=" do
      it "should call 'authentication_key=' on the connection" do
        active_adapter.should_receive(
          :authentication_key=
        ).with("something")
        ActionSms::Base.authentication_key = "something"
      end
    end

    describe "#deliver" do
      it "should call 'deliver' on the connection" do
        sms = mock("sms")
        options = {:my_options => "something"}
        active_adapter.should_receive(:deliver).with(sms, options)
        ActionSms::Base.deliver(sms, options)
      end
    end

    describe "#delivery_request_successful?" do
      it "should call 'delivery_request_successful?' on the connection" do
        gateway_response = mock("gateway_response")
        active_adapter.should_receive(
          :delivery_request_successful?
        ).with(gateway_response)
        ActionSms::Base.delivery_request_successful?(gateway_response)
      end
    end

    describe "#message_id" do
      before do
        active_adapter.stub!(:respond_to?).with(
          :message_id
        ).and_return(true)
      end
      context "active connection returns the message id" do
        before do
          active_adapter.stub!(
            :message_id
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.message_id("anything").should == "something"
        end
      end
      context "active connection does not return the message id" do
        before do
          active_adapter.stub!(:message_id)
        end
        context "another adapter returns the message id" do
          before do
            another_adapter.stub!(
              :message_id
             ).and_return("something else")
          end

          it "should return the other adapter's response" do
            ActionSms::Base.message_id("anything").should == "something else"
          end
        end

        context "no other adapter returns the message id" do
          it "should return nil" do
            ActionSms::Base.message_id("anything").should be_nil
          end
        end
      end
    end

    describe "#message_text" do
      before do
        active_adapter.stub!(:respond_to?).with(
          :message_text
        ).and_return(true)
      end
      context "active connection returns the message text" do
        before do
          active_adapter.stub!(
            :message_text
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.message_text("anything").should == "something"
        end
      end
      context "active connection does not return the message text" do
        before do
          active_adapter.stub!(:message_text)
        end
        context "another adapter returns the message text" do
          before do
            another_adapter.stub!(
              :message_text
             ).and_return("something else")
          end

          it "should return the other adapter's response" do
            ActionSms::Base.message_text("anything").should == "something else"
          end
        end

        context "no other adapter returns the message text" do
          it "should return nil" do
            ActionSms::Base.message_text("anything").should be_nil
          end
        end
      end
    end

    describe "#sender" do
      before do
        active_adapter.stub!(:respond_to?).with(
          :sender
        ).and_return(true)
      end
      context "active connection returns the sender" do
        before do
          active_adapter.stub!(
            :sender
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.sender("anything").should == "something"
        end
      end
      context "active connection does not return the sender" do
        before do
          active_adapter.stub!(:sender)
        end
        context "another adapter returns the sender" do
          before do
            another_adapter.stub!(
              :sender
             ).and_return("something else")
          end

          it "should return the other adapter's response" do
            ActionSms::Base.sender("anything").should == "something else"
          end
        end

        context "no other adapter return the sender" do
          it "should return nil" do
            ActionSms::Base.sender("anything").should be_nil
          end
        end
      end
    end

    describe "#service_url" do
      it "should call 'service_url' on the connection" do
        active_adapter.should_receive(:service_url)
        ActionSms::Base.service_url
      end
    end

    describe "#status" do
      before do
        active_adapter.stub!(:respond_to?).with(
          :status
        ).and_return(true)
      end
      context "active connection returns the status" do
        before do
          active_adapter.stub!(
            :status
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.status("anything").should == "something"
        end
      end
      context "active connection does not return the status" do
        before do
          active_adapter.stub!(:status)
        end
        context "another adapter returns the status" do
          before do
            another_adapter.stub!(
              :status
             ).and_return("something else")
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
      end
    end

    describe "#use_ssl" do
      it "should call 'use_ssl' on the connection" do
        active_adapter.should_receive(:use_ssl)
        ActionSms::Base.use_ssl
      end
    end

    describe "#use_ssl=" do
      it "should call 'use_ssl=' on the connection" do
        active_adapter.should_receive(
          :use_ssl=
        ).with("something")
        ActionSms::Base.use_ssl = "something"
      end
    end

    # Test Helper Methods

    describe "#sample_configuration" do
      it "should call 'sample_configuration' on the connection" do
        active_adapter.should_receive(:sample_configuration)
        ActionSms::Base.sample_configuration
      end
      context "with options" do
        it "should pass on the options" do
          options = {:my_option => "12345"}
          active_adapter.should_receive(
            :sample_configuration
          ).with(options)
          ActionSms::Base.sample_configuration(options)
        end
      end
    end

    describe "#sample_delivery_receipt" do
      shared_examples_for "another adapter's sample_delivery_receipt" do
        context "but another adapter responds to 'sample_delivery_receipt'" do
          before do
            another_adapter.stub!(:sample_delivery_receipt)
          end
          context "and returns one" do
            before do
              another_adapter.stub!(
                :sample_delivery_receipt
              ).and_return("something else")
            end
            it "should return the other adapter's response" do
              ActionSms::Base.sample_delivery_receipt.should == "something else"
            end
          end
          context "but also returns nil" do
            it "should return nil" do
              ActionSms::Base.sample_delivery_receipt.should be_nil
            end
          end
        end
        context "and no other adapter responds to 'sample_delivery_receipt'" do
          it "should return nil" do
            ActionSms::Base.sample_delivery_receipt.should be_nil
          end
        end
      end
      context "active connection responds to 'sample_delivery_receipt'" do
        before do
          active_adapter.stub!(:sample_delivery_receipt)
        end
        context "and returns a sample delivery receipt" do
          before do
            active_adapter.stub!(
              :sample_delivery_receipt
            ).and_return("something")
          end
          it "should return the active connection's response" do
            ActionSms::Base.sample_delivery_receipt.should == "something"
          end
        end
        context "but returns nil" do
          before do
            active_adapter.stub!(:sample_delivery_receipt)
          end
          it_behaves_like "another adapter's sample_delivery_receipt"
        end
      end
      context "active connection does not respond to 'sample_delivery_receipt'" do
        it_behaves_like "another adapter's sample_delivery_receipt"
      end
    end

    describe "#sample_delivery_response" do
      it "should call 'sample_delivery_response' on the connection" do
        active_adapter.should_receive(:sample_delivery_response)
        ActionSms::Base.sample_delivery_response
      end
      context "with options" do
        it "should pass on the options" do
          options = {:my_option => "12345"}
          active_adapter.should_receive(
            :sample_delivery_response
          ).with(options)
          ActionSms::Base.sample_delivery_response(options)
        end
      end
    end

    describe "#sample_delivery_response_with_message_id" do
      shared_examples_for "another adapter's sample_delivery_response_with_message_id" do
        context "but another adapter responds to 'sample_delivery_response_with_message_id'" do
          before do
            another_adapter.stub!(:sample_delivery_response_with_message_id)
          end
          context "and returns one" do
            before do
              another_adapter.stub!(
                :sample_delivery_response_with_message_id
              ).and_return("something else")
            end
            it "should return the other adapter's response" do
              ActionSms::Base.sample_delivery_response_with_message_id("12345") == "something else"
            end
          end
          context "but also returns nil" do
            it "should return nil" do
              ActionSms::Base.sample_delivery_response_with_message_id("12345").should be_nil
            end
          end
        end
        context "and no other adapter responds to 'sample_delivery_response_with_message_id'" do
          it "should return nil" do
            ActionSms::Base.sample_delivery_response_with_message_id("12345").should be_nil
          end
        end
      end
      context "active connection responds to 'sample_delivery_response_with_message_id'" do
        before do
          active_adapter.stub!(:sample_delivery_response_with_message_id)
        end
        context "and returns a sample delivery response with message id" do
          before do
            active_adapter.stub!(
              :sample_delivery_response_with_message_id
            ).and_return("something")
          end
          it "should return the active connection's response" do
            ActionSms::Base.sample_delivery_response_with_message_id("12345").should == "something"
          end
        end
        context "but returns nil" do
          before do
            active_adapter.stub!(:sample_delivery_response_with_message_id)
          end
          it_behaves_like "another adapter's sample_delivery_response_with_message_id"
        end
      end
      context "active connection does not respond to 'sample_delivery_response_with_message_id'" do
        it_behaves_like "another adapter's sample_delivery_response_with_message_id"
      end
    end

    describe "#sample_incoming_sms" do
      shared_examples_for "another adapter's sample_incoming_sms" do
        context "but another adapter responds to 'sample_incoming_sms'" do
          before do
            another_adapter.stub!(:sample_incoming_sms)
          end
          context "and returns one" do
            before do
              another_adapter.stub!(
                :sample_incoming_sms
              ).and_return("something else")
            end
            it "should return the other adapter's response" do
              ActionSms::Base.sample_incoming_sms.should == "something else"
            end
          end
          context "but also returns nil" do
            it "should return nil" do
              ActionSms::Base.sample_incoming_sms.should be_nil
            end
          end
        end
        context "and no other adapter responds to 'sample_incoming_sms'" do
          it "should return nil" do
            ActionSms::Base.sample_incoming_sms.should be_nil
          end
        end
      end
      context "active connection responds to 'sample_incoming_sms'" do
        before do
          active_adapter.stub!(:sample_incoming_sms)
        end
        context "and returns a sample incoming sms" do
          before do
            active_adapter.stub!(
              :sample_incoming_sms
            ).and_return("something")
          end
          it "should return the active connection's response" do
            ActionSms::Base.sample_incoming_sms.should == "something"
          end
        end
        context "but returns nil" do
          before do
            active_adapter.stub!(:sample_incoming_sms)
          end
          it_behaves_like "another adapter's sample_incoming_sms"
        end
      end
      context "active connection does not respond to 'sample_incoming_sms'" do
        it_behaves_like "another adapter's sample_incoming_sms"
      end
    end

    describe "#sample_message_id" do
      shared_examples_for "another adapter's sample_message_id" do
        context "but another adapter responds to 'sample_message_id'" do
          before do
            another_adapter.stub!(:sample_message_id)
          end
          context "and returns one" do
            before do
              another_adapter.stub!(
                :sample_message_id
              ).and_return("something else")
            end
            it "should return the other adapter's response" do
              ActionSms::Base.sample_message_id.should == "something else"
            end
          end
          context "but also returns nil" do
            it "should return nil" do
              ActionSms::Base.sample_message_id.should be_nil
            end
          end
        end
        context "and no other adapter responds to 'sample_message_id'" do
          it "should return nil" do
            ActionSms::Base.sample_message_id.should be_nil
          end
        end
      end
      context "active connection responds to 'sample_message_id'" do
        before do
          active_adapter.stub!(:sample_message_id)
        end
        context "and returns a sample message id" do
          before do
            active_adapter.stub!(
              :sample_message_id
            ).and_return("something")
          end
          it "should return the active connection's response" do
            ActionSms::Base.sample_message_id.should == "something"
          end
        end
        context "but returns nil" do
          before do
            active_adapter.stub!(:sample_message_id)
          end
          it_behaves_like "another adapter's sample_message_id"
        end
      end
      context "active connection does not respond to 'sample_message_id'" do
        it_behaves_like "another adapter's sample_message_id"
      end
    end
  end
end

