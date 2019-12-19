({
    //Method to set columns and data for datatable
    doInit : function(component,event,helper){
        // create current date instance
        var now = new Date();
        var date = now.getDate();
        var month = now.getMonth() + 1;
        var fullYear = now.getFullYear();
        var today = fullYear + '-' + month + '-' + date;
        component.set("v.today", today);
        
        // set lightning datatable columns   
        component.set("v.todocolumns",[
            {
                label:'Description',
                fieldName : 'linkToRecord',
                type:'url',
                typeAttributes:{label:{fieldName:'Description__c'},target:'_blank'}//to display link to record page
            },
            {
                label :'Due Date',
                fieldName:'Due_Date__c',
                type:'date',
                typeAttributes:{day:'2-digit',month:'long',year:'2-digit'}
            },
            {
                label:'Reminder Date',
                fieldName:'Reminder_Date__c',
                type:'date',
                typeAttributes:{day:'2-digit',month:'long',year:'2-digit'}
            }
        ]);
        // call helper function to get records data
        helper.getData(component,event,helper);
    },
    
    toggleForm : function(component,event,helper){
        // change toggle button icon 
        var evtSource = event.getSource();
        if(evtSource.get("v.iconName") === 'utility:chevrondown'){
            evtSource.set("v.iconName" , 'utility:chevronright' );
        }else{
            evtSource.set("v.iconName" , 'utility:chevrondown' );
        }
        
        //To show/hide form elements
        $A.util.toggleClass(component.find("formDiv"),'slds-hide');
    },
    
    saveTodo : function(component,event,helper){
        //If form data is valid , save record in database
        if(helper.validateData(component,event,helper)){
            //Appending the new todo entry in datatable
            var objToDo = component.get("v.objToDo");
 
            //call saveTodoRecord server side method to save todo record
            var action = component.get("c.saveTodoRecord");
            action.setParams({
                toDoRecord : objToDo
            });
            action.setCallback(this,function(response){
                var state = response.getState();
                if(state == "SUCCESS"){
                    var toastRef = $A.get("e.force:showToast");
                    if(response.getReturnValue() == null){
                        toastRef.setParams({
                            "type" : "Success",
                            "title" : "Success",
                            "message" : "New Task is Created.",
                            "mode" : "dismissible"
                        });
                    }
                    else{
                        toastRef.setParams({
                            "type" : "Error",
                            "title" : "Error",
                            "message" : response.getReturnValue(),
                            "mode" : "sticky"
                        }); 
                    }
                    toastRef.fire();
                    
                    $A.get("e.force:refreshView").fire();
                }
                else{
                    //To handle server error
                    console.log('Error during saving '+state);
                }
            });
            $A.enqueueAction(action);          
        }
    },
    
    setMaxValueOfReminderDate : function(component, event, helper){
        var dueDate = event.getSource().get("v.value");
        component.find("reminderDate").set("v.value",'');
        //Once due date is entered , reminder date is enabled
        if(dueDate != null && dueDate != ''){
            component.find("reminderDate").set("v.disabled",false);
            //set max date limit for reminder date
            component.find("reminderDate").set("v.max",dueDate);
        }
        else{
            component.find("reminderDate").set("v.disabled",true);
        }        
    }
})