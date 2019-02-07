# Re-Implementing the API

This is part one of a set of scripts which take you through re-implementing an API.

## Plan

### Set up identity, tools and services

1. Install VSCode
1. Create a project identity
1. Create a new, fresh GitHub repo. Clone it locally
1. Create a Restlet Account 
1. Create a Heroku account
1. Create an app with a postgres instance, on Heroku
1. Download and install the Omni DB database tool
1. Examine the Open API (Swagger) tools 

### Modify the API definition

1. Examine the Urban Wild REST interface definition using Restlet Studio, and Swagger
2. Remove all security definitions (for the time being)

### Construct a skeleton NodeJS server 

1. Use the Swagger tools to create a NodeJS server skeleton from the Urban Wild REST interface definition.
2. Run the server locally

### Create the database

1. Use the DB tool to create a database schema suitable to hold the UrbanWild data.

### Bind server to database

1. Hook-up the local NodeJS server to the remote Postgres database.
2. Implement the original functionality behind the interface
3. Debug the RESTful interface using the Visual Studio Code HTTP plugins.

### Deploy as a replacement service

1. Deploy the local NodeJS server to Heroku, from this GitHub repo
2. Change the location which the Urban Wild SPWA points to. Same interface, different location!

# Here we go

## Install VSCode
Microsoft Visual Studio Code is a ridiculously useful code editor, which comes with a debugger, compatible with NodeJS (amongst other things). It supports Windows, Linux and MacOS. You can install it [here](https://code.visualstudio.com/).

## Setting up a Project Identity

A project identity is very useful for keeping communications and accounts separate. 

We have set up a project alias on Alice's GMail account, and will use this mailbox identity to set-up any other accounts used by the project.

## New GitHub Repository

We created a new GitHub Repo [here]() to hold our project source code. We didn't put it in here, because we wanted to segregate it from the how-to documentation. That would have meant puting the project code in a sub-directory. This isn't supported by Heroku's deployment process. 

You can create a new fresh repo, on GitHub  if you're following along, or fork ours.

## Set-up RESTlet

We use Restlet Studio for building an and editing REST API definitions.

The Restlet API for urban wild is public.  
The original account is available [here](https://cloud.restlet.com/apis/25850/versions/1/overview)  
The REST API definition is [here](https://cloud.restlet.com/api/apis/25850/versions/1/swagger2?media=json), and copied to this repo [here](https://github.com/aliceliveprojects/WildLoggingDBParent/blob/master/documentation/restlet/swagger.yaml)  
Now we have the definition of the interface, to use in this project. Note: RESTlet's UI is the best for creating interfaces. Well worth getting an account and using it.

1. We created a RESTlet account for the porject identity

2. We imported the REST API definition into the Restlet Studio Tool, to take a look:



   ![here](./documentation/resources/restlet_api_def.png)


All is nicely laid-out, with end points for resources, verbs for the http operations, and defintions for the data which will be handled. 

The Restlet Studio UI is really good for visualising and building interface definitions, but once we're happy with them, we like to use the original swagger tools to validate them and construct skeleton servers.

## Swagger.io

Swagger.io originally developed the Open API Specification. We like to use its [open source tools](https://swagger.io/tools/open-source/) for development, because we think they are more definitive. 

1. We used the [online version](https://editor.swagger.io/) of the Swagger Editor to visualise [our]([here](https://github.com/TheUrbanWild/WildLoggingDB/blob/master/documentation/restlet/swagger.yaml) ) REST Interface definition.

   ![swagger](./documentation/resources/swagger_api_def.png)

The Swagger editor is much more code-orientated than Restlet Studio, which allows us to see much better how the interface is constructed - in [YAML](https://yaml.org/)

## Heroku

Heroku is a Platform-as-a-Service, which provides easy deployment of web applications and services from their source-code on GitHub. It has a generous free-tier model, which allows meaningful prototyping. It also has a thriving marketplace for third-party services, which provide similarly generous free-tier pricing. It's great for our purposes. 

The reason we like it so much, is that we remember how hard it used to be to deploy and secure a database backed web-service, and how much that got in the way of actual development. 

Security is a huge concern for anything that we do and to have such a trustable product at our disposal, essentially for free is a real benefit.

![heroku](./documentation/resources/heroku.png)

 Here's how we start-up our project with Heroku, and add a Postgres DB:

1. We created a Heroku account, using the project email address.
2. We used Heroku to create an app, using the European jurisdiction. (We called ours urbanwilddbapi
3. In Heroku, we used the 'Elements' menu item to add a free Heroku Postgres instance. (Hobby Dev)
4. In the app's Settings, the 'Reveal Config Vars' button shows we have a DATABASE_URL
5. The DATABASE_URL is a [Postgres URL](https://stackoverflow.com/questions/3582552/postgresql-connection-url) which points to the Postgres dabase instance on Amazon's AWS infrastructure.
6. The DATABASE URL is private, and should never be checked into a public repository, or allowed outside the project.
7. Heroku has a number of tools which can be used to create local instances of the Database - but for this exercise, we will just use the remote DB.

## Postgres tools
We need a Postgres client which is free, and usable from any of the Uni computers.

We're using [OmniDB](https://omnidb.org/index.php?option=com_content&view=category&layout=blog&id=12&Itemid=149&lang=en). 
This is a browser-based client. A web-based version is here: http://teampostgresql.herokuapp.com. If you're a student at MMU, use [these instructions](https://github.com/AliceDigitalLabs/SupportingLiveProjects_2018/wiki/Additional-Tools-from-Github#omnidb) and set-up OmniBD on your H: drive. You can then use it on any CMDT PC.

![omnidb](./documentation/resources/omnidb.png)

In the pic above, OmniDB is directly editing our remote Postgres database (which is something done with **great caution!**)



That's the tools. Let's have a look at the API definition.

## API definition

### Authentication

We're going to remove all authentication from the interface for the time being - right now, the API and the data which it fronts will be open. In later exercises, we'll add authentication properly.

1. In RESTlet studio, change the attribution (name, contact details, etc) of the API.

2. Change the base URL to reflect the new Heroku app we created.

3. Remove the security schemes from the API

4. Export the YAML file

5. Check in the changes ()


## Create the Server Skeleton

We're going to create a NodeJS server using the API definition, using the Swagger.io tools.

Before you start, check that Node and NPM are installed, and in your path.

```bash
adanac:WildLoggingDB coops$ node -v
v8.8.1
adanac:WildLoggingDB coops$ npm --v
5.4.2
```

(We use Node 8, as it's in LTS)

1. Go to the  [Swagger editor](https://editor.swagger.io/) 

2. Upload the YAML file

3. Use the menu option: Generate Server, and choose: nodejs-server

4. The NodeJS code is downloaded as a .zip file.

5. Put zip file in the root folder of the repo, unzip, and then discard the .zip file.

6. Your directory will have a directory in it called `nodejs-server`. Take the contents of this directory out and paste into the root directory.

7. Add a .gitignore file ([here](https://github.com/github/gitignore/blob/master/Node.gitignore)) (don't forget to make sure the name of the file is actually `.gitignore`). to the root directory.

8. Make a small change to the swagger.yaml file, in `<repo root>\api\swagger.yaml`. Make sure the following is set, near the top of the file:

9. ```yaml
   host: "localhost:8080"
   schemes:
   - "http"
   ```

10. Make sure you are connected to the internet. Open a terminal in the root directory, and type

11. ```bash
    npm start
    ```

12. This is an instruction to the node package manager to download all the dependencies of the application, and then start Node:

13. ```bash
    > theurbanwild@1.6.0 prestart /Users/coops/Documents/projects/WildLoggingDB/code
    > npm install
    
    npm WARN deprecated formidable@1.0.17: Old versions of Formidable are not compatible with the current Node.js; Upgrade to 1.2.0 or later
    npm notice created a lockfile as package-lock.json. You should commit this file.
    added 147 packages in 19.259s
    
    > theurbanwild@1.6.0 start /Users/coops/Documents/projects/WildLoggingDB/code
    > node index.js
    
    Your server is listening on port 8080 (http://localhost:8080)
    Swagger-ui is available on http://localhost:8080/docs
    ```

14. The best thing about the swagger-generated services like this, is that they automatically come with a set of interactive docs (swagger-ui), which you can use to debug the service:

15. ![swagger-ui](./documentation/resources/swagger_api_localhost.png)

16. The swagger UI is available at `http://localhost:8080/docs`

17. Try some of the functions. You find the swagger UI page sends an HTTP request to the service via the REST API, and gets some canned data back.

18. Once you're at this point, you can check in your changes.

## Deploy to Heroku

While we're here, it's a good idea to explore deployment to Heroku; the app has only just been generated, so there's nothing there to confuse if something goes wrong.

Heroku is a fantastic resource - but there are a couple of things we need to do to the app to make it play nicely:

1. Configure the app to listen on the HTTP port which Heroku gives it.
2. Configure the Swagger UI to make calls to the deployed REST interface, not localhost.

### Ports

Heroku is a gigantic container service, running millions of services in a virtualised environment. To do this, it  gives each app an automatic domain name, <yourappname>.herokuapp.com, and a `port` and routes all incoming traffic to your app, via that. 

If it wants to get this traffic, our service must listen on that port. 

Heroku provides the port in an environment variable. We need to read the value during the service's set-up,  and provide it to the skeleton server's framework.

We'll need to modify the file `index.js` in the root of the repo:

1. Find the following  line:

   ```javascript
   var serverPort = 8080;
   ```

2. Change it to:

3. ```javascript
   var serverPort = process.env.PORT || 8080
   ```



Now the app will listen on Heroku's port if it's defined, or if you're running the code locally, it will default to 8080.

### Swagger UI

The Swagger UI configures itself by reading and parsing the `/apis/swagger.yaml` file, when it has deployed to the browser.

The hostname and scheme values tell it where the REST service is and where to send its HTTP requests to. 

You will need to change the following values to match your own installation:

```yaml
host: "urbanwilddbapi.herokuapp.com"
schemes:
- "https"
```

1. To find your host value,  go to your Heroku account, and the 'settings' tab. You'll see it in the 'Domains and Certificates' section.

### Deploying from GitHub

Heroku has a nice way of connecting your app to your GitHub repo, so you can build directly from it, whenever you want to, from whatever branch.

1. **Make sure you have checked in your earlier changes!**

2. Login to your Heroku account, with your project identity, and go to the 'deploy' tab:

3. ![heroku deploy 1](./documentation/resources/heroku_deploy_1.png)

4. Choose 'connect to GitHub'. This happens:

5. ![heroku deploy 2](./documentation/resources/heroku_deploy_2.png)

6. Choose 'connect to GitHub' again, to confirm. This happens:

7. ![heroku deploy 3](./documentation/resources/heroku_deploy_3.png)

8. Fill-in the GitHub details for the account owning your repo, and sign-in. This now happens:

9. ![heroku deploy 4](./documentation/resources/heroku_deploy_4.png)

10. The left hand chooser is populated with all the GitHub personas which your login information gives you access to. The right hand search box allows you to search for repositories under that persona. Our repo is under an organisation called 'TheUrbanWild' for which we have admin access, and we called it 'WildLoggingDB'. Yours may be different.

11. You need admin access on a repo to grant permission for Heroku to connect to it.

12. Type in the name of your repo, and it will search to connect to it: 

13. ![heroku deploy 5](./documentation/resources/heroku_deploy_5.png)

14. Choose 'Connect' on the correct repo. This happens:

15. ![heroku deploy 6](./documentation/resources/heroku_deploy_6.png)

16. The heroku dashboard is now waiting to deploy the contents of the 'master' branch of the GitHub repo.

17. Deploying it, is as easy as pressing the button - except - Heroku needs to know what to build and where it is. Heroku's pretty smart; if the index.js of the NodeJS server is in the top level of the repo, it will recognise it, and build without a problem. 

18. Choose 'Deploy Branch'. This happens:

19. ![](./documentation/resources/heroku_deploy_7.png)

20. Heroku receives the source code from the repo, recognises it as being a NodeJS project, and starts building.

21. When it's done, this happens: 

22. ![](./documentation/resources/heroku_deploy_8.png)

23. The app has deployed, and is available to View. 

24. However, choosing the 'View' button won't take you to the Swagger doc. It gets deployed to <yourwebsite url>/docs

25. To find your website URL, go to the 'settings' tab. You'll see it in the 'Domains and Certificates' section.

26. Our swagger URL is https://urbanwilddbapi.herokuapp.com/docs

27. **If you have problems:** we had a lot of problems contacting our server, until we realised that our `eduroam` internet provision was blocking comms to it. MMU does provide a BTWifi connection, which is open, and can be used by visitors, so we reccommend using that for testing.

## Setup the Postgres Database

The Restlet Service we are re-creating has 2 data types. You can see the types, by looking at the `POST` verbs for the `events` endpoint and the `things`endpoint:

### Thing

```json
Thing {
	name (string)
}
```



### Event

```json
Event {
	postcode (string),
	date (integer),
	thing (string),
	lat (number),
	lon (number)
}
```

The Postgres database must model these, using tables.

We'll do this, using 2 tables: a `Things` table, an `Events` table, Just as it was in the RESTlet storage.

### UUIDs

A [UUID](https://www.uuidgenerator.net/version4) is a [Universally Unique Identifier](https://en.wikipedia.org/wiki/Universally_unique_identifier). We use UUIDs to index each row in a table, in an `id` column. 

First things first, we need to set up our database to use them.

1. Make sure you have installed Omni DB, and logged into your database. Remember that the DATABASE_URL in the  Config Vars of your Heroku Account contains [all the information you need](https://stackoverflow.com/questions/3582552/postgresql-connection-url).

2. You'll need to send the following Query to your database, to enable uuid functionality, provided by an extension, called `uuid-ossp`:

3. ```sql
   CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
   ```



### Tables

#### Things

Create the 'Things' table, by sending the following query:

```sql
CREATE TABLE "public"."things" (
    "id" text DEFAULT uuid_generate_v4(),
    "name" text NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE (name)
);
```

#### Events

Create the 'Events' table, by sending the following query:

```sql
CREATE TABLE "public"."events" (
    "id" text DEFAULT uuid_generate_v4(),
    "postcode" text NOT NULL,
    "lat" double precision NOT NULL,
    "lon" double precision NOT NULL,
    "date" bigint NOT NULL,
    "thing" text,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("thing") REFERENCES "public"."things"("id") ON DELETE CASCADE ON UPDATE CASCADE
);
```

### Test the Database

#### Things

Create a new Thing in the database, by sending the following query:

```sql
INSERT INTO "public"."things"("name") VALUES('Jay') RETURNING "id", "name";
```

You'll find that the database returns you an automatic UUID, for 'Jay'.

In this case the thing has a UUID of `5b911588-ce37-4356-96ae-d79e5b6aca88`. Yours will (obviously!) be different.

#### Events

Things get a bit complicated here, but it's worth it!

We're going to add an event, at our current latitude and longitude, the current date, expressed as a Java epoch time (number of seconds since 00:00:00 01/01/1970), and the current post code.

##### Lat Long

We're using the location of MUU's Shed, in https://www.latlong.net/

Which we get as something like: 

```
Lat:  54.570499
Lon: -5.930030
```

##### Postcode
We'll look these up on https://postcodes.io/ and check they are valid.

##### Date
We'll use https://www.epochconverter.com/ to convert the current time into a long integer. This returns us something like: 

```1546180701```

##### Add the entry

Putting it all together gives us this query to send:

```sql
INSERT INTO "public"."events"("postcode", "lat", "lon", "date", "thing") VALUES('M1 5GD', 54.570499, -5.93003, 1546180701, '5b911588-ce37-4356-96ae-d79e5b6aca88') RETURNING "id", "postcode", "lat", "lon", "date", "thing";

```

(don't forget to substitute your own thing id if you're following along)

**Add several entries, so that you're able to test searching and sorting, when you need to**

## Bind server to database

Now we're ready to connect our Node.JS server to the database.

### Add node-postgres

You'll remember that we have a NodeJS skeleton, whichwe generated from the REST interface definition, using the swagger tools.

You will need to install the [node-postgres](https://node-postgres.com/) package to this application.

1. Open a command prompt / terminal window in the root directory of the project. This is the directory which has the `package.json` file in it.

2. Type:

3. ```bash
   npm install pg
   ```



### Add Structure

We're going to add to the structure of our application , to make it clear that the database functionality is seperate to the server skeleton. 

We're also going to add some utility functions which make it easier to respond to error messages when things go awry.

Finally, we're going to hook-up the swagger-generated code to our database functionality, and give it a test, to see it all works properly.

Add the following files (shown in green) to your project:

![vscode_1](./documentation/resources/vscode_1.png)

#### stall.js

One of the best things to come out of NodeJS v8 was the implicit use of Promises in the language, with the keywords `async` and `await` , which encapsulate the concept of asynchronous code - code which runs independently of the main thread.

The swagger-generated skeleton supports pre-Node 8, and so uses the legacy  Promise class. We want to be able to use the swagger code with the minimum of alteration, so we won't mess about with it too much. However, we want to use the latest language additions in any new code we write, so that we take advantage of the enhanced readability.

Stall.js simply allows us to create a dummy asynchronous function, which resolves (runs) after a specified time, and lets us test our services.

Here's stall.js:

```javascript
'use strict'

async function stall(stallTime = 3000, throwable = null) {
    if(!throwable){
    	await new Promise(resolve => setTimeout(
        function(){
            console.log("dummy async function resolving in" + stallTime + " ms.");
            setTimeout(resolve,stallTime);
        }
        , 0));
    }else{
        await new Promise(resolve => setTimeout(resolve, stallTime));
        throw(throwable);
    }
}

module.exports = {
    stall: stall
};
```



You can see it simply sets up an old-style timeout. We can set `throwable` with an object which reports an error, too.

#### error.js

This simply gives us some more-readable helper functions, to create error objects, which can be thrown.

Here's error.js:

```javascript
'use strict'

module.exports = {

    createError: (code, message) => {
        var result = {};
        result.statusCode = code;
        result.message = message;
        return result;  
    },

    create500Error: (message) => {
        var result = {};
        result.statusCode = 500;
        result.message = message;
        return result;
    },
    create400Error:(message) => {
        var result ={};
        result.statusCode = 400;
        result.message = "Bad Request: " + message;
        return result;
    },

    createNotYetImplemented: (message) => {
        var result = {};
        result.statusCode = 500;
        result.message = "Not yet implemented: " + message;
        return result;
    }

}
```



#### database.js

This file is going to provide us with the implement of the REST interface, at the database level. 

At the moment, we're just going to add all the required dependencies, and test it, using  'stall' to represent an asynchronous call into the DB.

Add this to the new  `database.js` file:

```javascript
'use strict';

var { Pool } = require('pg');

var createError = require('../utils/error').createError;
var stall = require('../utils/stall').stall;

var thePool = null;
var theConfig = null;


const errors = {
  PARAMETER_ERROR:-1,
  DATABASE_ERROR:-2,
  INTERNAL_ERROR:-3
}

var initialise = function (url, needsSSL) {
    if (needsSSL == true) {
      url += "?sslmode=require"
    }
  
    if (thePool) {
      thePool.end();
    };
  
    theConfig = null;
  
    theConfig = {
      connectionString: url,
      ssl: needsSSL
    };
  
    thePool = new Pool(theConfig);
  };
  


  var test = async function(arg){

    await stall(500, createError(errors.PARAMETER_ERROR,"bad parameter!"));
    
  }


var getEvents = async function(id, date, lat, lon, postcode, thing, $page, $size, $sort){
  var result = null;
  await test(); // this will throw;
  return result;
}


  module.exports = {
    errors:errors,
    initialise: initialise,
    getEvents:getEvents
  };
```



You'll see we export:

* initialise: initialises the database connection and a pool of clients.
* errors: an object which defines all errors which are supported
* getEvents: function to do a database search - right now it's running  the dummy test function

#### Changes to swagger-generated skeleton code

##### WildlifelogService.js

We're going to change the function `getEvents` in this file. Here's the new version:

```javascript
exports.getEvents = function($page,lat,lon,date,id,$size,postcode,thing,$sort) {
  
   return new Promise(function(resolve, reject) {
         database.getEvents(id, date, lat, lon, postcode, thing, $page, $size, $sort)
         .then(resolve)
         .catch(function(e){
            switch(e.statusCode){
              case database.errors.DATABASE_ERROR:
              // remove database specific error - will leak information.
              reject (errApi.create500Error("something terrible happened with the database. Sorry..."));
              break;
              case database.errors.INTERNAL_ERROR:
              reject(errApi.create500Error(e.message));
              break;
              case database.errors.PARAMETER_ERROR:
              reject(errApi.create400Error(e.message));
              break;
            }
         })
   });
}
```

we're calling the `database.getEvents` function, here, as it would be called, but we've put some extra code in, to handle errors. One thing we want to handle properly is the way sql errors are reported. We're clobbering those and removing the detail.

##### Wildlifelog.js

We're going to change the function `getEvents` in this file:

```javascript
module.exports.getEvents =  function getEvents (req, res, next) {
  var $page = req.swagger.params['$page'].value || null;
  var lat = req.swagger.params['lat'].value || null;
  var lon = req.swagger.params['lon'].value || null;
  var date = req.swagger.params['date'].value || null;
  var id = req.swagger.params['id'].value || null;
  var $size = req.swagger.params['$size'].value || null;
  var postcode = req.swagger.params['postcode'].value || null;
  var thing = req.swagger.params['thing'].value || null;
  var $sort = req.swagger.params['$sort'].value || null;

  
  var response =  Wildlifelog.getEvents($page,lat,lon,date,id,$size,postcode,thing,$sort)
    .then(function (response) {
      utils.writeJson(res, response);
    })
    .catch(function (response) {
      utils.writeJson(res, utils.respondWithCode(response.statusCode, response));
    });

};
```



1. We've changed the incoming parameters: if they are undefined, we swap them to null. This makes it easier to write parameterised SQL queries, using the `null` to flag a missing optional parameter.
2. We're calling `respondWithCode`, which gives us that status code.

##### Index.js

Finally, we're going to initialise the database service in the index.js:

```javascript
'use strict';

var fs = require('fs'),
path = require('path'),
http = require('http');



var app = require('connect')();
var swaggerTools = require('swagger-tools');
var jsyaml = require('js-yaml');

var serverPort = process.env.PORT || 8080;

var database = require('./service/database');
var dbUrl = process.env.DATABASE_URL;

// database connection
database.initialise(dbUrl, true);

// swaggerRouter configuration
var options = {
  swaggerUi: path.join(__dirname, '/swagger.json'),
  controllers: path.join(__dirname, './controllers'),
  useStubs: process.env.NODE_ENV === 'development' // Conditionally turn on stubs (mock mode)
};

// The Swagger document (require it, build it programmatically, fetch it from a URL, ...)
var spec = fs.readFileSync(path.join(__dirname,'api/swagger.yaml'), 'utf8');
var swaggerDoc = jsyaml.safeLoad(spec);

// Initialize the Swagger middleware
swaggerTools.initializeMiddleware(swaggerDoc, function (middleware) {

  // Interpret Swagger resources and attach metadata to request - must be first in swagger-tools middleware chain
  app.use(middleware.swaggerMetadata());

  // Validate Swagger requests
  app.use(middleware.swaggerValidator());

  // Route validated requests to appropriate controller
  app.use(middleware.swaggerRouter(options));

  // Serve the Swagger documents and Swagger UI
  app.use(middleware.swaggerUi());

  // Start the server
  http.createServer(app).listen(serverPort, function () {
    console.log('Your server is listening on port %d (http://localhost:%d)', serverPort, serverPort);
    console.log('Swagger-ui is available on http://localhost:%d/docs', serverPort);
  });

});

```



The lines we've added are:

```javascript
var database = require('./service/database');
var dbUrl = process.env.DATABASE_URL;

// database connection
database.initialise(dbUrl, true);
```

#### Testing

One of the nicest things about VisualStudio Code, is that it supports debugging NodeJS right out of the box.

It will even support setting up the environment variables which Node will access from Heroku, when deployed. 

You can set up debugging, by creating a  `.vscode` directory in your project's root directory, and adding a `launch.json` file:

```json
{
    // Use IntelliSense to learn about possible attributes.
    // Hover to view descriptions of existing attributes.
    // For more information, visit: https://go.microsoft.com/fwlink/?linkid=830387
    "version": "0.2.0",
    "configurations": [
        {
            "type": "node",
            "request": "launch",
            "name": "Launch Program",
            "program": "${workspaceFolder}/index.js",
            "env": {
                "DATABASE_URL":"postgres://fljsdlfjsdsdfdssd:lalalalalalalalalalalalalalalalalalalalalala@ec2-99-999-99-999.eu-west-1.compute.amazonaws.com:5432/kgerwkgergergreger"
            }
        }
    ]
}
```

If get a permission error try replacing `${workspaceFolder}/index.js` with an windows path to the index.js file.

e.g. `H:\\Documents\\GitHub\\MyWildLoggingDB\\index.js`

You'll notice we added the DATABASE_URL, so we can debug the server locally, while using the main db.

*  **DO NOT check-in the launch.json file**. It now contains the login details to your database.

Once you have created the file you should be able to set breakpoints in the server code. You should be able  to run the server locally, from VSCode and test your new code using the Swagger UI at:

`http://localhost:8080/docs/#!/wildlifelog/getEvents`



## Hook up the database

Now we're going to create a query which will perform a search of the database. 

We've made a change to the `database.js` file's `getEvents` function:

```javascript
var getEvents = async function(id, date, lat, lon, postcode, thing, $page, $size, $sort){
  var result = null;

  var stem = 'select * from events where';
  var id_comp = '($1::text is null or id = $1) and ';
  var date_comp = '($2::bigint is null or date = $2) and ';
  var lat_comp = '($3::real is null or lat = $3) and '; // practically useless. Included for completeness
  var lon_comp = '($4::real is null or lon = $4) and '; // practically useless. Included for completeness
  var postcode_comp = "($5::text is null or postcode like $5) and ";
  var thing_comp = '($6::text is null or thing = $6) ';
  

  var page = 0;
  var size = 0;
  var sort = "";

  if(postcode){
    postcode = "%" + postcode + "%"; //wildcards addition
  }


  if($page){
    try{
      page = parseInt($page);
    }catch(e){}

  }
  if($size){
    try{
      size = parseInt($size);
    }catch(e){}
  }
  if($sort){
    sort = ' order by ' + $sort; // expecting something like "postcode ASC, date DESC". Will throw on error. 
  }

  var pagination_comp = "";
  var offset = page * size;
  if(offset){
    pagination_comp = " OFFSET " + offset + " LIMIT " + size; 
  }


  var query = 
    stem + 
    id_comp +
    date_comp +
    lat_comp +
    lon_comp +
    postcode_comp +
    thing_comp +
    sort + 
    pagination_comp + ";"; 
    

  var parameters = [id, date, lat, lon, postcode, thing];
  try{
    var response = await thePool.query(query,parameters);
    result = response.rows;
  }catch(e){
    throw(createError(errors.PARAMETER_ERROR,e.message));
  }

  return result;
}
```



It's a quick and dirty implementation, to illustrate the creation of the dynamic search query, but it fully implements the behaviour we're looking for.

We're going to do the same sort of thing to implement all the other REST endpoints. 

We now have 2 releases, which are tagged in the source code:

1. [one_endpoint_supported](https://github.com/TheUrbanWild/WildLoggingDB/releases/tag/one_endpoint_supported)

2. [all_endpoints_supported](https://github.com/TheUrbanWild/WildLoggingDB/releases/tag/all_endpoints_supported)


## Change the SPWA

We're going to point the Single Page Web App at the new REST API, and hope that it behaves itsself :-)

1. Find the orginal SPWA [here](https://github.com/TheUrbanWild/WildLogging)
2. We're going to fork it, so that it is a seperate entity, which can be run side-by-side, to the original. You can find the forked SPWA [here](https://github.com/aliceliveprojects/WildLogging)
3. We changed all references to the RESTlet API, and replace them with our new one.

## Testing with the SPWA

While testing, the following changes needed to be made to the REST service, so it worked as expected by the SPWA:

### CORS

We needed to add Cross Origin Request Support

1. on the command-line / terminal at the root of the REST service project:

2. ```bash
   npm install cors
   ```

3. then the following code gets added to `index.js`

4. ```javascript
   var cors = require('cors');
   ```

5. ...and:

6. ```javascript
   // Cross Origin Requests - must have this, as we are an API.
   // Without it, browsers running SPWAs from domains different to ours (e.g. github pages)
   // will reject HTTP requests during pre-flight check.
   app.use(cors());
   ```

### Database Response

We found that the SPWA was barfing, when trying to access events. The reason was because the REST service was returning the event.date as a string, and not a number.

To resolve this, we used a neat configuration function in `node-postgres`, in the setup of our `database.js`

1. We added this to the top of `database.js`

2. ```javascript
   var types = require('pg').types;
   
   // see https://github.com/brianc/node-pg-types#pg-types
   // pg is returning our bigint date type as a string instead of a number.
   types.setTypeParser(20, function(val) {
     return parseInt(val);
   });
   ```

3. see https://github.com/brianc/node-pg-types#pg-types for more information.

### Get the return type right

Finally, we noticed that the SPWA was not giving us the species name associated with the event - it was because we were returning an array of 1 item, instead of the object itself.

## Final Release

Our final release marks the API working with the SPWA:

* This release tag on the WildLoggingDB repo: [spwa_supported](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported)
* This release tag on the WildLogging SPWA repo: [spwa_supported](https://github.com/aliceliveprojects/WildLogging/releases/tag/spwa_supported)

You can find the final release [here](https://aliceliveprojects.github.io/WildLogging/#/home):

![final](./documentation/resources/final_release.png)


