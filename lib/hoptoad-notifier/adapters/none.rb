module HoptoadNotifier
  module Adapters
    class None < Adapter

      # This should provide something that implements the logger interface
      def logger
        @logger ||= Logger.new(STDOUT)
      end

      # This should perform the steps to integrate hoptoad catching into the framework
      def activate!
        
      end

    end
  end
end
