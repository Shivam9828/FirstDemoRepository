/**
 * Controller class for GenericRecordHandler Lightning Component
 * Contains method to retrieve objects and records
 * @author - Manish Choudhari
 * */
public class GenericRecordHandler {
	
    // This method retrieves all object list from Salesforce Org
    // You can filter out object list here, as per you use case
    @AuraEnabled(cacheable=true)
    public static List<ObjectWrapper> getObjects(){
		List<ObjectWrapper> objectList = new List<ObjectWrapper>();
        for ( Schema.SObjectType sObjType : Schema.getGlobalDescribe().values() ) {
            Schema.DescribeSObjectResult objResult = sObjType.getDescribe();
			objectList.add(new ObjectWrapper(objResult.getName(), objResult.getLabel(), objResult.isCustom()));
        }
        return objectList;
    }
	
	// Get record from a specific object
	// Here I am simply retrieving 200 records without any filteration
	// but you may want to put some filter in your query    
    @AuraEnabled(cacheable=true)
    public static List<sObject> getRecords(String objectName){
		return Database.query('SELECT Id, Name FROM '+objectName+' LIMIT 200');
    }
    
    //Object wrapper class having object properties like name, label and isCustom
    public class ObjectWrapper{
        @AuraEnabled public String objectName;
        @AuraEnabled public String objectLabel;
        @AuraEnabled public Boolean isCustom;
        ObjectWrapper(String objectName, String objectLabel, Boolean isCustom){
            this.objectName = objectName;
            this.objectLabel = objectLabel;
            this.isCustom = isCustom;
        }
    }
}