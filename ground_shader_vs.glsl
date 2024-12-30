#version 100

precision highp float;

attribute vec3 vertexPosition;
uniform mat4 mvp;
varying vec3 localPosition;

void main()
{
    localPosition = vertexPosition;
    gl_Position = mvp*vec4(vertexPosition, 1.0);
}