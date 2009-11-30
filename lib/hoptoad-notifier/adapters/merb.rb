module HoptoadNotifier
  module Adapters
    class Merb

      def initialize(config)
        super(config)
        config.environment_name = Merb.env
      end

      def logger
        ::Merb.logger
      end

      def activate!
        Merb::Bootloader.after_app_loads do
          Merb::AbstractController.send(:include, ControllerMixin)
          if configuration.automatic?
            Merb::Dispatcher::DefaultException.send(:include, ControllerMixin)
            Merb::Dispatcher::DefaultException.send(:include, DefaultExceptionExtensions)
          end
        end
      end

      module ControllerMixin
        protected

        def notify_hoptoad(ex)
          exceptions = request.execeptions || [ex]
          execeptions.each do |exeception|
            HoptoadNotifier.notify(exeception, {
              :parameters => params,
              :session => session,
              :controller => params[:controller],
              :action => params[:action],
              :url => absolute_url(:this),
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
end # module HoptoadNotifier
