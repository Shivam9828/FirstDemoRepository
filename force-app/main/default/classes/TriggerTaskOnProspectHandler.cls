public class TriggerTaskOnProspectHandler {
    
    public static Boolean runOnce = true;
    
    public static void updateChildWithParent(List<Prospect__c> childProspectRecord) {
        
        Set<Id> parentIds = NEW Set<Id>();
        for (Prospect__c childProspect : childProspectRecord) {
            IF(childProspect.Parent_Prospect__c!=null){
                parentIds.add(childProspect.Parent_Prospect__c);
            }
        }
        
        
        Map<Id, Prospect__c> parentsById = NEW Map<Id, Prospect__c>();
        parentsById.putAll([SELECT Id, type__c FROM Prospect__c WHERE Id IN :parentIds]);
        
        for(Prospect__c childProspect:childProspectRecord){ 
            IF(parentsById.containskey(childProspect.Parent_Prospect__c) && childProspect.type__c!=parentsById.get(childProspect.Parent_Prospect__c).type__c) {
                childProspect.type__c=parentsById.get(childProspect.Parent_Prospect__c).type__c;
                childProspect.type__c=parentsById.get(childProspect.Parent_Prospect__c).type__c;
            }
        }
        
    }
    
    Public Static void beforeUpdateCondition(List<Prospect__c> listToBeUpdate) {
        Set<Id> parentId = NEW Set<Id>();
        Set<Id> childIds = NEW Set<Id>();
        for(Prospect__c pros : listToBeUpdate) {
            if(pros.Parent_Prospect__c!=null) {
                parentId.add(pros.Parent_Prospect__c);
                childIds.add(pros.id);
            }
        }
        
        For(Prospect__c prosParent : [SELECT id,(SELECT id,active__c FROM Prospects__r WHERE ID NOT IN : childIds) FROM Prospect__c WHERE ID IN : parentId]) {
            if(prosParent.Prospects__r.size()==0) {
                for(Prospect__c prosChild : listToBeUpdate) {
                    if(prosChild.Active__c==false){
                    prosChild.Active__c = true;
                        }
                }
            }
        }
        
    }
    
    public static void afterUpdateCondition(Map<Id,Prospect__c> OldMap,Map<Id,Prospect__c> NEWMap) {
        
        TriggerTaskOnProspectHandler.runOnce = true;
        Set<id> prospectIds = NEW Set<id>();
        for(Prospect__c prs : NEWMap.Values()){
            IF(prs.type__c!=OldMap.get(prs.id).type__c){
                prospectIds.add(prs.Id);
            }
        }
        
        List<Prospect__c> updateChildProspect = NEW List<Prospect__c>();
        for(Prospect__c prosRecord : [SELECT id,type__c,(SELECT id, type__c FROM Prospects__r) FROM prospect__c WHERE Id IN : prospectIds]){
            IF(prosRecord.Prospects__r.Size()>0){
                for(Prospect__c childPros : prosRecord.Prospects__r){
                    IF(childPros.type__c!=prosRecord.Type__c){
                        childPros.type__c = prosRecord.Type__c;
                        updateChildProspect.add(childPros);
                    }
                }
            }
        }
        
        update updateChildProspect;
    }
    
    public static void conditionForActiveRecord(List<Prospect__c> recordList) {
        system.debug('Insert');
        TriggerTaskOnProspectHandler.runOnce = true;
        Prospect__c lstRecord = [SELECT id,active__c,Parent_Prospect__c FROM Prospect__c WHERE id IN : recordList order by CreatedDate DESC limit 1];
        system.debug('lstRecord$$$'+lstRecord.id);
        List<Prospect__c> prosRecord = NEW List<Prospect__c>();  
        Set<Id> prosParentIds = NEW Set<Id>();
        Set<Id> childIds = NEW Set<Id>();
        
        Set<id> childProsIds = NEW Set<id>();
        
        for(Prospect__c pros : recordList){
            IF(pros.Parent_Prospect__c!=null){
                //mapOFparentsIds.put(pros.Parent_Prospect__c, pros.id);
                childIds.add(pros.id);
                prosParentIds.add(pros.Parent_Prospect__c);
                /*IF(pros.active__c == true){
                    IF(pros.Parent_Prospect__c!=null)
                        mapOfParents.put(pros.Parent_Prospect__c,childIds);
                    
                    
                }*/
            }
        }
        
        
        
        prosRecord = [SELECT id,active__c FROM Prospect__c
                      WHERE active__c=true AND Parent_Prospect__c IN:prosParentIds AND Id NOT IN:childIds];
        
        IF(prosRecord.size()>0) {
            for(Prospect__c pros:prosRecord)
                pros.active__c=false;
        }
        update prosRecord;
        
        List<Prospect__c> childRecords = [SELECT id,active__c FROM Prospect__c
                                          WHERE Parent_Prospect__c IN:prosParentIds AND Id IN:childIds];
        
        List<Prospect__c> updateChild = NEW List<Prospect__c>();
        system.debug('childRecords$$'+childRecords.size());
        
        
        IF(childRecords.size()>0) {
            
            for(Prospect__c ps : childRecords) {
                system.debug('Inner');
                
                IF(ps.id==lstRecord.id && lstRecord.Parent_Prospect__c!=null) {
                    ps.Active__c = true;
                    updateChild.add(ps);
                }
                else {
                    ps.Active__c = false;
                    updateChild.add(ps);
                }
                update updateChild;
                system.debug('Active=='+ps.Active__c);
            }
        }
        
    }
    
    
    public static void afterUpdateProspect(Map<id,Prospect__c> NEWRecords,Map<id,Prospect__c> oldValue) {
        
        TriggerTaskOnProspectHandler.runOnce = true;
        Set<id> parentIds = NEW Set<id>();
        Set<id> parentIdsForInActive = NEW Set<id>();
        Set<id> childActiveRecords = NEW Set<id>();
        Set<id> childNotActiveRecords = NEW Set<id>();
        List<Prospect__c> updateProsRecords = NEW List<Prospect__c>();
        Boolean isActive=false;
        Boolean isNotActive=false;
        for(Prospect__c pros : NEWRecords.values()) {
            IF(pros.active__c!=oldValue.get(pros.Id).active__c){
                IF(pros.Active__c==true) {
                    system.debug('Active__c==true');
                    isActive = true;
                    IF(pros.Parent_Prospect__c!=null){
                        parentIds.add(pros.Parent_Prospect__c);
                    }
                    childActiveRecords.add(pros.Id);
                }
                else {
                    system.debug('fghhjkl');
                    isNotActive = true;
                    parentIdsForInActive.add(pros.Parent_Prospect__c);
                    childNotActiveRecords.add(pros.Id);
                }
            }
        }
        
        
        
        IF(isActive==true) {
            for(Prospect__c psParent : [SELECT id,(SELECT id,active__c FROM Prospects__r WHERE active__c=true AND id NOT IN : childActiveRecords) FROM Prospect__c WHERE id IN : parentIds]) {
                
                IF(psParent.Prospects__r.size()>0) {
                    for(Prospect__c ps : psParent.Prospects__r){
                        ps.Active__c = false;
                        updateProsRecords.add(ps);
                    }
                }
            }
        }
        IF(isNotActive) {
            Prospect__c childPros = [SELECT id,active__c FROM Prospect__c WHERE id NOT IN : childNotActiveRecords AND Parent_Prospect__c=:parentIdsForInActive order by CreatedDate DESC LIMIT 1];
            for(Prospect__c psForActive : [SELECT id,active__c FROM Prospect__c WHERE id NOT IN : childNotActiveRecords AND Parent_Prospect__c =:parentIdsForInActive ]) {
                IF(psForActive.id == childPros.Id) {
                    psForActive.active__c = true;
                    updateProsRecords.add(psForActive);
                }
                else {
                    psForActive.active__c = false;
                    updateProsRecords.add(psForActive);
                }
            }
            
        }
        update updateProsRecords;
    }
    
    public static void afterDeleteCondition(List<Prospect__c> oldList) {
        system.debug('beforeDeleteCondition');
        Set<ID> parentIds = NEW Set<ID>();
        Set<ID> childToBeDeleted = NEW Set<ID>();
        For(Prospect__c pros : oldList) {
            IF(pros.Active__c==true){
                system.debug('$$$$');
                parentIds.add(pros.Parent_Prospect__c);
                childToBeDeleted.add(pros.Id);
            }
        }
        
        system.debug('childToBeDeleted=='+childToBeDeleted);
        List<Prospect__c> updateChild = NEW List<Prospect__c>();
        
        for(Prospect__c prosParent : [SELECT id,(SELECT id,active__c FROM Prospects__r WHERE ID NOT IN : childToBeDeleted order by CreatedDate DESC LIMIT 1) FROM Prospect__c WHERE ID IN : parentIds]) {
            system.debug('prosParent.Prospects__r.size()=='+prosParent.Prospects__r.size()); 
            system.debug('prosParent.Prospects__r.ID=='+prosParent.Prospects__r[0].id); 
            
            IF(prosParent.Prospects__r.size()>0) {
                prosParent.Prospects__r[0].active__c=true;
                updateChild.add(prosParent.Prospects__r[0]);
            } 
            
        }
        system.debug('updateChild'+updateChild);
        
        update updateChild;
    }
    
}