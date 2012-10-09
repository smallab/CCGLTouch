//
//  MyCCGLView.h
//  CCGLTouchMultitouch example
//
//  Created by Matthieu Savary on 09/09/11.
//  Copyright (c) 2011 SMALLAB.ORG. All rights reserved.
//
//  More info on the CCGLTouch project >> http://www.smallab.org/code/ccgl-touch/
//  License & disclaimer >> see license.txt file included in the distribution package
//
//  Latest revision on 10/06/12.
//

#import "CCGLTouchView.h"

#include <vector>
#include <map>
#include <list>


struct TouchPoint {
	TouchPoint() {}
	TouchPoint( const Vec2f &initialPt, const Color &color ) : mColor( color ), mTimeOfDeath( -1.0 ) 
	{
		mLine.push_back( initialPt ); 
	}
	
	void addPoint( const Vec2f &pt ) { mLine.push_back( pt ); }
	
	void draw() const
	{
		/*if( mTimeOfDeath > 0 ) // are we dying? then fade out
			gl::color( ColorA( mColor, ( mTimeOfDeath - getElapsedSeconds() ) / 2.0f ) );
		else*/
			gl::color( mColor );
        
		gl::draw( mLine );
	}
	
	void startDying() { /*mTimeOfDeath = getElapsedSeconds() + 2.0f;*/ } // two seconds til dead
	
	bool isDead() const { return true;/* getElapsedSeconds() > mTimeOfDeath;*/ }
	
	PolyLine<Vec2f>	mLine;
	Color			mColor;
	float			mTimeOfDeath;
};


@interface MyCCGLView : CCGLTouchView {
    BOOL                        mTouchFlag;
	map<uint32_t,TouchPoint>	mActivePoints;
	list<TouchPoint>			mDyingPoints;
}

- (void)turnActiveTouchesOn:(BOOL)flag;

@end
