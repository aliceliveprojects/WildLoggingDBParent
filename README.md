# WildLoggingDB - INCOMPLETE. NOT FOR PUBLIC USE (YET!)
After a merger, Restlet has changed its service terms. We need to remove our dependency on this service.

We will transfer our dependency to Heroku, running a Postgres DB.

Incidentally, this development has the potential for use of the geo searching capabilities of Postgres.

## Why are we doing this?

UrbanWild is the project we use to demonstrate how we put together prototypes quickly, as a team. 

Restlet Cloud is the PaaS which we have been using. It's service hosted a database, fronted by a REST API, which the Urban Wild SPWA used to store wildlife sightings.

Restlet was great as a platform for showing what RESTful interfaces are and how they work. 

Now we want to build on this experience, and show you how the RESTful API definition (using the Open API Specification ([which used to be Swagger](https://swagger.io/docs/specification/about/))) we built in Restlet Studio can be used to generate a skeleton server, and a database back-end, without too much more effort.

The result is much more useful, because we can add functionality which transforms the data, rather than just looking it up. Doing more processing on the server means that we reduce the communications traffic, and the processing done on the client.

## Try this too

Follow along:  it's a good way to experience all the tools and processes, while having something which is easy to test.

## Plan

### Set up identity, tools and services

1. Create a project identity
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

## Set-up RESTlet
We use Restlet Studio for building an and editing REST API definitions.

The Restlet API for urban wild is public.  
The original account is available [here](https://cloud.restlet.com/apis/25850/versions/1/overview)  
The REST API definition is [here](https://cloud.restlet.com/api/apis/25850/versions/1/swagger2?media=json), and copied to this repo [here](https://github.com/TheUrbanWild/WildLoggingDB/blob/master/documentation/restlet/swagger.yaml)  
Now we have the definition of the interface, to use in this project. Note: RESTlet's UI is the best for creating interfaces. Well worth getting an account and using it.

1. We created a RESTlet account for the porject identity

2. We imported the REST API definition into the Restlet Studio Tool, to take a look:



   ![here](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/restlet_api_def.png)


All is nicely laid-out, with end points for resources, verbs for the http operations, and defintions for the data which will be handled. 

The Restlet Studio UI is really good for visualising and building interface definitions, but once we're happy with them, we like to use the original swagger tools to validate them and construct skeleton servers.

## Swagger.io

Swagger.io originally developed the Open API Specification. We like to use its [open source tools](https://swagger.io/tools/open-source/) for development, because we think they are more definitive. 

1. We used the [online version](https://editor.swagger.io/) of the Swagger Editor to visualise [our]([here](https://github.com/TheUrbanWild/WildLoggingDB/blob/master/documentation/restlet/swagger.yaml) ) REST Interface definition.

   ![swagger](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/swagger_api_def.png)

The Swagger editor is much more code-orientated than Restlet Studio, which allows us to see much better how the interface is constructed - in [YAML](https://yaml.org/)

## Heroku

Heroku is a Platform-as-a-Service, which provides easy deployment of web applications and services from their source-code on GitHub. It has a generous free-tier model, which allows meaningful prototyping. It also has a thriving marketplace for third-party services, which provide similarly generous free-tier pricing. It's great for our purposes. 

The reason we like it so much, is that we remember how hard it used to be to deploy and secure a database backed web-service, and how much that got in the way of actual development. 

Security is a huge concern for anything that we do and to have such a trustable product at our disposal, essentially for free is a real benefit.

![heroku](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/heroku.png)

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
This is a browser-based client. A web-based version is here: http://teampostgresql.herokuapp.com, or you can use [these instructions](https://github.com/AliceDigitalLabs/SupportingLiveProjects_2018/wiki/Additional-Tools-from-Github#omnidb) to set-up OmniBD on you H: drive. You can then use it on any CMDT PC.

![omnidb](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/omnidb.png)

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

5. Put zip file in the 'code' folder of the repo, unzip, and then discard the .zip file.

6. Your `/code` directory will have a directory in it called `nodejs-server`. Take the contents of this directory out and paste into the `code` directory.

7. Add a .gitignore file ([here](https://github.com/github/gitignore/blob/master/Node.gitignore)) (don't forget to make sure the name of the file is actually `.gitignore`). to the `/code` directory.

8. Make sure you are connected to the internet. Open a terminal in the `/code` directory, and type

9. ```bash
   npm start
   ```

10. This is an instruction to the node package manager to download all the dependencies of the application, and then start Node:

11. ```bash
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

12. The best thing about the swagger-generated services like this, is that they automatically come with a set of interactive docs (swagger-ui), which you can use to debug the service:

13. ![swagger-ui](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/swagger_api_localhost.png)

14. The swagger UI is available at `http://localhost:8080/docs`

15. Once you're at this point, you can check in your changes.

## Deploy to Heroku

While we're here, it's a good idea to explore deployment to Heroku; the app is in its generated state, so there's nothing there to confuse if something goes wrong.

Heroku has a nice way of connecting your app to your GitHub repo, so you can build directly from it, whenever you want to, from whatever branch.

1. Login to your Heroku account, with your project identity, and go to the 'deploy' tab:

2. ![heroku deploy 1](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/heroku_deploy_1.png)

3. Choose 'connect to GitHub'. This happens:

4. ![heroku deploy 2](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/heroku_deploy_2.png)

5. Choose 'connect to GitHub' to confirm. This happens:

6. ![heroku deploy 3](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/heroku_deploy_3.png)

7. Fill-in the GitHub details for the account owning your repo, and sign-in. This happens:

8. ![heroku deploy 4](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/heroku_deploy_4.png)

9. The left hand chooser is populated with all the GitHub personas which your login can access. The right hand search box allows you to search for repositories under that persona. Our repo is under an organisation called 'TheUrbanWild' for which we have admin access. 

10. You need admin access on a repo to get premission to connect to it from the Heroku dashboard!

11. Now you can type in the name of your repo, and it will search to connect to it. 

12. ![heroku deploy 5](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/heroku_deploy_5.png)

13. Connect to the correct repo! This happens:

14. ![heroku deploy 6](/Users/coops/Documents/projects/WildLoggingDB/documentation/resources/heroku_deploy_6.png)

15. The heroku dashboard is now waiting to deploy the contents of the 'master' branch of the GitHub repo.

16. Deploying it, is as easy as pressing the button - except - Heroku needs to know what to build and where it is. Heroku's pretty smart; if the index.js of the NodeJS server was in the top level of the repo, it would have recognised it, and built without a problem. However, our source is in the `/code` directory. We just need to add a [file](https://devcenter.heroku.com/articles/getting-started-with-nodejs) to get it going. 

17. In the root of the repo, create a file called `Procfile`

18. Add the following to the `Profile`

19. ```procfile
    web: node ./code/index.js
    ```

20. Check the code in.