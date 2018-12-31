# Adding Authentication [UNDER CONSTRUCTION: NOT FOR PUBLIC USE]

As of release [SPWA Supported]([SPWA Supported](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported)), the application works as an open data API.

This means that the data we gather is vulnerable to being altered when we would really rather it wasn't!

The SPWA is fairly simple, in that it POSTs new Things, and new Events, and then searches and reads them:

```
GET /things/
GET /things/{id}
POST /things/

GET /events/
GET /events/{id}
POST /events/
```

These following functions are much more in need of protection, since they can delete large amounts of data, or alter existing items.

```
DELETE /things/{id}
PUT /things/{id}

DELETE /events/{id}
PUT /events/{id}
```

We're going to wrap these in an authentication layer, so that access is only granted with a valid token.

## Authentication

If we're going to add authentication to our endpoints, then we need to choose an authentication method which is suitable.

We use a protocol called [OAuth2](https://oauth.net/2/) which is suited to clients such as SPWAs, whose scripts can be seen and altered by end-users with browser tools.

We use a Platform as a Service, called [Auth0](https://auth0.com), which provides us with a generous free tier for prototyping, and handling user accounts.

## The Plan

1. create a new Auth0 account 
2. use the RESTlet UI to add authentication definitions to our REST API definition (the swagger.yaml file)
3. add authentication handlers to the RESTFul service, which map to the authentication definitions
4. use the authentication handlers to intercept incoming REST requests and validate the authentication tokens, encoded in their headers.
5. Implement code which validates the tokens against a service endpoint, povided by Auth0.

# Here we go







