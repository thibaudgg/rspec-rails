require "spec_helper"

module RSpec::Rails
  describe MailerExampleGroup do
    it "is included in specs in ./spec/mailers" do
      stub_metadata(
        :example_group => {:file_path => "./spec/mailers/whatever_spec.rb:15"}
      )
      group = RSpec::Core::ExampleGroup.describe
      group.included_modules.should include(MailerExampleGroup)
    end

    describe "#mailer" do
      it "returns a new instance of the mailer" do
        mailer_class = Class.new(ActionMailer::Base)
        group = RSpec::Core::ExampleGroup.describe(mailer_class) do
          include MailerExampleGroup
        end
        group.new.mailer.should be_a(mailer_class)
      end
    end
  end
end
