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
        scanManager.presentScanner(from: self)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        scanManager.delegate = self
        resultTextView.isEditable = false // 결과화면 수정못하게
    }


}



extension ViewController: ScanManagerDelegate {
    func didScan(image: UIImage) {
        textRecognizer.recognizeText(from: image) { [weak self] text in
            self?.resultTextView.text = text
        }
    }
}
