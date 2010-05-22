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
  #   render(:template => "widgets/new.html.erb")
  #   render({:partial => "widgets/widget.html.erb"}, {... locals ...})
  #   render({:partial => "widgets/widget.html.erb"}, {... locals ...}) do ... end
  #
  # Delegates to ActionView::Base#render, so see documentation on that for more
  # info.
  #
  # The only addition is that you can call render with no arguments, and RSpec
  # will pass the top level description to render:
  #
  #   describe "widgets/new.html.erb" do
  #     it "shows all the widgets" do
  #       render # => view.render(:file => "widgets/new.html.erb")
  #       ...
  #     end
  #   end
  def render(options = nil, locals = {}, &block)
    options ||= {:file => file_to_render}
    @response = view.render(options, locals, &block)
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
