import Foundation

public struct EndpointDescriptor: Hashable {
  
  public enum BodyFormat: Hashable {
    case json(JSONValueDescriptor)
  }
  
  public enum Method: String, Encodable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
  }
  
  public struct Request: Hashable {
    public var header: HTTPHeaderDescriptor?
    public var urlParameter: URLParameterDescriptor?
    public var body: BodyFormat?
    
    public init(
      header: HTTPHeaderDescriptor?,
      urlParameter: URLParameterDescriptor?,
      body: BodyFormat?
    ) {
      self.header = header
      self.urlParameter = urlParameter
      self.body = body
    }
  }
  
  public struct Response: Hashable {
    public var header: HTTPHeaderDescriptor?
    public var body: BodyFormat?

    public init(
      header: HTTPHeaderDescriptor?,
      body: BodyFormat?
      ) {
      self.header = header
      self.body = body
    }
  }
  
  public var name: String
  public var path: String
  public var method: Method
  public var request: Request
  public var response: Response
  public var description: String
        
  public init(
    path: String,
    method: Method,
    request: Request,
    response: Response,
    description: String
  ) {
    
    self.name = path
    self.path = path
    self.method = method
    self.request = request
    self.response = response
    self.description = description
    
  }
  
}

