# Adding Authentication

As of release [SPWA Supported](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported), the application works as an open data API.

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
3. set-up Auth0 account to handle authorisation requests, coming from our SwaggerUI.
4. set-up our SwaggerUI to generate authorisation requests
5. upgrade our service so we can set up our SwaggerUI wherever it is deployed.
6. add authentication handlers to the RESTFul service, which map to the authentication definitions
7. use the authentication handlers to intercept incoming REST requests and validate the authentication tokens, encoded in their headers.
8. Implement code which validates the tokens against a service endpoint, provided by Auth0.

# Here we go

## Auth0, the authorisation provider

First things, first; Auth0 is going to help us manage users, and to check whether they are authenticated to access the sensitive parts of the API.  

Auth0 handles user accounts as well as the entire sign-up and login process to our API. We'll be creating our own admin account on Auth0. This will give us a free-tier allowance of 10,000 user accounts. 

 A good place to start is simply to switch off the sign-up option which Auth0 presents to new users, and to create accounts only for yourself and your team. We'll be doing this later, but wanted to let know know that first :-)

Don't forget: when you allow a user to sign-up to your service, you will be liable for the information they give you under [GDPR](https://ico.org.uk/for-organisations/guide-to-data-protection/). Auth0 provides all the tools you need to be GDPR compliant, but you need to be aware of your obligations. Be aware that anyone signing up to your service has rights on the information that they leave there.

OK, back to construction.

When our API is used, it's usually via a single page web application (SPWA). 

In our simple demonstration, we'll add authentication to the Swagger UI SPWA; the one which is built for us in the server skeleton.

The Swagger UI SPWA allows us to present an authenticated API, by default; it provides the UI elements required to authenticate via an Oauth implicit flow.

When users attempt to authenticate to get access to the API, the Swagger UI will be directed to an Auth0 login page.

The Auth0 page will give the user the option of signing-in, or signing up. Whether this option is given to them or not, is dependent on the configuration in the Auth0 account. The login page can be customised, also.

Once Auth0 has authenticated the user, it sends back a token in a redirect URL. The Swagger UI intercepts the URL, extracts the token and retains it.

Now, when the user uses the Swagger UI to send a request to a particular endpoint exposed by our service, it will send the token in the http header.

On receipt of an http request, our service verifies the token in the header, before it does anything else. If it checks out OK, the service will continue handling it. If not, it will immediately send back a 401 error, which will be shown by the Swagger UI. 

To verify the token our service will check first that it can be correctly decoded. Next, it will check that the information in it is safe. Finally, it will send the information to a special endpoint on Auth0's servers. 

