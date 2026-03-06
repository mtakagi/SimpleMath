// The Swift Programming Language
// https://docs.swift.org/swift-book

#if os(macOS) || os(iOS)
import Darwin
#elseif canImport(Glibc)
import Glibc
#elseif canImport(Musl)
import Musl
#elseif os(Windows)
import ucrt
#else
#error("Unknown platform")
#endif

extension Float {
    @usableFromInline static let deg2rad: Float = .pi / 180
    @usableFromInline static let rad2deg: Float = 180 / .pi
    @usableFromInline static let epsilon: Float = 1e-6
}

@frozen
public struct Vector2 : Equatable, Hashable {
    public var simd : SIMD2<Float>
    
    @inlinable
    public init() {
        self.simd = .zero
    }
    
    @inlinable
    public init(_ x : Float, _ y : Float) {
        self.simd = .init(x, y)
    }
    
    @inlinable
    public init(_ v : Float) {
        self.simd = .init(v, v)
    }
    
    @inlinable
    public init(_ simd : SIMD2<Float>) {
        self.simd = simd
    }
}

extension Vector2 : CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable
    public var description: String {
        return "Vector2(\(self.simd.x), \(self.simd.y))"
    }

    @inlinable
    public var debugDescription: String {
        return self.description
    }
}

extension Vector2 {
    @inlinable
    public func sqrMagnitude() -> Float {
        return (self.simd * self.simd).sum()
    }
}

extension Vector2 {
    public static let zero : Vector2 = .init()
    public static let one : Vector2 = .init(1, 1)
    public static let up : Vector2 = .init(0, 1)
    public static let down : Vector2 = .init(0, -1)
    public static let right : Vector2 = .init(1, 0)
    public static let left : Vector2 = .init(-1, 0)
    public static let positiveInfinity : Vector2 = .init(.infinity, .infinity)
    public static let negativeInfinity : Vector2 = .init( -.infinity, -.infinity)
}

extension Vector2 {
    @inlinable
    public static func min(_ lhs: Vector2, _ rhs: Vector2) -> Vector2 {
        return Vector2(Swift.min(lhs.simd.x, rhs.simd.x), Swift.min(lhs.simd.y, rhs.simd.y))
    }
    
    @inlinable
    public static func max(_ lhs: Vector2, _ rhs: Vector2) -> Vector2 {
        return Vector2(Swift.max(lhs.simd.x, rhs.simd.x), Swift.max(lhs.simd.y, rhs.simd.y))
    }
}

@frozen
public struct Vector3 : Equatable, Hashable {
    public var simd: SIMD3<Float>
    
    @inlinable
    public init() {
        self.simd = .zero
    }
    
    @inlinable
    public init(_ x: Float, _ y: Float, _ z: Float) {
        self.simd = .init(x, y, z)
    }
    
    @inlinable
    public init(_ v: Float) {
        self.simd = .init(v, v, v)
    }
    
    @inlinable
    public init (_ v: Vector2, _ z: Float) {
        self.simd = .init(v.simd, z)
    }
    
    @inlinable
    public init(_ simd: SIMD3<Float>) {
        self.simd = simd
    }
}

extension Vector3 : CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable
    public var description: String {
        return "Vector3(\(self.simd.x), \(self.simd.y), \(self.simd.z))"
    }

    @inlinable
    public var debugDescription: String {
        return self.description
    }
}

extension Vector3 {
    @inlinable
    public func magnitude() -> Float {
        return (self.simd * self.simd).sum().squareRoot()
    }
    
    @inlinable
    public func sqrMagnitude() -> Float {
        return (self.simd * self.simd).sum()
    }
    
    @inlinable
    public func normalized() -> Vector3 {
        let len = magnitude()
        
        return len.isZero ? .zero : .init(self.simd / len)
    }
}

extension Vector3 {
    @inlinable
    public var xy : Vector2 {
        return Vector2(self.simd.x, self.simd.y)
    }
}

