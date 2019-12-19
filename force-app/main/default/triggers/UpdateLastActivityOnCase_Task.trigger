trigger UpdateLastActivityOnCase_Task on Task (after insert, after update, after delete) {
  
    if(Trigger.isInsert || Trigger.isUpdate)
    {
       UpdateLastActivityOnCase_TaskHandler.afterUpdate(trigger.new);
    }
    else {
        UpdateLastActivityOnCase_TaskHandler.otherCases(trigger.old);
    }
}