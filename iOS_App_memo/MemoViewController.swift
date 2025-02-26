//
//  MemoViewController.swift
//  iOS_App_memo
//
//  Created by NH on 2/26/25.
//

import UIKit

class MemoViewController: UIViewController {
    @IBOutlet weak var myTableView: UITableView!
    
    var memoList: [String] = [] // 사용자에게 입력받은 메모 데이터를 배열에 저장
    let userDefaultsKey = "memoList" // 저장한 데이터를 불러오기 위해 사용하는 키 값
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myTableView.delegate = self
        myTableView.dataSource = self
        
        loadMemos() // 메모 데이터 로드
    }
    
    // + 버튼 터치 시, 메모 입력 기능
    @IBAction func didTapAddMemo(_ sender: Any) {
        let alert = UIAlertController(title: "새 메모", message: "메모 내용을 입력하세요.", preferredStyle: .alert) // 알림창을 이용해 사용자에게 새 매모를 입력하라는 창을 띄움
        alert.addTextField() // 알림창에 TextField 형태로 사용자에게 입력을 받음
        
        let addMemo = UIAlertAction(title: "추가", style: .default) { _ in
            
            if let text = alert.textFields?.first?.text, !text.isEmpty {
                self.memoList.append(text) // 메모 추가
                self.saveMemos() // 메모 데이터 저장
                self.myTableView.reloadData() // 추가한 메모 데이터를 UI에 업데이트
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        alert.addAction(addMemo)
        alert.addAction(cancel)

        self.present(alert, animated: true, completion: nil)
    }
    
    // 메모 데이터 저장
    func saveMemos() {
        UserDefaults.standard.set(memoList, forKey: userDefaultsKey)
        }
    
    // 메모 데이터 불러오기
    func loadMemos() {
        if let savedMemos = UserDefaults.standard.array(forKey: userDefaultsKey) as? [String] {
            memoList = savedMemos
        }
    }
    
}

extension MemoViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoTableViewCell", for: indexPath)
        let memo = memoList[indexPath.row]
        
        cell.textLabel?.text = memo
        
        return cell
    }
}

extension MemoViewController: UITableViewDelegate{
    // 스와이프 액션으로 메모 제거
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            memoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

