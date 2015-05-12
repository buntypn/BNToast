//
//  BNToast.h
//  Cocos2d-x
//
//  Created by Bunty Nara on 10-12-14.
//  Copyright 2015. All rights reserved.
//

#ifndef __BNToast_H__
#define __BNToast_H__

#include "cocos2d.h"

#define TOAST_Z 9999

using namespace cocos2d;

class BNToast : public DrawNode
{
    
    /**
     *  Adds vertices for a bezier curve with the given parameters to an array of vertices.
     *  It uses the same implementation as drawCubicBezier in CCDrawNode.
     *
     *  @param origin Starting point for our curve.
     *  @param control1 Control point for bending the curve before the halfway point.
     *  @param control2 Control point for bending the curve after the halfwar point.
     *  @param destination Ending point for our curve.
     *  @param segments Number of segments we want in the curve.
     *  @param vertices Pointer to an array of vertices that we'll be adding the curve vertices to.
     */
    void addCubicBezierVertices(Point origin, Point control1, Point control2, Point destination, int segments, Vec2 *vertices);

    /**
     *  Draws a rounded rectangle.
     *
     *  @param rect The rectangle to draw.
     *  @param cornerRadius The radius of the corners.
     *  @param smoothness A multiplier for the number of segments drawn for each corner. 2 or 3 is recommended.
     *  @param cornersToRound An array of BOOL values that signifies which corners we should round. The indices
     *          represent each corner as follows: 0 -> bottomLeft, 1 -> topLeft, 2 -> topRight, 3 -> bottomRight.
     */
    void drawSolidRoundedRect(Rect rect, int cornerRadius, int smoothness, bool *cornersToRound);

    void remove(float dt) {
        this->stopAllActions();
        this->unscheduleAllCallbacks();
        this->removeFromParentAndCleanup(true);
    }
    
public:
    
    Color4F fillColor;
    Color4F borderColor;
    float borderWidth;
    
    ~BNToast() {
        //CCLOG("~BNToast");
    }
    bool init() {
        return DrawNode::init();
    }
    
    void draw(Renderer *renderer, const Mat4 &transform, uint32_t flags) {
        DrawNode::draw(renderer, transform, flags);
    }
    
    CREATE_FUNC(BNToast);
    
    /**
     *  Shows a toast message in rounded rectangle for given time duration.
     *
     *  @param lblTitle The label to show on center of the screen.
     *  @param size The size of the toast
     *  @param cornerRadius The radius of the corners.
     *  @param borderWidth The width of boarder line.
     *  @param duartionSeconds The number of seconds to show the toast, after that it will be removed.
     *  @param target The target node in which toast to show.
     *  @param fillColor The background color in the toast.
     *  @param borderColor The boarder color of the toast.
     */
    static void showToast(Label* lblTitle, const Size size, const float cornerRadius, const float borderWidth,
                          const float duartionSeconds, Node *target,
                          const Color4F &fillColor = Color4F::GRAY, const Color4F &borderColor = Color4F::BLACK);
};


#endif
