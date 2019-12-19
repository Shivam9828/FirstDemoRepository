public class ObjectRetrieve {
    
    public List<SelectOption> getObjectName() {
        List<Schema.SobjectType> lstObj = schema.getGlobalDescribe().values();
        list<SelectOption> options = new list<SelectOption>();
        options.add(new SelectOption('--None--','--None--'));
        for(Schema.SobjectType obj : lstObj) {
            if(Obj.getDescribe().getName().contains('__c')) {
                options.add(new SelectOption(Obj.getDescribe().getName(), Obj.getDescribe().getName()));
            }
        }
        return options;
        
    }
}