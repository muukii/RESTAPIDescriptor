//
//  JSONSchema.swift
//  RESTAPIDescriptor
//
//  Created by muukii on 2019/10/26.
//

import Foundation

public enum JSONObjectPropertyRequriements: Hashable {
  case required
  case optional
  
  var isRequired: Bool {
    switch self {
    case .required: return true
    case .optional: return false
    }
  }
}

public struct JSONObjectPropertyDescriptor: Hashable {
  
  public let name: String
  public let valueType: JSONValueDescriptor
  public var required: Bool
  public var description: String = ""
  
  public init(
    name: String,
    valueType: JSONValueDescriptor,
    requirements: JSONObjectPropertyRequriements,
    description: String
  ) {
    self.name = name
    self.valueType = valueType
    self.required = requirements.isRequired
    self.description = description
  }
  
  public func addDescription(_ description: String) -> Self {
    var _obj = self
    _obj.description = description
    return _obj
  }
     
}

public struct JSONObjectDescriptor: Hashable {
  
  public let name: String
  public var properties: [JSONObjectPropertyDescriptor] = []
  public var description: String = ""
  
  public init(name: String) {
    self.name = name
  }
  
  public func addProperty(
    _ name: String,
    _ valueType: JSONValueDescriptor,
    _ requirements: JSONObjectPropertyRequriements,
    _ description: String = "") -> Self {
    var _obj = self
    _obj.properties.append(
      .init(
        name: name,
        valueType: valueType,
        requirements: requirements,
        description: description
      )
    )
    return _obj
  }
    
  public func addDescription(_ description: String) -> Self {
    var _obj = self
    _obj.description = description
    return _obj
  }
  
}

public struct JSONOneOfDescriptor: Hashable {
  
  public var cases: Set<JSONValueDescriptor>
  
  public init(_ cases: [JSONValueDescriptor]) {
    self.cases = .init(cases)
  }
  
}

public indirect enum JSONValueDescriptor: Hashable {
  case number
  case boolean
  case string
  case object(JSONObjectDescriptor)
  case array(JSONValueDescriptor)
  case oneOf(JSONOneOfDescriptor)
  
  public static func array(_ object: JSONObjectDescriptor) -> JSONValueDescriptor {
    .array(.object(object))
  }
  
  public static func oneOf(_ cases: [JSONValueDescriptor]) -> JSONValueDescriptor {
    .oneOf(.init(cases))
  }
  
  public static func oneOf(_ cases: JSONValueDescriptor...) -> JSONValueDescriptor {
    .oneOf(.init(cases))
  }
  
  public static func oneOf(_ cases: JSONObjectDescriptor...) -> JSONValueDescriptor {
    .oneOf(.init(cases.map { .object($0) }))
  }
}
