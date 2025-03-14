//
//  GraphViewController.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 1/25/25.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftUI
import RxDataSources
import DGCharts

class GraphViewController: UIViewController {
    
    var disposeBag : DisposeBag = DisposeBag()
    var viewModel : GraphViewModelInterface!
    
    lazy var toastMainViewHeight : CGFloat = 60
    lazy var toastMainViewHeightAnchor = toastMainView.heightAnchor.constraint(equalToConstant: toastMainViewHeight)
    lazy var toastMainViewBottomAnchor = toastMainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: toastMainViewHeight)
    
    let dataSource = RxTableViewSectionedAnimatedDataSource<SingleSectionModel>(configureCell: { _, graphTableView, indexPath, item in
        guard let cell = graphTableView.dequeueReusableCell(withIdentifier: DetailTableViewCell.identifier, for: indexPath) as? DetailTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(item: item)
        cell.contentView.backgroundColor = UIColor(hexCode: ColorConst.mainColorString, alpha: 0.05)
        return cell
    })
    
    lazy var dismissButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 12))
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = UIColor(hexCode: ColorConst.mainColorString)
        return button
    }()
    
    lazy var dismissButtonItem = UIBarButtonItem(customView: dismissButton)
    
    let pieChartView : PieChartView = {
        let p = PieChartView(frame: .zero)
        p.translatesAutoresizingMaskIntoConstraints = false
        return p
    }()
    
    let buttonCollectionView : UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        // TODO: - Content Size에 따라서 동적으로 ItemSize가 변해야 함.
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        let c = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        c.translatesAutoresizingMaskIntoConstraints = false
        c.showsHorizontalScrollIndicator = false
        return c
    }()
    
    lazy var headerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 300))
    
    let graphTableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let navigationTitleButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.blackColor, for: .normal)
        b.titleLabel?.font = UIFont(size: 14.0)
        return b
    }()
    
    // MARK: - Toast View
    let toastMainView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.clipsToBounds = true
        v.layer.cornerRadius = 20
        return v
    }()
    
    lazy var toastHeaderStackView : UIStackView = {
        let sv = UIStackView(arrangedSubviews: [toastHeaderLabel, toastHeaderButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fill
        sv.alignment = .fill
        return sv
    }()
    
    let toastHeaderLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .blackColor
        label.font = UIFont(size: 18.0)
        label.text = "월 선택하기"
        return label
    }()
    
    let toastHeaderButton : UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "following"), for: .normal)
        return button
    }()
    
    let toastTableView : UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    
    init(viewModel : GraphViewModelInterface) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("GraphViewController - Initializer 에러")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationController()
        setDelegate()
        setAnimate()
        setLayout()
        setReactive()
        setToastReactive()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        resignToastView()
    }
    
    func setNavigationController() {
        self.navigationItem.leftBarButtonItem = dismissButtonItem
        self.navigationItem.titleView = navigationTitleButton
    }
    
    func setDelegate() {
        pieChartView.delegate = self
        
        buttonCollectionView.dataSource = nil
        
        graphTableView.rowHeight = 65
        graphTableView.separatorStyle = .none
        graphTableView.dataSource = nil
        
        toastTableView.rowHeight = 50
        toastTableView.separatorStyle = .none
        
        toastTableView.dataSource = nil
        
        buttonCollectionView.register(TypeButtonCVCell.self, forCellWithReuseIdentifier: TypeButtonCVCell.identifier)
        graphTableView.register(DetailTableViewCell.self, forCellReuseIdentifier: DetailTableViewCell.identifier)
        toastTableView.register(DateTableViewCell.self, forCellReuseIdentifier: DateTableViewCell.identifier)
    }
    
    func setAnimate() {
        dataSource.animationConfiguration = AnimationConfiguration(
            deleteAnimation: .none
        )
    }
    
    
    
    func setLayout() {
        self.view.backgroundColor = .white
        
        headerView.addSubview(pieChartView)
        self.view.addSubview(buttonCollectionView)
        self.view.addSubview(graphTableView)
        
        self.view.addSubview(toastMainView)
        
        toastMainView.addSubview(toastHeaderStackView)
        toastMainView.addSubview(toastTableView)
        
        NSLayoutConstraint.activate([
            buttonCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            buttonCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            buttonCollectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            buttonCollectionView.heightAnchor.constraint(equalToConstant: 50),
            
            pieChartView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            pieChartView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            pieChartView.topAnchor.constraint(equalTo: self.headerView.topAnchor),
            pieChartView.heightAnchor.constraint(equalToConstant: 300),
            
            graphTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 30),
            graphTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -30),
            graphTableView.topAnchor.constraint(equalTo: self.buttonCollectionView.bottomAnchor, constant: 10),
            graphTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
        
        graphTableView.tableHeaderView = headerView
        
        // MARK: - ToastView Layout
        NSLayoutConstraint.activate([
            toastMainView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            toastMainView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            
            toastMainViewHeightAnchor,
            toastMainViewBottomAnchor,
            
            toastHeaderStackView.leadingAnchor.constraint(equalTo: self.toastMainView.leadingAnchor, constant: 15),
            toastHeaderStackView.trailingAnchor.constraint(equalTo: self.toastMainView.trailingAnchor),
            toastHeaderStackView.topAnchor.constraint(equalTo: self.toastMainView.topAnchor),
            toastHeaderStackView.heightAnchor.constraint(equalToConstant: 55),
            
            toastHeaderLabel.leadingAnchor.constraint(equalTo: self.toastHeaderStackView.leadingAnchor),
            toastHeaderLabel.centerYAnchor.constraint(equalTo: self.toastHeaderStackView.centerYAnchor),
            
            toastHeaderButton.trailingAnchor.constraint(equalTo: self.toastHeaderStackView.trailingAnchor),
            toastHeaderButton.centerYAnchor.constraint(equalTo: self.toastHeaderStackView.centerYAnchor),
            toastHeaderButton.widthAnchor.constraint(equalToConstant: 30),
            
            toastTableView.leadingAnchor.constraint(equalTo: self.toastMainView.leadingAnchor),
            toastTableView.trailingAnchor.constraint(equalTo: self.toastMainView.trailingAnchor),
            toastTableView.topAnchor.constraint(equalTo: self.toastHeaderStackView.bottomAnchor),
            toastTableView.bottomAnchor.constraint(equalTo: self.toastMainView.bottomAnchor),
        ])
    }
    
    func setReactive() {
        // MARK: - Coordinator 화면 전환 바인딩
        dismissButton.rx.tap
            .observe(on: MainScheduler.instance)
            .bind(to: viewModel.dismissButtonObserver)
            .disposed(by: disposeBag)
        
        // MARK: - Entity TableView 바인딩
        viewModel.entityDataObservable
            .observe(on: MainScheduler.instance)
            .map { [SingleSectionModel(items: $0)] }
            .bind(to: graphTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        // MARK: - Button 타입 라벨 바인딩
        viewModel.typeButtonDataObservable
            .observe(on: MainScheduler.instance)
            .bind(to: buttonCollectionView.rx.items(cellIdentifier: TypeButtonCVCell.identifier, cellType: TypeButtonCVCell.self)) { [weak self] (index, item, cell) in
                guard let self = self else { return }
                cell.configure(item: item, viewModel: viewModel)
        }.disposed(by: disposeBag)
        
        // MARK: - graphData 바인딩
        viewModel.graphDataObservable
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] eventList in
                guard let eventList = eventList.element else { return }
                guard let self = self else { return }
                self.setPieChart(eventList: eventList)
            }.disposed(by: disposeBag)
        
        viewModel.dateObservable
            .observe(on: MainScheduler.instance)
            .bind(to: navigationTitleButton.rx.title())
            .disposed(by: disposeBag)
        
        navigationTitleButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                becomeToastView()
            }.disposed(by: disposeBag)
    }
    
    
}

