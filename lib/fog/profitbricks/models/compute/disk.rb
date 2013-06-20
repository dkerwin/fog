require 'fog/core/model'

module Fog
  module Compute
    class ProfitBricks
      class Disk < Fog::Model

        identity  :id,                   :aliases => 'storageId'
        
        attribute :name,                 :aliases => 'storageName'
        attribute :created,              :aliases => 'creationTime'
        attribute :modified,             :aliases => 'lastModificationTime'
        attribute :state,                :aliases => 'provisioningState'

        attribute :size,                 :aliases => 'size', :type => :integer
        attribute :image,                :aliases => 'mountImage'
        attribute :image_id,             :aliases => 'mountImageId'
        attribute :image_password,       :aliases => 'profitBricksImagePassword'
        attribute :bus_type,             :aliases => 'busType'

        attribute :os_type,              :aliases => 'osType'
        
        attribute :server_id,            :aliases => 'serverId'
        attribute :datacenter_id,        :aliases => 'dataCenterId'
        attribute :request_id,           :aliases => 'requestId'

        def save
          requires :size

          options = {
            :size           => size,
            :name           => name,
            :datacenter_id  => datacenter_id,
            :image_id       => image_id,
            :image_password => image_password,
          }.delete_if {|k,v| v.nil? || v == "" }

          options = Hash[options.map { |k, v| [attr_translate[k], v] if attr_translate.has_key? k }]

          data = service.create_storage(options)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          service.delete_storage(id)
          true
        end

        def update(options={})
          ## Ensure id is part of the hash
          requires :id
          options.merge!(id: id)

          ## Get the aliases from class method and switch hash keys
          #attr_translation = self.class.aliases.invert
          options = Hash[options.map { |k, v| [attr_translate[k], v] }]

          service.update_storage(options)
          true
        end

        def connect(options={})
          requires :id
          options.merge!(id: id)

          raise ArgumentError.new('Missing key :server_id') if options[:server_id].nil?

          ## Get the aliases from class method and switch hash keys
          options = Hash[options.map { |k, v| [attr_translate[k], v] }]

          service.connect_storage(options)
          true
        end

        def disconnect(options={})
          requires :id
          options.merge!(id: id)

          raise ArgumentError.new('Missing key :server_id') if options[:server_id].nil?

          ## Get the aliases from class method and switch hash keys
          options = Hash[options.map { |k, v| [attr_translate[k], v] }]

          service.disconnect_storage(options)
          true
        end

        def provisioned?
          self.state == 'AVAILABLE'
        end

        def ready?
          self.provisioned?
        end

        private

        def attr_translate
          self.class.aliases.invert
        end
        
      end

    end
  end
end
