/*********************************************************************************************************
* Class Name: WSLRESTCallout 
* Description: Class to make REST API callouts to the Workforce Plan Named Credential
*********************************************************************************************************/

public class WSLRESTCallout {
    public static final Integer SERVICE_TIME_OUT = 30000;
    public static String WF_PLAN_NAMED_CREDENTIAL = 'callout:WorkforcePlan_NamedCredential';
    
    //Define configuration class and store all required inputs required for server call from custom metadata
    /*
    private class Configuration {
        //declare all inputs from custom metadata
    }

    private static void setupConfiguration(){
        //instantiate local Configuration and set all the inputs, so it can be used in post callout
    }
    */

    /*  @Description: function to make POST REST Callout to Workforce Plan external system.
    *   @Param: requestBody containing the input requet details
    *   Return OutboundResponseWrapper containing the status information and response details
    */
    public static OutboundResponseWrapper makePostCallout(String requestBody) {
        OutboundResponseWrapper responseWrapper = null;
        if(!String.isBlank(requestBody)) {
            // setupConfiguration(); Call to setup any configuration from custom metadata to private Configuration class
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            request.setMethod('POST');
            request.setTimeout(SERVICE_TIME_OUT); // timeout in milliseconds
            request.setEndpoint(WF_PLAN_NAMED_CREDENTIAL); //use named credential, change authentication if required in named credentials
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setBody(requestBody);
    
            HttpResponse response = http.send(request);
			responseWrapper = new OutboundResponseWrapper(response.getStatusCode(), response.getStatus());
            
            // If the request is successful, parse the JSON response.
            Integer statusCode = response.getStatusCode(); 
            if (statusCode == 200 || statusCode == 201) {
                CalloutResponse calloutResponse = new CalloutResponse();
                calloutResponse = (CalloutResponse) System.JSON.deserialize(response.getBody(), CalloutResponse.class);
                responseWrapper.outboundResponse = new Map<String, Object> { 'response' => calloutResponse };
            } else {
                String error = response.getStatus() + ' ' + response.getBody();
                System.debug('Callout failed: '+ statusCode + ' ' + error );
                CalloutErrorResponse calloutErrorResponse = new CalloutErrorResponse();
                calloutErrorResponse = (CalloutErrorResponse) System.JSON.deserialize(response.getBody(), CalloutErrorResponse.class);
                responseWrapper.outboundResponse = new Map<String, Object> { 'error' => calloutErrorResponse };
            }
        }

        return responseWrapper;
    }
    
    //wrapper class for Request in case the request parameters are more
    /*
    public class CalloutRequest {
        public String id { get; set; }
        public String agentid { get; set; }
    }
    */

    //wrapper class for Response
    public class CalloutResponse {
        public String success { get; set; }
        public String secretKey { get; set; }
    }

    //wrapper class for Response
    public class CalloutErrorResponse {
        public String success { get; set; }
        public String error { get; set; }
    }

}