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

class Material {
    
    internal let diffuseColor: vector_float3
    private let specularColor: vector_float3
    private let shininess: Float
    private var texture: Texture?
    var hasTexture: Bool {
        return texture != nil
    }
    
    init(diffuseColor: vector_float3, specularColor: vector_float3, shininess: Float, textureName: String?) {
        self.diffuseColor = diffuseColor
        self.specularColor = specularColor
        self.shininess = shininess
        if let textureName = textureName {
            self.texture = Texture(filename: textureName)
        }
    }
    
    func setupTexture(textureFilename: String) {
        texture = Texture(filename: textureFilename)
    }
    
    func shade(ray: Ray, hit: Hit, lightInfo light: (direction: vector_float3, color: vector_float3)) -> vector_float3 {
        // 100% working Jimmy version
//        let shaded = diffuseColor * max(0, dot(hit.normal!, light.direction)) * light.color
        
        guard let normal = hit.normal else {
            fatalError("Hit doesn't have normal")
        }
        
        let influence = dot(light.direction, normal)
        if influence <= 0 {
            return vector_float3(0, 0, 0)
        }
        
        var shade = textureOrDiffuseColor(hit.textureCoords) * max(dot(light.direction, normal), 0) * light.color
        
        let v = -light.direction + 2 * influence * normal
        let R = max(dot(-ray.direction, v), 0) ** shininess
        shade += specularColor * R * light.color
        
        return shade
        
        
//        let diffuseInfluence = max(dot(hit.normal!, light.direction), 0)
//        
//        if diffuseInfluence == 0 { return vector_float3() }
//        
//        let diffuseShading = diffuseColor * diffuseInfluence * light.color
//        
//        let reflectionAngle = -1 * light.direction + 2 * dot(light.direction, hit.normal!) * hit.normal!
//
//        let specularInfluence = max(dot(ray.direction, normalize(reflectionAngle)), 0)
//        
////        if specularInfluence == 0 { return vector_float3() }
//        
//        let specularShading = specularColor * (specularInfluence ** shininess) * light.color
//        
//        let shading = diffuseShading + specularShading
//
//        return shading
    }
    
    func textureOrDiffuseColor(textureCoords: vector_float2?) -> vector_float3 {
        if let texture = texture, let textureCoords = textureCoords {
            return texture.colorAt(textureCoords)
        }
        return vector_float3()
    }
    
}