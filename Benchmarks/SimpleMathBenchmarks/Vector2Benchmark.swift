//
//  Vector2Benchmark.swift
//  SimpleMath
//
//  Created by mtakagi on 2026/03/01.
//

import Benchmark
import SimpleMath
import simd

func registerVector2Benchmarks(configuration: Benchmark.Configuration) {
    Benchmark("Vector2: sqrMagnitude", configuration: configuration) { benchmark in
        let v = Vector2(1, 2)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(v.sqrMagnitude())
        }
    }
    
    Benchmark("Vector2: sqrMagnitude vs SIMD2<Float>", configuration: configuration) { benchmark in
        let v = SIMD2<Float>(1, 2)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_length_squared(v))
        }
    }
    
    Benchmark("Vector2: min", configuration: configuration) { benchmark in
        let v1 = Vector2(1, 2)
        let v2 = Vector2(3, 4)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector2.min(v1, v2))
        }
    }
    
    Benchmark("Vector2: min vs SIMD2<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD2<Float>(1, 2)
        let v2 = SIMD2<Float>(3, 4)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(min(v1, v2))
        }
    }
    
    Benchmark("Vector2: max", configuration: configuration) { benchmark in
        let v1 = Vector2(1, 2)
        let v2 = Vector2(3, 4)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector2.max(v1, v2))
        }
    }
    
    Benchmark("Vector2: max vs SIMD2<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD2<Float>(1, 2)
        let v2 = SIMD2<Float>(3, 4)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(max(v1, v2))
        }
    }
}
