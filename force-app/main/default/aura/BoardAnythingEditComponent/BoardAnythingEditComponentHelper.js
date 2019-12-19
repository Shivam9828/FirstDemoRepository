({
    fetchobjectnames : function(component,event,helper) {
        component.set('v.Spinner',true);
        var objfetch = component.get("c.ObjName");
        objfetch.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log("objList", response.getReturnValue());
                component.set("v.objlist",response.getReturnValue());
                console.log(response.getReturnValue());
                //component.set('v.Spinner',false);
            }
        });
        $A.enqueueAction(objfetch);
    },
	getTemplateFieldValues : function(component,event,objectName) {
        var action = component.get('c.getTemplateFieldValues');
        action.setParams({
            "objectInfo" : component.get('v.selectEditObject')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length>0){
                    component.set("v.TemplateFieldValues",response.getReturnValue());
                    
                }
            }
        });
        $A.enqueueAction(action);
        
    },
    
    fetchListViewRecords : function(component,event,objectName) {
        component.set('v.listViewRecords','');
        var action = component.get('c.getlistValues');
        action.setParams({
            "objectInfo" : component.get('v.selectEditObject')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {      
                console.log('List:',response.getReturnValue());
                component.set("v.listViewRecords",response.getReturnValue());
                component.set('v.selectEditListView',response.getReturnValue()[0]);
            }
        });
        $A.enqueueAction(action);
    },
    
    fetchGroupFieldsValues : function(component,event,objectName) {
        component.set('v.groupByRecords','');
        var action = component.get('c.getGroupFieldValues');
        action.setParams({
            "objectInfo" : component.get('v.selectEditObject')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Group===',response.getReturnValue());
                component.set("v.groupByRecords",response.getReturnValue());
                component.set('v.selectEditGroup',response.getReturnValue()[0]);
            }
        });
        $A.enqueueAction(action);
    },
    
    getSummaryFieldValues : function(component,event,objectName) {
        var action = component.get('c.getSummaryFieldValues');
        action.setParams({
            "objectInfo" : component.get('v.selectEditObject')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length>0){
                    component.set("v.summaryFieldRecords",response.getReturnValue());
                    component.set('v.selectEditSummary',response.getReturnValue()[0]);
                }
                else{
                    component.set("v.summaryFieldRecords",'');
                    component.set('v.selectEditSummary','--None--');
                }
            }
        });
        $A.enqueueAction(action);
    },

 /*fetchListViewRecordsForLblChange : function(component,event,obj) {
        
        var action = component.get('c.getlistValues');
        action.setParams({
            "objectInfo" : obj
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {      
                if(response.getReturnValue().length>0) {
                console.log('List:',response.getReturnValue());
                component.set("v.listViewRecords",response.getReturnValue());
                
                }
            }
        });
        $A.enqueueAction(action);
    },
    
    getGroupValuesAfterLablCHange : function(component,event,objectName) {
       var action = component.get('c.getGroupFieldValues');
        action.setParams({
            "objectInfo" : objectName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length>0) {
                console.log('Group===',response.getReturnValue());
                component.set("v.groupByRecords",response.getReturnValue());
               
            }
                }
        });
        $A.enqueueAction(action);
    },
    
    getSummaryFieldValuesForLabelCHange : function(component,event,ObjectName) {
        var action = component.get('c.getSummaryFieldValues');
        action.setParams({
            "objectInfo" : ObjectName
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue().length>0){
                    component.set("v.summaryFieldRecords",response.getReturnValue());
                   
                }
              
            }
        });
        $A.enqueueAction(action);
    },*/    
})