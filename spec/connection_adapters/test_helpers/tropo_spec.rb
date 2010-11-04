require 'spec_helper'

describe ActionSms::ConnectionAdapters::TropoAdapter do
  let (:adapter_name) { "tropo" }
  context "is not in test mode" do
    let(:adapter) {
      ActionSms::Base.tropo_connection(
        :adapter => adapter_name
      )
    }
    it "should not respond to #sample_incoming_sms" do
      adapter.should_not be_respond_to(:sample_incoming_sms)
    end

    it "should not respond to #sample_delivery_response" do
      adapter.should_not be_respond_to(:sample_delivery_response)
    end

    it "should not respond to #sample_message_id" do
      adapter.should_not be_respond_to(:sample_message_id)
    end

    it "should not respond to #sample_delivery_receipt" do
      adapter.should_not be_respond_to(:sample_delivery_receipt)
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

    describe "#sample_delivery_response" do
      context "with no options" do
        it "should return a successful delivery response" do
          adapter.sample_delivery_response.should == "<session><success>true</success></session>"
        end
      end
      context "with options" do
        context "'failed'" do
          it "should return a failed delivery response" do
            adapter.sample_delivery_response(:failed => true).should == "<session><success>false</success><token></token><reason>FAILED TO ROUTE TOKEN</reason></session>"
          end
        end
      end
    end

    describe "#sample_message_id" do
      context "with no options" do
        it "should return a default message id" do
          adapter.sample_message_id.should == "123e71195545ad204bdd99f2070a7d86"
        end
      end
      context "with options" do
        context "'message_id'" do
          it "should include the option" do
            adapter.sample_message_id(:message_id => "12345").should == "12345"
          end
        end
      end
    end

    describe "#sample_delivery_receipt" do
      context "with no options" do
        it "should return the default values" do
          adapter.sample_delivery_receipt.should include(
            "message_id", "status", "delivered_at"
          )
        end
      end
      context "with options" do
        context "'message_id'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :message_id => "12345"
            ).should include("message_id" => "12345")
          end
        end
        context "'error'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :error => "some error"
            ).should include("error" => "some error")
          end
        end
        context "'status'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :status => "no good"
            ).should include("status" => "no good")
          end
        end
        context "'date'" do
          it "should include the option" do
            adapter.sample_delivery_receipt(
              :date => "today"
            ).should include("delivered_at" => "today")
          end
        end
      end
    end
  end
end

