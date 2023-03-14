//
//  TransitionModel.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/05.
//

import Foundation

//전환 방식들
enum TransitionStyle {
    case root
    case push
    case modal
}

//화면 전환시 발생할 문제 에러 형식
enum TransitionError: Error {
    case navigationControllerMissing
    case cnnotPop
    case unknown
}

