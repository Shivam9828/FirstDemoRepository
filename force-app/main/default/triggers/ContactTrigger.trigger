trigger ContactTrigger on Contact (after insert, before Insert, before update, after update) {
    if ((Trigger.isInsert || Trigger.isUpdate) && Trigger.isAfter) {
        Set<Id> setofAccountId = new Set<Id>();
        for(Contact objCon : trigger.new)
            setofAccountId.add(objCon.accountid);
        //Get all account contact related values
        Date dToday = System.Today();
        Datetime dt = datetime.newInstance(dToday.year(), dToday.month(),dToday.day());
        Map<Id,Account> mapofAccIdToContacts = new Map<Id,Account>([Select Id,(Select Id From Contacts where CreatedDate =today) From Account Where Id IN : setofAccountId]);
        for(Contact objCon : trigger.new){
            if(mapofAccIdToContacts.containskey(objCon.accountID) && mapofAccIdToContacts.get(objCon.accountID).Contacts.size() > 2){
                objCon.addError('cannot have more than 2 contacts per account');}
        }
    }
}