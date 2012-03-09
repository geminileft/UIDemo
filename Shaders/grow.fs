precision mediump float;
varying vec2 vTextureCoord;
uniform sampler2D sTexture;

void main() {
	vec2 cen = vec2(0.5, 0.5) - vTextureCoord.xy;
	vec2 mcen = -0.07*log(length(cen))*normalize(cen);
	gl_FragColor = texture2D(sTexture, vTextureCoord.xy-mcen);
}
