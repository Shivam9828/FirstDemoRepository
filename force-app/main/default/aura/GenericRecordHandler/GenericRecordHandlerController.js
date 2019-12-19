({
    /**
     * This function will be called on page load
     * This sets data table columns and also fetches object list
     * @author - Manish Choudhari
     * */
	doInit : function(component, event, helper) {
		component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text'},
            {label: 'Action', type: 'button', initialWidth: 135, typeAttributes: 
             { label: 'View', name: 'view_details', title: 'Click to View or Edit Details'}}
        ]);
        
        //Fetch object list
        helper.getObjectList(component);
	},
    
    /**
     * This function will be called on object selection change
     * It fetches record list from that object
     * @author - Manish Choudhari
     * */
    onObjectSelectionChange : function(component, event, helper) {
        var selectedObject = component.find("objectList").get("v.value");
        //hide show details component
        component.set("v.showDetails", false);
        //fetch records
        helper.getRecordList(component, selectedObject);
    },
    
    /**
     * This function will be called on object selection change
     * It fetches record list from that object
     * @author - Manish Choudhari
     * */
    onModeChange : function(component, event, helper) {
        var recordFormMode = component.find("modeList").get("v.value");
        if(recordFormMode === "ReadOnly Mode"){
        	component.set("v.recordFormMode", "readonly");
        } else{
           	component.set("v.recordFormMode", "view");
        }
    },
    
    /**
     * This function will be called on object type selection change
     * It will filter object list as per user's selection
     * @author - Manish Choudhari
     * */
    onTypeChange : function(component, event, helper) {
        var selectedObjectType = component.find("typeList").get("v.value");
        var filteredObjects = [];
        if(selectedObjectType === "Standard Objects"){
            filteredObjects = component.get("v.allObjects").filter(function(value){
                return value.isCustom === false;
            });
        } else if(selectedObjectType === "Custom Objects"){
            filteredObjects = component.get("v.allObjects").filter(function(value){
                return value.isCustom === true;
            });
        } else{
            filteredObjects = component.get("v.allObjects");
        }
        component.set("v.filteredObjects", filteredObjects);
    },
    
    /**
     * This method will be called when View button is clicked in data table
     * @author Manish Choudhari
     * */
    handleRowAction : function (component, event, helper) {
        var action = event.getParam('action');
        var record = event.getParam('row');
        switch (action.name) {
            case 'view_details':
                component.set("v.selectedRecord", record.Id);
                component.set("v.selectedObject", component.find("objectList").get("v.value"));
                break;
        }
        
        if(component.get("v.selectedRecord")){
            //Show component details
            component.set("v.showDetails", true);
        }
    },
})