extension Vector3 {
    public static let zero : Vector3 = .init()
    public static let one : Vector3 = .init(1)
    public static let up : Vector3 = .init(0, 1, 0)
    public static let down : Vector3 = .init(0, -1, 0)
    public static let right : Vector3 = .init(1, 0, 0)
    public static let left : Vector3 = .init(-1, 0, 0)
    public static let forward : Vector3 = .init(0, 0, 1)
    public static let back : Vector3 = .init(0, 0, -1)
    public static let positiveInfinity : Vector3 = .init(.infinity)
    public static let negativeInfinity : Vector3 = .init(-.infinity)
}

extension Vector3 {
    @inlinable
    public static func min(_ lhs: Vector3, _ rhs: Vector3) -> Vector3 {
        return Vector3(Swift.min(lhs.simd.x, rhs.simd.x), Swift.min(lhs.simd.y, rhs.simd.y), Swift.min(lhs.simd.z, rhs.simd.z))
    }
    
    @inlinable
    public static func max(_ lhs: Vector3, _ rhs: Vector3) -> Vector3 {
        return Vector3(Swift.max(lhs.simd.x, rhs.simd.x), Swift.max(lhs.simd.y, rhs.simd.y), Swift.max(lhs.simd.z, rhs.simd.z))
    }
}

extension Vector3 {
    @inlinable
    public static func distance(_ lhs: Vector3, _ rhs: Vector3) -> Float {
        let simd = lhs.simd - rhs.simd
        
        return (simd * simd).sum().squareRoot()
    }
    
    @inlinable
    public static func sqrDistance(_ lhs: Vector3, _ rhs: Vector3) -> Float {
        let simd = lhs.simd - rhs.simd
        
        return (simd * simd).sum()
    }
}

extension Vector3 {
    @inlinable
    public static func dot(_ lhs: Vector3, _ rhs: Vector3) -> Float {
        return (lhs.simd * rhs.simd).sum()
    }
    
    @inlinable
    public static func cross(_ lhs: Vector3, _ rhs: Vector3) -> Vector3 {
        let x = lhs.simd.y * rhs.simd.z - lhs.simd.z * rhs.simd.y
        let y = lhs.simd.z * rhs.simd.x - lhs.simd.x * rhs.simd.z
        let z = lhs.simd.x * rhs.simd.y - lhs.simd.y * rhs.simd.x
        
        return Vector3(x, y, z)
    }
}

@frozen
public struct Vector4 : Equatable, Hashable {
    public var simd : SIMD4<Float>
    
    @inlinable
    public init() {
        self.simd = .zero
    }
    
    @inlinable
    public init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.simd = .init(x, y, z, w)
    }
    
    @inlinable
    public init(_ v: Float) {
        self.simd = .init(v, v, v, v)
    }
    
    @inlinable
    public init (_ v: Vector2, _ z: Float, _ w: Float) {
        self.simd = .init(lowHalf: v.simd, highHalf: SIMD2<Float>(z, w))
    }
    
    @inlinable
    public init (_ v1: Vector2, _ v2: Vector2) {
        self.simd = .init(lowHalf: v1.simd, highHalf: v2.simd)
    }
    
    @inlinable
    public init (_ v: Vector3, _ w: Float) {
        self.simd = .init(v.simd, w)
    }
    
    @inlinable
    public init(_ simd: SIMD4<Float>) {
        self.simd = simd
    }
}

extension Vector4 : CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable
    public var description: String {
        return "Vector4(\(self.simd.x), \(self.simd.y), \(self.simd.z), \(self.simd.w))"
    }

    @inlinable
    public var debugDescription: String {
        return self.description
    }
}

extension Vector4 {
    @inlinable
    public func magnitude() -> Float {
        return (self.simd * self.simd).sum().squareRoot()
    }
    
    @inlinable
    public func sqrMagnitude() -> Float {
        return (self.simd * self.simd).sum()
    }
    
    @inlinable
    public func normalized() -> Vector4 {
        let len = magnitude()
        
        return len.isZero ? .init(0) : .init(self.simd / len)
    }
}

