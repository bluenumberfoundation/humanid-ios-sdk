internal class MainViewController: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var fgView: UIView!
    @IBOutlet weak var appLogo: UIImageView!
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var fgViewHeight: NSLayoutConstraint!
    @IBOutlet weak var fgViewBottom: NSLayoutConstraint!

    var clientLogo = ""
    var clientName = ""

    var bottomSheetViewHeight: CGFloat = UIScreen.main.bounds.size.height * 0.40 {
        didSet {
            fgViewHeight.constant = bottomSheetViewHeight
            fgViewBottom.constant = bottomSheetViewHeight * -1.0
        }
    }

    var bottomSheetTouchPoint: CGPoint = CGPoint(x: 0, y: 0)

    var router: MainRoutingLogic?

    convenience init() {
        self.init(nibName: "MainViewController", bundle: Bundle.humanID)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimation(isDismiss: false)
    }

    func configureViews() {
        view.backgroundColor = .clear

        bgView.alpha = 0.0
        fgView.layer.cornerRadius = 10
        fgView.clipsToBounds = true
        fgView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        appLogo.image = UIImage(named: clientLogo)
        appName.text = clientName
    }

    @IBAction func goToRequestOTP(_ sender: Any) {
        router?.pushRequestOtpVC(with: clientName)
    }

    @IBAction func showTnc(_ sender: Any) {
        router?.openTnc()
    }

    @IBAction func dismiss(_ sender: UITapGestureRecognizer) {
        showAnimation(isDismiss: true)
    }

    @IBAction func swipeDown(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: fgView.window)

        switch sender.state {
        case .began:
            bottomSheetTouchPoint = touchPoint
        case .changed:
            if touchPoint.y - bottomSheetTouchPoint.y > 0 {
                fgView.frame = CGRect(
                    x: 0,
                    y: touchPoint.y,
                    width: fgView.frame.size.width,
                    height: fgView.frame.size.height
                )
            }
        case .ended, .cancelled:
            if touchPoint.y - bottomSheetTouchPoint.y > 100 {
                bgView.alpha = 0.0
                view.layoutIfNeeded()
                dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25, animations: {
                    self.fgView.frame = CGRect(
                        x: 0,
                        y: touchPoint.y,
                        width: self.fgView.frame.size.width,
                        height: self.bottomSheetViewHeight - self.fgView.frame.size.height
                    )
                })
            }
        default:
            break
        }
    }

    private func showAnimation(isDismiss: Bool) {
        fgViewBottom.constant = isDismiss ? (bottomSheetViewHeight * -1.0) : 0.0

        UIView.animate(withDuration: 0.25, animations: {
            self.bgView.alpha = isDismiss ? 0.0 : 0.3
            self.view.layoutIfNeeded()
        }) { (_) in
            if isDismiss {
                self.dismiss(animated: true)
            }
        }
    }
}
