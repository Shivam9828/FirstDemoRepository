public class DisplayAccounts {
    
    public DisplayAccounts() {
        
        set < String > AccountIdset = new set < String > ();
        for (Account ac: [select id, Name, Phone, Website from Account limit 5000]) {
            AccountIdset.add(ac.id);
        }
        /* call the above class that has returned accesstoken which is mandatory to get data from source org */      
        //SendAccount sa = new SendAccount();
        String accessToken = '00D2v000001eEGc!AQ4AQCpmd_nLIydQCSiV4JR.f2tD1HLg8ErlAtG_gXTDvYI25oHSdRqkfs7ywIGx86VP2TTnWrZxtx37ysbctKPLU5YuAi5f';
        //accessToken = sa.ReturnAccessToken();
        
        Http h1 = new Http();
        HTTPRequest req = new HTTPRequest();    
        req.setEndpoint('https://shivam9828-dev-ed.my.salesforce.com/services/data/v46.0/query?q=SELECT+name+,+phone+,+website+from+Account');
        req.setMethod('GET');
        //req.setHeader('Content-Type','application/json');
        req.setHeader('Content-Type', 'application/json;charset=UTF-8');
        req.setHeader('Authorization', 'Bearer ' + accessToken);           
        // Declaration of Http Response class
        system.debug('request=='+req);
        HTTPResponse res = h1.send(req);
        String strResponse = res.getBody();
        //Deserializing the response
        system.debug('res.getBody()=='+res.getBody());
        System.debug('STATUS:' + res.getStatus());
        System.debug('STATUS_CODE:' + res.getStatusCode());
        system.debug('JSON.deserialize(strResponse=='+JSON.deserializeUntyped(strResponse));
        Map<String, Object> lstAccounts = (Map<String, Object>) JSON.deserializeUntyped(strResponse);
        //Map<String,Object> lstAccounts = ( Map<String,Object>)JSON.deserialize(strResponse, List <Account> .class);
        system.debug('lstAccounts=='+lstAccounts);
        List<Object> objList = (List<object>) lstAccounts.get('records');
        system.debug('objList=='+objList);
        accWrpList = new List < wrapAccounts > ();
        List<string> lsstr= new List<string> ();
        /*for (integer i = 0; i < lstAccounts.size(); i++) {
            //system.debug('lstAccounts=='+lstAccounts[i].Name);
            accwrap = new wrapAccounts();
           //accwrap.Name = lstAccounts[i].Name;
           accwrap.isChecked = false;
            if (!AccountIdset.contains(accwrap.Id)) {
                accWrpList.add(accwrap);
            }
            
            system.debug('LIST—–' + accWrpList);
            
        }*/
        for(Object obj : objList) {
            //lsstr.add(String.valueOf(obj));
            accwrap = new wrapAccounts();
             Map<String, Object> p = (Map<String, Object>) obj;
            system.debug('obj=='+p.get('Name'));
            accwrap.name = (String) p.get('Name');
            accwrap.phone = (string) p.get('Phone');
            accwrap.Website = (string) p.get('Website');
            accWrpList.add(accwrap);
        }
    }
    
    public pageReference doSave() {
        List<Account> acList = new List<Account> ();
        for (wrapAccounts wa: accWrpList) {
            if (wa.isChecked == true) {
                Account a = new Account();
                a.Name = wa.Name;
               acList.add(a);
            }
        }
        
        if (acList.size() > 0) {
            try {
                insert acList;
            } catch(Exception e) {
                system.debug('ERROR :' + e);
            }
        }
        return (new pagereference('/apex/ShowAccountRecords').setRedirect(true));
    }
    
    public wrapAccounts accwrap {get;set;}
    public List <wrapAccounts> accWrpList {get;set;}
    
    public class wrapAccounts {
        public string Id {get;set;}            
        public string Name {get;set;}           
        public string Phone {get;set;}
        public string Website {get;set;}
        public Boolean isChecked{get;set;}          
        
    }
    
}