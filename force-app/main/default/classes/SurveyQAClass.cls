/**************************************************
* Class: SurveyQAClass
* Author: Soljit - SR
* Date: 2018-08-24
* 
* Description: This is the helper controller for SurveyTakePageController which is used to store the mapping between Survey objects used and store related data and sent it back to database. 
*
* V1.0: Initial
* 
****************************************************/
global with sharing class SurveyQAClass { 
    public String   name                   {get; set;}
    public String   id                           {get; set;}
    public String   question               {get; set;}
    public String   orderNumber            {get; set;}
    public String   freeTextArea                {get; set;}
    public String   selectedOption         {get;set;}
    public List<String> selectedOptions {get;set;}
    public List<SelectOption> singleOptions{get; set;}
    public List<SelectOption> multiOptions {get; set;}
    public Boolean  required               {get; set;}
    public String   questionType           {get; set;}
    public String   surveyName               {get; set;}
    public String   renderFreeText             {get; set;}
    public String   renderSelectRadio      {get; set;}
    public String   renderSelectCheckboxes {get; set;}
    public String   renderSelectRow        {get; set;}
    public List<String> responses              {get; set;}
    public String   singleOptionsForChart  {get; set;}
    public String   qResultsForChart         {get; set;}
    public List<String> strList              {get; set;} // The question's option as a list of string
    public List<Integer> resultsCounts       {get; set;} // The count of each response to a question's freeTextArea
    public List<SelectOption> rowOptions   {get; set;}
    public List<String> matrixAnswers   {get; set;}
    public boolean  noData                 {get; set;}
    public String noOfRowsForTextArea {get; set;}
    public Map<Integer, Survey_Answer__c> answerIndexToScoreMap {get; set;}
    public Boolean isShow {get;set;}
    public Id parentId {get;set;}
    public List<SurveyQAClass> childQuestions {get;set;}
    public Boolean skipQuestion {get;set;}
    public Map<string, String> mapIndexToOptionValue {get;set;}
    public Survey_Question__c sQuestion {get; set;}
    public string language {get;set;}
  
	/**********************************************************************************************
	 *  Fills up the SurveyQAClass Object
	 *  param:    List<Survey_Answer__c>
	 *  param:    Survey_Question__c
	 *  param:    Survey_Question__c.Is_Skip_Pattern__c
	*********************************************************************************************/

    public SurveyQAClass(Survey_Question__c sq, List<Survey_Answer__c> surveyAnswers, Boolean isSkippable, String language) {
    	skipQuestion = isSkippable;
    	//System.debug('sq *******' + sq.Id);
    	sQuestion = sq;
        this.language = language;
    	matrixAnswers = new List<String>();
    	mapIndexToOptionValue = new Map<String, String>();
    	answerIndexToScoreMap = new Map<Integer, Survey_Answer__c>();
        name = sq.Name;
        id = sq.Id;
        childQuestions = new List<SurveyQAClass>();
        parentId = sq.Parent_Question__r.Parent_Question__c;
        if(isSkippable)
        	isShow = false;
        else
        	isShow = true;
            if(language == 'fr'){
                 question = (string.isBlank(sq.Question_Fr__c) ? sq.Question__c :sq.Question_Fr__c);
            }
            else{
                question = sq.Question__c;
            }
       
        orderNumber = String.valueOf(sq.OrderNumber__c);
        freeTextArea = '';
        required = sq.Required__c;
        questionType = sq.Type__c;
        singleOptionsForChart = ' ';
        selectedOption = '';
        selectedOptions = new List<String>();

        if (sq.Type__c == 'Matrix'){
            renderSelectRadio='false';
            matrixAnswers = matrixAnswers(surveyAnswers);
            renderSelectCheckboxes='false';
            renderFreeText='false';
            renderSelectRow = 'true';
            selectedOption = '';
            selectedOptions = new List<String>();
        }

        if (sq.Type__c=='Single Select--Vertical'){
            renderSelectRadio='true';
            singleOptions = answerToSelectOptions(surveyAnswers);
            renderSelectCheckboxes='false';
            renderFreeText='false';
            renderSelectRow = 'false';
            selectedOption = '';
            selectedOptions = new List<String>();
        }
        else if (sq.Type__c=='Multi-Select--Vertical'){
            renderSelectCheckboxes='true';
            multiOptions = answerToSelectOptions(surveyAnswers);
            renderSelectRadio='false';
            renderFreeText='false';
            renderSelectRow = 'false';
            selectedOption = '';
            selectedOptions = new List<String>();
        }
        else if (sq.Type__c=='Single Select--Horizontal' && sq.Parent_Question__c == null){
            renderSelectCheckboxes='false';
            rowOptions = answerToSelectOptions(surveyAnswers);
            renderSelectRadio='false';
            renderFreeText='false';
            renderSelectRow = 'true';
            selectedOption = ''; 
            selectedOptions = new List<String>();
        }

        else if(sq.Type__c=='Single Select--Horizontal' && sq.Parent_Question__c != null){
        	renderSelectCheckboxes='false';
            //System.debug('surveyAnswers ******' + surveyAnswers);
            rowOptions = answerToMatrixSelectOptions(surveyAnswers);
            renderSelectRadio='false';
            renderFreeText='false';
            renderSelectRow = 'true';
            selectedOption = '';
            selectedOptions = new List<String>();
        }

        else if (sq.Type__c=='Free Text' || sq.Type__c=='Free Text - Single Row Visible'){
            renderFreeText='true';
            renderSelectRadio='false';
            renderSelectCheckboxes='false';
            renderSelectRow = 'false';
            freeTextArea='';
            //If it's text area but for single row then only show single row even though it's stil text area
            if(sq.Type__c == 'Free Text - Single Row Visible'){
                noOfRowsForTextArea = '1';
            }else{
                noOfRowsForTextArea = '5';
            }
        }
        //responses= getResponses();
    }



	/*********************************************************************************************
	 * 
	 * 
	 * 
	 **********************************************************************************************/
    private List<SelectOption> answerToSelectOptions(List<Survey_Answer__c> surveyAnswers){
    	 List<SelectOption> returnVal = new List<SelectOption>();
    	 Integer i = 0;
        system.debug('surveyAnswers***'+surveyAnswers);
        	for(Survey_Answer__c surAns : surveyAnswers){
                if(language == 'fr'){
                    returnVal.add(new SelectOption(String.valueOf(i),(surAns.Survey_Answer_Fr__c == null ?surAns.Survey_Answer__c : surAns.Survey_Answer_Fr__c)));
                }
                else{
                    returnVal.add(new SelectOption(String.valueOf(i),surAns.Survey_Answer__c));
                }
        		answerIndexToScoreMap.put(i,surAns);
        		i++;
        	}
    	    return returnVal;
    }

    /*********************************************************************************************
     * 
     * 
     * 
     **********************************************************************************************/
    private List<SelectOption> answerToMatrixSelectOptions(List<Survey_Answer__c> surveyAnswers){
    	 List<SelectOption> returnVal = new List<SelectOption>();
    	 Integer i = 0;
    	 List<string> sortedSurveyAnswers = matrixAnswers(surveyAnswers);
    	for(String surAns : sortedSurveyAnswers){
    		mapIndexToOptionValue.put(String.valueOf(i), surAns);
    		returnVal.add(new SelectOption(String.valueOf(i),''));
    		//answerIndexToScoreMap.put(i,surAns.Score__c); // TODO Find solution to put proper score for sorted list
    		i++;
    	}
        System.debug('mapIndexToOptionValue *****' + mapIndexToOptionValue);
    	 return returnVal;
    }

    /*********************************************************************************************
     * 
     * 
     * 
     **********************************************************************************************/
    private List<string> matrixAnswers(List<Survey_Answer__c> surveyAnswers){
        //System.debug('surveyAnswers *****' + surveyAnswers);
    	 List<String> returnVal = new List<String>();
    	 Integer i = 0;
         System.debug('surveyAnswers ******' + surveyAnswers);
         
    	for(Survey_Answer__c surAns : surveyAnswers){
            if(language == 'fr'){ 
                returnVal.add(surAns.Survey_Answer_Fr__c);
            }
            else{
                returnVal.add(surAns.Survey_Answer__c);
            }
    		
    		answerIndexToScoreMap.put(i,surAns);
    		i++;
            //System.debug('Value *****' + surAns);
    	}
    	//returnVal.sort();
        System.debug('answerIndexToScoreMap *****' + answerIndexToScoreMap);
        System.debug('returnVal *****' + returnVal);
    	 return returnVal;
    }
}