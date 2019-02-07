## Enabling Third-Party Authentication

This script takes you through adding **Third-Party authentication** to the API which you have already enabled for First-Party authentication.

First Party Authentication means that we will only grant access to the authenticated parts of the API to a SPWA which has been **served from the same domain as the API**. In this case, that means the **SwaggerUI** you developed in the last script.

Because of Cross-Origin restrictions, the browser **won't support the use of SPWAs served from other domains** (such as GitHub Pages) . 

To do that, we need to enable the Auth0 account, and we need to add some athentication smarts to the SPWA.

In this case, the SPWA we'll be upgrading is **WildLogging**. 

We will add:

* An Admin landing page, which handles login and logout
* A Things page, which handles listing and deleting of Things
* An Events page, which handles listing and deleting of Events

First though, the Account.

## Auth0 Third Party Authentication

When you set up your account with Auth0, you're given the ability to add applications and APIs to a Tenant. 

In this case, the Tenant is the same as our organisation: Urban Wild.







