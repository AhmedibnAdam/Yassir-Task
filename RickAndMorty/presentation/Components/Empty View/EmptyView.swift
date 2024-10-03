//
//  EmptyView.swift
///  RickAndMorty
//
//  Created by Ahmad on 02/10/2024.
//

import UIKit

class EmptyView: UIView {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet var parentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
        nibSetup()
    }

    override func prepareForInterfaceBuilder() {
        nibSetup()
    }

    // MARK: Config
    func configureView(emptyViewData: EmptyListView) {
        titleLabel.text = emptyViewData.title
        imageView.image = emptyViewData.image
    }

    func setUI() {

    }

    private func loadViewFromNib() -> UIView {
       let bundle = Bundle(for: type(of: self))
       let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
       let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
       return nibView
     }

    private func nibSetup() {
        backgroundColor = .clear
        parentView = loadViewFromNib()
        parentView.frame = bounds
        parentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        parentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(parentView)
        setUI()
    }
}
