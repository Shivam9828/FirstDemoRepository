/**
 * This class exposes methods
 * that call Google APIs to
 * get news.
 * 
 * @author      Shruti Sridharan
 * @since       08/03/2016
 * @version     1.0
 * @revisons    N/A
 */
public class GoogleNews {
    /**
     * This method calls the Google
     * APIs with the encoded key.
     * 
     * @since       08/03/2016
     * @version     1.0
     * @revison     N/A
     */
    public static String newsGrabber( String searchTerm ) {
        /**
         * Gets the Endpoint from the Custom
         * Settings.
         */
        String endpoint = news__c.getInstance( 'Google News Endpoint' ).Value__c;
        endpoint = endpoint.replace( 'searchstring', searchTerm );
        
        Http http = new Http();
        HttpRequest httpReq = new HttpRequest();
        HttpResponse httpRes = new HttpResponse();
        
        httpReq.setMethod( 'GET' );
        httpReq.setEndpoint( endpoint ); 
        
        httpRes = http.send( httpReq ); 
        
        String xmlBody = httpRes.getBody();
        return xmlBody;
    }
}