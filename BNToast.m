//
//  BNToast.h
//  Cocos2d-x
//
//  Created by Bunty Nara on 10-12-14.
//  Copyright 2015. All rights reserved.
//

#include "BNToast.h"

using namespace cocos2d;

void BNToast::showToast(Label* lblTitle, const Size size, const float cornerRadius, const float borderWidth,
                        const float duartionSeconds, Node *target,
                        const Color4F &fillColor, const Color4F &borderColor)
{
    float smoothness = 2.0;
    
    BNToast *toast = BNToast::create();
    toast->setContentSize(size);
    toast->setAnchorPoint(Vec2(0.5, 0.5));
    
    toast->borderWidth = borderWidth;
    toast->fillColor = fillColor;
    toast->borderColor = borderColor;
    
    toast->setPosition(target->getContentSize().width*0.5, target->getContentSize().height*0.5);
    target->addChild(toast, TOAST_Z);
    
    // bacground
    bool cornersToRound[4] = {true, true, true, true};
    toast->drawSolidRoundedRect(Rect(0,0,size.width, size.height), cornerRadius, smoothness, cornersToRound);
    
    // position label
    lblTitle->setPosition(size.width*0.5, size.height*0.5);
    toast->addChild(lblTitle);
    
    // hide after some time given
    toast->schedule(CC_SCHEDULE_SELECTOR(BNToast::remove), duartionSeconds);
}


void BNToast::addCubicBezierVertices(Point origin, Point control1, Point control2, Point destination, int segments, Vec2 *vertices)
{
    int totalSegments = segments - 1;
    float t = 0;
    for(int i = 0; i < totalSegments; i++)
    {
        Vec2 vertex;
        vertex.x = powf(1 - t, 3) * origin.x + 3.0f * powf(1 - t, 2) * t * control1.x + 3.0f * (1 - t) * t * t * control2.x + t * t * t * destination.x;
        vertex.y = powf(1 - t, 3) * origin.y + 3.0f * powf(1 - t, 2) * t * control1.y + 3.0f * (1 - t) * t * t * control2.y + t * t * t * destination.y;
        vertices[i] = vertex;
        t += 1.0f / totalSegments;
    }
    
    Vec2 finalVertex = (Vec2) {destination.x, destination.y};
    vertices[totalSegments] = finalVertex;
}


void BNToast::drawSolidRoundedRect(Rect rect, int cornerRadius, int smoothness, bool *cornersToRound) {
    Point origin = rect.origin;
    Size size = rect.size;
    
    // number of segments for each rounded corner, +1 for end point of the curve
    int roundedCornerSegments = cornerRadius * smoothness + 1;
    
    // get the total vertices we'll need to draw
    int totalVertices = 0;
    for (int i = 0; i < 4; i++) {
        // add number of vertices needed for a rounded corner if we're rounding it,
        // else just add 1 vertex for the corner
        if (cornersToRound[i]) {
            totalVertices += roundedCornerSegments;
        } else {
            totalVertices += 1;
        }
    }
    
    Vec2* vertices = new (std::nothrow) Vec2[totalVertices];
    if( ! vertices )
        return;
    
    // create the vertices to draw in clockwisefashion starting from bottom left corner
    int currentVertexIndex = 0;
    for (int i = 0; i < 4; i++) {

        // rect without rounded corner
        if (!cornersToRound[i]) {
            switch (i) {
                case 0: vertices[currentVertexIndex] = (Vec2){origin.x, origin.y}; break;
                case 1: vertices[currentVertexIndex] = (Vec2){origin.x, origin.y + size.height}; break;
                case 2: vertices[currentVertexIndex] = (Vec2){origin.x + size.width, origin.y + size.height}; break;
                case 3: vertices[currentVertexIndex] = (Vec2){origin.x + size.width, origin.y}; break;
                default: break;
            }
            currentVertexIndex++;
        } else {
            // rect with rounded corners
            switch (i) {
                case 0: addCubicBezierVertices(Point(origin.x + cornerRadius, origin.y),
                                               Point(origin.x + cornerRadius/2, origin.y),
                                               Point(origin.x, origin.y + cornerRadius/2),
                                               Point(origin.x, origin.y + cornerRadius),
                                               roundedCornerSegments, &vertices[currentVertexIndex]); break;
                case 1: addCubicBezierVertices(Point(origin.x, origin.y + size.height - cornerRadius),
                                               Point(origin.x, origin.y + size.height - cornerRadius/2),
                                               Point(origin.x + cornerRadius/2, origin.y + size.height),
                                               Point(origin.x + cornerRadius, origin.y + size.height),
                                               roundedCornerSegments, &vertices[currentVertexIndex]); break;
                case 2: addCubicBezierVertices(Point(origin.x + size.width - cornerRadius, origin.y + size.height),
                                               Point(origin.x + size.width - cornerRadius/2, origin.y + size.height),
                                               Point(origin.x + size.width, origin.y + size.height - cornerRadius/2),
                                               Point(origin.x + size.width, origin.y + size.height - cornerRadius),
                                               roundedCornerSegments, &vertices[currentVertexIndex]); break;
                case 3: addCubicBezierVertices(Point(origin.x + size.width, origin.y + cornerRadius),
                                               Point(origin.x + size.width, origin.y + cornerRadius/2),
                                               Point(origin.x + size.width - cornerRadius/2, origin.y),
                                               Point(origin.x + size.width - cornerRadius, origin.y),
                                               roundedCornerSegments, &vertices[currentVertexIndex]); break;
                default: break;
            }
            currentVertexIndex += roundedCornerSegments;
        }
    }
    
    // draw all vertices
    drawPolygon(vertices, totalVertices, fillColor, borderWidth, borderColor);
}

