public class DynamicObjectExampleController {

    public String selectedSObject {get;set;}
    List<SelectOption> recordList {get;set;}//this list will hold record from selected sObject
    public String selectedRecord {get;set;}
    public Id selectedRecordId {get;set;}

    /*

    This method will add all sObjectName in sObjectNames list

    */

    public List<SelectOption> getSObjectNames(){

        List<SelectOption> sObjectNames = new List<SelectOption>();

        sObjectNames.add(new SelectOption('Select sObject', 'Select sObject'));

        for ( Schema.SObjectType type : Schema.getGlobalDescribe().values() ) {

            sObjectNames.add(new SelectOption(String.valueOf(type), String.valueOf(type)));//Fetch object name and add in selectoption list

        }

        return sObjectNames;

    }

    

    /*

     * This method will fetch available records in sObject upto 100 records

     * Modify soql filter and limit based on your need

     * You need to make sure the SOQL does not timeout and does not impact performance

     */

    public PageReference generateRecordList(){

        try{

            if(selectedSObject != null && selectedSObject != ''){          

                String recordQuery = 'SELECT Id, Name FROM '+selectedSObject+' LIMIT 100';

                List<sObject> records = Database.query(recordQuery);

                recordProcessing(Database.query(recordQuery), true);

            }

        } catch(Exception e){

            ApexPages.Message myMsg;

            try{

                String recordQuery = 'SELECT Id FROM '+selectedSObject+' LIMIT 100';

                recordProcessing(Database.query(recordQuery), false);

                myMsg= new ApexPages.Message(ApexPages.Severity.ERROR,'Selected sObject does have "Name" Field!!'

                                                            +'\nFetching only Id fields now');

            ApexPages.addMessage(myMsg);

            } catch(Exception e1){

myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Select valid sObject');

                ApexPages.addMessage(myMsg);    

            }

        }

        return null;

    }

    

    /*

     * This function will get recordId from selected record

     * */

    public PageReference changeSelectedRecord(){

        System.debug('function called');

        if(selectedRecord != null && selectedRecord != ''){

            if(selectedRecord.contains('-')){

            selectedRecordId = (ID)selectedRecord.split('-')[1].trim();

            } else{

                selectedRecordId = (ID)selectedRecord.trim();

            }

            System.debug('select record id---'+selectedRecordId);

        }

        return null;

    }

    

    /*

     * This method will do post processing on fetched records

     * */

    public void recordProcessing(List<sObject> records, boolean nameIncluded){

        if(recordList == null){

            recordList = new List<SelectOption>();

        } else{

            recordList.clear();

        }

        for(sObject sObj : records){

            String recordName;

            if(nameIncluded){

            recordName = String.valueOf(sObj.get('Name'))+' - '+String.valueOf(sObj.get('Id'));

            } else{

                recordName = String.valueOf(sObj.get('Id'));

            }

            recordList.add(new SelectOption(recordName, recordName));

        }

        

        if(recordList.size() == 0){

            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.INFO,'No record found for this sObject!!');

            ApexPages.addMessage(myMsg);

        }

    }

    

    public Id getSelectedRecordId(){

        return selectedRecordId;

    }

    

    public List<SelectOption> getRecordList(){

        return recordList;

    }

}