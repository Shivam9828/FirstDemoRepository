public class StreamingApiController {
    /**
     * This method returns signed in user's session id
     * @author Manish Choudhari
     * */
    @AuraEnabled
    public static String getSessionId() {
        return UserInfo.getSessionId();
    }
}