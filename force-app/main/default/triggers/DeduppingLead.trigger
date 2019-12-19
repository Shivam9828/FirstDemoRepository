trigger DeduppingLead on Lead (before insert,before update) {

    for(lead ld : trigger.new) {
        if(ld.email!=null) {
            list<contact> conRecord = [select id from contact where email=:ld.email];
            if(conRecord.size()>0){
                    ld.contact__c = conRecord[0].id;}
                }
                else {
                    ld.contact__c = null;
                
    }
        }
    
}