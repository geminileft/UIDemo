/**
 * Toon Lines shader by Jose I. Romero (cyborg_ar)
 *
 * Based on blender's built-in "prewitt" filter which is free software
 * released under the terms of the GNU General Public License version 2
 *
 * The original code is (c) Blender Foundation.
 */

precision mediump float;

uniform sampler2D bgl_RenderedTexture;
uniform vec2 uOffsets[9];
varying vec2 vTextureCoord;

void main()
{
    vec4 sample[9];
    vec4 border;
    vec4 texcol = texture2D(bgl_RenderedTexture, vTextureCoord.st);
    
    for (int i = 0; i < 9; i++)
    {
        sample[i] = texture2D(bgl_RenderedTexture,
                              vTextureCoord.st + uOffsets[i]);
    }
    
    vec4 horizEdge = sample[2] + sample[5] + sample[8] -
    (sample[0] + sample[3] + sample[6]);
    
    vec4 vertEdge = sample[0] + sample[1] + sample[2] -
    (sample[6] + sample[7] + sample[8]);
    
    border.rgb = sqrt((horizEdge.rgb * horizEdge.rgb) +
                      (vertEdge.rgb * vertEdge.rgb));
    
    if (border.r > 0.4||border.g > 0.4||border.b > 0.4){
        gl_FragColor.r = 0.0;
        gl_FragColor.g = 0.0;
        gl_FragColor.b = 0.0;
        gl_FragColor.a = 1.0;
    }else{
        gl_FragColor.rgb = texcol.rgb;
        gl_FragColor.a = 1.0;
    }
}