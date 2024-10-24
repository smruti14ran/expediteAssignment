@RestResource(urlMapping='/getData/*')
global class FrontEndRestService {
    @HttpGet
    global static String doGet() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        String accountId = req.params.get('accountId');
        System.debug('accId '+accountId);
        return DataService.getOpportunities(accountId);
    }

}