module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class GetDatacenter < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'dataCenterId', 'dataCenterName', 'dataCenterVersion', 'provisioningState', 'region'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
