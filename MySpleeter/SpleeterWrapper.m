//
//  SpleeterWrapper.m
//  MySpleeter
//
//  Created by kyab on 2020/09/02.
//  Copyright © 2020 kyab. All rights reserved.
//

#import "SpleeterWrapper.h"

@implementation SpleeterWrapper
-(id)init{
    self = [super init];
    
    _separator = NULL;
    
    char path[4096];
    
    //append ffmpeg to PATH
    path[0] = '\0';
    strcat(path, getenv("PATH"));
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *ffmpegPath = [resourcePath stringByAppendingString:@"/ffmpeg"];
    const char *ffmpegPath_c = [ffmpegPath UTF8String];
    strcat(path, ":");
    strcat(path, ffmpegPath_c);
    setenv("PATH", path, 1);
    NSLog(@"now PATH=%s",getenv("PATH"));
    
    //set PYTHONPATH
    path[0] = '\0';
    strcat(path, [[resourcePath stringByAppendingString:@"/devbuild/lib/python37.zip"] UTF8String]);
    strcat(path,":");
    strcat(path, [[resourcePath stringByAppendingString:@"/devbuild/lib/python3.7"] UTF8String]);
    strcat(path,":");
    strcat(path, [[resourcePath stringByAppendingString:@"/devbuild/lib/python3.7/lib-dynload"] UTF8String]);
    strcat(path,":");
    strcat(path, [[resourcePath stringByAppendingString:@"/devbuild/lib/python3.7/site-packages"] UTF8String]);
    setenv("PYTHONPATH", path , 1);
    NSLog(@"now PYTHONPATH=%s", getenv("PYTHONPATH"));
    
    Py_Initialize();

    {
        //Log PythonPATH from python
        PyObject *pName = PyUnicode_DecodeFSDefault("sys");
        PyObject *pModule = PyImport_Import(pName);
        if (pModule == NULL){
            NSLog(@"failed to import sys!");
            return self;
        }
        PyObject *paths = PyObject_GetAttrString(pModule, "path");
        if (paths){
            Py_ssize_t len = PyList_Size(paths);
            for (int i = 0 ; i < len ; i++){
                PyObject *path = PyList_GetItem(paths, i);
                Py_ssize_t foo;
                wchar_t *ws = PyUnicode_AsWideCharString(path, &foo);
                NSString *nsStr =
                    [[NSString alloc] initWithBytes:ws length:wcslen(ws)*sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
                NSLog(@"search path : %@",nsStr);
                
            }
        }
    }
    
    
    //create and set working directory on ~/Library/Application Support/MySpleeter (where DB will be downloaded)
    {
        //create (if not exist)
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
        NSString *applicationSupportDirectory = [paths firstObject];
        NSString *supportDirectoryForThisApp = [applicationSupportDirectory stringByAppendingPathComponent:@"MySpeeter"];
        NSLog(@"Support Directory is %@", supportDirectoryForThisApp);
        BOOL isDir;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:supportDirectoryForThisApp isDirectory:&isDir]){
            if(![fileManager createDirectoryAtPath:supportDirectoryForThisApp withIntermediateDirectories:YES attributes:nil error:NULL]){
                 NSLog(@"Could not create directory : %@", supportDirectoryForThisApp);
            }
        }
        
        [fileManager changeCurrentDirectoryPath:supportDirectoryForThisApp];
        NSLog(@"Now working directory is %@", [fileManager currentDirectoryPath]);
        
    }
    
    
    return self;
}

-(NSString *)getPythonError{
    PyObject *type, *value, *traceback;
    PyErr_Fetch(&type, &value, &traceback);
    
    PyObject *valueAsString = PyObject_Str(value);
    Py_ssize_t foo;
    
    wchar_t *ws = PyUnicode_AsWideCharString(valueAsString, &foo);
    
    NSString *nsStr =
        [[NSString alloc] initWithBytes:ws length:wcslen(ws)*sizeof(wchar_t) encoding:NSUTF32LittleEndianStringEncoding];
    
    return nsStr;
}

-(void)makeSeparator5stems{
    if (_separator) return;
    
    NSLog(@"initializing separator...");
    PyObject *pName = PyUnicode_DecodeFSDefault("spleeter.separator");
    PyObject *pModule = PyImport_Import(pName);
    if(!pModule){
        NSString *pyErr = [self getPythonError];
        NSLog(@"%@", pyErr);
        return;
    }
    PyObject *pFunc = PyObject_GetAttrString(pModule, "Separator");
    PyObject *pArgs = PyTuple_New(1);
    PyObject *pArg = PyUnicode_DecodeFSDefault("spleeter:5stems");
    PyTuple_SetItem(pArgs, 0, pArg);
    _separator = PyObject_CallObject(pFunc, pArgs);
    
    if(!_separator){
        NSLog(@"failed to create Separator instance:%@",[self getPythonError]);
    }else{
        NSLog(@"initializing separator...done.");
    }
    
    
}
-(NSString *)separate_file:(NSString *)inFile outDir:(NSString *)outDir{
    
    PyObject *pFunc = PyObject_GetAttrString(_separator, "separate_to_file");
    if(!pFunc){
        NSString *s = @"Error : separate_to_file function not found : ";
        return [s stringByAppendingString:[self getPythonError]];
    }
    
    PyObject *pArgs = PyTuple_New(2);
    PyObject *pArg1 = PyUnicode_DecodeFSDefault([inFile UTF8String]);
    PyObject *pArg2 = PyUnicode_DecodeFSDefault([outDir UTF8String]);
    PyTuple_SetItem(pArgs, 0, pArg1);
    PyTuple_SetItem(pArgs, 1, pArg2);
    PyObject *ret = PyObject_CallObject(pFunc, pArgs);
    if (!ret){
        NSLog(@"blah!");
        NSString *pyErr = [self getPythonError];
        NSLog(@"separate_to_file(%@,%@) failed : %@", inFile, outDir, pyErr);
        return [NSString stringWithFormat:@"separate_to_file(%@,%@) failed : %@", inFile, outDir, pyErr];
    }
    
    
    return @"succeeded to separate to 5stems";
}
@end
