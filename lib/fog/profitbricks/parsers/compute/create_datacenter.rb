module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class CreateDatacenter < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'dataCenterId', 'region'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
