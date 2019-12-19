public class MultiAdd {
    
    //will hold the account records to be saved
    
    public List<Account>lstAcct = new List<Account>();
    
    //list of the inner class
    
    public List<innerClass> lstInner{ get;set; }
    
    
    public String selectedRowIndex{get;set;}
    
    //no. of rows added/records in the inner class list
    
    public Integer count = 1;    //{get;set;}
    
    public void Save(){
        
        
        
        for(Integer j = 0;j<lstInner.size();j++)    {
            
            lstAcct.add(lstInner[j].acct);
            
        }
        
        insert lstAcct;
        
        ApexPages.AddMessage(new ApexPages.Message(ApexPages.Severity.CONFIRM,'Record Created Successfully'));
        
        
        
    }
    
    //add one more row
    
    public void Add(){
        
        count = count+1;
        
        addMore();
        
    }
    
    
    public void addMore(){
        
        
        innerClass objInnerClass = new innerClass(count);
        
        
        
        lstInner.add(objInnerClass);
        
        system.debug('lstInner—->'+lstInner);
        
    }
    
    
    
    public void Del(){
        
        system.debug('selected row index—->'+selectedRowIndex);
        
        lstInner.remove(Integer.valueOf(selectedRowIndex)-1);
        
        count = count--;
        
    }
    
    public MultiAdd(ApexPages.StandardController ctlr){
        
        lstInner = new List<innerClass>();
        
        addMore();
        
        selectedRowIndex = '0';
        
    }
    
    public class innerClass{
        
        public String recCount{get;set;}
        
        public Account acct{get;set;}
        
        /*Inner Class Constructor*/
        
        public innerClass(Integer intCount){
            
            recCount = String.valueOf(intCount);
            
            acct = new Account();
            
        }
        
    }
    
}