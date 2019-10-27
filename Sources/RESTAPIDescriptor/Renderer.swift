//
//  Renderer.swift
//  RESTAPIDescriptor
//
//  Created by muukii on 2019/10/26.
//

import Foundation

public class PlainTextBuilder {
  
  private var lines: [String] = []
  
  private var indent: Int = 0
  
  public init() {
  }
  
  public func appendNewline() {
    lines.append("")
  }
  
  public func append(_ line: String) {
    lines.append(makeIndentSpace() + line)
  }
  
  private func makeIndentSpace() -> String {
    (0..<indent).map { _ in " " }.joined()
  }
  
  public func render() -> String {
    lines.joined(separator: "\n")
  }
}

public final class MarkdownBuilder: PlainTextBuilder {
  
  public let anchorNamespace: String
  
  public init(anchorNamespace: String) {
    self.anchorNamespace = anchorNamespace
  }
  
}

public final class EndpointsRenderer {
  
}

/*
protocol Renderer {
  
  func render(context: ParserContext) -> String
}

final class APIDocumentRenderer: Renderer {
  
  func render(context: ParserContext) -> String {
    
    let builder = PlainTextBuilder()
    
    for endpoint in context.endpoints {
      
      let endpointBuilder = MarkdownBuilder(anchorNamespace: endpoint.name)
      
      endpointBuilder.append("## 🔗  \(endpoint.method.toString()) : \(endpoint.name)")
      endpointBuilder.appendNewline()
      endpointBuilder.append("**Path** : \(endpoint.path)")
      endpointBuilder.append("**Method** : \(endpoint.method.toString())")
      endpointBuilder.appendNewline()
      
      endpointBuilder.append("### 📤 Request Parameters")
      endpointBuilder.appendNewline()
      endpointBuilder.append("#### Header Fields")
      endpointBuilder.appendPropertyList(from: context.object(from: endpoint.header).members)
      endpointBuilder.appendNewline()
      endpointBuilder.appendMarkdownSeparator()
      
      endpointBuilder.append("#### Query Parameters")
      endpointBuilder.appendPropertyList(from: context.object(from: endpoint.query).members)
      endpointBuilder.appendNewline()
      endpointBuilder.appendMarkdownSeparator()
      
      endpointBuilder.append("#### Body Parameters")
      endpointBuilder.appendPropertyList(from: context.object(from: endpoint.body).members)
      endpointBuilder.appendNewline()
      endpointBuilder.appendMarkdownSeparator()
      
      endpointBuilder.append("### 📥 Response Format")
      
      endpointBuilder.appendPropertyList(from: context.object(from: endpoint.response).members)
      endpointBuilder.appendNewline()
      endpointBuilder.appendMarkdownSeparator()
      
      endpointBuilder.append("#### Related Objects")
      endpointBuilder.appendNewline()
      endpointBuilder.appendMarkdownSeparator()
      
      endpointBuilder.appendMarkdownText(
        from: [
          context.object(from: endpoint.body).members.collectAllRelatedObjects(context: context),
          context.object(from: endpoint.response).members.collectAllRelatedObjects(context: context),
          ]
          .flatMap { $0 }
          .map {
            context.object(from: $0)
        }
        .sorted { $0.name < $1.name },
        baseHeading: "####"
      )
      
      endpointBuilder.appendNewline()
      endpointBuilder.appendNewline()
      endpointBuilder.appendNewline()
      
      builder.append(endpointBuilder.render())
    }
    
    return builder.render()
    
  }
}
*/
