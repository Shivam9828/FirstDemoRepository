@isTest(seeAllData = true)
public class SurveysControllerTest {

   static TestMethod void SurveyQuestionsTest(){
        //Survey Insertion
        //
      
       
        SurveyIt__c surv = new SurveyIt__c();
        surv.Name = 'Test Survey';
       	surv.Unique_Name__c = 'Test_Unique_Name';
        insert surv;
        
        //Survey Question Insertion
        List<Survey_Question__c> SURQuestionList = new List<Survey_Question__c>();
        /*Survey_Question__c SURQuestion = new Survey_Question__c();
        SURQuestion.Question__c = 'Test Question';
        SURQuestion.OrderNumber__c = 1;
        SURQuestion.Type__c = 'Single Select--Horizontal';
        SURQuestion.Access__c = true;
        SURQuestion.Automation__c = true;
        SURQuestion.Integration__c = true;
        SURQuestion.Reports__c = true;
        SURQuestion.Tracking__c = true;
        SURQuestion.Tasks_PM__c = true;
        SURQuestion.Required__c = false;
        SURQuestion.Maximum_Score__c = 10;
        SURQuestion.Survey__c = surv.id;
       
        SURQuestionList.add(SURQuestion);*/
       //Multi Select Question
        Survey_Question__c SURQuestion1 = new Survey_Question__c();
        SURQuestion1.Question__c = 'Test Multi-Select--Vertical Question';
        SURQuestion1.OrderNumber__c = 1;
        SURQuestion1.Type__c = 'Multi-Select--Vertical';
        SURQuestion1.Access__c = true;
        SURQuestion1.Automation__c = true;
        SURQuestion1.Integration__c = true;
        SURQuestion1.Reports__c = true;
        SURQuestion1.Tracking__c = true;
        SURQuestion1.Tasks_PM__c = true;
        SURQuestion1.Required__c = false;
        SURQuestion1.Maximum_Score__c = 10;
        SURQuestion1.Is_Parent__c = true;
        SURQuestion1.Is_Skip_Pattern__c = true;
        SURQuestion1.Survey__c = surv.id;
        //SURQuestionList.add(SURQuestion1);
        insert SURQuestion1;
        //Matrix Question
        Survey_Question__c SURQuestion2 = new Survey_Question__c();
        SURQuestion2.Question__c = 'Test Matrix Question';
        SURQuestion2.OrderNumber__c = 1;
        SURQuestion2.Type__c = 'Matrix';
        SURQuestion2.Access__c = true;
        SURQuestion2.Automation__c = true;
        SURQuestion2.Integration__c = true;
        SURQuestion2.Reports__c = true;
        SURQuestion2.Tracking__c = true;
        SURQuestion2.Tasks_PM__c = true;
        SURQuestion2.Required__c = false;
        SURQuestion2.Maximum_Score__c = 10;
        SURQuestion2.Is_Parent__c = true;
        SURQuestion2.Survey__c = surv.id;
       	SURQuestion2.Is_Skip_Pattern__c = true;
        SURQuestion2.Parent_Question__c = SURQuestion1.id;
        //SURQuestionList.add(SURQuestion2);
        insert SURQuestion2;
        //Survey Child Questions
        Survey_Question__c SURQuestion3 = new Survey_Question__c();
        SURQuestion3.Question__c = 'Test Child Single Selcect Questions Question';
        SURQuestion3.OrderNumber__c = 1;
        SURQuestion3.Type__c = 'Single Select--Horizontal';
        SURQuestion3.Access__c = true;
       	SURQuestion3.Survey_Section__c = 'Sales';
        SURQuestion3.Automation__c = true;
        SURQuestion3.Integration__c = true;
        SURQuestion3.Reports__c = true;
        SURQuestion3.Tracking__c = true;
        SURQuestion3.Tasks_PM__c = true;
        SURQuestion3.Required__c = false;
        SURQuestion3.Maximum_Score__c = 10;
        SURQuestion3.Survey__c = surv.id;
        SURQuestion3.Parent_Question__c = SURQuestion2.id;
        insert SURQuestion3;
        Survey_Question__c SURQuestion4 = new Survey_Question__c();
        SURQuestion4.Question__c = 'Test Child Single Selcect Questions Question';
        SURQuestion4.OrderNumber__c = 2;
        SURQuestion4.Type__c = 'Single Select--Horizontal';
        SURQuestion4.Access__c = true;
       	SURQuestion4.Survey_Section__c = 'Sales';
        SURQuestion4.Automation__c = true;
        SURQuestion4.Integration__c = true;
        SURQuestion4.Reports__c = true;
        SURQuestion4.Tracking__c = true;
        SURQuestion4.Tasks_PM__c = true;
        SURQuestion4.Required__c = false;
        SURQuestion4.Maximum_Score__c = 10;
        SURQuestion4.Survey__c = surv.id;
        SURQuestion4.Parent_Question__c = SURQuestion2.id;
        SURQuestionList.add(SURQuestion4);
       	insert SURQuestion4;
       
        //Survey Answer Insertion
        List<Survey_Answer__c> SURAnswerList = new List<Survey_Answer__c>();
        /*Survey_Answer__c SURAnswer = new Survey_Answer__c();
        SURAnswer.Name = 'Test Name';
        SURAnswer.OrderNumber__c = 1;
        SURAnswer.Score__c = 1;
        SURAnswer.Survey_Answer__c = 'Survey Answer Test';
        SURAnswer.Survey_Answer_Fr__c ='Survey Anwser fr Test';
        SURAnswer.Survey_Question__c = SURQuestion.id;
        SURAnswerList.add(SURAnswer);*/
        Survey_Answer__c SURAnswer1 = new Survey_Answer__c();
        SURAnswer1.Name = 'Test Name1';
        SURAnswer1.OrderNumber__c = 2;
        SURAnswer1.Score__c = 2;
        SURAnswer1.Survey_Answer__c = 'Yes';
        SURAnswer1.Survey_Answer_Fr__c ='Oui';
        SURAnswer1.Survey_Question__c = SURQuestion1.id;
        SURAnswerList.add(SURAnswer1);
        Survey_Answer__c SURAnswer1_1 = new Survey_Answer__c();
        SURAnswer1_1.Name = 'Test Name1';
        SURAnswer1_1.OrderNumber__c = 2;
        SURAnswer1_1.Score__c = 2;
        SURAnswer1_1.Survey_Answer__c = 'No';
        SURAnswer1_1.Survey_Answer_Fr__c ='Non';
        SURAnswer1_1.Survey_Question__c = SURQuestion1.id;
        SURAnswerList.add(SURAnswer1_1);
        Survey_Answer__c SURAnswer2 = new Survey_Answer__c();
        SURAnswer2.Name = 'Test Name2';
        SURAnswer2.OrderNumber__c = 1;
        SURAnswer2.Score__c = 1;
        SURAnswer2.Survey_Answer__c = 'Survey Answer Test2';
        SURAnswer2.Survey_Answer_Fr__c ='Survey Anwser fr Test2';
        SURAnswer2.Survey_Question__c = SURQuestion2.id;
        SURAnswerList.add(SURAnswer2);
        Survey_Answer__c SURAnswer2_1 = new Survey_Answer__c();
        SURAnswer2_1.Name = 'Test Name2_1';
        SURAnswer2_1.OrderNumber__c = 2;
        SURAnswer2_1.Score__c = 2;
        SURAnswer2_1.Survey_Answer__c = 'Survey Answer Test2_1';
        SURAnswer2_1.Survey_Answer_Fr__c ='Survey Anwser fr Test2_1';
        SURAnswer2_1.Survey_Question__c = SURQuestion2.id;
        SURAnswerList.add(SURAnswer2_1);
        Survey_Answer__c SURAnswer3 = new Survey_Answer__c();
        SURAnswer3.Name = 'Test Name3';
        SURAnswer3.OrderNumber__c = 2;
        SURAnswer3.Score__c = 2;
        SURAnswer3.Survey_Answer__c = 'Survey Answer Test3';
        SURAnswer3.Survey_Answer_Fr__c ='Survey Anwser fr Test3';
        SURAnswer3.Survey_Question__c = SURQuestion3.id;
        SURAnswerList.add(SURAnswer3);
        Survey_Answer__c SURAnswer3_1 = new Survey_Answer__c();
        SURAnswer3_1.Name = 'Test Name3_1';
        SURAnswer3_1.OrderNumber__c = 2;
        SURAnswer3_1.Score__c = 2;
        SURAnswer3_1.Survey_Answer__c = 'Survey Answer Test3_1';
        SURAnswer3_1.Survey_Answer_Fr__c ='Survey Anwser fr Test3_1';
        SURAnswer3_1.Survey_Question__c = SURQuestion3.id;
        SURAnswerList.add(SURAnswer3_1);
        Survey_Answer__c SURAnswer4 = new Survey_Answer__c();
        SURAnswer4.Name = 'Test Name4';
        SURAnswer4.OrderNumber__c = 2;
        SURAnswer4.Score__c = 2;
        SURAnswer4.Survey_Answer__c = 'Survey Answer Test4';
        SURAnswer4.Survey_Answer_Fr__c ='Survey Anwser fr Test4';
        SURAnswer4.Survey_Question__c = SURQuestion4.id;
        SURAnswerList.add(SURAnswer4);
        insert SURAnswerList;
        
        //Contact Insertion
        Contact con = new Contact();
        con.Firstname = 'Test first name';
        con.LastName = 'Test Last Name';
        con.Email = 'test@gmail.com';
        con.Field_of_Interest__c = 'Marketing';
        con.Phone = '9999999999';
        insert con;
        
        //Survey Taker insert
        SurveyTaker__c SurTaken = new SurveyTaker__c();
        SurTaken.Survey__c = surv.id;
        SurTaken.Contact__c = con.id;
        insert SurTaken;
       
       //lead creation
       Lead led = new Lead();
       led.firstName = 'Test First';
       led.lastName = 'lastName'; 
       led.email = 'test@soljit.com';
       led.Field_of_Interest__c = 'Accounting';
       led.company = 'test Sol';
       led.title = 'test title';
       insert led;
       
       
       Apexpages.currentPage().getParameters().put('name',surv.Unique_Name__c);
       SurveysController STPC = new SurveysController();
       STPC.led.firstName = 'Test First';
       STPC.led.lastName = 'lastName';
       STPC.led.email = 'test@soljit.com';
       STPC.led.Field_of_Interest__c = 'Accounting';
       STPC.led.company = 'test Sol';
       STPC.led.Title = 'test title';
       STPC.init();
        System.debug(' STPC.allQuestions ****' +  STPC.allQuestions[0].selectedOptions);
        STPC.allQuestions[0].selectedOptions.add('1') ;
      	
        STPC.submitResults();
       	STPC.convertResponseToProductivityGain('123214');
    }
}