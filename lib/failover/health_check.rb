module Failover
  class HealthCheck
    HTTP_OPTS = {
      open_timeout: (ENV['OPEN_TIMEOUT'] || 30).to_i,
      read_timeout: (ENV['READ_TIMEOUT'] || 30).to_i
    }

    def initialize(url)
      @url = url
    end

    def healthy?
      code = ""

      begin
        uri = URI.parse(@url)
        res = Net::HTTP.start(uri.host, uri.port, HTTP_OPTS) do |http|
          http.get("" == uri.path ? '/' : uri.path)
        end
        code = res.code
      rescue Exception => e
        # something went wrong with the request, return unhealthy
        $logger.warn("Check for #{@url} failed: #{e}")
        return false
      end

      if "200" != code
        # response code was not 200 OK, return unhealthy
        $logger.warn("Check for #{@url} failed: response code #{code}")
        return false
      end

      # nothing went wrong, return healthy
      return true

      rescue Exception => e
        # in case something went wrong and wasn't caught elsewhere
        return false
    end
  end
end
