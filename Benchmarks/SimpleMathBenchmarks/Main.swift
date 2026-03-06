//
//  Main.swift
//  SimpleMath
//
//  Created by mtakagi on 2026/03/01.
//

import Benchmark
import SimpleMath
import simd

let benchmarks : @Sendable () -> Void = {
    let configuration = Benchmark.Configuration(
        metrics: BenchmarkMetric.default,
        scalingFactor: .mega
    )
    
    registerVector2Benchmarks(configuration: configuration)
    registerVector3Benchmarks(configuration: configuration)
    registerVector4Benchmarks(configuration: configuration)
    registerQuaternionBenchmarks(configuration: configuration)
}
