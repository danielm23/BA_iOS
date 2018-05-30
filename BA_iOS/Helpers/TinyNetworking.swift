import Foundation

struct Resource<A> {
    let url: URL
    let parse: (Data) -> A?
}

extension Resource where A: Decodable {
    init(url: String) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let baseUrl = URL(string: "https://danielmueller.fwd.wf/api")!
        
        self.url = baseUrl.appendingPathComponent(url)
        self.parse = { try? decoder.decode(A.self, from: $0) }
    }
}


final class Webservice {
    
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        URLSession.shared.dataTask(with: resource.url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            completion(resource.parse(data))
            }.resume()
    }/*
    func load<A>(resource: Resource<A>, completion: @escaping (A?) -> ()) {
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        let dispatchGroup = DispatchGroup()

        dataTask = defaultSession.dataTask(with: resource.url) { data, response, error in
            dispatchGroup.enter()
            if let e = error {
                print("error:")
                print(e)
                //completion(error(e))
            } else if let d = data,
                let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        let newEvents = try decoder.decode([JsonEvent].self, from: d)
                        print(resource.parse(d))
                        print(" new Event ")
                        print(newEvents)
                    }
                    catch let jsonErr {
                        print("Error json: ", jsonErr)
                    }
                //completion(resource.parse(d))
                //print(d)
                //print("parsed data: ")
                //print(resource.parse(d))
                //print("  ")
            }
        dispatchGroup.leave()
        }
    dataTask?.resume()
    }*/
}

