public with sharing class VTM_YouTubeChannelController {
    
    public String searchText { get; set; }
    public VTM_YouTubeChannelController.Item[] items { get; set; }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }
    private String channelId { get; set; }

    public VTM_YouTubeChannelController() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.CHANNEL_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;
        channelId = ApexPages.currentPage().getParameters().get('id');
        details();
    }

    public void details() {
        if ((channelId == null) || (channelId == '')) {
            items = null;
        }
        else {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = null;
            String endpoint = SEARCH_URL +
                '?part=snippet,contentDetails' +
                '&channelId=' + channelId +
                '&maxResults=50' +
                '&pageToken=' +
                '&key=' + API_KEY;
            req.setEndPoint(endpoint);
            req.setMethod('GET');
            try {
                res = http.send(req);
                System.debug(res.getBody());
            } catch (System.CalloutException e){
                System.debug('ERROR:' + e);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to run search at this time.  Please try again later.'));
            }
            
            Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeChannelController.Response.class);
            this.items = response.items;            
        }       
    }

    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubeChannelController.PageInfo pageInfo { get; set; }
        public VTM_YouTubeChannelController.Item[] items { get; set; }
    }
    
    public class PageInfo {
        public Integer totalResults { get; set; }
        public Integer resultsPerPage { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeChannelController.Snippet snippet { get; set; }
        public VTM_YouTubeChannelController.ContentDetails contentDetails { get; set; }
    }
    
    public class Snippet {
        public Datetime publishedAt { get; set; }
        public String channelId { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public VTM_YouTubeChannelController.Thumbnails thumbnails { get; set; }
        public String channelTitle { get; set; }
    }
    
    public class Thumbnails {
        //public VTM_YouTubeChannelController.Thumbnail default { get; set; }
        public VTM_YouTubeChannelController.Thumbnail medium { get; set; }
        public VTM_YouTubeChannelController.Thumbnail high { get; set; }
        public VTM_YouTubeChannelController.Thumbnail standard { get; set; }
        public VTM_YouTubeChannelController.Thumbnail maxres { get; set; }
    }
    
    public class Thumbnail {
        public String url { get; set; }
    }

    public class ContentDetails {
        public String itemCount { get; set; }
    }
}