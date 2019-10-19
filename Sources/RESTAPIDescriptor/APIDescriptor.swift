import Foundation

public protocol JSONDescriptor {
  
}

public enum JSONObjectWrapper: JSONDescriptor {
  
  case object(JSONObjectDescriptor)
  case oneOf([JSONObjectDescriptor])
  
  public func takeAllDependencies() -> Set<JSONObjectDescriptor> {
    switch self {
    case .object(let d):
      return d.takeAllDependencies()
    case .oneOf(let d):
      return d.map { $0.takeAllDependencies() }
        .reduce(into: Set<JSONObjectDescriptor>()) { (result, d) in
          result.formUnion(d)
      }
    }
  }
}

public struct JSONObjectDescriptor: JSONDescriptor, Hashable {
  
  public struct PropertyDescriptor: Hashable {
    
    public enum ValueType: Hashable {
      case int
      case bool
      case string
      case enumeration([String])
      case anyObject
      case object(JSONObjectDescriptor)
      case oneOf([JSONObjectDescriptor])
      case array(JSONObjectDescriptor)
      case arrayOneOf([JSONObjectDescriptor])           
    }
    
    public let name: String
    public let valueType: ValueType
    public var required: Bool
    public var description: String = ""
  }
  
  
  public let name: String
  public var properties: [PropertyDescriptor] = []
  public var description: String = ""
  
  public init(name: String, properties:  [PropertyDescriptor] = [], description: String = "") {
    self.name = name
    self.properties = properties
    self.description = description
  }
  
  public func addDescription(_ description: String) -> Self {
    var _obj = self
    _obj.description = description
    return _obj
  }
  
  public func addProperty(name: String, valueType: PropertyDescriptor.ValueType, required: Bool, description: String = "") -> Self {
    var _obj = self
    _obj.properties.append(.init(name: name, valueType: valueType, required: required, description: description))
    return _obj
  }
  
  public func addOwnTypeName() -> Self {
    var _obj = self
    _obj.properties.append(.init(name: "type", valueType: .string, required: true, description: "The object type `\(name)`"))
    return _obj
  }
  
  public func takeAllDependencies() -> Set<Self> {
    
    var buffer: Set<JSONObjectDescriptor> = .init()
    
    func _take(_ object: JSONObjectDescriptor) {
      
      buffer.insert(object)
      object.properties.forEach { property in
        switch property.valueType {
        case .int,
             .bool,
             .string,
             .anyObject,
             .enumeration:
          break
        case .object(let object):
          buffer.insert(object)
          _take(object)
        case .oneOf(let objects):
          buffer.formUnion(objects)
          objects.forEach { _take($0) }
        case .array(let object):
          buffer.insert(object)
          _take(object)
        case .arrayOneOf(let objects):
          buffer.formUnion(objects)
          objects.forEach { _take($0) }
        }
      }
      
    }
    
    _take(self)
    
    return buffer
  }
}

public struct HeaderDescriptor {
  
  public struct Property {
    public var key: String
    public var valueDescription: String
  }
  
  public var properties: [Property] = []
  
  public init() {
    
  }
  
  public func addProperty(key: String, valueDescription: String) -> Self {
    var _self = self
    _self.properties.append(Property(key: key, valueDescription: valueDescription))
    return _self
  }
}

public struct QueryParameterDescriptor {
  
  public struct Property {
    public var key: String
    public var required: Bool
    public var valueDescription: String
  }
  
  public var properties: [Property] = []
  
  public init() {
    
  }
  
  public func addProperty(key: String, required: Bool, valueDescription: String) -> Self {
    var _self = self
    _self.properties.append(Property(key: key, required: required, valueDescription: valueDescription))
    return _self
  }
}

public struct Endpoint {
  
  public enum Method: String, Encodable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    
    public var documentationString: String {
      switch self {
      case .get: return "GET"
      case .post: return "POST"
      case .put: return "PUT"
      case .delete: return "DELETE"
      }
    }
  }
  
  public var name: String
  public var path: String
  public var method: Method
  public var description: String
  public var headers: HeaderDescriptor?
  
  public var queryParameters: QueryParameterDescriptor?
  public var requestBody: JSONObjectWrapper?
  
  public var response: JSONObjectDescriptor?
  
  public init(
    path: String,
    method: Method,
    headers: (() -> HeaderDescriptor)?,
    urlParameters: (() -> QueryParameterDescriptor)?,
    body: (() -> JSONObjectWrapper)?,
    response: (() -> JSONObjectDescriptor)?,
    description: String
  ) {
    
    self.name = path
    self.path = path
    self.method = method
    self.headers = headers?()
    self.queryParameters = urlParameters?()
    self.requestBody = body?()
    self.response = response?()
    self.description = description
    
  }
  
}

