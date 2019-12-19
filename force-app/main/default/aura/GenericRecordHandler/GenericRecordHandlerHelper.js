({
    /**
     * This function gets object list
     * @author - Manish Choudhari
     * */
	getObjectList : function(component) {
		var action = component.get("c.getObjects");
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.allObjects", response.getReturnValue());
                component.set("v.filteredObjects", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
	},
    
    /**
     * This function gets record list
     * @author - Manish Choudhari
     * */
    getRecordList : function(component, selectedObject) {
        var action = component.get("c.getRecords");
        action.setParams({
            'objectName' : selectedObject
        });
        action.setCallback(this,function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set("v.records", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    }
})