({
    doInit : function(component, event, helper) {
        var action = component.get("c.getContract");
        action.setParams({
            "contractId": component.get("v.recordId")
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
               
                if(storeResponse.Offre_Immo__c == true) {
                    alert(component.get("v.recordId"));
                    var urlEvent1 = $A.get("e.force:navigateToURL");
                    urlEvent1.setParams({
                        "url": "/apex/VF35_Mrleva_Bienvenue_LRCOPRO?core.apexpages.request.devconsole=1&id="+component.get("v.recordId"),
                        "isredirect": "true"
                    });
                    urlEvent1.fire();
                }
                
                else{
                    var urlEvent2 = $A.get("e.force:navigateToURL");
                    urlEvent2.setParams({
                        "url": "/apex/VF36_Maileva_Bienvenue?core.apexpages.request.devconsole=1&id="+component.get("v.recordId"),
                        "isredirect": "true"
                    });
                    urlEvent2.fire();
                }
            }
             });
            $A.enqueueAction(action);
       
        
      
        
	}
                           })