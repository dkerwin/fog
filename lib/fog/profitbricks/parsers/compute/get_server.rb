module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class GetServer < Fog::Parsers::Base

          def reset
            @ips         = []
            @storage_ids = []
            @response    = {}
          end

          def end_element(name)
            case name
            when 'serverName', 'creationTime', 'lastModificationTime', 'provisioningState', 'virtualMachineState', 'requestId',
                 'cores', 'ram', 'internetAccess', 'connectedStorages', 'availabilityZone', 'romDrives', 'osType'
              @response[name] = value
            when 'ips'
              @ips << value
            when 'storageId'
              @storage_ids << value
            when 'return'
              @response['ips']  = @ips.uniq!
              @response['storage_ids'] = @storage_ids

              @ips  = []
              @storage_ids = []
            end
          end

        end

      end
    end
  end
end
