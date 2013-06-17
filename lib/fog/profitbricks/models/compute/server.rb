require 'fog/core/model'

module Fog
  module Compute
    class ProfitBricks

      class Server < Fog::Model

        identity  :id,        :aliases => 'serverId'
        
        attribute :name,      :aliases => 'serverName'
        attribute :created,   :aliases => 'creationTime'
        attribute :modified,  :aliases => 'lastModificationTime'
        attribute :state,     :aliases => 'provisioningState'
        attribute :zone,      :aliases => 'availabilityZone'
        attribute :os_type,   :aliases => 'osType'
        
        attribute :vm_state,  :aliases => 'virtualMachineState'
        attribute :cores
        attribute :ram

        attribute :online,    :aliases => 'internetAccess'
        attribute :ips,       :type => :array

        attribute :storage_ids, :aliases => 'storageId', :type => :array
        attribute :romdrives, :aliases => 'romDrives'

        attribute :request_id, :aliases => 'requestId'

        def save
          requires :name
          requires :region
          date = service.create_server(name, region)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          service.delete_server(id)
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
        
      end

    end
  end
end
