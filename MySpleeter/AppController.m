//
//  AppController.m
//  MySpleeter
//
//  Created by kyab on 2020/09/01.
//  Copyright © 2020 kyab. All rights reserved.
//

#import "AppController.h"
#import <Cocoa/Cocoa.h>

@implementation AppController
-(void)awakeFromNib{
    NSLog(@"AppController awakeFromNib");
    _spleeter = [[SpleeterWrapper alloc] init];
}

- (IBAction)testClicked:(id)sender {
    NSLog(@"test");
}

- (IBAction)selectInputFile:(id)sender {
    NSLog(@"Select input file");
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setCanChooseFiles:YES];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:NO];
    if ([panel runModal] == NSModalResponseOK){
        NSURL *url = [panel URL];
        NSLog(@"path = %@", [url path]);
        [_txtInputFile setStringValue:[url path]];
    }else{
        //User cancelled
    }
}

- (IBAction)selectOutputDir:(id)sender {
    NSLog(@"Select output dir");
    NSOpenPanel *panel = [[NSOpenPanel alloc] init];
    [panel setCanCreateDirectories:YES];
    [panel setCanChooseFiles:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanChooseDirectories:YES];
    
    if ([panel runModal] == NSModalResponseOK){
        NSURL *url = [panel URL];
        NSLog(@"path = %@", [url path]);
        [_txtOutputDir setStringValue:[url path]];
    }else{
        //User cancelled
    }

}
- (IBAction)doSeparate:(id)sender {
    NSString *inFile = [_txtInputFile stringValue];
    NSString *outDir = [_txtOutputDir stringValue];
    
    if ([inFile length] ==0 || [outDir length] == 0){
        //empty infile or outdir
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setInformativeText:@"Please select input file and output directory."];
        [alert setMessageText:@"error"];
        [alert runModal];
        return;
    }
    //this is what we need.
    
    [_spleeter makeSeparator5stems];
    NSString *ret = [_spleeter separate_file:inFile outDir:outDir];
    
    NSAlert *alert = [[NSAlert alloc] init];
    [alert setInformativeText:ret];
    [alert setMessageText:@"result"];
    [alert runModal];
    
    
}



@end
