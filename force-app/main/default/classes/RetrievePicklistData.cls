public class RetrievePicklistData {
    
    public List<SelectOption> getPickValues() {
        list<SelectOption> options = new list<SelectOption>();
        Schema.DescribeFieldResult fld = Schema.SObjectType.opportunity.fields.stageName.getSObjectField().getDescribe();
        options.add(new SelectOption('--None--', '--None--'));
        for(PicklistEntry ent:fld.getpicklistvalues()) {
            options .add(new SelectOption(ent.getValue(), ent.getLabel()));
        }
         return options;
    }
   
}