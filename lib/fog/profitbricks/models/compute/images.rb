require 'fog/core/collection'
require 'fog/profitbricks/models/compute/image'

module Fog
  module Compute
    class ProfitBricks

      class Images < Fog::Collection

        model Fog::Compute::ProfitBricks::Image

        def all(filters = {})
          data = service.list_images.body
          data = data.find_all { |image| (filters.to_a - image.to_a).empty? }
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
