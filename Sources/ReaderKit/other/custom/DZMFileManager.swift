import Foundation
import UIKit

class DZMFileManager {
    static let shared = DZMFileManager()
    
    private init() {}
    
    // MARK: - File Operations
    
    func saveImage(_ image: UIImage, withName fileName: String, inFolder folderName: String, completion: @escaping (Bool) -> Void) {
        let compressionQuality: CGFloat = 0.5
        
        DispatchQueue.global(qos: .background).async(execute: DispatchWorkItem {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                DispatchQueue.main.async {
                    completion(false)
                }
                return
            }
            
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            do {
                try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
                
                // Try different static image formats in order of preference
                let (imageData, imageExtension): (Data?, String)
                
                // Try PNG first (lossless)
                if let pngData = image.pngData() {
                    imageData = pngData
                    imageExtension = ".png"
                }
                // Try JPEG with high quality
                else if let jpegData = image.jpegData(compressionQuality: 0.9) {
                    imageData = jpegData
                    imageExtension = ".jpeg"
                }
                // Try JPEG with medium quality
                else if let jpegData = image.jpegData(compressionQuality: compressionQuality) {
                    imageData = jpegData
                    imageExtension = ".jpeg"
                }
                else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                    return
                }
                
                // Add extension if the filename doesn't already have one
                let finalFileName = fileName.hasSuffix(imageExtension) ? fileName : fileName + imageExtension
                let fileURL = folderURL.appendingPathComponent(finalFileName)
                if let data = imageData {
                    try data.write(to: fileURL)
                    DispatchQueue.main.async {
                        completion(true)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(false)
                    }
                }
            } catch {
                print("Error saving image: \(error)")
                DispatchQueue.main.async {
                    completion(false)
                }
            }
        })
    }
    
    func deleteImage(fileName: String, inFolder folderName: String) {
        DispatchQueue.global(qos: .background).async {
            guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return
            }
            
            let folderURL = documentsDirectory.appendingPathComponent(folderName)
            
            do {
                // Get all files in the directory
                let files = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
                
                // Find and delete the file that matches the name (without extension)
                for fileURL in files {
                    let fileExtension = fileURL.pathExtension
                    let fileNameWithoutExtension = fileURL.deletingPathExtension().lastPathComponent
                    
                    if fileNameWithoutExtension == fileName {
                        try FileManager.default.removeItem(at: fileURL)
                        break
                    }
                }
            } catch {
                print("Error deleting image: \(error)")
            }
        }
    }
    
    func getImage(fileName: String, inFolder folderName: String) -> UIImage? {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }

        let folderURL = documentsDirectory.appendingPathComponent(folderName)
        
        do {
            // Get all files in the directory
            let files = try FileManager.default.contentsOfDirectory(at: folderURL, includingPropertiesForKeys: nil)
            
            // Find the file that matches the name (without extension)
            for fileURL in files {
                let fileNameWithoutExtension = fileURL.deletingPathExtension().lastPathComponent
                if fileNameWithoutExtension == fileName {
                    return UIImage(contentsOfFile: fileURL.path)
                }
            }
        } catch {
            print("Error getting image: \(error)")
        }
        
        return nil
    }
    
    // MARK: - Theme Export
    
    func exportTheme(_ backdrop: ReadBackdrop, withImage image: UIImage?, completion: @escaping (URL?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            let tempDirectory = FileManager.default.temporaryDirectory
            let fileName = "[自定义背景]\(backdrop.title).mrb"
            let fileURL = tempDirectory.appendingPathComponent(fileName)
            
            do {
                let jsonObject = backdrop.toDictionary()
                let data = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                
                // Create a zip file containing both the JSON and image
                let zipURL = tempDirectory.appendingPathComponent(fileName.replacingOccurrences(of: ".mrb", with: ".zip"))
                
                // Write JSON data
                try data.write(to: fileURL)
                
                // If there's an image, add it to the zip
                if let image = image {
                    let imageURL = tempDirectory.appendingPathComponent("image.jpg")
                    if let imageData = image.jpegData(compressionQuality: 0.5) {
                        try imageData.write(to: imageURL)
                    }
                }
                
                DispatchQueue.main.async {
                    completion(zipURL)
                }
            } catch {
                print("Error exporting theme: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
} 
