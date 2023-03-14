//
//  Scene.swift
//  RxMemo
//
//  Created by JEON JUNHA on 2023/02/05.
//

import UIKit

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case compose(MemoComposeViewModel)
}

extension Scene {
    func instantiat(from storyboard: String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        
        switch self {
        case .list(let memoListViewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNav") as? UINavigationController else { fatalError() }
            guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError() }
            
            // large title이 처음부터 적용되지 않는문제 해결
            DispatchQueue.main.async {
                listVC.bind(viewModel: memoListViewModel)
            }
            return nav
            
        case .detail(let memoDetailViewModel):
            guard var detailVC = storyboard.instantiateViewController(withIdentifier: "DetailVC") as? MemoDetailViewController else { fatalError() }
            DispatchQueue.main.async {
                detailVC.bind(viewModel: memoDetailViewModel)
            }
            return detailVC
            
        case .compose(let memoComposeViewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController else { fatalError() }
            guard var composeVC = nav.viewControllers.first as? MemoComposeViewController else { fatalError() }
            DispatchQueue.main.async {
                composeVC.bind(viewModel: memoComposeViewModel)
            }
            return nav
        }
    }
}
