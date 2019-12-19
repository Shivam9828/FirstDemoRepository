trigger AccountNotDeleted on Account (before delete)  
{  
    
    Set<id> accIdSet = new Set<id>();  
    for(Account acc : Trigger.old)  
    {  
        accIdSet.add(acc.id);  
    }  

    Map<Id, Account> accts = new Map<Id, Account>([Select Id, (Select Id from contacts) from Account where id in :accIdSet]);

    for(Account acc : Trigger.old)
    {
        if(accts.get(acc.id).contacts.size()>0)
        {
            acc.adderror('Account cannot be deleted');
            }
        }                                       

}