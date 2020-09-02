//
//  AppController.h
//  MySpleeter
//
//  Created by kyab on 2020/09/01.
//  Copyright © 2020 kyab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import "DragAndDropTextField.h"
#import "SpleeterWrapper.h"
NS_ASSUME_NONNULL_BEGIN

@interface AppController : NSObject{
    
    __weak IBOutlet DragAndDropTextField *_txtInputFile;
    __weak IBOutlet DragAndDropTextField *_txtOutputDir;
    __weak IBOutlet NSButton *_btnDoSpleet;
    
    SpleeterWrapper *_spleeter;
    
}


@end

NS_ASSUME_NONNULL_END
