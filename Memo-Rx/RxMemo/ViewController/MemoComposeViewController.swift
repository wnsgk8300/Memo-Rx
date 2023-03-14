//
//  MemoComposeViewController.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoComposeViewController: UIViewController, ViewModelBindableType {
    
    
    
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem! //혹시 확인하기
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var viewModel: MemoComposeViewModel!
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.initialText
            .drive(contentTextView.rx.text)
            .disposed(by: rx.disposeBag)
        
        cancelButton.rx.action = viewModel.cancelAction
        
        saveButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) //더블탭 방지
            .withLatestFrom(contentTextView.rx.text.orEmpty) //textview에 입력된 텍스트 방출
            .bind(to: viewModel.saveAction.inputs) // 방출된 텍스트 saveAction의 inputs로 바인딩
            .disposed(by: rx.disposeBag)
        
        let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue }
            .map { $0.cgRectValue.height } //키보드 높이
           
        let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
            .map { noti -> CGFloat in 0 }
        
        let keyboardObservable = Observable.merge(willShowObservable, willHideObservable)
            .share()
        
        keyboardObservable
        // 개선 전
//            .withUnretained(contentTextView)
//            .subscribe(onNext: { tv, height in
//                var inset = tv.contentInset
//                inset.bottom = height
//                tv.contentInset = inset
//
//                var scrollInset = tv.verticalScrollIndicatorInsets
//                scrollInset.bottom = height
//                tv.verticalScrollIndicatorInsets = scrollInset
//            })
        // 개선 후
            .toContentInset(of: contentTextView)
            .bind(to: contentTextView.rx.contentInset) //RxSwift6부터 자동으로 bind가능해짐]
            .disposed(by: rx.disposeBag)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentTextView.becomeFirstResponder()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if contentTextView.isFirstResponder {
            contentTextView.resignFirstResponder()
        }
    }
}

extension ObservableType where Element == CGFloat {
    func toContentInset(of textView: UITextView) -> Observable<UIEdgeInsets> {
        return map { height in
            var inset = textView.contentInset
            inset.bottom = height
            return inset
        }
    }
}
