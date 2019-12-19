public class displayAccountCallout {

   public displayAccountCallout() {
       set <String> AccountIdset = new set <String> ();
       for (Account ac: [select id, Name, Phone, Website from Account limit 5000]) {
           AccountIdset.add(ac.id);
       }
       system.debug('AccountIdset=='+AccountIdset);
       // Declaration of Http Request class
       HTTPRequest req = new HTTPRequest();
       req.setEndpoint('https://testforrestservice-developer-edition.ap15.force.com/services/apexrest/displayAccounts');
       req.setMethod('GET');

       // Declaration of Http Response class
       HTTP http = new HTTP();
       HTTPResponse res = http.send(req);
       String strResponse = res.getBody();
       system.debug('strResponse=='+strResponse);
       //Deserializing the response
       List<Account> lstAccounts = (List<Account>)JSON.deserialize(strResponse , List<Account>.class );                                        

       accWrpList = new List<wrapAccounts> ();
       for (integer i = 0; i < lstAccounts.size(); i++) {
           accwrap = new wrapAccounts();
           accwrap.Id = lstAccounts[i].id;
           accwrap.Name = lstAccounts[i].Name;
           accwrap.Phone = lstAccounts[i].Phone;
           accwrap.Website = lstAccounts[i].Website;
           accwrap.isChecked = false;
           if (!AccountIdset.contains(accwrap.Id)) {
               accWrpList.add(accwrap);
           }

           system.debug('LIST—–' + accWrpList);
       }
   }
   public pageReference doSave() {
       List < Account > acList = new List < Account > ();
       for (wrapAccounts wa: accWrpList) {
           if (wa.isChecked == true) {
               Account a = new Account();
               a.Name = wa.Name;
               a.Phone = wa.Phone;
               acList.add(a);
           }
           system.debug('%%%%%' + acList.size());
       }

       if (acList.size() > 0) {
           try {
               insert acList;
           } catch (Exception e) {
               system.debug('ERROR :' + e);
           }
       }
       return (new pagereference('/apex/ShowAccountRecords').setRedirect(true));

   }


   public wrapAccounts accwrap {get; set;}
   public List<wrapAccounts> accWrpList {get; set;}
   public class wrapAccounts {
   
       public string Id {get; set;}
       public string Name {get; set;}
       public string Phone {get; set;}
       public string Website {get; set;}
       public Boolean isChecked {get; set;}
          
   }
}