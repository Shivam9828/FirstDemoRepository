({
    
    onblur : function(component,event,helper){
        // on mouse leave clear the listOfSeachRecords & hide the search result component 
        component.set("v.listOfSearchRecords", null );
        component.set("v.SearchKeyWord", '');
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open');
        
    },
    onfocus : function(component,event,helper){
        
        // show the spinner,show child search result component and call helper function
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", null ); 
        var forOpen = component.find("searchRes");
        $A.util.addClass(forOpen, 'slds-is-open');
        $A.util.removeClass(forOpen, 'slds-is-close');
        // Get Default 5 Records order by createdDate DESC 
        var getInputkeyWord = '';
        
            helper.searchHelper(component,event,getInputkeyWord);
         
    },
    
    keyPressController : function(component, event, helper) {
        console.log('lstOptions==',component.get('v.lstOptions'));
        console.log('SearchKeyword==',component.get('v.SearchKeyWord'));
        $A.util.addClass(component.find("mySpinner"), "slds-show");
        // get the search Input keyword   
        var getInputkeyWord = component.get("v.SearchKeyWord");
        // check if getInputKeyWord size id more then 0 then open the lookup result List and 
        // call the helper 
        // else close the lookup result List part.   
        if(getInputkeyWord.length > 0){
            
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
    
    // function for clear the Record Selaction 
    clear :function(component,event,helper){
        var selectedPillId = event.getSource().get("v.name");
        var AllPillsList = component.get("v.lstSelectedRecords"); 
        
        for(var i = 0; i < AllPillsList.length; i++){
            if(AllPillsList[i] == selectedPillId){
                AllPillsList.splice(i, 1);
                component.set("v.lstSelectedRecords", AllPillsList);
            }  
        }
        helper.callEventForParentCmpHelper(component);
        component.set("v.SearchKeyWord",null);
        component.set("v.listOfSearchRecords", null );      
    },
    selectRecord: function(component, event, helper) {
        component.set("v.SearchKeyWord",null);
        var selectedItem = event.Target;
        console.log('@@selectedItem==',selectedItem);
        
        var listSelectedItems =  component.get("v.lstSelectedRecords");
        console.log('listSelectedItems==',listSelectedItems);
        listSelectedItems.push(selectedItem);
        component.set("v.lstSelectedRecords" , listSelectedItems); 
        helper.callEventForParentCmpHelper(component);
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        
        var forclose = component.find("searchRes");
        $A.util.addClass(forclose, 'slds-is-close');
        $A.util.removeClass(forclose, 'slds-is-open'); 
    },
    
    templateCheckboxHandler : function(component,event,helper){
        
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        console.log('checkedTemplateFields==',component.get('v.listOfSearchRecords'));
        var getWrapperTemplateFields = component.get('v.listOfSearchRecords');
        var checkedTemplateFields = getWrapperTemplateFields.filter(function(e){
            console.log(e);
            if(e.checked){
                return e;
            }
        }); 
        console.log('checkedTemplateFields==',checkedTemplateFields);
        component.set("v.checkedTemplateFieldLength",checkedTemplateFields.length);
    },
    
    clear : function(component,event,helper){
        
        var lookUpTarget = component.find("lookupField");
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        $A.util.addClass(lookUpTarget, 'slds-show');  
        var forclose = component.find("lookup-pill");
        $A.util.removeClass(forclose, 'slds-show');
        $A.util.addClass(forclose, 'slds-hide');
        
        
    },
})