
/**
 * An apex page controller that exposes the site login functionality.
 */
global with sharing class SiteLoginController {
    /**
     * The username and password supplied by the user on the login page.
     */
    global String username {get; set;}
    global String password {get; set;}

    /**
     * Authenticates the user and redirects to the requested start URL.
     */
    global PageReference login() {
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        return Site.login(username, password, startUrl);
    }
    
    /**
     * Constructs a new SiteLoginController instance.
     */
   	global SiteLoginController () {}
}
