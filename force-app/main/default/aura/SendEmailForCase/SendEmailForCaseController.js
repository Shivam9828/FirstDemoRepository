({
    sendMail: function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        var action = component.get("c.sendEmail"); 
        
         
        action.setCallback(this, function(response) {
             var state = response.getState();
            if (state === "SUCCESS") {
               helper.showSuccess(component, event, helper);
            }
            else {
                helper.showError(component, event, helper);
            }
        });
        $A.enqueueAction(action); 
        
           }
 
    
})