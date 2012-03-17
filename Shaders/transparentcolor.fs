precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

struct HSL {
    float h;
    float s;
    float l;
};


HSL RGB2HSL(vec3 c1)
{
    float themin,themax,delta;
    HSL c2;
    
    themin = min(c1.r,min(c1.g,c1.b));
    themax = max(c1.r,max(c1.g,c1.b));
    delta = themax - themin;
    c2.l = (themin + themax) / 2.0;
    c2.s = 0.0;
    if (c2.l > 0.0 && c2.l < 1.0)
        c2.s = delta / (c2.l < 0.5 ? (2.0*c2.l) : (2.0-2.0*c2.l));
    c2.h = 0.0;
    if (delta > 0.0) {
        if (themax == c1.r && themax != c1.g)
            c2.h += (c1.g - c1.b) / delta;
        if (themax == c1.g && themax != c1.b)
            c2.h += (2.0 + (c1.b - c1.r) / delta);
        if (themax == c1.b && themax != c1.r)
            c2.h += (4.0 + (c1.r - c1.g) / delta);
        c2.h *= 60.0;
    }
    return(c2);
}

void main() {
    vec4 color = texture2D(sTexture, vTextureCoord);

    HSL h = RGB2HSL(color.rgb);
    if (h.l <= 0.2) {
        color.a = 0.0;
    }
    
	gl_FragColor = color;
}
