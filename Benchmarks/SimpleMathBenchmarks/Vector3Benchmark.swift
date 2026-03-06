//
//  Vector3Benchmark.swift
//  SimpleMath
//
//  Created by mtakagi on 2026/03/01.
//

import Benchmark
import SimpleMath
import simd

func registerVector3Benchmarks(configuration : Benchmark.Configuration) {
    @_optimize(none)
    func dot(_ v1 : Float, _ v2 : Float, _ v3 : Float, _ v4 : Float, _ v5 : Float, _ v6 : Float) -> Float {
        return v1 * v4 + v2 * v5 + v3 * v6
    }
    
    Benchmark("Vector3: dot product(no optimization)", configuration: configuration) { benchmark in
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(dot(1, 2, 3, 4, 5, 6))
        }
    }
    
    Benchmark("Vector3: dot product", configuration: configuration) { benchmark in
        let a = Vector3(1, 2, 3)
        let b = Vector3(4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector3.dot(a, b))
        }
    }

    Benchmark("Vector3: dot product vs SIMD3<Float>", configuration: configuration) { benchmark in
        let a = SIMD3<Float>(1, 2, 3)
        let b = SIMD3<Float>(4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_dot(a, b))
        }
    }
    
    Benchmark("Vector3: cross product", configuration: configuration) { benchmark in
        let a = Vector3(1, 2, 3)
        let b = Vector3(4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector3.cross(a, b))
        }
    }
    
    Benchmark("Vector3: cross product vs SIMD3<Float>", configuration: configuration) { benchmark in
        let a = SIMD3<Float>(1, 2, 3)
        let b = SIMD3<Float>(4, 5, 6)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_cross(a, b))
        }
    }

    Benchmark("Vector3: magnitude", configuration: configuration) { benchmark in
        let v = Vector3(3, 4, 5)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(v.magnitude())
        }
    }
    
    Benchmark("Vector3: magnitude vs SIMD3<Float>", configuration: configuration) { benchmark in
        let v = SIMD3<Float>(3, 4, 5)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_length(v))
        }
    }
    
    Benchmark("Vector3: sqrMagnitude", configuration: configuration) { benchmark in
        let v = Vector3(3, 4, 5)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(v.sqrMagnitude())
        }
    }
    
    Benchmark("Vector3: sqrMagnitude vs SIMD3<Float>", configuration: configuration) { benchmark in
        let v = SIMD3<Float>(3, 4, 5)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_length_squared(v))
        }
    }
    
    Benchmark("Vector3: normalize", configuration: configuration) { benchmark in
        let v = Vector3(3, 4, 5)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(v.normalized())
        }
    }
    
    Benchmark("Vector3: normalize vs SIMD3<Float>", configuration: configuration) { benchmark in
        let v = SIMD3<Float>(3, 4, 5)

        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_normalize(v))
        }
    }
    
    Benchmark("Vector3: min", configuration: configuration) { benchmark in
        let v1 = Vector3(1, 2, 3)
        let v2 = Vector3(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector3.min(v1, v2))
        }
    }
    
    Benchmark("Vector3: min vs SIMD3<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD3<Float>(1, 2, 3)
        let v2 = SIMD3<Float>(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(min(v1, v2))
        }
    }
    
    Benchmark("Vector3: max", configuration: configuration) { benchmark in
        let v1 = Vector3(1, 2, 3)
        let v2 = Vector3(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector3.max(v1, v2))
        }
    }
    
    Benchmark("Vector3: max vs SIMD3<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD3<Float>(1, 2, 3)
        let v2 = SIMD3<Float>(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(max(v1, v2))
        }
    }
    
    Benchmark("Vector3: distance", configuration: configuration) { benchmark in
        let v1 = Vector3(1, 2, 3)
        let v2 = Vector3(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector3.distance(v1, v2))
        }
    }
    
    Benchmark("Vector3: distance vs SIMD3<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD3<Float>(1, 2, 3)
        let v2 = SIMD3<Float>(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_distance(v1, v2))
        }
    }
    
    Benchmark("Vector3: sqrDistance", configuration: configuration) { benchmark in
        let v1 = Vector3(1, 2, 3)
        let v2 = Vector3(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(Vector3.sqrDistance(v1, v2))
        }
    }
    
    Benchmark("Vector3: sqrDistance vs SIMD3<Float>", configuration: configuration) { benchmark in
        let v1 = SIMD3<Float>(1, 2, 3)
        let v2 = SIMD3<Float>(4, 5, 6)
        
        for _ in benchmark.scaledIterations {
            Benchmark.blackHole(simd_distance_squared(v1, v2))
        }
    }
}
