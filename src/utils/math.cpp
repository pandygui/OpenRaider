/*!
 *
 * \file src/utils/math.cpp
 * \brief Vector and Matrix math
 *
 * \author Mongoose
 */

#include <stdlib.h>
#include <math.h>
#include <float.h>
#include <assert.h>

#include "utils/Vector3d.h"
#include "utils/Matrix.h"
#include "utils/math.h"

bool equalEpsilon(vec_t a, vec_t b) {
    vec_t epsilon = FLT_EPSILON;
    if (fabs(a - b) <= (fmax(fabs(a), fabs(b)) * epsilon))
        return true;
    return false;
}


inline vec_t square(vec_t a)
{
    return a * a;
}


int helIntersectionLineAndPolygon(vec3_t intersect,
        vec3_t p1, vec3_t p2,
        vec3_t *polygon)
{
    assert(polygon != NULL);

    //  vec3_t normal, a, b;
    Vector3d a, b, normal, pA, pB;
    vec_t d, denominator, mu;


    pA = Vector3d(p1);
    pB = Vector3d(p2);

    // Find normal
    a = Vector3d(polygon[1]) - Vector3d(polygon[0]);
    b = Vector3d(polygon[2]) - Vector3d(polygon[0]);
    normal = Vector3d::cross(a, b);
    normal.normalize();

    // find D
    //d = (normal[0] * polygon[0][0] -
    //    normal[1] * polygon[0][1] -
    //    normal[2] * polygon[0][2]);
    d = (normal.mVec[0] * polygon[0][0] -
            normal.mVec[1] * polygon[0][1] -
            normal.mVec[2] * polygon[0][2]);

    // line segment parallel to plane?
    a = pB - pA;

    //denominator = (normal[0] * a[0] +
    //                  normal[1] * a[1] +
    //                  normal[2] * a[2]);
    denominator = Vector3d::dot(normal, a);

    if (denominator > 0.0)
        return 0;

    // Line segment contains intercept point?
    //mu = - ((d + normal[0] * p1[0] + normal[1] * p1[1] + normal[2] * p1[2]) /
    //        denominator);
    mu = -((d + Vector3d::dot(normal, pA)) / denominator);

    if (mu < 0.0 || mu > 1.0)
        return 0;

    //intersect[0] = p1[0] + mu * a[0];
    //intersect[1] = p1[1] + mu * a[1];
    //intersect[2] = p1[2] + mu * a[2];
    b = pA + (a * mu);
    intersect[0] = b.mVec[0];
    intersect[1] = b.mVec[1];
    intersect[2] = b.mVec[2];


    // See if the intercept is bound by polygon by winding number
    // assume convex polygons here for sure
    double theta = Vector3d::dot(b - Vector3d(polygon[0]), normal); // b = intersect

    if (theta >= 90.0) // Yeah I know
        return 0;

    return 1;
}


vec_t helDist3v(vec3_t a, vec3_t b)
{
    return (sqrtf( ((b[0] - a[0]) * (b[0] - a[0])) +
                ((b[1] - a[1]) * (b[1] - a[1])) +
                ((b[2] - a[2]) * (b[2] - a[2]))));
}


void helMidpoint3v(vec3_t a, vec3_t b, vec3_t mid)
{
    mid[0] = (a[0] + b[0]) / 2.0f;
    mid[1] = (a[1] + b[1]) / 2.0f;
    mid[2] = (a[2] + b[2]) / 2.0f;
}


vec_t helNorm4v(vec4_t v)
{
    return (sqrtf(v[0]*v[0] + v[1]*v[1] + v[2]*v[2] + v[3]*v[3]));
}


vec_t helNorm3v(vec3_t v)
{
    return (sqrtf(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]));
}


vec_t helNorm2v(vec2_t v)
{
    return (sqrtf(v[0]*v[0] + v[1]*v[1]));
}


vec_t helRandomNum(vec_t from, vec_t to)
{
    return from + ((to - from) * rand() / (RAND_MAX + 1.0f));
}
