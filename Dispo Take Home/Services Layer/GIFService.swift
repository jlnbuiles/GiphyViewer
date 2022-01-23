import Foundation
import RxSwift
import Alamofire

/**
        GIF Web services layer. Responsible for initiating and handling GIF-related requests.
    
    - Author: Julian Builes
*/
struct GIFService <T: Codable> {
    
    let decoder: JSONDecoder = {
        let decodr = JSONDecoder()
        decodr.keyDecodingStrategy = .convertFromSnakeCase
        return decodr
    }()
    
    func executeRequest(url: URL) -> Observable <T> {
        return Observable.create { observer in
            
            AF.request(url).responseDecodable(of: T.self, decoder: decoder) { resp in
                switch resp.result {
                    case .success:
                        if let responseValue = resp.value { observer.onNext(responseValue) }
                    case let .failure(error):
                        handleResponseWith(error: error, url: url)
                        observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create { }
        }
    }
    
    func GETTrendingGIFs() -> Observable<T> {
        let url = APIPathManager.Path.trending.url()!
        return executeRequest(url: url)
    }
    
    func GETGIF(by id: String) -> Observable<T> {
        let url = APIPathManager.Path.byID(id).url()!
        return executeRequest(url: url)
    }
    
    func GETGIFs(by searchTerm: String) -> Observable<T> {
        let url = APIPathManager.Path.search(searchTerm).url()!
        return executeRequest(url: url)
    }
}

/**
        Error handling extension
 
    - Author: Julian Builes
*/
extension GIFService {
    
    func handleResponseWith(error: Error?, url: URL) {
        // only logging the error locally for now...
        print("\n\nReceived error \(String(describing: error))\nfor url: \(url)")
    }
}
