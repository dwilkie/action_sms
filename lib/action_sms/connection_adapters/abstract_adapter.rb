require 'net/https'

module ActionSms #:nodoc:
  module ConnectionAdapters #:nodoc:
    # All the concrete gateway adapters follow the interface laid down in this
    # class.  You can use this interface directly by borrowing the gateway
    # connection from the Base with Base.connection.
    class AbstractAdapter
      protected
        # Helper method to send an HTTP POST request to +url+ with paramaters
        # specified by the +params+ hash.
        def send_http_request(url, params)
          uri = URI.parse(url)
          req = Net::HTTP::Post.new(uri.path)
          req.set_form_data(params)

          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true if uri.scheme == 'https'
          resp = http.start do
            http.request(req)
          end
          resp.body
        end
    end
  end
end

