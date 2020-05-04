import UIKit

// https://www.raywenderlich.com/7595-how-to-make-a-custom-control-tutorial-a-reusable-slider#
class CustomSlider: UIControl {

    // Describes the state of the control
    var minimumValue: CGFloat = 0 {
        didSet {
            updateSliderFrames()
        }
    }

    var maximumValue: CGFloat = 1 {
        didSet {
            updateSliderFrames()
        }
    }
    
    var thumbValue: CGFloat = 1 {
        didSet {
            updateSliderFrames()
        }
    }

    private var previousLocation = CGPoint()

    private let track = UIImageView()
    private let thumbImageView = UIImageView()

//    #imageLiteral(resourceName: "thumb")
    var thumbImage = #imageLiteral(resourceName: "thumb") {
        didSet {
            thumbImageView.image = thumbImage
            updateSliderFrames()
        }
    }

//    var trackImage = #imageLiteral(resourceName: "slider_image") {
//        didSet {
//            track.image = thumbImage
//            updateSliderFrames()
//        }
//    }

    override var frame: CGRect {
        didSet {
            updateSliderFrames()
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

//        track.image = trackImage
        addSubview(track)

        thumbImageView.image = thumbImage
        addSubview(thumbImageView)

        updateSliderFrames()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // 1
    private func updateSliderFrames() {
        track.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 223, height: 66))
        thumbImageView.frame = CGRect(origin: thumbOriginForValue(thumbValue), size: CGSize(width: thumbImage.size.width, height: thumbImage.size.height - 2))
    }
    
    // 2
    func positionForValue(_ value: CGFloat) -> CGFloat {
        return bounds.width * value
    }
    
    // 3
    private func thumbOriginForValue(_ value: CGFloat) -> CGPoint {
        let x = positionForValue(value) - thumbImage.size.width / 2.0
        return CGPoint(x: x, y: (bounds.height - (thumbImage.size.height - 10)) / 2.0)
    }
}

extension CustomSlider {
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        // 1
        previousLocation = touch.location(in: self)

        // 2
        thumbImageView.isHighlighted = true

        // 3
        return thumbImageView.isHighlighted
    }

    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)

        // 1
        let deltaLocation = location.x - previousLocation.x
        let deltaValue = (maximumValue - minimumValue) * deltaLocation / bounds.width

        previousLocation = location

        // 2
        thumbValue += deltaValue
        thumbValue = boundValue(thumbValue, toLowerValue: minimumValue, upperValue: maximumValue)

        // 3

        updateSliderFrames()

        sendActions(for: .valueChanged)

        return true
    }

    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        thumbImageView.isHighlighted = false
    }

    private func boundValue(_ value: CGFloat, toLowerValue lowerValue: CGFloat,
        upperValue: CGFloat) -> CGFloat {
        return min(max(value, lowerValue), upperValue)
    }
}
