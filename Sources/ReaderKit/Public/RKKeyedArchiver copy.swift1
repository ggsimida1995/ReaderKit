import UIKit

class RKKeyedArchiver: NSObject {
    
    // 获取应用沙盒的 Caches 目录
    private static var cachesDirectory: String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0].path
    }
    
    /// 归档文件
    class func archiver(folderName: String, fileName: String, object: Any) {
        let path = cachesDirectory + "/\(DZM_READ_FOLDER_NAME)/\(folderName)"
        
        if creat_file(path: path) { // 创建文件夹成功或者文件夹存在
            let filePath = path + "/\(fileName)"
            do {
                let data = try NSKeyedArchiver.archivedData(withRootObject: object, requiringSecureCoding: false)
                try data.write(to: URL(fileURLWithPath: filePath))
            } catch {
                ReadToastView.showError(error, operation: "保存文件")
                print("保存文件失败：\(error)")
            }
        }
    }
    
    /// 解档文件
    class func unarchiver(folderName: String, fileName: String) -> Any? {
        let path = cachesDirectory + "/\(DZM_READ_FOLDER_NAME)/\(folderName)/\(fileName)"
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let result = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [NSObject.self, NSString.self, NSNumber.self, NSArray.self, NSDictionary.self, NSAttributedString.self, RKReadRecordModel.self, RKReadChapterModel.self, RKReadPageModel.self], from: data)
            return result
        } catch {
            ReadToastView.showError(error, operation: "加载文件")
            return nil
        }
    }
    
    /// 解档文件（指定类型）
//    class func unarchiver<T: NSObject & NSCoding>(folderName: String, fileName: String, type: T.Type) -> T? {
//        let path = cachesDirectory + "/\(DZM_READ_FOLDER_NAME)/\(folderName)/\(fileName)"
//        do {
//            let data = try Data(contentsOf: URL(fileURLWithPath: path))
//            return try NSKeyedUnarchiver.unarchivedObject(ofClass: T.self, from: data)
//        } catch {
//            return nil
//        }
//    }
    
    /// 删除归档文件
    class func remove(folderName: String, fileName: String? = nil) -> Bool {
        var path = cachesDirectory + "/\(DZM_READ_FOLDER_NAME)/\(folderName)"
        
        if let fileName = fileName, !fileName.isEmpty {
            path += "/\(fileName)"
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            ReadToastView.showError(error, operation: "删除文件")
            return false
        }
    }
    
    /// 清空归档文件
    class func clear() -> Bool {
        let path = cachesDirectory + "/\(DZM_READ_FOLDER_NAME)"
        
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            ReadToastView.showError(error, operation: "清空归档文件")
            return false
        }
    }
    
    /// 是否存在归档文件
    class func isExist(folderName: String, fileName: String? = nil) -> Bool {
        var path = cachesDirectory + "/\(DZM_READ_FOLDER_NAME)/\(folderName)"
        
        if let fileName = fileName, !fileName.isEmpty {
            path += "/\(fileName)"
        }
        
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// 创建文件夹,如果存在则不创建
    private class func creat_file(path: String) -> Bool {
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) { return true }
        
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
            return true
        } catch let error {
            ReadToastView.showError(error, operation: "创建目录失败")
            return false
        }
    }
    
    // 获取文件路径
    class func filePath(folderName: String, fileName: String) -> String {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let cachesDirectory = paths[0]
        
        // 组合文件夹路径
        let folderURL = cachesDirectory.appendingPathComponent(folderName)
        // 组合文件路径
        let fileURL = folderURL.appendingPathComponent(fileName)
        return fileURL.path
    }
}

