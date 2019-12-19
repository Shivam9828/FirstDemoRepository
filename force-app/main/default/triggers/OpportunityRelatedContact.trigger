trigger OpportunityRelatedContact on Opportunity (after insert, after update) { 
{
Map<Id,Id> instructorsToOppsMap = new Map<Id,Id>();
    for(Opportunity A : trigger.new) {
           instructorsToOppsMap.put(A.accountId,A.Id);
 }
List<Account> contactsToUpdate = new List<Account>{};
      
    for (Account Instructor: [SELECT Id,industry FROM Account WHERE Id IN:  instructorsToOppsMap.keySet()])
    {
        Id oppId = instructorsToOppsMap.get(Instructor.Id);
        Opportunity opp = trigger.newMap.get(oppId);
        if (opp.StageName=='Prospecting'){
            Instructor.industry='Education';
             contactsToUpdate.add(instructor);
         }
}
if(contactsToUpdate != null && !contactsToUpdate.isEmpty())
        Database.update(contactsToUpdate);
}}