// MARK: - ToastView
extension GraphViewController {
    func becomeToastView() {
        toastMainViewHeight = (toastTableView.contentSize.height + toastHeaderStackView.frame.height) <= 400 ? (toastTableView.contentSize.height + toastHeaderStackView.frame.height) : 400
        
        toastMainViewHeightAnchor.constant = toastMainViewHeight
        toastMainViewBottomAnchor.constant = -10
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            view.layoutIfNeeded()
        }
    }
    
    func resignToastView() {
        self.toastMainViewBottomAnchor.constant = toastMainViewHeight
        
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let self = self else { return }
            view.layoutIfNeeded()
        }
    }
    
    func setToastReactive() {
        // MARK: - DateList Cell 바인딩
        viewModel.dateListObservable
            .observe(on: MainScheduler.instance)
            .bind(to: toastTableView.rx.items(cellIdentifier: DateTableViewCell.identifier, cellType: DateTableViewCell.self)) { (index, item, cell) in
                cell.configure(dateStr: item)
            }.disposed(by: disposeBag)
        
        // MARK: - Dismiss 버튼 탭 바인딩
        toastHeaderButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                resignToastView()
            }.disposed(by: disposeBag)
        
        // MARK: - Cell Index 클릭 바인딩
        toastTableView.rx.itemSelected
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] indexPath in
                guard let self = self else { return }
                guard let indexPath = indexPath.element else { return }
                guard let cellData = toastTableView.cellForRow(at: indexPath) as? DateTableViewCell, let dateStr = cellData.dateLabel.text else { return }
                resignToastView()
                viewModel.selectDateObserver.onNext(dateStr)
            }.disposed(by: disposeBag)
    }
}


