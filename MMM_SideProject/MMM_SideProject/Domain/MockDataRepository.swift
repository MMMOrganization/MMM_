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
    
    private var dateType : YearMonth = .init()
    
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
    
    // TODO: - 따로 만들지 readData() 에서 상태 비교를 통해서 할지 고민
    func readDataOfDay() -> [Entity] {
        return []
    }
    
    func readDate() -> String {
        return dateType.toString()
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
