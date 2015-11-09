## Who Follows?

A simple Sinatra/Redis app - does one Twitter user follow another?


## Overview

This example uses:

- Ruby 2+
- Bundler
- [Twitter Ruby gem](https://github.com/sferik/twitter)
- [Sinatra](http://www.sinatrarb.com/) as the framework
- Redis as the cache/datastore
- [Bootstrap](http://getbootstrap.com) for visual loveliness
- The latest version of the [apc CLI](http://docs.apcera.com/quickstart/installing-apc/) for the [Apcera Platform](http://www.apcera.com)

It demonstrates:

- Setting the location of static content with Sinatra
- Using layout templates
- Using Apcera Platform app manifests for deployment
- Configuration via environment variables

Limitations:

- The app queries the Twitter [GET followers/ids](https://dev.twitter.com/docs/api/1.1/get/followers/ids) REST endpoint, which is [rate-limited](https://dev.twitter.com/docs/rate-limiting/1.1/limits) to 15 calls in a 15 minute window, so it cannot be used heavily. This is just a demonstration of some simple API functionality.  

## Deploying the App

###Overview
This app, although simple, is an example of a [12 Factor](http://12factor.net/) app, a methodology for building modern cloud-native applications.

The deployment manifest describes some of the runtime configuration specifications for the app, including a Redis service that will automatically be created and bound by the Apcera Platform's automation processes.

You will need to create a [Twitter app](http://apps.twitter.com) and make note of the following the API keys in the environment variables: `TW_CONSUMER_KEY`, `TW_CONSUMER_SECRET`, `TW_ACCESS_TOKEN` and `TW_ACCESS_TOKEN_SECRET`.

###Customizing the Deployment
To customize the app deployment, do the following steps:

1. After cloning the *apcera-sample-apps* repo, change to the _apc-sinatra-twitter_ directory.
2. Edit the manifest file to provide a custom application `name`. You can also customize further with any attribute supported in [app manifest files](http://docs.apcera.com/jobs/manifests/#manifest-attributes).
3. Deploy the app specifying the environmental variables for your [Twitter app API keys](http://apps.twitter.com). For example:

```
apc app create \
  -e 'TW_CONSUMER_KEY=<your_consumer_key>' \
  -e 'TW_CONSUMER_SECRET=<your_consumer_secret>' \
  -e 'TW_ACCESS_TOKEN=<your_access_token>' \
  -e 'TW_ACCESS_TOKEN_SECRET=<your_access_token_secret>'
```

## Issues

The following issues are known:

- Lack of strong error handling -> currently if one or both user IDs don't exist, a "page does not exist" error is shown
- Twitter API limits only return the first (100?) users in the list of friends/followers, so if a user has many thousands of followers it may not work (Ruby gem and Twitter API hard limits)

## Future enhancements (TODO)

A few areas could be tided up:

- Better error handling
- No real need for the query to direct to a separate page, make this dynamic
- Add a static page with some background information on how it works
- Nicer mobile support (hide fork me banner)