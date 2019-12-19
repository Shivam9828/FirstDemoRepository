public class SendAccount {
    
    String clientId = '3MVG9G9pzCUSkzZuMvOU3EKxZTTegDxHRSR4kMtK4KkE10oF7WGq4nHfEJ9wrpCkDyl0aT18lTj20oH.qgtTT';
    String clientsecret = 'D4F58196C06D5ECD6398719345D4FC706604097DEC6748461CEB58EC4359D64E';
    String username = 'shivam9828@yadav.com';
    String password = 'yadav9828';
    String accesstoken_url = 'https://login.salesforce.com/services/oauth2/token';
    String redirecturi = 'https://shivam0611-dev-ed--c.ap4.visual.force.com/apex/ShowAccountRecords';
    String authurl = 'https://login.salesforce.com/services/oauth2/authorize';
    
    public class deserializeResponse {
        public String access_token;
    }
    public String ReturnAccessToken() {
        system.debug('ReturnAccessToken==');
        String reqbody = 'grant_type=password&client_id=' + clientId + '&client_secret=' + clientSecret + '&username=' + username + '&password=' + password;
        string paramvalue = EncodingUtil.base64Encode(Blob.valueOf(userinfo.getSessionId()));
        system.debug('paramvalue=='+paramvalue);
        Http h = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setBody(reqbody);
        req1.setMethod('POST');    
        req1.setHeader('Content-Type','application/x-www-form-urlencoded');
        req1.setEndpoint('https://login.salesforce.com/services/oauth2/token?'+reqbody);
        HttpResponse res = h.send(req1);
        System.debug('Response=='+res.getBody());
        System.debug('STATUS:' + res.getStatus());
        System.debug('STATUS_CODE:' + res.getStatusCode());
        deserializeResponse der = (deserializeResponse) JSON.deserialize(res.getBody(), deserializeResponse.class);
        system.debug('accessToken=='+der.access_token);
        return der.access_token;
    }
    
}