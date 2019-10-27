//
//  Visitor.swift
//  RESTAPIDescriptor
//
//  Created by muukii on 2019/10/28.
//

import Foundation

open class EndpointsVisitor {
  
  public init() {
    
  }
  
  open func visit(_ endpointGroup: EndpointDescriptorGroup) {
    endpointGroup.endpoints.forEach {
      visit($0)
    }
  }
  
  open func visit(_ endpoint: EndpointDescriptor) {
    visit(endpoint.request, endpoint)
    visit(endpoint.response, endpoint)
    visit(endpoint.method, endpoint)
  }
  
  open func visit(_ request: EndpointDescriptor.Request, _ endpoint: EndpointDescriptor) {
    request.body.map {
      visit($0)
    }
    request.header.map {
      visit($0, endpoint)
    }
    request.urlParameter.map {
      visit($0, endpoint)
    }
  }
  
  open func visit(_ response: EndpointDescriptor.Response, _ endpoint: EndpointDescriptor) {
    response.body.map {
      visit($0)
    }
    response.header.map {
      visit($0, endpoint)
    }
  }
      
  open func visit(_ header: HTTPHeaderDescriptor, _ endpoint: EndpointDescriptor) {
    
  }
  
  open func visit(_ query: URLParameterDescriptor, _ endpoint: EndpointDescriptor) {
    
  }
  
  open func visit(_ method: EndpointDescriptor.Method, _ endpoint: EndpointDescriptor) {
    
  }
  
  open func visit(_ body: EndpointDescriptor.BodyFormat) {
    switch body {
    case .json(let json):
      visit(json)
    }
  }
  
  open func visit(_ jsonValue: JSONValueDescriptor) {
    switch jsonValue {
    case .number:
      break
    case .boolean:
      break
    case .string:
      break
    case .object(let object):
      visit(object)
    case .array(let value):
      visit(value)
    case .oneOf(let oneOf):
      oneOf.cases.forEach {
        visit($0)
      }
    }
  }
  
  open func visit(_ jsonObject: JSONObjectDescriptor) {
    for property in jsonObject.properties {
      visit(property)
    }
  }
  
  open func visit(_ jsonObjectProperty: JSONObjectPropertyDescriptor) {
    visit(jsonObjectProperty.valueType)
  }
      
}
