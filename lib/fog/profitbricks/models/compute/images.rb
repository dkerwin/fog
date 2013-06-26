require 'fog/core/collection'
require 'fog/profitbricks/models/compute/image'

module Fog
  module Compute
    class ProfitBricks

      class Images < Fog::Collection

        model Fog::Compute::ProfitBricks::Image

        def all
          data = service.list_images.body
          load(data)
        end

        def get(id)
          return nil if id.nil? || id == ""
          data = service.get_image(id).body
          new(data)
        rescue Excon::Errors::NotFound
          nil
        end

      end

    end
  end
end
