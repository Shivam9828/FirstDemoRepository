trigger AccountRelatedToContactTrigger on Account (after update) {
   AccountRelatedToContactTriggerHandler.conRelatedToAcc(Trigger.newMap, Trigger.oldMap);
    
}