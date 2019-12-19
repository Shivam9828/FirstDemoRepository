public class withoutActionregionController {
    public Account acc{get;set;}
    public Boolean showPhone{get;set;}
     
    public withoutActionregionController(){
        acc = new Account();
        showPhone = false;
    }
     
    public PageReference priorityChanged(){
        if(acc.CustomerPriority__c == 'High'){
            showPhone = true;
        }
        else{
            showPhone = false;
        }
        return null;
    }
}