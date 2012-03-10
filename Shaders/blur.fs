precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

#define KERNEL_SIZE 9

uniform float uWidth;
uniform float uHeight;

uniform float uOffsets[KERNEL_SIZE];
uniform float uKernel[KERNEL_SIZE];

void main() {
    int i = 0;
    vec4 sum = vec4(0.0);
    
    if(vTextureCoord.s<0.495) {
        for( i=0; i<KERNEL_SIZE; i++ )
        {
			sum += texture2D(sTexture, vTextureCoord.st + uOffsets[i]) * uKernel[i];
        }
    }
    else if( vTextureCoord.s>0.505 )
    {
		sum = texture2D(sTexture, vTextureCoord.st);
        sum.a *= 0.5;
    }
    else
    {
		sum = vec4(0.0, 0.0, 1.0, 1.0);
	}
    
    gl_FragColor = sum;
}