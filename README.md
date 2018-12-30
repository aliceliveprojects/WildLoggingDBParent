# WildLoggingDB - INCOMPLETE. NOT FOR PUBLIC USE (YET!)
UrbanWild is the project we use to demonstrate how we put together prototypes quickly, as a team. You can find it [here](https://github.com/TheUrbanWild/WildLogging).

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

## Plan

### Set up identity, tools and services

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
The REST API definition is [here](https://cloud.restlet.com/api/apis/25850/versions/1/swagger2?media=json), and copied to this repo [here](https://github.com/TheUrbanWild/WildLoggingDB/blob/master/documentation/restlet/swagger.yaml)  
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
5. The DATABASE_URL is a Postgres URL which points to the Postgres dabase instance on Amazon's AWS infrastructure.
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

Heroku is a gigantic container service, running millions of services in a virtualised environment. To do this, it  gives each app an automatic domain name, <yourappname>.herokuapp.com, and port and routes all incoming traffic to your app, via that. 

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

10. The left hand chooser is populated with all the GitHub personas which your login information give you access to can. The right hand search box allows you to search for repositories under that persona. Our repo is under an organisation called 'TheUrbanWild' for which we have admin access, and we called it 'WildLoggingDB'. Yours may be different.

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

27. Your Heroku app is now ready to re-deploy with any changes you make locally. Just check-in your changes to GitHub, and use the 'Deploy Branch' button again.

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

We'll do this, using 3 tables: a `Things` table, an `Events` table, and a `ThingsEvents` table. This last table joins joins events to things, so we can look up all sighting events of a particular thing.

### UUIDs

A [UUID](https://www.uuidgenerator.net/version4) is a [Universally Unique Identifier](https://en.wikipedia.org/wiki/Universally_unique_identifier). We use UUIDs to index each row in a table. 

First things first, we need to set up our database to use them.

1. Make sure you have installed Omni DB, and logged into your database



