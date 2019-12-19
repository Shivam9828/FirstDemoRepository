({
    /*
     * Initially this Method will be called and will fetch the records from the Salesforce Org 
     * Then we will hold all the records into the attribute of Lightning Component
     */
    doFetchContact : function(component) {
        var action = component.get('c.getContacts');
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS' && component.isValid()){
                alert();
                var pageSize = component.get("v.pageSize");
                // hold all the records into an attribute named "ContactData"
                component.set('v.data', response.getReturnValue());
                // get size of all the records and then hold into an attribute "totalRecords"
                component.set("v.totalRecords", component.get("v.data").length);
                console.log('component.get("v.data")==',component.get("v.data"));
                // set star as 0
                component.set("v.startPage",0);
                 
                component.set("v.endPage",pageSize-1);
                var PaginationList = [];
                for(var i=0; i< pageSize; i++){
                    if(component.get("v.data").length> i)
                        PaginationList.push(response.getReturnValue()[i]);    
                }
                console.log('PaginationList==',PaginationList);
                component.set('v.filteredData', PaginationList);
                console.log('filteredData==',component.get('v.filteredData'));
            }
        });
        $A.enqueueAction(action);
    },
    /*
     * Method will be called when use clicks on next button and performs the 
     * calculation to show the next set of records
     */
    next : function(component, event){
        var sObjectList = component.get("v.data");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i=end+1; i<end+pageSize+1; i++){
            if(sObjectList.length > i){
                Paginationlist.push(sObjectList[i]);
            }
            counter ++ ;
        }
        start = start + counter;
        end = end + counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.filteredData', Paginationlist);
    },
    /*
     * Method will be called when use clicks on previous button and performs the 
     * calculation to show the previous set of records
     */
    previous : function(component, event){
        var sObjectList = component.get("v.data");
        var end = component.get("v.endPage");
        var start = component.get("v.startPage");
        var pageSize = component.get("v.pageSize");
        var Paginationlist = [];
        var counter = 0;
        for(var i= start-pageSize; i < start ; i++){
            if(i > -1){
                Paginationlist.push(sObjectList[i]);
                counter ++;
            }else{
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.startPage",start);
        component.set("v.endPage",end);
        component.set('v.filteredData', Paginationlist);
    },
    
    sortData : function(component,fieldName,sortDirection){
        var data = component.get("v.filteredData");
        //function to return the value stored in the field
        var key = function(a) { return a[fieldName]; }
        var reverse = sortDirection == 'asc' ? 1: -1;
        
        
        // to handel text type fields 
            data.sort(function(a,b){ 
                var a = key(a) ? key(a).toLowerCase() : '';//To handle null values , uppercase records during sorting
                var b = key(b) ? key(b).toLowerCase() : '';
                return reverse * ((a>b) - (b>a));
            });    
        
        //set sorted data to accountData attribute
        component.set("v.filteredData",data);
    }
    
})