public with sharing class VTM_YouTubeVideoCateController {
    
    public String searchText { get; set; }
    public VTM_YouTubeVideoCateController.Item[] items { get; set; }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }
    private String regionCode { get; set; }

    public VTM_YouTubeVideoCateController() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.VIDEO_CATE_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;
        regionCode = ApexPages.currentPage().getParameters().get('id');
        details();
    }

    public void details() {
        if ((regionCode == null) || (regionCode == '')) {
            items = null;
        }
        else {
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            HttpResponse res = null;
            String endpoint = SEARCH_URL +
                '?part=snippet' +
                '&regionCode=' + regionCode +
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
            
            Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeVideoCateController.Response.class);
            this.items = response.items;            
        }       
    }

    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public VTM_YouTubeVideoCateController.Item[] items { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeVideoCateController.Snippet snippet { get; set; }
    }
    
    public class Snippet {
        public String channelId { get; set; }
        public String title { get; set; }
        public String assignable { get; set; }
    }
}