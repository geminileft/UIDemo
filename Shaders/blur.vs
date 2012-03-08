uniform mat4 uViewMatrix;
uniform mat4 uProjectionMatrix;

attribute vec4 aVertices;
attribute vec2 aTextureCoords;
attribute vec2 aPosition;

varying vec2 vTextureCoord;
varying   mediump vec2 t1;				//Texture coordinate passed to fragment.
varying mediump vec2 t2;				//Texture location for fragment directly above.
varying mediump vec2 t3;				//Texture location for fragment directly to the right.

void main() {
	mat4 identityMatrix = mat4(1.0,0.0,0.0,0.0, 0.0,1.0,0.0,0.0, 0.0,0.0,1.0,0.0, aPosition.x,aPosition.y,0.0,1.0);
	gl_Position = (uProjectionMatrix * (uViewMatrix * (identityMatrix))) * aVertices;
	vTextureCoord = aTextureCoords;

	t1 = aTextureCoords;
	t2 = vec2(aTextureCoords.x, aTextureCoords.y+1);
	t3 = vec2(aTextureCoords.x+1, aTextureCoordsd.y);
}
