//
//  StaveView.h
//  Pianist
//
//  Created by Matt Mower on 22/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface StaveView : NSView {
  BOOL showNote;
  BOOL nameNote;
  int note;
}

@property BOOL showNote;
@property BOOL nameNote;
@property int note;

@end