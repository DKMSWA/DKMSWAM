
/**
 * Test class for HelloWorld.
 * Covers all public methods (createHelloAccount, sayHello) with positive and negative scenarios.
 */
@isTest
public class HelloWorldTest {

    /**
     * Tests the positive scenario for createHelloAccount.
     * Verifies that an Account is created with the expected field values and can be queried back.
     */
    @isTest
    static void testCreateHelloAccountPositive() {
        // Test data
        String accountName = 'Test Account';

        // Start test execution context
        Test.startTest();

        // Call the method under test
        Account result = HelloWorld.createHelloAccount(accountName);

        // Stop test execution context
        Test.stopTest();

        // Verify that the account was created and returned
        System.assertNotEquals(null, result, 'Account should be created successfully.');

        // Query the account from the database to ensure it was inserted
        Account savedAccount = [SELECT Id, Name, Industry, Rating, Phone, Description 
                                FROM Account 
                                WHERE Id = :result.Id 
                                LIMIT 1];

        // Verify all fields were set correctly
        System.assertEquals(accountName, savedAccount.Name, 'Name should match input.');
        System.assertEquals('Technology', savedAccount.Industry, 'Industry should be set to Technology.');
        System.assertEquals('Hot', savedAccount.Rating, 'Rating should be set to Hot.');
        System.assertEquals('080-1234-5678', savedAccount.Phone, 'Phone should be set correctly.');
        System.assertEquals('Hello World from ' + accountName, savedAccount.Description, 'Description should be constructed correctly.');
    }

    /**
     * Tests the negative scenario for createHelloAccount.
     * Passing a null account name should cause a DmlException (Account.Name is required),
     * which is caught and the method returns null.
     */
    @isTest
    static void testCreateHelloAccountNegative() {
        // Start test execution context
        Test.startTest();

        // Call the method under test with null name (should trigger DmlException)
        Account result = HelloWorld.createHelloAccount(null);

        // Stop test execution context
        Test.stopTest();

        // Verify that the method returned null due to the failed insert
        System.assertEquals(null, result, 'Method should return null when insert fails.');
    }

    /**
     * Tests the positive scenario for sayHello.
     * Verifies that the method creates an Account and returns the expected greeting string.
     */
    @isTest
    static void testSayHelloPositive() {
        // Expected greeting string based on the fixed account name in sayHello
        String expectedMessage = 'Hello World! Hello World Inc. | Technology | Hot | Hello World from Hello World Inc.';

        // Start test execution context
        Test.startTest();

        // Call the method under test
        String actualMessage = HelloWorld.sayHello();

        // Stop test execution context
        Test.stopTest();

        // Verify the returned message matches the expected format
        System.assertEquals(expectedMessage, actualMessage, 'sayHello should return the correct greeting message.');
    }

    /**
     * Tests the negative scenario for sayHello.
     * Simulates a user without permission to create Accounts, causing the insert
     * inside createHelloAccount to fail. The method should then return 'Could not create account.'
     */
    @isTest
    static void testSayHelloNegative() {
        // Find a profile that does not have create permission on Account.
        // Prefer a profile with a standard Salesforce user license for typical user creation.
        List<Profile> profiles = [
            SELECT Id 
            FROM Profile 
            WHERE Id IN (
                SELECT ParentId 
                FROM ObjectPermissions 
                WHERE SobjectType = 'Account' 
                AND PermissionsCreate = false
            )
            AND UserLicense.Name = 'Salesforce'
            LIMIT 1
        ];

        // Fallback: if no such profile with standard license, pick any profile without Account create permission
        if (profiles.isEmpty()) {
            profiles = [
                SELECT Id 
                FROM Profile 
                WHERE Id IN (
                    SELECT ParentId 
                    FROM ObjectPermissions 
                    WHERE SobjectType = 'Account' 
                    AND PermissionsCreate = false
                )
                LIMIT 1
            ];
        }

        // If no suitable profile is found, skip the test (should not happen in most orgs)
        if (profiles.isEmpty()) {
            return;
        }

        Profile profileWithoutAccountCreate = profiles[0];

        // Create a test user with the selected profile
        User testUser = new User(
            Username = 'testuser' + System.now().getTime() + '@example.com',
            LastName = 'Test',
            Email = 'testuser@example.com',
            Alias = 'tuser',
            CommunityNickname = 'tuser' + System.now().getTime(),
            TimeZoneSidKey = 'America/New_York',
            LocaleSidKey = 'en_US',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            ProfileId = profileWithoutAccountCreate.Id
        );
        insert testUser;

        // Execute as the test user who lacks Account create permission
        System.runAs(testUser) {
            // Start test execution context
            Test.startTest();

            // Call the method under test; internal insert will fail due to permissions
            String result = HelloWorld.sayHello();

            // Stop test execution context
            Test.stopTest();

            // Verify the method returns the failure message
            System.assertEquals('Could not create account.', result, 'sayHello should return failure message when account creation fails.');
        }
    }
}
