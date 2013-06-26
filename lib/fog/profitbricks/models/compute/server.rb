require 'fog/compute/models/server'
require 'fog/profitbricks/models/compute/base'

module Fog
  module Compute
    class ProfitBricks

      class Server < Fog::Compute::Server

        include Fog::Compute::ProfitBricks::Base

        identity  :id,                   :aliases => :serverId
        
        attribute :name,                 :aliases => :serverName
        attribute :created,              :aliases => :creationTime
        attribute :modified,             :aliases => :lastModificationTime
        attribute :state,                :aliases => :provisioningState
        attribute :zone,                 :aliases => :availabilityZone
        attribute :os_type,              :aliases => :osType
        
        attribute :vm_state,             :aliases => :virtualMachineState
        attribute :cores,                :aliases => :cores, :type => :integer
        attribute :ram,                  :aliases => :ram, :type => :integer

        attribute :online,               :aliases => :internetAccess, :type => :boolean
        attribute :ips,                  :type => :array
        attribute :nics,                 :aliases =>  :nics

        attribute :storages,             :aliases => :connectedStorages
        attribute :rom_drives,           :aliases => :romDrives

        attribute :boot_from_image_id,   :aliases => :bootFromImageId
        attribute :boot_from_storage_id, :aliases => :bootFromStorageId

        attribute :datacenter_id,        :aliases => :dataCenterId
        attribute :request_id,           :aliases => :requestId

        def save
          requires :cores, :ram

          options = {
            :cores                => cores,
            :ram                  => ram,
            :datacenter_id        => datacenter_id,
            :name                 => name,
            :boot_from_image_id   => boot_from_image_id,
            :boot_from_storage_id => boot_from_storage_id,
            :online               => online,
            :zone                 => zone,
            :os_type              => os_type,
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

        ## Manual sqash for servers, storages and loadbalancers. Return entire hash
        ## and aliases in subkeys don't work. Will return array of *id's.
        ## Methods are dynamically created
        [[:storages, :storageId], [:nics, :nicId]].each do |attr|
          define_method "#{attr[0]}" do
            result = []

            ## Return empty result if response im empty
            return result if attributes[attr[0]].nil?

            [attributes[attr[0]]].flatten.each do |a|
              result << a[attr[1]]
            end
            result
          end
        end
        
      end

    end
  end
end
