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

  describe "#connection" do
    it "should set the connection" do
      adapter = mock("adapter")
      ActionSms::Base.connection = adapter
      ActionSms::Base.connection.should == adapter
      ActionSms::Base.should be_connected
    end
  end
end

