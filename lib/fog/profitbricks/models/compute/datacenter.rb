require 'fog/core/model'
require 'fog/profitbricks/models/compute/base'

module Fog
  module Compute
    class ProfitBricks

      class Datacenter < Fog::Model

        include Fog::Compute::ProfitBricks::Base

        identity  :id,            :aliases => :dataCenterId
        
        attribute :name,          :aliases => :dataCenterName
        attribute :version,       :aliases => :dataCenterVersion
        attribute :state,         :aliases => :provisioningState
        attribute :region,        :aliases => :region

        attribute :servers
        attribute :storages
        attribute :loadbalancers, :aliases => :loadBalancers

        attribute :request_id,    :aliases => :requestId

        def save(options={})
          requires :name, :region

          options.merge!(name: name, region: region)
          raise ArgumentError.new("Unknown region '#{region}'") unless ['NORTH_AMERICA', 'EUROPE', 'DEFAULT'].include? options[:region]

          ## Get the aliases from class method and switch hash keys
          options = Hash[options.map { |k, v| [attr_translate[k], v] }]
          
          data = service.create_datacenter(options)
          merge_attributes(data.body)
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

        def destroy
          requires :id
          service.delete_datacenter(id)
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

        ## Manual sqash for servers, storages and loadbalancers. Return entire hash
        ## and aliases in subkeys don't work. Will return array of *id's.
        ## Methods are dynamically created
        [[:servers, :serverId], [:storages, :storageId], [:loadbalancers, :loadBalancerId]].each do |attr|
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
