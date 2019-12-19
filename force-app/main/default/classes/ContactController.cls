public class ContactController {

    @AuraEnabled
    public static List<Contact> getContacts(){
        return [SELECT 
                	ID, 
                	Name, 
                	Email,
                	Phone,
                	Birthdate 
               FROM 
                	Contact LImit 10];
    }
}