//
//  MemoDetailViewModel.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/05.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel: CommonViewModel {
    
    var memo: Memo
    
    private var formatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_kr")
        f.dateStyle = .medium
        f.timeStyle = .medium
        return f
    }()
    
    // 메모보기 화면에서 편집버튼 누른다음 메모 편집하고, 다시 메모보기 화면으로 돌아오면 편집한 내용이 반영되어야함
    // 그러기 위해서는 새로운 문자열 배열을 방출해야한다. 때문에 BehaviorSubject 사용
    var contents: BehaviorSubject<[String]>
    
    init(memo: Memo, title: String, sceneCoordinator: SceneCoordinatorType, storage: MemoStorageType) {
        self.memo = memo
        contents = BehaviorSubject<[String]>(value: [
            memo.content,
            formatter.string(from: memo.insertData)
        ])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
    }
    
   lazy var popAction = CocoaAction { [unowned self] in
       return self.sceneCoordinator.close(animated: true)
           .asObservable()
           .map { _ in }
   }
    
    // createMemo로 내용없는 메모 생성하고 저장하면, 여기서 입력한 메모로 업데이트
    func performUpdate(memo: Memo) -> Action<String, Void> {
        return Action { input in
            self.storage.update(memo: memo, content: input)
                .do(onNext: {self.memo = $0})
                .map { [$0.content, self.formatter.string(from: $0.insertData)]}
                .bind(onNext: { self.contents.onNext($0)})
                .disposed(by: self.rx.disposeBag)
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let composeViewModel = MemoComposeViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let composeScene = Scene.compose(composeViewModel)
            
            return self.sceneCoordinator.transition(to: composeScene, using: .modal, animated: true)
                .asObservable()
                .map { _ in }
        }
    }
    
    func makeDeleteAction() -> CocoaAction {
        return Action { input in
            self.storage.delete(memo: self.memo)
            return self.sceneCoordinator.close(animated: true)
                .asObservable()
                .map { _ in }
        }
    }
}
