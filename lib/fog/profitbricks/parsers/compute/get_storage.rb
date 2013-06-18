module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class GetStorage < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'storageId', 'storageName', 'creationTime', 'lastModificationTime', 
                  'provisioningState', 'size', 'osType', 'busType', 'dataCenterId'
              @response[name] = value
            when 'serverIds'
              ## FIXME: Ugly workaround to compensate serverIds from API
              @response['serverId'] = value
            when 'imageId'
              ## FIXME: I'd rather take the image ID instead of the name
              @response['image'] = value
            end
          end

        end

      end
    end
  end
end
