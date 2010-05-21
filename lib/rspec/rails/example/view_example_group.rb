require 'webrat'

module ViewExampleGroupBehaviour
  extend ActiveSupport::Concern

  def controller_path
    parts = file_to_render.split('/')
    parts.pop
    parts.join('/')
  end

  def response
    @response
  end

  def render
    @response = view.render :file => file_to_render
  end

  def file_to_render
    running_example.example_group.top_level_description
  end

  included do
    include RSpec::Rails::ActionViewSandbox
  end

  RSpec.configure do |c|
    c.include self, :example_group => { :file_path => /\bspec\/views\// }
  end

end
