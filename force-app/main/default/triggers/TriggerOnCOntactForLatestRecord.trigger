trigger TriggerOnCOntactForLatestRecord on Contact (before insert) {
    set<id> conId = new set<id>();
    List<Contact> conList = [select id,check__c from contact where id IN : trigger.new order by CreatedDate desc limit 1];
    for(contact con : conList) {
        con.check__c = true;
        
    }
}