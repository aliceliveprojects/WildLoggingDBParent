# WildLoggingDB - Re-implementing an API

This project is a sequel to [WildLogging](https://github.com/TheUrbanWild/WildLogging).

It is the parent project to:

* [WildLogging](https://github.com/aliceliveprojects/WildLogging) (A fork of the original)
* [WildLoggingDB](https://github.com/aliceliveprojects/WildLoggingDB)

UrbanWild is the project we use to demonstrate how we put together prototypes quickly, as a team. You can find it [here](https://github.com/TheUrbanWild/WildLogging).

We use the RESTlet platform to provide us with very fast (Free) way of prototyping data APIs - in this case, we logged species and sightings.

After a merger, Restlet has changed its service terms. We need to remove our dependency on this service.

We will transfer our dependency to Heroku, running a Postgres DB.

Incidentally, this development has the potential for use of the geo searching capabilities of Postgres.

## Why are we doing this?

Restlet Cloud is the PaaS which we have been using. It's service hosted a database, fronted by a REST API, which the Urban Wild SPWA used to store wildlife sightings.

Restlet was great as a platform for showing what RESTful interfaces are and how they work. 

Now we want to build on this experience, and show you how the RESTful API definition (using the Open API Specification ([which used to be Swagger](https://swagger.io/docs/specification/about/))) we built in Restlet Studio can be used to generate a skeleton server, and a database back-end, without too much more effort.

The result is much more useful, because we can add functionality which transforms the data, rather than just looking it up. Doing more processing on the server means that we reduce the communications traffic, and the processing done on the client.

## Try this too

Follow along:  it's a good way to experience all the tools and processes, while having something which is easy to test. We're assuming you have a GitHub account already.

## How do I do it?

We've got a number of scripts to go through, in order:

* [Re-implementing the API](./ReImplementing.md)
* [First Party Authentication](./Authentication.md)
* [Third-Party Authentication](./ThirdPartyAuthentication.md)

## Repository Cheatsheet

| SPWA                                                         | REST API                                                     |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [No Admin Implementation](https://github.com/aliceliveprojects/WildLoggingAndAdmin/releases/tag/v.1.0) | [Unauthenticated REST API](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported) |
| [Admin Implemented](https://github.com/aliceliveprojects/WildLoggingAndAdmin/releases/tag/spwa_with_admin_and_login_modules) | [Unauthenticated REST API](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported) |
| [Third Party Authentication Implemented](https://github.com/aliceliveprojects/WildLoggingAndAdmin/releases/tag/spwa_authentication_supported_with_token_renewal) | [Authenticated REST API](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/authentication_supported_updated_scope_check) |