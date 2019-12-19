public class CountContactsInAccountHandler {

    public static void CountContacts(List<Contact> newContact) {
        set<id> actIds = new set<id>();
        for(Contact con : newContact) {
            actIds.add(con.accountId);
        }
        
        List<Account> actList = [select id,Count_Of_Contacts__c,
                                                               (SELECT id FROM Contacts) FROM Account WHERE id IN : actIds];
        Map<id,List<Contact>> mapAcc = new Map<id,List<Contact>>();
        list<Account> updateAccount = new List<Account>();
        for(Account acc : actList) {
              acc.Count_Of_Contacts__c = acc.Contacts.size();
            updateAccount.add(acc);
        }
        update updateAccount;
    }
}