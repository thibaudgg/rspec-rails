require 'webrat'

module RSpec::Rails
  module MailerExampleGroup
    extend ActiveSupport::Concern

    include ActionMailer::TestCase::Behavior

    include Webrat::Matchers
    include RSpec::Matchers

    module ClassMethods
      # Used internally by ActionMailer::TestCase::Behavior to determine
      # what mailer class to use to generate mail.
      def mailer_class
        describes
      end
    end

    module InstanceMethods
      # Returns an instance of the mailer class being specified. Useful for
      # specifying the behavior of mailer instance methods in isolation.
      #
      # == Examples
      #
      #   describe Notifier do
      #     describe "#salutation" do
      #       it "includes the user's first and last name" do
      #         user = double("user", :first_name => "Jane", :last_name => "Roe")
      #         mailer.salutation.should match(/Jane Roe/)
      #       end
      #     end
      #   end
      def mailer
        self.class.describes.__send__ :new
      end
    end

    RSpec.configure do |c|
      c.include self, :example_group => { :file_path => /\bspec\/mailers\// }
    end
  end
end
