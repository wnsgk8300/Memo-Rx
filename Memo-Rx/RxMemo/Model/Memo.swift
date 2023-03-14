//
//  Memo.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/02.
//

import Foundation
import RxDataSources //tableView, collectioView에 바인딩할 수 있는 DataSources
import CoreData
import RxCoreData

// RxDataSources에 저장되는 모든 데이터는 반드시 IdentifiableType프로토콜을 채용해야함
// IdentifiableType는 identity가 선언되어있고 Hashable형식임
// 여기서는 identity를 선언했고, String은 hashable프로토콜을 채용한 형식이므로 모든 조건 충족함
struct Memo: Equatable, IdentifiableType {
    var content: String
    var insertData: Date
    var identity: String
    
    init(content: String, insertData: Date = Date()) {
        self.content = content
        self.insertData = insertData
        self.identity = "\(insertData.timeIntervalSinceReferenceDate)"
    }
    
    // 업데이트된 내용으로 새로운 메모 인스턴스 생성
    init(original: Memo, updatedContent: String) {
        self = original
        self.content = updatedContent
    }
}

extension Memo: Persistable {
    static var entityName: String {
        return "Memo"
    }
    
    static var primaryAttributeName: String {
        return "identity"
    }
    init(entity: NSManagedObject) {
        content = entity.value(forKey: "content") as! String
        insertData = entity.value(forKey: "insertDate") as! Date
        identity = "\(insertData.timeIntervalSinceReferenceDate)"
    }
    func update(_ entity: NSManagedObject) {
        entity.setValue(content, forKey: "content")
        entity.setValue(insertData, forKey: "insertDate")
        entity.setValue("\(insertData.timeIntervalSinceReferenceDate)", forKey: "identity")
        
        do {
            try entity.managedObjectContext?.save() //RxCoreData를 사용하지 않고, CoreData가 제공하는 기본기능을 사용했기때문에 save를 따로 처리해주어야 함
        } catch {
            print(error)
        }
    }
}
