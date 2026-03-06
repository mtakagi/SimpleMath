//
//  QuaternionBenchmark.swift
//  SimpleMath
//
//  Created by mtakagi on 2026/03/03.
//

import Benchmark
import SimpleMath
import simd

func registerQuaternionBenchmarks(configuration : Benchmark.Configuration) {
    func angleAxis(degree : Float, _ axis : simd_float3) -> Quaternion {
        let q = simd_quatf(angle: degree * (.pi / 180), axis: simd_normalize(axis))
        
        return Quaternion(q.vector)
    }
    
    func euler(pitchDegree: Float, yawDegree: Float, rollDegree: Float) -> Quaternion {
        let hx = pitchDegree * (.pi / 180) * 0.5
        let hy = yawDegree   * (.pi / 180) * 0.5
        let hz = rollDegree  * (.pi / 180) * 0.5

        var sx: Float = 0, cx: Float = 0
        var sy: Float = 0, cy: Float = 0
        var sz: Float = 0, cz: Float = 0

        __sincosf(hx, &sx, &cx)
        __sincosf(hy, &sy, &cy)
        __sincosf(hz, &sz, &cz)

        return Quaternion(
            x:  cz*sx*cy - sz*cx*sy,
            y:  cz*cx*sy + sz*sx*cy,
            z:  sz*cx*cy + cz*sx*sy,
            w:  cz*cx*cy - sz*sx*sy
        )
    }
    
    func fromToRotation(fromDir: Vector3, toDir: Vector3) -> Quaternion {
        let f = fromDir.normalized()
        let t = toDir.normalized()
        
        return Quaternion(simd_quatf(from: f.simd, to: t.simd).vector)
    }
    
    func lookRotation(_ forward: Vector3, _ up: Vector3) -> Quaternion {
        let f = simd_normalize(forward.simd)
        var u = simd_normalize(up.simd)
        var r = simd_cross(u, f)
        
        let epsilon: Float = 1e-6
        if simd_length_squared(r) < epsilon {
            return Quaternion.fromToRotation(fromDir: .forward, toDir: forward)
        }
        
        r = simd_normalize(r)
        u = simd_cross(f, r)
        
        return Quaternion(simd_quatf(simd_float3x3(r, u, f)).vector)
    }
    
    Benchmark("Quaternion: axisAngle", configuration: configuration) { benchmark in
        let axis: Vector3 = .init(1, 0, 0)

        for i in benchmark.scaledIterations {
            Benchmark.blackHole(Quaternion.angleAxis(degree: Float(i), axis))
        }
    }
    
    Benchmark("Quaternion: axisAngle vs simd", configuration: configuration) { benchmark in
        let axis: simd_float3 = .init(1, 0, 0)

        for i in benchmark.scaledIterations {
            Benchmark.blackHole(angleAxis(degree: Float(i), axis))
        }
    }
    
    Benchmark("Quaternion: euler", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [(Float, Float, Float)] = (0..<count).map { _ in
            (Float.random(in: 0..<360), Float.random(in: 0..<360), Float.random(in: 0..<360))
        }
        
        for i in benchmark.scaledIterations {
            let (pitch, yaw, roll) = inputs[i & (count - 1)]
            
            Benchmark.blackHole(Quaternion.euler(pitchDegree: pitch, yawDegree: yaw, rollDegree: roll))
        }
    }
    
    Benchmark("Quaternion: euler(optimized)", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [(Float, Float, Float)] = (0..<count).map { _ in
            (Float.random(in: 0..<360), Float.random(in: 0..<360), Float.random(in: 0..<360))
        }
        
        for i in benchmark.scaledIterations {
            let (pitch, yaw, roll) = inputs[i & (count - 1)]

            Benchmark.blackHole(euler(pitchDegree: pitch, yawDegree: yaw, rollDegree: roll))
        }
    }
    
    Benchmark("Quaternion: mul", configuration: configuration) { benchmark in
        let q1 = Quaternion(x: 1, y: 2, z: 3, w: 4)
        let q2 = Quaternion(x: 5, y: 6, z: 7, w: 8)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(q1 * q2)
        }
    }
    
    Benchmark("Quaternion: mul vs simd", configuration: configuration) { benchmark in
        let q1 = simd_quatf(ix: 1, iy: 2, iz: 3, r: 4)
        let q2 = simd_quatf(ix: 5, iy: 6, iz: 7, r: 8)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(q1 * q2)
        }
    }
    
    Benchmark("Quaternion: fromToRotation", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [(Vector3, Vector3)] = (0..<count).map { _ in
            return (Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)), Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)))
        }
        
        for i in benchmark.scaledIterations {
            let (from, to) = inputs[i & (count - 1)]
            Benchmark.blackHole(Quaternion.fromToRotation(fromDir: from, toDir: to))
        }
    }
    
    Benchmark("Quaternion: fromToRotation vs simd", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [(Vector3, Vector3)] = (0..<count).map { _ in
            return (Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)), Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)))
        }
        
        for i in benchmark.scaledIterations {
            let (from, to) = inputs[i & (count - 1)]
            Benchmark.blackHole(fromToRotation(fromDir: from, toDir: to))
        }
    }
    
    Benchmark("Quaternion: fromToRotation vs simd no normalize", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [(Vector3, Vector3)] = (0..<count).map { _ in
            return (Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)), Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)))
        }
        
        for i in benchmark.scaledIterations {
            let (from, to) = inputs[i & (count - 1)]
            Benchmark.blackHole(simd_quatf(from: from.simd, to: to.simd))
        }
    }
    
    Benchmark("Quaternion: lookRotation", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [(Vector3, Vector3)] = (0..<count).map { _ in
            return (Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)), Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)))
        }
        
        for i in benchmark.scaledIterations {
            let (forward, up) = inputs[i & (count - 1)]
            Benchmark.blackHole(Quaternion.lookRotation(forward, up))
        }
    }
    
    Benchmark("Quaternion: lookRotation vs Fast", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [(Vector3, Vector3)] = (0..<count).map { _ in
            return (Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)), Vector3(Float.random(in: -1...1), Float.random(in: -1...1), Float.random(in: -1...1)))
        }
        
        for i in benchmark.scaledIterations {
            let (forward, up) = inputs[i & (count - 1)]
            Benchmark.blackHole(lookRotation(forward, up))
        }
    }
}
