module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class CreateStorage < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'storageId', 'requestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
