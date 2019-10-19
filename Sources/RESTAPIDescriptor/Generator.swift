
import Foundation

extension JSONObjectDescriptor {
  
  var markdownLinkString: String {
    "#\(name.replacingOccurrences(of: " ", with: "-"))-object"
  }
  
}

extension JSONObjectDescriptor.PropertyDescriptor.ValueType {
  public var documentationString: String {
    switch self {
    case .int:
      return "int"
    case .bool:
      return "bool"
    case .string:
      return "string"
    case .enumeration(let strings):
      return strings.joined(separator: ", ")
    case .object(let obj):
      return "Link to \(obj.name)"
    case .oneOf(let objects):
      return "The one of \(objects.map { "[`\($0.name)`](\($0.markdownLinkString))" }.joined(separator: " ,"))"
    case .array(let object):
      return "The array of [`\(object.name)`](\(object.markdownLinkString))"
    case .arrayOneOf(let objects):
      return "the array of an object that one of these \(objects.map { "[`\($0.name)`](\($0.markdownLinkString))" }.joined(separator: " ,"))"
    case .anyObject:
      return "Any object"
    }
  }
}

public enum Generator {
  
  public static func run(targets: [JSONObjectDescriptor]) {
    
    for target in targets {
      print("## \(target.name) object")
      print("### Description")
      print("")
      print("### Properties")
      print("|Name|Value Type|Required|Description|")
      print("|---|---|---|---|")
      for property in target.properties {
        print("|\(property.name)|\(property.valueType.documentationString)|\(property.required)|\(property.description)|")
      }
      print("")
      print("---")
      print("")
    }
    
  }
  
  public static func run(endpoint: Endpoint) -> String {
    
    var strings: [String] = []
    var jsonObjects: Set<JSONObjectDescriptor> = .init()
    
    strings.append("# Endpoints")
    strings.append("")
    
    do {
      strings.append("## \(endpoint.method.documentationString) : \(endpoint.path)")
      strings.append("")
      strings.append("### Overview")
      strings.append("")
      
      strings.append("### Request Parameters")
      strings.append("")
      
      strings.append("#### Header Fields")
      strings.append("")
      
      strings.append("#### Query Parameters")
      strings.append("")
      
      if let queryParameters = endpoint.queryParameters {
        // TODO:
        
        strings.append("|Key|Required|Description|")
        strings.append("|---|---|---|")
        
        queryParameters.properties.forEach { property in
          strings.append("|\(property.key)|\(property.required.description)|\(property.valueDescription)|")
        }
        strings.append("")
        
      } else {
        strings.append("None")
      }
      
      strings.append("#### Body Parameters")
      strings.append("")
      
      if let requestBody = endpoint.requestBody {
        
        switch requestBody {
        case .object(let d):
          strings.append("[`\(d.name)`](\(d.markdownLinkString)) object")
        case .oneOf(let d):
          strings.append(d.map { "[`\($0.name)`](\($0.markdownLinkString)) object" }.joined(separator: ", "))
        }
        
        strings.append("")
        
        jsonObjects.formUnion(requestBody.takeAllDependencies())
      }
      
      strings.append("#### Response Format")
      strings.append("")
      
      if let response = endpoint.response {
        strings.append("Returns [`\(response.name)`](\(response.markdownLinkString)) object")
      } else {
        strings.append("No Response")
      }
      
      if let dependencies = endpoint.response?.takeAllDependencies() {
        jsonObjects.formUnion(dependencies)
      }
      
    }
    
    strings.append("")
    strings.append("# JSON Schema")
    strings.append("")
    
    for target in jsonObjects.sorted(by: { $0.name < $1.name }) {
      strings.append("## \(target.name) object")
      strings.append("")
      
      strings.append("### Description")
      strings.append("")
      
      strings.append("### Properties")
      strings.append("")
      
      strings.append("|Name|Value Type|Required|Description|")
      strings.append("|---|---|---|---|")
      for property in target.properties {
        strings.append("|\(property.name)|\(property.valueType.documentationString)|\(property.required)|\(property.description)|")
      }
      strings.append("")
      strings.append("---")
      strings.append("")
    }
    
    return strings.joined(separator: "\n")
    
  }
  
