# myjsonip.com

This is a site that allows you to quickly get information relative to your hosts. IP address and agent are the only things
implemented so far.


## How to use the site

You are able to query the site for your WAN IP address and it will return json (default) or yaml depending on the route.

| HTTP Method | URI         | What is returned?  | Format |
|:------------|:------------|:-------------------|:-------|
| GET         | /           | IP Address         | json   |
| GET         | /yaml       | IP Address         | yaml   |
| GET         | /agent      | Agent              | json   |
| GET         | /agent/yaml | Agent              | yaml   |
| GET         | /all        | IP Address + Agent | json   |
| GET         | /all/yaml   | IP Address + Agent | yaml   |


## I have x (multiple) IPs on my server with NATs, how can I leverage this site to get their WAN IP?

    require 'net/http'
    require 'json'
    require 'resolv'
    require 'socket'
    
    # Grab all interfaces that have valid IPv4 addresses
    interfaces = Socket.getifaddrs.map do |i|
      next if i.addr.ipv4_loopback? || i.addr.ipv6_loopback?
      next unless i.addr.ipv4?
      x = [ i.name, i.addr.ip_address ]
      x
    end.compact
    
    # Build hash for looking up interface names by IP
    ip_to_int = interfaces.inject({}) do |memo,x|
      name   = x[0]
      lan_ip = x[1]
      memo[lan_ip] = name
      memo
    end
    
    # Parse the command line to see if any IP addresses where passed.
    ip_addresses = ARGV.each.map do |x|
      if x =~ Resolv::IPv4::Regex && ip_to_int.keys.include?(x)
        x
      else
        next
      end
    end.compact
    
    # If no IP addresses where passed, grab the WAN IP of all interfaces
    ip_addresses = interfaces.map { |x| x[1] } if ip_addresses.empty?
    
    # Setup our http connection. This is used to discover the public/WAN IP.
    uri  = URI('http://myjsonip.com/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 2
    http.read_timeout = 2
    
    ip_addresses.each do |ip|
      failed_request = false
      no_ip = false
      lan_ip = ip
      interface_name = ip_to_int[lan_ip]
    
      # This makes sure we use this interface when making outbound connections.
      http.local_host = lan_ip
    
      begin
        res = http.get('/')
      rescue Net::OpenTimeout, Errno::EHOSTUNREACH, Errno::ECONNREFUSED => e
        failed_request = true
        no_ip = true
      end
    
      wan_ip   = JSON.load(res.body)['ip'] unless failed_request
      # If the WAN IP is 50.56.18.108 it means that no NAT is setup and it's defaulting to our firewall's IP.
      wan_ip = nil if no_ip
      puts "%s:%s:%s" % [interface_name, lan_ip, wan_ip]
    end

## Contributing

1. Fork it ( https://github.com/jasonwbarnett/myjsonip.com/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
