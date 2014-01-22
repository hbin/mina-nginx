# Mina Nginx

[Mina](https://github.com/nadarei/mina) tasks for handle with
[Nginx](http://nginx.com/).

This gem provides several mina tasks:

    mina nginx:link     # Symlinking nginx config file
    mina nginx:parse    # Parse nginx configuration file and upload it to the server
    mina nginx:reload   # Reload Nginx
    mina nginx:restart  # Restart Nginx
    mina nginx:setup    # Setup Nginx
    mina nginx:start    # Start Nginx
    mina nginx:status   # Status Nginx
    mina nginx:stop     # Stop Nginx

## Installation

Add this line to your application's Gemfile:

    gem 'mina-nginx', :require => false

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mina-nginx

## Usage

Add this to your `config/deploy.rb` file:

    require 'mina/nginx'

Make sure the following settings are setted in your `config/deploy.rb`:

* `application` - application name
* `server_name` - your application's server_name in nginx (e.g. example.com)(optional)
* `deploy_to`   - deployment path

Launch new tasks:

```
$ mina nginx:setup
$ mina nginx:link
```

Be sure to edit `shared/config/nginx.conf` on your server. Or you can parse an sample
configuration file by `mina nginx:parse` on your server.

Then:

```
$ mina nginx:reload
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/mina-nginx/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
