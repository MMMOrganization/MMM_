//
//  TypeButtonCVCell.swift
//  MMM_SideProject
//
//  Created by 강대훈 on 3/4/25.
//

import UIKit
import RxSwift
import RxCocoa

final class TypeButtonCVCell: UICollectionViewCell {
    
    static let identifier = "TypeCell"
    
    var disposeBag : DisposeBag = .init()
    
    lazy var typeButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitleColor(.blackColor, for: .normal)
        b.titleLabel?.font = UIFont(size: 14)
        b.clipsToBounds = true
        b.layer.borderWidth = 2
        b.layer.cornerRadius = 14.5
        b.layer.borderColor = UIColor.mainColor.cgColor
        b.setTitle("타입", for: .normal)
        return b
    }()
    
    func configure(item: (String, UIColor), viewModel : GraphViewModelInterface) {
        disposeBag = .init()
        
        typeButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                viewModel.typeButtonTapObserver.onNext(item.0)
            }.disposed(by: disposeBag)
        
        typeButton.setTitle(item.0, for: .normal)
        typeButton.layer.borderColor = item.1.cgColor
        typeButton.backgroundColor = item.1.withAlphaComponent(0.1)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = .init()
    }
    
    // MARK: - 셀에 레이아웃 객체가 제공하는 속성을 수정할 수 있는 기회를 제공합니다.
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        // layoutAttributes -> 레이아웃 객체가 제공하는 속성, 레이아웃이 셀에 적용하려는 값을 나타냄.
        let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
        
        // ContentSize의 크기는 54라는 최소 값을 가지고, 넘으면 10의 여백을 가지고 typeButton의 intrinsicContentSize 너비를 가진다.
        
        attributes.frame.size.width = typeButton.intrinsicContentSize.width > 54 ? typeButton.intrinsicContentSize.width : 54
        
        attributes.frame.size.height = 50
        
        return attributes
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLayout() {
        contentView.addSubview(typeButton)
        
        NSLayoutConstraint.activate([
            typeButton.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            typeButton.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            typeButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 54),
            typeButton.heightAnchor.constraint(equalToConstant: 29),
        ])
    }
    
    deinit {
        print("TypeButtonCVCell - 메모리 해제")
    }
}
