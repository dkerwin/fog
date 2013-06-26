require 'fog/core/model'

module Fog
  module Compute
    class ProfitBricks

      class Image < Fog::Model

        identity  :id,          :aliases => :imageId

        attribute :name,        :aliases => :imageName
        attribute :type,        :aliases => :imageType
        attribute :writeable,   :type => :boolean
        attribute :region

        attribute :cpu_hotplug, :aliases => :cpuHotpluggable, :type => :boolean
        attribute :mem_hotplug, :aliases => :memoryHotpluggable, :type => :boolean
        attribute :server_ids,  :aliases => :serverIds
                
        attribute :request_id,  :aliases => :requestId

        def set_os_type
          raise Fog::Errors::NotImplemented.new("Please implement the #set_os_type method")
        end

        [[:server_ids, :serverIds]].each do |attr|
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
