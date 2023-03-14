//
//  MemoDetailViewController.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/05.
//

import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class MemoDetailViewController: UIViewController, ViewModelBindableType {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    var viewModel: MemoDetailViewModel!
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.contents
            .bind(to: contentTableView.rx.items) { tableView, row, value in
                switch row {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "contentCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        
        editButton.rx.action = viewModel.makeEditAction()
        
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance) 
            .withUnretained(self)
            .subscribe(onNext: {(vc, _) in
                let memo = self.viewModel.memo.content //vc로 해결이 안됨. 수정 필요
                let activityVC = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self.present(activityVC, animated: true)
            }).disposed(by: rx.disposeBag)
        
        deleteButton.rx.action = viewModel.makeDeleteAction()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
}
