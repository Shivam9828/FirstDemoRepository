/**************************************************
* Class: SurveysController
* Author: Soljit - SR
* Date: 2018-08-24
* 
* Description: This controller gets all the Survey Questions for the passed Survey and collects the user's response and save them back to atabase and also generates a report using SurveySelfAssessmentReport Page and sends report survey taker.  
*
* V1.0: Initial
* V1.1: 2018-10-27 Inserting Lead instead of Contact
****************************************************/
global virtual class SurveysController {
    public String  qQuestion                      {get; set;}
    public Boolean qRequired                      {get; set;}
    public String  qChoices                       {get; set;}
    public String surveyName                      {get; set;}
    public String surveyHeader                    {get; set;}
    public String surveyId                        {get; set;}   
    public String renderSurveyPreview             {get; set;}  
    public String questionName                    {get; set;}  
    public String questionType                    {get; set;}
    public Boolean questionRequired               {get; set;}
    public List<SelectOption> singleOptions       {get; set;} 
    public List<SurveyQAClass> allQuestions       {get; set;}
    public List<String> responses                 {get; set;}
    public Integer allQuestionsSize               {get; set;}
    public String anonymousAnswer {get;set;}
    public List<SelectOption> anonymousOrUser {get;set;}
    public Boolean isInternal {get;set;}
    public String baseURL {get;set;}
    public String userId{get;set;}
    public String userName{get;set;}
    public String surveyTakerId {get;set;}
    public Boolean thankYouRendered{get;set;}
    public List<String> newOrder {get;set;}
    public Lead led {get;set;}
    public Map<Id, List<Survey_Answer__c>> martixQAs {get; set;}
    public Map<Id, List<Survey_Question__c>> martixQToLevel3QMap {get; set;}
    public Map<Id, List<Survey_Question__c>> parentQuestionToMatrix {get; set;}
    public Map<string, Decimal> sectionToMaxScore {get; set;}
    public Map<string, Decimal> sectionToAttainedScore {get; set;}
    public Map<string, Decimal> sectionToFinalScore {get; set;}
    public String emailId {get;set;}
    public Decimal totalProductivityGain {get;set;}
    
    private Map<string, Map<string, Decimal>> sectionToTypeMaxScore {get;set;}
    private Map<string, Map<string, Decimal>> sectionToTypeAttainedScore {get;set;}
    private Map<String, Decimal> typeToFinalMaxScore {get;set;}
    private Map<String, Decimal> typeToFinalAttainedScore {get;set;}
    private Map<String, Decimal> typeToTotalScore {get;set;}
    private Map<string, List<Survey_Question__c>> sectionToListQuestions {get;set;}
    public SurveyIt__c survey {get;set;}
    public String language {get;set;}
    public PageReference report {get; set;}
    public string pageTitle {get;set;}
    
    /*********************************************************************************************
* 
*  Retrieves the list of questions, the survey name, after retrieving the necessary parameters from the url 
* 
**********************************************************************************************/
    public SurveysController()
    {
        String surveyUniqueName = Apexpages.currentPage().getParameters().get('name');
        language = Apexpages.currentPage().getParameters().get('ln');
        
        if(String.isBlank(language)){
            language = 'en';
        }
        
        if(language == 'en'){
            pageTitle = 'Self-Assessment Digital Transformation | SOLJIT';
        }
        else{
            pageTitle = 'Auto-évaluation virage numérique | SOLJIT';
        }
        
        System.debug('language *******' + language);
        // By default the preview is not showing up
        renderSurveyPreview = 'false';
        led = new Lead();
        
        if(String.isBlank(surveyUniqueName)){
            if(!Test.isRunningTest()){
                Survey_settings__c surveySettings = Survey_settings__c.getInstance('Default');
                surveyName = surveySettings.Survey_Name__c;
            }
            else{
                surveyName = 'Test_Unique_Name';
            }
            
            System.debug('surveyName *****'+ surveyName);
            survey = [SELECT Id, Survey_Header__c FROM SurveyIt__c WHERE Unique_Name__c =: surveyName];
            surveyId = survey.Id;
        }
        else{
            system.debug('ggggggggg');
            if(!String.isEmpty(surveyUniqueName)) {
            survey = [SELECT Id, Survey_Header__c FROM SurveyIt__c WHERE Unique_Name__c =: surveyUniqueName];
            surveyId = survey.Id;
                }
        }
        init();
    }
    
    /*********************************************************************************************
* Init method which initialises the page with Question and Answers
* 
* 
**********************************************************************************************/
    public void init()
    {       
        // Retrieve all necessary information to be displayed on the page
        
        allQuestions = new List<SurveyQAClass>();
        sectionToTypeMaxScore = new Map<string, Map<string, Decimal>>();
        sectionToTypeAttainedScore = new Map<string, Map<string, Decimal>>();
        sectionToListQuestions = new Map<string, List<Survey_Question__c>>();
        typeToFinalMaxScore = new Map<String, Decimal>();
        typeToFinalAttainedScore = new Map<String, Decimal>();
        typeToTotalScore = new Map<String, Decimal>();
        getQuestions();
        anonymousOrUser = new List<SelectOption>();
        
        anonymousOrUser.add(new SelectOption('User','User ' + UserInfo.getFirstName() + ' ' + UserInfo.getLastName()));
        anonymousAnswer = 'Anonymous';
        isInternal =true;
        newOrder = new List<String>();
        String urlBase = URL.getSalesforceBaseUrl().toExternalForm();
        baseURL = urlBase;
        
        userId = UserInfo.getUserId();
        userName = UserInfo.getName();
        
        String profileId = UserInfo.getProfileId();
        try
        {
            Profile p = [select Id, UserType from Profile where Id=:profileId];
            if (p.UserType == 'Guest')
            {
                isInternal = false;
            }
            else
            {
                isInternal = true;
            }
        }
        catch (Exception e){
            isInternal = false;
        }
        thankYouRendered=false;     
    }
    
    
    /********************************************************************************************** 
* 
* Fills up the List of questions to be displayed on the Visualforce page
* 
***********************************************************************************************/   
    private List<SurveyQAClass> getQuestions() {
        sectionToMaxScore = new Map<string, Decimal>();
        
        List<Survey_Question__c> allQuestionsList = 
            [Select  Type__c, Id, Survey__c, Required__c, Question__c,is_Productivity_Gain__c ,
             OrderNumber__c, Name, Choices__c , Parent_Question__c , Survey_Section__c, Maximum_Score__c , Is_Parent__c , Is_Skip_Pattern__c, Parent_Question__r.Parent_Question__c , Access__c, Integration__c, Automation__c, Tracking__c,   Tasks_PM__c, Reports__c, Question_Fr__c 
             From Survey_Question__c
             WHERE Survey__c =: surveyId ORDER BY OrderNumber__c];
        
        allQuestions = new List<SurveyQAClass>();
        Double old_OrderNumber = 0;
        Double new_OrderNumber;
        Double difference = 0;
        
        List<Survey_Answer__c> surveyAnswersList = new List<Survey_Answer__c>([SELECT ID, Survey_Question__r.Type__c,Survey_Question__r.Parent_Question__c, Name, Survey_Answer__c , Survey_Question__c, OrderNumber__c, Score__c,Survey_Answer_Fr__c  FROM Survey_Answer__c WHERE Survey_Question__c IN:allQuestionsList ORDER BY OrderNumber__c]);
        system.debug('handleMatrixQuestions**');
        handleMatrixQuestions(allQuestionsList, surveyAnswersList);
        Map<id, List<Survey_Answer__c>> surveyQuestionToAnswersMap = new Map<id, List<Survey_Answer__c>>();
        
        for(Survey_Answer__c sa : surveyAnswersList){
            if(surveyQuestionToAnswersMap.containsKey(sa.Survey_Question__c)){
                surveyQuestionToAnswersMap.get(sa.Survey_Question__c).add(sa);
            }
            else{
                List<Survey_Answer__c> sAns = new List<Survey_Answer__c>();
                sAns.add(sa);
                surveyQuestionToAnswersMap.put(sa.Survey_Question__c,sAns);
            }
        }
        /* Make sure that the order number follow each other (after deleting a question, orders might not do so) */
        
        Set<Id> consideredQuestions = new Set<Id>();
        
        for (Survey_Question__c q : allQuestionsList){ 
            if(sectionToMaxScore.containsKey(q.Survey_Section__c )){
                sectionToMaxScore.put(q.Survey_Section__c, sectionToMaxScore.get(q.Survey_Section__c) + (q.Maximum_Score__c != null ? q.Maximum_Score__c : 0)); 
            }
            else{
                sectionToMaxScore.put(q.Survey_Section__c, (q.Maximum_Score__c != null ? q.Maximum_Score__c : 0));
            }
            
            // Map which links section and its related Question 
            if(sectionToListQuestions.containsKey(q.Survey_Section__c)){
                sectionToListQuestions.get(q.Survey_Section__c).add(q);
            }
            else{
                List<Survey_Question__c> sQuestions = new List<Survey_Question__c>();
                sQuestions.add(q);
                sectionToListQuestions.put(q.Survey_Section__c, sQuestions);
            }   
            
            sectionToTypeMaxScore = new Map<string, Map<string, Decimal>>();
            System.debug('sectionToListQuestions *****' + sectionToListQuestions);
            // This loop is to link Section and its related Map of Type to Max Scores based on what is checked on Question3
            for(string section : sectionToListQuestions.keySet()){
                List<Survey_Question__c> relatedSQuestions = sectionToListQuestions.get(section);
                Map<string, Decimal> typeToMaxScore = new Map<string, Decimal>();
                for(Survey_Question__c sQuestion : relatedSQuestions){
                    
                    if(sQuestion.Access__c){
                        typeToMaxScore = fillTypeToQuestionsMap(SurveyConstants.ACCESS, sQuestion, typeToMaxScore );
                    }
                    
                    if(sQuestion.Integration__c){
                        typeToMaxScore = fillTypeToQuestionsMap(SurveyConstants.INTEGRATION, sQuestion, typeToMaxScore );
                    }
                    
                    if(sQuestion.Automation__c){
                        typeToMaxScore = fillTypeToQuestionsMap(SurveyConstants.AUTOMATION, sQuestion, typeToMaxScore );
                    }
                    
                    if(sQuestion.Tracking__c){
                        typeToMaxScore = fillTypeToQuestionsMap(SurveyConstants.TRACKING, sQuestion, typeToMaxScore );
                    }
                    
                    if(sQuestion.Tasks_PM__c){
                        typeToMaxScore = fillTypeToQuestionsMap(SurveyConstants.TASKSandPM, sQuestion, typeToMaxScore );
                    }
                    
                    if(sQuestion.Reports__c){
                        typeToMaxScore = fillTypeToQuestionsMap(SurveyConstants.REPORTS, sQuestion, typeToMaxScore );
                    }   
                }
                
                sectionToTypeMaxScore.put(section, typeToMaxScore);
            }
            
            System.debug('sectionToMaxScore ******'  + sectionToMaxScore);
            if(!consideredQuestions.contains(q.id)){
                new_OrderNumber = q.OrderNumber__c;
                difference = new_OrderNumber - old_OrderNumber - 1;
                if (difference > 0) {
                    Double dd = double.valueOf(difference);
                    Integer newOrderInt = dd.intValue();
                    q.OrderNumber__c -= Integer.valueOf(newOrderInt); 
                }
                old_OrderNumber = q.OrderNumber__c;
                SurveyQAClass theQ ; 
                if(q.Parent_Question__c == null){ // These are normal questions
                    
                    if(surveyQuestionToAnswersMap.containsKey(q.id)){
                        theQ = new SurveyQAClass(q, surveyQuestionToAnswersMap.get(q.id), (q.Is_Skip_Pattern__c ? true : false), language);
                    }
                    else{
                        theQ = new SurveyQAClass(q, null, false, language);
                    }
                    allQuestions.add(theQ);
                }
                system.debug('q.Is_Skip_Pattern__c***'+q.Is_Skip_Pattern__c);
                system.debug('parentQuestionToMatrix****'+parentQuestionToMatrix);
                system.debug('parentQuestionToMatrix***'+parentQuestionToMatrix.containsKey(q.Id));
                if(q.Is_Skip_Pattern__c && parentQuestionToMatrix.containsKey(q.Id)){
                    List<Survey_Question__c> relatedMatrixQuestions = parentQuestionToMatrix.get(q.Id);
                    //System.debug('relatedMatrixQuestions ******' + relatedMatrixQuestions); 
                    for(Survey_Question__c matrixQuestion : relatedMatrixQuestions){
                        //System.debug('matrixQuestion ******' + matrixQuestion);
                        consideredQuestions.add(matrixQuestion.Id);
                        if(martixQAs.containsKey(matrixQuestion.id)){
                            SurveyQAClass theMatrixQ = new SurveyQAClass(matrixQuestion,martixQAs.get(matrixQuestion.id), true, language);
                            theQ.childQuestions.add(theMatrixQ);
                            if(martixQToLevel3QMap.containsKey(matrixQuestion.Id)){
                                List<Survey_Question__c> level3SurveyQuestions = martixQToLevel3QMap.get(matrixQuestion.Id);
                                for(Survey_Question__c sQuestion : level3SurveyQuestions){
                                    System.debug('sQuestion ******' + sQuestion.Survey_Section__c);
                                    SurveyQAClass theLevel3ChildQ = new SurveyQAClass(sQuestion, martixQAs.get(sQuestion.Parent_Question__c), true, language);
                                    theMatrixQ.childQuestions.add(theLevel3ChildQ);
                                    consideredQuestions.add(sQuestion.Id);
                                }
                            }
                            
                        } 
                    }
                    
                    //SurveyQAClass theMatrixQ = new SurveyQAClass(allQuestionsList.get(parentQuestionToMatrix.get(q.id)), martixQAs.get(parentQuestionToMatrix.get(q.id)) , true);
                    
                    //List<Survey_Question__c> level3SurveyQuestions = martixQToLevel3QMap.get(parentQuestionToMatrix.get(q.id));
                    /*for(Survey_Question__c sQuestion : level3SurveyQuestions){
SurveyQAClass theLevel3ChildQ = new SurveyQAClass(sQuestion, martixQAs.get(sQuestion.Parent_Question__c), true);
theQ.childQuestions.add(theLevel3ChildQ);
consideredQuestions.add(sQuestion.Id);
}*/
                }
                consideredQuestions.add(q.id);
            }
        }
        
        //
        System.debug('allQuestions *****' + allQuestions);
        allQuestionsSize = allQuestions.size();
        return allQuestions;
    }  
    
    /********************************************************************************************** 
* Forms maps with QuestionTypes to List of Questions
* 
* 
***********************************************************************************************/
    private Map<string, Decimal> fillTypeToQuestionsMap(String typeOfQuestion, Survey_Question__c sQuestion, Map<string, Decimal> typeToMaxScore){
        
        if(typeToMaxScore.containsKey(typeOfQuestion)){
            typeToMaxScore.put(typeOfQuestion, typeToMaxScore.get(typeOfQuestion) + (sQuestion.Maximum_Score__c != null ? sQuestion.Maximum_Score__c : 0)); 
        }
        else{
            typeToMaxScore.put(typeOfQuestion, (sQuestion.Maximum_Score__c != null ? sQuestion.Maximum_Score__c : 0)); 
        }
        
        return typeToMaxScore;
    } 
    
    /********************************************************************************************** 
* Forms maps 
*  parentQuestionToMatrix: map which links the level 1 Questions to Level 2 (Matrix type) Questions 
*  martixQAs: map which is the link between the martix question and the list of all its answers 
*  martixQToLevel3QMap: map which is the link between matrix type question and its related child questions 
*  param: List<Survey_Question__c> allQuestionsList   list of the the questions from database 
*  param: List<Survey_Answer__c> surveyAnswersList  list of all the answers from database
*********************************************************************************************/
    private void handleMatrixQuestions(List<Survey_Question__c> allQuestionsList, List<Survey_Answer__c> surveyAnswersList){
        parentQuestionToMatrix = new Map<Id, List<Survey_Question__c>>();
        martixQAs = new Map<Id, List<Survey_Answer__c>>();
        martixQToLevel3QMap = new Map<Id, List<Survey_Question__c>>();
        for(Survey_Question__c sQuestion : allQuestionsList){
            System.debug('sQuestion.Parent_Question__c ******' + sQuestion.Parent_Question__c);
            System.debug('sQuestion.Type__c ******' + sQuestion.Type__c);
            if(sQuestion.Parent_Question__c != null && sQuestion.Type__c == SurveyConstants.MATRIX_QUES_TYPE){
                if(parentQuestionToMatrix.containsKey(sQuestion.Parent_Question__c)){
                    parentQuestionToMatrix.get(sQuestion.Parent_Question__c).add(sQuestion);
                }
                else{
                    List<Survey_Question__c> sQuestions = new List<Survey_Question__c>();
                    sQuestions.add(sQuestion);
                    parentQuestionToMatrix.put(sQuestion.Parent_Question__c, sQuestions);
                }
            }
        }
        
        for(Survey_Answer__c sAns : surveyAnswersList){
            if(sAns.Survey_Question__r.Type__c == SurveyConstants.MATRIX_QUES_TYPE){
                //parentQuestionToMatrix.put(sAns.Survey_Question__r.Parent_Question__c, sAns.Survey_Question__c);
                if(martixQAs.containsKey(sAns.Survey_Question__c)){
                    martixQAs.get(sAns.Survey_Question__c).add(sAns);
                }
                else{
                    List<Survey_Answer__c> surveyAnswers = new List<Survey_Answer__c>();
                    surveyAnswers.add(sAns);
                    martixQAs.put(sAns.Survey_Question__c, surveyAnswers);
                }
            }
        }
        
        List<Survey_Question__c> level3QuestionsList = new List<Survey_Question__c>();
        for(Survey_Question__c sQuestion : allQuestionsList){
            if(sQuestion.Type__c != SurveyConstants.MATRIX_QUES_TYPE && sQuestion.Parent_Question__c != null){
                level3QuestionsList.add(sQuestion);
            }
        }
        
        
        for(Survey_Question__c sQuestion : level3QuestionsList){
            //System.debug('sQuestion *****' + sQuestion);
            //System.debug('martixQAs.get(sQuestion.id) *****' + martixQAs.get(sQuestion.Parent_Question__c));
            //SurveyQAClass theQ = new SurveyQAClass(sQuestion, martixQAs.get(sQuestion.Parent_Question__c));
            //allQuestions.add(theQ);
            
            if(martixQToLevel3QMap.containsKey(sQuestion.Parent_Question__c)){
                martixQToLevel3QMap.get(sQuestion.Parent_Question__c).add(sQuestion);
            }
            else{
                List<Survey_Question__c> newSQuestionList = new List<Survey_Question__c>();
                newSQuestionList.add(sQuestion);
                martixQToLevel3QMap.put(sQuestion.Parent_Question__c, newSQuestionList);
            }
        }
    }
    
    /********************************************************************************************** 
* 
* This method saves the Survey responses and appropriate scores to Survey Question Response Object
* 
***********************************************************************************************/
    public PageReference submitResults(){
        //TODO: Verify if the Contact details are provided or not, if not show the error message
        if( string.isBlank(led.FirstName) || string.isBlank(led.LastName) || string.isBlank(led.Email)
           || string.isBlank(led.Company) || string.isBlank(led.Field_of_interest__c)){
               Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, (language == 'fr' ? SurveyConstants.FRENCH_ERROR : SurveyConstants.ENGLISH_ERROR)));
               return null;
           }
        
        sectionToAttainedScore = new Map<string, Decimal>();
        sectionToFinalScore = new Map<string, Decimal>();
        typeToFinalMaxScore = new Map<String, Decimal>();
        typeToFinalAttainedScore = new Map<String, Decimal>();
        Set<String> skippedSections = new Set<String>();
        List <SurveyQuestionResponse__c> surveyQuestionResponsesList = new List<SurveyQuestionResponse__c>();
        System.debug('allQuestions ******' + allQuestions);
        List<SurveyQAClass> allQuestionsList = new List<SurveyQAClass>();
        
        for (SurveyQAClass mainQuestion : allQuestions) {
            allQuestionsList.add(mainQuestion);
            
            if(!mainQuestion.childQuestions.isEmpty()){
                for (SurveyQAClass level2Q : mainQuestion.childQuestions) {
                    //allQuestionsList.add(level2Q);
                    if(!level2Q.childQuestions.isEmpty()){
                        for (SurveyQAClass level3Q : level2Q.childQuestions) {
                            allQuestionsList.add(level3Q);
                        }
                    }
                }
            }
        }
        for (SurveyQAClass q : allQuestionsList) {
            System.debug('q *******' +q);
            SurveyQuestionResponse__c sqr = new SurveyQuestionResponse__c();
            if (q.renderSelectRadio == 'true') {
                if (q.required && (q.selectedOption == null || q.selectedOption == '')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, (language == 'fr' ? SurveyConstants.FRENCH_ERROR : SurveyConstants.ENGLISH_ERROR)));
                    return null;
                }
                if (q.selectedOption == null || q.selectedOption == '') {
                    sqr.Response__c = '';
                    sqr.Score__c = 0;
                } 
                else {
                    sqr.Response__c = q.singleOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                    sqr.Score__c = q.answerIndexToScoreMap.get(Integer.valueOf(q.selectedOption)).Score__c;
                    sqr.Survey_Answer__c = q.answerIndexToScoreMap.get(Integer.valueOf(q.selectedOption)).id;
                }
                sqr.Survey_Question__c = q.Id;
                surveyQuestionResponsesList.add(sqr);
            } 
            else if (q.renderFreeText == 'true') {            
                if (q.required && q.freeTextArea == '') {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, (language == 'fr' ? SurveyConstants.FRENCH_ERROR : SurveyConstants.ENGLISH_ERROR)));
                    return null;
                }
                System.debug('*****Select Radio ' + q.freeTextArea);
                sqr.Response__c = q.freeTextArea;
                sqr.Survey_Question__c = q.Id;
                surveyQuestionResponsesList.add(sqr);
            }
            else if (q.renderSelectCheckboxes == 'true') {
                if (q.required && (q.selectedOptions == null || q.selectedOptions.size() == 0)){
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, (language == 'fr' ? SurveyConstants.FRENCH_ERROR : SurveyConstants.ENGLISH_ERROR)));
                    return null;
                }
                Map<string,MultiOpsWrapper> Options = new Map<string,MultiOpsWrapper>();
                
                sqr = new SurveyQuestionResponse__c();
                
                for (String opt : q.selectedOptions) {
                    
                    
                    if (opt == '' || opt == null) {
                        sqr.Response__c = '';
                        sqr.Score__c = 0;
                    } else {
                        sqr.Response__c = q.multiOptions.get(Integer.valueOf(opt)).getLabel();
                        sqr.Score__c = q.answerIndexToScoreMap.get(Integer.valueOf(opt)).Score__c;
                    }
                    sqr.Survey_Question__c = q.Id;
                    
                    SYstem.debug('Options ****' + Options);
                    if((sqr.Response__c == SurveyConstants.YES || sqr.Response__c == SurveyConstants.OUI)){
                        //surveyQuestionResponsesList.add(sqr);
                        MultiOpsWrapper mOps = new MultiOpsWrapper(sqr.Score__c, sqr.Response__c,q.answerIndexToScoreMap.get(Integer.valueOf(opt)).id);
                        Options.put(sqr.Response__c, mOps);
                        
                        System.debug('sqr.Response__c****' + sqr.Response__c);
                    }
                    if((sqr.Response__c == SurveyConstants.NO || sqr.Response__c == SurveyConstants.NON )){
                        //
                        MultiOpsWrapper mOps = new MultiOpsWrapper(sqr.Score__c, sqr.Response__c, q.answerIndexToScoreMap.get(Integer.valueOf(opt)).id);
                        Options.put(sqr.Response__c, mOps);
                        
                        System.debug('sqr.Response__c****' + sqr.Response__c);
                    }       
                }
                
                
                sqr.Survey_Question__c = q.Id;
                
                if(Options.containsKey((language == 'fr' ? SurveyConstants.NON : SurveyConstants.NO))){
                    sqr.Response__c = Options.get((language == 'fr' ? SurveyConstants.NON : SurveyConstants.NO)).response;
                    sqr.Score__c =  Options.get((language == 'fr' ? SurveyConstants.NON : SurveyConstants.NO)).score;
                    sqr.Survey_Answer__c = Options.get((language == 'fr' ? SurveyConstants.NON : SurveyConstants.NO)).sAnswer;
                }
                else if(Options.containsKey((language == 'fr' ? SurveyConstants.OUI : SurveyConstants.Yes))){
                    
                    sqr.Response__c = Options.get((language == 'fr' ? SurveyConstants.OUI : SurveyConstants.YES)).response;
                    sqr.Score__c =  Options.get((language == 'fr' ? SurveyConstants.OUI : SurveyConstants.YES)).score;
                    sqr.Survey_Answer__c = Options.get((language == 'fr' ? SurveyConstants.OUI : SurveyConstants.YES)).sAnswer;
                }
                System.debug('sqr *****' + sqr);
                
                surveyQuestionResponsesList.add(sqr);
                
                if(q.sQuestion.Is_Skip_Pattern__c && sqr.Response__c == '' || sqr.Response__c == (language == 'fr' ? SurveyConstants.NON : SurveyConstants.NO)){
                    skippedSections.add(q.sQuestion.Survey_Section__c );
                }
            } 
            else if (q.renderSelectRow == 'true') {
                if (q.required && (q.selectedOption == null || q.selectedOption == '')) {
                    Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, (language == 'fr' ? SurveyConstants.FRENCH_ERROR : SurveyConstants.ENGLISH_ERROR)));
                    return null;
                }                    
                if (q.selectedOption == null || q.selectedOption == '') {
                    sqr.Response__c = '';
                    sqr.Score__c = 0;
                } 
                else {
                    if(q.skipQuestion){ // As we dont show labels for skip questions we get the values from initially formed map 
                        sqr.Response__c = q.mapIndexToOptionValue.get(string.valueOf(q.selectedOption));
                    }
                    else{
                        sqr.Response__c = q.rowOptions.get(Integer.valueOf(q.selectedOption)).getLabel();
                    }
                    
                    sqr.Score__c = q.answerIndexToScoreMap.get(Integer.valueOf(q.selectedOption)).Score__c;
                    sqr.Survey_Answer__c = q.answerIndexToScoreMap.get(Integer.valueOf(q.selectedOption)).id;
                }
                sqr.Survey_Question__c = q.Id;
                if(String.isNotBlank(sqr.Response__c)){
                    if(sectionToAttainedScore.containsKey(q.sQuestion.Survey_Section__c )){
                        sectionToAttainedScore.put(q.sQuestion.Survey_Section__c, sectionToAttainedScore.get(q.sQuestion.Survey_Section__c) + (sqr.Score__c != null ? sqr.Score__c : 0)); 
                    }
                    else{
                        sectionToAttainedScore.put(q.sQuestion.Survey_Section__c, (sqr.Score__c != null ? sqr.Score__c : 0));
                    }                    
                    surveyQuestionResponsesList.add(sqr);
                }
            }
        }
        
        if( string.isBlank(led.FirstName) || string.isBlank(led.LastName) || string.isBlank(led.Email) || string.isBlank(led.Field_of_Interest__c) || string.isBlank(led.Company)){
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, language == 'en' ? SurveyConstants.ENGLISH_ERROR : SurveyConstants.FRENCH_ERROR));
            return null;
        }
        
        Id leadId; 
        Id contactId; 
        
        Contact contact = new Contact();
        Lead lead = new Lead();
        
        //Get the Contact based on the info provided from the Survey, If Contact exists use the Contact
        List<Contact> ExistingContact = new List<Contact>([SELECT Id, FirstName, LastName, Email, Phone, Survey_Completed_SA__c, Language__c
                                                           FROM Contact WHERE (FirstName =: led.FirstName AND Email =: led.Email AND LastName =:led.LastName) OR
                                                           (FirstName =: led.FirstName AND Phone =: led.Phone AND LastName =:led.LastName) 
                                                           Order by CreatedDate DESC]);
        if(ExistingContact.size() > 0){
            contactId = ExistingContact[0].id;
            contact = ExistingContact[0];
            contact.Survey_Completed_SA__c = 'Yes';
            if(language == 'en'){
                contact.Language__c = SurveyConstants.ENGLISH_LANGUAGE;
            }
            else{
                contact.Language__c = SurveyConstants.FRENCH_LANGUAGE;
            }
            UPDATE contact;
        }else{
            //As the matched Contact not found, Get the Lead based on the info provided from the Survey
            List<Lead> ExistingLead = new List<Lead>([SELECT Id, Title, IsConverted, ConvertedContactId, ConvertedContact.Name,Company, Name, 
                                                      FirstName, LastName, Email, Phone, Survey_Completed_SA__c, Language__c FROM Lead WHERE 
                                                      IsConverted = false AND
                                                      ((FirstName =: led.FirstName AND Email =: led.Email AND LastName =:led.LastName) OR
                                                      (FirstName =: led.FirstName AND Title =: led.Title AND LastName =:led.LastName AND Company =: led.Company) OR
                                                      (FirstName =: led.FirstName AND Phone =: led.Phone AND LastName =:led.LastName AND Company =: led.Company) OR
                                                      (FirstName =: led.FirstName AND Title =: led.Title AND LastName =:led.LastName AND Email =: led.Email) OR
                                                      (FirstName =: led.FirstName AND Phone =: led.Phone AND LastName =:led.LastName) )
                                                      Order by Createddate desc]);
            System.debug('ExistingLead *****' + ExistingLead);
            if(ExistingLead.Size() > 0){

                lead = ExistingLead[0];
                 leadId = lead.Id; 
                lead.Survey_Completed_SA__c = 'Yes';
                if(language == 'en'){
                    lead.Language__c = SurveyConstants.ENGLISH_LANGUAGE;
                }
                else{
                    lead.Language__c = SurveyConstants.FRENCH_LANGUAGE;
                }
                UPDATE lead;                
            }
            else{
                //If Lead not exists create a lead - ByPass the duplicate rule for safer side to allow the Survey to complete
                led.Survey_Completed_SA__c = 'Yes';
                led.LeadSource = 'Self-Assessment survey';
                if(language == 'en'){
                    led.Language__c = SurveyConstants.ENGLISH_LANGUAGE;
                }
                else{
                    led.Language__c = SurveyConstants.FRENCH_LANGUAGE;
                }
                //INSERT LEAD and bypass the duplicate rule
                Database.SaveResult sr = Database.insert(led, false);
                if (!sr.isSuccess()) {                
                    // Insertion failed due to duplicate detected
                    for(Database.Error duplicateError : sr.getErrors()){
                        Datacloud.DuplicateResult duplicateResult = 
                            ((Database.DuplicateError)duplicateError).getDuplicateResult();
                        System.debug('Duplicate records have been detected by ' + 
                                     duplicateResult.getDuplicateRule());
                        System.debug(duplicateResult.getErrorMessage());
                    }
                    // If the duplicate rule is an alert rule, we can try to bypass it
                    Database.DMLOptions dml = new Database.DMLOptions(); 
                    dml.DuplicateRuleHeader.AllowSave = true;
                    Database.SaveResult sr2 = Database.insert(led, dml);
                    if (sr2.isSuccess()) {
                        System.debug('Duplicate Lead has been inserted in Salesforce!');
                    }
                }            
                lead = led;
                leadId = led.Id;                                
            }            
        }
        System.debug('leadId *****' + leadId);
        SurveyTaker__c st = new SurveyTaker__c();
        st.Survey__c = surveyId;
        st.User__c = userId;
        System.debug('contactId ******' + contactId);
        st.contact__c = contactId;
        st.Lead__c = leadId;
        insert st;
        surveyTakerId = st.Id;
        
        
        for (SurveyQuestionResponse__c sQuesResp : surveyQuestionResponsesList){
            sQuesResp.SurveyTaker__c = surveyTakerId;
        }
        insert surveyQuestionResponsesList;
        
        system.debug('surveyQuestionResponsesList'+surveyQuestionResponsesList);                    
        
        System.debug('skippedSections ******' + skippedSections);
        for(String section : skippedSections){
            if(sectionToAttainedScore.containsKey(section)){
                sectionToAttainedScore.remove(section);
            }
            if(sectionToMaxScore.containsKey(section)){
                sectionToMaxScore.remove(section);
            }
            
            // Remove skipped sections for Type Score calculations
            if(sectionToTypeMaxScore.containsKey(section)){
                sectionToTypeMaxScore.remove(section);
            }
        }
        sectionToMaxScore.remove(null);
        sectionToAttainedScore.remove(null);
        System.debug('sectionToMaxScore *****' + sectionToMaxScore);
        System.debug('sectionToAttainedScore *****' + sectionToAttainedScore);
        createTypeScores(surveyQuestionResponsesList); // Caculate Access, Integration etc types scores and find average percentages 
        thankYouRendered=true;
        return calculateFinalScoreAndSendAssessmentReport(sectionToMaxScore, sectionToAttainedScore, contact, lead);
        
        
        //return null;
    }
    /*********************************************************************************************
* 
* 
* 
**********************************************************************************************/
    /*private Boolean AddSurveyTaker(){
String userId;
if (surveyId == null){
return false;
}

//if(contactId.toUpperCase() =='NONE'|| contactId.length()<5)
//contactId = null;         
if (anonymousAnswer != 'Anonymous'){
userId = UserInfo.getUserId();
}
else{
userId = null;
}
if(anonymousAnswer != 'Anonymous'){
List<SurveyTaker__c> check = [Select Contact__c, SurveyIt__c, Case__c, User__c From SurveyTaker__c 
Where Contact__c=:contactId and SurveyIt__c=:surveyId and User__c=:UserId];
if(check != null && check.size()>0){
Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.LABS_SF_You_have_already_taken_this_survey));
return false;       
}
}

return true;    
}
*/
    
    public void sendEmailToUser(Contact con, Lead lead, Blob attachment){
        /* List<string> mail = new List<string>();
mail.add(con.email); */
        //custom Settings
        System.debug('lead ******' + lead);
        List<string> TOEmailIDS = new List<string>();
        string EmailIDs;
        
        if(!TEst.isRunningTest()){
            Survey_Settings__c SS = Survey_Settings__c.getInstance('Default');
            if(string.isNotBlank(SS.EmailID__c)){
                 EmailIDs = SS.EmailID__c;
            }
            else{
                 EmailIDs = 'test@soljit.com';
            }
           
        }
        else{
            EmailIDs = 'test@soljit.com';
        }
        
        List<string> spiltedEmailIDs = new List<string>();
        spiltedEmailIDs = EmailIDs.split(';');
        EmailTemplate eTempCont = [select id, HtmlValue from EmailTemplate Where DeveloperName = 'Survey_Completed_Contact_Details_to_User'];
        EmailTemplate eTempLead = [select id, HtmlValue from EmailTemplate Where DeveloperName = 'Survey_Completed_Lead_Details_to_User'];
        List<Messaging.SingleEmailMessage> Mails = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage SendEmail = new Messaging.SingleEmailMessage();
        SendEmail.setToAddresses(spiltedEmailIDs);
        
        if(con.id != null){
            SendEmail.setTemplateId(eTempCont.Id);
            SendEmail.setTargetObjectId(con.id);
        }
        else{
            SendEmail.setTemplateId(eTempLead.Id);
            SendEmail.setTargetObjectId(lead.id);
            System.debug('In lead else');
        } 
        SendEmail.setTreatTargetObjectAsRecipient(false);
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        //System.debug('attach.name ' + attachment.Name);
        if(language == 'fr'){
            efa.setFileName('SOLJIT - Auto Évaluation Virage Numérique.pdf');
        }
        else{
            efa.setFileName('SOLJIT - Self Assessment Digital Transformation.pdf');
        }
        
        //Blob b = attachment.Body;
        efa.setBody(attachment);
        SendEmail.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        
        Mails.add(SendEmail);
        Messaging.sendEmail(Mails);
        
        
    }
    
    /*********************************************************************************************
* 
* Map<string, Map<string, Decimal>> sectionToTypeAttainedScore
* paran surveyResponses : all Inserted responses
**********************************************************************************************/
    
    private void createTypeScores(List<SurveyQuestionResponse__c> surveyResponses){
        System.debug('createTypeScores ******');
        List<SurveyQuestionResponse__c> latestSurveyResponses = new List<SurveyQuestionResponse__c> ([SELECT id, Name, Survey_Answer__c, Survey_Answer__r.Score__c, Score__c, Survey_Question__c, Survey_Question__r.Access__c, 
                                                                                                      Survey_Question__r.Automation__c, Survey_Question__r.Integration__c, Survey_Question__r.Reports__c, Survey_Question__r.Tasks_PM__c, Survey_Question__r.Tracking__c, Survey_Question__r.Survey_Section__c,Survey_Question__r.is_Productivity_Gain__c,Response__c  FROM SurveyQuestionResponse__c WHERE ID In:surveyResponses ]);
        Map<string, List<SurveyQuestionResponse__c>> sectionToResponsesMap = new Map<string, List<SurveyQuestionResponse__c>>();
        for(SurveyQuestionResponse__c sResponse : latestSurveyResponses){
            if(sectionToResponsesMap.containsKey(sResponse.Survey_Question__r.Survey_Section__c)){
                sectionToResponsesMap.get(sResponse.Survey_Question__r.Survey_Section__c).add(sResponse);
            }
            else{
                List<SurveyQuestionResponse__c> sQuestionResponses = new List<SurveyQuestionResponse__c>();
                sQuestionResponses.add(sResponse);
                sectionToResponsesMap.put(sResponse.Survey_Question__r.Survey_Section__c, sQuestionResponses);
            }
        }
        
        System.debug('sectionToResponsesMap ******' + sectionToResponsesMap);
        for(string section : sectionToResponsesMap.keySet()){
            
            List<SurveyQuestionResponse__c> relatedResponses = sectionToResponsesMap.get(section);
            Map<string, Decimal> typeToAttainedScoreMap = new Map<string, Decimal>();
            for(SurveyQuestionResponse__c sQuestionsResponse : relatedResponses){
                if(sQuestionsResponse.Survey_Question__r.Access__c){
                    if(typeToAttainedScoreMap.containsKey(SurveyConstants.ACCESS)){
                        typeToAttainedScoreMap.put(SurveyConstants.ACCESS, typeToAttainedScoreMap.get(SurveyConstants.ACCESS) + (sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0));
                    }
                    else{
                        typeToAttainedScoreMap.put(SurveyConstants.ACCESS, sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0);
                    }
                }
                
                if(sQuestionsResponse.Survey_Question__r.Integration__c){
                    if(typeToAttainedScoreMap.containsKey(SurveyConstants.INTEGRATION)){
                        typeToAttainedScoreMap.put(SurveyConstants.INTEGRATION, typeToAttainedScoreMap.get(SurveyConstants.INTEGRATION) + (sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0));
                    }
                    else{
                        typeToAttainedScoreMap.put(SurveyConstants.INTEGRATION, sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0);
                    }
                }
                
                if(sQuestionsResponse.Survey_Question__r.Automation__c){
                    if(typeToAttainedScoreMap.containsKey(SurveyConstants.AUTOMATION)){
                        typeToAttainedScoreMap.put(SurveyConstants.AUTOMATION, typeToAttainedScoreMap.get(SurveyConstants.AUTOMATION) + (sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0));
                    }
                    else{
                        typeToAttainedScoreMap.put(SurveyConstants.AUTOMATION, sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0);
                    }
                }
                
                if(sQuestionsResponse.Survey_Question__r.Tracking__c){
                    if(typeToAttainedScoreMap.containsKey(SurveyConstants.TRACKING)){
                        typeToAttainedScoreMap.put(SurveyConstants.TRACKING, typeToAttainedScoreMap.get(SurveyConstants.TRACKING) + (sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0));
                    }
                    else{
                        typeToAttainedScoreMap.put(SurveyConstants.TRACKING, sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0);
                    }
                }
                
                if(sQuestionsResponse.Survey_Question__r.Tasks_PM__c){
                    if(typeToAttainedScoreMap.containsKey(SurveyConstants.TASKSandPM)){
                        typeToAttainedScoreMap.put(SurveyConstants.TASKSandPM, typeToAttainedScoreMap.get(SurveyConstants.TASKSandPM) + (sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0));
                    }
                    else{
                        typeToAttainedScoreMap.put(SurveyConstants.TASKSandPM, sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0);
                    }
                }
                
                if(sQuestionsResponse.Survey_Question__r.Reports__c){
                    if(typeToAttainedScoreMap.containsKey(SurveyConstants.REPORTS)){
                        typeToAttainedScoreMap.put(SurveyConstants.REPORTS, typeToAttainedScoreMap.get(SurveyConstants.REPORTS) + (sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0));
                    }
                    else{
                        typeToAttainedScoreMap.put(SurveyConstants.REPORTS, sQuestionsResponse.Score__c != null ? sQuestionsResponse.Score__c : 0);
                    }
                }   
            }
            
            sectionToTypeAttainedScore.put(section, typeToAttainedScoreMap);
        }
        
        System.debug('sectionToTypeAttainedScore ******' + sectionToTypeAttainedScore);
        calculateFinalTypeScores();
        calculateProductivityGains(latestSurveyResponses); // Calculate productivity gain 
    }
    
    /*********************************************************************************************
*  private Map<String, Decimal> typeToFinalMaxScore {get;set;}
*  private Map<String, Decimal> typeToFinalAttainedScore {get;set;}
* 
* 
**********************************************************************************************/
    private void calculateFinalTypeScores(){
        System.debug('sectionToTypeMaxScore ******' + sectionToTypeMaxScore);
        for(string section: sectionToTypeMaxScore.keySet()){
            Map<string, Decimal> typeToScoreMap = sectionToTypeMaxScore.get(section);
            System.debug('typeToScoreMap *****' + typeToScoreMap);
            for(String typeOfQuestion : typeToScoreMap.keySet() ){
                if(typeOfQuestion == SurveyConstants.ACCESS || typeOfQuestion == SurveyConstants.INTEGRATION || typeOfQuestion == SurveyConstants.AUTOMATION || typeOfQuestion == SurveyConstants.TRACKING || typeOfQuestion == SurveyConstants.TASKSandPM || typeOfQuestion == SurveyConstants.REPORTS){
                    addScoreToMaps(typeToFinalMaxScore, typeOfQuestion, typeToScoreMap.get(typeOfQuestion));
                }
            }
        }
        
        for(string section: sectionToTypeAttainedScore.keySet()){
            Map<string, Decimal> typeToScoreMap = sectionToTypeAttainedScore.get(section);
            for(String typeOfQuestion : typeToScoreMap.keySet() ){
                if(typeOfQuestion == SurveyConstants.ACCESS || typeOfQuestion == SurveyConstants.INTEGRATION || typeOfQuestion == SurveyConstants.AUTOMATION || typeOfQuestion == SurveyConstants.TRACKING || typeOfQuestion == SurveyConstants.TASKSandPM || typeOfQuestion == SurveyConstants.REPORTS){
                    addScoreToMaps(typeToFinalAttainedScore, typeOfQuestion, typeToScoreMap.get(typeOfQuestion));
                }
            }
        }
        System.debug('typeToFinalMaxScore ******' + typeToFinalMaxScore);
        System.debug('typeToFinalAttainedScore ******' + typeToFinalAttainedScore);
        for(string typeOfQuestion : typeToFinalMaxScore.keySet()){
            Decimal maxScore = 0;
            Decimal attinedScore = 0;
            Decimal totalScore = 0;
            maxScore = typeToFinalMaxScore.get(typeOfQuestion);
            attinedScore = typeToFinalAttainedScore.get(typeOfQuestion);
            System.debug('maxScore***** '+maxScore);
            if(attinedScore != null){
                totalScore = attinedScore/maxScore;
                totalScore = totalScore.setScale(2);
                totalScore = totalScore * 100;
            }
            typeToTotalScore.put(typeOfQuestion, totalScore);
        }
        
        System.debug('typeToTotalScore ******' + typeToTotalScore);
    }
    
    /*********************************************************************************************
*  Helper method which adds scores to maps 
*  param typeToScoreMap: To which map we need to add passed score
*  param typeOfQuestion : What is the type to which to score has to be added like access, integration, HR etc.. 
*  param score: Actuall score which has to be added
**********************************************************************************************/
    private void addScoreToMaps(Map<String, Decimal> typeToScoreMap, String typeOfQuestion, Decimal score ){
        System.debug('typeOfQuestion *****' + typeOfQuestion);
        System.debug('typeToScoreMap ******' + typeToScoreMap);
        if(typeToScoreMap.containsKey(typeOfQuestion)){
            typeToScoreMap.put(typeOfQuestion, typeToScoreMap.get(typeOfQuestion)+score); 
        }
        else{
            typeToScoreMap.put(typeOfQuestion,score); 
        }
    }
    
    /*********************************************************************************************
*  Calculate Productivity gain 
*  param surveyResponses : List of all the responses
* 
**********************************************************************************************/
    private void calculateProductivityGains(List<SurveyQuestionResponse__c> surveyResponses){
        totalProductivityGain = 0;
        System.debug('surveyResponses ******' + surveyResponses);
        for(SurveyQuestionResponse__c sQuesResponse : surveyResponses){
            if(sQuesResponse.Survey_Question__r.is_Productivity_Gain__c){
                System.debug('sQuesResponse.Response__c *****' + sQuesResponse.Response__c);
                totalProductivityGain += convertResponseToProductivityGain(sQuesResponse.Response__c);
            }
        }
        System.debug('final totalProductivityGain' + totalProductivityGain);
    }
    
    /*********************************************************************************************
*  Helper method which converts response for productity gains
*  param productivityGain : Response is same as Productivity Gain, so we need to convert strimg response to decimal to find 
*  sum
* 
**********************************************************************************************/
    @TestVisible
    private Decimal convertResponseToProductivityGain(String productivityGain){
        Decimal productivityGainNum = 0;
        String numericPGain = '0';
        integer strLength = productivityGain.length();
        for(integer i =0;i<productivityGain.length();i++){
            String s= productivityGain.mid(i,1);
            if(s.isNumeric()){
                numericPGain +=s;
                
            }
        }
        productivityGainNum = Decimal.valueOf(numericPGain);
        return productivityGainNum;
    }
    
    /*********************************************************************************************
* 
* Redirects user to Thank You page
* 
**********************************************************************************************/
    private PageReference redirectToThankYou(){
        Pagereference thankYou = Page.SurveyThankYouPage;
        thankYou.getParameters().put('ln', language);
        thankYou.setRedirect(true);
        
        return thankYou;
    }
    
    /********************************************************************************************
* This method gets all the responses and calculates the final score percents which are used forgenerating Self Assessment report
* param: Map<string, Decimal> sectionToMaxScore:  This map forms link between each section and its questions sum of Max scores, 
* param: Map<string, Decimal> sectionToAttainedScore : This map forms link between each section and its questions sum of Attained (based on survey taker input) scores. 
*********************************************************************************************/
    private pageReference  calculateFinalScoreAndSendAssessmentReport(Map<string, Decimal> sectionToMaxScore, Map<string, Decimal> sectionToAttainedScore, Contact contact, Lead lead){
        sectionToFinalScore = new Map<string, Decimal>();
        for(String sectionMax: sectionToMaxScore.keyset()){
            System.debug('sectionMax *****' + sectionMax);
            Decimal sectionMaxScore = (sectionToMaxScore.containsKey(sectionMax) ? sectionToMaxScore.get(sectionMax) : 0);
            System.debug('sectionMaxScore *****' + sectionMaxScore);
            if(sectionMaxScore == 0){
                sectionMaxScore = 1;
            }
            Decimal sectionAttainedScore = (sectionToAttainedScore.containsKey(sectionMax) ? sectionToAttainedScore.get(sectionMax) : 0);
            System.debug('sectionAttainedScore *****' + sectionAttainedScore);
            Decimal calValue = sectionAttainedScore/ sectionMaxScore; 
            calValue = calValue.setScale(2);
            Decimal finalCalculatedVal = (calValue * 100);
            SYstem.debug('finalCalculatedVal ******' + finalCalculatedVal);
            sectionToFinalScore.put(sectionMax, finalCalculatedVal);
        }
        System.debug('sectionToMaxScore *****' + sectionToMaxScore);
        System.debug('sectionToAttainedScore *****' + sectionToAttainedScore);
        
        System.debug('sectionToFinalScore *****' + sectionToFinalScore);
        
        PageReference report = Page.SurveySelfAssessmentReport;
        
        for(String sectionMax: sectionToFinalScore.keyset()){
            report.getParameters().put(sectionMax, String.valueOf(sectionToFinalScore.get(sectionMax)));
        }
        report.getParameters().put('Overall', getOverallScore(sectionToMaxScore, sectionToAttainedScore));
        
        for(String typeMaxScore : typeToTotalScore.keyset()){
            report.getParameters().put(typeMaxScore, String.valueOf(typeToTotalScore.get(typeMaxScore)));
        }
        
        report.getParameters().put('ProductivityGain', String.valueOf(totalProductivityGain));
        
        report.getParameters().put('ln', language);
        // return report;
        Attachment attachment = new Attachment();
        attachment.name = 'Self Assessment Report.pdf';
        
        
        if(!Test.isRunningTest()){
            attachment.body = report.getContentAsPDF();
        }
        else{
            attachment.body = Blob.valueOf('test');
        }
        
        if(contact.id != null){
            attachment.parentId = contact.Id;
        }
        else{
            attachment.parentId = lead.Id;
        }
        insert attachment;
        
        
        List<String> toaddresses = new List<String>();
        toaddresses.add(led.Email);
        String templateName;
        if(language == 'fr'){
            templateName = SurveyConstants.SELF_ASSES_TEMPLATE_FR;
        }
        else{
            templateName = SurveyConstants.SELF_ASSES_TEMPLATE_EN;
        }
        
        EmailTemplate eTemp = new EmailTemplate ();
        eTemp = [select id, HtmlValue, Subject, Body from EmailTemplate Where DeveloperName =: templateName];
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setSubject(eTemp.Subject);
        email.setToAddresses( toaddresses );
        
        String firstName = '';
        if(String.isNotBlank(contact.firstName)){
            firstName = contact.firstName;
        }
        else if(String.isNotBlank(lead.firstName)){
            firstName = lead.firstName;
        }
        
        if(string.isBlank(eTemp.body))
            email.setPlainTextBody( 'Hello '+ firstName +', Please find the attached PDF' );
        else
            email.setPlainTextBody(eTemp.Body);
        System.debug('survey ******' + survey);
        
        email.setHTMLBody(eTemp.HtmlValue.replace('{!Contact.FirstName}', firstName)); // add Name and Thankyou signature
        
        Blob b;
        if(!Test.isRunningTest()){
            b = report.getContentAsPDF();
        }
        else{
            b = Blob.valueOf('test');
        }
        
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        //System.debug('attach.name ' + attachment.Name);
        if(language == 'fr'){
            efa.setFileName(SurveyConstants.PDF_FR_FILENAME);
        }
        else{
            efa.setFileName(SurveyConstants.PDF_EN_FILENAME);
        }
        
        efa.setBody(b);
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});
        
        // Sends the email
        Messaging.SendEmailResult [] results = 
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email}); 
        System.debug('lead ******' + lead);
        sendEmailToUser(contact,lead, b);
        return redirectToThankYou();
        //return report;
    }
    
    /********************************************************************************************
* Calculate the overall score based in the Max and attained scores
* param sectionToMaxScore: Map which gathers section to Max score
* param sectionToFinalScore Map which gathers section to Final score
*********************************************************************************************/
    public string getOverallScore (Map<string, Decimal> sectionToMaxScore, Map<string, Decimal> sectionToFinalScore){
        Decimal maxScoreTotal = 0;
        Decimal attainedScoreTotal = 0;
        
        for(Decimal maxScore : sectionToMaxScore.values()){
            maxScoreTotal += maxScore;
        }
        
        System.debug('maxScoreTotal ******' + maxScoreTotal);
        for(Decimal finalScore : sectionToFinalScore.values()){
            attainedScoreTotal += finalScore;
        }
        
        System.debug('attainedScoreTotal ******' + attainedScoreTotal);
        Decimal overallScore = (attainedScoreTotal/maxScoreTotal); 
        overallScore = overallScore.setScale(2);
        
        System.debug('overallScore *****' + overallScore);
        
        String finalOverAllPercent = string.valueof(Integer.valueOf(overallScore * 100)); 
        
        System.debug('finalOverAllPercent *****'  + finalOverAllPercent);
        
        return finalOverAllPercent;
    }
    
    /*********************************************************************************************
*  A helper method which shows/hides the martix child questions based on user input from page. 
**********************************************************************************************/
    public void showChildQuestions(){
        //System.debug(ApexPages.currentPage().getParameters().get('selectedQuestion'));
        //System.debug(ApexPages.currentPage().getParameters().get('selectedOption'));
        Id questionId = Id.valueOf(ApexPages.currentPage().getParameters().get('selectedQuestion'));
        //String selectedOption = ApexPages.currentPage().getParameters().get('selectedOption');
        string isShow;
        for(SurveyQAClass level1Q : allQuestions){
            if(level1Q.id == questionId){
                for (String opt : level1Q.selectedOptions) {
                    if (opt == '' || opt == null) {
                        isShow = (language == 'fr' ? SurveyConstants.NON : SurveyConstants.NO);
                    } 
                    else {
                        isShow = level1Q.multiOptions.get(Integer.valueOf(opt)).getLabel();
                    }
                }
                for(SurveyQAClass level2Q : level1Q.childQuestions){
                    level2Q.isShow = (isShow == (language == 'fr' ? SurveyConstants.OUI : SurveyConstants.YES) ? true : false);
                    if(isShow == (language == 'fr' ? SurveyConstants.NON : SurveyConstants.NO)){
                        System.debug('level2Q.childQuestions ******' + level2Q.childQuestions);
                        for(SurveyQAClass level3Q : level2Q.childQuestions){
                            System.debug('level3Q.selectedOption 8888'+level3Q.selectedOption);
                            level3Q.selectedOption = null;
                        }
                    }
                }
            }
        }
    }
    
    public class MultiOpsWrapper{
        public Decimal score{get;set;}
        public string response {get;set;}
        public Id sAnswer {get;set;}
        
        public MultiOpsWrapper(Decimal score, string response, Id sAnswer){
            this.score = score;
            this.response = response;
            this.sAnswer = sAnswer;
        }
    }
}