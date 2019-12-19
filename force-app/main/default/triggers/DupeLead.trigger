trigger DupeLead on Lead (before insert, before update) {

    for(lead ldRecord : trigger.new) {
        if(ldRecord.Email!=null) {
            list<contact> con = [select Email from contact where email=:ldRecord.Email];
            if(con.size()>0) {
                ldRecord.addError('Duplicate Email FOund');
            }
        }
    }
}