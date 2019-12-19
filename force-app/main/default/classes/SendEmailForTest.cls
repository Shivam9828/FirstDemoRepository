public class SendEmailForTest {
    
    @AuraEnabled
    public static void sendEmail(){
        
        
        List<string> toAddress = new List<string>();
        toAddress.add('shivam.yadav0611@gmail.com');
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setTemplateId('2F00X6F000002tof9');
        mail.setToAddresses(toAddress);
        mail.setSubject('For Case Record');
        
        List<Messaging.SingleEmailMessage> allmsg = new List<Messaging.SingleEmailMessage>();
        allmsg.add(mail);
        
        try {
            system.debug('!!!!!!!');
            Messaging.sendEmail(allmsg,false);
            return;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
    }}