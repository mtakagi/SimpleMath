//
//  Matrix4x4Benchmark.swift
//  SimpleMath
//
//  Created by mtakagi on 2026/03/07.
//

import Benchmark
import SimpleMath
import simd

func registerMatrix4x4Benchmarks(configuration : Benchmark.Configuration) {
    Benchmark("Matrix4x4: inverse", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [Matrix4x4] = (0..<count).map { _ in
            Matrix4x4(Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10),
                      Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10),
                      Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10),
                      Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10))
        }
            
        for i in benchmark.scaledIterations {
            let m = inputs[i & (count - 1)]
            Benchmark.blackHole(m.inverse())
        }
    }
        
    Benchmark("Matrix4x4: inverse vs simd", configuration: configuration) { benchmark in
        let count = 1024
        let inputs: [simd_float4x4] = (0..<count).map { _ in
            simd_float4x4(SIMD4<Float>(Float.random(in: -10...10), Float.random(in: -10...10),Float.random(in: -10...10), Float.random(in: -10...10)),
                          SIMD4<Float>(Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10)),
                          SIMD4<Float>(Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10)),
                          SIMD4<Float>(Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10), Float.random(in: -10...10)))
        }
            
        for i in benchmark.scaledIterations {
            let m = inputs[i & (count - 1)]
            Benchmark.blackHole(simd_inverse(m))
        }
    }
    
    Benchmark("Matrix4x4: TRS", configuration: configuration) { benchmark in
        let pos = Vector3(10, 20, 30)
        let rot = Quaternion(simd_quatf(angle: 1.0, axis: SIMD3<Float>(0, 1, 0)).vector)
        let scl = Vector3(2, 2, 2)
        
        for _ in benchmark.scaledIterations {
            let t = Matrix4x4.translate(pos)
            let r = Matrix4x4.rotate(rot)
            let s = Matrix4x4.scale(scl)
            
            Benchmark.blackHole(t * r * s)
        }
    }
}
