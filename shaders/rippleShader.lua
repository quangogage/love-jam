
return [[
    #define PI 3.1415926535897932384626433832795

    extern number rippleFrequency;    // Frequency of the ripple effect
    extern number rippleIntensity;    // Intensity of the ripple effect
    extern number rippleSpeed;        // Speed of the ripple effect
    extern number timeValue;          // Time value for animation

    vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
        vec2 uv = textureCoords;

        // Apply ripple effect using time and speed
        float xRipple = sin((uv.y + timeValue * rippleSpeed) * rippleFrequency) * rippleIntensity * 0.005;
        float yRipple = sin((uv.x + timeValue * rippleSpeed) * rippleFrequency) * rippleIntensity * 0.005;
        uv.x += xRipple;
        uv.y += yRipple;

        // Sample original texture
        vec4 originalColor = Texel(texture, uv);

        return originalColor * color;
    }
]]

