//
//  Flowers
//
//  Pierre Navarre
//

import Foundation

public extension RequestBuilder {
    func asyncExecute(_ apiResponseQueue: DispatchQueue = OpenAPIClientAPI.apiResponseQueue) async throws -> Response<T> {
        return try await withCheckedThrowingContinuation { continuation in
            self.execute { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
