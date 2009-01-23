//
//  AppController.m
//  Pianist
//
//  Created by Matt Mower on 22/01/2009.
//  Copyright 2009 LucidMac Software. All rights reserved.
//

#import <PYMIDI/PYMIDI.h>

#import "AppController.h"
#import "MIDIController.h"

#define MAX_COUNTER (100)

@interface AppController ()

- (void)resetCounter;
- (void)incrementCounter;
- (void)playRound;

- (void)roundIsOver;

@end

@implementation AppController

@synthesize counter;
@synthesize stave;
@synthesize currentRound;
@synthesize score;

- (void)awakeFromNib {
  midiController = [[MIDIController alloc] initWithDestination:self];
  [self rescanMidi:nil];
}

- (IBAction)startGame:(id)sender {
  [self setScore:0];
  [self setCurrentRound:1];
  [self playRound];
}

- (IBAction)rescanMidi:(id)sender {
  // Remove all but the first two items from the MIDI menu
  NSArray *items = [midiMenu itemArray];
  for( NSMenuItem *item in [items subarrayWithRange:NSMakeRange(2,[items count]-2)] ) {
    [midiMenu removeItem:item];
  }
  
  for( PYMIDIEndpoint *source in [[PYMIDIManager sharedInstance] realSources] ) {
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:[source displayName] action:@selector(setMidiSource:) keyEquivalent:@""];
    [item setTarget:self];
    [item setRepresentedObject:source];
    [midiMenu addItem:item];
  }
}

- (IBAction)setMidiSource:(id)sender {
  [midiController setSource:[sender representedObject]];
  [sender setState:NSOnState];
}

- (void)playRound {
  notePlayed = NO;
  currentNote = 36 + ( random() % 25 );
  [self resetCounter];
  [stave setNote:currentNote];
  
  timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                           target:self
                                         selector:@selector(check:)
                                         userInfo:nil
                                          repeats:YES];
}

- (void)resetCounter {
  [self setCounter:0];
}

- (void)incrementCounter {
  [self setCounter:[self counter]+1];
}

- (void)check:(NSTimer *)notifyingTimer {
  if( notePlayed ) {
    [self roundIsOver];
  } else {
    if( [self counter] == MAX_COUNTER ) {
      [self roundIsOver];
    } else {
      [self incrementCounter];
    }
  }
}

- (void)roundIsOver {
  [timer invalidate];
  NSBeep();
  [stave setShowNote:NO];
}

- (void)noteReceived:(int)noteNumber withVelocity:(int)velocity {
  playedNote = noteNumber;
  notePlayed = YES;
}

@end