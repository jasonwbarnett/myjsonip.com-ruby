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

## Contributing

1. Fork it ( https://github.com/jasonwbarnett/myjsonip.com/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
