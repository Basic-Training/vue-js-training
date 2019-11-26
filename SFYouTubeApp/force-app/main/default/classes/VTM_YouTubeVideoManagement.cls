public class VTM_YouTubeVideoManagement {

    // Use to get JSON data from youtube API
    public static HttpResponse getResponse(String searchURL, Map<String, String> mapParams) {

        String endpoint = searchURL + '?';

        for(String valueParam : mapParams.keyset()) {
            endpoint += '&' + valueParam + '=' + mapParams.get(valueParam);
        }

        System.debug('endpoint ==> ' + endpoint);

        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse res = null;
        req.setEndPoint(endpoint);
        req.setMethod('GET');
        
        try {
            res = http.send(req);
            //System.debug(res.getBody());
        } catch (System.CalloutException e){
            System.debug('ERROR:' + e);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error, 'Unable to run search at this time.  Please try again later.'));
        }
        
        return res;
    }

}
