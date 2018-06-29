import Foundation

enum APIUrl {
    
}

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource where A: Decodable {
    init(url: String, querys: [URLQueryItem]? = nil) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let urlComponents = NSURLComponents()
        urlComponents.scheme = Webservice.baseScheme
        urlComponents.host = Webservice.baseHost
        urlComponents.path = "/api/" + url
        
        print(querys)
        if (querys != nil) {
            urlComponents.queryItems = querys
        }
        self.url = urlComponents.url!
        self.parse = { try? decoder.decode(A.self, from: $0) } 
    }
}

final class Webservice {
    
    public static let baseScheme = "https"
    public static let baseHost = "danielmueller.fwd.wf"

    func load<A>(resource: Resource<A>, session: URLSession, completion: @escaping (A?) -> ()) {
        session.dataTask(with: resource.url) { data, _, _ in
            guard let data = data
                else {
                completion(nil)
                print("Error")
                return
            }
            completion(resource.parse(data))
            }.resume()
    }
}
