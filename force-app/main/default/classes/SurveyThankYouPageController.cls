public class SurveyThankYouPageController {
     public String language {get;set;}
	
    public SurveyThankYouPageController(){
        language = Apexpages.currentPage().getParameters().get('ln');
        if(String.isBlank(language)){
            language = 'en';
        }
    }
}