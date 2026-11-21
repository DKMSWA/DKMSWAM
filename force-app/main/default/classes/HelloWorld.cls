public class HelloWorld {

    // Sets a greeting on standard fields of the given accounts (no DML here)
    public static void addHelloWorld(List<Account> accs) {
        for (Account a : accs) {
            a.Description = 'Hello World from ' + a.Name;
        }
    }

    // Creates an Account using standard fields and saves it
    public static Account createHelloAccount() {
        Account acc = new Account(
            Name = 'Hello World Inc.',
            Industry = 'Technology',
            Description = 'Hello World!'
        );
        insert acc;
        return acc;
    }

    // Queries the account back and prints a greeting
    public static void sayHello() {
        Account acc = createHelloAccount();
        Account saved = [SELECT Id, Name, Industry, Description
                         FROM Account WHERE Id = :acc.Id LIMIT 1];
        System.debug('Hello World! ' + saved.Name + ' | ' + saved.Industry + ' | ' + saved.Description);
    }
}