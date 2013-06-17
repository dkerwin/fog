require 'fog/core/model'

module Fog
  module Compute
    class ProfitBricks

      class Image < Fog::Model

        identity  :id,          :aliases => 'imageId'

        attribute :name,        :aliases => 'imageName'
        attribute :type,        :aliases => 'imageType'
        attribute :writeable
        attribute :region

        attribute :cpu_hotplug, :aliases => 'cpuHotpluggable'
        attribute :mem_hotplug, :aliases => 'memoryHotpluggable'
        attribute :server_ids,  :aliases => 'serverIds'
                
        attribute :request_id,  :aliases => 'requestId'

        def set_os_type
          raise Fog::Errors::NotImplemented.new("Please implement the #set_os_type method")
        end          
                
      end

    end
  end
end
