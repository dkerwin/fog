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

      request_path 'fog/profitbricks/requests/compute'
      request :list_datacenters

      request :get_datacenter
      request :create_datacenter
      request :delete_datacenter
      request :clear_datacenter
      request :update_datacenter

      request :get_server

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
          @connection_options = options[:connection_options] || {} #{:debug_request => true, :debug_response => true}

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
            #puts "RESPONSE == #{response.body}"
          rescue Excon::Errors::HTTPStatusError => error
            if match = error.response.body.match(/(?:<faultCode>(.+)<\/faultCode>).*(?:<httpCode>(.*)<\/httpCode>).*(?:<message>(.*)<\/message>)/m)
              
              # match[1]: API fault code | match[2]: HTTP status code | match[3]: Error message 
              raise case match[1]
                when 'RESOURCE_NOT_FOUND'
                  Fog::Compute::ProfitBricks::NotFound.slurp(error, "HTTP code #{match[2]} => #{match[1]}")
                else
                  Fog::Compute::ProfitBricks::Error.slurp(error, "#{match[1]} => #{match[3]}")
                end
              end
            else
              error
            end

          response
        end

      end
    end
  end
end
