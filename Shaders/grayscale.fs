precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

void main() {
    vec4 color = texture2D(sTexture, vTextureCoord);
    //float value = (color.r + color.g + color.b) / 3.0;
    vec3 grayMultiplier = vec3(0.3, 0.59, 0.11);
    float value = dot(color.rgb, grayMultiplier);
    color.r = value;
    color.g = value;
    color.b = value;
	gl_FragColor = color;
}
