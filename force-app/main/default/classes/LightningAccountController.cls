global class LightningAccountController {
    @AuraEnabled global static void createAccountRecord(Account objAcc) {
        insert objAcc;
    }
    
     @AuraEnabled global static Map<string,string> getPicklistValue() {
        Map<string,string> options = new Map<string,string>();
         schema.DescribeFieldResult fieldResult = Account.Industry.getDescribe();
         //get Account Industry Picklist Values
        List<Schema.PicklistEntry> pList = fieldResult.getPicklistValues();
         for (Schema.PicklistEntry p: pList) {
            //Put Picklist Value & Label in Map
            options.put(p.getValue(), p.getLabel());
        }
         return options;
    }
}