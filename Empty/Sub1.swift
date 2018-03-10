//
//  Sub1.swift
//  Empty
//
//  Created by bsidesoft on 2018. 3. 11..
//  Copyright © 2018년 com.bsidesoft.ios. All rights reserved.
//

import Foundation
import UIKit

class Sub1: UIViewController {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.blue
		let btn = UIButton(type: UIButtonType.system)
		btn.frame = CGRect(x:50, y:100, width:150, height:30)
		btn.setTitle("sub1 button", for: UIControlState.normal)
		btn.center = CGPoint(x:self.view.frame.size.width / 2, y:100)
		btn.addTarget(.touchUpInside){
			Router.get("main")?.route(self.parent!, Router.type.replace).with("sub2")
		}
		view.addSubview(btn)
	}
}
