({
    searchHelper : function(component,event,term) {
        console.log('term==',term);
        var excludeitemsList= component.get("v.lstSelectedRecords");
        var excludeitemsListValues = [];
        if(excludeitemsList.length>0) {
        for(var i =0; i<excludeitemsList.length; i++){
            excludeitemsListValues.push(excludeitemsList[i]);
        }
            }
        var searchList = [];
        var searchList1 = [];
        term = term.toString().toLowerCase();
        var listOfOptions = component.get("v.lstOptions");
        for(var i =0; i<listOfOptions.length; i++){
            //console.log('listOfOptions[i]==',listOfOptions[i]);
            var option = listOfOptions[i].toString().toLowerCase();
            //console.log('option[i]==',listOfOptions[i]);
            if(option && option.indexOf(term) !== -1 && excludeitemsListValues.indexOf(listOfOptions[i]) < 0){
                searchList.push(listOfOptions[i]);
            }
            if(!term && excludeitemsListValues.indexOf(listOfOptions[i]) < 0){
                searchList1.push(listOfOptions[i]);
            }
        }
        console.log('searchList==',searchList);
        console.log('searchList1==',searchList1);
        $A.util.removeClass(component.find("mySpinner"), "slds-show");
        component.set("v.listOfSearchRecords", searchList);
        //console.log('listOfSearchRecords==',component.get('v.listOfSearchRecords'));
        var lst = component.get('v.listOfSearchRecords');
        var lstPsh =[];
        console.log('listOfSearchRecords==',lst);
        console.log('listOfSearchRecords==',Object.values(lst));
        if(!term){
            component.set("v.listOfSearchRecords", searchList1);
        }
    },
    callEventForParentCmpHelper: function(component){
        var cmpEvent = component.getEvent("mutiSelectEvnt"); 
        cmpEvent.setParams({ 
            "selectedItems" : component.get("v.lstSelectedRecords")
        }); 
        cmpEvent.fire();
    }
})