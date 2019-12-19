public with sharing class YouTubeSearchController {
    
    public String searchText { get; set; }
    public YouTubeSearchController.Item[] items { get; set; }
    
    private static final String SEARCH_URL = 'https://www.googleapis.com/youtube/v3/search';
    private static final String API_KEY = 'Get a key at - https://console.developers.google.com/';

    public PageReference search() {
        if ((searchText == null) || (searchText == '')) {
            items = null;
            return null;
        }
        
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet' +
            '&maxResults=10' +
            '&type=video' +
            '&q=' + EncodingUtil.urlEncode(searchText, 'UTF-8') +
            '&key=' + API_KEY;
        
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        try {
            res = http.send(req);
            System.debug(res.getBody());
        } catch (System.CalloutException e){
            System.debug('ERROR:' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to run search at this time.  Please try again later.'));
            return null;
        }
        
        Response response = (Response)JSON.deserialize(res.getBody(), YouTubeSearchController.Response.class);
        this.items = response.items;
        
        return null;
    }
    
    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public YouTubeSearchController.PageInfo pageInfo { get; set; }
        public YouTubeSearchController.Item[] items { get; set; }
    }
    
    public class PageInfo {
        public Integer totalResults { get; set; }
        public Integer resultsPerPage { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public YouTubeSearchController.Id id { get; set; }
        public YouTubeSearchController.Snippet snippet { get; set; }
    }
    
    public class Id {
        public String kind { get; set; }
        public String videoId { get; set; }
    }
    
    public class Snippet {
        public Datetime publishedAt { get; set; }
        public String channelId { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public YouTubeSearchController.Thumbnails thumbnails { get; set; }
        public String channelTitle { get; set; }
        public String liveBroadcastContent { get; set; }
    }
    
    public class Thumbnails {
        //public YouTubeSearchController.Thumbnail default { get; set; }
        public YouTubeSearchController.Thumbnail medium { get; set; }
        public YouTubeSearchController.Thumbnail high { get; set; }
    }
    
    public class Thumbnail {
        public String url { get; set; }
    }
}