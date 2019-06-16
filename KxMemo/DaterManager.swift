//
//  DaterManager.swift
//  KxMemo
//
//  Created by D7703_23 on 2019. 6. 13..
//  Copyright © 2019년 D7703_23. All rights reserved.
//

import Foundation
import CoreData

class DataManager {
    static let shared = DataManager()
    private init() { }
    
    var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    //저장되어 있는 메모를 읽어오는 코드
    
    //읽어올 메모를 저장하는 변수 선언
    var memoList = [Memo]()
    
    //데이터를 가져오는 메소드
    func fetchMemo() {
        let request: NSFetchRequest<Memo> = Memo.fetchRequest()
        
        //정렬 : 날짜를 내림차순으로 정렬
        let sortByDateDesc = NSSortDescriptor(key: "insertDate", ascending: false)
        request.sortDescriptors = [sortByDateDesc]
        
        //fetch 메소드를 실행 (try catch로 예외처리)
        do {
            memoList = try mainContext.fetch(request)
        } catch {
            print(error)
        }
    }
    
    //새로운 메모 추가
    func addNewMemo(_ memo: String?) {
        let newMemo = Memo(context: mainContext)
        
        newMemo.content = memo
        newMemo.insertDate = Date()
        
        saveContext()
    }
    
    func  deleteMemo(_ memo: Memo?) {
        if let memo = memo {
            mainContext.delete(memo)
            saveContext()
        }
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "KxMemo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
