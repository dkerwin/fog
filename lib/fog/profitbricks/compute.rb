require 'fog/profitbricks'
require 'fog/compute'

module Fog
  module Compute
    class ProfitBricks < Fog::Service

      requires :profitbricks_password, :profitbricks_username
      #recognizes :host, :port, :scheme, :persistent

      model_path 'fog/profitbricks/models/compute'
      model       :datacenter
      collection  :datacenters

      request_path 'fog/profitbricks/requests/compute'
      request :list_datacenters

      request :get_datacenter
      request :create_datacenter
      request :delete_datacenter
      request :clear_datacenter
      request :update_datacenter

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

          @profitbricks_password = options[:profitbricks_password]
          @profitbricks_username = options[:profitbricks_username]
          @connection_options = options[:connection_options] || {:debug_request => true, :debug_response => true}
          @host       = options[:host]        || "api.profitbricks.com"
          @persistent = options[:persistent]  || false
          @port       = options[:port]        || 443
          @scheme     = options[:scheme]      || 'https'
          @connection = Fog::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def reload
          @connection.reset
        end

        def request(params)
          key = "#{@profitbricks_username}:#{@profitbricks_password}"
          params[:headers] = { "Authorization" => "Basic #{Base64.encode64(key).delete("\r\n")}", 
                               "Content-Type"  => "text/xml",
                               "Accept"        => "text/xml",
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
            response = @connection.request(params.merge!({:host => @host}))
            puts "RESPONSE == #{response.body}"
          rescue Excon::Errors::HTTPStatusError => error
            raise case error
            when Excon::Errors::NotFound
              Fog::Compute::BareMetalCloud::NotFound.slurp(error)
            else
              error
            end
          end

          response
        end

      end
    end
  end
end
