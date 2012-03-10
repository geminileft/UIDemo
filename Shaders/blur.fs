precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

#define KERNEL_SIZE 9

uniform vec2 uOffsets[KERNEL_SIZE];
uniform float uKernel[KERNEL_SIZE];

void main() {
    int i = 0;
    vec4 sum = vec4(0.0);
    
    if(vTextureCoord.s<0.495) {
        for( i=0; i<KERNEL_SIZE; i++ )
        {
			sum += texture2D(sTexture, vTextureCoord.st + uOffsets[i]) * uKernel[i];
        }
        sum.a = 1.0;
    }
    else if( vTextureCoord.s>0.505 )
    {
		sum = texture2D(sTexture, vTextureCoord.st);
    }
    else
    {
		sum = vec4(0.0, 0.0, 1.0, 1.0);
	}
    
    gl_FragColor = sum;
}