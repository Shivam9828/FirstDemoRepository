public with sharing class AccountWeatherController {

	public String city {get;set;}
	public String temp {get;set;}
	public String pressure {get;set;}
	public String humidity {get;set;}
	public String temp_min {get;set;}
	public String temp_max {get;set;}

	public AccountWeatherController(ApexPages.StandardController stdController) {
		Account acct = (Account)stdController.getRecord();
		Account accRecord = [SELECT Id, ShippingCity FROM Account WHERE Id =:acct.Id];
		
		String accountCity = accRecord.ShippingCity;
		String apiKey = 'daf9b90496ecfb2531337cbe67a71dcb';

		String requestEndpoint = 'http://api.openweathermap.org/data/2.5/weather';
		requestEndpoint += '?q=' + accountCity;
		requestEndpoint += '&units=metric';
		requestEndpoint += '&APPID=' + apiKey;
		
		Http http = new Http();
		HttpRequest request = new HttpRequest();
		request.setEndpoint(requestEndpoint);
		request.setMethod('GET');
		HttpResponse response = http.send(request);
         system.debug('Response:'+response);
		// If the request is successful, parse the JSON response.
		if (response.getStatusCode() == 200) {

   Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            city = String.valueOf(results.get('name'));
   Map<String, Object> mainResults = (Map<String, Object>)(results.get('main'));
   temp = String.valueOf(mainResults.get('temp'));
   pressure = String.valueOf(mainResults.get('pressure'));
   humidity = String.valueOf(mainResults.get('humidity')); 
   temp_min = String.valueOf(mainResults.get('temp_min')); 
   temp_max = String.valueOf(mainResults.get('temp_max'));

}
		   
		   
		   /*Map mainResults = (Map)(results.get('main'));
		   temp = String.valueOf(mainResults.get('temp'));
		   pressure = String.valueOf(mainResults.get('pressure'));
			humidity = String.valueOf(mainResults.get('humidity')); 
			temp_min = String.valueOf(mainResults.get('temp_min')); 
			temp_max = String.valueOf(mainResults.get('temp_max'));*/
		
		 else {
			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'There was an error retrieving the weather information.');
           ApexPages.addMessage(myMsg);
		}
	

	}
}