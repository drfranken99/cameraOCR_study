import UIKit
import VisionKit

class EmojiScannerViewController: UIViewController {

    @IBOutlet weak var emojiLabel: UILabel!

    @IBOutlet weak var recognizedText: UILabel!


    var scannerViewController: DataScannerViewController?
    var hasScanned = false

    override func viewDidLoad() {
        super.viewDidLoad()
        emojiLabel.text = "😶"
    }


    @IBAction func startScanTapped(_ sender: Any) {
        print("스캐너 사용 가능 여부: \(DataScannerViewController.isAvailable)")
        hasScanned = false
        guard DataScannerViewController.isSupported else {
            print("이 기기에서 DataScanner 미지원")
            return
        }

        let scannerVC = DataScannerViewController(
            recognizedDataTypes: [.text(languages: ["en-US"])],
            qualityLevel: .balanced,
            recognizesMultipleItems: false,
            isHighFrameRateTrackingEnabled: false,
            isHighlightingEnabled: true
        )

        print("여기까지 왔나")
        scannerVC.delegate = self
        addChild(scannerVC)
        scannerVC.view.frame = view.bounds
        view.addSubview(scannerVC.view)
        scannerVC.didMove(toParent: self)

        do {
            try scannerVC.startScanning()
        } catch {
            print("스캐너 시작 실패: \(error.localizedDescription)")
        }

        self.scannerViewController = scannerVC
    }




    // 인식가능한 글자셋
    func updateEmoji(for text: String) {
        let lower = text.lowercased()
        let emojiMap: [String: String] = [
            "happy": "😊",
            "birthday": "🎂",
            "love": "❤️",
            "dog": "🐶",
            "cat": "🐱",
            "coffee": "☕️"
        ]

        for (key, emoji) in emojiMap {
            if lower.contains(key) {
                emojiLabel.text = emoji
                return
            }
        }

        emojiLabel.text = "❓" // 매칭 안 될 경우
    }

}

extension EmojiScannerViewController: DataScannerViewControllerDelegate {
    // 이거 죽어도 안됨
    func dataScanner(_ dataScanner: DataScannerViewController, didAdd addedItems: [RecognizedItem]) {
        guard !hasScanned else { return }
        hasScanned = true

        print("addedItems 전체 내용: \(addedItems)")
        for item in addedItems {
            if case let .text(textItem) = item {
                print("textItem 전체 정보: \(textItem)")
                let text = textItem.transcript
                print("인식된 텍스트: \(text)")
                DispatchQueue.main.async {
                    self.recognizedText.text = text
                    self.updateEmoji(for: text)
                    self.scannerViewController?.dismiss(animated: true)
                }
            }
        }
    }

    func dataScanner(_ dataScanner: DataScannerViewController, didUpdate updatedItems: [RecognizedItem]) {
        print("didUpdate 호출됨 - 업데이트된 항목 수: \(updatedItems.count)")
    }

    func dataScanner(_ dataScanner: DataScannerViewController, didRemove removedItems: [RecognizedItem]) {
        print("didRemove 호출됨 - 제거된 항목 수: \(removedItems.count)")
    }

    // 대신 탭하면 실행되는거로 바꿈
    func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
        guard !hasScanned else { return }
        hasScanned = true

        if case let .text(textItem) = item {
            let text = textItem.transcript
            print("didTapOn 텍스트: \(text)")
            DispatchQueue.main.async {
                self.updateEmoji(for: text)
                self.recognizedText.text = text
                self.scannerViewController?.willMove(toParent: nil)
                self.scannerViewController?.view.removeFromSuperview()
                self.scannerViewController?.removeFromParent()
            }
        }
    }

    func dataScannerDidStopScanning(_ dataScanner: DataScannerViewController) {
        print("스캐너 종료됨")
    }
}
