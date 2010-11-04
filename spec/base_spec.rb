require 'spec_helper'

describe ActionSms::Base do

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

      ActionSms::Base.stub!(:call).with(
        :another_concrete_adapter_connection
      ).and_return(another_concrete_adapter)
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

    describe "#service_url" do
      it "should call 'service_url' on the connection" do
        url = "http://omeurl.com"
        active_concrete_adapter.should_receive(:service_url)
        ActionSms::Base.service_url
      end
    end

    describe "#message_id" do
      before do
        active_concrete_adapter.stub!(:call).with(
          :message_id, *anything
        )
      end
      context "active connection returns the message id" do
        before do
          active_concrete_adapter.should_receive(:call).with(
            :message_id, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.message_id("anything").should == "something"
        end
      end

      context "another adapter returns the message id" do
        before do
          another_concrete_adapter.stub!(:call).with(
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
        active_concrete_adapter.stub!(:call).with(
          :message_text, *anything
        )
      end
      context "active connection returns the message text" do
        before do
          active_concrete_adapter.should_receive(:call).with(
            :message_text, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.message_text("anything").should == "something"
        end
      end

      context "another adapter returns the message text" do
        before do
          another_concrete_adapter.stub!(:call).with(
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
        active_concrete_adapter.stub!(:call).with(
          :sender, *anything
        )
      end
      context "active connection returns the sender" do
        before do
          active_concrete_adapter.should_receive(:call).with(
            :sender, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.sender("anything").should == "something"
        end
      end

      context "another adapter returns the sender" do
        before do
          another_concrete_adapter.stub!(:call).with(
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

    describe "#status" do
      before do
        active_concrete_adapter.stub!(:call).with(
          :status, *anything
        )
      end
      context "active connection returns the status" do
        before do
          active_concrete_adapter.should_receive(:call).with(
            :status, *anything
          ).and_return("something")
        end
        it "should return the active connection's response" do
          ActionSms::Base.status("anything").should == "something"
        end
      end

      context "another adapter returns the sender" do
        before do
          another_concrete_adapter.stub!(:call).with(
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
    end
  end

  describe "#connection" do
    it "should set the connection" do
      adapter = mock("adapter")
      ActionSms::Base.connection = adapter
      ActionSms::Base.connection.should == adapter
      ActionSms::Base.should be_connected
    end
  end
end

