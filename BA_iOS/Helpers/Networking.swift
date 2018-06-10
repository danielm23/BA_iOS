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
        
        self.url = Webservice.baseUrl.appendingPathComponent(url)
        self.parse = { try? decoder.decode(A.self, from: $0) }
    }
}


final class Webservice {
    
    public static let baseUrl = URL(string: "https://danielmueller.fwd.wf/api")!

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
