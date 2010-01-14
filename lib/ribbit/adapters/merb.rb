module Ribbit
  module Adapters
    class Merb < Adapter

      def initialize(config)
        super(config)
        config.environment_name = ::Merb.env
        config.project_root = ::Merb.root
      end

      def logger
        ::Merb.logger
      end

      def activate!
        ::Merb::BootLoader.after_app_loads do
          ::Merb::AbstractController.send(:include, ControllerMixin)
          if configuration.automatic?
            ::Merb::Dispatcher::DefaultException.send(:include, ControllerMixin)
            ::Merb::Dispatcher::DefaultException.send(:include, DefaultExceptionExtensions)
          end
        end
      end

      module ControllerMixin
        protected

        def notify_hoptoad(ex=nil)
          exceptions = request.exceptions || [ex]
          exceptions.each do |exception|
            Ribbit.notify(exception, {
              :parameters => params,
              :session => session,
              :controller => params[:controller],
              :action => params[:action],
              :url => request.full_uri,
              :cgi_data => ENV.to_hash.merge(request.env)
            })
          end
        end
      end # ControllerMixin

      module DefaultExceptionExtensions
        def self.included(mod)
          mod.class_eval do
            before :notify_hoptoad
          end
        end
      end

    end # class Merb
  end # module Adapters
end # module Ribbit
