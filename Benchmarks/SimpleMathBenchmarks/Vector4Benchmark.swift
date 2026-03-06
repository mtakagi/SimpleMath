//
//  Vector4Benchmark.swift
//  SimpleMath
//
//  Created by mtakagi on 2026/03/01.
//

import Benchmark
import SimpleMath
import simd

func registerVector4Benchmarks(configuration : Benchmark.Configuration) {
    Benchmark("Vector4: magnitude", configuration: configuration) { benchmark in
        let v = Vector4(3, 4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(v.magnitude())
        }
    }
    
    Benchmark("Vector4: magnitude vs SIMD4<Float>", configuration: configuration) { benchmark in
        let v = SIMD4<Float>(3, 4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_length(v))
        }
    }
    
    Benchmark("Vector4: sqrMagnitude", configuration: configuration) { benchmark in
        let v = Vector4(3, 4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(v.sqrMagnitude())
        }
    }
    
    Benchmark("Vector4: sqrMagnitude vs SIMD4<Float>", configuration: configuration) { benchmark in
        let v = SIMD4<Float>(3, 4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_length_squared(v))
        }
    }
    
    Benchmark("Vector4: normalize", configuration: configuration) { benchmark in
        let v = Vector4(3, 4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(v.normalized())
        }
    }
    
    Benchmark("Vector4: normalize vs SIMD4<Float>", configuration: configuration) { benchmark in
        let v = SIMD4<Float>(3, 4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_normalize(v))
        }
    }
    
    Benchmark("Vector4: min", configuration: configuration) { benchmark in
        let v1 = Vector4(1, 2, 3, 4)
        let v2 = Vector4(5, 6, 7, 8)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector4.min(v1, v2))
        }
    }
    
    Benchmark("Vector4: min vs SIMD4<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD4<Float>(1, 2, 3, 4)
        let v2 = SIMD4<Float>(5, 6, 7, 8)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(min(v1, v2))
        }
    }
    
    Benchmark("Vector4: max", configuration: configuration) { benchmark in
        let v1 = Vector4(1, 2, 3, 4)
        let v2 = Vector4(5, 6, 7, 8)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector4.max(v1, v2))
        }
    }
    
    Benchmark("Vector4: max vs SIMD4<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD4<Float>(1, 2, 3, 4)
        let v2 = SIMD4<Float>(5, 6, 7, 8)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(max(v1, v2))
        }
    }
}