  public static func makePostmanItems(endpoint: Endpoint) -> PostmanSchema.Item {
    
    let description = { () -> String in
      var strings: [String] = []
      var jsonObjects: Set<JSONObjectDescriptor> = .init()
      
      strings.append("# Endpoints")
      strings.append("")
      
      do {
        strings.append("## \(endpoint.method.documentationString) : \(endpoint.path)")
        strings.append("")
        strings.append("### Overview")
        strings.append("")
        strings.append(endpoint.description)
        
        strings.append("### Request Parameters")
        strings.append("")
        
        strings.append("#### Header Fields")
        strings.append("")
        
        strings.append("#### Query Parameters")
        strings.append("")
        
        if let queryParameters = endpoint.queryParameters {
          // TODO:
          
          strings.append("|Key|Required|Description|")
          strings.append("|---|---|---|")
          
          queryParameters.properties.forEach { property in
            strings.append("|\(property.key)|\(property.required.description)|\(property.valueDescription)|")
          }
          strings.append("")
          
        } else {
          strings.append("None")
        }
        
        strings.append("#### Body Parameters")
        strings.append("")
        
        if let requestBody = endpoint.requestBody {
          
          switch requestBody {
          case .object(let d):
            strings.append("[`\(d.name)`](\(d.markdownLinkString)) object")
          case .oneOf(let d):
            strings.append(d.map { "[`\($0.name)`](\($0.markdownLinkString)) object" }.joined(separator: ", "))
          }
          
          strings.append("")
          
          jsonObjects.formUnion(requestBody.takeAllDependencies())
        }
        
        strings.append("#### Response Format")
        strings.append("")
        
        if let response = endpoint.response {
          strings.append("Returns [`\(response.name)`](\(response.markdownLinkString)) object")
        } else {
          strings.append("No Response")
        }
        
        if let dependencies = endpoint.response?.takeAllDependencies() {
          jsonObjects.formUnion(dependencies)
        }
        
      }
      
      strings.append("")
      strings.append("# JSON Schema")
      strings.append("")
      
      for target in jsonObjects.sorted(by: { $0.name < $1.name }) {
        strings.append("## \(target.name) object")
        strings.append("")
        
        strings.append("### Description")
        strings.append("")
        
        strings.append("### Properties")
        strings.append("")
        
        strings.append("|Name|Value Type|Required|Description|")
        strings.append("|---|---|---|---|")
        for property in target.properties {
          strings.append("|\(property.name)|\(property.valueType.documentationString)|\(property.required)|\(property.description)|")
        }
        strings.append("")
        strings.append("---")
        strings.append("")
      }
      
      return strings.joined(separator: "\n")
    }()
    
    return .init(
      name: endpoint.name,
      request: .init(
        method: endpoint.method,
        url: endpoint.path,
        description: description
      )
    )
    
  }
  
  public static func makePostmanItems(endpoints: [Endpoint]) -> [PostmanSchema.Item] {
    
    endpoints.map { makePostmanItems(endpoint: $0) }
    
  }
  
  public static func run(endpoints: [Endpoint]) -> String {
    
    var strings: [String] = []
    var jsonObjects: Set<JSONObjectDescriptor> = .init()
    
    strings.append("# Endpoints")
    strings.append("")
    
    for endpoint in endpoints {
      
      strings.append("## \(endpoint.method.documentationString) : \(endpoint.path)")
      strings.append("")
      strings.append("### Overview")
      strings.append("")
      
      strings.append("### Request Parameters")
      strings.append("")
      
      strings.append("#### Header Fields")
      strings.append("")
      
      strings.append("#### Query Parameters")
      strings.append("")
      
      if let queryParameters = endpoint.queryParameters {
        // TODO:
        
        strings.append("|Key|Required|Description|")
        strings.append("|---|---|---|")
        
        queryParameters.properties.forEach { property in
          strings.append("|\(property.key)|\(property.required.description)|\(property.valueDescription)|")
        }
        strings.append("")
        
      } else {
        strings.append("None")
      }
      
      strings.append("#### Body Parameters")
      strings.append("")
      
      if let requestBody = endpoint.requestBody {
        
        switch requestBody {
        case .object(let d):
          strings.append("[`\(d.name)`](\(d.markdownLinkString)) object")
        case .oneOf(let d):
          strings.append(d.map { "[`\($0.name)`](\($0.markdownLinkString)) object" }.joined(separator: ", "))
        }
        
        strings.append("")
        
        jsonObjects.formUnion(requestBody.takeAllDependencies())
      }
            
      strings.append("#### Response Format")
      strings.append("")

      if let response = endpoint.response {
        strings.append("Returns [`\(response.name)`](\(response.markdownLinkString)) object")
      } else {
        strings.append("No Response")
      }
                
      if let dependencies = endpoint.response?.takeAllDependencies() {
        jsonObjects.formUnion(dependencies)
      }
      
    }
    
    strings.append("")
    strings.append("# JSON Schema")
    strings.append("")
    
    for target in jsonObjects.sorted(by: { $0.name < $1.name }) {
      strings.append("## \(target.name) object")
      strings.append("")
      
      strings.append("### Description")
      strings.append("")
      
      strings.append("### Properties")
      strings.append("")
      
      strings.append("|Name|Value Type|Required|Description|")
      strings.append("|---|---|---|---|")
      for property in target.properties {
        strings.append("|\(property.name)|\(property.valueType.documentationString)|\(property.required)|\(property.description)|")
      }
      strings.append("")
      strings.append("---")
      strings.append("")
    }
    
    return strings.joined(separator: "\n")
    
  }
  
  public static func generatePostman(postman: PostmanSchema) -> String {
    
    let encoder = JSONEncoder()
    encoder.outputFormatting = [.prettyPrinted]
    
    let value = try! encoder.encode(postman)
    let string = String(data: value, encoding: .utf8)!
    
    return string
    
  }
}