extension Vector4 {
    @inlinable
    public static func min(_ lhs: Vector4, _ rhs: Vector4) -> Vector4 {
        return Vector4(Swift.min(lhs.simd.x, rhs.simd.x), Swift.min(lhs.simd.y, rhs.simd.y), Swift.min(lhs.simd.z, rhs.simd.z), Swift.min(lhs.simd.w, rhs.simd.w))
    }
    
    @inlinable
    public static func max(_ lhs: Vector4, _ rhs: Vector4) -> Vector4 {
        return Vector4(Swift.max(lhs.simd.x, rhs.simd.x), Swift.max(lhs.simd.y, rhs.simd.y), Swift.max(lhs.simd.z, rhs.simd.z), Swift.max(lhs.simd.w, rhs.simd.w))
    }
}

@frozen
public struct Quaternion : Equatable, Hashable {
    public var simd : SIMD4<Float>
    
    @inlinable
    public init() {
        self.simd = .zero
    }
    
    @inlinable
    public init(x: Float, y: Float, z: Float, w: Float) {
        self.simd = .init(x, y, z, w)
    }
    
    @inlinable
    public init(_ v: Float) {
        self.simd = .init(v, v, v, v)
    }
        
    @inlinable
    public init(_ simd: SIMD4<Float>) {
        self.simd = simd
    }
    
    @inlinable
    public init(_ v: Vector4) {
        self.simd = v.simd
    }
}

extension Quaternion : CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable
    public var description: String {
        return "Quaternion(\(self.simd.x), \(self.simd.y), \(self.simd.z), \(self.simd.w))"
    }

    @inlinable
    public var debugDescription: String {
        return self.description
    }
}

extension Quaternion {
    @inlinable
    public func magnitude() -> Float {
        return (self.simd * self.simd).sum().squareRoot()
    }
    
    @inlinable
    public func sqrMagnitude() -> Float {
        return (self.simd * self.simd).sum()
    }
    
    @inlinable
    public func normalized() -> Quaternion {
        let len = magnitude()
        
        return len.isZero ? .init(0) : .init(self.simd / len)
    }
}

extension Quaternion {
    @inlinable
    public func inverse() -> Quaternion {
        let lenSq = sqrMagnitude()
        
        return lenSq < .epsilon ? .identity : .init(self.conjugate().simd / lenSq)
    }
    
    @inlinable
    public func conjugate() -> Quaternion {
        return .init(x: -self.simd.x, y: -self.simd.y, z: -self.simd.z, w: self.simd.w)
    }
    
//    @inlinable
//    public func act(_ v: Vector3) -> Vector3 {
//        let qv = Vector3(simd.x, simd.y, simd.z)
//        let uv = Vector3.cross(qv, v)
//        let uuv = Vector3.cross(qv, uv)
//        let result = v.simd + ((uv.simd * simd.w) + uuv.simd) * 2.0
//        
//        return Vector3(result)
//    }
    
    @inlinable
    public func act(_ v: Vector3) -> Vector3 {
        let q = self.normalized().conjugate()
        let a = Quaternion(x: v.simd.x, y: v.simd.y, z: v.simd.z, w: 0)
        let result = q * a * self
        
        return Vector3(result.simd.x, result.simd.y, result.simd.z)
    }
}

extension Quaternion {
    @inlinable
    public var vector4 : Vector4 {
        return Vector4(self.simd)
    }
}

extension Quaternion {
    public static let identity: Quaternion = .init(x: 0, y: 0, z: 0, w: 1)
}

extension Quaternion {
    @inlinable
    public static func angleAxis(degree: Float, _ axis: Vector3) -> Quaternion {
        let n = axis.normalized()
        let radian = .deg2rad * degree
        let halfRadian = radian * 0.5
        let s = sinf(halfRadian)
        let c = cosf(halfRadian)
        let v = n.simd * s
        
        return .init(x: v.x, y: v.y, z: v.z, w: c)
    }
    
