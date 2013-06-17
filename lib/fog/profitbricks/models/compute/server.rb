require 'fog/compute/models/server'

module Fog
  module Compute
    class ProfitBricks

      class Server < Fog::Compute::Server

        identity  :id,          :aliases => 'serverId'
        
        attribute :name,        :aliases => 'serverName'
        attribute :created,     :aliases => 'creationTime'
        attribute :modified,    :aliases => 'lastModificationTime'
        attribute :state,       :aliases => 'provisioningState'
        attribute :zone,        :aliases => 'availabilityZone'
        attribute :os_type,     :aliases => 'osType'
        
        attribute :vm_state,    :aliases => 'virtualMachineState'
        attribute :cores
        attribute :ram

        attribute :online,      :aliases => 'internetAccess', :type => :boolean
        attribute :ips,         :type => :array

        attribute :storage_ids, :aliases => 'storageId', :type => :array
        attribute :rom_drives,  :aliases => 'romDrives'

        attribute :request_id,  :aliases => 'requestId'

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

        ## FIXME: WIP
        def update
          requires :id
          options = {
            :id => id
            :name => name,
            :cores => cores,
            :ram => ram,
            #:bootFromImageId => bootFromImageId
            :zone => zone,
            #:bootFromStorageId => bootFromStorageId
            :type => type
          }.delete_if {|k,v| v.nil? || v == "" }

          service.update_server(options)
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

        def start
          requires :id
          service.start_server(id)
          true
        end

        def start
          requires :id
          service.start_server(id)
          true
        end

        def shutdown
          requires :id
          service.shutdown_server(id)
          true
        end

        def poweroff
          requires :id
          service.poweroff_server(id)
          true
        end

        def reboot
          requires :id
          service.reboot_server(id)
          true
        end

        def reset
          requires :id
          service.reset_server(id)
          true
        end
        
      end

    end
  end
end
