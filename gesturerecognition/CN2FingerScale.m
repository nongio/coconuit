//
//  CN2FingerScale.m
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


#import "CN2FingerScale.h"
#import "CNPathElement.h"
#import "CNLayer.h"

@implementation CN2FingerScale

-(id)init{
	if(self = [super init]){
		super.GestureName = @"2FingersScale";
		state = WaitingGesture;
		anchorPoint = NSMakePoint(0.5, 0.5);
	}
	return self;
}

-(BOOL)recognize:(id)sender{
	if([sender isKindOfClass:[CNLayer class]]){
		NSMutableArray* gStrokes = [[sender myMultitouchEvent] strokes];
		
		if([gStrokes count] == 2){///By now no grouping for this gesture is supported. Is supposed that only two different touch are in the active area.
			
			CNStroke* stroke_0 = [gStrokes objectAtIndex:0];
			CNStroke* stroke_1 = [gStrokes objectAtIndex:1];
			
			CN2dVect* vect_old;
			CN2dVect* vect;
			
			if(stroke_0.strokePath.count>1 && stroke_1.strokePath.count>1){
				
				CNTouch* Touch0 = (CNTouch*)stroke_0;///get the first touch
				CNTouch* Touch1 = (CNTouch*)stroke_1;///get the second touch
				
				NSPoint stroke_0_old_position = [(CNPathElement*)[stroke_0.strokePath objectAtIndex:([stroke_0.strokePath count]-2)] position];///get first touch previous position
				NSPoint stroke_1_old_position = [(CNPathElement*)[stroke_1.strokePath objectAtIndex:([stroke_1.strokePath count]-2)] position];///get second touch previous position
				
				NSPoint mediumPoint = getMediumPoint(stroke_0.position,stroke_1.position);///get medium point
				
				vect_old = [[CN2dVect alloc] initWithPoint:stroke_0_old_position andPoint:stroke_1_old_position];///get the vector between old positions
				vect = [[CN2dVect alloc] initWithPoint:stroke_0.position andPoint:stroke_1.position];///get the vector between actual positions
				
				double Min2FingerScaleValue = [[GesturesParams objectForKey:@"Min2FingerScaleValue"] doubleValue];
				

				double scale = vect.module/vect_old.module;///get scale value - actual touches vect module divided for old touches vect module
				
				///manage gesture state
				if(Touch0.type==ReleaseTouch || Touch1.type==ReleaseTouch){
					state=EndGesture;
				}
				
				if(state==BeginGesture){
					state=UpdateGesture;
				}
					
				if(state==WaitingGesture){
					state=BeginGesture;
					anchorPoint = mediumPoint;
				}
				
						
				NSLog(@"Scale del fattore %f ",scale);
				if(scale>Min2FingerScaleValue || state==EndGesture){///if the scale value is greater than a fixed threshold
					
					NSArray* keys = [NSArray arrayWithObjects:@"scaleValue", @"center", @"gState",nil];
					
					///set the useful params for the animation
					NSNumber* scalePar = [NSNumber numberWithFloat:scale];
					NSValue* centerPar = [NSValue valueWithPoint:anchorPoint];
					NSNumber* gStatePar = [NSNumber numberWithInt:state];
					
					NSArray* objects = [NSArray arrayWithObjects:scalePar, centerPar, gStatePar, nil];
					NSDictionary* params = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
					
					[sender performGesture:@"TwoFingerScale" withData:params];///call perform TwoFingerRotateGesture on the related layer [sender performGesture:@"TwoFingerScale" withData:params];
																			  ///passing Scale Value, Scale Center and GestureState
				}
				
				if(state==EndGesture){
					state=WaitingGesture;
				}
				[vect_old release];
				[vect release];
				return TRUE;
			}
				
		}
	}
	return FALSE;
}

@end
