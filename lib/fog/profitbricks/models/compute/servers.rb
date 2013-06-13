require 'fog/core/collection'
require 'fog/profitbricks/models/compute/server'

module Fog
  module Compute
    class ProfitBricks

      class Servers < Fog::Collection

        model Fog::Compute::ProfitBricks::Server

        def all(id)
          data = service.list_servers(id).body
          load(data)
        end

        def get(id)
          return nil if id.nil? || id == ""
          data = service.get_server(id).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
