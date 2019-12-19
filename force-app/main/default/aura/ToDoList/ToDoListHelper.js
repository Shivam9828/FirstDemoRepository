({
    getData : function(component,event,helper){
        //call loadData server side method to get the toDo records
        var action = component.get("c.loadData");
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS"){
                var dotoList = response.getReturnValue();
                for(var i=0; i < dotoList.length;i++){
                    //To display description of todo item as link
                    dotoList[i].linkToRecord = '/'+dotoList[i].Id;
                }
                component.set("v.todoData",dotoList);
            }
            else{
                //To handle server error
                console.log('Error occured while init of data '+state);
            }
        });
        $A.enqueueAction(action);
    },
    
    validateData : function(component, event, helper){
        var isValid = component.find("todoForm").reduce(function(validSoFar,inputComp){
            //To display error message when user saves the form with invalid data
            inputComp.showHelpMessageIfInvalid();
            return validSoFar && inputComp.get("v.validity").valid;
        },true);
        return isValid;
    }
})