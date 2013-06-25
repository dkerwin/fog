require 'fog/core/collection'
require 'fog/profitbricks/models/compute/datacenter'

module Fog
  module Compute
    class ProfitBricks

      class Datacenters < Fog::Collection

        model Fog::Compute::ProfitBricks::Datacenter

        def all
          data = [service.list_datacenters.body].flatten
          load(data)
        end

        def get(id)
          return nil if id.nil? || id == ""
          data = service.get_datacenter(id).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
