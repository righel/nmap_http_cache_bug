## Description
An improper cache invalidation mechanism in the `check_size()` function located in the `http.lua` library leads to an incorrect caching of http requests.

## How to reproduce
Run an NSE script that does a `http.get` or `http.get_url` requesting a resource of `size` > `http.max-cache-size` or `1000000` bytes by default results in the response gets cached temporarily and then when `check_size()` function is called, the contents of the cache record are set to `0`, however, the key is not removed from the cache table. 

When the script is run on the next target `lookup_cache()` returns a match, with status `200` and empty content.
The bug can also be triggered with the n-th request that exceeds the `max-cache-size`, which can be a small request.

To avoid this bug one can simply increment the size `http.max-cache-size` or set the `bypass_cache` / `no_cache` options to `true` in the request.


### Impacted functions
* `http.get` 
* `http.get_url`

### PoC:
```
$ nmap -p 80 --script poc.nse -iL targets.txt
Starting Nmap 7.80 ( https://nmap.org ) at 2021-12-09 08:34 CET
Nmap scan report for localhost (127.0.0.1)
Host is up (0.000025s latency).

PORT   STATE SERVICE
80/tcp open  http

Nmap scan report for localhost (127.0.0.1)
Host is up (0.000081s latency).

PORT   STATE SERVICE
80/tcp open  http
|_poc: status: 200 size: 2097152
|_poc: status: 200 size: 0

Nmap done: 2 IP addresses (2 hosts up) scanned in 0.18 seconds
```
