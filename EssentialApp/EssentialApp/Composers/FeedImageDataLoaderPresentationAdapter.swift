//
//  FeedImageDataLoaderPresentationAdapter.swift
//  
//
//  Created by Nicolò Pasini on 23/07/22.
//

import Combine
import Foundation
import EssentialFeed
import EssentialFeediOSMVP

final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    
    var presenter: FeedImagePresenter<View, Image>?
    
    private let model: FeedImage
    private var cancellable: Cancellable?
    private let imageLoader: (URL) -> FeedImageDataLoader.Publisher
    
    init(model: FeedImage, imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        
        cancellable = imageLoader(model.url)
            .dispatchOnMainQueue()
            .sink { [weak self] completion in
                switch completion {
                case .finished: break
                    
                case let .failure(error):
                    self?.presenter?.didFinishLoadingImageData(with: error, for: model)
                }
            } receiveValue: { [weak self] data in
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
            }
    }
    
    func didCancelImageRequest() {
        cancellable?.cancel()
    }
}
