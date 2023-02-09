//
//  ImageCommentsPresenter.swift
//  
//
//  Created by nicolo.pasini on 08/02/23.
//

import Foundation

import iOSUtilities

public final class ImageCommentsPresenter {

    public static var title: String { Localized.ImageComments.title }

    public static func map(_ comments: [ImageComment]) -> ImageCommentsViewModel {
        let formatter = RelativeDateTimeFormatter()
        
        return ImageCommentsViewModel(comments: comments.map {
            ImageCommentViewModel(
                date: formatter.localizedString(for: $0.createdAt, relativeTo: Date()),
                message: $0.message,
                username: $0.username
            )
        })
    }
}
