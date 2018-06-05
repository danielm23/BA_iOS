import Foundation

enum APIUrl {
    
}

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource where A: Decodable {
    init(url: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        self.url = Webservice.BASEURL.appendingPathComponent(url)
        self.parse = { try? decoder.decode(A.self, from: $0) }
    }
}


final class Webservice {
    
    public static let BASEURL = URL(string: "https://danielmueller.fwd.wf/api")!

    // modify to get SEESSION.SHARED as argument
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
            }.resume()
    }
}

