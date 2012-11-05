#define DEGREES_TO_RADIANS(angle)( ( angle ) / 180.0 * M_PI )
#define RADIANS_TO_DEGREES( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

inline float clampf( float v, float min, float max )
{
    if( v < min ) v = min;
    if( v > max ) v = max;
    
    return v;
}
