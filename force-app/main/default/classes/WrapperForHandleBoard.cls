public class WrapperForHandleBoard {

    @AuraEnabled public Map<String,List<sobject>> mapRec{get;set;}
    @AuraEnabled public Map<string,string> mapForLabelWithId{get;set;}
    @AuraEnabled public List<sobject> objRecords{get;set;}
    
}