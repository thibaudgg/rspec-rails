require 'webrat'

module HelperExampleGroupBehaviour
  extend ActiveSupport::Concern

  def controller_path
    helper_module.to_s.sub(/Helper/,'').underscore
  end

  def helper_module
    running_example.example_group.describes
  end

  def helper
    view
  end

  included do
    include RSpec::Rails::ActionViewSandbox
    before do
      view.extend(helper_module)
    end
  end

  RSpec.configure do |c|
    c.include self, :example_group => { :file_path => /\bspec\/helpers\// }
  end

end

