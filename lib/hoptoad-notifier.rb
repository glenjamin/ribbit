require 'hoptoad-notifier/configuration'
require 'hoptoad-notifier/notice'
require 'hoptoad-notifier/sender'
require 'hoptoad-notifier/backtrace'
require 'hoptoad-notifier/adapters'
require 'hoptoad-notifier/adapters/adapter'

module HoptoadNotifier
  CLIENT_NAME = "Glenjamin's Hoptoad Notifier"
  VERSION = "0.1.0.dev"
  API_VERSION = "2.0"
  LOG_PREFIX = "** [Hoptoad] "

  class << self
    # The sender object is responsible for delivering formatted data to the Hoptoad server.
    # Must respond to #send_to_hoptoad. See HoptoadNotifier::Sender.
    attr_accessor :sender

    # A Hoptoad configuration object. Must act like a hash and return sensible
    # values for all Hoptoad configuration options. See HoptoadNotifier::Configuration.
    attr_accessor :configuration

    # The adapter allows different things to happen on different environments
    # Basicially we proxy some methods through to subclasses of
    # HoptoadNotifier::Adapters::Adapter
    attr_accessor :adapter

    # Collection of all existing adapters
    def adapters
      HoptoadNotifier::Adapters.adapters
    end

    # Proxy logger onto the adapter
    def logger
      adapter.logger if adapter
    end

    # Call this method to modify defaults in your initializers.
    #
    # @example
    #   HoptoadNotifier.configure do |config|
    #     config.api_key = '1234567890abcdef'
    #     config.secure = false
    #   end
    def configure(silent = false)
      self.configuration ||= Configuration.new
      yield(configuration)
      self.sender = Sender.new(configuration)
      # Attempt to attach an adapter, either by class or name
      if adapters.include? configuration.adapter
        self.adapter = configuration.adapter.new(configuration)
      elsif configuration.adapter
        adapter_class = HoptoadNotifier::Adapters.load_adapter configuration.adapter
        self.adapter = adapter_class.new(configuration) rescue nil
      end
      self.adapter.activate! if self.adapter
    end

    # Sends an exception manually using this method, even when you are not in a controller.
    #
    # @param [Exception] exception The exception you want to notify Hoptoad about.
    # @param [Hash] opts Data that will be sent to Hoptoad.
    #
    # @option opts [String] :api_key The API key for this project. The API key is a unique identifier that Hoptoad uses for identification.
    # @option opts [String] :error_message The error returned by the exception (or the message you want to log).
    # @option opts [String] :backtrace A backtrace, usually obtained with +caller+.
    # @option opts [String] :request The controller's request object.
    # @option opts [String] :session The contents of the user's session.
    # @option opts [String] :environment ENV merged with the contents of the request's environment.
    def notify(exception, opts = {})
      send_notice(build_notice_for(exception, opts))
    end

    # Sends the notice unless it is one of the default ignored exceptions
    # @see HoptoadNotifier.notify
    def notify_or_ignore(exception, opts = {})
      notice = build_notice_for(exception, opts)
      send_notice(notice) unless notice.ignore?
    end

    private

    def send_notice(notice)
      if configuration.public?
        sender.send_to_hoptoad(notice.to_xml)
      end
    end

    def build_notice_for(exception, opts = {})
      if exception.respond_to?(:to_hash)
        opts = opts.merge(exception)
      else
        opts = opts.merge(:exception => exception)
      end

      Notice.new(configuration.merge(opts))
    end

  end
end
