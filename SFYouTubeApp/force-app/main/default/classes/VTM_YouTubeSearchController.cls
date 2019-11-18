public with sharing class VTM_YouTubeSearchController {
    
    public String searchText { get; set; }
    public VTM_YouTubeSearchController.Item[] items { get; set; }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }

    public VTM_YouTubeSearchController() {
        VTM_YOUTUBE_SETTINGS__c	youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.SEARCH_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;
    }

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
            '&maxResults=50' +
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
        
        Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeSearchController.Response.class);
        this.items = response.items;
        
        return null;
    }
    
    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubeSearchController.PageInfo pageInfo { get; set; }
        public VTM_YouTubeSearchController.Item[] items { get; set; }
    }
    
    public class PageInfo {
        public Integer totalResults { get; set; }
        public Integer resultsPerPage { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public VTM_YouTubeSearchController.Id id { get; set; }
        public VTM_YouTubeSearchController.Snippet snippet { get; set; }
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
        public VTM_YouTubeSearchController.Thumbnails thumbnails { get; set; }
        public String channelTitle { get; set; }
        public String liveBroadcastContent { get; set; }
    }
    
    public class Thumbnails {
        //public YouTubeSearchController.Thumbnail default { get; set; }
        public VTM_YouTubeSearchController.Thumbnail medium { get; set; }
        public VTM_YouTubeSearchController.Thumbnail high { get; set; }
    }
    
    public class Thumbnail {
        public String url { get; set; }
    }
}