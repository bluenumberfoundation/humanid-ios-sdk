import RxAlamofire
import RxSwift

internal final class Network {

    private let scheduler: ConcurrentDispatchQueueScheduler
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init() {
        let dispatchQoS = DispatchQoS.QoSClass.background
        let qos = DispatchQoS(qosClass: dispatchQoS, relativePriority: 1)

        self.scheduler = ConcurrentDispatchQueueScheduler(qos: qos)
        self.encoder = JSONEncoder()
        self.decoder = JSONDecoder()
    }

    func requestOtp(url: URL, header: BaseRequest, request: RequestOTP.Request) -> Observable<BaseResponse<RequestOTP.Response>> {
        let requestBody = try! encoder.encode(request)

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(header.clientId, forHTTPHeaderField: "client-id")
        urlRequest.setValue(header.clientSecret, forHTTPHeaderField: "client-secret")
        urlRequest.method = .post
        urlRequest.httpBody = requestBody

        return RxAlamofire
            .request(urlRequest)
            .validate(statusCode: 200..<401)
            .responseJSON()
            .asObservable()
            .observeOn(scheduler)
            .map({ (response) -> BaseResponse<RequestOTP.Response> in
                return try self.decoder.decode(BaseResponse<RequestOTP.Response>.self, from: response.data!)
            })
    }

    func login(url: URL, header: BaseRequest, request: Login.Request) -> Observable<BaseResponse<Login.Response>> {
        let requestBody = try! encoder.encode(request)

        var urlRequest = URLRequest(url: url)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue(header.clientId, forHTTPHeaderField: "client-id")
        urlRequest.setValue(header.clientSecret, forHTTPHeaderField: "client-secret")
        urlRequest.method = .post
        urlRequest.httpBody = requestBody

        return RxAlamofire
            .request(urlRequest)
            .validate(statusCode: 200..<401)
            .responseJSON()
            .asObservable()
            .observeOn(scheduler)
            .map({ (response) -> BaseResponse<Login.Response> in
                return try self.decoder.decode(BaseResponse<Login.Response>.self, from: response.data!)
            })
    }
}
