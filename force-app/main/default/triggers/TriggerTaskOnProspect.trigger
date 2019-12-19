Trigger TriggerTaskOnProspect on Prospect__c (before insert,before update,after update,after insert,before delete, after Delete) {

    IF(Trigger.isBefore) {
    IF(Trigger.isInsert || Trigger.isUpdate){
        
    TriggerTaskOnProspectHandler.updateChildWithParent(Trigger.new);
        }
        }
    IF(Trigger.isAfter && Trigger.isUpdate && TriggerTaskOnProspectHandler.runOnce){
        TriggerTaskOnProspectHandler.runOnce = false;
        TriggerTaskOnProspectHandler.afterUpdateCondition(Trigger.oldMap,Trigger.NewMap);
        
    }
    IF(Trigger.isAfter){
        IF(Trigger.isInsert && TriggerTaskOnProspectHandler.runOnce){
            TriggerTaskOnProspectHandler.runOnce = false;
            TriggerTaskOnProspectHandler.conditionForActiveRecord(Trigger.new);
        }
    }
    
    IF(Trigger.isAfter && Trigger.isUpdate && TriggerTaskOnProspectHandler.runOnce) {
         TriggerTaskOnProspectHandler.runOnce = false;
         TriggerTaskOnProspectHandler.afterUpdateProspect(Trigger.NewMap, Trigger.oldMap);
           
    }
    
    IF(Trigger.isAfter && Trigger.isDelete) {
        TriggerTaskOnProspectHandler.afterDeleteCondition(Trigger.old);
    }
    
    IF(Trigger.isBefore && Trigger.isUpdate) {
        TriggerTaskOnProspectHandler.beforeUpdateCondition(Trigger.New);
        }
}