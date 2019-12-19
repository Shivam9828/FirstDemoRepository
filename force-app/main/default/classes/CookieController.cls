public class CookieController {
    
    public static pageReference CookieControllerfun(){
        Cookie RecordId = ApexPages.currentPage().getCookies().get('xgaxccacx');
        if(RecordId != null && RecordId.getValue() != ''){
           return null;
        }else{
            pageReference pageRef = new pageReference('/apex/login_account');
            pageRef.setRedirect(true);
            return pageRef;
        }
    }
    
    
    public pageReference logoutFunction(){	
       
        Cookie RecordId = new Cookie('xgaxccacx','',null,0,true);
        ApexPages.currentPage().setCookies(new Cookie[]{RecordId});
        pageReference pageRef = new pageReference('/apex/login_account');
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    public pageReference logoutFunctionWithMsg(String msg){
        
         Cookie RecordId = new Cookie('xgaxccacx','',null,0,true);
        ApexPages.currentPage().setCookies(new Cookie[]{RecordId});
        pageReference pageRef = new pageReference('/apex/login_account?msg='+msg);
        pageRef.setRedirect(true);
        return pageRef;
    }
    
    
    
}