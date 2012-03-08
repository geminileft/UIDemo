precision mediump float;

varying vec2 vTextureCoord;

uniform sampler2D sTexture;

#define KERNEL_SIZE 9

uniform float uWidth;
uniform float uHeight;

void main() {
    // Gaussian kernel
    // 1 2 1
    // 2 4 2
    // 1 2 1
    /*
    float kernel[KERNEL_SIZE];
    kernel[0] = 1.0/16.0;
    kernel[1] = 2.0/16.0;
    kernel[2] = 1.0/16.0;
    kernel[3] = 2.0/16.0;
    kernel[4] = 4.0/16.0;
    kernel[5] = 2.0/16.0;
    kernel[6] = 1.0/16.0;
    kernel[7] = 2.0/16.0;
    kernel[8] = 1.0/16.0;
    */
     // Mean kernel
     // 1 1 1
     // 1 1 1
     // 1 1 1
     
    /*
     float kernel[KERNEL_SIZE];
     kernel[0] = 1.0/16.0;
     kernel[1] = 1.0/16.0;
     kernel[2] = 1.0/16.0;
     kernel[3] = 1.0/16.0;
     kernel[4] = 1.0/16.0;
     kernel[5] = 1.0/16.0;
     kernel[6] = 1.0/16.0;
     kernel[7] = 1.0/16.0;
     kernel[8] = 1.0/16.0;
     */
    
    // Emboss kernel
    // 2  0  0
    // 0 -1  0
    // 0  0 -1
    
    /*
    float kernel[KERNEL_SIZE];
    kernel[0] = 2.0/16.0;
    kernel[1] = 0.0/16.0;
    kernel[2] = 0.0/16.0;
    kernel[3] = 0.0/16.0;
    kernel[4] = -1.0/16.0;
    kernel[5] = 0.0/16.0;
    kernel[6] = 0.0/16.0;
    kernel[7] = 0.0/16.0;
    kernel[8] = -1.0/16.0;
    */
    // Emboss2 kernel
    // 2  0  0
    // 0 -1  0
    // 0  0 -1
    /*
    float kernel[KERNEL_SIZE];
    kernel[0] = -0.5/16.0;
    kernel[1] = 0.0/16.0;
    kernel[2] = 0.0/16.0;
    kernel[3] = 0.0/16.0;
    kernel[4] = 2.0/16.0;
    kernel[5] = 0.0/16.0;
    kernel[6] = 0.0/16.0;
    kernel[7] = 0.0/16.0;
    kernel[8] = 2.0/16.0;
    */
    //*
    // Laplacian kernel
    // 0  1  0
    // 1 -4  1
    // 0  1  0
    
    float kernel[KERNEL_SIZE];
    kernel[0] = 0.0/9.0;
    kernel[1] = 1.0/9.0;
    kernel[2] = 0.0/9.0;
    kernel[3] = 1.0/9.0;
    kernel[4] = -4.0/9.0;
    kernel[5] = 1.0/9.0;
    kernel[6] = 0.0/9.0;
    kernel[7] = 1.0/9.0;
    kernel[8] = 0.0/9.0;
    //*/
    
    /*
    // Sharpen kernel
    // -1  -1  -1
    // -1   9  -1
    // -1  -1  -1
    
    float kernel[KERNEL_SIZE];
    kernel[0] = -1.0/16.0;
    kernel[1] = -1.0/16.0;
    kernel[2] = -1.0/16.0;
    kernel[3] = -1.0/16.0;
    kernel[4] = 9.0/16.0;
    kernel[5] = -1.0/16.0;
    kernel[6] = -1.0/16.0;
    kernel[7] = -1.0/16.0;
    kernel[8] = -1.0/16.0;
    */
    
    float step_w = 1.0/uWidth;
    float step_h = 1.0/uHeight;
    
    vec2 offset[KERNEL_SIZE];
    offset[0] = vec2(-step_w, -step_h);
    offset[1] = vec2(0.0, -step_h);
    offset[2] = vec2(step_w, -step_h);
    offset[3] = vec2(-step_w, 0.0);
    offset[4] = vec2(0.0, 0.0);
    offset[5] = vec2(step_w, 0.0);
    offset[6] = vec2(-step_w, step_h);
    offset[7] = vec2(0.0, step_h);
    offset[8] = vec2(step_w, step_h);

    int i = 0;
    vec4 sum = vec4(0.0);
    
    if(vTextureCoord.s<0.495) {
        for( i=0; i<KERNEL_SIZE; i++ )
        {
			vec4 tmp = texture2D(sTexture, vTextureCoord.st + offset[i]);
			sum += tmp * kernel[i];
        }
    }
    else if( vTextureCoord.s>0.505 )
    {
		sum = texture2D(sTexture, vTextureCoord.xy);
    }
    else
    {
		sum = vec4(1.0, 0.0, 0.0, 1.0);
	}
    
    gl_FragColor = sum;
}