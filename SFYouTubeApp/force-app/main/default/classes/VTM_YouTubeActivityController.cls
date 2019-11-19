public with sharing class VTM_YouTubeActivityController {
    
    public String searchText { get; set; }
    public VTM_YouTubeActivityController.Item[] items { get; set; }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }
    private String channelId { get; set; }

    public VTM_YouTubeActivityController() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.ACTIVITY_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;
        channelId = ApexPages.currentPage().getParameters().get('id'); // it can be empty
        details();
    }

    public void details() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet,contentDetails' +
            '&channelId=' + channelId +
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
        
        Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeActivityController.Response.class);
        this.items = response.items;
        System.debug(response.items);                  
    }

    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public VTM_YouTubeActivityController.Item[] items { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeActivityController.Snippet snippet { get; set; }
        public VTM_YouTubeActivityController.ContentDetails contentDetails { get; set; }
    }
    
    public class Snippet {
        public String channelId { get; set; }
        public String channelTitle { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public VTM_YouTubeActivityController.Thumbnails thumbnails { get; set; }
    }

    public class ContentDetails {
        public VTM_YouTubeActivityController.Upload upload { get; set; }
    }

    public class Upload {
        public String videoId { get; set; }
    }

    public class Thumbnails {
        //public VTM_YouTubeActivityController.Thumbnail default { get; set; }
        public VTM_YouTubeActivityController.Thumbnail medium { get; set; }
        public VTM_YouTubeActivityController.Thumbnail high { get; set; }
    }
    
    public class Thumbnail {
        public String url { get; set; }
    }
}