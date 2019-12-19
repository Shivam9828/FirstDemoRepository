public class J1VisaReviewDetails {
    
    public list<account> accRecord{get;set;}
    public list<Wrapper> wrp{get;set;}

    public J1VisaReviewDetails() {
        
        wrp = new list<Wrapper>();
        for(Account acc : [select name,industry from account]) {
            wrp.add(new Wrapper(acc,false));
        }
    }
    
    public pagereference selectRecords() {
        accRecord = new list<account>();
        //list<Wrapper> wpRecord = new list<Wrapper>();
        for(Wrapper wp : wrp) {
            if(wp.checkWhenNeeded==true) {
                accRecord.add(wp.accRecord);
            }
            
        }
        pagereference pg = page.selectedRecords;
        
        return null;
    }
    
    public class Wrapper{
        public account accRecord{get;set;}
        public boolean checkWhenNeeded{get;set;}
        public Wrapper(account act,boolean check) {
            this.accRecord = act;
            this.checkWhenNeeded = check;
        }
    }
}