//
//  MemoStorageType.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/02.
//

import Foundation
import RxSwift

protocol MemoStorageType {
    
    @discardableResult //작업 결과가 필요 없는 경우도 있으므로
    func createMemo(content: String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[MemoSectionModel]>
    
    @discardableResult
    func update(memo: Memo, content: String) -> Observable<Memo>
    
    @discardableResult
    func delete(memo: Memo) -> Observable<Memo>
}
