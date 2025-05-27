//
//  ViewController.swift
//  cameraOCR_study
//
//  Created by drfranken on 5/27/25.
//

import UIKit

class ViewController: UIViewController {

    let scanManager = ScanManager()
    let textRecognizer = TextRecognizer()

    @IBOutlet weak var resultTextView: UITextView!
    
    @IBAction func scanDocument(_ sender: Any) {
        //스캔화면 오픈
        scanManager.presentScanner(from: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        scanManager.delegate = self
        resultTextView.isEditable = false // 결과화면 수정못하게
    }
}



// Delegate 역할
extension ViewController: ScanManagerDelegate {
    // 스캔 완료시
    func didScan(image: UIImage) {
        textRecognizer.recognizeText(from: image) { [weak self] text in
            self?.resultTextView.text = text
        }
    }
}
