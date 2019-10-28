import UIKit


final class DividerView: UIView {

    init(text: String, color: UIColor) {
        super.init(frame: .zero)

        let leftLine = UIView()
        leftLine.backgroundColor = color
        leftLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(leftLine)

        let label = UILabel()
        let attributes: [NSAttributedString.Key : Any] = [
            .foregroundColor: color
        ]
        label.attributedText = NSAttributedString(string: "or", attributes: attributes)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        let rightLine = UIView()
        rightLine.backgroundColor = color
        rightLine.translatesAutoresizingMaskIntoConstraints = false
        addSubview(rightLine)

        let constraints: [NSLayoutConstraint] = [
            leftLine.heightAnchor.constraint(equalToConstant: 1.0),
            leftLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            leftLine.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftLine.trailingAnchor.constraint(equalTo: label.leadingAnchor, constant: -Constants.raster),

            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),

            rightLine.heightAnchor.constraint(equalToConstant: 1.0),
            rightLine.centerYAnchor.constraint(equalTo: centerYAnchor),
            rightLine.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: Constants.raster),
            rightLine.trailingAnchor.constraint(equalTo: trailingAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
