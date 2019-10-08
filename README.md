# WildLogging

WildLogging is a web application which we built to show how the JAM Stack works (Javascript, API, Markup). 
It's a pretty simple responsive app which lets anyone log wildlife sightings in their neighbourhood.

You can find the SPWA (Single Page Web Application) deployed on GitHub Pages,  [here](https://aliceliveprojects.github.io/WildLoggingAndAdmin)

The WildLogging App depends on an API, which fronts a database. You can find the API UI [here](https://urbanwilddbapi.herokuapp.com/docs). 

Here's where you can find the source code:

* for the web application: [here](https://github.com/aliceliveprojects/WildLoggingAndAdmin)
* for the API: [here](https://github.com/aliceliveprojects/WildLoggingDB)

Here's how we developed the project:  

* [See our planning boards on Trello](https://trello.com/b/rRl2fKYh/the-urban-wild)  
* [See our quick and dirty wireframes on GitHubPages](https://theurbanwild.github.io/WildFrames/wireframes/published)  
* [See our deliveries in this repo](https://github.com/TheUrbanWild/WildLogging/tree/master/documentation/deliveries)
* [See our investigations demo](https://theurbanwildtest.github.io/)  
* [See our development write up](https://digitallabs.mmu.ac.uk/taming-the-urban-wild/)


We originally built the project to show the wonder of Platforms-as-a-Service: We used a fantastic service called Restlet, which gave us an online database and UI tools to easily make the RESTFul API to wrap it. Alas Restlet was swallowed by a larger organisation and the service was discontinued. It really helped us though: we could produce a data API in just a few minutes.

# About this project
Now the project has moved on: we removed the dependency on Restlet, by creating a new API and our own Postgres DB.

For history's sake, you can see the original project [here](https://github.com/TheUrbanWild/WildLogging).
You can see the re-worked project [here](https://github.com/aliceliveprojects/WildLogging) 

Now we'll show you how the RESTful API definition (using the Open API Specification ([which used to be Swagger](https://swagger.io/docs/specification/about/))) we built in Restlet Studio can be used to generate a skeleton server, and a database back-end, without too much more effort.

The result is much more useful, because we can add functionality which transforms the data, rather than just looking it up. Doing more processing on the server means that we reduce the communications traffic, and the processing done on the client.

## Try this too

Follow along:  it's a good way to experience all the tools and processes, while having something which is easy to test. We're assuming you have a GitHub account already.

## How do I do it?

We've got a number of scripts to go through, in order:

* [Re-implementing the API](./ReImplementing.md) - this shows you how we created a Postgres DB behind the same RESTful API - so we ddn't have to change the client.
* [First Party Authentication](./Authentication.md) - this shows you how we added authentication to the sensitive parts of the API, which delete data. We  show you how to use the authentication service, Auth0
* [Third-Party Authentication](./ThirdPartyAuthentication.md) - this shows how we added thir-[art 

## Repository Cheatsheet

| SPWA                                                         | REST API                                                     |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [No Admin Implementation](https://github.com/aliceliveprojects/WildLoggingAndAdmin/releases/tag/v.1.0) | [Unauthenticated REST API](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported) |
| [Admin Implemented](https://github.com/aliceliveprojects/WildLoggingAndAdmin/releases/tag/spwa_with_admin_and_login_modules) | [Unauthenticated REST API](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported) |
| [Third Party Authentication Implemented](https://github.com/aliceliveprojects/WildLoggingAndAdmin/releases/tag/spwa_authentication_supported_with_token_renewal) | [Authenticated REST API](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/authentication_supported_updated_scope_check) |
