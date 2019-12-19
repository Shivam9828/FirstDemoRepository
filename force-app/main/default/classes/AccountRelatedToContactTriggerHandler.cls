public class AccountRelatedToContactTriggerHandler {

    public static void conRelatedToAcc(Map<id,Account> newAccount, Map<id,Account> oldMap) {
       
        list<Account> accList = new list<Account>();
        for(Id newRecords : newAccount.keySet()) {
            if(newAccount.get(newRecords).phone != oldMap.get(newRecords).phone) {
                accList.add(newAccount.get(newRecords));
            }
        }
        Map<id,Account> conListRelated = new  Map<id,Account>([Select Id,Phone,(Select Id,Phone from Contacts) from Account where Id in:accList]);
        Map<id,list<contact>> fetchContactList = new Map<id,list<contact>>();
        for(Account acc : conListRelated.values()) {
            if(acc.contacts.size()>0) {
                fetchContactList.put(acc.id,acc.contacts);
            }
        }
        
        list<contact> conUpdate = new list<contact>();
        for(Id accId : fetchContactList.keyset()) {
            list<contact> conForUpdate = new list<contact>();
            conForUpdate = fetchContactList.get(accId);
            for(Contact con : conForUpdate) {
                Account acc = conListRelated.get(accId);
                con.phone = acc.Phone;
                conUpdate.add(con);
            }
        }
        update conUpdate;
    }    
}