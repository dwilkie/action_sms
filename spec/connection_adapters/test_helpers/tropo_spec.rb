require 'spec_helper'

describe ActionSms::ConnectionAdapters::TropoAdapter do
  let (:adapter_name) { "tropo" }
  context "is not in test mode" do
    let(:adapter) {
      ActionSms::Base.tropo_connection(
        :adapter => adapter_name
      )
    }

    it "should not respond to #sample_configuration" do
      adapter.should_not be_respond_to(:sample_configuration)
    end

    it "should not respond to #sample_delivery_response" do
      adapter.should_not be_respond_to(:sample_delivery_response)
    end

    it "should not respond to #sample_incoming_sms" do
      adapter.should_not be_respond_to(:sample_incoming_sms)
    end
  end

  context "is in test mode" do
    let(:adapter) {
      ActionSms::Base.tropo_connection(
        :adapter => adapter_name,
        :environment => "test"
      )
    }

    # Additional methods available in test mode

    describe "#sample_configuration" do
      it "should contain Tropo specific configuration" do
        adapter.sample_configuration.should include(
          :outgoing_token
        )
      end
      it "should contain the correct adapter name" do
        adapter.sample_configuration.should include(
          :adapter => "tropo"
        )
      end
      context "with options" do
        context "authentication_key => true" do
          it "should contain an authentication key" do
            adapter.sample_configuration(
              :authentication_key => true
            ).should include(:authentication_key)
          end
        end
      end
    end

    describe "#sample_delivery_response" do
      context "with no options" do
        it "should return a successful delivery response" do
          adapter.sample_delivery_response.should == "success=true&token=abcde3214&id=9865abcde"
        end
      end
      context "with options" do
        context "'failed'" do
          it "should return a failed delivery response" do
            adapter.sample_delivery_response(:failed => true).should == "success=false&token=abcde3214&reason=Invalid+token"
          end
        end
      end
    end

    describe "#sample_incoming_sms" do
      context "with no options" do
        it "should return the default values" do
          session = adapter.sample_incoming_sms["session"]
          session.should include(
            "timestamp", "initial_text"
          )
          session["to"].should include("id")
          session["from"].should include("id")
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
            session = adapter.sample_incoming_sms(
              :message => "hello"
            )["session"]
            session.should include(
              "initial_text" => "hello"
            )
          end
        end
        context "'to'" do
          it "should include the option" do
            session = adapter.sample_incoming_sms(
              :to => "someone"
            )["session"]
            session["to"].should include(
              "id" => "someone"
            )
          end
        end
        context "'from'" do
          it "should include the option" do
            session = adapter.sample_incoming_sms(
              :from => "anyone"
            )["session"]
            session["from"].should include(
              "id" => "anyone"
            )
          end
        end
        context "'date'" do
          it "should include the option" do
            session = adapter.sample_incoming_sms(
              :date => "today"
            )["session"]
            session.should include(
              "timestamp" => "today"
            )
          end
        end
      end
    end
  end
end

