precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

#define KERNEL_SIZE 9

uniform float uWidth;
uniform float uHeight;

// Swirl effect parameters

vec4 PostFX(sampler2D tex, vec2 uv)
{
    float radius = 200.0;
    float angle = 0.8;
    vec2 center = vec2(400.0, 300.0);

    vec2 texSize = vec2(uWidth, uHeight);
    vec2 tc = uv * texSize;
    tc -= center;
    float dist = length(tc);

    if (dist < radius)
    {
        float percent = (radius - dist) / radius;
        float theta = percent * percent * angle * 8.0;
        float s = sin(theta);
        float c = cos(theta);
        tc = vec2(dot(tc, vec2(c, -s)), dot(tc, vec2(s, c)));
    }
    tc += center;

    vec3 color = texture2D(tex, tc / texSize).rgb;

    //return vec4(1.0, 1.0, 1.0, 1.0);
    return vec4(color, 1.0);
}

void main ()
{

    vec2 uv = vTextureCoord.st;
    gl_FragColor = PostFX(sTexture, uv);
}