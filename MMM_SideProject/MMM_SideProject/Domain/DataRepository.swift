//
//  DataRepository.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/15/25.
//

import UIKit
import RealmSwift
import Realm

class DataRepository : DataRepositoryInterface {
    
    private var stateType : ButtonType = .total
    private var dateType : YearMonthDay = .init()
    
    func readData() -> [Entity] {
        switch stateType {
        case .total:
            return readTotalData()
        case .income:
            return readIncomeData()
        case .expend:
            return readExpendData()
        }
    }
    
    func readData(typeName: String) -> [Entity] {
        return []
    }
    
    func readDate() -> String {
        return ""
    }
    
    func readDataOfDay() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readDataOfDay")
            return []
        }
        
        let realmData = realm.objects(UserDB.self)
        
        return realmData.where { $0.dateString == dateType.toStringYearMonthDay() }
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    func readGraphData() -> [(String, Double)] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readGraphData")
            return []
        }
        
        let userDB = realm.objects(UserDB.self).where {
            $0.createType == .expend
        }
        
        var tempDict : [String : Double] = .init()
        var resultList : [(String, Double)] = []
        
        userDB.forEach {
            if tempDict[$0.typeString] == nil {
                tempDict[$0.typeString] = 1
            }
            else {
                tempDict[$0.typeString]! += 1
            }
        }
        
        for (key, value) in tempDict.sorted(by: { $0.value > $1.value }) {
            resultList.append((key, value))
        }
        
        return resultList
    }
    
    func readAmountsDict() -> [String : Int] {
        var amountsDict : [String : Int] = .init()
        
        // TODO: - Concurrency 적용 필요
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readAmountsDict")
            return [:]
        }
        
        let realmData = realm.objects(UserDB.self)
        let uniqueDate = Set(realmData.map { $0.dateString })
        
        for dateString in uniqueDate {
            let tempDate = realmData.where {
                $0.dateString == dateString
            }
            
            // MARK: - 해당 Date의 모든 요소 값 계산 후 반환
            let tempAmount = tempDate.reduce(0) { $0 + $1.moneyAmount }
            
            amountsDict[dateString] = tempAmount
        }
        
        return amountsDict
    }
    
    func readDataForCreateCell(of type: CreateType, selectedIndex: Int) -> [CreateCellIcon] {
        return []
    }
    
    func setDate(type: DateButtonType) {
        
    }
    
    func setDate(dateStr : String) {
        
    }
    
    func setState(type: ButtonType) {
        
    }
    
    func setDay(of day: Int) {
        
    }
    
    func deleteData(id: UUID) {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error deleteData")
            return
        }
        
        try? realm.write {
            let userDB = realm.objects(UserDB.self).where {
                $0.id == id
            }
            
            realm.delete(userDB)
        }
    }
    
    func readDateList() -> [String] {
        return []
    }
}

private extension DataRepository {
    private func readTotalData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readTotalData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    private func readIncomeData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readIncomeData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .income }
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
    
    private func readExpendData() -> [Entity] {
        guard let realm = try? Realm() else {
            print("MockData - Realm Error readIncomeData")
            return []
        }
        
        let realmData = realm.objects(UserDB.self).filter("dateString BEGINSWITH '\(dateType.toStringYearMonthForRealmData())'")
            .where { $0.createType == .expend }
        
        return realmData.sorted { $0.dateString > $1.dateString }
            .map { Entity(id: $0.id, dateStr: $0.dateString, typeStr: $0.typeString , createType: $0.createType, amount: $0.moneyAmount, iconImage: $0.iconImageType.getImage) }
    }
}
