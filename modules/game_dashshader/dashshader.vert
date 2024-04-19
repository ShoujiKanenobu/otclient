attribute highp vec2 a_TexCoord;
uniform highp mat3 u_TextureMatrix;
varying highp vec2 v_TexCoord;
varying highp vec2 v_TexCoord2;
uniform int u_direction;
varying float v_instanceID;
highp vec4 calculatePosition();
highp vec4 calculateDir();
void main()
{
    //The default vertex code with the position modified via calculateDir()
    gl_Position = calculatePosition() + calculateDir();
    v_TexCoord = (u_TextureMatrix * vec3(a_TexCoord,1.0)).xy;
    //Pass the instanceID to the fragment shader
    v_instanceID = gl_InstanceID;
}

attribute highp vec2 a_Vertex;
uniform highp mat3 u_TransformMatrix;
uniform highp mat3 u_ProjectionMatrix;
highp vec4 calculatePosition() {
    return vec4(u_ProjectionMatrix * u_TransformMatrix * vec3(a_Vertex.xy, 1.0), 1.0);
}

//The 0.04 Determines the distance between each afterimage
highp vec4 calculateDir() {
    if(u_direction == 0)
    {
        return vec4(0.0, -1.0 * gl_InstanceID * 0.04, 0.0, 0.0);
    } 
    else if(u_direction == 1) 
    {
        return vec4(-1.0 * gl_InstanceID * 0.04, 0.0, 0.0, 0.0);
    } 
    else if(u_direction == 2) 
    {
        return vec4(0.0, gl_InstanceID * 0.04, 0.0, 0.0);
    } 
    else if(u_direction == 3)
    {
        return vec4(gl_InstanceID * 0.04, 0.0, 0.0, 0.0);
    } else {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }
}