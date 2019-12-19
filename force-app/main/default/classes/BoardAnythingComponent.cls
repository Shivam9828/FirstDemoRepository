public class BoardAnythingComponent {
    @AuraEnabled
    public static string boardRecordId{get;set;}
    @AuraEnabled
    public static string boardRecordLabel{get;set;}
    
    @AuraEnabled
    public static Map<String,String> getInitialValues(){
        List<CCBoardAnything__Board_Configuration__c>  boardRecord  = [select id,CCBoardAnything__Board_Label__c from CCBoardAnything__Board_Configuration__c];
        Map<String,String> labelWithId = new Map<String,String>();
        if(boardRecord.size()>0) {
            for(CCBoardAnything__Board_Configuration__c bbc : boardRecord) {
                labelWithId.put(bbc.CCBoardAnything__Board_Label__c,bbc.id);
            } 
        }
        return labelWithId;
    }
    
    @AuraEnabled
    public static List<String> ObjName(){
        List<String> objNameList = new List<String>();
        List<Schema.SObjectType> Sobjectlist = Schema.getGlobalDescribe().values();
        for(Schema.SObjectType Sobj : Sobjectlist){
            Schema.DescribeSObjectResult fieldResult = Sobj.getDescribe();
            // System.debug('fieldResult : '+fieldResult  );
            if(fieldResult.isAccessible() && fieldResult.isCreateable() && fieldResult.isUpdateable() && fieldResult.isSearchable()  && !fieldResult.isCustomSetting()){
                if(fieldResult.getName() != 'Task' && fieldResult.getName() != 'Attachment' && fieldResult.getName() != 'CaseComment' && fieldResult.getName() != 'Macro' &&
                   fieldResult.getName() != 'ContentVersion' && fieldResult.getName() != 'Document' && fieldResult.getName() != 'EmailTemplate' &&
                   fieldResult.getName() != 'Event' && fieldResult.getName() != 'FeedComment' && fieldResult.getName() != 'FeedItem' && fieldResult.getName() != 'DandBCompany' &&
                   fieldResult.getName() != 'Group' && fieldResult.getName() != 'Note' && fieldResult.getName() != 'PermissionSet' && fieldResult.getName() != 'CollaborationGroup' &&
                   fieldResult.getName() != 'Topic' && fieldResult.getName() != 'UserRole' && fieldResult.getName() != 'User' && fieldResult.getName() != 'Idea' &&
                   fieldResult.getName() != 'IdeaComment' && fieldResult.getName() != 'Config_Object__c' && fieldResult.getName() != 'CCBoardAnything__Board_Configuration__c'){
                       // System.debug('ObjList : '+ObjList);
                       
                       objNameList.add(fieldResult.getName());
                   }
            }
        }if(objNameList.size()>0){
            objNameList.sort();   
        }
        return objNameList;
    }
    
    @AuraEnabled
    public static list<string> getlistValues(string objectInfo){
        list<String> listViewLabels = new list<string>();
        //list<listViewWrapper> oListViewWrapper = new list<listViewWrapper>();
        
        for(ListView lv : [SELECT id, Name, DeveloperName FROM ListView
                           WHERE sObjectType = : objectInfo]){ 
                               listViewLabels.add(lv.Name);
                           }
        listViewLabels.sort();
        return listViewLabels; 
    }
    
    @AuraEnabled
    public static list<string> getGroupFieldValues(string objectInfo){
        system.debug('!!!!!!!');
        Map<String, schema.Sobjectfield> fieldMap = new Map<String, schema.Sobjectfield>();
        List<String> groupingFieldsList = new List<String>();
        fieldMap = Schema.getGlobalDescribe().get(String.escapeSingleQuotes(objectInfo)).getDescribe().fields.getMap();
        for(schema.Sobjectfield sobjfield : fieldMap.values()){
            Schema.DescribeFieldResult fieldResult = sobjfield.getDescribe();
            String tempfieldName = fieldResult.getName();
            
            if(fieldResult.isAccessible() && !fieldResult.isUnique() && !fieldResult.isRestrictedPicklist() && !fieldResult.isNameField() && fieldResult.isUpdateable() && (fieldResult.getType() != Schema.DisplayType.Reference) && !fieldResult.isCalculated()){
                if(fieldResult.getType() != Schema.DisplayType.TextArea && fieldResult.getType() != Schema.DisplayType.ID && fieldResult.getType() != Schema.DisplayType.Email && fieldResult.getType() != Schema.DisplayType.URL &&
                   !tempfieldName.contains('Phone') && fieldResult.getName() != 'FirstName' && fieldResult.getName() != 'LastName' && fieldResult.getName() != 'Name' && fieldResult.getName() != 'ActivatedDate' && fieldResult.getName() != 'Subject' &&
                   !tempfieldName.contains('Latitude') && !tempfieldName.contains('Longitude') && !tempfieldName.contains('PostalCode') && fieldResult.getName() != 'SuppliedName' && fieldResult.getName() != 'Salutation' &&
                   fieldResult.getName() != 'AccountNumber' && fieldResult.getName() != 'Birthdate' && fieldResult.getName() != 'Fax'){
                       
                       groupingFieldsList.add(fieldResult.getName());
                       
                   }
                
            }
        }
        system.debug('groupingFieldsList'+groupingFieldsList);
        groupingFieldsList.sort();
        system.debug('groupingFieldsListAfter=='+groupingFieldsList);
        return groupingFieldsList;
    }
    @AuraEnabled
    public static list<string> getSummaryFieldValues(string objectInfo){
        Map<String, schema.Sobjectfield> fieldMap = new Map<String, schema.Sobjectfield>();
        List<String> summaryfieldlist = new List<String>();
        fieldMap = Schema.getGlobalDescribe().get(String.escapeSingleQuotes(objectInfo)).getDescribe().fields.getMap();
        for(schema.Sobjectfield sobjfield : fieldMap.values()){
            Schema.DescribeFieldResult fieldResult = sobjfield.getDescribe();
            String tempfieldName = fieldResult.getName();
            if(fieldResult.isAccessible() && ( fieldResult.getType() == Schema.DisplayType.Currency || fieldResult.getType() == Schema.DisplayType.INTEGER )){
                
                summaryfieldlist.add(fieldResult.getName());
                
            }
            
        }
        system.debug('groupingFieldsList'+summaryfieldlist);
        return summaryfieldlist;
    }
    
    
    @AuraEnabled
    public static list<Wrapper> getTemplateFieldValues(string objectInfo){
        Map<String, schema.Sobjectfield> fieldMap = new Map<String, schema.Sobjectfield>();
        list<Wrapper> tmpFields = new list<Wrapper>();
        fieldMap = Schema.getGlobalDescribe().get(String.escapeSingleQuotes(objectInfo)).getDescribe().fields.getMap();
        for(schema.Sobjectfield sobjfield : fieldMap.values()){
            Schema.DescribeFieldResult fieldResult = sobjfield.getDescribe();
            String tempfieldName = fieldResult.getName();
            if(fieldResult.isAccessible() && fieldResult.getName() != 'IsDeleted' && (fieldResult.getType() != Schema.DisplayType.Id)
               && ( String.valueOf(fieldResult.getType()).toLowerCase() != 'reference' ) 
               && (fieldResult.getType() != Schema.DisplayType.TextArea) && !tempfieldName.contains('Address') &&
               !tempfieldName.contains('Latitude') && !tempfieldName.contains('Longitude') && !tempfieldName.contains('PostalCode')){
                   tmpFields.add(new Wrapper(fieldResult.getName()));
               }
            
        }
        system.debug('tmpFields=='+tmpFields);
        return tmpFields;
    }
    
    //Method for checking  header list greater than 30 or not
    @AuraEnabled
    public Static boolean checkHeaderValues(String selectedObj,String selectedGroupingField){
        Boolean checkHeaderSet = false;
        Set<Object> tempSet = new Set<Object>();
        String objectName = String.escapeSingleQuotes(selectedObj);
        String fieldNames = String.escapeSingleQuotes(selectedGroupingField);
        String queryString = 'Select '+ fieldNames +' from '+ objectName +' Limit 10000';
        
        for(Sobject sobj : Database.query(queryString)){
            tempSet.add(sObj.get(selectedGroupingField));
            if(tempSet.size()==30){
                checkHeaderSet = true;
                break;
            }
            
        }
        return checkHeaderSet;
    } 
    
    @AuraEnabled
    public Static WrapperForHandleBoard insertBoardRecord(String selectedGroupingField,String selectedListView, String selectedObj, String inputLable,String selectedSummaryField, List<String> templateSelectedField, Integer tmplimit){
        system.debug('object'+selectedObj);
        system.debug(selectedGroupingField);
        system.debug('selectedListView=='+selectedListView);
        String groupinFieldMessage = '';
        WrapperForHandleBoard wfh = new WrapperForHandleBoard();
        Map<string,string> boardLabel = new Map<string,string>();
        String queryString = 'select id,name from '+ selectedObj;
        List<sobject> recordList =  Database.query(queryString);
        wfh.objRecords = recordList;
        //  system.debug('In here 1');
        
        system.debug('templateSelectedField='+templateSelectedField);
        CCBoardAnything__Board_Configuration__c boardObj = new CCBoardAnything__Board_Configuration__c();
        boardObj.CCBoardAnything__Grouping_Field__c = selectedGroupingField;
        boardObj.CCBoardAnything__List_View_ID__c = selectedListView;
        boardObj.CCBoardAnything__Object_Name__c = selectedObj;
        boardObj.CCBoardAnything__Board_Label__c = inputlable;
        boardObj.CCBoardAnything__SummaryFieldName__c = selectedSummaryField;
        boardObj.CCBoardAnything__Template_Fields__c = string.join(new List<string>(templateSelectedField), ',');
        boardObj.CCBoardAnything__Template_Field_Limit__c = Decimal.valueOf(tmplimit);
        system.debug('tmplimit=='+boardObj.CCBoardAnything__Template_Field_Limit__c);
        String BoardId; 
        try{
            system.debug('insert');
            
            insert boardObj;
            boardLabel.put(boardObj.CCBoardAnything__Board_Label__c,boardObj.Id);
            BoardId =  boardObj.Id;
            wfh.mapForLabelWithId = boardLabel;
            
        }
        catch(Exception e){
            system.debug(e);
        }
        
        if(!string.isEmpty(BoardId)) {
        wfh.mapRec = getBoardRecord(BoardId);
            }
        system.debug('wfh=='+wfh);
          return wfh;
    }
    
    
    
    @AuraEnabled
    public static Map<String,List<sobject>> getBoardRecord(String recordId){
        Map<String,List<sobject>> recordmap = new Map<String,List<sobject>>();
        CCBoardAnything__Board_Configuration__c  boardRecord  = [select id,CCBoardAnything__Object_Name__c,CCBoardAnything__SummaryFieldName__c,CCBoardAnything__Template_Fields__c,CCBoardAnything__Grouping_Field__c from CCBoardAnything__Board_Configuration__c where id =:recordId];
        List<String> listOfTemplateFields =  boardRecord.CCBoardAnything__Template_Fields__c.split(',');
        system.debug('Object=='+boardRecord.CCBoardAnything__Object_Name__c);
        system.debug('Group=='+boardRecord.CCBoardAnything__Grouping_Field__c);
        //system.debug('ListView=='+boardRecord.CCBoardAnything__List_View_ID__c);
        system.debug('listOfTemplateFields'+listOfTemplateFields);
        String recordFields = '';
        for(String fieldnames : listOfTemplateFields){
            if(recordFields==null ||recordFields=='' && fieldnames != boardRecord.CCBoardAnything__Grouping_Field__c){
                recordFields = fieldnames;
            }
            else{
                if(fieldnames != boardRecord.CCBoardAnything__Grouping_Field__c && fieldnames!=null) {
                    
                recordFields += ','+fieldnames;
                    }
            }
        }
        system.debug('recordFields='+recordFields);
        List<string> fieldList = recordFields.split(',');
        system.debug('fieldList.size()='+fieldList.size());
        String queryString = '';
        if(fieldList.size()==1) {
            system.debug('null');
            queryString = 'select name,id,'+boardRecord.CCBoardAnything__Grouping_Field__c+' from '+ boardRecord.CCBoardAnything__Object_Name__c;
         
        }
        
        else {
            system.debug('Notnull');
             queryString = 'select name,id,'+recordFields+','+boardRecord.CCBoardAnything__Grouping_Field__c+' from '+ boardRecord.CCBoardAnything__Object_Name__c;
        }
            system.debug('queryString='+queryString);
        List<sobject> recordList =  Database.query(queryString);
        system.debug('recordList='+recordList);
        for(sobject recordObj :recordList){
            String groupfield;
            if(recordObj.get(boardRecord.CCBoardAnything__Grouping_Field__c) != null){         
                groupfield = (String)recordObj.get(boardRecord.CCBoardAnything__Grouping_Field__c);
                if(!recordmap.containsKey(groupfield)){
                    recordmap.put(groupfield,new List<sobject>{recordObj});                
                }
                else{
                    recordmap.get(groupfield).add(recordObj);      
                }
            }        
            else{
                  if(!recordmap.containsKey('[Blank Value]')){
                      recordmap.put('[Blank Value]',new List<sobject>{recordObj}); 
                  }
                else{
                     recordmap.get('[Blank Value]').add(recordObj);  
                }     
            }
        }
        system.debug('Map'+recordmap);
        return recordmap;
    }  
    
    @AuraEnabled
    public static WrapperForLabelChange getBoardRecordForLabelCHange(String recordId){
       
        Map<String,List<sobject>> recordmap = new Map<String,List<sobject>>();
        WrapperForLabelChange wfl = new WrapperForLabelChange();
        CCBoardAnything__Board_Configuration__c  boardRecord  = [select id,CCBoardAnything__Object_Name__c,CCBoardAnything__SummaryFieldName__c,CCBoardAnything__Template_Fields__c,CCBoardAnything__Grouping_Field__c from CCBoardAnything__Board_Configuration__c where id =:recordId];
        List<String> tmpList =  boardRecord.CCBoardAnything__Template_Fields__c.split(',');
        system.debug('Object=='+boardRecord.CCBoardAnything__Object_Name__c);
        system.debug('Group=='+boardRecord.CCBoardAnything__Grouping_Field__c);
        //system.debug('ListView=='+boardRecord.CCBoardAnything__List_View_ID__c);
        system.debug('listOfTemplateFields'+tmpList);
        wfl.tmpListForLabel = string.join(new List<string>(tmpList), ',');
        String recordFields = '';
        
        for(String fieldnames : tmpList){
            
            if(recordFields == null || recordFields == '' && fieldnames != boardRecord.CCBoardAnything__Grouping_Field__c){
                recordFields = fieldnames;
            }
            else{
			if(fieldnames != boardRecord.CCBoardAnything__Grouping_Field__c && fieldnames!=null) {
                recordFields += ','+fieldnames;
				}
            }
        }
        system.debug('recordFields='+recordFields);
        //wfl.tmpListForLabel = recordFields;
        
        String queryString = '';
        
        if(recordFields==null) {
            system.debug('null');
            queryString = 'select name,id'+boardRecord.CCBoardAnything__Grouping_Field__c+' from '+ boardRecord.CCBoardAnything__Object_Name__c;
         
        }
        
        else {
            system.debug('Notnull');
             queryString = 'select name,id,'+recordFields+','+boardRecord.CCBoardAnything__Grouping_Field__c+' from '+ boardRecord.CCBoardAnything__Object_Name__c;
        }
       
        set<sobject> recSet = new set<sobject>();
        List<sobject> recList =  Database.query(queryString);
        system.debug('recList='+recList);
        //recSet.addAll(recSet);
        Map<Id,SObject> mp = new Map<Id,SObject>(recList);
        recSet.addAll(mp.values());
        system.debug('mp='+mp);
        system.debug('recSet='+recSet);
        List<sobject> recordList = new List<sobject>();
        recordList.addAll(recSet);
        system.debug('recordList='+recordList);
        for(sobject recordObj :recordList){
            String groupfield;
            if(recordObj.get(boardRecord.CCBoardAnything__Grouping_Field__c) != null){         
                groupfield = (String)recordObj.get(boardRecord.CCBoardAnything__Grouping_Field__c);
                if(!recordmap.containsKey(groupfield)){
                    recordmap.put(groupfield,new List<sobject>{recordObj});                
                }
                else{
                    recordmap.get(groupfield).add(recordObj);      
                }
            }        
            else{
                  if(!recordmap.containsKey('[Blank Value]')){
                      recordmap.put('[Blank Value]',new List<sobject>{recordObj}); 
                  }
                else{
                     recordmap.get('[Blank Value]').add(recordObj);  
                }     
            }
        }
        system.debug('Map'+recordmap);
        wfl.objRecords = recordmap;
        system.debug('wfl=='+wfl.tmpListForLabel);
        return wfl;
   
    }    
    
    @AuraEnabled
    public static List<wrapperForGroup> fetchCheckedGroup(List<String> grpFields){
        List<wrapperForGroup> wfg = new List<wrapperForGroup>();
        for(String grp : grpFields) {
            wfg.add(new wrapperForGroup(grp));
        }
        return wfg;
    }
    
     @AuraEnabled
    public static CCBoardAnything__Board_Configuration__c updateBoardRecord(Id boardId){
        system.debug('boardId=='+boardId);
        //WrapperForEditrecord wfe = new WrapperForEditrecord();
        CCBoardAnything__Board_Configuration__c  boardRecord  = [select id,CCBoardAnything__Object_Name__c,CCBoardAnything__Board_Label__c,CCBoardAnything__SummaryFieldName__c,CCBoardAnything__Template_Fields__c,CCBoardAnything__List_View_ID__c,CCBoardAnything__Grouping_Field__c from CCBoardAnything__Board_Configuration__c where id =:boardId];
        /*system.debug('Ummary@@'+boardRecord.CCBoardAnything__SummaryFieldName__c);
        wfe.objectName = boardRecord.CCBoardAnything__Object_Name__c;
        wfe.listViewValue = boardRecord.CCBoardAnything__List_View_ID__c;
        wfe.groupBy = boardRecord.CCBoardAnything__Grouping_Field__c;
        wfe.summary = boardRecord.CCBoardAnything__SummaryFieldName__c;
        wfe.tempFields = boardRecord.CCBoardAnything__Template_Fields__c.split(',');
        wfe.inputLabel = boardRecord.CCBoardAnything__Board_Label__c;*/
        
        
        system.debug('WrapperForEditrecord=='+boardRecord);
        return boardRecord;
    }
    
    @AuraEnabled
    public static Map<String,List<sobject>> updateBoardConfigRecord(String recId,string objName,string lstView, string grpName, string summary, list<string> tmpVal, String input, Boolean isDuplicate){
        CCBoardAnything__Board_Configuration__c cbc = [select id,CCBoardAnything__Object_Name__c,CCBoardAnything__Board_Label__c,CCBoardAnything__SummaryFieldName__c,CCBoardAnything__Template_Fields__c,CCBoardAnything__List_View_ID__c,CCBoardAnything__Grouping_Field__c from CCBoardAnything__Board_Configuration__c where id =:recId];
        system.debug('objName=='+objName);
        system.debug('objName=='+lstView);
        system.debug('objName=='+grpName);
        system.debug('objName=='+tmpVal);
         system.debug('objName=='+summary);
        cbc.CCBoardAnything__Object_Name__c = objName;
        cbc.CCBoardAnything__List_View_ID__c = lstView;
        cbc.CCBoardAnything__Grouping_Field__c = grpName;
        cbc.CCBoardAnything__Template_Fields__c = string.join(new List<string>(tmpVal), ',');
        cbc.CCBoardAnything__SummaryFieldName__c = summary;
        cbc.CCBoardAnything__Board_Label__c = input;
        String recordId='';
        try{
        UPDATE cbc;
        recordId = cbc.Id;
            }
        catch(Exception e) {
            system.debug('Exception=='+e);
        }
        Map<String,List<sobject>> recUpdated = getBoardRecord(recordId);
        return recUpdated;
    }
    
    @AuraEnabled
    public static void deleteBoardRecord(string brdId) {
        CCBoardAnything__Board_Configuration__c  boardRecord  = [select id from CCBoardAnything__Board_Configuration__c where id =:brdId];
        DELETE boardRecord;
    }
    
    public class wrapper{
        @AuraEnabled public Boolean checked;
        @AuraEnabled public String templateFields;
        wrapper(String templateFieldFetched){
            checked = false;
            templateFields = templateFieldFetched;
        }
    }
    
     public class wrapperForGroup{
        @AuraEnabled public Boolean checkGrp;
        @AuraEnabled public String groupField;
       public wrapperForGroup(String groupFieldChecked){
            checkGrp = true;
            groupField = groupFieldChecked;
        }
    }

    public class WrapperForEditrecord{
        @AuraEnabled public string objectName;
        @AuraEnabled public string listViewValue;
        @AuraEnabled public string groupBy;
        @AuraEnabled public string summary;
        @AuraEnabled public list<string> tempFields;
        @AuraEnabled public string inputLabel;
        
        /*public WrapperForEditrecord(string objectName,string listViewValue,string groupBy,string summary,list<string> tempFields,string inputLabel) {
            this.objectName = objectName;
            this.listViewValue = listViewValue;
            this.groupBy = groupBy;
            this.summary = summary;
            this.tempFields = tempFields;
            this.inputLabel = inputLabel;
        } 
       */
    }    
    
    public class WrapperForLabelChange {
       @AuraEnabled public string tmpListForLabel;
       @AuraEnabled public Map<String,List<sobject>> objRecords;
    }
    
}