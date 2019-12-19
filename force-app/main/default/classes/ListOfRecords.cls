global with sharing class ListOfRecords {

    @AuraEnabled
    public static AccountContactWrapper getObjectRecords() {
        AccountContactWrapper acw = new AccountContactWrapper();
        acw.accounts = [select id,name,industry,Phone from account limit 20];
        acw.contacts = [select id, firstname,lastname,email from contact limit 20];
        return acw;
    }
    
    @AuraEnabled
    public static List<contact> getContacts() {
        return [select id, firstname,lastname,email from contact limit 20];
    }
    
    @AuraEnabled
    public static List<account> getAccounts() {
        return [select id,name,industry,Phone from account limit 20];
    }
}