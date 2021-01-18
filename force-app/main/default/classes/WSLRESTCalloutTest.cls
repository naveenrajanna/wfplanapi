@isTest
public class WSLRESTCalloutTest {
    @isTest static  void testMakePostCallout_Success() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('makeWFPlanPostCallout_success');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        String requestBody = 'id=5007F000017I7uE&agentid=0057F000000Z2AG';
        OutboundResponseWrapper responseWrapper;
        WSLRESTCallout.CalloutResponse response;
        responseWrapper = WSLRESTCallout.makePostCallout(requestBody);

        // Verify mock response is not null
        System.assertNotEquals(null,
            responseWrapper,
            'The callout returned a null response.');

        // Verify status code
        System.assertEquals(200,
            responseWrapper.httpStatusCode,
            'The status code is not 200.');
        
        // Verify the outbound response
        response = (WSLRESTCallout.CalloutResponse) responseWrapper.outboundResponse.get('response');
        System.assertEquals('true', response.success,
          'success attribute is not matching from mock');
        System.assertEquals('3682a26bf582015d31f794b1e376f553', response.secretKey,
          'secretKey is not matching from mock');
    }   

    @isTest static  void testMakePostCallout_Failure() {
        // Create the mock response based on a static resource
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('makeWFPlanPostCallout_failure');
        mock.setStatusCode(500);
        mock.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        // Associate the callout with a mock response
        Test.setMock(HttpCalloutMock.class, mock);
        // Call method to test
        String requestBody = 'id=5007F000017I7uE&agentid=0057F000000Z2AG';
        OutboundResponseWrapper responseWrapper;
        WSLRESTCallout.CalloutErrorResponse response;
        responseWrapper = WSLRESTCallout.makePostCallout(requestBody);

        // Verify status code
        System.assertEquals(500,
            responseWrapper.httpStatusCode,
            'The status code is not 500.');
        
        // Verify the outbound response
        response = (WSLRESTCallout.CalloutErrorResponse) responseWrapper.outboundResponse.get('error');
        System.assertEquals('false', response.success,
          'success attribute is not matching from mock');
        System.assertEquals('Internal server error', response.error,
          'error is not matching from mock');
    }  
}