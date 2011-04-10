require 'rack'
require 'trinidad'

module Rack
  module Handler
    class Trinidad
      def self.run(app, options={})
        opts = options.dup
        opts[:app] = app
        opts[:port] = 3000
        opts[:address] = (options[:Host] || 'localhost')
        ::Trinidad::Server.new(opts).start
      end
    end
  end
end

Rack::Handler.register 'trinidad', 'Rack::Handler::Trinidad'
