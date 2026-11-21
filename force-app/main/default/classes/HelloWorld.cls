
/**
 * Utility class that creates and retrieves a hello world Account record.
 */
public class HelloWorld {

    /**
     * Creates and inserts an Account with standard fields for the given account name.
     */
    public static Account createHelloAccount(String accName) {
        Account acc = new Account(
            Name = accName,
            Industry = 'Technology',
            Rating = 'Hot',
            Phone = '080-1234-5678',
            Description = 'Hello World from ' + accName
        );
        try {
            insert acc;
        } catch (DmlException e) {
            System.debug('Insert failed: ' + e.getMessage());
            return null;
        }
        return acc;
    }

    /**
     * Creates the account, queries it back, and prints a greeting message.
     */
    public static String sayHello() {
        Account acc = createHelloAccount('Hello World Inc.');
        if (acc == null) {
            return 'Could not create account.';
        }
        Account saved = [SELECT Id, Name, Industry, Rating, Description
                         FROM Account WHERE Id = :acc.Id LIMIT 1];
        String msg = 'Hello World! ' + saved.Name + ' | ' + saved.Industry
                     + ' | ' + saved.Rating + ' | ' + saved.Description;
        System.debug(msg);
        return msg;
    }
}
