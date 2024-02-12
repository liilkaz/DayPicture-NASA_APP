//
//  DetailViewController.swift
//  DayPic
//
//  Created by Лилия Феодотова on 08.02.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailViewController: UIViewController {
    
    let detailModel: DayPictureModel
    
    private var previousStatusBarHidden = false
    
    private let scrollView = UIScrollView()
    private let textContainer = UIView()
    private let imageView = UIImageView()
    private let imageContainer = UIView()
    private let textBacking = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        
        return label
    }()
    
    private let explanation: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .regular)
        label.textColor = .white
        
        return label
    }()
    
    init(detailModel: DayPictureModel) {
        self.detailModel = detailModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setNavigationBar(title: "")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.scrollIndicatorInsets = view.safeAreaInsets
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
    }
}

private extension DetailViewController {
    func setupView() {
        view.backgroundColor = .black
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.delegate = self
        
        textContainer.backgroundColor = .clear
        textBacking.backgroundColor = .clear
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        view.addSubviews(scrollView)
        scrollView.addSubviews(imageContainer, textBacking, imageView, textContainer)
        textContainer.addSubviews(titleLabel, explanation)
        configure()
    }
    
    func configure() {
        imageView.kf.setImage(with: URL(string: detailModel.url))
        titleLabel.text = detailModel.title
        explanation.text = detailModel.explanation
    }

    func setConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
        
        textBacking.snp.makeConstraints {
            make in
            
            make.left.right.equalTo(view)
            make.top.equalTo(textContainer)
            make.bottom.equalTo(view)
        }
        
        imageContainer.snp.makeConstraints { make in

            make.top.equalTo(scrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(imageContainer.snp.width).multipliedBy(0.7)
        }
        
        imageView.snp.makeConstraints { make in

            make.left.right.equalTo(imageContainer)
            make.top.equalTo(view).priority(.high)
            make.height.greaterThanOrEqualTo(imageContainer.snp.height).priority(.required)
            
            make.bottom.equalTo(imageContainer.snp.bottom)
        }
        
        textContainer.snp.makeConstraints { make in
            make.top.equalTo(imageContainer.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(scrollView)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(textContainer).inset(20)
            make.left.right.equalTo(textContainer).inset(20)
        }
        
        explanation.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.right.equalTo(textContainer).inset(20)
            make.bottom.equalTo(textContainer).inset(20)
        }
    }
}

extension DetailViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if previousStatusBarHidden != shouldHideStatusBar {
            
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            
            previousStatusBarHidden = shouldHideStatusBar
        }
        
        if(scrollView.convert(view.frame.origin, to: self.view).y >= 0) {
            navigationController!.navigationBar.topItem!.title = ""
        } else {
            navigationController!.navigationBar.topItem!.title = detailModel.title
        }
        
    }
    
    //MARK: - Status Bar Appearance
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar: Bool {
        let frame = textContainer.convert(textContainer.bounds, to: nil)
        return frame.minY < view.safeAreaInsets.top
    }
}
