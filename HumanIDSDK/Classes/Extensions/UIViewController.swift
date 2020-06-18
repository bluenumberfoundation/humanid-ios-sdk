internal extension UIViewController {

    func alertVC(with message: String) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Close", style: .default))
        present(alertVC, animated: true)
    }

    func alertVCCompletion(with message: String, completion: @escaping ((Bool?)->())) {
        let alertVC = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Close", style: .default, handler: { (Void) in
            completion(true)
        }))
        present(alertVC, animated: true)
    }
}