    @inlinable
    public static func euler(pitchDegree: Float, yawDegree: Float, rollDegree: Float) -> Quaternion {
//        let hx = pitchDegree * (.pi / 180) * 0.5
//        let hy = yawDegree   * (.pi / 180) * 0.5
//        let hz = rollDegree  * (.pi / 180) * 0.5
//
//        let sx = sin(hx), cx = cos(hx)
//        let sy = sin(hy), cy = cos(hy)
//        let sz = sin(hz), cz = cos(hz)
//
//        return Quaternion(
//            x: cz * sx * cy - sz * cx * sy,
//            y: cz * cx * sy + sz * sx * cy,
//            z: sz * cx * cy + cz * sx * sy,
//            w: cz * cx * cy - sz * sx * sy
//        )
        let qz = angleAxis(degree: rollDegree, .init(0, 0, 1))
        let qx = angleAxis(degree: pitchDegree, .init(1, 0, 0))
        let qy = angleAxis(degree: yawDegree, .init(0, 1, 0))
        
        return (qz * qx) * qy
    }
    
    @inlinable
    public static func fromToRotation(fromDir: Vector3, toDir: Vector3) -> Quaternion {
        let f = fromDir.normalized()
        let t = toDir.normalized()
        let dot = Vector3.dot(f, t)

        if dot >= 1.0 - .epsilon {
            return .identity
        } else if dot <= -1.0 + .epsilon {
            var axis = Vector3.cross(f, .right)
            
            if axis.sqrMagnitude() < .epsilon {
                axis = Vector3.cross(f, .up)
            }
            
            return Quaternion.angleAxis(degree: 180, axis)
        } else {
            let c = Vector3.cross(f, t)
            let s = ((1.0 + dot) * 2.0).squareRoot()
            let inverseS = 1.0 / s
            let v = c.simd * inverseS
                
            return Quaternion(x: v.x, y: v.y, z: v.z, w: s * 0.5)
        }
    }
    
    @inlinable
    public static func lookRotation(_ forward: Vector3, _ up: Vector3) -> Quaternion {
        let q1 = Quaternion.fromToRotation(fromDir: .forward, toDir: forward)
        let c = Vector3.cross(forward, up.normalized())
        
        if c.sqrMagnitude() < .epsilon {
            return q1
        }
        
        let currentUp = q1.act(Vector3.up)
        let q2 = Quaternion.fromToRotation(fromDir: currentUp, toDir: up)
        
        return q2 * q1
    }
}

extension Quaternion {
    @inlinable
    public static func * (_ lhs: Quaternion, _ rhs: Quaternion) -> Quaternion {
        let l = lhs.simd
        let r = rhs.simd
        
        let x = l.w * r.x + l.x * r.w + l.y * r.z - l.z * r.y
        let y = l.w * r.y - l.x * r.z + l.y * r.w + l.z * r.x
        let z = l.w * r.z + l.x * r.y - l.y * r.x + l.z * r.w
        let w = l.w * r.w - l.x * r.x - l.y * r.y - l.z * r.z
        
        return .init(x: x, y: y, z: z, w: w)
    }
    
    @inlinable
    public static func * (_ lhs: Quaternion, _ rhs: Vector3) -> Vector3 {
        return lhs.act(rhs)
    }
}

@frozen
public struct Matrix4x4 : Equatable, Hashable {
    public var c0 : SIMD4<Float>
    public var c1 : SIMD4<Float>
    public var c2 : SIMD4<Float>
    public var c3 : SIMD4<Float>
    
    @inlinable
    public init() {
        self.c0 = .init(0, 0, 0, 0)
        self.c1 = .init(0, 0, 0, 0)
        self.c2 = .init(0, 0, 0, 0)
        self.c3 = .init(0, 0, 0, 0)
    }
    
