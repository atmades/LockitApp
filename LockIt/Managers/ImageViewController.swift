import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    var imageView = UIImageView()
    var image: UIImage?
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupImageView()
        view.backgroundColor = .black
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 4.0
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentMode = .scaleAspectFit
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setupImageView() {
        scrollView.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalTo(scrollView)
            make.height.equalTo(scrollView)
        }
        
        if let image = image {
            imageView.image = image
        }
    }
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
