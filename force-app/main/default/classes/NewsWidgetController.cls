/**
 * This class is created to call
 * Google News Generating class
 * and display in the VisualForce
 * Page.
 * 
 * @author      Shruti Sridharan
 * @since       08/03/2016
 * @version     1.0
 * @revisons    N/A
 */
global class NewsWidgetController {
    /**
     * This method calls the GoogleNews
     * Class which in turn calls the
     * Google News API.
     * 
     * @since       08/03/2016
     * @version     1.0
     * @revisons    N/A
     */
    @RemoteAction
    global static String newsDisplayer( String searchTerm ) {
        String newsBody = GoogleNews.newsGrabber( searchTerm );
        return newsBody;
    }
    
    public NewsWidgetController(ApexPages.StandardController controller){
    }
}