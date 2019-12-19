public class QuickBookIntigrationService {
    public static String client_Id = 'Q0P7ulucpCaope7vtpZoPR1GJ0lnjoGOlruZcBnqEWpTpANrBn';//L0b0okNmY9bQ2XYXeXy9FACmCtwSnPVRBe0Jnh158wlBvyuRnK
    public static String consumer_Secret = 'qqPuEjW94BwKAMpBoxJJLP03ZgKmyUHtZGxCoVGj';//4f2rscGFcWZhfmDrkmfBixJObSTV2KfYpVlVIs5t
    public static String redirect_URI = 'https://shivam0611-dev-ed.my.salesforce.com/apex/QuickbookConnection';
    public static Account AccountErr{ get; set; }
    public static Contact ContactErr{ get; set; }
    public static String errorFinder = '';
    public static String accessTokenValue;
    private static OAuthService__c serviceObject;
    static Map<string,string> currMap;
    static Quickbook__c CS = Quickbook__c.getInstance();
    public static PageReference doAuthorizationQuickBooks(){
        // Testing
        //Quickbooks_Token_Info__c oauthClient = new Quickbooks_Token_Info__c();
        String authorization_endpoint =  'https://appcenter.intuit.com/connect/oauth2'; 
        
        String scope = 'com.intuit.quickbooks.accounting';
        
        String final_EndPoint = authorization_endpoint+'?client_id='+client_Id+'&response_type=code'+'&scope='+
            scope+'&redirect_uri='+redirect_URI+'&state=123445633443&myRecord=aaa';
        
        PageReference pageRef = new PageReference(final_EndPoint);  
        return pageRef;
    }
    
    public static void doFetchAccessToken(){
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(client_Id+':'+consumer_Secret));
        String endPoint = 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer';
        String oAuthCode = ApexPages.currentPage().getParameters().get('code');
        String requestBody = 'grant_type=authorization_code&code='+oAuthCode+'&redirect_uri='+redirect_URI;
        String errorMessage ='';
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(endPoint);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
        httpReq.setBody(requestBody);
        
        try{
            httpRes = http.send(httpReq);
            
            if(httpRes.getStatusCode() == 200){	
                Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
                List<Quickbooks_Token_Info__c> connectSettingInfos = new List<Quickbooks_Token_Info__c>();
                connectSettingInfos = [Select Id, Name,Expires_In_Time__c From Quickbooks_Token_Info__c 
                                       Where Name ='QuickBooks Setting Info'];
                Quickbooks_Token_Info__c quickBooksSettingInfo = new Quickbooks_Token_Info__c();
                
                String Name = 'QuickBooks Setting Info';
                String accessToken = (String)response_Map.get('access_token');
                String refreshToken = (String)response_Map.get('refresh_token');
                Decimal expiresIn = (Decimal)response_Map.get('expires_in');
                Decimal expiresInRefToken = (Decimal)response_Map.get('x_refresh_token_expires_in');
                
                
                quickBooksSettingInfo.Name = Name;
                quickBooksSettingInfo.Access_Token__c = accessToken;
                quickBooksSettingInfo.Refresh_Token__c = refreshToken;
                quickBooksSettingInfo.Expire_In_Seconds__c = expiresIn;
                quickBooksSettingInfo.Refresh_Token_Expires_In__c = expiresInRefToken;
                quickBooksSettingInfo.Expires_In_Time__c = System.Now().addSeconds(Integer.valueOf(expiresIn));
                if(connectSettingInfos!=null && connectSettingInfos.size() > 0 ) quickBooksSettingInfo.Id = connectSettingInfos[0].Id;
                
                upsert quickBooksSettingInfo;
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Confirm,'Successfully Authenticated with Quickbooks System!!!'));
            }else{
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error while communicating with Quickbooks API'+
                                                           'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode()));
            }
            
        }catch(System.Exception e){
            System.debug('#### Exception Executed '+e.getStackTraceString());
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }else{
                errorMessage = 'Unexpected Error while communicating with Quickbooks API. '
                    +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }
        }  
        
        
    }
    
    public static void doRefreshAccessToken(){
        system.debug('client_Id'+client_Id);
        String encodedString = EncodingUtil.base64Encode(Blob.valueOf(client_Id+':'+consumer_Secret));
        String endPoint = 'https://oauth.platform.intuit.com/oauth2/v1/tokens/bearer';
        //QuickBookIntegrationInfo__c QBInfo = QuickBookIntegrationInfo__c.getAll().get('QuickBooks Setting Info');
        List<Quickbooks_Token_Info__c> QBInfo = new List<Quickbooks_Token_Info__c>();
        QBInfo = [Select Id, Name,Expires_In_Time__c, Refresh_Token__c,
                  Refresh_Token_Expires_In__c  From Quickbooks_Token_Info__c 
                  Where Name ='QuickBooks Setting Info'];
        String requestBody = 'grant_type=refresh_token&refresh_token=';
        if(QBInfo!=null && QBInfo[0].Refresh_Token__c != null){
            requestBody+= QBInfo[0].Refresh_Token__c;
        }else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Refresh Token is NULL'));
        }
        String errorMessage ='';
        
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        Http http = new Http();
        httpReq.setMethod('POST');
        httpReq.setEndPoint(endPoint);
        httpReq.setHeader('Authorization' , 'Basic '+encodedString);
        httpReq.setHeader('Content-Type' , 'application/x-www-form-urlencoded');
        httpReq.setBody(requestBody);
        
        try{
            // Check if Access Token is expired or not.
            // if Expired then get the new Token
            system.debug(QBInfo);
                httpRes = http.send(httpReq);
             //     system.debug('accessTokenValue---Gen-->'+httpRes.getBody());
                if(httpRes.getStatusCode() == 200){
                    Map<String, Object> response_Map = (Map<String, Object>)JSON.deserializeUntyped(httpRes.getBody());
                    if(response_Map.get('access_token')!=null){
                    accessTokenValue=string.valueof(response_Map.get('access_token'));
                        }
                      system.debug('accessTokenValue---Gen-->'+accessTokenValue);
                    // Assign the Value to the Existing Quickbooks info Object and at the last update the information
                    // with new values
                }else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Unexpected Error while communicating with Quickbooks API'+
                                                               'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode()));
                }
            
        }catch(System.Exception e){
            System.debug('#### Exception Executed '+e.getStackTraceString());
            if(String.valueOf(e.getMessage()).startsWith('Unauthorized endpoint')){
                errorMessage = 'Unauthorize endpoint: An Administer must go to Setup -> Administer -> Security Control ->'
                    +' Remote Site Setting and add '+' '+ endPoint +' Endpoint';
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }else{
                errorMessage = 'Unexpected Error while communicating with Quickbooks API. '
                    +'Status '+httpRes.getStatus()+' and Status Code '+httpRes.getStatuscode();
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errorMessage));
                //return null;
            }
        }  
    }
    
    
    
    public static Account createCustomer(Account acc){
        currMap = new Map<string,string>();
        currMap.put('USD','United States Dollar');
        currMap.put('EUR','Euro');
        system.debug('####Test');
        for(string key : currMap.keySet()){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            
            if(key.equals('USD')){
                gen.writeStringField('DisplayName', acc.name+'.');
            }else{
                gen.writeStringField('DisplayName', acc.name);
            }
            
            gen.writeFieldName('BillAddr');
            gen.writeStartObject();
            gen.writeStringField('Line1', acc.BillingStreet == null ? '' : acc.BillingStreet);
            gen.writeStringField('City', acc.BillingCity  == null ? '' : acc.BillingCity);
            gen.writeStringField('Country', acc.BillingCountry == null ? '' : acc.BillingCountry);
            //gen.writeStringField('CountrySubDivisionCode', 'test@virtuowhiz.com');
            gen.writeStringField('PostalCode', acc.BillingPostalCode == null ? '' : acc.BillingPostalCode);
            gen.writeEndObject();
            
            gen.writeFieldName('CurrencyRef');
            gen.writeStartObject();
            gen.writeStringField('value', key);
            gen.writeStringField('name', currMap.get(key));
            gen.writeEndObject();
            gen.writeFieldName('PrimaryEmailAddr');
            gen.writeStartObject();
            gen.writeStringField('Address', acc.Primary_Email__c == null ? '' : acc.Primary_Email__c);//Should be changed
            gen.writeEndObject();
            //gen.writeEndObject();
            String body = gen.getAsString();
            system.debug('Body : '+body);
            list<string> fetchChilds = new list<string>();// //123146318044504
            String endPoint = 'https://sandbox-quickbooks.api.intuit.com/v3/company/123145685018067/customer';
            //string    requestBody='{ "FullyQualifiedName": "King Groceries", "PrimaryEmailAddr": { "Address": "jdrew@myemail.com" }, "DisplayName": "Kings Groceries", "Suffix": "Jr", "Title": "Mr", "MiddleName": "B", "Notes": "Here are other details.", "FamilyName": "King", "PrimaryPhone": { "FreeFormNumber": "(555) 555-5555" }, "CompanyName": "King Groceries", "BillAddr": { "CountrySubDivisionCode": "CA", "City": "Mountain View", "PostalCode": "94042", "Line1": "123 Main Street", "Country": "USA" }, "GivenName": "James" }';
            doRefreshAccessToken();
            system.debug('accessTokenValue--->'+accessTokenValue);
            String accessToken =accessTokenValue;
            HttpRequest httpReq = new HttpRequest();
            HttpResponse httpRes = new HttpResponse();
            Http http = new Http();
            httpReq.setMethod('POST');
            httpReq.setEndPoint(endPoint);
            httpReq.setHeader('Authorization' , 'Bearer '+accessToken);
            httpReq.setHeader('Accept', 'application/json');
            httpReq.setHeader('Content-Type', 'application/json');
            
            httpReq.setBody(body);
            
            httpRes = http.send(httpReq);
            system.debug('httpRes'+httpRes.getStatusCode());
            QuickBookCustomerWrapper obj;
            if(httpRes.getStatusCode() == 200){
             obj = QuickBookCustomerWrapper.parse(httpRes.getBody());
              if(key.equals('USD')){
                    acc.Quickbooks_USDId__c = obj.Customer.id;
                    if(obj.Customer.BillAddr != null){
                        acc.BillingAddressID_USD__c = obj.Customer.BillAddr.Id;
                    }else{
                        acc.BillingAddressID_USD__c = '0';
                    }
                    acc.Quickbook_SyncToken_USD__c = obj.Customer.SyncToken;
                }
                else{
                    acc.Quickbooks_EURId__c = obj.Customer.id;
                    acc.Quickbook_SyncToken_EUR__c = obj.Customer.SyncToken;
                    if(obj.Customer.BillAddr != null){
                        acc.BillingAddressID_EUR__c = obj.Customer.BillAddr.Id;
                    }else{
                        acc.BillingAddressID_EUR__c = '0';
                    }
                    
                }
            }
        }
        return acc;
    }
   
    public static void updateCustomer(String aid){
        Account acc = [Select id,name,BillingStreet, BillingCity, BillingCountry, BillingPostalCode, BillingAddressID_EUR__c,BillingAddressID_USD__c, Primary_Email__c, Quickbooks_EURId__c,Quickbooks_USDId__c,Quickbook_SyncToken_EUR__c,Quickbook_SyncToken_USD__c from Account where id =:aid];
        currMap = new Map<string,string>();
        currMap.put('USD','United States Dollar');
        currMap.put('EUR','Euro');
        
        for(string key : currMap.keySet()){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(key.equals('USD')){
                gen.writeStringField('Id', acc.Quickbooks_USDId__c);
                gen.writeStringField('SyncToken', acc.Quickbook_SyncToken_USD__c);
                gen.writeStringField('DisplayName', acc.name+'.');
            }else{
                gen.writeStringField('Id', acc.Quickbooks_EURId__c);
                gen.writeStringField('SyncToken', acc.Quickbook_SyncToken_EUR__c);
                gen.writeStringField('DisplayName', acc.name);
            }
            
            gen.writeFieldName('BillAddr');
            gen.writeStartObject();
            if(key.equals('USD'))   {
                gen.writeStringField('Id', acc.BillingAddressID_USD__c == null ? '' : acc.BillingAddressID_USD__c); 
            } else{
                gen.writeStringField('Id', acc.BillingAddressID_EUR__c == null ? '' : acc.BillingAddressID_EUR__c);
            }
            
            gen.writeStringField('Line1', acc.BillingStreet == null ? '' : acc.BillingStreet);
            gen.writeStringField('City', acc.BillingCity == null ? '' : acc.BillingCity);
            gen.writeStringField('Country', acc.BillingCountry == null ? '' : acc.BillingCountry);
            //gen.writeStringField('CountrySubDivisionCode', 'test@virtuowhiz.com');
            gen.writeStringField('PostalCode', acc.BillingPostalCode == null ? '' : acc.BillingPostalCode);
            gen.writeEndObject();
            gen.writeFieldName('PrimaryEmailAddr');
            gen.writeStartObject();
            gen.writeStringField('Address', acc.Primary_Email__c == null ? '' : acc.Primary_Email__c);//Should be changed
            gen.writeEndObject();
            gen.writeEndObject();
            String body = gen.getAsString();
            
            String endPoint = 'https://sandbox-quickbooks.api.intuit.com/v3/company/123145685018067/customer';
             doRefreshAccessToken();
            system.debug('accessTokenValue--->'+accessTokenValue);
            String accessToken =accessTokenValue;
            HttpRequest httpReq = new HttpRequest();
            HttpResponse httpRes = new HttpResponse();
            Http http = new Http();
            httpReq.setMethod('POST');
            httpReq.setEndPoint(endPoint);
            httpReq.setHeader('Authorization' , 'Bearer '+accessToken);
            httpReq.setHeader('Content-Type' , 'application/json');
            httpReq.setBody(body);
            string resParams;
            try{
                httpRes = http.send(httpReq);
                //res = http.send(req); 
                resParams = httpRes.getBody();
                System.debug('###resParams :: '+resParams);
                //system.debug('httpRes.getStatusCode()-->'+httpRes.getStatusCode());  
                system.debug('httpRes.getBody()-->'+resParams);  
                QuickBookCustomerWrapper obj = QuickBookCustomerWrapper.parse(resParams);
                System.debug('### update jsonResponse ::' + obj);
                if(key.equals('USD')){
                    acc.Quickbooks_USDId__c = obj.Customer.id;
                    if(obj.Customer.BillAddr != null){
                        acc.BillingAddressID_USD__c = obj.Customer.BillAddr.Id;
                    }
                    acc.Quickbook_SyncToken_USD__c = obj.Customer.SyncToken;
                }
                else{
                    acc.Quickbooks_EURId__c = obj.Customer.id;
                    acc.Quickbook_SyncToken_EUR__c = obj.Customer.SyncToken;
                    if(obj.Customer.BillAddr != null){
                        acc.BillingAddressID_EUR__c = obj.Customer.BillAddr.Id;
                    }}
            }catch(Exception e) {
                System.debug(e.getMessage());     
                errorFinder = e.getMessage();
            }
        }
        ProcessorControlFututreAccount.futureFlag=false;
        update acc;
        
    }
    
    public static PageReference quickbookExport(){
        string orgId = ApexPages.currentPage().getParameters().get('id');
        Account acc = [Select id,name,BillingStreet, BillingCity, BillingCountry, BillingPostalCode, BillingAddressID_EUR__c,BillingAddressID_USD__c, Primary_Email__c, Quickbooks_EURId__c,Quickbooks_USDId__c,Quickbook_SyncToken_EUR__c,Quickbook_SyncToken_USD__c from Account where id =:orgId];
        AccountErr = acc;
        if(acc.Quickbooks_EURId__c !=null && acc.Quickbooks_USDId__c!=null){
            updateCustomer(acc.id);
        }else{
            acc = createCustomer(acc);
            system.debug('Name :'+acc.Name);
        }
        if(!String.isEmpty(errorFinder) && errorFinder.contains('Attempt to de-reference a null object')){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Another customer, contact or account is already using this name. Please change the name and try again.'));
            return null;
        }
        if(acc.Quickbooks_EURId__c != null && acc.Quickbooks_USDId__c!=null){
            update acc;
        }
        PageReference p = new PageReference('/' + acc.Id);
        return p;
    }
    
    public static Contact createContactCustomer(Contact con){
        system.debug('con'+con);
        currMap = new Map<string,string>();
        currMap.put('USD','United States Dollar');
        currMap.put('EUR','Euro');
        for(string key : currMap.keySet()){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            
            if(key.equals('USD')){
                gen.writeStringField('DisplayName', con.name+'.');
            }else{
                gen.writeStringField('DisplayName', con.name);
            }
            
            gen.writeFieldName('BillAddr');
            gen.writeStartObject();
            gen.writeStringField('Line1', con.MailingStreet == null ? '' : con.MailingStreet);
            gen.writeStringField('City', con.MailingCity == null ? '' : con.MailingCity);
            gen.writeStringField('Country', con.MailingCountry == null ? '' : con.MailingCountry);
            //gen.writeStringField('CountrySubDivisionCode', 'test@virtuowhiz.com');
            gen.writeStringField('PostalCode', con.MailingPostalCode == null ? '' : con.MailingPostalCode);
            gen.writeEndObject();
            
            gen.writeFieldName('CurrencyRef');
            gen.writeStartObject();
            gen.writeStringField('value', key);
            gen.writeStringField('name', currMap.get(key));
            gen.writeEndObject();
            gen.writeFieldName('PrimaryEmailAddr');
            gen.writeStartObject();
            gen.writeStringField('Address', con.Email == null ? '' : con.Email);//Should be changed
            gen.writeEndObject();
            gen.writeEndObject();
            String body = gen.getAsString();
            String endPoint = 'https://sandbox-quickbooks.api.intuit.com/v3/company/123145685018067/customer';
           doRefreshAccessToken();
            system.debug('accessTokenValue--->'+accessTokenValue);
            String accessToken =accessTokenValue;

            
            HttpRequest httpReq = new HttpRequest();
            HttpResponse httpRes = new HttpResponse();
            Http http = new Http();
            httpReq.setMethod('POST');
            httpReq.setEndPoint(endPoint);
            httpReq.setHeader('Authorization' , 'Bearer '+accessToken);
            httpReq.setHeader('Content-Type' , 'application/json');
            httpReq.setHeader('Accept', 'application/json');
            httpReq.setBody(body);
            httpRes = http.send(httpReq);
            QuickBookCustomerWrapper obj;
            system.debug('httpRes.getBody()-->'+httpRes.getBody());
            if(httpRes.getStatusCode() == 200){
             obj = QuickBookCustomerWrapper.parse(httpRes.getBody());
                if(key.equals('USD')){
                    con.Quickbooks_USDId__c = obj.Customer.id;
                    if(obj.Customer.BillAddr != null){
                        con.MailingAddressID_USD__c = obj.Customer.BillAddr.Id;
                    }
                    con.Quickbook_SyncToken_USD__c = obj.Customer.SyncToken;
                }else{
                    con.Quickbooks_EURId__c = obj.Customer.id;
                    con.Quickbook_SyncToken_EUR__c = obj.Customer.SyncToken;
                    if(obj.Customer.BillAddr != null){
                        con.MailingAddressID_EUR__c = obj.Customer.BillAddr.Id;
                    }
                }
                
        }
        }
        return con;
    }
    
    public static void updateCustomerByContact(String cid){
        Contact con = [Select id,name, MailingStreet, MailingCity, MailingCountry, MailingPostalCode, MailingAddressID_EUR__c,MailingAddressID_USD__c, Email, Quickbooks_EURId__c,Quickbooks_USDId__c,Quickbook_SyncToken_EUR__c,Quickbook_SyncToken_USD__c from Contact where id =:cid];
        system.debug('####contact' + con);
        currMap = new Map<string,string>();
        currMap.put('USD','United States Dollar');
        currMap.put('EUR','Euro');
        for(string key : currMap.keySet()){
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            if(key.equals('USD')){
                gen.writeStringField('Id', con.Quickbooks_USDId__c);
                gen.writeStringField('SyncToken', con.Quickbook_SyncToken_USD__c);
                gen.writeStringField('DisplayName', con.name+'.');
            }else{
                gen.writeStringField('Id', con.Quickbooks_EURId__c);
                gen.writeStringField('SyncToken', con.Quickbook_SyncToken_EUR__c);
                gen.writeStringField('DisplayName', con.name);
            }
            
            gen.writeFieldName('BillAddr');
            gen.writeStartObject();
            if(key.equals('USD'))   {
                gen.writeStringField('Id', con.MailingAddressID_USD__c == null ? '' : con.MailingAddressID_USD__c); 
            } else{
                gen.writeStringField('Id', con.MailingAddressID_EUR__c == null ? '' : con.MailingAddressID_EUR__c);
            }
            
            gen.writeStringField('Line1', con.MailingStreet == null ? '' : con.MailingStreet);
            gen.writeStringField('City', con.MailingCity == null ? '' : con.MailingCity);
            gen.writeStringField('Country', con.MailingCountry == null ? '' : con.MailingCountry);
            //gen.writeStringField('CountrySubDivisionCode', 'test@virtuowhiz.com');
            gen.writeStringField('PostalCode', con.MailingPostalCode == null ? '' : con.MailingPostalCode);
            gen.writeEndObject();
            gen.writeFieldName('PrimaryEmailAddr');
            gen.writeStartObject();
            gen.writeStringField('Address', con.Email == null ? '' : con.Email);//Should be changed
            gen.writeEndObject();
            gen.writeEndObject();
            String body = gen.getAsString();
            String endPoint = 'https://sandbox-quickbooks.api.intuit.com/v3/company/123145685018067/customer';
              doRefreshAccessToken();
            system.debug('accessTokenValue--->'+accessTokenValue);
            String accessToken =accessTokenValue;
            HttpRequest httpReq = new HttpRequest();
            HttpResponse httpRes = new HttpResponse();
            Http http = new Http();
            httpReq.setMethod('POST');
            httpReq.setEndPoint(endPoint);
            httpReq.setHeader('Authorization' , 'Bearer '+accessToken);
            httpReq.setHeader('Content-Type' , 'application/json');
            httpReq.setBody(body);
            httpRes = http.send(httpReq);
            system.debug('httpRes.getStatusCode()-->'+httpRes.getStatusCode());  
            system.debug('httpRes.getBody()-->'+httpRes.getBody());  
        }}
    
    public static PageReference quickbookContactExport(){
        
        string orgId = ApexPages.currentPage().getParameters().get('id');
        Contact con = [Select id,name,MailingStreet, MailingCity, MailingCountry, MailingPostalCode, MailingAddressID_EUR__c,MailingAddressID_USD__c, Email, Quickbooks_EURId__c,Quickbooks_USDId__c,Quickbook_SyncToken_EUR__c,Quickbook_SyncToken_USD__c from Contact where id =:orgId];
        ContactErr = con;
        if(con.Quickbooks_EURId__c !=null && con.Quickbooks_USDId__c!=null){
            updateCustomer(con.id);
        }else{
            con = createContactCustomer(con);
            if(!String.isEmpty(errorFinder) && errorFinder.contains('Attempt to de-reference a null object')){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Another customer, contact or account is already using this name. Please change the name and try again.'));
                return null;
            }
        }
        
        if(con.Quickbooks_EURId__c != null && con.Quickbooks_USDId__c!=null){
            update con;
        }
        PageReference p = new PageReference('/' + con.Id);
        return p;
    }
    
    
    
}