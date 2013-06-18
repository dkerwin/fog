module Fog
  module Compute
    class ProfitBricks
      class Real

        # Boot a new server
        #
        # ==== Parameters
        # * planId<~String> - The id of the plan to boot the server with
        # * options<~Hash>: optional extra arguments
        #   * imageId<~String>  - Optional image to boot server from
        #   * name<~String>     - Name to boot new server with
        #
        # ==== Returns
        # * response<~Excon::Response>:
        #   * body<~Hash>:
        #     * 'server'<~Hash>:
        #       * 'id'<~String> - Id of the image
        #
        def delete_storage(id)
          request(
            :expects => 200,
            :method  => 'POST',
            :path    => '/1.2',
            :body    => %Q{<ws:deleteStorage><storageId>#{id}</storageId></ws:deleteStorage>}
          )
        end

      end
    end
  end
end
