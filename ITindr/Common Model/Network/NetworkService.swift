//
//  RequestHelper.swift
//  ITindr
//
//  Created by Эдуард Логинов on 24.10.2021.
//

import Alamofire
import UIKit

class NetworkService {
    // MARK: Properties
    private let defaults: UserDefaultsManager
    
    private var isRetrying = false
    
    // MARK: Init
    init(defaultsManager: UserDefaultsManager) {
        defaults = defaultsManager
    }
}

// MARK: Interceptor
extension NetworkService: RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var request = urlRequest
        guard let token = defaults.readAccessToken() else {
            completion(.success(urlRequest))
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: RequestKeys.authorization)
        completion(.success(request))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < RetryPolicy.defaultRetryLimit else {
            completion(.doNotRetry)
            return
        }
        
        determineRetryAction(error, retrying: isRetrying, completion: completion)
    }
    
    private func determineRetryAction(_ error: Error, retrying: Bool, completion: @escaping (RetryResult) -> Void) {
        if retrying {
            completion(.retryWithDelay(2))
            return
        }
        
        if error.asAFError?.responseCode == 401 && !retrying {
            isRetrying = true
            requestRefresh { [weak self] isSuccess in
                isSuccess ? completion(.retryWithDelay(2)) : completion(.doNotRetry)
                self?.isRetrying = false
            }
        } else {
            completion(.doNotRetry)
        }
    }
}

// MARK: Auth
extension NetworkService {
    func signInRequest(email: String, password: String,
                       onSuccess success: @escaping () -> Void,
                       onFailure failure: @escaping (_ error: Error) -> Void) {
        AF.request(urlStrings.base + urlStrings.login,
                   method: .post,
                   parameters: [
                    RequestKeys.email: email,
                    RequestKeys.password: password
                   ],
                   encoding: JSONEncoding.default).validate().responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let token = try? decoder.decode(TokenResponse.self, from: data) {
                    self?.defaults.writeTokens(accessToken: token.accessToken,
                                               refreshToken: token.refreshToken)
                    success()
                } else {
                    failure(AuthError(code: 1002))
                }
            case .failure(let error):
                failure(AuthError(code: error.responseCode))
            }
        }
    }
    
    func signUpRequest(email: String, password: String,
                       onSuccess success: @escaping () -> Void,
                       onFailure failure: @escaping (_ error: Error) -> Void) {
        AF.request(urlStrings.base + urlStrings.register,
                   method: .post,
                   parameters: [
                    RequestKeys.email: email,
                    RequestKeys.password: password
                   ],
                   encoding: JSONEncoding.default).validate().responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let token = try? decoder.decode(TokenResponse.self, from: data) {
                    self?.defaults.writeTokens(accessToken: token.accessToken,
                                               refreshToken: token.refreshToken)
                    success()
                } else {
                    failure(AuthError(code: 1002))
                }
            case .failure(let error):
                failure(AuthError(code: error.responseCode))
            }
        }
    }
    
    func requestRefresh(_ completion: @escaping (_ isSuccess: Bool) -> Void) {
        let refreshToken = defaults.readRefreshToken() ?? ""
        
        AF.request(urlStrings.base + urlStrings.refresh,
                   method: .post,
                   parameters: [
                    RequestKeys.refreshToken: refreshToken
                   ],
                   encoding: JSONEncoding.default,
                   interceptor: self
        ).responseData { [weak self] response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let token = try? decoder.decode(TokenResponse.self, from: data) {
                    self?.defaults.writeTokens(accessToken: token.accessToken,
                                               refreshToken: token.refreshToken)
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure:
                completion(false)
            }
        }
    }
}

// MARK: Profile
extension NetworkService {
    func requestProfileInfo(
        onSuccess success: @escaping (_ user: User) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
            AF.request(urlStrings.base + urlStrings.profile,
                       method: .get,
                       encoding: JSONEncoding.default,
                       interceptor: self
            ).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let userData = try? decoder.decode(User.self, from: data) {
                        success(userData)
                    } else {
                        failure(ProfileError.retrievingProfileFailed)
                    }
                case .failure(let error):
                    guard error.responseCode == 401 else {
                        failure(ProfileError.retrievingProfileFailed)
                        return
                    }
                    notAuthotized()
                }
            }
    }
    
    func requestUpdateProfile(
        name: String,
        about: String?,
        topics: [String]?,
        onSuccess success: @escaping (_ user: User) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
        AF.request(urlStrings.base + urlStrings.profile,
                   method: .patch,
                   parameters: [
                    RequestKeys.name: name,
                    RequestKeys.about: about ?? "",
                    RequestKeys.topics: topics ?? []
                   ],
                   encoding: JSONEncoding.default,
                   interceptor: self
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userData = try? decoder.decode(User.self, from: data) {
                    success(userData)
                } else {
                    failure(ProfileError.updatingProfileFailed)
                }
            case .failure(let error):
                guard error.responseCode == 401 else {
                    failure(ProfileError.updatingProfileFailed)
                    return
                }
                notAuthotized()
            }
        }
    }
}

