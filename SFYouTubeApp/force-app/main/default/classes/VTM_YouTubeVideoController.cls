public with sharing class VTM_YouTubeVideoController {
    
    public String searchText { get; set; }
    public VTM_YouTubeVideoController.Item[] items { get; set; }
    public VTM_YouTubeVideoController.ItemLive[] itemsLive { get; set; }
    public String regionCode {
        get {
            if (regionCode == null) {
                regionCode = 'VN';
            }
            return regionCode;
        }
        set {
            regionCode = value;
        }
    }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }
    private String videoId { get; set; }

    public VTM_YouTubeVideoController() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        //SEARCH_URL = youTubeSettings.VIDEO_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;
        videoId = ApexPages.currentPage().getParameters().get('id');
        details();
    }

    public void details() {
        if ((videoId == null) || (videoId == '')) {
            items = null;
        }
        else {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = null;
            String endpoint = SEARCH_URL +
                '?part=snippet,contentDetails,statistics' +
                '&id=' + videoId +
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
            
            Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.Response.class);
            this.items = response.items;            
        }       
    }

    public PageReference listPopularVideosByCountry() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.VIDEO_URL__c;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet,contentDetails,statistics' +
            '&maxResults=10' +
            '&chart=mostPopular' +
            '&regionCode=' + this.regionCode +
            '&key=' + API_KEY;
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        System.debug('endpoint === ' + endpoint);
        try {
            res = http.send(req);
        } catch (System.CalloutException e){
            System.debug('ERROR:' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to run search at this time.  Please try again later.'));
        }
        System.debug('res.getBody === ' + res.getBody());
        Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.Response.class);
        this.items = response.items;
        return null;
    }

    public PageReference listLiveBroadcasts() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.SEARCH_URL__c;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet' +
            '&maxResults=10' +
            '&eventType=live' +
            '&type=video' +
            '&q=' + this.searchText +
            '&key=' + API_KEY;
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        System.debug('endpoint === ' + endpoint);
        try {
            res = http.send(req);
        } catch (System.CalloutException e){
            System.debug('ERROR:' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to run search at this time.  Please try again later.'));
        }
        System.debug('res.getBody === ' + res.getBody());
        ResponseLive response = (ResponseLive)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.ResponseLive.class);
        this.itemsLive = response.items;
        return null;
    }

    public void listRelatedVideos() {
        /*
        SEARCH_URL
        curl \
  'https://www.googleapis.com/youtube/v3/search?part=snippet&relatedToVideoId=wtLJPvx7-ys&type=video&key=[YOUR_API_KEY]' \
  --header 'Authorization: Bearer [YOUR_ACCESS_TOKEN]' \
  --header 'Accept: application/json' \
  --compressed
        */
    }

    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubeVideoController.PageInfo pageInfo { get; set; }
        public VTM_YouTubeVideoController.Item[] items { get; set; }
    }
    
    public class ResponseLive {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubeVideoController.PageInfo pageInfo { get; set; }
        public VTM_YouTubeVideoController.ItemLive[] items { get; set; }
    }

    public class PageInfo {
        public Integer totalResults { get; set; }
        public Integer resultsPerPage { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeVideoController.Snippet snippet { get; set; }
        public VTM_YouTubeVideoController.ContentDetails contentDetails { get; set; }
        public VTM_YouTubeVideoController.Statistics statistics { get; set; }
    }

    public class ItemLive {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeVideoController.Snippet snippet { get; set; }
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
        public VTM_YouTubeVideoController.Thumbnails thumbnails { get; set; }
        public String channelTitle { get; set; }
        public String liveBroadcastContent { get; set; }
    }
    
    public class Thumbnails {
        //public YouTubeSearchController.Thumbnail default { get; set; }
        public VTM_YouTubeVideoController.Thumbnail medium { get; set; }
        public VTM_YouTubeVideoController.Thumbnail high { get; set; }
        public VTM_YouTubeVideoController.Thumbnail standard { get; set; }
        public VTM_YouTubeVideoController.Thumbnail maxres { get; set; }
    }
    
    public class Thumbnail {
        public String url { get; set; }
    }

    public class ContentDetails {
        public String duration { get; set; }
        public String dimension { get; set; }
        public String definition { get; set; }
        public String caption { get; set; }
        public String licensedContent { get; set; }
        public String projection { get; set; }
    }

    public class Statistics {
        public String viewCount { get; set; }
        public String likeCount { get; set; }
        public String dislikeCount { get; set; }
        public String favoriteCount { get; set; }
        public String commentCount { get; set; }
    }
}