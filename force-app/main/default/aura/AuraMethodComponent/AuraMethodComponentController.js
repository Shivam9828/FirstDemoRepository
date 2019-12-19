({
    doInit : function(component, event, helper) {
        component.defaultParamers();
    },
    loadDefaultParams : function(component, event, helper) {
        var params = event.getParam('arguments');
        var onSucess = function(result){
            console.log(result);
        }
        if (params) {
            params.header = onSucess[0];
            params.footer = onSucess[1];
            params.title = onSucess[2];
        }
        var action = component.get("c.getServerSideParams");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                onSucess(response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    
})