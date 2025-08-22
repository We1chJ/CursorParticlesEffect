attribute float aIntensity;
attribute float aAngle;
uniform sampler2D uTexture;
uniform vec2 uResolution;
varying vec3 vColor;
uniform sampler2D uDisplacementTexture;
void main()
{
    vec3 newPos = position;
    float displacementIntensity = texture(uDisplacementTexture, uv).r;
    displacementIntensity = smoothstep(0.1, 0.3, displacementIntensity);
    vec3 displacement = vec3(
        cos(aAngle) * 0.2, 
        sin(aAngle) * 0.2,
        1.0
    );
    displacement = normalize(displacement);
    displacement *= displacementIntensity;

    displacement *= 3.0;
    displacement *= aIntensity;
    newPos += displacement;
    


    // Final position
    vec4 modelPosition = modelMatrix * vec4(newPos, 1.0);
    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    float intensity = texture(uTexture, uv).r;

    // Point size
    gl_PointSize = 0.15 * uResolution.y * intensity;
    gl_PointSize *= (1.0 / - viewPosition.z);

    vColor = vec3(pow(intensity, 2.0));
}