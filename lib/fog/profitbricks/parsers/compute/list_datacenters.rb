module Fog
  module Parsers
    module Compute
      module ProfitBricks

        class ListDatacenters < Fog::Parsers::Base

          def reset
            @datacenter = {}
            @response = { 'datacenters' => [] }
          end

          def end_element(name)
            case name
            when 'dataCenterId', 'dataCenterName', 'dataCenterVersion'
              @datacenter[name] = value
            when 'return'
              @response['datacenters'] << @datacenter
              @datacenter = {}
            end
          end

        end

      end
    end
  end
end
