//
//  ComposeViewController.swift
//  KxMemo
//
//  Created by D7703_23 on 2019. 6. 13..
//  Copyright © 2019년 D7703_23. All rights reserved.
//

import UIKit

class ComposeViewController: UIViewController {
    
    var editTarget: Memo?
    
    @IBOutlet weak var memoTextView: UITextView!

    @IBAction func btnClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func btnSave(_ sender: Any) {
        let memo = memoTextView.text
        
        //편집모드
        if let editTarget = editTarget {
            editTarget.content = memo
            DataManager.shared.saveContext()
        } else {
            DataManager.shared.addNewMemo(memo)
        }      
        
        dismiss(animated: true, completion: nil)
    }
    
    
    var willShowToken: NSObjectProtocol?
    var willHideToken: NSObjectProtocol?
    
    deinit{
        if let token = willShowToken {
            NotificationCenter.default.removeObserver(token)
        }
        if let token = willHideToken {
            NotificationCenter.default.removeObserver(token)
        }
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //초기화코드
        //편집모드
        if let memo = editTarget {
            navigationItem.title = "메모 편집"
            memoTextView.text = memo.content
        } else {
            navigationItem.title = "세 메모"
            memoTextView.text = ""
        }
        
        willShowToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: {[weak self] (noti) in guard let strongSelf = self else {return}
            
            if let frame = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue{
                let height = frame.cgRectValue.height
                
                var inset = strongSelf.memoTextView.contentInset
                inset.bottom = height
                strongSelf.memoTextView.contentInset = inset
                
                inset = strongSelf.memoTextView.scrollIndicatorInsets
                inset.bottom = height
                strongSelf.memoTextView.scrollIndicatorInsets = inset
            }
        })
        
        willHideToken = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
            guard let strongSelf = self else {
                return
            }
            
            var inset = strongSelf.memoTextView.contentInset
            inset.bottom = 0
            strongSelf.memoTextView.contentInset = inset
            
            inset = strongSelf.memoTextView.scrollIndicatorInsets
            inset.bottom = 0
            strongSelf.memoTextView.scrollIndicatorInsets = inset
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTextView.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        memoTextView.resignFirstResponder()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
