({
    /* Initialise Method */ 
    
	doInit : function(component, event, helper) {
        console.log('groupContainList==',component.get('v.groupContainList'));
		var action = component.get('c.fetchCheckedGroup');
        action.setParams({
            "grpFields" : component.get('v.groupContainList')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var grpValues = response.getReturnValue();
                console.log('grpValues==',grpValues);
                
                var checkedList = component.get('v.listOfCheckedGroup');
                console.log('checkedList==',checkedList);
                
                if(checkedList.length>0) {
                    var grp = component.get('v.groupFieldValuesAfterSave');
                    component.set('v.groupFieldValues',grp);
                }
                else {
                    component.set('v.groupFieldValues',grpValues);
                }
                var checkAll = component.find("checkAll");
                if(grpValues.length>0) {
                    for(var i=0;i<grpValues.length;i++) {
                        if(grpValues[i].checkGrp == true) {
                            checkAll.set('v.value',true);
                        }
                        else {
                            checkAll.set('v.value',false);
                        }
                    }
                }
                
            }
        });
        $A.enqueueAction(action);
	},
    
    /* Method for display checked Group */
    
    saveCheckedGroup : function(component,event,helper) {
        component.set('v.allGroup',false);
        component.set('v.isGroupTrue',true);
        var getGroup = component.get('v.groupFieldValues');
        var collectGrp = [];
        var checkedGroupFields = getGroup.filter(function(e){
            console.log(e);
            collectGrp.push(e);
            if(e.checkGrp){
                return e;
            }
        }); 
        component.set('v.groupFieldValuesAfterSave',collectGrp);
        console.log('checkedGroupFields==',checkedGroupFields);
        component.set('v.listOfCheckedGroup',checkedGroupFields);
        var cmpEvent = component.getEvent("filterHandle"); 
        cmpEvent.setParams({
            "allGroup" : component.get('v.allGroup'),
            "isGroupTrue" : component.get('v.isGroupTrue'),
            "listOfCheckedGroup" : component.get('v.listOfCheckedGroup')
                            }); 
        cmpEvent.fire();
    },
    
    /* Method to check all checkbox based on condition */
    
    checkAllColumns : function(component,event,helper) {
        
        var checkAll = component.find("checkAll").get("v.value");
        var grp = component.find("groupColumn");
        if(checkAll) {
            for(var i=0;i<grp.length;i++) {
                grp[i].set("v.value", true);
            }
        }
        else {
            for(var i=0;i<grp.length;i++) {
                grp[i].set("v.value", false);
            }
        }
    },
    
    /* This method displays change in checkbox values */
    onchangeCheckbox : function(component,event,helper) {
        var check = event.getSource().get('v.value');
        var checkAll = component.find("checkAll");
        if(!check) {
            checkAll.set('v.value',false);
        }
        
    }
})