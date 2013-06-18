module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class CreateServer < Fog::Parsers::Base

          def reset
            @response = {}
          end

          def end_element(name)
            case name
            when 'serverId', 'requestId'
              @response[name] = value
            end
          end

        end

      end
    end
  end
end
