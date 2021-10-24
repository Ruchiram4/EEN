//
//  ObjectParserTest.swift
//  EENAssignmentTests
//
//  Created by Ruchira Macbook on 2021-10-12.
//

import XCTest
@testable import EENAssignment

class ObjectParserTest: XCTestCase {

    var parser: ObjectParser? = ObjectParser()
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        parser = nil
        super.tearDown()
    }
    
    func test_getHttpStatusCode(){
        
        let urlString = URLs.host() + URLs.login()
        let url = URL(string: urlString)
        
        let httpResponse200 = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let httpResponse400 = HTTPURLResponse(url: url!, statusCode: 400, httpVersion: "1.1", headerFields: nil)
        let httpResponse401 = HTTPURLResponse(url: url!, statusCode: 401, httpVersion: "1.1", headerFields: nil)
        let httpResponse403 = HTTPURLResponse(url: url!, statusCode: 403, httpVersion: "1.1", headerFields: nil)
        let httpResponse500 = HTTPURLResponse(url: url!, statusCode: 500, httpVersion: "1.1", headerFields: nil)
        let httpResponseAbc = HTTPURLResponse(url: url!, statusCode: 800, httpVersion: "1.1", headerFields: nil)
        
        XCTAssertEqual(200, parser!.getHttpStatusCode(response: httpResponse200))
        XCTAssertEqual(400, parser!.getHttpStatusCode(response: httpResponse400))
        XCTAssertEqual(401, parser!.getHttpStatusCode(response: httpResponse401))
        XCTAssertEqual(403, parser!.getHttpStatusCode(response: httpResponse403))
        XCTAssertEqual(500, parser!.getHttpStatusCode(response: httpResponse500))
        XCTAssertEqual(800, parser!.getHttpStatusCode(response: httpResponseAbc))
        
    }
    
    func test_performBasicValidationOfReponseErrors() {
        
        let responseErrorBodyWithAuthError = """
            {
                "error": "invalid_grant",
                "error_description": "Invalid credentials"
            }
            """
        
        let dataWithAuthenticationError = Data(base64Encoded: responseErrorBodyWithAuthError.base64Encode() )
        let emptyData = Data(base64Encoded: "".base64Encode())
        
        let urlString = URLs.host() + URLs.login()
        let url = URL(string: urlString)
        
        let httpResponse200 = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        let httpResponse400 = HTTPURLResponse(url: url!, statusCode: 400, httpVersion: "1.1", headerFields: nil)
        let httpResponse401 = HTTPURLResponse(url: url!, statusCode: 401, httpVersion: "1.1", headerFields: nil)
        let httpResponse403 = HTTPURLResponse(url: url!, statusCode: 403, httpVersion: "1.1", headerFields: nil)
        let httpResponse500 = HTTPURLResponse(url: url!, statusCode: 500, httpVersion: "1.1", headerFields: nil)
        
        var r200 = (parser?.performBasicValidationOfReponseErrors(withData: dataWithAuthenticationError, error: nil, response: httpResponse200))!
        var r400 = (parser?.performBasicValidationOfReponseErrors(withData: dataWithAuthenticationError, error: nil, response: httpResponse400))!
        var r401 = (parser?.performBasicValidationOfReponseErrors(withData: dataWithAuthenticationError, error: nil, response: httpResponse401))!
        var r403 = (parser?.performBasicValidationOfReponseErrors(withData: dataWithAuthenticationError, error: nil, response: httpResponse403))!
        var r500 = (parser?.performBasicValidationOfReponseErrors(withData: dataWithAuthenticationError, error: nil, response: httpResponse500))!
        
        //Although 400 is bad request, the code checks the "error" value to determine
        XCTAssertEqual(r200, ResponseError.none)
        XCTAssertEqual(r400, ResponseError.badrequest)
        XCTAssertEqual(r401, ResponseError.authentication)
        XCTAssertEqual(r403, ResponseError.authentication)
        XCTAssertEqual(r500, ResponseError.server)
        
        r200 = (parser?.performBasicValidationOfReponseErrors(withData: emptyData, error: nil, response: httpResponse200))!
        r400 = (parser?.performBasicValidationOfReponseErrors(withData: emptyData, error: nil, response: httpResponse400))!
        r401 = (parser?.performBasicValidationOfReponseErrors(withData: emptyData, error: nil, response: httpResponse401))!
        r403 = (parser?.performBasicValidationOfReponseErrors(withData: emptyData, error: nil, response: httpResponse403))!
        r500 = (parser?.performBasicValidationOfReponseErrors(withData: emptyData, error: nil, response: httpResponse500))!
        
        XCTAssertEqual(r200, ResponseError.none)
        XCTAssertEqual(r400, ResponseError.badrequest)
        XCTAssertEqual(r401, ResponseError.authentication)
        XCTAssertEqual(r403, ResponseError.authentication)
        XCTAssertEqual(r500, ResponseError.server)

    }
    
    func test_cameraStreamsResponse() {
        let responseString = """
            [
                {
                    "streamId": {
                        "value": 0
                    },
                    "urls": {
                        "rtsp": "rtsp://ca033.cameramanager.com:554/stream/rtsp/open?camera_id=1729057",
                        "rtspHttp": "rtspHttp://ca033.cameramanager.com:80/stream/rtsp/open?camera_id=1729057",
                        "rtspHttps": "rtspHttps://ca033.cameramanager.com:443/stream/rtsp/open?camera_id=1729057",
                        "hlsHttp": "http://ca033.cameramanager.com:80/stream/hls/getPlaylist?camera_id=1729057",
                        "hlsHttps": "https://ca033.cameramanager.com:443/stream/hls/getPlaylist?camera_id=1729057",
                        "multipartHttp": "http://ca033.cameramanager.com:80/stream/multipart/open?camera_id=1729057",
                        "multipartHttps": "https://ca033.cameramanager.com:443/stream/multipart/open?camera_id=1729057",
                        "multipartaudioHttp": "http://ca033.cameramanager.com:80/stream/multipartaudio/open?camera_id=1729057",
                        "multipartaudioHttps": "https://ca033.cameramanager.com:443/stream/multipartaudio/open?camera_id=1729057",
                        "mjpegHttp": "http://ca033.cameramanager.com:80/stream/jpeg/open?camera_id=1729057",
                        "mjpegHttps": "https://ca033.cameramanager.com:443/stream/jpeg/open?camera_id=1729057",
                        "audioPushHttp": "http://ca033.cameramanager.com:80/rest/v2.1/cameras/1729057/audio",
                        "audioPushHttps": "https://ca033.cameramanager.com:443/rest/v2.1/cameras/1729057/audio"
                    }
                }
            ]
            """
        
        let objectParser = ObjectParser()
        
        let urlString = URLs.host() + URLs.cameraStream(cameraId: 12345)
        let url = URL(string: urlString)
        let httpResponse200 = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: "1.1", headerFields: nil)
        
        let (cameraStream, error) = objectParser.parseCameraStreamResponse(withData: responseString.data(using: .utf8), error: nil, response: httpResponse200)
        
        XCTAssertEqual(error, .none)
        XCTAssertEqual(cameraStream?.urls?.rtsp, "rtsp://ca033.cameramanager.com:554/stream/rtsp/open?camera_id=1729057")
        
    }

}
