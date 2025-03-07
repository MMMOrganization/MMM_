//
//  MockDataRepository.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/17/25.
//

import UIKit

class MockDataRepository : DataRepositoryInterface {
    
    // MARK: - CalendarVM 에서 사용하는 repository에서는 항상 total 타입
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
    
    // MARK: - CalendarVC 에서는 항상 totalData와 하루의 데이터만 사용하기 때문에 이 함수를 사용한다.
    /// For Calendar Function
    /// 하루치에 해당하는 데이터를 가져와야 함.
    func readDataOfDay() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: dateType.toStringYearMonth(), createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: dateType.toStringYearMonth(), createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: dateType.toStringYearMonth(), createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!),
        ]
    }
    
    func readData(typeName : String, color : UIColor = .clear) -> [Entity] {
        // TODO: - Date 기준으로 typeName 을 가져와서 데이터를 뽑아줘야 함.
        return [Entity(id: UUID(), dateStr: "2025-03-12", createType: .expend, amount: 12000, iconImage: UIImage(systemName:            "heart")!, color: color),
                Entity(id: UUID(), dateStr: "2025-03-12", createType: .expend, amount: 12000, iconImage: UIImage(systemName: "heart")!, color: color),
            Entity(id: UUID(), dateStr: "2025-03-12", createType: .expend, amount: 12000, iconImage: UIImage(systemName: "heart")!, color: color),
            Entity(id: UUID(), dateStr: "2025-03-12", createType: .expend, amount: 12000, iconImage: UIImage(systemName: "heart")!, color: color),
            Entity(id: UUID(), dateStr: "2025-03-12", createType: .expend, amount: 12000, iconImage: UIImage(systemName: "heart")!, color: color),]
    }
    
    func readDate() -> String {
        return dateType.toStringYearMonth()
    }
    
    func readAmountsDict() -> [String : Int] {
        var amountsDict : [String : Int] = .init()
        
        amountsDict["2025-01-01"] = Int.random(in: -10000...10000)
        amountsDict["2025-01-05"] = Int.random(in: -10000...10000)
        amountsDict["2025-01-08"] = Int.random(in: -10000...10000)
        amountsDict["2025-01-14"] = Int.random(in: -10000...10000)
        amountsDict["2025-01-18"] = Int.random(in: -10000...10000)
        amountsDict["2025-01-22"] = Int.random(in: -10000...10000)
        
        return amountsDict
    }
    
    func readGraphData() -> [(String, Double)] {
        // TODO: - date를 받아서 해당 date에 맞는 데이터를 디비에서 가져옴
        // 디비에서 받아온 데이터를 타입마다 분류하여 전달함.
        
        return [("기타",12.0),
                ("용돈",1.0),
                ("음주",5.0),
                ("음식",7.0),
                ("커피",10.0),
                ("하이",7.0)]
    }
    
    func readDataForCreateCell(of type : CreateType, selectedIndex : Int) -> [CreateCellIcon] {
        switch type {
        case .expend:
            return CreateCellIcon.readExpendData(at : selectedIndex)
        case .income:
            return CreateCellIcon.readIncomeData(at : selectedIndex)
        default:
            return []
        }
    }
    
    func setState(type : ButtonType) {
        switch type {
        case .total:
            stateType = .total
        case .income:
            stateType = .income
        case .expend:
            stateType = .expend
        }
    }
    
    func setDate(type : DateButtonType) {
        switch type {
        case .increase:
            dateType.increase()
            return
        case .decrease:
            dateType.decrease()
            return
        }
    }
    
    func setDay(of day : Int) {
        self.dateType.setDay(of: day)
    }
}

private extension MockDataRepository {
    private func readTotalData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-10-23", createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-24", createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-28", createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-31", createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-10-15", createType: .total, amount: 12000, iconImage: UIImage(named: "DateImage")!)
        ]
    }
    
    private func readIncomeData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-11-25", createType: .income, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-23", createType: .income, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-27", createType: .income, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-29", createType: .income, amount: 12000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-11-30", createType: .income, amount: 12000, iconImage: UIImage(named: "DateImage")!)
        ]
    }
    
    private func readExpendData() -> [Entity] {
        return [
            Entity(id: UUID(), dateStr: "2024-12-12", createType: .expend, amount: -13000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-23", createType: .expend, amount: -15000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-23", createType: .expend, amount: -18000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-23", createType: .expend, amount: -11000, iconImage: UIImage(named: "DateImage")!),
            Entity(id: UUID(), dateStr: "2024-12-11", createType: .expend, amount: -13000, iconImage: UIImage(named: "DateImage")!)
        ]
    }
}

// TODO: -
