public class TestPurpose {

    public static void TestPurposeOnly() {
        list<account> acc = new list<account>();
        acc = [select name,Description from account limit 10];
        list<account> accountRecord = new list<account>();
    for(Account act : acc) {
        act.Description = 'this is for test purpose';
        //accountRecord.add(act);
        update act;   
        system.debug('###'+act);
    }
        //update accountRecord;
        
    }
    
    
}