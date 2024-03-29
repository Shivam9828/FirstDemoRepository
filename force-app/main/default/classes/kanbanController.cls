public class kanbanController {
    
    @AuraEnabled
    public static kanbanWrap getKanbanWrap(String objName, String[] objFields, String kanbanField) {
        List<String> lstPickvals=new List<String>();
        for (Schema.PicklistEntry a : Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(kanbanField).getDescribe().getPickListValues())
            lstPickvals.add(a.getValue());
        System.debug(lstPickvals);
        
        String query = 'SELECT Id, ';
        for(String s:objFields){
            query += s+' ,';
        }
        query = query.removeEnd(',');
        query += ' FROM ' + objName;
        System.debug('qq  ' + query);
        
        return new kanbanWrap(Database.query(query), lstPickvals);
    }
    
    @AuraEnabled
    public static String getUpdateStage(Id recId, String kanbanField, String kanbanNewValue) {
        SObject o1 = recId.getSObjectType().newSObject(recId);
        o1.put(kanbanField,kanbanNewValue);
        update o1;
        return 'Success';
    }
    
    
    
    public class kanbanWrap{
        @AuraEnabled
        List<sObject> records {get;set;}
        @AuraEnabled
        List<String> pickVals {get;set;}
        
        public kanbanWrap(List<sObject> recs, List<String> pVals){
            this.records = recs;
            this.pickVals = pVals;
        }
    }
    
}