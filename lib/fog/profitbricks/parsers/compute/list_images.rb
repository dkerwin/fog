module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class ListImages < Fog::Parsers::Base

          def reset
            @image = {}
            @response = { 'images' => [] }
          end

          def end_element(name)
            case name
            when 'imageId', 'imageName', 'imageType', 'writeable', 'cpuHotpluggable',
                 'memoryHotpluggable', 'serverIds', 'region', 'osType'
              @image[name] = value
            when 'return'
              @response['images'] << @image
              @image= {}
            end
          end

        end

      end
    end
  end
end
