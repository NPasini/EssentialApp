//
//  CommentsViewAdapter.swift
//  EssentialApp
//
//  Created by nicolo.pasini on 10/02/23.
//

import Foundation
import EssentialFeed
import EssentialFeediOSMVP

final class CommentsViewAdapter: ResourceView {
    
    private weak var controller: ListViewController?

    init(controller: ListViewController) {
        self.controller = controller
    }

    func display(_ viewModel: ImageCommentsViewModel) {
        controller?.display(viewModel.comments.map { viewModel in
            CellController(id: viewModel, ImageCommentCellController(model: viewModel))
        })
    }
}
