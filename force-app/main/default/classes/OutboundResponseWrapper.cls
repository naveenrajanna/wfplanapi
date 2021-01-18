/*********************************************************************************************************
* Class Name: OutboundResponse 
* Description: Response wrapper for outbound calls
*********************************************************************************************************/
public with sharing class OutboundResponseWrapper {
    public Integer httpStatusCode {get; set;}
    public String statusMessage {get; set;}
    public Map<String, Object> outboundResponse {get; set;}

    public OutboundResponseWrapper(Integer httpStatusCode, String statusMessage) {
        this.httpStatusCode = httpStatusCode;
        this.statusMessage = statusMessage;
    }

    public OutboundResponseWrapper(Integer httpStatusCode, Map<String, Object> outboundResponse, String statusMessage) {
        this.httpStatusCode = httpStatusCode;
        this.outboundResponse = outboundResponse;
        this.statusMessage = statusMessage;
    }
}