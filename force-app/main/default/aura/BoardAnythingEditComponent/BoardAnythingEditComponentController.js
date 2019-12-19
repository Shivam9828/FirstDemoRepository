({
    setScriptLoaded :function(component){ 
        component.find("Id_spinner").set("v.class" , 'slds-hide');
    },
    
    doInit : function(component,event,helper) {
        
        
        var cmpTarget = component.find('dropTemplateFieldId');
        $A.util.addClass(cmpTarget, 'slds-hide');
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        var labelfield = component.find('labelfield');
        $A.util.removeClass(labelfield, 'slds-m-top_x-large');
        //var tmp = component.get('v.TempFieldValues');
        
        //component.set('v.selectedTempList',component.get('v.TemplateFieldValues')); 
        console.log('selectedTempList==',component.get('v.selectedTempList'));
        console.log('@@boardId==',component.get('v.boardId'));
        console.log('ListViewRecords==',component.get('v.listViewRecords'));
        console.log('GroupRecords==',component.get('v.groupByRecords'));
        console.log('SummaryRecoprds==',component.get('v.summaryFieldRecords'));
        //console.log('Input==',component.get('v.selectEditInput'));
    },
    
    handleKeyUpForTemplateField : function(component,event,helper){
        console.log('@@TemplateFieldValues==',component.get('v.TemplateFieldValues'));
        var searchTemplateField = component.find("enter-search").get("v.value");
        var cmpTarget = component.find('dropTemplateFieldId');
        var getWrapperTemplateFields = component.get('v.TemplateFieldValues');
        $A.util.removeClass(cmpTarget, 'slds-hide');
        $A.util.addClass(cmpTarget,'slds-show');
        if(event.keyCode == 8  && searchTemplateField==null || searchTemplateField ==""){
            console.log('backspace key pressed');
            helper.getTemplateFieldValues(component,event,helper);
        }
        //const startsWithN = getWrapperTemplateFields.filter((tempfieldValues) => tempfieldValues.startsWith(searchTemplateField));
        var newwrapper = getWrapperTemplateFields.filter(function(e){
            if(e.templateFields.toUpperCase().startsWith(searchTemplateField.toUpperCase())){
                return e;
            }
        });
        component.set('v.TemplateFieldValues',newwrapper);
        console.log(newwrapper);
        
    },
    
    templateCheckboxHandler : function(component,event,helper){
        var lookUpTarget = component.find("lookupField");
        $A.util.addClass(lookUpTarget, 'slds-hide');
        $A.util.removeClass(lookUpTarget, 'slds-show');  
        var forclose = component.find("lookup-pill");
        $A.util.addClass(forclose, 'slds-show');
        $A.util.removeClass(forclose, 'slds-hide');
        var labelfield = component.find('labelfield');
        $A.util.removeClass(labelfield, 'slds-m-top_x-large');
        var getWrapperTemplateFields = component.get('v.TemplateFieldValues');
        var checkedTemplateFields = getWrapperTemplateFields.filter(function(e){
            console.log(e);
            if(e.checked){
                return e;
            }
        }); 
        var chk = [];
        for(var i=0;i<checkedTemplateFields.length;i++) {
            chk.push(checkedTemplateFields[i].templateFields);
        }
        console.log('checkedTemplateFields==',chk);
        component.set('v.selectedTempList',chk);
        component.set("v.checkedTemplateFieldLength",checkedTemplateFields.length);
    },
    handleMouseLeaveTemplateFields: function(component,event,helper){
        var cmpTarget = component.find('dropTemplateFieldId'); 
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget,'slds-show');
    },
    
    onObjectChange: function(component, event, helper) {
        var lookUpTarget = component.find("lookupField");
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        $A.util.addClass(lookUpTarget, 'slds-show');  
        var forclose = component.find("lookup-pill");
        $A.util.removeClass(forclose, 'slds-show');
        $A.util.addClass(forclose, 'slds-hide');
        
        helper.fetchListViewRecords(component, event, helper);
        helper.fetchGroupFieldsValues(component, event, helper);
        helper.getSummaryFieldValues(component, event, helper);
        helper.getTemplateFieldValues(component,event,helper);
    },
    
    updateBoard : function(component,event,helper) {
        
        console.log('!!Object==',component.get('v.selectEditObject'));
        console.log('!!ListView==',component.get('v.selectEditListView'));
        console.log('!!selectEditSummary==',component.get('v.selectEditSummary'));
        console.log('!!Group==',component.get('v.selectEditGroup'));
        //var input = component.get('v.selectEditInput');
        console.log('TemplateWhenUpdate==',component.get('v.TempFieldValues'));
        var getWrapperTemplateFields = component.get('v.TemplateFieldValues');
        var cmpTarget = component.find('Template-error-01');
        
        
        var cmpEvent = component.getEvent("editBoardRecord"); 
        cmpEvent.setParams({"recordId" : component.get('v.boardId'),
                            "checkedTemplate" : component.get('v.selectedTempList'),
                            "objName" : component.get('v.selectEditObject'),
                            "listView" : component.get('v.selectEditListView'),
                            "groupName" : component.get('v.selectEditGroup'),
                            "summaryValue" : component.get('v.selectEditSummary'),
                            "input" : component.get('v.selectEditInput')
                           }); 
        cmpEvent.fire();
    },
    
    CloseModel : function(component,event,helper) {
        var cmpEvent = component.getEvent("editBoardRecord"); 
        cmpEvent.setParams({"isEdit" : false}); 
        cmpEvent.fire();
    },
    clear : function(component,event,helper){
        var cmpTarget = component.find('dropTemplateFieldId'); 
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget,'slds-show');
        var lookUpTarget = component.find("lookupField");
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        $A.util.addClass(lookUpTarget, 'slds-show');  
        var forclose = component.find("lookup-pill");
        $A.util.removeClass(forclose, 'slds-show');
        $A.util.addClass(forclose, 'slds-hide');
        var labelfield = component.find('labelfield');
        $A.util.addClass(labelfield, 'slds-m-top_x-large');
        
    },
    
    onListViewChange : function(component, event, helper) {
        var lstView = event.getSource().get('v.value'); 
        console.log('ListView==',lstView);
        component.set('v.selectEditListView',lstView);
        console.log('##selectedListView==',lstView);
    },
    
    /* on Group change process */
    
    onGroupChange : function(component, event, helper) {
        var grp = event.getSource().get('v.value');
        component.set('v.selectEditGroup',grp);
        console.log('grp==',grp);
    },
    
    /* on summary change process */
    
    onSummaryChange : function(component, event, helper) {
        var smr = event.getSource().get('v.value');
        if(smr==null) {
            component.set('v.selectEditSummary','');
        }
        else {
            component.set('v.selectEditSummary',smr);
        }
    },
    
    
})