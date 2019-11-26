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
    public String typeSearch {
        get {
            if (typeSearch == null) {
                typeSearch = 'video';
            }
            return typeSearch;
        }
        set {
            typeSearch = value;
        }
    }
    public String displayVideo {
        get {
            if (displayVideo == null) {
                displayVideo = '';
            }
            return displayVideo;
        }
        set {
            displayVideo = value;
        }
    }
    public String displayChannel {
        get {
            if (displayChannel == null) {
                displayChannel = 'none';
            }
            return displayChannel;
        }
        set {
            displayChannel = value;
        }
    }
    public String displayPlaylist {
        get {
            if (displayPlaylist == null) {
                displayPlaylist = 'none';
            }
            return displayPlaylist;
        }
        set {
            displayPlaylist = value;
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
                //channelId = 'UC6zhI71atP7YLoZyIyCIGNw';
                channelId = '';
            }
            return channelId;
        }
        set {
            channelId = value;
        }
    }
    public Integer resultsPerPage { 
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
    public VTM_YouTubeVideoController.ItemCountry[] itemsCountry { get; set; }
    
    public String SEARCH_URL { get; set; }
    public String API_KEY { get; set; }
    public String videoId { get; set; }
    public String displayTitleSearch { get; set; }
    public String displayTitleAllVideos { get; set; }

    

    public void details() {
        if ((videoId == null) || (videoId == '')) {
            items = null;
        }
        else {
            VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
            SEARCH_URL = youTubeSettings.VIDEO_URL__c;
            API_KEY = youTubeSettings.API_KEY__c;

            Map<String, String> mapParams = new Map<String, String>();
            mapParams.put('key', API_KEY);
            mapParams.put('part', 'snippet,contentDetails,statistics');
            mapParams.put('type', 'video');
            mapParams.put('id', videoId);

            HttpResponse res = VTM_YouTubeVideoManagement.getResponse(SEARCH_URL, mapParams);
            //System.debug('listPopularVideosByCountry ===> ' + res.getBody());
            
            Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.Response.class);
            this.items = response.items;            
        }       
    }

    // List most popular videos on Homepage
    public PageReference listPopularVideosByCountry() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.VIDEO_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;

        Map<String, String> mapParams = new Map<String, String>();
        mapParams.put('key', API_KEY);
        mapParams.put('part', 'snippet,contentDetails,statistics');
        mapParams.put('type', 'video');
        mapParams.put('regionCode', this.regionCode);
        mapParams.put('maxResults', String.valueOf(resultsPerPage));
        mapParams.put('pageToken', pageTokenPopular);
        mapParams.put('chart', 'mostPopular');

        HttpResponse res = VTM_YouTubeVideoManagement.getResponse(SEARCH_URL, mapParams);
        //System.debug('listPopularVideosByCountry ===> ' + res.getBody());

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

        Map<String, String> mapParams = new Map<String, String>();
        mapParams.put('key', API_KEY);
        mapParams.put('part', 'snippet');
        mapParams.put('type', 'video');
        mapParams.put('eventType', 'live');
        mapParams.put('q', this.searchText);
        mapParams.put('maxResults', String.valueOf(resultsPerPage));
        mapParams.put('pageToken', pageTokenLive);

        HttpResponse res = VTM_YouTubeVideoManagement.getResponse(SEARCH_URL, mapParams);
        //System.debug('listLiveBroadcasts ===> ' + res.getBody());

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
        channelId = 'UC6zhI71atP7YLoZyIyCIGNw';

        Map<String, String> mapParams = new Map<String, String>();
        mapParams.put('key', API_KEY);
        mapParams.put('part', 'snippet,contentDetails');
        mapParams.put('type', 'video');
        mapParams.put('channelId', channelId);
        mapParams.put('maxResults', String.valueOf(resultsPerPage));
        mapParams.put('pageToken', pageTokenRecent);

        HttpResponse res = VTM_YouTubeVideoManagement.getResponse(SEARCH_URL, mapParams);
        //System.debug('listRecentVideos ===> ' + res.getBody());

        ResponseRecent response = (ResponseRecent)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.ResponseRecent.class);
        this.itemsRecent = response.items;
        this.pageTokenRecent = response.nextPageToken;
        return null;
    }

    // List videos display on Search page with searchText & country
    public PageReference listSearchVideo() {        
        Map<String, String> params = ApexPages.currentPage().getParameters();
        if(params.containsKey('searchText')) {
            this.searchText = params.get('searchText');
        }
        else {
            searchText = ApexPages.currentPage().getParameters().get('searchText');
        }
        
        typeSearch = ApexPages.currentPage().getParameters().get('typeSearch');
        channelId = ApexPages.currentPage().getParameters().get('channelId');
        regionCode = ApexPages.currentPage().getParameters().get('regionCode');

        switch on typeSearch {
            when 'video' {
                displayVideo = '';
                displayChannel = 'none';
                displayPlaylist = 'none';
            }
            when 'channel' {
                displayVideo = 'none';
                displayChannel = '';
                displayPlaylist = 'none';
                channelId = '';
            }
            when 'playlist' {
                displayVideo = 'none';
                displayChannel = 'none';
                displayPlaylist = '';
                channelId = '';
            }
        }

        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.SEARCH_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;

        Map<String, String> mapParams = new Map<String, String>();
        mapParams.put('key', API_KEY);
        mapParams.put('part', 'snippet');
        mapParams.put('type', typeSearch);
        mapParams.put('order', 'date');
        // mapParams.put('topicId', '/m/04rlf'); // Music
        mapParams.put('maxResults', String.valueOf(resultsPerPage));
        mapParams.put('pageToken', pageTokenLive);

        if (String.isNotBlank(searchText)) {
            mapParams.put('q', searchText);
            displayTitleSearch = '';
            displayTitleAllVideos = 'none';
        }
        else {
            displayTitleSearch = 'none';
            displayTitleAllVideos = '';
        }
        
        if (String.isNotBlank(channelId)) {
            mapParams.put('channelId', channelId);
        }

        if (String.isNotBlank(regionCode)) {
            mapParams.put('regionCode', regionCode);
        }

        HttpResponse res = VTM_YouTubeVideoManagement.getResponse(SEARCH_URL, mapParams);
        System.debug('listSearchVideo ===> ' + res.getBody());
        
        ResponseLive response = (ResponseLive)JSON.deserialize(res.getBody(), VTM_YouTubeVideoController.ResponseLive.class);
        this.itemsLive = response.items;
        this.pageTokenLive = response.nextPageToken;
        return null;
    }

    public PageReference listCountries() {
        //videoId = ApexPages.currentPage().getParameters().get('id');
        //details();

        StaticResource sr = [Select id,body from StaticResource Where Name = 'VTM_youtube_countries'];
        String jsonCountries = sr.body.toString();
        System.debug('SR@@@'+ jsonCountries);

        ResponseCountry response = (ResponseCountry)JSON.deserialize(jsonCountries, VTM_YouTubeVideoController.ResponseCountry.class);
        this.itemsCountry = response.items;
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
        public String channelId { get; set; }
        public String playlistId { get; set; }
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

    // list countries

    public class ResponseCountry {
        public String kind { get; set; }
        public String etag { get; set; }
        public VTM_YouTubeVideoController.ItemCountry[] items { get; set; }
    }

    public class ItemCountry {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeVideoController.SnippetCountry snippet { get; set; }
    }

    public class SnippetCountry {
        public String gl { get; set; }
        public String name { get; set; }
    }

}