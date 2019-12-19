({
  doInit : function(component,event,helper){
        component.set('v.isNew',false);
    },
	keyPressController : function(component, event, helper) {
      // get the search Input keyword   
		var getInputkeyWord = component.get("v.SearchKeyWord");
      // check if getInputKeyWord size id more then 0 then open the lookup result List and 
      // call the helper 
      // else close the lookup result List part.   
        if( getInputkeyWord.length > 0 ){
             var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-open');
               $A.util.removeClass(forOpen, 'slds-is-close');
            helper.searchHelper(component,event,getInputkeyWord);
        }
        else{  
            component.set("v.listOfSearchRecords", null ); 
             var forclose = component.find("searchRes");
               $A.util.addClass(forclose, 'slds-is-close');
               $A.util.removeClass(forclose, 'slds-is-open');
          }
         
	},
  
  // function for clear the Record Selection 
    clear :function(component,event,heplper){
      
         component.set('v.isNew',false);
      
         component.set("v.SearchKeyWord",null);
         component.set("v.listOfSearchRecords", null );
    },
    
  // This function call when the end User Select any record from the result list.   
    handleComponentEvent : function(component, event, helper) {
     
    // get the selected Account record from the COMPONETN event 	 
       var selectedAccountGetFromEvent = event.getParam("accountByEvent");
	   component.set('v.isNew',true);
	   component.set("v.selectedRecord" , selectedAccountGetFromEvent); 
       component.set('v.isSelected',true);
       var forOpen = component.find("searchRes");
               $A.util.addClass(forOpen, 'slds-is-close');
               $A.util.removeClass(forOpen, 'slds-is-open');
      
	},
  // automatically call when the component is done waiting for a response to a server request.  
    hideSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : false });
        evt.fire();    
    },
 // automatically call when the component is waiting for a response to a server request.
    showSpinner : function (component, event, helper) {
        var spinner = component.find('spinner');
        var evt = spinner.get("e.toggle");
        evt.setParams({ isVisible : true });
        evt.fire();    
    },
    
})