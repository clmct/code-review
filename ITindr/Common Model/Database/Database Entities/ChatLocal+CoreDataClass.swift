//
//  ChatLocal+CoreDataClass.swift
//  ITindr
//
//  Created by Эдуард Логинов on 02.12.2021.
//
//

import Foundation
import CoreData

public class ChatLocal: NSManagedObject {
    static func getOrCreate(from domainChat: Chat, context: NSManagedObjectContext) -> ChatLocal {
        let request = ChatLocal.fetchRequest()
        request.predicate = NSPredicate(format: "id == \"\(domainChat.id)\"")
    
        guard let localChat = try? context.fetch(request).first else {
            return create(from: domainChat, context: context)
        }
        
        localChat.update(with: domainChat)
        return localChat
    }
    
    static func create(from domainChat: Chat, context: NSManagedObjectContext) -> ChatLocal {
        let localChat = ChatLocal(context: context)
        localChat.update(with: domainChat)
        return localChat
    }
    
    func update(with domainChat: Chat) {
        id = domainChat.id
        title = domainChat.title
        avatar = domainChat.avatar
    }
    
    func toDomainModel() -> Chat? {
        return Chat(id: id ?? "", title: title ?? "", avatar: avatar)
    }
}
