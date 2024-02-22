-- Crystal ball shader code
local crystalBallShaderCode = [[
    extern number distortionAmount;  // Amount of distortion
    extern number refractionAmount;  // Amount of refraction

    vec2 distort(vec2 uv) {
        // Apply distortion effect based on uv coordinates
        vec2 distortedUV = uv - 0.5;  // Center coordinates
        distortedUV *= 1.0 + distortionAmount * pow(length(distortedUV), 2.0);
        distortedUV += 0.5;  // Restore to original coordinates
        return distortedUV;
    }

    vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
        // Apply distortion to texture coordinates
        vec2 distortedCoords = distort(textureCoords);

        // Apply refraction effect based on distorted coordinates
        vec2 refractedCoords = textureCoords + (distortedCoords - textureCoords) * refractionAmount;

        // Sample original texture with refraction
        vec4 finalColor = Texel(texture, refractedCoords);

        return finalColor * color;
    }
]]

return crystalBallShaderCode
