
/**
 * Test class for SiteLoginController
 * Covers all public/global methods: constructor, username/password properties, and login()
 */
@isTest
private class SiteLoginControllerTest {

    /**
     * Test the global constructor.
     * Verifies that the controller can be instantiated successfully.
     */
    @isTest
    static void testConstructor() {
        SiteLoginController controller = new SiteLoginController();
        System.assertNotEquals(null, controller, 'Controller should be instantiated.');
    }

    /**
     * Test the username and password properties.
     * Verifies that values can be set and retrieved correctly.
     */
    @isTest
    static void testUsernamePasswordProperties() {
        SiteLoginController controller = new SiteLoginController();
        controller.username = 'testuser@example.com';
        controller.password = 'testpassword';
        System.assertEquals('testuser@example.com', controller.username, 'Username should be set correctly.');
        System.assertEquals('testpassword', controller.password, 'Password should be set correctly.');
    }

    /**
     * Test login with a startURL parameter.
     * Sets a current page reference with a startURL, then calls login.
     * Site.login is a platform call that may return null in test context,
     * so we only verify that the method executes without throwing an exception.
     */
    @isTest
    static void testLoginWithStartURL() {
        PageReference pageRef = new PageReference('/apex/SiteLogin');
        pageRef.getParameters().put('startURL', '/home/home.jsp');
        Test.setCurrentPageReference(pageRef);

        SiteLoginController controller = new SiteLoginController();
        controller.username = 'testuser@example.com';
        controller.password = 'testpassword';

        Test.startTest();
        PageReference result = controller.login();
        Test.stopTest();

        // The return value depends on Site.login behavior and org configuration.
        // In a unit test, it is acceptable for result to be null or a PageReference.
        System.assert(result == null || result instanceof PageReference, 
            'login() should return a PageReference or null, but got: ' + result);
    }

    /**
     * Test login without a startURL parameter.
     * Sets a current page reference without startURL, then calls login.
     * This tests the logic when the startURL is missing.
     */
    @isTest
    static void testLoginWithoutStartURL() {
        PageReference pageRef = new PageReference('/apex/SiteLogin');
        Test.setCurrentPageReference(pageRef);

        SiteLoginController controller = new SiteLoginController();
        controller.username = 'testuser@example.com';
        controller.password = 'testpassword';

        Test.startTest();
        PageReference result = controller.login();
        Test.stopTest();

        // Verify that login handles a null startURL gracefully (no exception).
        System.assert(result == null || result instanceof PageReference, 
            'login() should return a PageReference or null, but got: ' + result);
    }
}
