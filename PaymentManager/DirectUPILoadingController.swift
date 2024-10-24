//
//  DirectUPILoadingController.swift
//  AstroYeti
//
//  Created by Sudhanshu Dwivedi on 22/02/24.
//  Copyright © 2024 Puneet Gupta. All rights reserved.
//

import UIKit
import Lottie


protocol UpiPaymentStatus: AnyObject {
    func upiPaymentSuccess(transactionId: String)
    func upiPaymentFailed()
}

class DirectUPILoadingController: UIViewController {
    
    init(intentURL: String, razorpayTxId: String) {
        self.intentURL = intentURL
        self.razorpayTxId = razorpayTxId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Outlets
    @IBOutlet weak var lottieContainerView: UIView!
    @IBOutlet weak var primaryLabel: UILabel!
    @IBOutlet weak var secondaryLabel: UILabel!
    
    //MARK: Variables
    lazy var progressAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        if let progressAnimation = LottieAnimation.named("paymentLoader") {
            animationView.animation = progressAnimation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
            animationView.play()
        }
        return animationView
    }()
    private var networkManager = NetworkManager.shared
    lazy var successAnimationView: LottieAnimationView = {
        let animationView = LottieAnimationView()
        if let successAnimation = LottieAnimation.named("paymentSuccess") {
            animationView.animation = successAnimation
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .playOnce
            animationView.isHidden = true
        }
        return animationView
    }()
    
    
    //MARK: Variables
    private var intentURL: String
    private var razorpayTxId: String
    weak var delegate: UpiPaymentStatus?
    private var timer: Timer?
    private var timerCounter = 0
    private var isPaymentSuccess: Bool = false
    var isDismissed = false
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAnimations()
        lauchIntent()
        startTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        stopTimer()
    }

    @objc func appWillResignActive() {
        stopTimer()
    }
    
    @objc func appDidBecomeActive() {
        startTimer()
    }
    
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func timerAction() {
        timerCounter += 2
        
        print("Timer value: \(timerCounter)")
        
        // Stop the timer if it reaches 45 seconds and show the payment fail state
        if timerCounter >= 45 && isPaymentSuccess == false {
            stopTimer()
            dismissPresentedControllers {
                self.delegate?.upiPaymentFailed()
            }
        }
        
        getOrderStatus()
    }
    
    //MARK: Setup
    private func setupAnimations() {
        lottieContainerView.addSubview(progressAnimationView)
        lottieContainerView.addSubview(successAnimationView)
        
        progressAnimationView.frame = lottieContainerView.bounds
        successAnimationView.frame = lottieContainerView.bounds
    }
    
    //MARK: Data
    private func lauchIntent() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            guard let self = self else { return }
            launchIntentURLFromStr(urlString: self.intentURL)
        }
    }
    
    private func launchIntentURLFromStr(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: { success in
                    if success {
                        print("URL was successfully opened.")
                    } else {
                        print("Failed to open URL.")
                    }
                })
            } else {
                print("Cannot open the URL.")
            }
        } else {
            print("Invalid URL string.")
        }
    }
    
    func showSuccessState(transactionId: String) {
        primaryLabel.text = "Money added successfully"
        secondaryLabel.isHidden = true
        progressAnimationView.isHidden = true
        successAnimationView.isHidden = false
        successAnimationView.play()
        
        if !isDismissed { // Check if already dismissed
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                self.dismiss(animated: true) {
                    self.delegate?.upiPaymentSuccess(transactionId: transactionId)
                    self.isDismissed = true // Mark as dismissed
                }
            }
        }
    }
    
    private func getOrderStatus() {
        
        let params:[String: Any] = ["razorpayTxId": self.razorpayTxId, "razorpayOrderId": ""]
        
        debugPrint(params)
        
        networkManager.getRequest(k_upi_payment_status, params: params as [String : AnyObject]?,oauth: true, result: {
            (response: JSON?, error: NSError?, statuscode: Int) in
            guard let response = response else { return }
            if response["status"].stringValue == "fail" {
//                self.view.makeToast(response["reason"].stringValue, duration: 2.0, position: CSToastPositionBottom)
            }
            else {
                if statuscode == 200 || statuscode == 201 {
                    
                    debugPrint(response)
                    
                    let status = response["data"]["status"].stringValue
                    if status == "captured" || status == "authorized" {
                        self.isPaymentSuccess = true
                        self.stopTimer()
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
                            guard let self = self else { return }
                            if !self.isDismissed { // Check if already dismissed
                                self.showSuccessState(transactionId: response["data"]["id"].stringValue)
                            }
                        }
                    }
                }
            }
        })
    }
    
    //MARK: Action
    @IBAction func crossButtonAction(_ sender: Any) {
        showCancelPaymentAlert()
    }
    
    func showCancelPaymentAlert() {
        let alertController = UIAlertController(title: "Cancel Payment?", message: "We are in the process of payment, going back will cancel this payment. Are you sure you want to go back?", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "No, don't cancel", style: .default) { _ in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        let confirmAction = UIAlertAction(title: "Yes, cancel", style: .destructive) { _ in
            print("User chose to cancel payment")
            self.dismiss(animated: true) {
                self.delegate?.upiPaymentFailed()
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Helper
    func dismissPresentedControllers(completion: (() -> Void)?) {
        if let presentedViewController = presentedViewController {
            presentedViewController.dismiss(animated: true) {
                self.dismiss(animated: true) {
                    completion?()
                }
            }
        } else {
            self.dismiss(animated: true) {
                completion?()
            }
        }
    }
}
