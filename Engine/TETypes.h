#ifndef TETYPES
#define TETYPES

#include <list>
#include <string>

class TEComponent;
class TEUtilTexture;

typedef std::string String;

typedef unsigned int uint;

enum TEComponentEvent {
	EVENT_TOUCH_STARTED
	, EVENT_TOUCH_REJECT
	, EVENT_TOUCH_ACCEPT
	, EVENT_TOUCH_ENDED
	, EVENT_MOVE_TO_TOP
	, EVENT_ACCEPT_MOVE
	, EVENT_REJECT_MOVE
	, EVENT_MOVE_TO_FOUNDATION
	, EVENT_PRE_MOVE_TO_FOUNDATION
};

typedef TEComponentEvent TEComponentEvent;

struct TESize {
    float width;
    float height;	
};

typedef TESize TESize;

inline TESize TESizeMake(float newWidth, float newHeight) {
	TESize size;
	size.width = newWidth;
	size.height = newHeight;
	return size;
}

struct TEPoint {
    float x;
    float y;	
};

typedef TEPoint TEPoint;

inline TEPoint TEPointMake(float newX, float newY) {
	TEPoint point;
	point.x = newX;
	point.y = newY;
	return point;
}

typedef std::list<TEComponent*> TEComponentContainer;

struct TERect {
	float left;
	float right;
	float top;
	float bottom;
	
	bool overlaps(TERect rect) {
		return
		(left <= rect.right)
		&& (right >= rect.left)
		&& (bottom <= rect.top)
		&& (top >= rect.bottom);
	}
};

typedef TERect TERect;

inline TERect TERectMake(TEPoint position, TESize size) {
	TERect rect;
	rect.left = position.x - ((float)size.width / 2);
	rect.right = rect.left + size.width;
	rect.bottom = position.y - ((float)size.height / 2);
	rect.top = rect.bottom + size.height;
	return rect;
}

struct TEVec3 {
    float x;
    float y;
    float z;
};

typedef struct TEVec3 TEVec3;

struct TEColor4 {
    float r;
    float g;
    float b;
    float a;
};

typedef struct TEColor4 TEColor4;

inline TEColor4 TEColor4Make(float r, float g, float b, float a) {
    TEColor4 color;
    color.r = r;
    color.g = g;
    color.b = b;
    color.a = a;
    return color;
}

struct TERenderTexturePrimative {
    uint textureName;
    TEVec3 position;
    float* vertexBuffer;
    float* textureBuffer;
};

typedef TERenderTexturePrimative TERenderTexturePrimative;

struct TERenderPolygonPrimative {
    float* vertexBuffer;
    int vertexCount;
    TEVec3 position;
    TEColor4 color;
};

typedef TERenderPolygonPrimative TERenderPolygonPrimative;

inline double deg2rad(double deg) {
    return (deg * 3.14159265358979323846f / 180.0f);
}

#endif
