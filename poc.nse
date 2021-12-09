local http = require "http"

portrule = function(host, port) return true end

action = function(host, port)
    local response = http.get_url("https://raw.githubusercontent.com/righel/nmap_http_cache_bug/main/random_2mb", {max_body_size = -1})
    
    return ("status: %s size: %s"):format(response.status, #response.body)
end
