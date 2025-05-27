import UIKit
import VisionKit

protocol ScanManagerDelegate: AnyObject {
    func didScan(image: UIImage)
}

class ScanManager: NSObject {
    weak var delegate: ScanManagerDelegate? // ScanManager 의 일을 대신 처리해줄 놈. ViewController 가 들어가거나 nil

    func presentScanner(from viewController: UIViewController) {
        let scanVC = VNDocumentCameraViewController() // 스캔용 VC를 새로 생성
        scanVC.delegate = self // 스캔용 VC의 대리자는 ScanManager 즉 self
        viewController.present(scanVC, animated: true) // 메일 VC 에서 scanVC 를 띄운다
    }
}



// VNDocumentCameraViewController 의 delegate 역할을 맡을 때 처리할 메서드들
extension ScanManager: VNDocumentCameraViewControllerDelegate {
    // 스캔을 다 하고 완료 버튼 누를 때 동작
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        // 스캔이 한장 이상일 때 동작.
        if scan.pageCount > 0 {
            // 여러장 찍어도 지금은 첫번째 페이지만 사용
            let image = scan.imageOfPage(at: 0)
            // delegate 점찍어둔애가 있으면 그놈의 didScan 함수를 실행
            delegate?.didScan(image: image)
        }
    }

    // 취소 누를 때 동작
    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    // 실패시 동작
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        print("스캔 실패: \(error.localizedDescription)")
    }
}
