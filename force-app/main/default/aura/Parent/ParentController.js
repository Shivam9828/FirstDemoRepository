({
    getMapCompany: function(component, event, helper) {
        //call apex class method 
        var action = component.get('c.getMap');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                //Create an empty array to store the map keys 
                var arrayMapKeys = [];
                //Store the response of apex controller (return map)     
                var result = response.getReturnValue();
                //Set the store response[map] to component attribute, which name is map and type is map.   
                component.set('v.companyMap', result);
                 
                for (var key in result) {
                    arrayMapKeys.push(key);
                }

                //Set the list of keys.
                for(var i=0;i<arrayMapKeys.length;i++)
                component.set('v.keyFor', arrayMapKeys[i]);   
                alert(component.get('v.keyFor'));
                component.set('v.keyList', arrayMapKeys);
            }
        });
        // enqueue the Action   
        $A.enqueueAction(action);
    }
})