public class findcontact {
    Public List<Contact> contactfind(){
        List<Contact> con = New List<Contact>();
        con = [select Id,Name,Phone,Email,Account.Name,Account.Industry from Contact limit 10];
        return con;
    }
}