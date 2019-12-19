({
    /* Method to load script */
    setScriptLoaded :function(component){ 
        component.find("Id_spinner").set("v.class" , 'slds-hide');
    },
    
    /* Initialise Method */
    
    doInit : function(component, event, helper) {
        
        component.set('v.isEditForLbl',true); 
        helper.getBoardRecordWithLabelList(component,event,helper);
        
    },
    
    /* Method to close Model box */
    
    CloseModel : function(component,event,helper){
        component.set('v.isTrue',false);
        //$('#filterDiv').toggle("slide", { direction: "right" }, 1000);  
    },
    
    /* This Method is to handle process after mouse leave in template */
    
    handleMouseLeaveTemplateFields: function(component,event,helper){
        var cmpTarget = component.find('dropTemplateFieldId'); 
        $A.util.addClass(cmpTarget, 'slds-hide');
        $A.util.removeClass(cmpTarget,'slds-show');
        var tmpLength = component.get('v.checkedTemplateFieldLength');
        var tmpLimit = component.get('v.setFieldLimit');
        //var tmp = component.find('enter-search').get('v.value');
        component.set('v.tmpLength',false);
        if(tmpLength>tmpLimit) {
        //component.set('v.error','You Cannot use more than 3 template fields');
        component.set('v.tmpLength',true);
        }
    },
    
    // This method is for Insert Board Record
    saveBoardRecord : function(component,event,helper){
        
        component.set('v.isLabelChange',false);
        component.set('v.isGroupTrue',false);
        component.set('v.allGroup',true);
        var selectedobject = component.get("v.selectedObject");
        var selectedListView = component.get("v.selectedListView");
        
        component.set('v.selectEditListView',selectedListView);
        console.log('selectedListView==',selectedListView);
        var selectedGroupField = component.get("v.selectedGroupField"); 
        component.set('v.selectEditGroup',selectedGroupField);
        console.log('selectedGroupField==',selectedGroupField);
        var selectedSummaryField = component.get("v.selectedSummaryField");
        var inputLabel = component.get("v.inputLabel");
        var getWrapperTemplateFields = component.get('v.TemplateFieldValues');
        var cmpTarget = component.find('Template-error-01');
        var checkedTemplateFields = getWrapperTemplateFields.filter(function(e){
            if(e.checked){
                console.log(e.templateFields);
                return e.templateFields;
            }
        }); 
        var updatedlist=[];
        var savedBoardsList = [];
        var isDuplicate;
        for(var i=0;i<checkedTemplateFields.length;i++){
          
            updatedlist.push(checkedTemplateFields[i].templateFields);
            
        }
        
        component.set('v.TemplateFieldchecked',updatedlist);
        console.log('updatedlistSIze==',updatedlist.length);
        if(checkedTemplateFields.length==0){
            $A.util.addClass(cmpTarget, 'slds-show');
            $A.util.removeClass(cmpTarget,'slds-hide');
        }
        
        var tmpLimit = component.get('v.setFieldLimit');
        var errMsg = 'You can choose maximum '+tmpLimit+' Template Fields.';
        component.set('v.error','');
        if(component.get('v.tmpLength')) {
            component.set('v.error',errMsg);
        }
        else {
            component.set('v.isSpinner',true);
        var action = component.get("c.insertBoardRecord");
          
        action.setParams({
            "selectedGroupingField" : selectedGroupField,
            "selectedListView" : selectedListView,
            "selectedObj" : selectedobject,
            "inputLable" : inputLabel,
            "selectedSummaryField" : selectedSummaryField,
            "templateSelectedField" : updatedlist,
            "tmplimit" : tmpLimit
        });   
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                
                console.log('response.getReturnValue()==',response.getReturnValue());
                component.set('v.selectedTemplateFields',updatedlist);
                var boardList = component.get('v.savedBoardsList');
                boardList.push(component.get("v.inputLabel"));
                component.set('v.savedBoardsList',boardList);
                var returnedMapList  =  response.getReturnValue();
                console.log('returnedMapList.mapRec==',returnedMapList.mapRec);
                var recordMap=[];
                var lstForDupv = [];
                var storeKeys = [];
                for(var key in returnedMapList.mapRec){
                    storeKeys.push(key);
                    console.log('key==',key);
                    console.log('selectedGroupField==',selectedGroupField);
                    console.log('returnedMapList.mapRec[key]==',returnedMapList.mapRec[key]);
                    
                    var innermap = [];
                    returnedMapList.mapRec[key].forEach(function(co){
                        
                        var arr=[];
                        for (var sub in co) {
                            arr.push({subkey:sub,subvalue:co[sub]});
                        }
                        
                        if(isDuplicate) {
                        for(var i=0;i<arr.length;i++) {
                            if(arr[i].subkey == selectedGroupField) {
                                alert('dup');
                                storeKeys.push({subkey:arr[i].subkey,subvalue:arr[i].subvalue});
                            }
                        }
                            }
                        console.log('arr!!',arr);
                        var updatedObj = helper.compare(arr,updatedlist); 
                        
                        console.log('updatedObj==',updatedObj);
                        innermap.push({recordlist:updatedObj});
                    });
                    recordMap.push({key:key,value:innermap}); 
                    console.log("mainarray",recordMap);
                    //component.set('v.recordWrapper',recordMap);
                    
                }
                console.log('storeKeys=',storeKeys);
                console.log('lstForDupv=',lstForDupv);
                console.log("mainarray",recordMap);
                component.set('v.recordWrapper',recordMap);
                console.log('recordWrapper==',component.get('v.recordWrapper'));
                
                component.set('v.isSpinner',false);
                helper.showSuccess();
                var boardArr = component.get('v.handleBoard');
                var boardId = '';
                var boardLabel = component.get('v.handleBoardLabel');
                for(var key in returnedMapList.mapForLabelWithId) {
                    boardArr.push({value:returnedMapList.mapForLabelWithId[key], key:key});
                    component.set('v.boardId',returnedMapList.mapForLabelWithId[key]);
                    boardLabel.push(key);
                    component.set('v.selectedBoard',key);
                }
                console.log('selectedBoard==',component.get('v.selectedBoard'));
                component.set('v.handleBoardLabel',boardLabel);
                component.set('v.handleBoard',boardArr);
                
                console.log('@@handleBoard==',component.get('v.handleBoard'));
                
            }       
            console.log('@@selectedBoard==',component.get('v.selectedBoard'));
            console.log('selectedTemplateFields==',component.get('v.selectedTemplateFields'));
        });
        $A.enqueueAction(action);
            }
        
    },
    
    /* This method used to handle template process */
    
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
    
    /* This method is used for handling keyup process in template */
    
    handleKeyUpForTemplateField : function(component,event,helper){
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
    
    /* This method is used for handle process with checkbox in template */
    
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
        console.log('checkedTemplateFields==',checkedTemplateFields);
        component.set("v.checkedTemplateFieldLength",checkedTemplateFields.length);
    },
    
    /* This method is used for adding new board record */
    
    newButtonsidebar : function(component, event, helper) {
        component.set('v.isTrue',true);
        component.set('v.isGroup',false);
        component.set('v.isSave',true);
        component.set('v.isDelete',false);
        component.set('v.isEditBoard',false);
        component.set('v.isNew',true);
        component.set('v.isEditForLbl',false);
        var cmpTarget = component.find('dropTemplateFieldId');
        $A.util.addClass(cmpTarget, 'slds-hide');
        $('#filterDiv').toggle("slide", { direction: "right" }, 1000);
        if(!$('#filterDiv').is(":visible"))
        {
            helper.fetchobjectnames(component, event, helper);
        }
        
        console.log('@@ListView=',component.get('v.selectedListView'));
        console.log('@@Group=',component.get('v.selectedGroupField'));
        console.log('@@state=',component.get('v.state')); 
        
    },    
    
    /* This method is used for handling process after object change */
    
    onobjselect: function(component, event, helper) {
        
        var lookUpTarget = component.find("lookupField");
        $A.util.removeClass(lookUpTarget, 'slds-hide');
        $A.util.addClass(lookUpTarget, 'slds-show');  
        var forclose = component.find("lookup-pill");
        $A.util.removeClass(forclose, 'slds-show');
        $A.util.addClass(forclose, 'slds-hide');
        var labelfield = component.find('labelfield');
        $A.util.addClass(labelfield, 'slds-m-top_x-large');
        component.find("LabelInputField").set("v.value","");
        component.find("enter-search").set("v.value","");
        
        helper.fetchListViewRecords(component, event, null);
        helper.fetchGroupFieldsValues(component, event, null);
        console.log('groupByRecords==',component.get('v.groupByRecords'));
        helper.getSummaryFieldValues(component, event, null);
        console.log('Summary==',component.get('v.summaryFieldRecords'));
        helper.getTemplateFieldValues(component,event,null);
        console.log('Template==',component.get('v.TemplateFieldValues'));
        console.log('LstVw==',component.get('v.selectedListView'));
        console.log('grpBrd==',component.get('v.selectedGroupField'));
        console.log('Summary==',component.get('v.selectedSummaryField'));
        
    },
    
    /* This method is used for handling listview change process */
    
    onListViewChange : function(component, event, helper) {
        var lstView = event.getSource().get('v.value'); 
        console.log('ListView==',lstView);
        component.set('v.selectedListView',lstView);
        component.set('v.selectEditListView',lstView);
        console.log('##selectedListView==',lstView);
    },
    
    /* on Group change process */
    
    onGroupChange : function(component, event, helper) {
        var grp = event.getSource().get('v.value');
        component.set('v.selectedGroupField',grp);
        component.set('v.selectEditGroup',grp);
        console.log('grp==',grp);
    },
    
    /* on summary change process */
    
    onSummaryChange : function(component, event, helper) {
        var smr = event.getSource().get('v.value');
        component.set('v.selectedSummaryField',smr);
         component.set('v.selectEditSummary',smr);
    },
    
    /* for closing modal box */
    
    HideMe: function(component, event, helper) {
        if(component.get('v.ShowModule')) {
            component.set("v.ShowModule", false);
        }
        
        if(component.get('v.isDelete')) {
            component.set("v.isDelete", false);
        }
    },
    ShowModuleBox: function(component, event, helper) {
        component.set("v.ShowModule", true);
    },
    
       
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    
    // this function automatic call by aura:doneWaiting event 
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    
    allowDrop: function(component, event, helper) {
        event.preventDefault();
    },
    
    drag: function (component, event, helper) {
        console.log('drag==',event.target.id);
        event.dataTransfer.setData("text", event.target.id);
        
    },
    
    drop: function (component, event, helper) {
        event.preventDefault();
        var data = event.dataTransfer.getData("text");
        console.log('data==',data);
        var tar = event.target;
        console.log('tar==',tar.id);
        while(tar.tagName != 'ul' && tar.tagName != 'UL')
            tar = tar.parentElement;
        tar.appendChild(document.getElementById(data));
        console.log('aaaaaaaaaaaaa   :   ' + tar.getAttribute('data-Pick-Val'));
        document.getElementById(data).style.backgroundColor = "#ffb75d";
        
    },
    
    fetchGroupingFields: function (component, event, helper) {
        
        component.set('v.isTrue',false);
        console.log('@@groupContainList==',component.get('v.groupListWhenLabelCHange'));
        var glw = component.get('v.groupListWhenLabelCHange');
        var allGroup = component.get('v.allGroup');
        if(glw.length>0 && !allGroup) {
            //alert();
            var gvalc = component.get('v.groupListWhenLabelCHange');
            helper.ManageGroupFields(component,event,gvalc);
        }
        else {
        var groupList = [];
        var keyForGroup = component.get('v.recordWrapper');
        for(var i=0;i<keyForGroup.length;i++) {
            
            groupList.push(keyForGroup[i].key);
        }
        console.log('groupList==',groupList);
        //component.set('v.groupContainList',groupList);
            helper.ManageGroupFields(component,event,groupList);
            }
            
        component.set('v.isGroup',true);
        $('#filterDivForGroup').toggle("slide", { direction: "right" }, 1000);  
    },    
    recordBoxdrag: function(component,event,helper){
        console.log('draggable true');
        /*$( "ul.outerUL" ).droppable({
            drop: function( event, ui ) {
                alert( "dropped" );
                console.log(ui)
                var fieldValue = $(this).siblings("div.header").find(".c").text();
                console.log(fieldValue);
            }        
        });
        $("ul.outerUL").sortable({
            connectWith:"ul.outerUL",
            scrollSensitivity: 10,
            scrollSpeed: 40,                        
            tolerance: "intersect",
        }).disableSelection();   */
        $("ul.outerUL").droppable({
                      accept:"li.boardElement",
                      drop:function(event,ui){
                          ui.draggable.css("transform","rotate(0deg)");
                          ui.draggable.css("background-color"," rgb(255, 255, 255)");
                          var recordId = ui.draggable.attr("id");
                          var fieldValue = $(this).siblings("div.header").find(".headervalue ").text();
                          var preFieldValue = ui.draggable.parent().siblings("div.header").find(".headervalue ").text();
                          //alert(fieldValue.lenght+'---'+fieldValue +'--'+preFieldValue);
                          if(preFieldValue != fieldValue ){
                              passStringToController(recordId,fieldValue);
                          }
                      }
                  })
                  
                  $("ul.outerUL").sortable({
                        tolerance: "intersect",
                        revert:true,
                        connectWith: "ul.outerUL",
                        scrollSensitivity: 10,
                        scrollSpeed: 40,
                        placeholder: "placeholder",
                        start: function(e, ui ){
                             ui.placeholder.height(ui.helper.outerHeight()- 20);
                             ui.helper.css("transform","rotate(8deg)");
                             ui.helper.css("background-color","rgba(244, 246, 249, 0.70)");
                        }
                  }).disableSelection();
                  $("li.boardElement").mouseup(function(){
                      $(this).css("transform","rotate(0deg)");
                  });
                  $(".boardElement").mouseenter(function(){
                      $(this).css({"background-color":"rgb(244, 246, 249)","box-shadow":"4px 4px 8px 0px rgba(22, 50, 92, 0.65)"});
                  });
                  $(".boardElement").mouseleave(function(){
                      $(this).css({"background-color":"#FFF","box-shadow":"none"});
                  });
       
    },
    recordBoxdragForTemplate: function(component,event,helper){
        console.log('draggable true');
        
        $("ul.tempSetUL").sortable({
            tolerance: "intersect",
            revert:true,
            scrollSensitivity: 10,
            scrollSpeed: 40,
            start: function(e, ui ){
                console.log('ui==',ui);
                ui.helper.css("transform","rotate(5deg)");
                ui.helper.css("background-color","rgba(244, 246, 249, 0.70)");
            }
        }).disableSelection();
        
        $("ul.tempSetUL").droppable({
            accept:"li.templateSetting",
            drop:function(event,ui){
                console.log('droppable==',ui);
                ui.draggable.css("transform","rotate(0deg)");
                ui.draggable.css("background-color"," rgb(255, 255, 255)");
            }
        });
        
        $("li.templateSetting").mouseup(function(){
            $(this).css("transform","rotate(0deg)");
            $(this).css("background-color"," rgb(255, 255, 255)");
        });
        $("li.templateSetting").mouseenter(function(){
            $(this).css("background-color", "rgb(244, 246, 249)");
        });
        $("li.templateSetting").mouseleave(function(){
            $(this).css("background-color", "#FFF");
        });
        
    },
    
    saveRearrangeTempFields : function(component,event,helper) {
        var templateFiedlArray = [];
         $("li.templateSetting").each(function(index){
                var field = $(this).attr("id");
                templateFiedlArray.push(field);
            });
        console.log('templateFiedlArray==',templateFiedlArray);
        component.set("v.ShowModule", false);
    },
    
    /*This is by Shivam*/
    checkAllColumns : function(component,event,helper) {
        var checkAll = component.find("checkAll").get("v.value");
        var grp = component.find("groupColumn");
        if(checkAll) {
            for(var i=0;i<grp.length;i++) {
                grp[i].set("v.value", true);
            }
        }
        else {
            for(var i=0;i<grp.length;i++) {
                grp[i].set("v.value", false);
            }
        }
    },
    
    /*fetchHeaderValueToDisplay : function(component,event,helper) {
        var grpFields = component.get('v.groupFieldValues');
        var checkGrp = event.getSource().get('v.value');
        console.log('checkGrp==',checkGrp);
        //var grpValues = component.get('v.listOfCheckedGroup');
         var grpValues = [];
        var getGroup = component.get('v.groupFieldValues');
        var checkedGroupFields = getGroup.filter(function(e){
            console.log(e);
            if(e.checkGrp){
                return e;
            }
        }); 
        console.log('grpValues==',grpValues);
        component.set('v.listOfCheckedGroup',grpValues);
        console.log('listOfCheckedGroup==',component.get('v.listOfCheckedGroup'));
        
    },*/
    
    /*saveCheckedGroup : function(component,event,helper) {
        component.set('v.allGroup',false);
        component.set('v.isGroupTrue',true);
        var getGroup = component.get('v.groupFieldValues');
        var collectGrp = [];
        var checkedGroupFields = getGroup.filter(function(e){
            console.log(e);
            collectGrp.push(e);
            if(e.checkGrp){
                return e;
            }
        }); 
        component.set('v.groupFieldValuesAfterSave',collectGrp);
        console.log('checkedGroupFields==',checkedGroupFields);
        component.set('v.listOfCheckedGroup',checkedGroupFields);
    },*/
    
    fetchBoardLabel : function(component,event,helper) {
        console.log('@@selectedBoard==',component.get('v.selectedBoard'));
        component.set('v.allGroup',false);
        component.set('v.isEditBoard',false);
        component.set('v.isSpinner',true);
        component.set('v.isTrue',false);
        component.set('v.isLabelChange',true);
        component.set('v.isGroup',false);
        component.set('v.isInputChange',true);
        component.set('v.isLabel',true);
        component.set('v.isGroupTrue',false);
        component.set('v.isEditForLbl',true);
        
        var lbl = event.getSource().get('v.value');
        helper.getLabelValue(component,event,lbl);
        
        console.log('label==',lbl);
        var handleBoardList = component.get('v.handleBoard');
        
        console.log('handleBoardList==',handleBoardList.length);
        var boardId = '';
        for(var i=0;i<handleBoardList.length;i++) {
            if(handleBoardList[i].key == lbl) {
                boardId = handleBoardList[i].value;
            }
            
        }
        component.set('v.boardId',boardId);
        //component.set('v.isEditBoard',true);
        
        console.log('boardId==',boardId);
        var tempFields = component.get('v.selectedTemplateFields');
        console.log('tempFields==',tempFields);
        var action = component.get('c.getBoardRecordForLabelCHange');
        action.setParams({
            "recordId" : component.get('v.boardId')
        });
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                alert();
                //helper.fetchListViewRecords(component,event,null);
                var returnedMapList  =  response.getReturnValue();
                console.log('storeData==',response.getReturnValue());
                //console.log('returnedMapList.mapRec==',returnedMapList);
                var tmpFields = returnedMapList.tmpListForLabel.split(',');
                component.set('v.selectedTemplateFields',tmpFields);
                console.log('selectedTemplateFields==',component.get('v.selectedTemplateFields'));
                var tempSelected = component.get('v.selectedTemplateFields');
                var recordMap=[];
                var grpContain = [];
                for(var key in returnedMapList.objRecords){
                    console.log('key==',key);
                    var innermap = [];
                    returnedMapList.objRecords[key].forEach(function(co){
                        console.log('co==',co);
                        var arr=[];
                        for (var sub in co) {
                            arr.push({subkey:sub,subvalue:co[sub]});
                        }
                        console.log('arr!!',arr);
                        var updatedObj = helper.compare(arr,tempSelected); 
                        console.log('updatedObj==',updatedObj);
                        innermap.push({recordlist:updatedObj});
                    });
                    recordMap.push({key:key,value:innermap}); 
                    for(var i=0;i<recordMap.length;i++) {
                        console.log('Keys==',recordMap[i].key);
                        //grpContain.push(recordMap[i].key);
                    }
                    
                    component.set('v.boardWrapper',recordMap);
                }
                for(var i=0;i<recordMap.length;i++) {
                        console.log('Keys==',recordMap[i].key);
                        grpContain.push(recordMap[i].key);
                    }
                component.set('v.groupListWhenLabelCHange',grpContain);
                console.log('recordMapForChange==',recordMap);
                console.log('Liiisstt==',component.get('v.selectEditListView'));
                console.log('grroupp==',component.get('v.selectEditGroup'));
                component.set('v.boardWrapper',recordMap);
                console.log('boardWrapper==',component.get('v.boardWrapper'));
                component.set('v.allGroup',false);
                component.set('v.isSpinner',false);
                helper.forEditBoardData(component,event,boardId);
                //component.set('v.isEditBoard',true);
                //var brdId = component.get('v.boardId');
                
                
            }
        });
        $A.enqueueAction(action);
        
    },
    
    EditBoardRecord : function(component,event,helper) {
        console.log('Labl==',component.get('v.selectedBoard'));
        //component.set('v.isEditSpinner',true);
        component.set('v.isNew',false);
        component.set('v.isTrue',false);
        
        component.set('v.isSpinner',false);
        var boardId = '';
        
        var brd = component.get('v.selectedBoard');
        //console.log('inpLbl==',inpLbl);
        var brdList = component.get('v.handleBoard');
        
        for(var i=0;i<brdList.length;i++) {
            if(brd==brdList[i].key) {
                boardId = brdList[i].value;
            }
        }
        
        component.set('v.boardId',boardId);
        console.log('boardId===',boardId);
        helper.fetchobjectnames(component,event,helper);
        helper.forEditBoardData(component,event,boardId);
        console.log('selectEditInput=',component.get('v.selectEditInput'));
        component.set('v.isEditBoard',true);
       
        $('#filterDivForEdit').toggle("slide", { direction: "right" }, 1000); 
    },
    
    
    updateBoardWithRecord : function(component,event,helper) {
        
        var edit = event.getParam("isEdit");
        console.log('edit==',edit);
        var recId = event.getParam("recordId");
        component.set('v.isSpinner',true);
        console.log('recId==',recId);
        
        if(event.getParam("recordId")==null || event.getParam("recordId")==undefined || event.getParam("recordId")==''){
            component.set('v.isEditBoard',event.getParam("isEdit"));
        }
        else {
            alert('hh');
            debugger; 
            var updTemplate = event.getParam("checkedTemplate");
                
            var listView = event.getParam("listView");
            console.log('l==',listView);
            var groupName = event.getParam("groupName");
            console.log('g==',groupName);
            var obj = event.getParam("objName");
            console.log('o==',obj);
            var sum = event.getParam("summaryValue");
            console.log('s==',sum);
            var inp = event.getParam("input");
            console.log('i==',inp);
            
            console.log('upd==',updTemplate);
            var action = component.get('c.updateBoardConfigRecord');
            action.setParams({
                "recId" : recId,
                "objName" : obj,
                "lstView" : listView,
                "grpName" : groupName,
                "summary" : sum,
                "tmpVal" :  updTemplate,
                "input" : inp
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    alert('SUCCESS');
                    console.log('response.getReturnValue',response.getReturnValue());
                    var returnedMapList = response.getReturnValue();
                    var recordMap=[];
                    for(var key in returnedMapList){
                    console.log('key==',key);
                    var innermap = [];
                    returnedMapList[key].forEach(function(co){
                        console.log('co==',co);
                        var arr=[];
                        for (var sub in co) {
                            arr.push({subkey:sub,subvalue:co[sub]});
                        }
                        console.log('arr!!',arr);
                        var updatedObj = helper.compare(arr,updTemplate); 
                        console.log('updatedObj==',updatedObj);
                        innermap.push({recordlist:updatedObj});
                    });
                    recordMap.push({key:key,value:innermap}); 
                    console.log("mainarray",recordMap);
                    //component.set('v.recordWrapper',recordMap);
                    
                }
                    console.log("mainarrayAfterUpdate",recordMap);
                    if(component.get('v.isLabelChange')) {
                        component.set('v.boardWrapper',recordMap);
                    }
                    else {
                    component.set('v.recordWrapper',recordMap);
                        }
                    console.log('recordWrapperAfterUpdate==',component.get('v.recordWrapper'));
                    //component.set('v.Spinner',false);
                    component.set('v.isSpinner',false);
                    helper.showSuccessForUpdate();
                }
            });
            $A.enqueueAction(action);
            
           
        }
    },
    
    
    //Method for Filter button
    getFilteredValues : function(component,event,helper) {
        
        console.log('allGroup==',event.getParam("allGroup"));
        console.log('isGroup==',event.getParam("isGroupTrue"));
        
        var checkGrp = event.getParam("listOfCheckedGroup");
        var allGroup = event.getParam("allGroup");
        var isGroup = event.getParam("isGroupTrue");
        
        component.set('v.listOfCheckedGroup',checkGrp);
        component.set('v.isGroupTrue',isGroup);
        var lbl = component.get('v.isEditForLbl');
        console.log('lbl==',lbl);
        
        if(lbl) {
            component.set('v.isLabelChange',allGroup);
            component.set('v.isFilterForLbl',true);
            component.set('v.isFilterForNew',false);
            
            alert('labelCHange');
            }
        else {
            component.set('v.allGroup',allGroup);
            component.set('v.isFilterForNew',true);
            component.set('v.isFilterForLbl',false);
            alert('allGroup');
        }
        
        console.log('isGroupTrue==',component.get('v.isGroupTrue'));
        console.log('listOfCheckedGroup==',component.get('v.listOfCheckedGroup'));
        console.log('boardWrapper==',component.get('v.boardWrapper'));
    },
    
    redirectToHome : function(component,event,helper) {
        
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url": "/lightning/page/home"
        });
        urlEvent.fire();
        
    },
    
    
    //This method is to show individual object record
    doView: function(component, event, helper) {
        var selectedItem = event.currentTarget;
        var dataIndex = selectedItem.getAttribute('data-index');
        var groupId = selectedItem.getAttribute('data-groupid');
        console.log('dataIndex==',dataIndex);
        console.log('groupId==',groupId);
         var data = component.get("v.recordWrapper");
        var recordEdit = [];
        for(var i=0;i<data.length;i++){
            if(i==groupId){
                for(var j in data[i]){
                    console.log("datainner",data[i][j][dataIndex]);
                    recordEdit.push(data[i][j][dataIndex]);
                }
            }
        }
        recordEdit.shift();
        for(var i=0;i<recordEdit.length;i++){
            for(var j in recordEdit[i]){
                recordEdit[i][j].forEach(function(element){
                    if(element.subkey=="Id"){
                        console.log('Id',element.subvalue);
                        component.set("v.selectedRecordId",element.subvalue);
                    }
                });
            }
        }
        var editRecordEvent = $A.get("e.force:navigateToSObject");
        editRecordEvent.setParams({
            "recordId": component.get('v.selectedRecordId')
        });
        editRecordEvent.fire();
    },
    
    
    //This Method is for Refresh button
    fetchRecordOnRecord : function(component,event,helper) {
        var brdId = component.get('v.boardId');
        if(brdId != null || brdId != undefined || brdId != '') {
        helper.getSingleRecordToShow(component,event,brdId);
            }
        
    },
    
    forDeleteBoard : function(component,event,helper) {
        component.set('v.isDelete',true);
        /*var brdId = component.get('v.boardId');
        var action = component.get('c.deleteBoardRecord');
        action.setParams({
            "brdId" : brdId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(component.get('v.allGroup')) {
                    component.set('v.recordWrapper','');
                    component.set('v.allGroup',false);
                }
                if(component.get('v.isLabelChange')) {
                    component.set('v.boardWrapper','');
                    component.set('v.isLabelChange',false);
                }
               helper.getBoardRecordWithLabelList(component,event,helper);
                
            }
        });
        $A.enqueueAction(action);*/
    },
    
    deleteBoard : function(component,event,helper) {
        component.set('v.isDelete',false);
        var brdId = component.get('v.boardId');
        var action = component.get('c.deleteBoardRecord');
        action.setParams({
            "brdId" : brdId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(component.get('v.allGroup')) {
                    component.set('v.recordWrapper','');
                    component.set('v.allGroup',false);
                }
                if(component.get('v.isLabelChange')) {
                    component.set('v.boardWrapper','');
                    component.set('v.isLabelChange',false);
                }
               helper.getBoardRecordWithLabelList(component,event,helper);
                
            }
        });
        $A.enqueueAction(action);
    }
 
    
})