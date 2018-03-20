//
//  File.swift
//  Empty
//
//  Created by bsidesoft on 2018. 3. 8..
//  Copyright © 2018년 com.bsidesoft.ios. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController{

	static private let navStack = NSMutableDictionary()

    @discardableResult
	func pushRouter(_ c: UIViewController, _ type: Router.type) -> Int {

        let stack = (UIViewController.navStack[hash] as? NSMutableArray) ?? NSMutableArray.init()
        UIViewController.navStack[hash] = stack

        if case .replace = type {
            stack.removeLastObject()
            stack.removeLastObject()
        }

        switch (self, type) {

        // UINavigationController
        case (let base as UINavigationController, .replace):
            base.viewControllers = base.viewControllers.dropLast() + [c]

        // UIViewController
        case (_, .replace):
            if let last = stack.lastObject as? UIViewController {
                last.removeFromParentViewController()
                last.view.removeFromSuperview()
            }
            addChildViewController(c)
            view.addSubview(c.view)

        case (_, .add):
            addChildViewController(c)
            view.addSubview(c.view)

        case (_, .cover):  // viewcontroller의 라이프사이클을 강제호출해준다.
            if let last = stack.lastObject as? UIViewController {
                last.viewDidDisappear(false)
            }

            if let nv = self as? UINavigationController {
                nv.viewControllers.last?.addChildViewController(c)
//                addChildViewController(c)
//                nv.viewControllers = nv.viewControllers + [c]
                nv.viewControllers.last?.view?.addSubview(c.view)
            } else {
                addChildViewController(c)
                view.addSubview(c.view)
            }



        }

        stack.add(type) // !주의 - 2번 빼야 함..
        stack.add(c)

        return stack.count - 1

	}


	func popRouter(){

        let stack = (UIViewController.navStack[hash] as? NSMutableArray) ?? NSMutableArray.init()
        guard let c = stack.lastObject as? UIViewController else { return }

        stack.remove(c)
        let type = stack.lastObject as! Router.type
        stack.remove(type)

        if case .cover = type, let last = stack.lastObject as? UIViewController {
            last.viewWillAppear(false)
        }

        switch (self) {
        case (let base as UINavigationController):
            base.viewControllers = base.viewControllers.dropLast() + []
        default:
            c.removeFromParentViewController()
            c.view.removeFromSuperview()
        }

	}

    func removeRouter(_ idx: Int) {

        guard let stack = UIViewController.navStack[hash] as? NSMutableArray else { return }
        guard stack.count > idx else { return }

        var isCover = false
        var idx = idx
        while idx < stack.count {
            if let vc = stack.object(at: idx) as? UIViewController,
               let type = stack.object(at: idx - 1) as? Router.type {

                switch (self, type) {
                case (let base as UINavigationController, .replace):
                    base.viewControllers = base.viewControllers.dropLast() + []
                default:
                    if case .cover = type {
                        isCover = true
                    }
                    vc.removeFromParentViewController()
                    vc.view.removeFromSuperview()
                }
                stack.remove(vc)
                stack.remove(type)
            }
            idx += 2
        }

        if isCover, let last = stack.lastObject as? UIViewController {
            last.viewWillAppear(false)
        }

    }
}