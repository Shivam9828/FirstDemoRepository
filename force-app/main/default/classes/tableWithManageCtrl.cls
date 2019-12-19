public class tableWithManageCtrl {
    @AuraEnabled
    public static List < account > fetchAccount() {
        
        List < Account > returnList = new List < Account > ();
        
        for (Account acc: [select id, Name, Type, Industry, Phone, Fax from account LIMIT 10]) {
            returnList.add(acc);
        }
        return returnList;
    }
}