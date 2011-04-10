module Trinidad
  class Server
    alias :old_load_config :load_config
    def load_config(config)
      old_load_config(config)
      trap_signals
    end

    def trap_signals
      # trap signals and stop tomcat properly to make sure resque is also stopped properly
      trap('INT') { tomcat.stop }
      trap('TERM') { tomcat.stop }
    end
  end

  class WebApp
    def app
      @config[:app]
    end
  end

  module Lifecycle
    class Default < Base
      def configure_rack_servlet(context)
        wrapper = context.create_wrapper

        rack = Trinidad::Rack::RackServlet.new
        rack.rackup(@webapp.app)
        wrapper.servlet = rack
        wrapper.name = 'RackServlet'

        context.add_child(wrapper)
        context.add_servlet_mapping('/*', wrapper.name)
      end
      def configure_rack_listener(context)
        # we need to disable this method to ensure trinidad doesn't load any
        # application listener
      end
    end
  end
end
