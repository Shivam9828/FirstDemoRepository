public class VFforTest {
    public list<account> acnt{get;set;}
 public VFforTest() {

            acnt = [select name,industry from account limit 10];

      }
}