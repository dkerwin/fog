require 'fog/core/collection'
require 'fog/profitbricks/models/compute/disk'

module Fog
  module Compute
    class ProfitBricks

      class Disks < Fog::Collection

        model Fog::Compute::ProfitBricks::Disk

        def all
          raise ArgumentError.new("Please use datacenters.get(DATACENTER_ID).storages instead")
        end

        def get(id)
          return nil if id.nil? || id == ""
          data = service.get_storage(id).body

          ## FIXME: ugly workaround but it's required to have the id in the server object
          ## Should be returned by PB API
          data[:id] = id

          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
