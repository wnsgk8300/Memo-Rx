//
//  SceneCoordinatorType.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/05.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    // 파라미터로 대상 scene과 style, animated전달
    // Completable: 여기에 구독차를 추가하고, 화면 전환이 완료된 후에 원하는 작업을 구현할 수 있다 , 필요 없으면 사용 안해도 됨
    // @discardableResult: return되는 completable을 사용하지 않더라도 경고 발생 안함
    @discardableResult
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable
    
    @discardableResult
    func close(animated: Bool) -> Completable
}
