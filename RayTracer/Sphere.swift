//
// Ray caster/tracer skeleton code and scene files adapted from starter code
// provided by MIT 6.837 on OCW.
//
// All additional code written by Dion Larson unless noted otherwise.
//
// Original skeleton code available for free here (assignments 4 & 5):
// http://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-837-computer-graphics-fall-2012/
//
// Licensed under Creative Commons 4.0 (Attribution, Noncommercial, Share Alike)
// http://creativecommons.org/licenses/by-nc-sa/4.0/
//


import Foundation
import simd

class Sphere: ObjectType, CustomStringConvertible {
    
    private let center: vector_float3
    private let radius: Float
    internal let material: Material
    
    internal var description: String {
        get {
            return "Sphere <\(center), \(radius)>"
        }
    }
    
    init(center: vector_float3, radius: Float, material: Material) {
        self.center = center
        self.radius = radius
        self.material = material
    }
    
    func intersect(ray r: Ray, tMin: Float, hit h: Hit) -> Bool {
        let newOrigin = r.origin - self.center
        
        let inside = ((2 * dot(r.direction, newOrigin)) ** 2 - 4 * (r.direction.x ** 2 + r.direction.y ** 2 + r.direction.z ** 2) * (dot(newOrigin, newOrigin) - radius ** 2))
        if inside <= 0 { return false }
        
        let d = sqrt(inside)
        
        let t1 = (-1 * (2 * dot(r.direction, newOrigin)) + d)/(2 * (r.direction.x ** 2 + r.direction.y ** 2 + r.direction.z ** 2))
        let t2 = (-1 * (2 * dot(r.direction, newOrigin)) - d)/(2 * (r.direction.x ** 2 + r.direction.y ** 2 + r.direction.z ** 2))
        
        if t1 <= tMin || t1 >= h.t && t2 < tMin || t2 >= h.t { return false }
        
        let trueT = max(t1, t2)
        
//        let normal = normalize(newOrigin + trueT * r.direction)
        let normal = r.pointAtParameter(trueT)
        
        h.set(t: trueT, material: material, normal: normal)
        
        return true
    }
    
}