return [[
    extern number distortionAmount;  // Amount of distortion
    extern number refractionAmount;  // Amount of refraction
    extern number zoomFactor;         // Zoom factor

    vec2 distort(vec2 uv) {
        // Apply distortion effect based on uv coordinates
        vec2 distortedUV = uv - 0.5;  // Center coordinates
        distortedUV *= 1.0 + distortionAmount * pow(length(distortedUV), 2.0);
        distortedUV += 0.5;  // Restore to original coordinates
        return distortedUV;
    }

    vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
        // Apply zoom to texture coordinates
        vec2 zoomedCoords = textureCoords * vec2(zoomFactor, zoomFactor) + vec2((1.0 - zoomFactor) / 2.0);

        // Apply distortion to zoomed texture coordinates
        vec2 distortedCoords = distort(zoomedCoords);

        // Apply refraction effect based on distorted coordinates
        vec2 refractedCoords = textureCoords + (distortedCoords - zoomedCoords) * refractionAmount;

        // Sample original texture with refraction
        vec4 finalColor = Texel(texture, refractedCoords);

        return finalColor * color;
    }
]]
