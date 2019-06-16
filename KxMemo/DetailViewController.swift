//
//  DetailViewController.swift
//  KxMemo
//
//  Created by D7703_23 on 2019. 6. 13..
//  Copyright © 2019년 D7703_23. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var memoTableView: UITableView!
    
    let formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateStyle = .long
        f.timeStyle = .medium
        f.locale = Locale(identifier: "Ko_kr")
        return f
    }()
    
    //memo에 저장
    var memo: Memo?
    
    //메모 삭제
    @IBAction func deleteMemo(_ sender: Any) {
        let alert = UIAlertController(title: "삭제 확인", message: "메모를 삭제할까요?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) {
            (action) in
            DataManager.shared.deleteMemo(self.memo)
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(deleteAction)
        
        let cancleAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancleAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func share(_ sender: Any) {
        guard let memo = memo?.content else{
            return
        }
        let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil); present(vc, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination.children.first as? ComposeViewController {
            vc.editTarget = memo
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memoTableView.reloadData()
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

extension DetailViewController : UITableViewDataSource {
    
    //표시할 셀 숫자
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //어떤 데이터를 표시할지
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "memoCell", for: indexPath)
            
            cell.textLabel?.text = memo?.content
            
            return cell
        case 1 :
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateCell", for: indexPath)
            
            cell.textLabel?.text = formatter.string(for: memo?.insertDate)
            
            return cell
        default:
            fatalError()
        }
    }
    
    
}
