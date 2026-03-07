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
    let thresholds: [BenchmarkMetric: BenchmarkThresholds] = [
        .throughput: BenchmarkThresholds(relative: [.p50: -5.0]),
        .mallocCountTotal: BenchmarkThresholds(absolute: [.p50: 0])
    ]
    
    let configuration = Benchmark.Configuration(
        metrics: BenchmarkMetric.default,
        scalingFactor: .mega,
        thresholds: thresholds
    )
    
    registerVector2Benchmarks(configuration: configuration)
    registerVector3Benchmarks(configuration: configuration)
    registerVector4Benchmarks(configuration: configuration)
    registerQuaternionBenchmarks(configuration: configuration)
    registerMatrix4x4Benchmarks(configuration: configuration)
}
