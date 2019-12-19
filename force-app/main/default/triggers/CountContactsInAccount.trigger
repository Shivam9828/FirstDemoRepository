trigger CountContactsInAccount on Contact (after insert,after delete) {

    if(trigger.isInsert) {
        CountContactsInAccountHandler.CountContacts(trigger.new);
    }
     if(trigger.isDelete) {
        CountContactsInAccountHandler.CountContacts(trigger.old);
    }
}