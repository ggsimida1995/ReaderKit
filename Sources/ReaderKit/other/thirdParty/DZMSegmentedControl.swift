import UIKit

// 滑条宽度自适应填充
let DZMSegmentedControlSliderWidthFill: CGFloat = -1

// 代理协议
@objc protocol DZMSegmentedControlDelegate: AnyObject {
    @objc optional func segmentedControl(_ segmentedControl: DZMSegmentedControl, clickIndex: Int)
    @objc optional func segmentedControl(_ segmentedControl: DZMSegmentedControl, scrollIndex: Int)
}

// DZMSegmentedControl 类
class DZMSegmentedControl: UIView {
    weak var delegate: DZMSegmentedControlDelegate?
    var normalFont: UIFont = .systemFont(ofSize: 14)
    var selectFont: UIFont = .boldSystemFont(ofSize: 16)
    var normalColor: UIColor = .gray
    var selectColor: UIColor = .red
    var sliderColor: UIColor = .red
    var sliderHeight: CGFloat = 2
    var sliderBottom: CGFloat = 0
    var sliderWidth: CGFloat = DZMSegmentedControlSliderWidthFill
    var itemSpace: CGFloat = 0
    var insets: UIEdgeInsets = .zero
    private(set) var selectIndex: Int = -1

    private var items: [UIButton] = []
    private var sliderView: UIView = {
        let view = UIView()
        return view
    }()
    private weak var selectItem: UIButton?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupDefaults()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupDefaults()
    }

    private func setupDefaults() {
        addSubview(sliderView)
    }

    // 刷新列表
    func reloadTitles(_ titles: [String]) {
        reloadTitles(titles, index: 0)
    }

    // 刷新列表 并 选中指定按钮
    func reloadTitles(_ titles: [String], index: Int) {
        if titles.isEmpty { return }

        items.forEach { $0.removeFromSuperview() }
        items.removeAll()

        for (i, title) in titles.enumerated() {
            let item = UIButton(type: .custom)
            item.tag = i
            item.setTitle(title, for: .normal)
            item.setTitle(title, for: .selected)
            items.append(item)
            addSubview(item)
            item.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
        }

        scrollIndex(index, animated: false)
        reloadUI()
    }

    // 选中索引
    func scrollIndex(_ index: Int, animated: Bool) {
        selectItem(index)
        if selectIndex == index { return }
        selectIndex = index

        let updateBlock = {
            self.sliderView.frame = CGRect(x: self.selectItem!.center.x - self.sliderView.frame.size.width / 2,
                                           y: self.frame.size.height - self.sliderHeight + self.sliderBottom,
                                           width: self.sliderView.frame.size.width,
                                           height: self.sliderHeight)
        }

        if animated {
            UIView.animate(withDuration: 0.2, animations: updateBlock)
        } else {
            updateBlock()
        }

        delegate?.segmentedControl?(self, scrollIndex: index)
    }

    // 选中按钮
    private func selectItem(_ index: Int) {
        selectItem?.isSelected = false
        selectItem?.titleLabel?.font = normalFont

        let item = items[index]
        item.isSelected = true
        item.titleLabel?.font = selectFont
        selectItem = item
    }

    // 刷新当前页面布局
    func reloadUI() {
        let count = items.count
        if count == 0 { return }

        let itemW = ((frame.size.width - insets.left - insets.right) - (CGFloat(count - 1) * itemSpace)) / CGFloat(count)
        let itemH = frame.size.height - insets.top - insets.bottom

        for (i, item) in items.enumerated() {
            let itemX = insets.left + CGFloat(i) * (itemW + itemSpace)
            let itemY = insets.top
            item.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)

            item.titleLabel?.font = item.isSelected ? selectFont : normalFont
            item.setTitleColor(normalColor, for: .normal)
            item.setTitleColor(selectColor, for: .selected)
        }

        let sliderWidth = sliderWidth < 0 ? frame.size.width : sliderWidth
        let finalSliderWidth = min(sliderWidth, itemW)
        sliderView.backgroundColor = sliderColor
        sliderView.frame = CGRect(x: selectItem!.center.x - finalSliderWidth / 2,
                                  y: frame.size.height - sliderHeight + sliderBottom,
                                  width: finalSliderWidth,
                                  height: sliderHeight)
    }

    // 滑动滑条
    func scrollSlider(_ scrollView: UIScrollView) {
        // 暂时不支持，待开发
    }

    @objc private func clickItem(_ item: UIButton) {
        if selectIndex == item.tag { return }
        scrollIndex(item.tag, animated: true)
        delegate?.segmentedControl?(self, clickIndex: item.tag)
    }
}