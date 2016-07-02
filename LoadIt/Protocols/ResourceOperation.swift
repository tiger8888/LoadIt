//
//  ResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 26/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol Cancellable: class {
  var cancelled: Bool { get }
}

public protocol Finishable: class {
  func finish(errors: [NSError])
}

public protocol ResourceOperation: Cancellable, Finishable {
  associatedtype ResourceType: Resource
  var resource: ResourceType { get }
  
  /**
   <#Description#>
   
   - parameter service: <#service description#>
   */
  func fetchResource<T: ResourceService where T.ResourceType == ResourceType>(service service: T)
  
  /**
   Called when the operation has finished
   
   - parameter result: The result of the operation
   */
  func didFinishFetchingResource(result result: Result<ResourceType.ModelType>)
}

public extension ResourceOperation {
  
  public func fetchResource<T: ResourceService where T.ResourceType == ResourceType>(service service: T) {
    if cancelled { return }
    service.fetch(resource: resource) { [weak self] (result) in
      guard let strongSelf = self else { return }
      if strongSelf.cancelled { return }
      NSThread.executeOnMain { [weak self] in
        guard let strongSelf = self else { return }
        if strongSelf.cancelled { return }
        strongSelf.didFinishFetchingResource(result: result)
        strongSelf.finish([])
      }
    }
  }
  
}