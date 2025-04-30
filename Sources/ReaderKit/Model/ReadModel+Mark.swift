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
    func insetMark(recordModel:ReadRecordModel? = nil) {
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let markModel = ReadMarkModel()
        
        markModel.bookID = recordModel.bookID
        
        markModel.chapterID = recordModel.chapterModel.id
        
        if recordModel.pageModel.isHomePage {
            
            markModel.name = "(无章节名)"
            
            markModel.content = bookName
            
        }else{
            
            markModel.name = recordModel.chapterModel.name
            
            markModel.content = recordModel.contentString.removeSEHeadAndTail.removeEnterAll
        }
        
        markModel.time = NSNumber(value: Timer1970())
        
        markModel.location = recordModel.locationFirst
        
        if markModels.isEmpty {
            
            markModels.append(markModel)
            
        }else{
            
            markModels.insert(markModel, at: 0)
        }
        
        save()
    }
    
    /// 移除当前书签
    func removeMark(index:NSInteger) ->Bool {
        
        markModels.remove(at: index)
        
        save()
        
        return true
    }
    
    /// 移除当前书签
    func removeMark(recordModel:ReadRecordModel? = nil) ->Bool {
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let markModel = isExistMark(recordModel: recordModel)
        
        if markModel != nil {
            
            let index = markModels.firstIndex(of: markModel!)!
            
            return removeMark(index: index)
        }
        
        return false
    }
    
    /// 是否存在书签
    func isExistMark(recordModel:ReadRecordModel? = nil) ->ReadMarkModel? {
        
        if markModels.isEmpty { return nil }
        
        let recordModel = (recordModel ?? self.recordModel)!
        
        let locationFirst = recordModel.locationFirst!
        
        let locationLast = recordModel.locationLast!
        
        for markModel in markModels {
            
            if markModel.chapterID == recordModel.chapterModel.id {
                
                if (markModel.location.intValue >= locationFirst.intValue) && (markModel.location.intValue < locationLast.intValue) {
                    
                    return markModel
                }
            }
        }
        
        return nil
    }
}