To make this possible, the token is of a particular format: [JWT, or JSON Web Token](https://jwt.io/). JWTs are base64-encoded, so that they can be passed in a http authorization header as a Bearer type. For more information about how they are built, see [here](https://jwt.io/introduction/).

## Create an Auth0 account

Creating an Auth0 account couldn't be simpler: 

1. go to https://auth0.com/ and click on 'Sign-up'. 
2. you'll be presented with a choice of email address + password , or syndiction with Google, Facebook, or Github account. We used the email address option and used the same credentials as for our Heroku account earlier.
3. Next, you'll be asked for a 'tenant' domain name. It's used for authentication endpoints. We chose 'urbanwild'.
4. Also, make sure you choose the EU region to host your user account data. 
5. ![minipic](./documentation/resources/auth0_signup_2.png)
6. Finally, we'll let Auth0 know we're not really serious:
7. ![minipic](./documentation/resources/auth0_signup_3.png)
8. That's it! The account is created. You'll need to verify it. Do this by going to the inbox of the email address you gave to sign-up with. There will be an email waiting for you, with a 'verify your account' button.

## Set up your Auth0 account

Your Auth0 account needs to create settings for

1. A 'connection' to user database
2. An API
3. A SPWA client

### connection to user database

This is easy: we want Auth0 to handle our user accounts, so we will make no change to our account's default setting, which uses it's own database, called **Username-Password-Authentication**

### API

Creating an API in Auth0 is simply creating a configuration for the API which you want to protect.

Create an API in Auth0: 

1. select the APIs item in the list on the left, and then click the '+ CREATE API' button
2. ![auth0_create_api_1](./documentation/resources/auth0_create_api_1.png)
3. give the API entry a name, and an identifier: you'll see we're choosing to identify it via the organisation name 'urban wild'
4. the signing algorithm is very important here: make sure you set it to `RS256`.
5. ![auth0_create_api_2](./documentation/resources/auth0_create_api_2.png)
6. your API is created and you can now see it in the list:
7. ![auth0_create_api_3](./documentation/resources/auth0_create_api_3.png)

## Application

Creating an Application in Auth0 is simply adding a method by which it will be handling authorisation requests. In this case we want to enable a mechanism which can be used to authorise access by users via 'unsecure' applications. That is, those which expose code or data easily; such as those running in a browser: SPWAs

1. In your Auth0 dashboard, click on 'Applications'

2. Click on '+ CREATE APPLICATION':

3. ![auth0_create_app_1](./documentation/resources/auth0_create_app_1.png)

4. Provide an App Name, and choose the type of application you will be using

5. ![auth0_create_api_3](./documentation/resources/auth0_create_app_2.png)

6. Choosing the type of application here allows Auth0 to figure out the mechanism by which it will expect authorisation requests, and to supply you with helpful info and libraries

7. Since we're using the SwaggerUI, we'll choose SPWA. Click 'Create'

8. ![auth0_create_app_1](./documentation/resources/auth0_create_app_3.png)

9. Choose 'JS' for the tech.

10. ![auth0_create_app_1](./documentation/resources/auth0_create_app_4.png)

11. We've created the Application entry. Notice it's got a **Client ID** which we'll return to later.

12. Finally, we want to debug our app locally, which means we want to get an authentication callback to a page which our client will know to intercept, to obtain the JWT. Our Swagger UI SPWA uses a file called o2c.html. More about this later.

13. In Applications > Settings, put the following into **Allowed callback URLs**:

14. ```bash
    http://localhost:8080/docs/o2c.html
    ```

15. ![auth0_create_app_1](./documentation/resources/auth0_create_app_7.png)


## Redefine the interface

 We're going to make some changes to our interface definition, to add an authentication requirement onto the correct end-points. 

Ensure that you have the project downloaded to the local file system, and opened in VSCode (or your favorite editor...)

The file we're altering is the `/api/swagger.yaml`of the `WildLoggingDB` service project. 

### Change to localhost

We're going to do alot of the debugging on localhost, using VSCode.

Make the following change to the swagger.yaml file, so that it will send requests to our local server instance:

```yaml
#host: 'urbanwilddbapi.herokuapp.com:443'
host: localhost:8080
schemes:
#  - https
  - http
```



### Authentication Definition 

We're going to add an authentication definition first, which mirrors the definition we made for the Swagger UI SPWA in the Auth0 account.

1. Find the section `definitions`

2. Add the following code, before the section:

3. ```yaml
   securityDefinitions:
     urbanwild_admin_auth:
       type: "oauth2"
       authorizationUrl: "https://urbanwild.eu.auth0.com/authorize"
       flow: "implicit"
       scopes:
         admin: "Full Access"     
   ```

4. You will need to replace part of the authorizationURL with the domain you defined in Auth0. It's defined in Auth0: Applications > Settings > Domain

5. Now you can add the definition to the correct endpoints in the swagger.yaml file:

6. ```text
   DELETE /things/{id}
   PUT /things/{id}
   
   DELETE /events/{id}
   PUT /events/{id}
   ```

7. For example, here's the full definition for the `DELETE /things/{id}` endpoint (don't forget the importance of indentation!)

8. ```yaml
       delete:
         tags:
         - "wildlifelog"
         description: "Deletes a Thing"
         operationId: "deleteThingsThingid"
         parameters:
         - name: "thingid"
           in: "path"
           description: "Identifier of the Thing"
           required: true
           type: "string"
         responses:
           200:
             description: "Status 200"
           400:
             description: "Bad request"
           401:
             description: "Unauthorized"
         security:
         - urbanwild_admin_auth:
           - "admin"
  ```

### Adding scopes to the authentication
#### What are scopes?
1. You'll notice a term in in the securityDefinition above; 'scopes'
2. scopes are pretty big in OAuth; a scope can be seen as a capability or a priviledge which a client is granted when they access a system via its API.
3. when a client uses an OAuth service to provide user authorisation for an API, it can supply the scopes it wants within the authorisation request.
4. the OAuth service looks up the user associated with the authorisation request, and checks the vaility of the requested scope
5. If the scope is valid, the OAuth server puts it into the authorisation token result.
6. The client can then pass the authorization token to the API with each http request
7. Some endpoints will require different scopes
8. For example an endpoint might provide company data with one scope, and more sensitive data with another.

### Adding the 'admin' scope to the Auth0 API
We're going to ensure that the `wildlogginadmin` authorization adds an 'admin' scope to its token.
1. In your Auth0 account, click on the API again, to check out the detail:
2. ![auth0_create_api_4](./documentation/resources/auth0_create_api_4.png)
3. in addition to the 'settings' tab, you'll find the 'scopes' tab. Click on it.
4. ![auth0_create_api_5](./documentation/resources/auth0_create_api_5.png)
5. now add a scope entry called `admin`, and give it a description
6. you can see that it's no more than a tag, associated with this wildloggingadmin API.
7. Auth0 has the apbility let you assoicate these scopes with users in the database, so you can give them extra privileges on your API.
8. For now, we're just using the one scope.



