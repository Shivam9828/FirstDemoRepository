({
    doInit: function (component, event, helper) {
        // Set the columns of the Table 
        component.set('v.isSending',true);
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text', sortable : true},
            {label: 'Email', fieldName: 'Email', type: 'email', sortable : true},
            {label: 'Phone', fieldName: 'Phone', type: 'phone', sortable : true}]);
        helper.doFetchContact(component);
    },
    getSelectedName: function (component, event) {
        var selectedRows = event.getParam('selectedRows');
        // Display that fieldName of the selected rows
        for (var i = 0; i < selectedRows.length; i++){
            alert("You selected: " + selectedRows[i].Name);
        }
    },
    next: function (component, event, helper) {
        helper.next(component, event);
    },
    previous: function (component, event, helper) {
        helper.previous(component, event);
    },
    
    handleSort : function(component,event,helper){
        //Returns the field which has to be sorted
        var sortBy = event.getParam("fieldName");
        //returns the direction of sorting like asc or desc
        var sortDirection = event.getParam("sortDirection");
        //Set the sortBy and SortDirection attributes
        component.set("v.sortBy",sortBy);
        component.set("v.sortDirection",sortDirection);
        // call sortData helper function
        helper.sortData(component,sortBy,sortDirection);
    }
    
})