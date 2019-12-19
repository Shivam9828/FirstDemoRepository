public class createContactDynamically {
    public list<wrapper> wrppr{get;set;}
    public integer count{get;set;}
    //public integer index{get;set;}
    public account accRecord{get;set;}
    public id accId{get;set;}
    //public id accntId{get;set;}
    public createContactDynamically()
    {
        count=0;
        accId = ApexPages.CurrentPage().getparameters().get('id');
        wrppr = new list<wrapper>();
        wrppr.add(new wrapper(new contact(),count));
    }
    
    public account getAccountRec() {
        if(accId!=null) {
            accRecord = [select name,industry,type,description from account where id=:accId];
            accId=accRecord.id;
        }
        else {
            accRecord = new Account();
        }
        return accRecord;
    }
    public PageReference SaveAcc() {
        upsert accRecord;
        accId=accRecord.id;
        return null;
    }
    
    
    public void AddRow()
    {
        count+=1;
        wrppr.add(new wrapper(new contact(),count));
    } 
    public PageReference submit() {
        list<contact> contactList = new list<contact>();
        for(wrapper wrp : wrppr)
        {
            system.debug('accId=='+accId);
            if(accId!=null) {
                wrp.con.accountId=accId; 
            }
            contactList.add(wrp.con);  
        }
        insert contactList;
        return null;
    }
    public void Remove()
    {
        wrppr.remove(count);  
        count-=1;
    }
    
    public class wrapper {
        public integer rcount{get;set;}
        public contact con{get;set;}
        //public account acc{get;set;}
        public wrapper(Contact con ,integer cnt) {
            this.rcount = cnt;
            this.con = con;
            
        }
    }
}