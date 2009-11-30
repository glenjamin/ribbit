module HoptoadNotifier
  module Adapters
    class Adapter

      attr_accessor :configuration

      class << self
        def inherited(klass)
          HoptoadNotifier::Adapters.add_adapter klass
        end
      end

      def initialize(config)
        self.configuration = config
      end

      # This should provide something that implements the logger interface
      def logger
        raise NotImplementedError
      end

      # This should perform the steps to integrate hoptoad catching into the framework
      def activate!
        raise NotImplementedError
      end

    end
  end
end
