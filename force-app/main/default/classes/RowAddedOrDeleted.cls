public class RowAddedOrDeleted {
    //public contact conRecord{get;set;}
    public integer count{get;set;}
    public list<wrapper> wrp{get;set;}
    public list<contact> conToInsert{get;set;}
    public RowAddedOrDeleted() {
        count=0;
        wrp = new list<wrapper>();
        //conRecord = new contact();
        wrp.add(new wrapper(new contact(),count));
    }
    
    public void save() {
        conToInsert = new list<contact>();
        for(wrapper wp : wrp) {
            conToInsert.add(wp.conData);
        }
        insert conToInsert;
    }
    
    public void addRow() {
        count+=1;
        wrp.add(new wrapper(new contact(),count));
    }
    
    public class wrapper{
        public contact conData{get;set;}
        public integer add{get;set;}
        
        public wrapper(contact c,integer i) {
            this.conData = c;
            this.add = i;
        }
    }
}