// MARK: Profile Avatar
extension NetworkService {
    func updloadAvatar(
        _ image: UIImage,
        onSuccess success: @escaping () -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
        AF.upload(
            multipartFormData: { formData in
                formData.append(
                    image.jpegData(compressionQuality: 0.2) ?? Data(),
                    withName: RequestKeys.avatar,
                    fileName: RequestKeys.avatar + ".jpg",
                    mimeType: "image/jpeg")
            },
            to: urlStrings.base + urlStrings.avatar,
            interceptor: self
        ).validate().responseData(completionHandler: { response in
            switch response.result {
            case .success:
                success()
            case .failure(let error):
                guard error.responseCode == 401 else {
                    failure(ProfileError.uploadingAvatarFailed)
                    return
                }
                notAuthotized()
            }
        })
    }
    
    func removeAvatar(
        onSuccess success: @escaping () -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
        AF.request(
            urlStrings.base + urlStrings.avatar,
            method: .delete,
            encoding: JSONEncoding.default,
            interceptor: self
        ).validate().responseData(completionHandler: { response in
            switch response.result {
            case .success:
                success()
            case .failure(let error):
                guard error.responseCode == 401 else {
                    failure(ProfileError.deletingAvatarFailed)
                    return
                }
                notAuthotized()
            }
        })
    }
}

// MARK: Topics
extension NetworkService {
    func requestAllTopics(onSuccess success: @escaping (_ topics: [Topic]) -> Void,
                          onFailure failure: @escaping (_ error: Error) -> Void,
                          onNotAuthorized notAuthotized: @escaping () -> Void) {
        AF.request(urlStrings.base + urlStrings.topic,
                   method: .get,
                   encoding: JSONEncoding.default,
                   interceptor: self
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let topics = try? decoder.decode([Topic].self, from: data) {
                    success(topics)
                } else {
                    failure(TopicsError.gettingTopicsFailed)
                }
            case .failure(let error):
                guard error.responseCode == 401 else {
                    failure(TopicsError.gettingTopicsFailed)
                    return
                }
                notAuthotized()
            }
        }
    }
}

// MARK: Users List/Feed
extension NetworkService {
    func requestUsersList(
        limit: Int,
        offset: Int,
        onSuccess success: @escaping (_ users: [User]) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
        AF.request(
            urlStrings.base + urlStrings.user + "?limit=\(limit)&offset=\(offset)",
            method: .get,
            encoding: JSONEncoding.default,
            interceptor: self
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userData = try? decoder.decode([User].self, from: data) {
                    success(userData)
                } else {
                    failure(UserError.gettingUsersFailed)
                }
            case .failure(let error):
                guard error.responseCode == 401 else {
                    failure(UserError.gettingUsersFailed)
                    return
                }
                notAuthotized()
            }
        }
    }
    
    func requestUserFeed(onSuccess success: @escaping (_ users: [User]) -> Void,
                         onFailure failure: @escaping (_ error: Error) -> Void,
                         onNotAuthorized notAuthotized: @escaping () -> Void) {
        AF.request(
            urlStrings.base + urlStrings.feed,
            method: .get,
            encoding: JSONEncoding.default,
            interceptor: self
        ).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                if let userData = try? decoder.decode([User].self, from: data) {
                    success(userData)
                } else {
                    failure(UserError.gettingUserFeedFailed)
                }
            case .failure(let error):
                guard error.responseCode == 401 else {
                    failure(UserError.gettingUserFeedFailed)
                    return
                }
                notAuthotized()
            }
        }
    }
}

