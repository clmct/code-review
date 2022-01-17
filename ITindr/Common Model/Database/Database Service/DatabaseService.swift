//
//  DatabaseService.swift
//  ITindr
//
//  Created by Эдуард Логинов on 01.12.2021.
//

import Foundation
import CoreData

class DatabaseService {
    
    // MARK: Properties
    static var shared = DatabaseService()
    
    private let context: NSManagedObjectContext
    
    // MARK: Init
    private init() {
        let container = NSPersistentContainer(name: "CacheDatabase")
        container.loadPersistentStores { _, error in
            if let error = error {
                print(String(describing: error))
            }
        }
        context = container.viewContext
    }
    
    // MARK: Private Methods
    private func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                context.rollback()
                fatalError(String(describing: error))
            }
        }
    }
}

// MARK: People
extension DatabaseService {
    func getPeopleList() -> [User] {
        let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userId) ?? ""
        return UserLocal.getDomainUsers(withoutId: userId, context: context)
    }
    
    @discardableResult
    func updatePeopleList(withContest contest: [User]) -> [UserLocal] {
        let updatedPeople = UserLocal.updateOrCreate(fromContest: contest, context: context)
        saveContext()
        return updatedPeople
    }
}

// MARK: Chats List
extension DatabaseService {
    func getChatsList() -> [ChatListItem] {
        return ChatListItemLocal.getDomainItems(context: context)
    }
    
    @discardableResult
    func updateChatsList(withContest contest: [ChatListItem]) -> [ChatListItem] {
        let localChatItems = ChatListItemLocal.updateOrCreate(fromContest: contest, context: context)
        saveContext()
        return localChatItems.sorted { item1, item2 in
            return Date.isIncreasingDateOrder(date1: item1.lastMessage?.createdAt,
                                              date2: item2.lastMessage?.createdAt)
        }.compactMap { $0.toDomainModel() }
    }
}

// MARK: Messages
extension DatabaseService {
    func getMessages(forChat chatId: String) -> [Message] {
        return MessageLocal.getDomainMessages(forChat: chatId, context: context)
    }
    
    func updateMessages(withContest domainMessages: [Message],
                        forChat chatId: String) -> [Message] {
        let localMessages = MessageLocal.updateOrCreate(fromContest: domainMessages,
                                                        chatId: chatId,
                                                        context: context)
        saveContext()
        return localMessages.sorted { message1, message2 in
            return Date.isIncreasingDateOrder(date1: message1.createdAt,
                                             date2: message2.createdAt)
        }.compactMap { $0.toDomainModel() }
    }
}

// MARK: Profile
extension DatabaseService {
    func getProfile() -> User? {
        let userId = UserDefaults.standard.string(forKey: UserDefaultsKeys.userId) ?? ""
        return UserLocal.get(fromId: userId, context: context)?.toDomainModel()
    }
    
    @discardableResult
    func updateProfile(with domainProfile: User) -> UserLocal {
        let profile = UserLocal.updateOrCreate(from: domainProfile, context: context)
        saveContext()
        return profile
    }
}

// MARK: Topics
extension DatabaseService {
    func getTopics() -> [Topic] {
        return TopicLocal.getDomainTopics(context: context)
    }
    
    @discardableResult
    func updateTopics(with newTopics: [Topic]) -> [TopicLocal] {
        let localTopics = TopicLocal.updateOrCreate(fromContest: newTopics, context: context)
        saveContext()
        return localTopics
    }
}
