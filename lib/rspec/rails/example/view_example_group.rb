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

  def file_to_render
    running_example.example_group.top_level_description
  end

  # :callseq:
  #   render 
  #   render("some/path") 
  #   render(:template => "some/path")
  #   render({:partial => "some/path"}, {... locals ...})
  #   render({:partial => "some/path"}, {... locals ...}) do ... end
  def render(options = nil, locals = {}, &block)
    @response = view.render(prepare(options), locals, &block)
  end

  def prepare(options) # :nodoc:
    case options
    when String
      {:file => options}
    when nil
      {:file => file_to_render}
    else
      options
    end
  end

  def helpers
    ::Rails.application.routes.named_routes.helpers
  end

  included do
    include RSpec::Rails::ActionViewSandbox
  end

  RSpec.configure do |c|
    c.include self, :example_group => { :file_path => /\bspec\/views\// }
  end

end
