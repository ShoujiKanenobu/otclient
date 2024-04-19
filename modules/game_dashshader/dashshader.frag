uniform vec4 u_Color;
varying vec2 v_TexCoord;
uniform sampler2D u_Tex0;
uniform lowp float u_Opacity;
varying float v_instanceID;
lowp vec4 calculatePixel();
const float ALPHA_TOLERANCE = 0.01;
void main()
{
    if(v_instanceID == 0)
    {
        //Red outline from https://otland.net/threads/help-with-shader-outline.283875/
        //Modifications to simplifly it and make it compatible with this version of OTClient
        vec4 baseColor = texture2D(u_Tex0, v_TexCoord);

        //Get Neighbor pixels
        vec4 pixel1 = texture2D(u_Tex0, vec2(v_TexCoord.x + 0.001, v_TexCoord.y));
        vec4 pixel2 = texture2D(u_Tex0, vec2(v_TexCoord.x - 0.001, v_TexCoord.y));
        vec4 pixel3 = texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y + 0.001));
        vec4 pixel4 = texture2D(u_Tex0, vec2(v_TexCoord.x, v_TexCoord.y - 0.001));

        bool neighbourColor = pixel4.a > ALPHA_TOLERANCE || pixel3.a > ALPHA_TOLERANCE || pixel2.a > ALPHA_TOLERANCE || pixel1.a > ALPHA_TOLERANCE;

        //Set pixel to red
        if (baseColor.a < ALPHA_TOLERANCE && neighbourColor) {
            baseColor.rgb = vec3(1.0, 0.0, 0.0);
            baseColor.a = 0.7;
        }
        gl_FragColor = baseColor;
        if(gl_FragColor.a < 0.01) discard;   
    }
    else
    {
        //Do default fragment shader
        gl_FragColor = calculatePixel();
        gl_FragColor.a *= u_Opacity;
        //Fade
        gl_FragColor.a -= v_instanceID * 0.1;
    }
         
}

lowp vec4 calculatePixel() {
    return texture2D(u_Tex0, v_TexCoord) * u_Color;
}