/*******************************************************************************
* Class: QuickBookCustomerWrapper
* Author: 
* Date: 07 May 2018
* 
* Description : QuickBook Customer
*******************************************************************************/
public class QuickBookCustomerWrapper{
    public cls_Customer Customer;
    public class cls_Customer {
        public boolean Taxable;
        public cls_BillAddr BillAddr;
        public String Notes;    //Here are other details.
        public boolean Job;
        public boolean BillWithParent;
        public Integer Balance; //0
        public Integer BalanceWithJobs; //0
        public cls_CurrencyRef CurrencyRef;
        public String PreferredDeliveryMethod;  //Print
        public String domain;   //QBO
        public boolean sparse;
        public String Id;   //60
        public String SyncToken;    //0
        public cls_MetaData MetaData;
        public String Title;    //Mr
        public String GivenName;    //James1
        public String MiddleName;   //B1
        public String FamilyName;   //King1
        public String Suffix;   //Jr1
        public String FullyQualifiedName;   //King's Groceries1
        public String CompanyName;  //King Groceries1
        public String DisplayName;  //King's Groceries1
        public String PrintOnCheckName; //King Groceries1
        public boolean Active;
        public cls_PrimaryEmailAddr PrimaryEmailAddr;
    }
    
    //----------------------------------------------------------------------------
    // Method Name : cls_BillAddr
    // Description : Billing Address Parameters of Customer
    //----------------------------------------------------------------------------     
    
    public class cls_BillAddr {
        public String Id;   //97
        public String Line1;    //ajmer road
        public String City; //Jaipur
        public String Country;  //India
        public String PostalCode;   //302016
    }
    
    //----------------------------------------------------------------------------
    // Method Name : cls_CurrencyRef
    // Description : Currency Parameters of Customer
    //----------------------------------------------------------------------------      
    
    public class cls_CurrencyRef {
        public String value;    //USD
        public String name; //United States Dollar
    }
    
    //----------------------------------------------------------------------------
    // Method Name : cls_MetaData
    // Description : MetaData Parameters of Customer
    //----------------------------------------------------------------------------      
    
    public class cls_MetaData {
        public String CreateTime;   //2018-04-27T05:58:47-07:00
        public String LastUpdatedTime;  //2018-04-27T05:58:47-07:00
    }
    
    //----------------------------------------------------------------------------
    // Method Name : cls_PrimaryEmailAddr
    // Description : Primary Email Address Parameter of Customer
    //----------------------------------------------------------------------------      
    
    public class cls_PrimaryEmailAddr {
        public String Address;  //test@virtuowhiz.com
    }
    
    public static QuickBookCustomerWrapper parse(String json){
        
        return (QuickBookCustomerWrapper) System.JSON.deserialize(json, QuickBookCustomerWrapper.class);
    }

}