### Modifying the client

Now we need to modify our SwaggerUI to properly handle our Authentication with Auth0.

To explain:

Our Auth0 account is for our 'urbanwild' organisation; all authorizations for APIs belonging to our organisation will begin with a request to our **authorization domain**:

`urbanwild.eu.auth0.com`

Our account can handle multiple APIs, so an authorization request must tell Auth0 what API it's for. That's the **API Audience**

`https://www.urbanwild/wildloggingadmin`

The request must come from a known client, so that OAuth can understand what authorization flow mechanism it needs. For that we use a **Client ID**

`Find the Client ID in 'Applications'. Our Swagger UI SPWA entry has its own.` 

 For reasons of it's own, Auth0 also requires the **App Name** in the request:

`Find theApp name in'Applications'. We called our app 'SwaggerUI' `

There are a number of other items which are checked for in the request which aren't necessarilly needed, but we've found will cause the process to barf (technical term) if they are missing.

**We will modify the SwaggerUI, so we can automatically inject these items into the request.**

#### A new Swagger UI client

You will see from the `package.json` file, that the project has a dependency on `swagger-tools` and, if you take a look in `\node_modules\swagger-tools\middleware`, you'll see the swagger-ui. A closer look at the source code reveals that our swagger-generated server code currently runs version 2.1.4, which is fine.

The source code is all there, waiting for modification. 

**We can't modify this code, because it has been installed by npm, and cannot be checked in.**

We need to get our own version of the source, and modify that.

