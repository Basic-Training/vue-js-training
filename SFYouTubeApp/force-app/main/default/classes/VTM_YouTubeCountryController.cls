public with sharing class VTM_YouTubeCountryController {
    
    public String searchText { get; set; }
    public VTM_YouTubeCountryController.Item[] items { get; set; }
    
    private String SEARCH_URL { get; set; }
    private String API_KEY { get; set; }

    public VTM_YouTubeCountryController() {
        VTM_YOUTUBE_SETTINGS__c youTubeSettings = VTM_YOUTUBE_SETTINGS__c.getInstance();
        SEARCH_URL = youTubeSettings.COUNTRY_URL__c;
        API_KEY = youTubeSettings.API_KEY__c;
        details();
    }

    public void details() {
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        String endpoint = SEARCH_URL +
            '?part=snippet' +
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
        
        Response response = (Response)JSON.deserialize(res.getBody(), VTM_YouTubeCountryController.Response.class);
        this.items = response.items;
    }

    public class Response {
        public String kind { get; set; }
        public String etag { get; set; }
        public VTM_YouTubeCountryController.Item[] items { get; set; }
    }
    
    public class Item {
        public String kind { get; set; }
        public String etag { get; set; }
        public String id { get; set; }
        public VTM_YouTubeCountryController.Snippet snippet { get; set; }
    }
    
    public class Snippet {
        public String gl { get; set; }
        public String name { get; set; }
    }
}