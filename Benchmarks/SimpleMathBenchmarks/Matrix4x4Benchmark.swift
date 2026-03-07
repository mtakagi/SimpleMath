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
        let m = Matrix4x4(
            1, 2, 3, 4,
            2, 3, 4, 1,
            3, 4, 1, 2,
            4, 1, 2, 3
        )
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(m.inverse())
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
