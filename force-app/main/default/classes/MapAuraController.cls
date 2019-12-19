public class MapAuraController {
     
    @AuraEnabled
    public static map<Integer, String> getMap(){
        Map<Integer, String> companyMap = new Map<Integer, String>();
        //Put value in Map 
        companyMap.put(1,'Salesforce');
        companyMap.put(2,'SAP');  
        companyMap.put(3,'Oracle');  
        companyMap.put(4,'Microsoft');  
        //return map  
        return companyMap;
    }
}