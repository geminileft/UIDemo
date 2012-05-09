//
//  TEManagerProfiler.cpp
//  UIDemo
//
//  Created by dev on 5/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include "TEManagerProfiler.h"
#include "TEManagerTime.h"

static double mShortStart;

void TEManagerProfiler::startShort() {
    mShortStart = TEManagerTime::currentTime();
}

double TEManagerProfiler::shortTimeDiff() {
    const double current = TEManagerTime::currentTime();
    const double diff = current - mShortStart;
    mShortStart = current;
    return diff;
}
