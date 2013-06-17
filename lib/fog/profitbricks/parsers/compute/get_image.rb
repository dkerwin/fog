module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class GetImage < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'imageId', 'imageName', 'imageType', 'writeable', 'cpuHotpluggable',
                 'memoryHotpluggable', 'serverIds', 'region', 'osType'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
