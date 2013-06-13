module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class GetDatacenter < Fog::Parsers::Base

          def reset
            @servers  = []
            @storages = []
            @response = {}
          end

          def end_element(name)
            case name
            when 'dataCenterId', 'dataCenterName', 'dataCenterVersion', 'provisioningState', 'region'
              @response[name] = value
            when 'serverId'
              @servers << value
            when 'storageId'
              @storages << value
            when 'return'
              @response['servers'] = @servers.uniq!
              @response['storages'] = @storages.uniq!
              @servers  = []
              @storages = []
            end
          end

        end

      end
    end
  end
end
