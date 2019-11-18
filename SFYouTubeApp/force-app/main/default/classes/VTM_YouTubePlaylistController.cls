public with sharing class VTM_YouTubePlaylistController {
    
    public String searchText { get; set; }
    public VTM_YouTubePlaylistController.Item[] items { get; set; }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }
    private String playlistId { get; set; }

    public VTM_YouTubePlaylistController() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.PLAYLIST_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;
        playlistId = ApexPages.currentPage().getParameters().get('id');
        details();
    }

    public void details() {
        if ((playlistId == null) || (playlistId == '')) {
            items = null;
        }
        else {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = null;
            String endpoint = SEARCH_URL +
                '?part=snippet' +
                '&playlistId=' + playlistId +
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
            
            Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubePlaylistController.Response.class);
            this.items = response.items;            
        }       
    }

    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public String nextPageToken { get; set; }
        public String prevPageToken { get; set; }
        public VTM_YouTubePlaylistController.PageInfo pageInfo { get; set; }
        public VTM_YouTubePlaylistController.Item[] items { get; set; }
    }
    
    public class PageInfo {
        public Integer totalResults { get; set; }
        public Integer resultsPerPage { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubePlaylistController.Snippet snippet { get; set; }
        public VTM_YouTubePlaylistController.ContentDetails contentDetails { get; set; }
    }
    
    public class Snippet {
        public Datetime publishedAt { get; set; }
        public String channelId { get; set; }
        public String title { get; set; }
        public String description { get; set; }
        public VTM_YouTubePlaylistController.Thumbnails thumbnails { get; set; }
        public String channelTitle { get; set; }
    }
    
    public class Thumbnails {
        //public VTM_YouTubePlaylistController.Thumbnail default { get; set; }
        public VTM_YouTubePlaylistController.Thumbnail medium { get; set; }
        public VTM_YouTubePlaylistController.Thumbnail high { get; set; }
        public VTM_YouTubePlaylistController.Thumbnail standard { get; set; }
        public VTM_YouTubePlaylistController.Thumbnail maxres { get; set; }
    }
    
    public class Thumbnail {
        public String url { get; set; }
    }

    public class ContentDetails {
        public String itemCount { get; set; }
    }
}