// MARK: - ChartViewDelegate
extension GraphViewController : ChartViewDelegate {
    func setPieChart(eventList : [(String, Double)]) {
        var entryList : [PieChartDataEntry] = []
        
        eventList.forEach {
            entryList.append(PieChartDataEntry(value: $0.1, label: $0.0))
        }
        
        let dataSet = PieChartDataSet(entries: entryList, label: "")
        
        // 🎨 각 조각별 색상
        
        var dataSetColors : [UIColor] = []
        for _ in 0..<dataSet.count {
            dataSetColors.append(UIColor.randomColor)
        }
        
        dataSet.colors = dataSetColors
        dataSet.sliceSpace = 5
        
        var buttonDataList = [(String, UIColor)]()
        
        for i in 0..<eventList.count {
            buttonDataList.append((eventList[i].0, dataSetColors[i]))
        }
        
        viewModel.typeButtonDataObserver.onNext(buttonDataList)
        
        // 🥯 도넛 형태 만들기 (원형 비율 조정)
        pieChartView.holeRadiusPercent = 0.25  // 중앙 구멍 크기
        pieChartView.transparentCircleRadiusPercent = 0.65  // 반투명한 원 크기
        
        // 구멍 근처에 있는 흰색 없애기
        pieChartView.transparentCircleColor = .clear
        
        // 🏷️ 라벨 위치 설정 (도넛 차트에 적합하게)
        dataSet.xValuePosition = .insideSlice  // 라벨을 내부에 표시
        dataSet.yValuePosition = .insideSlice  // 값도 내부에 표시
        
        // 클릭시에 효과 제거
        dataSet.selectionShift = 0
        
        // 라벨 스타일
        let data = PieChartData(dataSet: dataSet)
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.multiplier = 1
        data.setValueFormatter(DefaultValueFormatter(formatter: formatter))
        
        // 라벨 색상
        data.setValueTextColor(.blackColor.withAlphaComponent(0.7))
        data.setValueFont(UIFont(size: 16.0)) // 라벨 폰트
        
        pieChartView.data = data
        
        // 기타 설정
        pieChartView.legend.enabled = false  // 범례 숨기기
        pieChartView.animate(xAxisDuration: 1.0, yAxisDuration: 1.0)  // 애니메이션 효과
    }
}
