public with sharing class VTM_YouTubeVideoController {
    
    public String searchText {
        get {
            if (searchText == null) {
                searchText = 'news';
            }
            return searchText;
        }
        set {
            searchText = value;
        }
    }
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
    public String channelId {
        get {
            if (channelId == null) {
                channelId = 'UC6zhI71atP7YLoZyIyCIGNw';
            }
            return channelId;
        }
        set {
            channelId = value;
        }
    }
    private Integer resultsPerPage { 
        get {
            if (resultsPerPage == null) {
                resultsPerPage = 4;
            }
            return resultsPerPage;
        }
        set {
            resultsPerPage = value;
        }
    }
    public String pageTokenPopular {
        get {
            if (pageTokenPopular == null) {
                pageTokenPopular = '';
            }
            return pageTokenPopular;
        }
        set {
            pageTokenPopular = value;
        }
    }
    public String pageTokenLive {
        get {
            if (pageTokenLive == null) {
                pageTokenLive = '';
            }
            return pageTokenLive;
        }
        set {
            pageTokenLive = value;
        }
    }
    public String pageTokenRecent {
        get {
            if (pageTokenRecent == null) {
                pageTokenRecent = '';
            }
            return pageTokenRecent;
        }
        set {
            pageTokenRecent = value;
        }
    }

    public VTM_YouTubeVideoController.Item[] items { get; set; }
    public VTM_YouTubeVideoController.ItemLive[] itemsLive { get; set; }
    public VTM_YouTubeVideoController.ItemRecent[] itemsRecent { get; set; }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }
    private String videoId { get; set; }

    public VTM_YouTubeVideoController() {
        videoId = ApexPages.currentPage().getParameters().get('id');
        details();
    }

    public void details() {
        if ((videoId == null) || (videoId == '')) {
            items = null;
        }
        else {
            VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
            SEARCH_URL = youTubeSettings.VIDEO_URL__c;
            API_KEY = youTubeSettings.API_KEY__c;

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

    // List most popular videos on Homepage
    public PageReference listPopularVideosByCountry() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.VIDEO_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet,contentDetails,statistics' +
            '&maxResults=' + resultsPerPage +
            '&chart=mostPopular' +
            '&pageToken=' + pageTokenPopular +
            '&regionCode=' + this.regionCode +
            '&key=' + API_KEY;
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        try {
            res = http.send(req);
        } catch (System.CalloutException e){
            System.debug('ERROR:' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to run search at this time.  Please try again later.'));
        }
        Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.Response.class);
        this.items = response.items;
        this.pageTokenPopular = response.nextPageToken;
        return null;
    }

    // List live events on Homepage
    public PageReference listLiveBroadcasts() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.SEARCH_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet' +
            '&maxResults=' + resultsPerPage +
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
        
        ResponseLive response = (ResponseLive)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.ResponseLive.class);
        this.itemsLive = response.items;
        this.pageTokenLive = response.nextPageToken;
        return null;
    }

    // list recent videos
    public PageReference listRecentVideos() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.ACTIVITY_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet,contentDetails' +
            '&maxResults=' + resultsPerPage +
            '&channelId=' + this.channelId +
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
        
        ResponseRecent response = (ResponseRecent)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.ResponseRecent.class);
        System.debug('response.items === ' + response.items);
        this.itemsRecent = response.items;
        this.pageTokenRecent = response.nextPageToken;
        return null;
    }

    // List videos display on Search page with searchText & country
    public PageReference listSearchVideo() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.VIDEO_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet,contentDetails,statistics' +
            '&maxResults=' + resultsPerPage +
            '&q=' + this.searchText +
            '&pageToken=' + pageTokenPopular +
            '&regionCode=' + this.regionCode +
            '&key=' + API_KEY;
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        try {
            res = http.send(req);
        } catch (System.CalloutException e){
            System.debug('ERROR:' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to run search at this time.  Please try again later.'));
        }
        Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.Response.class);
        this.items = response.items;
        this.pageTokenPopular = response.nextPageToken;
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

    // list most popular videos

    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubeVideoController.PageInfo pageInfo { get; set; }
        public VTM_YouTubeVideoController.Item[] items { get; set; }
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

    // list live events

    public class ResponseLive {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubeVideoController.PageInfo pageInfo { get; set; }
        public VTM_YouTubeVideoController.ItemLive[] items { get; set; }
    }

    public class ItemLive {
        public String kind { get; set; }
        public String etag { get; set; }
        public VTM_YouTubeVideoController.IdVideoLive id { get; set; }
        public VTM_YouTubeVideoController.SnippetLive snippet { get; set; }
    }

    public class IdVideoLive {
        public String kind { get; set; }
        public String videoId { get; set; }
    }

    public class SnippetLive {
        public Datetime publishedAt { get; set; }
        public String channelId { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public VTM_YouTubeVideoController.ThumbnailsLive thumbnails { get; set; }
        public String channelTitle { get; set; }
        public String liveBroadcastContent { get; set; }
    }

    public class ThumbnailsLive {
        //public YouTubeSearchController.Thumbnail default { get; set; }
        public VTM_YouTubeVideoController.Thumbnail medium { get; set; }
        public VTM_YouTubeVideoController.Thumbnail high { get; set; }
    }

    // list recent videos

    public class ResponseRecent {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubeVideoController.PageInfo pageInfo { get; set; }
        public VTM_YouTubeVideoController.ItemRecent[] items { get; set; }
    }

    public class ItemRecent {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeVideoController.SnippetRecent snippet { get; set; }
        public VTM_YouTubeVideoController.contentDetailsRecent contentDetails { get; set; }

    }

    public class SnippetRecent {
        public Datetime publishedAt { get; set; }
        public String channelId { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public VTM_YouTubeVideoController.ThumbnailsRecent thumbnails { get; set; }
        public String channelTitle { get; set; }
        public String type { get; set; }
    }

    public class ThumbnailsRecent {
        //public YouTubeSearchController.Thumbnail default { get; set; }
        public VTM_YouTubeVideoController.Thumbnail medium { get; set; }
        public VTM_YouTubeVideoController.Thumbnail high { get; set; }
        public VTM_YouTubeVideoController.Thumbnail standard { get; set; }
        public VTM_YouTubeVideoController.Thumbnail maxres { get; set; }
    }

    public class contentDetailsRecent {
        public VTM_YouTubeVideoController.UploadRecent upload { get; set; }
    }

    public class UploadRecent {
        public String videoId { get; set; }
    }

}