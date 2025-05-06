//
//  ReadModel+Mark.swift
//  eBookRead
//
//  Created by dengzemiao on 2019/4/19.
//  Copyright © 2019年 . All rights reserved.
//

import UIKit

extension ReadModel {

    /// 添加书签,默认使用当前阅读记录!
    func insetMark(recordModel: ReadRecordModel? = nil) {
        guard let recordModel = recordModel ?? self.recordModel else { return }
        
        let markModel = ReadMarkModel()
        markModel.bookID = recordModel.bookID
        markModel.chapterID = recordModel.chapterModel.id
        
        if recordModel.pageModel.isHomePage {
            markModel.name = "(无章节名)"
            markModel.content = bookName
        } else {
            markModel.name = recordModel.chapterModel.name
            markModel.content = recordModel.contentString.removeSEHeadAndTail.removeEnterAll
        }
        
        markModel.time = Timer1970()
        markModel.location = recordModel.locationFirst
        
        if markModels.isEmpty {
            markModels.append(markModel)
        } else {
            markModels.insert(markModel, at: 0)
        }
        
        save()
    }
    
    /// 移除当前书签
    func removeMark(index: Int) -> Bool {
        guard index >= 0 && index < markModels.count else { return false }
        markModels.remove(at: index)
        save()
        return true
    }
    
    /// 移除当前书签
    func removeMark(recordModel: ReadRecordModel? = nil) -> Bool {
        guard let recordModel = recordModel ?? self.recordModel,
              let markModel = isExistMark(recordModel: recordModel),
              let index = markModels.firstIndex(of: markModel) else {
            return false
        }
        
        return removeMark(index: index)
    }
    
    /// 是否存在书签
    func isExistMark(recordModel: ReadRecordModel? = nil) -> ReadMarkModel? {
        guard let recordModel = recordModel ?? self.recordModel,
              !markModels.isEmpty else {
            return nil
        }
        
        let locationFirst = recordModel.locationFirst
        let locationLast = recordModel.locationLast
        
        return markModels.first { markModel in
            markModel.chapterID == recordModel.chapterModel.id &&
            markModel.location >= locationFirst &&
            markModel.location < locationLast
        }
    }
}
