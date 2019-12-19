trigger UpdateContact on Opportunity (after insert, after update) {

    set<id> conId = new set<id>();

for(Opportunity opp : trigger.new){
conId.add(opp.accountId);
}

List<Account> conList = [select id,Industry from Account where id IN : conId];
List<Account> updateAccount = new List<Account>();
for(Opportunity opRec : trigger.new) {

    for(Account con : conList) {
    if(con.id == opRec.accountId) {
    if(opRec.stagename =='Prospecting') {
       con.Industry = 'Education';
       updateAccount.add(con);
    }
    else {
     con.Industry = 'Banking';
     updateAccount.add(con);
    }
    }
    }
    
    update updateAccount;
}
}