    @inlinable
    public init(_ m00 : Float, _ m01 : Float, _ m02 : Float, _ m03 : Float,
                _ m10 : Float, _ m11 : Float, _ m12 : Float, _ m13 : Float,
                _ m20 : Float, _ m21 : Float, _ m22 : Float, _ m23 : Float,
                _ m30 : Float, _ m31 : Float, _ m32 : Float, _ m33 : Float
    ) {
        self.c0 = .init(m00, m10, m20, m30)
        self.c1 = .init(m01, m11, m21, m31)
        self.c2 = .init(m02, m12, m22, m32)
        self.c3 = .init(m03, m13, m23, m33)
    }
    
    @inlinable
    public init(_ c0: SIMD4<Float>, _ c1: SIMD4<Float>, _ c2: SIMD4<Float>, _ c3: SIMD4<Float>) {
        self.c0 = c0
        self.c1 = c1
        self.c2 = c2
        self.c3 = c3
    }
}

extension Matrix4x4 : CustomStringConvertible, CustomDebugStringConvertible {
    @inlinable
    public var description: String {
        return "Matrix4x4(\(c0)\n\(c1)\n\(c2)\n\(c3))"
    }
    
    @inlinable
    public var debugDescription: String {
        return description
    }
}

// TODO: remove simd library dependency
#if canImport(simd)
import simd

extension Matrix4x4 {
    @inlinable
    public func inverse() -> Matrix4x4 {
        let m = simd_float4x4(self.c0, self.c1, self.c2, self.c3)
        let inverse = simd_inverse(m)
        
        return Matrix4x4(inverse.columns.0, inverse.columns.1, inverse.columns.2, inverse.columns.3)
    }
    
    @inlinable
    public func determinant() -> Float {
        let m = simd_float4x4(self.c0, self.c1, self.c2, self.c3)
        
        return simd_determinant(m)
    }
}
#endif

extension Matrix4x4 {
    @inlinable
    public func translation() -> Vector3 {
        return Vector3(self.c3.x, self.c3.y, self.c3.z)
    }
}

extension Matrix4x4 {
    @inlinable
    public func multiplyPoint(_ p: Vector3) -> Vector3 {
        let r = c0 * p.simd.x + c1 * p.simd.y + c2 * p.simd.z + c3
        let simd = SIMD3<Float>(r.x, r.y, r.z) / r.w
        
        return Vector3(simd)
    }
    
    @inlinable
    public func multiplyVector(_ v: Vector3) -> Vector3 {
        let r = c0 * v.simd.x + c1 * v.simd.y + c2 * v.simd.z
        
        return Vector3(r.x, r.y, r.z)
    }
}

extension Matrix4x4 {
    public static let identity: Matrix4x4 = .init(
        .init(1, 0, 0, 0),
        .init(0, 1, 0, 0),
        .init(0, 0, 1, 0),
        .init(0, 0, 0, 1)
    )
}

extension Matrix4x4 {
    @inlinable
    public static func scale(_ v : Vector3) -> Matrix4x4 {
        return .init(v.simd.x, 0, 0, 0,
                     0, v.simd.y, 0, 0,
                     0, 0, v.simd.z, 0,
                     0, 0, 0, 1)
    }
    
    @inlinable
    public static func translate(_ v : Vector3) -> Matrix4x4 {
        return .init(1, 0, 0, v.simd.x,
                     0, 1, 0, v.simd.y,
                     0, 0, 1, v.simd.z,
                     0, 0, 0, 1)
    }
    
    @inlinable
    public static func rotate(_ q: Quaternion) -> Matrix4x4 {
        let x = q.simd.x
        let y = q.simd.y
        let z = q.simd.z
        let w = q.simd.w

        let xx = x * x
        let yy = y * y
        let zz = z * z
        let xy = x * y
        let xz = x * z
        let yz = y * z
        let wx = w * x
        let wy = w * y
        let wz = w * z

        return .init(1 - 2 * (yy + zz), 2 * (xy + wz), 2 * (xz - wy), 0,
                     2 * (xy - wz), 1 - 2 * (xx + zz), 2 * (yz + wx), 0,
                     2 * (xz + wy), 2 * (yz - wx), 1 - 2 * (xx + yy), 0,
                     0, 0, 0, 1)
    }
}

