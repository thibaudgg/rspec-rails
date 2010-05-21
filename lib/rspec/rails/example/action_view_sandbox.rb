module RSpec
  module Rails
    module ActionViewSandbox
      extend ActiveSupport::Concern

      class ViewExampleController < ActionController::Base
        attr_accessor :controller_path
      end

      module ViewExtension
        def protect_against_forgery?; end
        def method_missing(selector, *args)
          if controller.respond_to?(selector) || ::Rails.application.routes.named_routes.helpers.include?(selector)
            controller.__send__(selector, *args)
          else
            super(selector, *args)
          end
        end

        def _router
          super() || ::Rails.application.routes
        end
      end

      def controller
        @controller ||= begin
                          controller = ViewExampleController.new
                          controller.controller_path = controller_path
                          controller.request = ActionDispatch::Request.new(Rack::MockRequest.env_for("/url"))
                          controller
                        end
      end

      def view
        @view ||= begin
                    view = ActionView::Base.new(ActionController::Base.view_paths, assigns, controller)
                    view.extend(ActionController::PolymorphicRoutes)
                    view.extend(ViewExtension)
                    view
                  end
      end

      def assign(name, value)
        assigns[name] = value
      end

      def assigns
        @assigns ||= {}
      end

      def method_missing(selector, *args)
        if view.respond_to?(selector) || ::Rails.application.routes.named_routes.helpers.include?(selector)
          view.__send__(selector, *args)
        else
          super
        end
      end

      included do
        include Webrat::Matchers
        include RSpec::Matchers
      end
    end
  end
end
