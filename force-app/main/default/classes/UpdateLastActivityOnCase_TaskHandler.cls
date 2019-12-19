public class UpdateLastActivityOnCase_TaskHandler {
    
   //Method for after insert and after update conditions
    public static void afterUpdate(list<task> newList) {
        list<case> updateRecord = new list<case>();
        for(Task t : newList) {
            String tId = String.valueOf(t.WhatId);
            if(!String.isEmpty(t.WhatId)) {
                if(tId.startsWith('500')) {
                    Case c = new Case();
                    c.Id = tId;
                    c.Last_Activity_Date__c = t.LastModifiedDate;
                    updateRecord.add(c);
                }
            }
        }
        update updateRecord;
    }
    
    //Method for other than after insert and after update conditions
    public static void otherCases(list<task> oldList) {
        list<case> updateCaseWithTask = new list<case>();
        set<id> oldTask = new set<id>();
        for(task t : oldList) { 
            if(string.valueOf(t.WhatId).startsWith('500')){
                oldTask.add(t.WhatId);
            }
        }
        if(!oldTask.isEmpty()) {
            
            map<id,list<task>> addTask = new map<id,list<task>>();
            map<id,list<Event>> addEvent = new map<id,list<Event>>();
            
            for(task tsk : [Select Id,LastModifiedDate,WhatId from Task where WhatId in : oldTask]) {
                list<task> taskList;
                if(addTask.get(tsk.WhatId)==null) {
                    taskList= new list<task>();
                }
                else {
                    taskList=  addTask.get(tsk.WhatId);          
                }
                taskList.add(tsk) ;     
                addTask.put(tsk.WhatId, taskList);
            }
            for(Event evnt : [Select Id,LastModifiedDate,WhatId from Event where WhatId in : oldTask]) {
                list<event> eventList;
                if(addEvent.get(evnt.WhatId)==null){
                    eventList= new list<event>();
                }
                else {
                    eventList = addEvent.get(evnt.WhatId); 
                }
                eventList.add(evnt);
                addEvent.put(evnt.WhatId, eventList);
            }
            
            for(Id whatIds : oldTask) {
                if(addTask.get(whatIds).size()==0 && addEvent.get(whatIds).size()==0) {
                    Case c = new Case();
                    c.Id = whatIds;
                    c.Last_Activity_Date__c = null;
                    updateCaseWithTask.add(c);
                }
                
                else {
                    for(Id whatId : oldTask) {
                        Case c = new Case();
                        DateTime dt = DateTime.newInstance(1899,1,1,1,1,1);
                        for(Task tk1 : addTask.get(whatId)){
                            if(tk1.LastModifiedDate > dt) {
                                c.Id = whatId;
                                c.Last_Activity_Date__c = tk1.LastModifiedDate;
                                dt = tk1.LastModifiedDate;
                            }
                        }
                        for(Event ev1 : addEvent.get(whatId)) {
                            if(ev1.LastModifiedDate > dt)
                            {
                                c.Id = WhatId;
                                c.Last_Activity_Date__c = ev1.LastModifiedDate;
                                dt = ev1.LastModifiedDate;
                            }
                        }
                        if(c.Id != null){
                            updateCaseWithTask.add(c);
                        }
                    }
                    
                }
            }
            update updateCaseWithTask;
        }
        
    }
    
    
}