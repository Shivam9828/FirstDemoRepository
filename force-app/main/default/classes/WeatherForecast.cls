public with sharing class WeatherForecast 
{
    public JsonP.Data js {get;set;}
    public OurParse.Data js1 {get;set;}
    public String s {get;set;}
    public String s1 {get;set;}
    public String des {get;set;}
    public Integer t {get;set;}
    public Integer maxt {get;set;}
    public Integer mint {get;set;}
    public String con {set;get;}
    public String country {set;get;}
    public String c {set;get;}
    public Integer hum {get;set;}
    public Double spd {get;set;}
    public Integer pres {get;set;}
    public String l {get;set;}
    public DateTime dt {get;set;}
    
    public WeatherForecast(ApexPages.StandardController controller)
    {
        for(Contact ct : [Select MailingCity,MailingCountryCode,MailingCountry,CreatedDate from Contact where id= : ApexPages.currentPage().getParameters().get('id') limit 1])
         {
            con = ct.MailingCountryCode;
             system.debug('CountryCode:'+con);
            country = ct.MailingCountry.capitalize();
            c = ct.MailingCity.capitalize();   
             system.debug('country:'+con);system.debug('City:'+c);
         }
         
        String apiKey = 'f726d4e95c5979adc099eb23428a0a66';
         Http h = new Http();
         HttpRequest req = new HttpRequest();
         HttpResponse hres = new HttpResponse();
        String requestEndpoint = 'http://api.openweathermap.org/data/2.5/weather';
		requestEndpoint += '?q=' + c;
		requestEndpoint += '&units=metric';
		requestEndpoint += '&APPID=' + apiKey;
         req.setEndPoint(requestEndpoint);  
         req.setMethod('GET');
         //req.setTimeOut(120000);
        system.debug('Response:'+h.send(req));
          hres = h.send(req);
        //system.debug('Response:'+hres);
         s = hres.getBody();
         js = JsonP.parse(s);
         t = (js.Main.temp).intValue();
         maxt = (js.Main.temp_max).intValue();
         mint = (js.Main.temp_min).intValue();
         hum = js.Main.humidity;
         spd = js.Wind.speed;
         pres = (js.Main.pressure).intValue();
         des = js.Weather[0].description.capitalize();  
         //l = ''+js.dt;
        // l = l+'100';
         //Long ld = Long.valueOf(l);
         //dt = DateTime.newInstance(ld);
         
        /* String apiKeyTimeZone = 'YGLYE8YKHCVY';
         Http h1 = new Http();
         HttpRequest req1 = new HttpRequest();
         if(c != null && con != null)
         {
             system.debug('Country : '+ con);
             String endpointRequest = 'http://api.timezonedb.com/v2.1/get-time-zone';
		endpointRequest += '?key=' + apiKeyTimeZone;
		endpointRequest += '&format=json';
             endpointRequest += '&by=country';
             endpointRequest += '&country='+con;
		//endpointRequest += '&country=' + con;
             req1.setEndPoint(endpointRequest);  
             req1.setMethod('GET');
             req1.setTimeOut(120000);
             HttpResponse hres1 = h1.send(req1);
         
             s1 = hres1.getBody();
             system.debug('s1 : '+s1);
             js1 = OurParse.parse(s1);
         system.debug('js1'+js1);
             s1 = ''+js1.Zones[0].timestamp;
             s1 = s1+'100';
             Long t1 = Long.valueOf(s1);
             dt = DateTime.newInstance(t1); 
         */
         
           
    }

}