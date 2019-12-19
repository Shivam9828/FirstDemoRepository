public class EmailSendController {
 @AuraEnabled 
    public static void sendMailMethod(String mMail ,String mSubject ,String mbody){
    
     List<Messaging.SingleEmailMessage> mails =  new List<Messaging.SingleEmailMessage>();     
  
     // Step 1: Create a new Email
       Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    
    // Step 2: Set list of people who should get the email
       List<String> sendTo = new List<String>();
       sendTo.add(mMail);
       mail.setToAddresses(sendTo);
    
    // Step 3: Set who the email is sent from
       mail.setReplyTo('noreply@gmail.com'); // change it with your mail address.
       mail.setSenderDisplayName('salesforce User'); 
    
    // Step 4. Set email contents - you can use variables!
      mail.setSubject(mSubject);
      mail.setHtmlBody(mbody);
    
    // Step 5. Add your email to the master list
      mails.add(mail);
    
  // Step 6: Send all emails in the master list
     Messaging.sendEmail(mails);
   }   
    
    @AuraEnabled
    public static contact getAccount(id recordId) {
        return [select id,FirstName,lastname,Account.name from contact where id=:recordId and accountid!=null limit 1];
    }
    
        @AuraEnabled
    public static contact saveEmailTemplate(contact cont) {
        system.debug(cont);
        update cont;
        return [select id,FirstName,lastname,Account.name from contact where Id=:cont.Id and Accountid!=null Limit 1];
    }
    
    @AuraEnabled
     public static contact createContact(Contact con) {
        system.debug(con);
        insert con;
        return con;
    }
}