1. Download the swagger-ui 2.2.10 version, by going to its release in GitHub, [here](https://github.com/swagger-api/swagger-ui/tree/v2.2.10)

2. Click on the clone or download button, and choose 'download ZIP'

3. extract the contents of the zip file in your downloads directory.

4. copy the 'dist' directory from the contents into your project, at the root level

5. rename the 'dist' directory to 'swagger_spwa'

6. ![swagger_spwa_1](./documentation/resources/swagger_spwa_1.png)

7. We need to tell our server to deploy this version of the swagger-ui, rather than the bundled one

8. in `index.js` 

9. **replace**

10. ```javascript
     // Serve the Swagger documents and Swagger UI
     app.use(middleware.swaggerUi());
     ```

    ```

11. **with**

12. ```javascript
        // Serve the Swagger documents and Swagger UI
        app.use(middleware.swaggerUi(
           {swaggerUiDir: path.join(__dirname, './swagger_spwa')}
        ));
   ```

13. Test it, by re-running the server, and going to `http://localhost:8080/docs`. It will look different, and won't be displaying our interface any more. More mods needed!

#### Swagger UI will read our set-up from a .js file

 We're going to put all our set-up values into a .js file, which will be deployed to the browser with the rest of the Swagger UI SPWA.

**Don't worry!** No client secrets will be exposed.

1. create the file: `authproviderconfig.js` in `./swagger_spwa`

2. add the following javascript, substituting the values from your account where necessary:

3. ```javascript
   var auth_config = 
   { 
       "clientId": "SUBSTITUTE_YOUR_CLIENT__ID", 
       "appName": "SUBSTITUTE_YOUR_APP_NAME", 
       "clientSecret": "dummy", 
       "realm": "dummy", 
       "scopeSeparator": " ", 
       "additionalQueryStringParams": { 
           "audience": "SUBSTITUTE_YOUR_AUDIENCE", 
           "nonce": "123456" 
       } 
   }
   ```

4. replace the contents of the `index.html`file with the following

5. ``` html
   
   <!DOCTYPE html>
   <html>
   <head>
     <meta charset="UTF-8">
     <title>Swagger UI</title>
     <link rel="icon" type="image/png" href="images/favicon-32x32.png" sizes="32x32" />
     <link rel="icon" type="image/png" href="images/favicon-16x16.png" sizes="16x16" />
     <link href='css/typography.css' media='screen' rel='stylesheet' type='text/css'/>
     <link href='css/reset.css' media='screen' rel='stylesheet' type='text/css'/>
     <link href='css/screen.css' media='screen' rel='stylesheet' type='text/css'/>
     <link href='css/reset.css' media='print' rel='stylesheet' type='text/css'/>
     <link href='css/print.css' media='print' rel='stylesheet' type='text/css'/>
     <script src='lib/jquery-1.8.0.min.js' type='text/javascript'></script>
     <script src='lib/jquery.slideto.min.js' type='text/javascript'></script>
     <script src='lib/jquery.wiggle.min.js' type='text/javascript'></script>
     <script src='lib/jquery.ba-bbq.min.js' type='text/javascript'></script>
     <script src='lib/handlebars-4.0.5.js' type='text/javascript'></script>
     <script src='lib/js-yaml.min.js' type='text/javascript'></script>
     <script src='lib/lodash.min.js' type='text/javascript'></script>
     <script src='lib/backbone-min.js' type='text/javascript'></script>
     <script src='swagger-ui.js' type='text/javascript'></script>
     <script src='lib/highlight.9.1.0.pack.js' type='text/javascript'></script>
     <script src='lib/highlight.9.1.0.pack_extended.js' type='text/javascript'></script>
     <script src='lib/jsoneditor.min.js' type='text/javascript'></script>
     <script src='lib/marked.js' type='text/javascript'></script>
     <script src='lib/swagger-oauth.js' type='text/javascript'></script>
     <script src='lib/url.js' type='text/javascript'></script>
     <script src='authproviderconfig.js' type='text/javascript'></script>
   
     <!-- Some basic translations -->
     <!-- <script src='lang/translator.js' type='text/javascript'></script> -->
     <!-- <script src='lang/ru.js' type='text/javascript'></script> -->
     <!-- <script src='lang/en.js' type='text/javascript'></script> -->
   
     <script type="text/javascript">
       $(function () {
         function initSwaggerUi (url) {
   
           // Pre load translate...
           if(window.SwaggerTranslator) {
             window.SwaggerTranslator.translate();
           }
           window.swaggerUi = new SwaggerUi({
             url: url,
             dom_id: "swagger-ui-container",
             supportedSubmitMethods: ['get', 'post', 'put', 'delete', 'patch'],
             onComplete: function(swaggerApi, swaggerUi){
               if(typeof initOAuth == "function") {
                 var auth_config = window.auth_config;
                 initOAuth(
                   auth_config
                 );
               }
   
               if(window.SwaggerTranslator) {
                 window.SwaggerTranslator.translate();
               }
             },
             onFailure: function(data) {
               log("Unable to Load SwaggerUI");
             },
             docExpansion: "none",
             jsonEditor: false,
             defaultModelRendering: 'schema',
             showRequestHeaders: false,
             showOperationIds: false
           });
   
           window.swaggerUi.load();
   
           function log() {
             if ('console' in window) {
               console.log.apply(console, arguments);
             }
           }
         }
         
         $.ajax({
           type: "HEAD",
           async: true,
           url: document.location,
           error: function (xhr, status, thrown) {
             log("Unable to get the Swagger UI URL from the server: " + thrown);
           },
           success: function (message, text, response) {
             var url = response.getResponseHeader('Swagger-API-Docs-URL');
   
             if (!url) {
               url = window.location.search.match(/url=([^&]+)/);
   
               if (url && url.length > 1) {
                 url = decodeURIComponent(url[1]);
               } else {
                 url = "http://petstore.swagger.io/v2/swagger.json";
               }
             }
   
             initSwaggerUi(url);
           }
         });
       });
     </script>
   </head>
   
   <body class="swagger-section">
   <div id='header'>
     <div class="swagger-ui-wrap">
       <a id="logo" href="http://swagger.io">swagger</a>
       <form id='api_selector'>
         <div class='input'><input placeholder="http://example.com/api" id="input_baseUrl" name="baseUrl" type="text"/></div>
         <div class='input'><input placeholder="api_key" id="input_apiKey" name="apiKey" type="text"/></div>
         <div class='input'><a id="explore" href="#" data-sw-translate>Explore</a></div>
       </form>
     </div>
   </div>
   
   <div id="message-bar" class="swagger-ui-wrap" data-sw-translate>&nbsp;</div>
   <div id="swagger-ui-container" class="swagger-ui-wrap"></div>
   </body>
   </html>
   
   ```




#### Test

Running this up on `http://localhost:8080/docs` should allow you to request an an authorization token, although, the server won't know what to do with it:

1. Select an authorizing endpoint from the new Swagger UI
2. ![swagger_spwa_1](./documentation/resources/swagger_api_localhost_auth_1.png)

3. Click on the (!) to click-off an authorization attempt.
4. ![swagger_spwa_2](./documentation/resources/swagger_api_localhost_auth_2.png)
5. Click on 'Authorize'
6. ![swagger_spwa_3](./documentation/resources/swagger_api_localhost_auth_3.png)
7. Since we have no users currently represented in the account, the only option is to sign-up and create one. Create yourself a user, with a password.
8. ![swagger_spwa_4](./documentation/resources/swagger_api_localhost_auth_4.png)
9. Auth0 is asking if SwaggerUI can be allowed to represent the user we just created. This is where the **client id** comes in. Click the tick to allow SwaggerUI to attempt access.
10. Note: this is the one 'danger' with implicit flow: spoofing of an app with a client id, since the client id is exposed. There are now even more secure alternatives. 
11. To be careful, make sure your `authproviderconfig.js` is never checked in.
12. ![swagger_spwa_5](./documentation/resources/swagger_api_localhost_auth_5.png)
13. We now have an authorization token.



### Remove Sign-up by default from the Auth0 account

Now we have our one user signed-up, it's time to ensure that we don't over-extend our obligations, and remove the facility from the UI.

1. Go to the 'connections' area in your Auth0 account
2. You have one 'database' connection: 'Username-Password-Authentication'. Select this one, and view its detail
3. You'll see a setting 'Disable sign-ups'. **make sure this is checked**
4. Note: you can still create new users on the account, using the dashboard.

### Use our service to configure its Swagger UI from wherever it's deployed

You'll have noticed that there is a lot to do when we set-up an authenticated service. We try and minimise the hassle wherever we can. One way is to store our essential client set-up values in environment varables on the server: when the server is started, we can read them, and put them in the `authproviderconfig.js` file for the SPWA to pick up. Here's how:

1. Setup environment variables

2. On Heroku, you'll remember you can set environment variables in the applications's settings

3. On localhost, these variables are accessible when you debug using VSCode, if you place them in the `./launch.json file`

4. Here, we've set up the main variables: 

5. ```json
   {
       "version": "0.2.0",
       "configurations": [
           {
               "type": "node",
               "request": "launch",
               "name": "Launch Program",
               "program": "${workspaceFolder}/index.js",
               "env": {
                   "DATABASE_URL":"postgres://fljsdlfjsdsdfdssd:lalalalalalalalalalalalalalalalalalalalalala@ec2-99-999-99-999.eu-west-1.compute.amazonaws.com:5432/kgerwkgergergreger",
                   "AUTH_CLIENT_ID": "SUBSTITUTE_YOUR_CLIENT__ID", 
                   "AUTH_APP_NAME": "SUBSTITUTE_YOUR_APP_NAME", 
                   "AUTH_AUDIENCE": "SUBSTITUTE_YOUR_AUDIENCE"
               }
           }
       ]
   }
   ```

6. In the `./index.js` file of your service, add these functions which read the environment variables and build the `authproviderconfig.js` file:

7. ```javascript
   // builds a configuration for the client app, from environment variables 
   // so that the server can be deployed to multiple domains from the same source
   var getAuthClientConfig = function(){
     var result = {};
   
       // Used in Auth0's authentication process to identify the client
       if(!process.env.AUTH_CLIENT_ID) throw new Error("undefined in environment: AUTH_CLIENT_ID");
       if(!process.env.AUTH_APP_NAME) throw new Error("undefined in environment: AUTH_APP_NAME");
       if(!process.env.AUTH_AUDIENCE) throw new Error("undefined in environment: AUTH_AUDIENCE");
   
       
       result.clientId = process.env.AUTH_CLIENT_ID;
       result.appName = process.env.AUTH_APP_NAME;
       result.clientSecret = "dummy";
       result.realm =  "dummy";
       result.scopeSeparator =  " ";
       result.additionalQueryStringParams = {};
       result.additionalQueryStringParams.audience = process.env.AUTH_AUDIENCE;
       result.additionalQueryStringParams.nonce = "123456";
   
     return result;
   }
   
   
   // client configuration file is written to the folder which gets downloaded to the SPWA in the browser.
   var writeAuthClientConfig = function (config){
     var authenticationClientConfig = config;
     var authenticationClientContent = "var auth_config = " + JSON.stringify(authenticationClientConfig);
     fs.writeFileSync('./swagger_spwa/authproviderconfig.js', authenticationClientContent);
   }
   
   ```

8. Make a call to the functions, when you're initialising everything else:

9. **replace**

10. ```javascript
    // database connection
    database.initialise(dbUrl, true);
    ```

11. 

12. **with**

13. ```javascript
    // configure where the SwaggerUI looks for authentication
    writeAuthClientConfig(getAuthClientConfig());
    
    // database connection
    database.initialise(dbUrl, true);
    
    ```


### Modify the service to handle token-based authorisation

You'll have noticed that this swagger-generated service relies alot on the swagger middleware components. These handle the routing of http requests to their handler code, via a mapping to their interface definition in the `swagger.yaml`.

The middleware components also provide a handy way of authorising a request, before it's seen by the handler code, by applying it to a plugin authorization function.

In the `swagger.yaml`,  you'll see this in the `security` term of an endpoint definition:

```
      security:
        - urbanwild_admin_auth:
            - admin
```

In this section we'll be providing the `urbanwild_admin_auth` handler, and plugging it in to the middle ware.

#### Environment Variables

To authenticate the incoming authorisation token, we need to contact Auth0's service. We need to know where this is, so we'll store the URIs in the environment variables:

**AUTH_URI** - `https://<your auth0 domain>/authorize`

example: `https://urbanwild.eu.auth0.com/authorize`

**RSA_AUTH_URI** - `https://<your auth0 domain>/.well-known/jwks.json`

example: `https://urbanwild.eu.auth0.com//.well-known/jwks.json`



1. set your environment variables up again in the `launch.json` file, you're working with VSCode:

2. ```json
   {
       "version": "0.2.0",
       "configurations": [
           {
               "type": "node",
               "request": "launch",
               "name": "Launch Program",
               "program": "${workspaceFolder}/index.js",
               "env": {
                   "DATABASE_URL":"postgres://fljsdlfjsdsdfdssd:lalalalalalalalalalalalalalalalalalalalalala@ec2-99-999-99-999.eu-west-1.compute.amazonaws.com:5432/kgerwkgergergreger",
                   "AUTH_CLIENT_ID": "SUBSTITUTE_YOUR_CLIENT__ID", 
                   "AUTH_APP_NAME": "SUBSTITUTE_YOUR_APP_NAME", 
                   "AUTH_AUDIENCE": "SUBSTITUTE_YOUR_AUDIENCE",
                   "AUTH_URI": "SUBSTITUTE_YOUR_URI",
                   "RSA_URI": "SUBSTITUTE_YOUR_URI"
               }
           }
       ]
   }
   ```



#### Setting up 

1. Add to your `./index.js file` :

2. **replace**

3. ```javascript
   var dbUrl = process.env.DATABASE_URL;
   ```

4. **with**

5. ```javascript
   var dbUrl = process.env.DATABASE_URL;
   
   // URL provided by the Auth0 authentication PaaS
   if(!process.env.AUTH_URI) throw new Error("undefined in environment: AUTH_URI");
   var authUrl = process.env.AUTH_URI;
   
   
   // RSA Authentication, supplied by Auth0 authentication PaaS.
   if(!process.env.RSA_URI) throw new Error("undefined in environment: RSA_URI");
   var rsaUri = process.env.RSA_URI;
   ```

6. we're going to add the authentication handler functionality in a single file:

7. **replace** :

8. ```javascript
   var cors = require('cors');
   ```

9. **with** : 

10. ```javascript
    var cors = require('cors');
    var auth = require('./utils/authentication');
    ```

11. we're going to initialise this 'authentication handler', here, too:

12. **replace** : 

13. ```javascript
    
        // Interpret Swagger resources and attach metadata to request - must be first in swagger-tools middleware chain
        app.use(middleware.swaggerMetadata());
    
   ```

14. **with** : 

15. ```javascript
      // database connection
      database.initialise(dbUrl, true);
      // initialise authentication
      auth.initialise(rsaUri);
      ```

16. make it explicit where the authentication is. Substitute the value from the environment variables in to the `swagger.yaml, so it can be read by the SwaggerUI:

17. **replace** :

18. ```javascript
    var swaggerDoc = jsyaml.safeLoad(spec);
    ```

19. **with** :

20. ```javascript
    var swaggerDoc = jsyaml.safeLoad(spec);
    
    var secDefs = swaggerDoc.securityDefinitions;
    for (var secDef in secDefs) {
        console.log("changing: " + secDefs[secDef].authorizationUrl + " : to : " + authUri);
        secDefs[secDef].authorizationUrl = authUri;
    }
    ```

21. finally, plug-in the authentication handler:

22. **replace**:

23. ```javascript
      // Interpret Swagger resources and attach metadata to request - must be first in swagger-tools middleware chain
      app.use(middleware.swaggerMetadata());
      ```

24. **with:**

25. ```javascript
      // Interpret Swagger resources and attach metadata to request - must be first in swagger-tools middleware chain
      app.use(middleware.swaggerMetadata());
          
      // Provide the security handlers
      app.use(middleware.swaggerSecurity({
        urbanwild_admin_auth: auth.authorisation_handler
      }));
      ```

26. now create a file for the authentication handler: `./utils/authentication.js`:

27. ```javascript
    'use strict';
    
    var libjwt = require('jsonwebtoken');
    var libjwks = require('jwks-rsa');
    var authParser = require('auth-header');
    var error = require('./error');
    
    const supported_algorithms = {
        rsa: "RS256"
    };
    
    const supportedScopes = {
        admin: "admin" // can alter and delete existing data
    }
    
    
    const NOT_FOUND = -1;
    
    var jwks_client = null;
    
    
    var initialise = function (rsa_uri) {
    
        jwks_client = libjwks({
            cache: true,
            rateLimit: true,
            jwksRequestsPerMinute: 5, // Default value
            jwksUri: rsa_uri
        });
    
    
    };
    
    
    var get_access_token = function (req) {
        var authHeader = req.headers.authorization;
        var auth = authParser.parse(authHeader);
        var token = null;
        if (auth.scheme == "Bearer") {
            token = auth.token;
        }
        return token;
    }
    
    // attempt to verify the RSA signature of the access token, and then decode it.
    var validate_RSA_access_token = function (token, kid, callback) {
        jwks_client.getSigningKey(kid, (err, key) => {
            if (!err) {
                const signingKey = key.publicKey || key.rsaPublicKey;
                libjwt.verify(
                    token,
                    signingKey,
                    function (err, decoded) {
                        callback(err, decoded);
                    }
                );
            } else {
                callback(err, null);
            }
        });
    }
    
    
    
    var hasAuthorisedScope = function (scopeString, authorisedScopes) {
        var result = false;
        if (scopeString && scopeString.length > 0) {
            var scopes = Object.keys(authorisedScopes);
    
            for (var index = 0; index < scopes.length; index++) {
                var scope = scopes[index];
                if (scopeString.indexOf(scope) != NOT_FOUND) {
                    result = true;
                    break;
                }
            }
        }
        return result;
    }
    
    
    
    
    
    var authorisation_handler = function (req, def, scopes, callback) {
    
        var err = null;
    
        // get the access token from the incoming request
        var access_token = get_access_token(req);
    
        if (access_token) {
            // the access token is JWT - Base64 encoded, with signature
            var decoded_token = libjwt.decode(access_token, { complete: true });
    
            if (decoded_token) {
                if (decoded_token.header.alg == supported_algorithms.rsa) {
                    // the authorizing authority has defined the API as requiring RSA security
    
                    // get the key id to pass to the RSA endpoint during validation
                    var kid = decoded_token.header.kid;
    
                    validate_RSA_access_token(
                        access_token,
                        kid,
                        function (err, valid_token) {
                            if (!err) {
                                if (hasAuthorisedScope(valid_token.scope, supportedScopes)) {
                                    callback(null, valid_token);
                                } else {
                                    callback(error.create401Error("admin scope is required for this service."));
                                }
                            } else {
                                callback(error.create401Error(err.message));
                            }
                        });
    
                } else {
                    callback(error.create401Error("unsupported JWT algorithm"));
                }
            } else {
                callback(error.create401Error("could not decode token"));
            }
        } else {
            callback(error.create401Error("token not found"));
        }
    }
    
    
    module.exports = {
        SUPPORTED_SCOPES: supportedScopes,
        initialise: initialise,
        authorisation_handler: authorisation_handler
    };
    ```

28. Finally, we'll need to add the extra dependencies to your project. In a terminal, at the root directory:

29. ```bash
    npm install auth-header
    npm install jsonwebtoken
    npm install jwks-rsa
    ```



Now you should be able to run on local host. Use the Swagger UI to attempt to access both authenticated and non-authenticated endpoints :-)

### Deploying

There are a couple of things which we need to do before deploying, so our authentication system will work:

* Add more environment variables, to override the API location in the swagger.yaml
  * This means we can have multiple deployments from the same source code
* Add the new environment variables to Heroku
* Add the deployed callback page to Auth0

#### API location variables

We're going to add some environment variables which override specific settings in the `swagger.yaml` for the location of the API. 

You'll recall that the SwaggerUI application will read the `swagger.yaml` in order to know where to send HTTP requests to, to access the API.

Having the location of the API set in the swagger.yaml ties the deployment to the information in the repository. If you want the API to have a nice SPWA, it means you can only deploy it to location specified in the yaml. That means only one deployment per copy of the repo.

##### Localhost by default

We'll point our `swagger.yaml` at localhost, by default:

```yaml
swagger: '2.0'
info:
  description: ''
  version: 1.6.0
  title: theurbanwild
  contact:
    name: alicedigitallabs@gmail.com
    email: alicedigitallabs@gmail.com
host: localhost:8080
schemes:
  - http
```

We'll add some code in the server to check for the following optional environment variables:

* API_DOMAIN

* API_PORT

* API_SCHEME

These variables override the values in the `swagger.yaml` ONLY IF THEY ARE SET. The repo is then set up for local debugging by default.

Here are the changes we made to the the `index.js` file in the server, to do it:

 

```javascript
var secDefs = swaggerDoc.securityDefinitions;
for (var secDef in secDefs) {
    console.log("changing: " + secDefs[secDef].authorizationUrl + " : to : " + authUri);
    secDefs[secDef].authorizationUrl = authUri;
}


var getSwaggerUIConfig = function(){
  var result = {};

  result.scheme = process.env.API_SCHEME;
  result.domain = process.env.API_DOMAIN;
  result.port = process.env.API_PORT;
  result.existingPort = process.env.PORT; // assigned by Heroku if deployed.
  
  return result;

}

var writeSwaggerUIConfig = function(swaggerDoc, env){

  var doc = {};
  doc.scheme = swaggerDoc.schemes[0];  //WILL THROW IF SCHEMES NOT DEFINED IN DOC
  doc.domain = swaggerDoc.host.split(':')[0];  //WILL THROW IF HOST NOT DEFINED IN DOC 
  doc.port = swaggerDoc.host.split(':')[1];  //WILL THROW IF PORT NOT DEFINED IN DOC  
  
  if (env.existingPort){
    console.log("remote deployment has already defined port");
    if(env.port){
      
      doc.port = env.port; // override (useful for consistency, or if the remote service is not heroku, and listening on a different port.)
      console.log("external facing port env variable is set. Updating swagger.yaml with this value: %s", doc.port);
    }else{
      doc.port = 443; // override the setting with Heroku's default external facing port
      console.log("external facing port env variable is unset. Updating swagger.yaml with default value: %s", doc.port);
    }
  }else{
    console.log("local deployment.");
    if(env.port){
        doc.port = env.port; //override (useful if you have lots of servers running on local host)
        console.log("overriding swagger.yaml port to env variable: %s", doc.port);
    }else{
        env.port = doc.port;
        console.log("env varable not defined for port. Setting to default from swagger.yaml: %s ", env.port );
    }
  }
  if(env.domain){
    doc.domain = env.domain; //override (useful if you want to deploy to a different server than specified in the yaml)
    console.log("overriding swagger.yaml domain to env variable: %s", doc.domain);
  }
  if(env.scheme){
    doc.scheme = env.scheme; // override (useful if you want to deploy to a different comms scheme than that defined in the yaml.
    console.log("overriding swagger.yaml scheme to env variable: %s", doc.scheme);
  }
  
  var hostAddrPort = doc.domain + ":" + doc.port;
  var schemes = [doc.scheme];

  swaggerDoc.host = hostAddrPort;
  swaggerDoc.schemes = schemes;
  
  return swaggerDoc;
}

var swaggerUIConfig = getSwaggerUIConfig();
swaggerDoc = writeSwaggerUIConfig(swaggerDoc, swaggerUIConfig);
var serverPort = swaggerUIConfig.existingPort || swaggerUIConfig.port;
```

... you'll notice we have to deal with a number of scenarios - especially since Heroku routes http traffic through port 443 into a totally different port whichthe NodeJS instance must listen for.

####  Adding the Environment Variables to Heroku

This is pretty straight-forward. Just take the values which you put into your VSCode `launch.json` file:

* AUTH_CLIENT_ID
* AUTH_APP_NAME
* AUTH_AUDIENCE
* AUTH_URI
* RSA_URI

... and the others, which you be able to obtain from your heroku settings:

* API_DOMAIN

- API_PORT

- API_SCHEME

Like this:

![swagger_spwa_4](./documentation/resources/heroku_deploy_9.png)



#### Adding the callback page to Auth0

You'll remember that the implicit flow needs to call-back to a web-page with the authorization token, and that Auth0 needs to make sure this is allowed. The SwaggerUI SPWA uses `o2c.html`, but this is now served from our deployed service, and not localhost.

In your Auth0 account, you'll need to change the setting for

**Applications > Settings > Allowed Callback URLs**

Simply change the domain from localhost, to the one you deployed to. In our case, it's  `urbanwilddbapi.herokuapp.com`: 



![swagger_spwa_4](./documentation/resources/auth0_create_app_8.png)



## Release

This release marks the API working with the SwaggerUI SPWA, having several authenticated endpoints. 

The WildLogging SPWA is unaffected by this, as it doens't use these endpoints

- This release tag on the WildLoggingDB repo: [authentication_supported](https://github.com/aliceliveprojects/WildLoggingDB/releases/tag/spwa_supported)

You can find the final release [here](https://aliceliveprojects.github.io/WildLogging/#/home):

![final](./documentation/resources/final_release.png)

You can find the Swagger SPWA [here](https://urbanwilddbapi.herokuapp.com/docs/#/)

![final](./documentation/resources/final_swaggerui_release.png)

