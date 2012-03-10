precision highp float;

uniform vec2 uOffsets[9];

uniform sampler2D sTexture;

const highp vec3 W = vec3(0.2125, 0.7154, 0.0721);

void main()
{
    float im1m1 = texture2D(sTexture, uOffsets[0]).r;
    float i00   = texture2D(sTexture, uOffsets[1]).r;
    float ip1m1 = texture2D(sTexture, uOffsets[2]).r;

    float im1p1 = texture2D(sTexture, uOffsets[3]).r;
    float i0p1 = texture2D(sTexture, uOffsets[4]).r;
    float ip1p1 = texture2D(sTexture, uOffsets[5]).r;

    float im10 = texture2D(sTexture, uOffsets[6]).r;
    float i0m1 = texture2D(sTexture, uOffsets[7]).r;
    float ip10 = texture2D(sTexture, uOffsets[8]).r;

    float h = -im1p1 - 2.0 * i0p1 - ip1p1 + im1m1 + 2.0 * i0m1 + ip1m1;
    float v = -im1m1 - 2.0 * im10 - im1p1 + ip1m1 + 2.0 * ip10 + ip1p1;
    
    float mag = 1.0 - length(vec2(h, v));
    
    gl_FragColor = vec4(vec3(mag), 1.0);
}
