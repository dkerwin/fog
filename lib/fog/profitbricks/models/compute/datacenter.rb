require 'fog/core/model'

module Fog
  module Compute
    class ProfitBricks

      class Datacenter < Fog::Model

        identity  :id,       :aliases => 'dataCenterId'
        
        attribute :name,     :aliases => 'dataCenterName'
        attribute :version,  :aliases => 'dataCenterVersion'
        attribute :state,    :aliases => 'provisioningState'
        attribute :region

        attribute :request_id, :aliases => 'requestId'

        def save
          requires :name
          requires :region
          p = service.create_datacenter(name, region).body
        end

        def destroy
          requires :id
          service.delete_datacenter(id)
          true
        end

        def update
          requires :id
          requires :name
          service.update_datacenter(id, name)
          true
        end

        def clear
          requires :id
          service.clear_datacenter(id)
          true
        end

        def ready?
          self.state == 'AVAILABLE'
        end

        def servers
          requires :id
          service.get_datacenter(id).body['servers']
        end

        def storages
          requires :id
          service.get_datacenter(id).body['storages']
        end
        
      end

    end
  end
end
