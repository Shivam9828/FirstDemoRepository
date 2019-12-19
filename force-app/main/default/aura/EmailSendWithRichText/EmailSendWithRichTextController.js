({
    doInit : function(component, event, helper) {
        /*var helpText='{!Application__c.Contact__c} use for company contact, {!Applicant__c.Name} use for name of applicant,\n{!Application__c.Applicant_Resume_URL__c} use for resume Link, {!Applicant__c.CVOne_Password_For_Contact_Person__c} use for password.';
        component.set("v.helpText", helpText); */
        
        var recordId=component.get("v.recordId");
        
        
       // alert(recordId);
        if(recordId==undefined || recordId=='' || recordId==null){
            
            component.set("v.isNew",true);
            
            component.set("v.changeApplicant",true);
            var childComponent = component.find("childLook");
        childComponent.getChildMethod();
            return;
        }
        var action = component.get("c.getAccount");
        action.setParams({
            'recordId':recordId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var responseData=response.getReturnValue();
                component.set("v.contact", response.getReturnValue());
                
                var selected={"Id":responseData.Account,"Name":responseData.Account.Name};
                console.log('responseData');
                 console.log(selected);
                component.set("v.selectedLookUpRecord",selected);
            }
        });
        $A.enqueueAction(action); 
    } ,    
    cancel: function(component, event, helper) {
        var navEvent = $A.get("e.force:navigateToList");
            navEvent.setParams({
                "listViewId": '00B0x000000YxbvEAC',
                "listViewName": null,
                "scope": "Contact"
            });
            navEvent.fire();
    },
    showHTML: function(component, event, helper) {
        var richTextId = component.find("richTextId");
        var htmlTextId = component.find("htmlTextId");
        var emailTemplateRich=component.get("v.emailTemplate.Email_Template__c")+''; 
        var emailTemplateHTML=component.get("v.htmlText")+''; 
        if(component.get("v.shoHTML")){
            component.set("v.HTMLButton",'SHOW HTML');
            component.set("v.shoHTML",false);
            component.set("v.emailTemplate.Email_Template__c",emailTemplateHTML);
            $A.util.addClass(richTextId, 'slds_open');
            $A.util.removeClass(richTextId, 'slds_hide');
            $A.util.addClass(htmlTextId, 'slds_hide');
            $A.util.removeClass(htmlTextId, 'slds_open');
            
        }else{
            component.set("v.HTMLButton",'SHOW EMAIL');
            component.set("v.shoHTML",true);
            component.set("v.htmlText",emailTemplateRich);
            $A.util.addClass(htmlTextId, 'slds_open');
            $A.util.removeClass(htmlTextId, 'slds_hide');
            $A.util.addClass(richTextId, 'slds_hide');
            $A.util.removeClass(richTextId, 'slds_open');
        }
    },
    changeApplicant: function(component, event, helper) {
        var toggleText = component.find("lookupApp");
        $A.util.toggleClass(toggleText, "toggle");   
        component.set("v.changeApplicant",true);    
    },
    cancleChangeApplicant: function(component, event, helper) {
        var toggleText = component.find("lookupApp");
        $A.util.toggleClass(toggleText, "toggle"); 
        component.set("v.changeApplicant",false);    
    },
    
    saveTemplate:function(component,event,helper){    
        
        var applicantSelected=component.get("v.conAccount");
        console.log(applicantSelected.Account);
        var emailTemplate=component.get("v.contact");
        if(component.get("v.selectedLookUpRecord").Id==undefined || component.get("v.selectedLookUpRecord").Id==''){
              alert('fill required field');
            return;    
        }
        if(contact.FirstName.trim() =='' || contact.LastName.trim()==''){
            alert('fill required field');
            return;
        }
        
            contact.Account=component.get("v.selectedLookUpRecord").Id;
            component.set("v.contact",contact);
        
        //alert(emailTemplate.Applicant__c);
        // alert(emailTemplate.Applicant__c);
        component.set('v.Spinner',true);
        var action = component.get("c.saveEmailTemplate");
        action.setParams({
            'con':contact
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = JSON.stringify(response.getError());
            //alert(errors);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Application Template Saved',
                    messageTemplate: '!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                component.set("v.contact",storeResponse);
                component.set('v.Spinner',false);
            }
            if(state=='ERROR'){
                var errors = JSON.stringify(response.getError());
                //component.set("v.errors", JSON.stringify(errors)); 
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Error Message'+errors,
                    message: errors,
                    messageTemplate: '!',
                    duration:' 50000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                component.set("v.Spinner", false);    
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    createTemplate:function(component,event,helper){    
        
        var applicantSelected=component.get("v.conAccount");
        console.log(applicantSelected.Account);
        var contact=component.get("v.contact");
       
        if(component.get("v.selectedLookUpRecord").Id==undefined || component.get("v.selectedLookUpRecord").Id==''){
              alert('fill required field');
            return;    
        }
        if(contact.FirstName.trim() =='' || contact.LastName.trim()==''){
            alert('fill required field');
            return;
        }
        
            contact.Account=component.get("v.selectedLookUpRecord").Id;
            component.set("v.contact",contact);
        
        //alert(emailTemplate.Applicant__c);
        // alert(emailTemplate.Applicant__c);
        component.set('v.Spinner',true);
        var action = component.get("c.createContact");
        action.setParams({
            'con':contact
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            var errors = JSON.stringify(response.getError());
            //alert(errors);
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Success Message',
                    message: 'Record has been created successfully',
                    messageTemplate: '!',
                    duration:' 5000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                $A.get('e.force:refreshView').fire();
                
                component.set('v.Spinner',false);
                var sObectEvent = $A.get("e.force:navigateToSObject");
                sObectEvent .setParams({
                    "recordId": storeResponse.Id 
                });
                sObectEvent.fire(); 
                
                
            }
            if(state=='ERROR'){
                var errors = JSON.stringify(response.getError());
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : response.getError()[0].pageErrors[0].message,
                    message: errors,
                    messageTemplate: '!',
                    duration:' 50000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'dismissible'
                });
                toastEvent.fire();
                component.set("v.Spinner", false);    
                
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
})