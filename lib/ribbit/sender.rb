require 'net/http'
require 'net/https'

module Ribbit
  # Sends out the notice to Hoptoad
  class Sender

    NOTICES_URI = '/notifier_api/v2/notices/'.freeze
    HEADERS = {
      'Content-type' => 'text/xml',
      'Accept' => 'text/xml, application/xml'
    }

    def initialize(options = {})
      [:proxy_host, :proxy_port, :proxy_user, :proxy_pass, :protocol,
        :host, :port, :secure, :http_open_timeout, :http_read_timeout].each do |option|
        instance_variable_set("@#{option}", options[option])
      end
    end

    # Sends the notice data off to Hoptoad for processing.
    #
    # @param [String] data The XML notice to be sent off
    def send_to_hoptoad(data)
      log :debug, "Sending request to #{url.to_s}:\n#{data}"

      http =
        Net::HTTP::Proxy(proxy_host, proxy_port, proxy_user, proxy_pass).
        new(url.host, url.port)

      http.read_timeout = http_read_timeout
      http.open_timeout = http_open_timeout
      http.use_ssl      = secure

      response = begin
                   http.post(url.path, data, HEADERS)
                 rescue TimeoutError => e
                   log :error, "Timeout while contacting the Hoptoad server."
                   nil
                 end

      case response
      when Net::HTTPSuccess then
        log :info, "Success: #{response.class}"
        log :debug, "Response Body: #{response.body}"
      else
        log :error, "Failure: #{response.class}"
        log :debug, "Response Body: #{response.body}"
      end
    end

    private

    attr_reader :proxy_host, :proxy_port, :proxy_user, :proxy_pass, :protocol,
      :host, :port, :secure, :http_open_timeout, :http_read_timeout

    def url
      URI.parse("#{protocol}://#{host}:#{port}").merge(NOTICES_URI)
    end

    def log(level, message)
      logger.send level, LOG_PREFIX + message if logger
    end

    def logger
      Ribbit.logger
    end

  end
end
