require 'webrat'
require 'rspec/rails/view_assigns'

module RSpec::Rails
  # Extends ActionView::TestCase::Behavior
  #
  # == Examples
  #
  #   describe "widgets/index.html.erb" do
  #     it "renders the @widgets" do
  #       widgets = [
  #         stub_model(Widget, :name => "Foo"),
  #         stub_model(Widget, :name => "Bar")
  #       ]
  #       assign(:widgets, widgets)
  #       render
  #       rendered.should contain("Foo")
  #       rendered.should contain("Bar")
  #     end
  #   end
  module ViewExampleGroup
    extend  ActiveSupport::Concern

    include RSpec::Rails::SetupAndTeardownAdapter
    include RSpec::Rails::TestUnitAssertionAdapter
    include ActionView::TestCase::Behavior
    include RSpec::Rails::ViewAssigns
    include Webrat::Matchers

    module InstanceMethods
      # :call-seq:
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
      def render(options={}, local_assigns={}, &block)
        options = {:template => _default_file_to_render} if Hash === options and options.empty?
        super(options, local_assigns, &block)
      end

      # The instance of ActionView::Base that is used to render the template.
      # Use this before the +render+ call to stub any methods you want to stub
      # on the view:
      #
      #   describe "widgets/new.html.erb" do
      #     it "shows all the widgets" do
      #       view.stub(:foo) { "foo" }
      #       render
      #       ...
      #     end
      #   end
      def view
        _view
      end

      # Deprecated. Use +view+ instead.
      def template
        RSpec.deprecate("template","view")
        view
      end


      # Deprecated. Use +rendered+ instead.
      def response
        RSpec.deprecate("response", "rendered")
        rendered
      end

    private

      def _default_file_to_render
        example.example_group.top_level_description
      end

      def _controller_path
        _default_file_to_render.split("/")[0..-2].join("/")
      end
    end

    included do
      before do
        controller.controller_path = _controller_path
      end
    end

    RSpec.configure do |c|
      c.include self, :example_group => { :file_path => /\bspec\/views\// }
    end
  end
end
