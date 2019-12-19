({
    fetchobjectnames : function(component,event,helper) {
        component.set('v.Spinner',true);
        var objfetch = component.get("c.ObjName");
        objfetch.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("objList", response.getReturnValue());
                component.set("v.objlist",response.getReturnValue());
                component.set("v.selectedObject",response.getReturnValue()[0]);
                console.log(response.getReturnValue()[0]);
                this.fetchListViewRecords(component,event,null);
                this.fetchGroupFieldsValues(component,event,null);
                this.getSummaryFieldValues(component,event,null);
                this.getTemplateFieldValues(component,event,null);
                component.set('v.Spinner',false);
            }
        });
        $A.enqueueAction(objfetch);
    },
    
    fetchListViewRecords : function(component,event,ObjectName) {
        var getObjectName='';
        if(ObjectName!=null){
        getObjectName = ObjectName;
            }
        else {
            getObjectName = component.get("v.selectedObject");
        }
        console.log(getObjectName);
        var action = component.get('c.getlistValues');
        action.setParams({
            "objectInfo" : getObjectName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {      
                if(response.getReturnValue().length>0) {
                console.log('List:',response.getReturnValue());
                component.set("v.listViewRecords",response.getReturnValue());
                if(component.get('v.isNew')) {
                    component.set('v.selectedListView',response.getReturnValue()[0]);
                }
                console.log('@@lst==',component.get('v.selectedListView'));
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchGroupFieldsValues : function(component,event,ObjectName) {
        var getObjectName='';
        if(ObjectName!=null){
        getObjectName = ObjectName;
            }
        else {
            getObjectName = component.get("v.selectedObject");
        }
        
        var action = component.get('c.getGroupFieldValues');
        action.setParams({
            "objectInfo" : getObjectName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length>0) {
                console.log('Group===',response.getReturnValue());
                component.set("v.groupByRecords",response.getReturnValue());
                if(component.get('v.isNew')) {
                    component.set('v.selectedGroupField',response.getReturnValue()[0]);
                }
                 console.log('@@Group==',component.get('v.selectedGroupField'));
            }
                }
        });
        $A.enqueueAction(action);
    },
    
    getSummaryFieldValues : function(component,event,ObjectName) {
         var getObjectName='';
        if(ObjectName!=null){
        getObjectName = ObjectName;
            }
        else {
            getObjectName = component.get("v.selectedObject");
        }
        var action = component.get('c.getSummaryFieldValues');
        action.setParams({
            "objectInfo" : getObjectName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length>0){
                    component.set("v.summaryFieldRecords",response.getReturnValue());
                   
                }
                else{
                    component.set("v.summaryFieldRecords",'None');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getTemplateFieldValues : function(component,event,ObjectName) {
        var getObjectName='';
        if(ObjectName!=null){
        getObjectName = ObjectName;
            }
        else {
            getObjectName = component.get("v.selectedObject");
        }
        var action = component.get('c.getTemplateFieldValues');
        action.setParams({
            "objectInfo" : getObjectName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length>0){
                    component.set("v.TemplateFieldValues",response.getReturnValue());
                    var tmp = component.get('v.TemplateFieldValues');
                    var tmpSlct = [];
                    for(var i=0;i<tmp.length;i++) {
                        tmpSlct.push(tmp[i].templateFields);
                    }
                    
                    component.set('v.tmpOptions',tmpSlct);
                }
            }
        });
        $A.enqueueAction(action);
    },
     showSuccess : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'The record has been Saved successfully.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'Board Label should contain unique value',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    compare : function(obj,updatedlist){
        console.log('obj==',obj);
        var arr = [];
        obj.forEach(function(objfetch){
            console.log('key',objfetch);
            console.log('value',objfetch.subkey);
            
            updatedlist.forEach(function(uplist){
                if(objfetch.subkey== uplist){
                    arr.push(objfetch);
                }                 
          })
            if(objfetch.subkey=='Id' || objfetch.subkey=='Name')
            arr.push(objfetch);
        });
                              
      console.log('arr',arr);
        return arr;
    },
    
    showSuccessForUpdate : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Success',
            message: 'The record has been Updated successfully.',
            duration:' 5000',
            key: 'info_alt',
            type: 'success',
            mode: 'pester'
        });
        toastEvent.fire();
    },
    
    getLabelValue : function(component,event,label) {
        component.set('v.storeLabel',label);
    },
    /*fetchBoardValues : function(component, event, helper){
        
        var action = component.get('c.getBoardLabel');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var arrKeys = [];
                var arrOfValues = [];
             var storeresponse = response.getReturnValue(); 
                for(var key in storeresponse) {
                    arrKeys.push(storeresponse);
                }
                component.set('v.handleBoardId',arrKeys[0]);
                console.log('handleBoardId==',handleBoardId);
                storeresponse[key].forEach(function(e) {
                    arrOfValues.push(e);
                });
                component.set('v.handleBoardLabel',arrOfValues[0]);
                console.log('handleBoardLabel==',handleBoardLabel);
            }
        });
        $A.enqueueAction(action);
        
    }*/

    forEditBoardData : function(component,event,boardId) {
        component.set('v.spinnerForEdit',true);
    var action = component.get('c.updateBoardRecord');
        action.setParams({
            "boardId" : boardId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var store = response.getReturnValue();
                console.log('store==',store);
                var obj = store.CCBoardAnything__Object_Name__c;
                //this.fetchobjectnames(component,event,helper);
                this.fetchListViewRecords(component,event,obj)
                this.fetchGroupFieldsValues(component,event,obj);
                this.getSummaryFieldValues(component,event,obj);
                this.getTemplateFieldValues(component,event,obj);
                //component.set('v.isEditForLbl',false);
                
                console.log('checkedTemplateFields==',component.get('v.checkedTemplateFieldLength'));
                //component.set("v.checkedTemplateFieldLength",checkedTemplateFields.length);
                //var store = response.getReturnValue();
                
                component.set('v.selectEditObject',store.CCBoardAnything__Object_Name__c);
                component.set('v.selectEditListView',store.CCBoardAnything__List_View_ID__c);
                component.set('v.selectEditGroup',store.CCBoardAnything__Grouping_Field__c);
                component.set('v.selectEditSummary',store.CCBoardAnything__SummaryFieldName__c);
                component.set('v.selectEditInput',store.CCBoardAnything__Board_Label__c);
                var tmpLnth = [];
                
                tmpLnth = store.CCBoardAnything__Template_Fields__c;
                var tmpLnth2 = tmpLnth.split(',');
                console.log('Template=',tmpLnth2);
                component.set('v.checkedTemplateFieldLength',tmpLnth2.length);
                component.set('v.spinnerForEdit',false);
                console.log('TemplateFieldValues=',component.get('v.TemplateFieldValues'));
            }
        });
        $A.enqueueAction(action);
        
},
    
    ManageGroupFields : function(component,event,grpValue) {
        console.log('@@groupListWhenLabelCHange==',grpValue);
        component.set('v.groupContainList',grpValue);
    },
    
    getBoardRecordWithLabelList : function(component,event,helper) {
        
        var action = component.get('c.getInitialValues');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {      
                if(response.getReturnValue().length!=0) {
                console.log('Response=',response.getReturnValue());
                var Store = response.getReturnValue();
                var arr = [];
                    for(var key in Store) {
                        arr.push({key:key, value:Store[key]});
                    }
                    console.log('arr=',arr);
                    if(arr.length>0) {
                        component.set('v.selectedBoard',arr[0].key);
                        var lblList = [];
                        for(var i=0;i<arr.length;i++) {
                            lblList.push(arr[i].key);
                        }
                        component.set('v.handleBoardLabel',lblList);
                        component.set('v.handleBoard',arr);
                        
                        component.set('v.boardId',arr[0].value);
                        this.getSingleRecordToShow(component,event,arr[0].value);
                        component.set('v.allGroup',false);
                        //component.set('v.isSpinner',false);
                    }
            }
                }
        });        
       
         $A.enqueueAction(action);    
    },
    
    getSingleRecordToShow : function(component,event,brdId) {
        console.log('brdId=',brdId);
        
        component.set('v.isSpinner',true);
        var action = component.get('c.getBoardRecordForLabelCHange');
        action.setParams({
            "recordId" : brdId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
               
                var returnedMapList  =  response.getReturnValue();
                console.log('storeData==',response.getReturnValue());
                
                var tmpFields = returnedMapList.tmpListForLabel.split(',');
                component.set('v.selectedTemplateFields',tmpFields);
                console.log('selectedTemplateFields==',component.get('v.selectedTemplateFields'));
                var tempSelected = component.get('v.selectedTemplateFields');
                var recordMap=[];
                var grpContain = [];
                for(var key in returnedMapList.objRecords){
                    console.log('key==',key);
                    var innermap = [];
                    returnedMapList.objRecords[key].forEach(function(co){
                        console.log('co==',co);
                        var arr=[];
                        for (var sub in co) {
                            arr.push({subkey:sub,subvalue:co[sub]});
                        }
                        console.log('arr!!',arr);
                        
                        var lstOfValue = [];
                        arr.forEach(function(objfetch){
                            console.log('key',objfetch);
                            console.log('value',objfetch.subkey);
                            
                            tempSelected.forEach(function(uplist){
                                if(objfetch.subkey== uplist){
                                    lstOfValue.push(objfetch);
                                }                 
                            })
                            if(objfetch.subkey=='Id' || objfetch.subkey=='Name')
                                lstOfValue.push(objfetch);
                        });
                        
                        console.log('updatedObj==',lstOfValue);
                        innermap.push({recordlist:lstOfValue});
                    });
                    recordMap.push({key:key,value:innermap}); 
                    for(var i=0;i<recordMap.length;i++) {
                        console.log('Keys==',recordMap[i].key);
                        //grpContain.push(recordMap[i].key);
                    }
                    component.set('v.isLabelChange',true);
                    var isLabelChange = component.get('v.isLabelChange');
                    if(isLabelChange) {
                    component.set('v.boardWrapper',recordMap);
                        }
                    else {
                        component.set('v.recordWrapper',recordMap);
                    }
                }
                for(var i=0;i<recordMap.length;i++) {
                        console.log('Keys==',recordMap[i].key);
                        grpContain.push(recordMap[i].key);
                    }
                component.set('v.groupListWhenLabelCHange',grpContain);
                
                if(isLabelChange) {
                    component.set('v.boardWrapper',recordMap);
                        }
                    else {
                        component.set('v.recordWrapper',recordMap);
                    }
                //component.set('v.boardWrapper',recordMap);
                console.log('boardWrapper==',component.get('v.boardWrapper'));
                component.set('v.isSpinner',false);
                
                
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
})