require 'fog/compute/models/server'

module Fog
  module Compute
    class ProfitBricks

      class Server < Fog::Compute::Server

        identity  :id,                   :aliases => 'serverId'
        
        attribute :name,                 :aliases => 'serverName'
        attribute :created,              :aliases => 'creationTime'
        attribute :modified,             :aliases => 'lastModificationTime'
        attribute :state,                :aliases => 'provisioningState'
        attribute :zone,                 :aliases => 'availabilityZone'
        attribute :os_type,              :aliases => 'osType'
        
        attribute :vm_state,             :aliases => 'virtualMachineState'
        attribute :cores,                :aliases => 'cores', :type => :integer
        attribute :ram,                  :aliases => 'ram', :type => :integer

        attribute :online,               :aliases => 'internetAccess', :type => :boolean
        attribute :ips,                  :type => :array
        attribute :lan_id,               :aliases => 'lanId', :type => :integer

        attribute :storage_ids,          :aliases => 'storageId', :type => :array
        attribute :rom_drives,           :aliases => 'romDrives'

        attribute :boot_from_image_id,   :aliases => 'bootFromImageId'
        attribute :boot_from_storage_id, :aliases => 'bootFromStorageId'

        attribute :datacenter_id,        :aliases => 'dataCenterId'
        attribute :request_id,           :aliases => 'requestId'

        def save
          requires :cores
          requires :ram

          options = {
            :cores => cores,
            :ram => ram,
            :datacenter_id => datacenter_id,
            :name => name,
            :boot_from_image_id => boot_from_image_id,
            :boot_from_storage_id => boot_from_storage_id,
            :lan_id => lan_id,
            :online => online,
            :zone => zone,
            :os_type => os_type,
          }.delete_if {|k,v| v.nil? || v == "" }

          options = Hash[options.map { |k, v| [attr_translate[k], v] if attr_translate.has_key? k }]

          data = service.create_server(options)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          service.delete_server(id)
          true
        end

        def update(options={})
          ## Ensure id is part of the hash
          requires :id
          options.merge!(id: id)

          ## Get the aliases from class method and switch hash keys
          #attr_translation = self.class.aliases.invert
          options = Hash[options.map { |k, v| [attr_translate[k], v] }]

          service.update_server(options)
          true
        end

        def clear
          requires :id
          service.clear_datacenter(id)
          true
        end

        def provisioned?
          self.state == 'AVAILABLE'
        end

        def running?
          self.vm_state == 'RUNNING'
        end

        def ready?
          self.provisioned? and self.running?
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

        private

        def attr_translate
          self.class.aliases.invert
        end
        
      end

    end
  end
end
