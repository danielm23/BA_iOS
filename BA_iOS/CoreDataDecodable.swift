import Foundation
import CoreData

public protocol CoreDataDecodable: Decodable {
    associatedtype DTO: Decodable
    
    @discardableResult
    static func findOrCreate(for dto: DTO, in context: NSManagedObjectContext) throws -> Self
    
    init(with dto: DTO, in context: NSManagedObjectContext) throws
    
    mutating func update(from dto: DTO) throws
}
enum CoreDataDecodingError: Error {
    case missingContext(codingPath: [CodingKey])
}

extension NSManagedObjectContext {
    private static var _decodingContext: NSManagedObjectContext?
    
    static func decodingContext(at codingPath: [CodingKey] = []) throws -> NSManagedObjectContext {
        if let context = _decodingContext { return context }
        throw CoreDataDecodingError.missingContext(codingPath: codingPath)
    }
    
    public final func asDecodingContext(do work: () -> ()) {
        NSManagedObjectContext._decodingContext = self
        defer { NSManagedObjectContext._decodingContext = nil }
        performAndWait { work() }
    }
}

extension CoreDataDecodable {
    init(from decoder: Decoder) throws {
        try self.init(with: DTO(from: decoder), in: .decodingContext(at: decoder.codingPath))
    }
}

extension CoreDataDecodable where Self: NSManagedObject {
    init(with dto: DTO, in context: NSManagedObjectContext) throws {
        self.init(context: context)
        try update(from: dto)
    }
}
