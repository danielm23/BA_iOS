/*import CoreData

public protocol CoreDataDecodable: Decodable, Managed {
    associatedtype DTO: Decodable
    
    @discardableResult
    static func findOrCreateDTO(for dto: DTO, in context: NSManagedObjectContext) throws -> Self
    
    init(with dto: DTO, in context: NSManagedObjectContext) throws
    
    // without mutating!
    func update(from dto: DTO) throws
}

public extension CoreDataDecodable {
    public init(from decoder: Decoder) throws {
        try self.init(with: DTO(from: decoder), in: .decodingContext(at: decoder.codingPath))
    }
}

public extension CoreDataDecodable where Self: NSManagedObject {
    @discardableResult
    static func findOrCreateDTO(for dto: DTO, in context: NSManagedObjectContext) throws -> Self {
        var object = findOrCreate(in: context, matching: <#T##NSPredicate#>, configure: <#T##(Managed) -> ()#>)
        try object.update(from: dto)
        return object
    }

    public init(with dto: DTO, in context: NSManagedObjectContext) throws {
        self.init(context: context)
        try update(from: dto)
    }
}

public enum CoreDataDecodingError: Error {
    case missingContext(codingPath: [CodingKey])
}*/
/*
public extension NSManagedObjectContext {
    private static var _decodingContext: NSManagedObjectContext?
    
    public static func decodingContext(at codingPath: [CodingKey] = []) throws -> NSManagedObjectContext {
        if let context = _decodingContext { return context }
        throw CoreDataDecodingError.missingContext(codingPath: codingPath)
    }
    
    public final func asDecodingContext<T>(do work: () throws -> T) rethrows -> T {
        NSManagedObjectContext._decodingContext = self
        defer { NSManagedObjectContext._decodingContext = nil }
        return try sync { try work() }
    }
}*/
