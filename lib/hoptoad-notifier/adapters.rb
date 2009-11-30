module HoptoadNotifier
  module Adapters
    class << self

      attr_accessor :adapters

      # Register a new adapter - you do not need to call this directly if subclassing Adapter
      def add_adapter(adapter)
        self.adapters << adapter
      end

      def load_adapter(name)
        require_adapter!(name)
        adapter_class_name = name.to_s.capitalize
        HoptoadNotifier::Adapters.const_get(adapter_class_name) rescue nil
      end

      private

      def adapter_path(name)
        name = name.to_s.lower
        File.join(File.dirname(__FILE__), 'adapters', "#{name}.rb")
      end

      def require_adapter!(name)
        begin
          require adapter_path(name)
        rescue LoadError
          false
        end
      end

    end
  end
end
