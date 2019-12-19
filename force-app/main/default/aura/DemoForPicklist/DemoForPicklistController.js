({
    doInit: function(component, event, helper) {        
        helper.getIndustryPicklist(component, event);
    },
    
     //handle Account Save
    handleAccountSave : function(component, event, helper) {
         let validExpense = component.find('fieldId').reduce(function (validSoFar, inputCmp) {
            // Displays error messages for invalid fields
            inputCmp.showHelpMessageIfInvalid();
            return validSoFar && inputCmp.get('v.validity').valid;
        }, true);
        if(validExpense){
        helper.saveAccount(component, event);
        }
    },
    //handle Industry Picklist Selection
    handleCompanyOnChange : function(component, event, helper) {
        var indutry = component.get("v.acc.Industry");
        alert(indutry);
    }
})