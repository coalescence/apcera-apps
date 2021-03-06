# Display Apcera Platform Environment Variables

A simple Sinatra application. Once deployed to Apcera Platform, it will echo the Environment and HTTP Request Headers.

This is especially useful to learn about service connection details being passed to an application. Create them, bind them to this running application, and you'll see the service-specific URI strings that are set for each one.

<img src="https://github.com/coalescence/apcera-apps/blob/master/apc-env/docs/images/demo.png">

## Deploy

The repo contains a manifest file which creates a new application called `apc-env`. The manifest also creates and binds 2 services to the app: a Redis instance and a Memcached instance.

To deploy:

```
$ apc app create

Packaging... done
Creating package "apc-env"... done
Uploading package contents... done!
[staging] Subscribing to the staging process...
[staging] Located application manifest
[staging] Beginning staging with 'stagpipe::/apcera::ruby' pipeline, 1 stager(s) defined.
[staging] Launching instance of stager 'ruby'...
[staging] Downloading package for processing...
[staging] Found Rack application
[staging] Stager needs relaunching
[staging] Launching instance of stager 'ruby'...
[staging] Downloading package for processing...
[staging] Found Rack application
[staging] Executing Bundler...
[staging] Fetching gem metadata from https://rubygems.org/..........
[staging] Installing json_pure 1.8.1
[staging] Installing rack 1.5.2
[staging] Installing rack-protection 1.5.2
[staging] Installing tilt 1.4.1
[staging] Installing sinatra 1.4.4
[staging] Using bundler 1.6.5
[staging] Your bundle is complete!
[staging] Gems in the groups development and test were not installed.
[staging] It was installed into ./vendor/bundle
[staging] Staging is complete.
Creating app "apc-env"... done
Attempting to bind to 2 service(s)
Looking up service "apc-redis"... no service found
Creating service "apc-redis"... done
Binding app "apc-env" to service "apc-redis"... done
╭───────────────────────────────╮
│ Binding Environment Variables │
├───────────────────────────────┤
│ "APCENV_APCREDIS_URI"         │
│ "REDIS_URI"                   │
╰───────────────────────────────╯
Looking up service "apc-mcache"... no service found
Creating service "apc-mcache"... done
Binding app "apc-env" to service "apc-mcache"... done
╭───────────────────────────────╮
│ Binding Environment Variables │
├───────────────────────────────┤
│ "APCENV_APCMCACHE_URI"        │
│ "MEMCACHE_URI"                │
╰───────────────────────────────╯
Start Command: bundle exec rackup config.ru -p 
Waiting for the application to start...
[stderr] /opt/apcera/ruby-1.9.3-p547/lib/ruby/gems/1.9.1/gems/bundler-1.6.5/lib/bundler/runtime.rb:222: warning: Insecure world writable dir /app in PATH, mode 040777
[stderr] [2015-11-15 23:28:44] INFO  WEBrick 1.3.1
[stderr] [2015-11-15 23:28:44] INFO  ruby 1.9.3 (2014-05-14) [x86_64-linux]
[stderr] [2015-11-15 23:28:44] INFO  WEBrick::HTTPServer#start: pid=3 port=4000
App should be accessible at "http://apc-env.admin.sandbox.cool-running.apcera-platform.io"
Success!

```