// MARK: User Like/Dislike
extension NetworkService {
    func requestLikeUser(
        userId: String,
        onSuccess success: @escaping (_ isMutual: LikeResponse) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void,
        onUserAlreadyRected userAlreadyReacted: @escaping () -> Void) {
            AF.request(
                urlStrings.base + urlStrings.user + "/\(userId)" + urlStrings.like,
                method: .post,
                parameters: [
                    userId: userId
                ],
                encoding: JSONEncoding.default,
                interceptor: self
            ).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let isMutual = try? decoder.decode(LikeResponse.self, from: data) {
                        success(isMutual)
                    } else {
                        failure(UserReactionError.userReactionFailed)
                    }
                case .failure(let error):
                    guard error.responseCode != 401 else {
                        notAuthotized()
                        return
                    }
                    
                    guard error.responseCode != 409 else {
                        userAlreadyReacted()
                        return
                    }
                    
                    failure(UserReactionError.userReactionFailed)
                }
            }
    }
    
    func requestDislikeUser(
        userId: String,
        onSuccess success: @escaping () -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void,
        onUserAlreadyRected userAlreadyReacted: @escaping () -> Void) {
            AF.request(
                urlStrings.base + urlStrings.user + "/\(userId)" + urlStrings.dislike,
                method: .post,
                parameters: [
                    userId: userId
                ],
                encoding: JSONEncoding.default,
                interceptor: self
            ).validate().responseData { response in
                switch response.result {
                case .success:
                    success()
                case .failure(let error):
                    guard error.responseCode != 401 else {
                        notAuthotized()
                        return
                    }
                    
                    guard error.responseCode != 409 else {
                        userAlreadyReacted()
                        return
                    }
                    
                    failure(UserReactionError.userReactionFailed)
                }
            }
    }
}

// MARK: Chats List
extension NetworkService {
    func requestChatsList(
        onSuccess success: @escaping (_ chatsList: [ChatListItem]) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
            AF.request(
                urlStrings.base + urlStrings.chat,
                method: .get,
                encoding: JSONEncoding.default,
                interceptor: self
            ).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let chatsList = try? decoder.decode([ChatListItem].self, from: data) {
                        success(chatsList)
                    } else {
                        failure(ChatError.gettingChatsFailed)
                    }
                case .failure(let error):
                    guard error.responseCode == 401 else {
                        failure(ChatError.gettingChatsFailed)
                        return
                    }
                    notAuthotized()
                }
            }
    }
}

// MARK: Chat
extension NetworkService {
    func requestChatMessages(
        chatId: String,
        limit: Int,
        offset: Int,
        onSuccess success: @escaping (_ messages: [Message]) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
            AF.request(
                urlStrings.base + urlStrings.chat + "/\(chatId)" + urlStrings.message + "?limit=\(limit)&offset=\(offset)",
                method: .get,
                encoding: JSONEncoding.default,
                interceptor: self
            ).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let messages = try? decoder.decode([Message].self, from: data) {
                        success(messages)
                    } else {
                        failure(ChatError.gettingMessagesFailed)
                    }
                case .failure(let error):
                    guard error.responseCode == 401 else {
                        failure(ChatError.gettingMessagesFailed)
                        return
                    }
                    notAuthotized()
                }
            }
        }
    
    func requestSendMessage(
        chatId: String,
        messageText: String?,
        attachment: UIImage?,
        onSuccess success: @escaping (_ message: Message) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
            AF.upload(
                multipartFormData: { formData in
                    if let text = messageText {
                        formData.append(
                            Data(text.utf8),
                            withName: RequestKeys.messageText)
                    }
                    if let image = attachment {
                        formData.append(
                            image.jpegData(compressionQuality: 0.2) ?? Data(),
                            withName: RequestKeys.attachment,
                            fileName: RequestKeys.attachment + ".jpg",
                            mimeType: "image/jpeg")
                    }
                },
                to: urlStrings.base + urlStrings.chat + "/\(chatId)" + urlStrings.message,
                interceptor: self
            ).validate().responseData(completionHandler: { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let message = try? decoder.decode(Message.self, from: data) {
                        success(message)
                    } else {
                        failure(ChatError.sendingMessageFailed)
                    }
                case .failure(let error):
                    guard error.responseCode == 401 else {
                        failure(ChatError.sendingMessageFailed)
                        return
                    }
                    notAuthotized()
                }
            })
        }
    
    func requestCreateChat(
        userId: String,
        onSuccess success: @escaping (_ newChat: Chat) -> Void,
        onFailure failure: @escaping (_ error: Error) -> Void,
        onNotAuthorized notAuthotized: @escaping () -> Void) {
            AF.request(
                urlStrings.base + urlStrings.chat,
                method: .post,
                parameters: [
                    RequestKeys.userId: userId
                ],
                encoding: JSONEncoding.default,
                interceptor: self
            ).validate().responseData { response in
                switch response.result {
                case .success(let data):
                    let decoder = JSONDecoder()
                    if let chat = try? decoder.decode(Chat.self, from: data) {
                        success(chat)
                    } else {
                        failure(ChatError.creatingChatFailed)
                    }
                case .failure(let error):
                    guard error.responseCode == 401 else {
                        failure(ChatError.creatingChatFailed)
                        return
                    }
                    notAuthotized()
                }
            }
        }
}
