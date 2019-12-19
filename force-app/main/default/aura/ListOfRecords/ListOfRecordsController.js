({
    changeTab : function(component, event, helper) {
       
        component.set('v.subTab', event.target.getAttribute("data-tab"));
        /*var subtab = component.get('v.subTab');
        debugger;
        if(subtab == 'Accounts') {
            
            component.set('v.conCheck',false);
            component.set('v.accCheck',true);
        }
        else if(subtab == 'Contacts') {
             component.set('v.checkFor',false);
            component.set('v.accCheck',false);
            component.set('v.conCheck',true);
            
           
        }*/
        
    },
    initialize : function(component, event, helper) {
        component.set('v.checkFor',true);
        //component.set('v.accCheck',true);
        var action = component.get('c.getObjectRecords');
        action.setCallback(this, function(response) {
            component.set('v.wrapRecords',response.getReturnValue());
            
        });
         $A.enqueueAction(action);
        component.set('v.accCheck',false);
    },
    
    
    
})