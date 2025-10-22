//
//  ImageSaver.swift
//  ManualZipSwiftUI
//
//  Created by Brown on 10/22/25.
//

import UIKit

final class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc private func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            print("앨범 저장 오류: \(error.localizedDescription)")
        } else {
            print("이미지가 앨범에 성공적으로 저장되었습니다!")
        }
    }
}