extension Matrix4x4 {
    @inlinable
    static func * (lhs: Matrix4x4, rhs: SIMD4<Float>) -> SIMD4<Float> {
        return lhs.c0 * rhs.x + lhs.c1 * rhs.y + lhs.c2 * rhs.z + lhs.c3 * rhs.w
    }
    
    @inlinable
    public static func * (_ lhs: Matrix4x4, _ rhs: Matrix4x4) -> Matrix4x4 {
//        let m00 = lhs.c0.x * rhs.c0.x + lhs.c1.x * rhs.c0.y + lhs.c2.x * rhs.c0.z + lhs.c3.x * rhs.c0.w
//        let m01 = lhs.c0.x * rhs.c1.x + lhs.c1.x * rhs.c1.y + lhs.c2.x * rhs.c1.z + lhs.c3.x * rhs.c1.w
//        let m02 = lhs.c0.x * rhs.c2.x + lhs.c1.x * rhs.c2.y + lhs.c2.x * rhs.c2.z + lhs.c3.x * rhs.c2.w
//        let m03 = lhs.c0.x * rhs.c3.x + lhs.c1.x * rhs.c3.y + lhs.c2.x * rhs.c3.z + lhs.c3.x * rhs.c3.w
//
//        let m10 = lhs.c0.y * rhs.c0.x + lhs.c1.y * rhs.c0.y + lhs.c2.y * rhs.c0.z + lhs.c3.y * rhs.c0.w
//        let m11 = lhs.c0.y * rhs.c1.x + lhs.c1.y * rhs.c1.y + lhs.c2.y * rhs.c1.z + lhs.c3.y * rhs.c1.w
//        let m12 = lhs.c0.y * rhs.c2.x + lhs.c1.y * rhs.c2.y + lhs.c2.y * rhs.c2.z + lhs.c3.y * rhs.c2.w
//        let m13 = lhs.c0.y * rhs.c3.x + lhs.c1.y * rhs.c3.y + lhs.c2.y * rhs.c3.z + lhs.c3.y * rhs.c3.w
//
//        let m20 = lhs.c0.z * rhs.c0.x + lhs.c1.z * rhs.c0.y + lhs.c2.z * rhs.c0.z + lhs.c3.z * rhs.c0.w
//        let m21 = lhs.c0.z * rhs.c1.x + lhs.c1.z * rhs.c1.y + lhs.c2.z * rhs.c1.z + lhs.c3.z * rhs.c1.w
//        let m22 = lhs.c0.z * rhs.c2.x + lhs.c1.z * rhs.c2.y + lhs.c2.z * rhs.c2.z + lhs.c3.z * rhs.c2.w
//        let m23 = lhs.c0.z * rhs.c3.x + lhs.c1.z * rhs.c3.y + lhs.c2.z * rhs.c3.z + lhs.c3.z * rhs.c3.w
//
//        let m30 = lhs.c0.w * rhs.c0.x + lhs.c1.w * rhs.c0.y + lhs.c2.w * rhs.c0.z + lhs.c3.w * rhs.c0.w
//        let m31 = lhs.c0.w * rhs.c1.x + lhs.c1.w * rhs.c1.y + lhs.c2.w * rhs.c1.z + lhs.c3.w * rhs.c1.w
//        let m32 = lhs.c0.w * rhs.c2.x + lhs.c1.w * rhs.c2.y + lhs.c2.w * rhs.c2.z + lhs.c3.w * rhs.c2.w
//        let m33 = lhs.c0.w * rhs.c3.x + lhs.c1.w * rhs.c3.y + lhs.c2.w * rhs.c3.z + lhs.c3.w * rhs.c3.w
//
//        return .init(
//            m00, m01, m02, m03,
//            m10, m11, m12, m13,
//            m20, m21, m22, m23,
//            m30, m31, m32, m33
//        )
        let r0 = lhs * rhs.c0
        let r1 = lhs * rhs.c1
        let r2 = lhs * rhs.c2
        let r3 = lhs * rhs.c3

        return Matrix4x4(r0, r1, r2, r3)
    }
}
