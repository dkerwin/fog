require 'fog/profitbricks'
require 'fog/compute'

module Fog
  module Compute
    class ProfitBricks < Fog::Service

      API_URL = "https://api.profitbricks.com/"

      requires :profitbricks_username, :profitbricks_password
      recognizes :profitbricks_api_url, :persistent

      model_path 'fog/profitbricks/models/compute'
      model      :datacenter
      collection :datacenters
      model      :server
      collection :servers
      model      :image
      collection :images

      request_path 'fog/profitbricks/requests/compute'

      ## Datacenter
      request :list_datacenters
      request :get_datacenter
      request :create_datacenter
      request :delete_datacenter
      request :clear_datacenter
      request :update_datacenter

      ## Server
      request :get_server
      request :delete_server
      request :update_server
      request :create_server
      request :start_server
      request :shutdown_server
      request :reboot_server
      request :poweroff_server
      request :reset_server

      ## Image
      request :list_images
      request :get_image

      ## Storage

      ## Loadbalancer

      class Mock

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {}
          end
        end

        def self.reset
          @data = nil
        end

        def initialize(options={})
          @bare_metal_cloud_username = options[:bare_metal_cloud_username]
        end

        def data
          self.class.data[@bare_metal_cloud_username]
        end

        def reset_data
          self.class.data.delete(@bare_metal_cloud_username)
        end

      end

      class Real

        def initialize(options={})
          require 'fog/core/parser'

          @username = options[:profitbricks_username] || Fog.credentials[:profitbricks_username]
          @password = options[:profitbricks_password] || Fog.credentials[:profitbricks_password]
          @api_url  = options[:profitbricks_api_url]  || Fog.credentials[:profitbricks_api_url] || API_URL
          @persistent = options[:persistent] || false
          @connection_options = options[:connection_options] || {:debug_request => true, :debug_response => true}

          @connection = Fog::Connection.new(@api_url, @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          key = "#{@username}:#{@password}"
          params[:headers] = { "Authorization" => "Basic #{Base64.encode64(key).delete("\r\n")}", 
                               "Content-Type"  => "text/xml;charset=utf-8",
                               "Accept"        => "text/xml;charset=utf-8",
                             }

          body = <<-EOI
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.api.profitbricks.com/">
  <soapenv:Header>
  </soapenv:Header>
  <soapenv:Body>
    #{params[:body]}
  </soapenv:Body>
</soapenv:Envelope>
EOI
          
          params[:body] = body

          begin
            response = @connection.request(params)
          rescue Excon::Errors::HTTPStatusError => error
            errors = { :http_code => error.response.status, :fault_code => nil, :fault => nil, :message => nil }
            parser = { :http => /(?:<httpCode>(\d+)<\/httpCode>)/,
                       :fault_code => /(?:<faultCode>(.+)<\/faultCode>)/,
                       :fault => /(?:<faultstring>(.+)<\/faultstring>)/,
                       :message => /(?:<message>(.*)<\/message>)/
                     }

            parser.each do |type, rx|
              if match = error.response.body.match(rx)
                errors[type] = match[1]
              end
            end

            if errors[:message]
              m = errors[:message]
            else
              m = errors[:fault]
            end

            message = "HTTP error #{errors[:http_code]} => #{errors[:fault_code]}: #{m}"

            raise case  errors[:fault]
            when 'RESOURCE_NOT_FOUND'
              Fog::Compute::ProfitBricks::NotFound.slurp(error, message)
            else
              Fog::Compute::ProfitBricks::Error.slurp(error, message)
            end
          end

          response
        end

      end
    end
  end
end
