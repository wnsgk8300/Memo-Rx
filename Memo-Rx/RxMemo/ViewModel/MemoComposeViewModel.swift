//
//  MemoComposeViewModel.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/05.
//

import Foundation
import RxSwift
import RxCocoa
import Action

// 새로운 메모 추가, 메모 편집
class MemoComposeViewModel: CommonViewModel {
    private let content: String?
    
    var initialText: Driver<String?> {
        return Observable.just(content).asDriver(onErrorJustReturn: nil)
    }
    
    let saveAction: Action<String, Void>
    let cancelAction: CocoaAction
    
    init(title: String, content: String? = nil, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType, saveAction: Action<String, Void>? = nil, cancelAction: CocoaAction? = nil) {
        self.content = content\
        self.saveAction = Action<String, Void> { input in
            if let action = saveAction {
                action.execute(input)
            }\
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        self.cancelAction = CocoaAction {
            if let action = cancelAction {
                action.execute(())
            }
            return sceneCoordinator.close(animated: true).asObservable().map { _ in }
        }
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
}
