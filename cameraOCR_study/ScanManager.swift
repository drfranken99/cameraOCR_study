import UIKit
import VisionKit

protocol ScanManagerDelegate: AnyObject {
    func didScan(image: UIImage)
}

class ScanManager: NSObject {
    weak var delegate: ScanManagerDelegate?

    func presentScanner(from viewController: UIViewController) {
        let scanVC = VNDocumentCameraViewController()
        scanVC.delegate = self
        viewController.present(scanVC, animated: true)
    }
}

extension ScanManager: VNDocumentCameraViewControllerDelegate {
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        controller.dismiss(animated: true)
        if scan.pageCount > 0 {
            let image = scan.imageOfPage(at: 0)
            delegate?.didScan(image: image)
        }
    }

    func documentCameraViewControllerDidCancel(_ controller: VNDocumentCameraViewController) {
        controller.dismiss(animated: true)
    }

    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFailWithError error: Error) {
        controller.dismiss(animated: true)
        print("스캔 실패: \(error.localizedDescription)")
    }
}
