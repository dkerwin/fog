require 'fog/core/model'

module Fog
  module Compute
    class ProfitBricks

      class Datacenter < Fog::Model

        identity  :id,            :aliases => :dataCenterId
        
        attribute :name,          :aliases => :dataCenterName
        attribute :version,       :aliases => :dataCenterVersion
        attribute :state,         :aliases => :provisioningState
        attribute :region

        attribute :servers
        attribute :storages
        attribute :loadbalancers, :aliases => :loadBalancers

        attribute :request_id,    :aliases => :requestId

        def save
          requires :name, :region
          data = service.create_datacenter(name, region)
          merge_attributes(data.body)
          true
        end

        def destroy
          requires :id
          service.delete_datacenter(id)
          true
        end

        def update(options={})
          requires :id
          options.merge!(id: id)

          ## Get the aliases from class method and switch hash keys
          #attr_translation = self.class.aliases.invert
          options = Hash[options.map { |k, v| [attr_translate[k], v] }]

          service.update_datacenter(options)
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

        def attr_translate
          self.class.aliases.invert
        end

        ## Ensure some attributes are arrays if only a single result is returned.
        ## Methods are dynamically created
        [:servers, :storages, :loadbalancers].each do |attr|
          define_method "#{attr}" do 
            [attributes[attr]].flatten unless attributes[attr].nil?
          end
        end

      end

    end
  end
end
