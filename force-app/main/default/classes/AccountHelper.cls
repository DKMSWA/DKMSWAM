public class AccountHelper {
    public static void process() {
        // Triggers Missing Component / Unmet Dependency if Custom_Setting__c is not in the branch or target org
        List<Sample_Custom_Setting__c> settings = [SELECT Id, Non_Existent_Field__c FROM Sample_Custom_Setting__c];

        // Triggers Missing Component if MissingUtilityClass is omitted from the branch
        MissingUtilityClass.doWork();
    }
}