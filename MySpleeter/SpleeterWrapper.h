//
//  SpleeterWrapper.h
//  MySpleeter
//
//  Created by kyab on 2020/09/02.
//  Copyright © 2020 kyab. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Python.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpleeterWrapper : NSObject{
    PyObject *_separator;
}
-(void)makeSeparator5stems;
-(NSString *)separate_file:(NSString *)inFile outDir:(NSString *)outDir;
@end

NS_ASSUME_NONNULL_END
