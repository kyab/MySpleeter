//
//  DragAndDropTextField.m
//  MySpleeter
//
//  Created by kyab on 2020/09/01.
//  Copyright © 2020 kyab. All rights reserved.
//
//https://gist.github.com/PaulChana/2f1c11d495d79b250c36805851e6ac0a

#import "DragAndDropTextField.h"

@interface DragAndDropTextField ()
@property (nonatomic) bool dragIsOver;
@end

@implementation DragAndDropTextField

-(void)awakeFromNib{
    
    NSLog(@"DragAndDropTextField awakeFromNib");
    [self
     registerForDraggedTypes:[NSArray arrayWithObjects:NSPasteboardTypeFileURL, nil]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [NSGraphicsContext saveGraphicsState];
    [super drawRect:dirtyRect];
    if (_dragIsOver)
    {
        [[[NSColor keyboardFocusIndicatorColor] colorWithAlphaComponent:0.25] set];
        NSRectFill(NSInsetRect(self.bounds, 1, 1));
    }
    [NSGraphicsContext restoreGraphicsState];
    
    // Drawing code here.
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    if ( [[[sender draggingPasteboard] types] containsObject:NSPasteboardTypeFileURL] ) {
        _dragIsOver = true;
        [self setNeedsDisplay:YES];
        return NSDragOperationCopy;
    }
    return NSDragOperationNone;
}

- (void)draggingExited:(nullable id <NSDraggingInfo>)sender {
    _dragIsOver = false;
    [self setNeedsDisplay:YES];
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
    NSPasteboard *pboard = [sender draggingPasteboard];
    if ( [[pboard types] containsObject:NSPasteboardTypeFileURL] ) {
        NSURL *fileURL = [NSURL URLFromPasteboard:pboard];
        self.stringValue = [fileURL path];
        _dragIsOver = false;
        [self setNeedsDisplay:YES];
    }
    return YES;
}


@end
