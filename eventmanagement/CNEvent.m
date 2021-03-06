//
//  Event.m
//
//  CocoNuit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU Lesser General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version. 
//
//  CocoNuit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU Lesser General Public License for more details.
//
//  You should have received a copy of the GNU Lesser General Public License
//  along with CocoNuit.  If not, see <http://www.gnu.org/licenses/>.
//
//  Copyright 2009 Nicola Martorana <martorana.nicola@gmail.com>.
//

#import "CNEvent.h"


@implementation CNEvent

@synthesize strokes;
@synthesize timestamp;

-(id)init{
	if(self = [super init]){
		timestamp = [[NSDate date] timeIntervalSinceReferenceDate];//controllare che fa [NSDate timestamp]
		strokes = [[NSMutableArray alloc] init];
	}
	return self;
}

-(void)dealloc{
	[strokes release];
	[super dealloc];
}

-(void)setStroke:(CNStroke*)aStroke{
	[strokes addObject:aStroke];
}

-(CNStroke *)getStrokeByID:(NSInteger)aStrokeID{
	for (CNStroke* stroke in strokes){
		if(stroke.strokeID == aStrokeID){
			return stroke;
		}
	}
	return Nil;
}

-(BOOL)removeStrokeByID:(NSInteger)aStrokeID{
	for (int i=0; i<strokes.count; i++){
		CNStroke* tempStroke = (CNStroke*) [strokes objectAtIndex:i];
		if(tempStroke.strokeID == aStrokeID){
			[strokes removeObject:tempStroke];
			return YES;
		}
	}
	return NO;
}

-(id)copy{
	CNEvent* aEvent = [[CNEvent alloc] init];
	aEvent.timestamp = timestamp;
	
	NSMutableArray* anArray = [[NSMutableArray alloc] init];
	
	for(id stroke in strokes){
		CNTouch*copytouch = [((CNTouch*)stroke) copy];
		[anArray addObject:copytouch];
		[copytouch release];
	}
	[aEvent setStrokes: anArray];
	[anArray release];
	return aEvent;
}

@end
