import Testing
@testable import SimpleMath
import simd

@Test func vector_identity() {
    let v = Vector3(1, 2, 3)
    
    #expect(Vector3.dot(v, .zero) == 0)
    #expect(Vector3.cross(v, .zero) == .zero)
    #expect((v.normalized().magnitude() - 1) < 1e-6)
}

@Test func dot_known_values() {
    let a = Vector3(1, 2, 3)
    let b = Vector3(4, 5, 6)
    
    #expect(Vector3.dot(a, b) == 32)
}

@Test func cross_known_values() {
    let a = Vector3(1, 0, 0)
    let b = Vector3(0, 1, 0)
    
    #expect(Vector3.cross(a, b) == Vector3(0, 0, 1))
}

@Test func zero_vector_normalize() {
    let v = Vector3.zero
    
    #expect(v.normalized() == .zero)
}

@Test func extreme_values() {
    let v = Vector3(Float.greatestFiniteMagnitude, 1, 1)
    let len = v.magnitude()
    
    #expect(len.isFinite)
}

@Test func cross_orthogonality() {
    let a = Vector3(1, 2, 3)
    let b = Vector3(4, 5, 6)
    let c = Vector3.cross(a, b)

    #expect(Vector3.dot(a, c) == 0)
    #expect(Vector3.dot(b, c) == 0)
}

@Test func dot_matches_simd() {
    for _ in 0..<10_000 {
        let a = Vector3(Float.random(in: -10...10))
        let b = Vector3(Float.random(in: -10...10))
        
        #expect(Vector3.dot(a, b) == simd_dot(a.simd, b.simd))
    }
}

@Test func normalize_property() {
    for _ in 0..<10000 {
        let v = Vector3(Float.random(in: -100...100),
                        Float.random(in: -100...100),
                        Float.random(in: -100...100))
        let n = v.normalized()
        if v.sqrMagnitude() > 1e-6 {
            #expect(abs(n.magnitude() - 1) < 1e-4)
        }
    }
}

@Test func cross_orthogonal_property() {
    let a = Vector3(1, 2, 3)
    let b = Vector3(4, 5, 6)
    let c = Vector3.cross(a, b)

    #expect(abs(Vector3.dot(a, c)) < 1e-5)
    #expect(abs(Vector3.dot(b, c)) < 1e-5)
}

@Test func normalize_magnitude_is_one() {
    let v = Vector3(3, 4, 5).normalized()
    
    #expect(abs(v.magnitude() - 1) < 1e-6)
}

@Test func quaternion_angle_axis_match() {
    func angleAxis(degree : Float, _ axis : simd_float3) -> Quaternion {
        let q = simd_quatf(angle: degree * (.pi / 180), axis: simd_normalize(axis))
        
        return Quaternion(q.vector)
    }
    
    let q1 = angleAxis(degree: 60, .init(1, 0, 0))
    let q2 = Quaternion.angleAxis(degree: 60, .init(1, 0, 0))
    
    #expect(q1 == q2)
}

@Test func quaternion_identity() {
    let q = Quaternion.identity
    
    #expect(q * q == q)
}

@Test func quaternion_euler_match() {
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
    
    let pitch = Float.random(in: 0..<360)
    let yaw = Float.random(in: 0..<360)
    let roll = Float.random(in: 0..<360)
    
    let q1 = Quaternion.euler(pitchDegree: pitch, yawDegree: yaw, rollDegree: roll)
    let q2 = euler(pitchDegree: pitch, yawDegree: yaw, rollDegree: roll)
    
    let dot = simd_dot(q1.simd, q2.simd)
    
    #expect(abs(dot) > 0.99999)
//    #expect(q1 == q2)
}

@Test func from_to_rotation_normal_case() {
    let from = Vector3(1, 0, 0)
    let to = Vector3(0, 1, 0)
        
    let q = Quaternion.fromToRotation(fromDir: from, toDir: to)
    let rotated = q.act(from)
        
    #expect(abs(rotated.simd.x - 0.0) < 1e-5)
    #expect(abs(rotated.simd.y - 1.0) < 1e-5)
    #expect(abs(rotated.simd.z - 0.0) < 1e-5)
}

@Test func from_to_rotation_parallel() {
    let dir = Vector3(1, 2, 3)
    let q = Quaternion.fromToRotation(fromDir: dir, toDir: dir)
        
    #expect(q.simd.w == 1.0)
    #expect(q.simd.x == 0.0)
    #expect(q.simd.y == 0.0)
    #expect(q.simd.z == 0.0)
}

@Test func from_to_rotation_anti_parallel() {
    let from = Vector3(1, 0, 0)
    let to = Vector3(-1, 0, 0)
        
    let q = Quaternion.fromToRotation(fromDir: from, toDir: to)
    let rotated = q.act(from)
        
    #expect(abs(rotated.simd.x - (-1.0)) < 1e-5)
    #expect(abs(rotated.simd.y) < 1e-5)
    #expect(abs(rotated.simd.z) < 1e-5)
}

// MARK: - QuaternionLookRotationTests
@Suite struct QuaternionLookRotationTests {

    @Test func lookRotation_Basic() {
        // X軸方向(1, 0, 0)を向き、上をY軸(0, 1, 0)とする
        let forward = Vector3(1, 0, 0)
        let up = Vector3(0, 1, 0)
        
        let q = Quaternion.lookRotation(forward, up)
        
        // 期待値: 元のZ軸(0, 0, 1)が、forward(1, 0, 0)に向く
        // 元のY軸(0, 1, 0)は、up(0, 1, 0)のまま
        let rotatedForward = simd_act(simd_quatf(vector: q.simd), SIMD3<Float>(0, 0, 1))
        let rotatedUp = simd_act(simd_quatf(vector: q.simd), SIMD3<Float>(0, 1, 0))
        
        #expect(abs(rotatedForward.x - 1.0) <= 1e-5)
        #expect(abs(rotatedForward.y - 0.0) <= 1e-5)
        #expect(abs(rotatedForward.z - 0.0) <= 1e-5)
        
        #expect(abs(rotatedUp.x - 0.0) <= 1e-5)
        #expect(abs(rotatedUp.y - 1.0) <= 1e-5)
        #expect(abs(rotatedUp.z - 0.0) <= 1e-5)
    }

    @Test func lookRotation_NonOrthogonal() {
        // forwardとupが完全に直交していない場合（よくある入力）
        let forward = Vector3(1, 0, 1) // 斜め前
        let up = Vector3(0, 1, 1)      // 斜め上
        
        let q = Quaternion.lookRotation(forward, up)
        
        let rotatedForward = simd_act(simd_quatf(vector: q.simd), SIMD3<Float>(0, 0, 1))
        let rotatedUp = simd_act(simd_quatf(vector: q.simd), SIMD3<Float>(0, 1, 0))
        
        // 1. forwardは、入力されたforward方向と「完全に」一致しなければならない
        let expectedForward = simd_normalize(forward.simd)
        #expect(abs(rotatedForward.x - expectedForward.x) <= 1e-5)
        #expect(abs(rotatedForward.y - expectedForward.y) <= 1e-5)
        #expect(abs(rotatedForward.z - expectedForward.z) <= 1e-5)
        
        // 2. 最終的なUpは、入力forwardに直交しつつ、入力upに「最も近い」向きになる
        // （内積が正になるはず）
        let dotWithInputUp = simd_dot(rotatedUp, simd_normalize(up.simd))
        #expect(dotWithInputUp > 0.0, "Result up should roughly point towards input up")
        
        // 3. 結果の軸同士は完全に直交している(内積0)はず
        let dotOrthogonal = simd_dot(rotatedForward, rotatedUp)
        #expect(abs(dotOrthogonal - 0.0) <= 1e-5)
    }

    @Test func lookRotation_CollinearFallback() {
        // 真上を向く場合 (forwardとupが平行)。C++コードの early-exit (g_XMEpsilon) のテスト
        let forward = Vector3(0, 1, 0)
        let up = Vector3(0, 1, 0)
        
        let q = Quaternion.lookRotation(forward, up)
        let rotatedForward = simd_act(simd_quatf(vector: q.simd), SIMD3<Float>(0, 0, 1))
        
        // エラーにならず、少なくともforwardが真上を向いていること
        #expect(abs(rotatedForward.x - 0.0) <= 1e-5)
        #expect(abs(rotatedForward.y - 1.0) <= 1e-5)
        #expect(abs(rotatedForward.z - 0.0) <= 1e-5)
    }
}

// MARK: - QuaternionInverseTests
@Suite struct QuaternionInverseTests {

    @Test func inverse_MultiplyToIdentity() {
        // 任意の回転 (例: (1,1,1)軸回りに60度回転)
        let axis = simd_normalize(SIMD3<Float>(1, 1, 1))
        let q = Quaternion(simd_quatf(angle: 60 * .pi / 180, axis: axis).vector)
        
        let invQ = q.inverse() // または Quaternion.inverse(q)
        
        // q * invQ = Identity になるはず
        let result1 = q * invQ
        let result2 = invQ * q
        
        // Identity (r: 1.0, ix: 0, iy: 0, iz: 0) に戻るか確認
        #expect(abs(result1.simd.w - 1.0) <= 1e-5)
        #expect(abs(result1.simd.x - 0.0) <= 1e-5)
        #expect(abs(result1.simd.y - 0.0) <= 1e-5)
        #expect(abs(result1.simd.z - 0.0) <= 1e-5)
        
        #expect(abs(result2.simd.w - 1.0) <= 1e-5)
    }

    @Test func inverse_RevertVectorRotation() {
        // ベクトルを回転させて、逆クォータニオンでもとに戻るか確認
        let originalVector = SIMD3<Float>(10, 20, 30)
        
        // Y軸に90度回転
        let q = Quaternion(simd_quatf(angle: 90 * .pi / 180, axis: SIMD3<Float>(0, 1, 0)).vector)
        
        // ベクトルを回転
        let rotatedVector = simd_act(simd_quatf(vector: q.simd), originalVector)
        
        // 逆クォータニオンで再度回転（もとに戻す）
        let revertedVector = simd_act(simd_quatf(vector: q.inverse().simd), rotatedVector)
        
        #expect(abs(revertedVector.x - originalVector.x) <= 1e-4)
        #expect(abs(revertedVector.y - originalVector.y) <= 1e-4)
        #expect(abs(revertedVector.z - originalVector.z) <= 1e-4)
    }
}

// MARK: - QuaternionInversePerformanceTests
@Suite struct QuaternionInversePerformanceTests {

    @Test func inversePerformance() {
        let axis = simd_normalize(SIMD3<Float>(1, 2, 3))
        let q = Quaternion(simd_quatf(angle: 1.5, axis: axis).vector)
        
        var result = Quaternion.identity
        
        // 100万回の Inverse 実行 (Swift Testingにはmeasureが無いため純粋なループとして実行)
        for _ in 0..<1_000_000 {
            // 内部状態に依存させないため、結果を上書きし続ける
            result = q.inverse()
        }
        
        // 最適化でループが消し飛ばされないように、結果を評価しておく
        #expect(result.simd.w != 0.0)
    }
}

// MARK: - Matrix4x4InverseTests
@Suite struct Matrix4x4InverseTests {
    
    @Test func inverse_MultiplyToIdentity() {
        // テスト用の適当な変換行列を作成 (平行移動 + スケール + 回転)
        // ※それぞれのメソッドは実装されている前提
        let translation = Matrix4x4.translate(Vector3(10, -5, 2))
        let scale = Matrix4x4.scale(Vector3(2, 2, 2))
        let rotation = Matrix4x4.rotate(Quaternion.angleAxis(degree: 45, Vector3.up))
        
        let m = translation * rotation * scale
        let invM = m.inverse()
        
        // M * M^-1 = Identity になるはず
        let result = m * invM
        
        // 浮動小数点の計算誤差を許容して単位行列かチェック
        #expect(abs(result.c0.x - 1.0) <= 1e-5)
        #expect(abs(result.c1.y - 1.0) <= 1e-5)
        #expect(abs(result.c2.z - 1.0) <= 1e-5)
        #expect(abs(result.c3.w - 1.0) <= 1e-5)
        
        // 他の非対角成分が0であることもチェック
        #expect(abs(result.c3.x - 0.0) <= 1e-5) // translation成分が消えているか
    }
    
    @Test func inverse_RevertPointTransformation() {
        let m = Matrix4x4.translate(Vector3(100, 200, 300))
        let invM = m.inverse()
        
        let originalPoint = Vector3(1, 2, 3)
        
        // 1. まず元の行列で変換
        let transformedPoint = m.multiplyPoint(originalPoint)
        #expect(abs(transformedPoint.simd.x - 101.0) <= 1e-5)
        
        // 2. 逆行列で再度変換（元に戻るはず）
        let revertedPoint = invM.multiplyPoint(transformedPoint)
        
        #expect(abs(revertedPoint.simd.x - originalPoint.simd.x) <= 1e-4)
        #expect(abs(revertedPoint.simd.y - originalPoint.simd.y) <= 1e-4)
        #expect(abs(revertedPoint.simd.z - originalPoint.simd.z) <= 1e-4)
    }
}

// MARK: - Matrix4x4InversePerformanceTests
@Suite struct Matrix4x4InversePerformanceTests {
    
    @Test func inversePerformance() {
        // 複雑な行列を1つ用意
        let m = Matrix4x4(
            1, 2, 3, 4,
            2, 3, 4, 1,
            3, 4, 1, 2,
            4, 1, 2, 3
        )
        
        var result = Matrix4x4()
        
        // 10万回の逆行列計算
        for _ in 0..<100_000 {
            result = m.inverse()
        }
        
        // ループ最適化によるコードの消滅（Dead Code Elimination）を防ぐためのダミー評価
        #expect(result.c0.x != 0.0)
    }
}

// MARK: - Matrix4x4MultiplyTests
@Suite struct Matrix4x4MultiplyTests {

    @Test func multiplyPoint() {
        // 移動 (X:+10, Y:+20, Z:+30), スケール (2倍) の行列
        // ※各種create系関数が実装されている前提
        let translation = Matrix4x4.translate(Vector3(10, 20, 30))
        let scale = Matrix4x4.scale(Vector3(2, 2, 2))
        let m = translation * scale
        
        let p = Vector3(1, 2, 3)
        let result = m.multiplyPoint(p)
        
        // 期待値:
        // 1. スケール適用 -> (2, 4, 6)
        // 2. 移動適用 -> (12, 24, 36)
        #expect(abs(result.simd.x - 12.0) <= 1e-5)
        #expect(abs(result.simd.y - 24.0) <= 1e-5)
        #expect(abs(result.simd.z - 36.0) <= 1e-5)
    }

    @Test func multiplyVector() {
        // 移動 (X:+10, Y:+20, Z:+30), 回転 (Y軸90度) の行列
        let translation = Matrix4x4.translate(Vector3(10, 20, 30))
        let rotation = Matrix4x4.rotate(Quaternion.angleAxis(degree: 90, Vector3.up))
        let m = translation * rotation
        
        let v = Vector3(1, 0, 0)
        let result = m.multiplyVector(v)
        
        // 期待値:
        // 1. 回転適用 -> (0, 0, -1) または (0, 0, 1) ※右手/左手系による
        // 2. 移動は *無視される* ため、値が +10,+20,+30 されないこと
        #expect(abs(result.simd.x - 0.0) <= 1e-5)
        #expect(abs(result.simd.y - 0.0) <= 1e-5)
        
        // 左手系を想定して -1.0 をチェック (Z奥が正なら +1.0)
        // 回転が反映され、移動の (10, 20, 30) が足されていないことが最重要
        #expect(result.simd.x != 10.0)
        #expect(abs(abs(result.simd.z) - 1.0) <= 1e-5)
    }
}

// MARK: - Matrix4x4CreationTests
@Suite struct Matrix4x4CreationTests {

    @Test func scaleMatrix() {
        let m = Matrix4x4.scale(Vector3(2.0, 3.0, 4.0))
        let p = Vector3(10.0, 10.0, 10.0)
        
        let result = m.multiplyPoint(p)
        
        // 期待値: X成分が2倍, Y成分が3倍, Z成分が4倍
        #expect(abs(result.simd.x - 20.0) <= 1e-5)
        #expect(abs(result.simd.y - 30.0) <= 1e-5)
        #expect(abs(result.simd.z - 40.0) <= 1e-5)
    }

    @Test func translateMatrix() {
        let m = Matrix4x4.translate(Vector3(5.0, -2.0, 3.0))
        let p = Vector3(10.0, 10.0, 10.0)
        
        let result = m.multiplyPoint(p)
        
        // 期待値: 足し算になっていること
        // ※もし Translate の成分を間違えて「行」に入れていた場合、ここでおかしくなります
        #expect(abs(result.simd.x - 15.0) <= 1e-5)
        #expect(abs(result.simd.y - 8.0) <= 1e-5)
        #expect(abs(result.simd.z - 13.0) <= 1e-5)
    }

    @Test func rotateMatrix() {
        // Y軸周りに90度回転するクォータニオン
        let q = Quaternion(simd_quatf(angle: 90 * .pi / 180, axis: SIMD3<Float>(0, 1, 0)).vector)
        let m = Matrix4x4.rotate(q)
        
        let p = Vector3(1.0, 0.0, 0.0)
        
        // 行列による回転
        let resultFromMatrix = m.multiplyPoint(p)
        
        // クォータニオンによる直接回転 (正解データ)
        let resultFromQuat = q.act(p)
        
        // 行列変換とクォータニオン変換の結果が完全に一致するか
        #expect(abs(resultFromMatrix.simd.x - resultFromQuat.simd.x) <= 1e-5)
        #expect(abs(resultFromMatrix.simd.y - resultFromQuat.simd.y) <= 1e-5)
        #expect(abs(resultFromMatrix.simd.z - resultFromQuat.simd.z) <= 1e-5)
    }
}

// MARK: - Matrix4x4CreationPerformanceTests
@Suite struct Matrix4x4CreationPerformanceTests {

    @Test func trsMatrixGenerationPerformance() {
        let pos = Vector3(10, 20, 30)
        let rot = Quaternion(simd_quatf(angle: 1.0, axis: SIMD3<Float>(0, 1, 0)).vector)
        let scl = Vector3(2, 2, 2)
        
        var result = Matrix4x4()
        
        // 10万個のオブジェクトのワールド行列（T * R * S）を計算する想定
        for _ in 0..<100_000 {
            let t = Matrix4x4.translate(pos)
            let r = Matrix4x4.rotate(rot)
            let s = Matrix4x4.scale(scl)
            
            // M = T * R * S (乗算順序は Column-Major を想定)
            result = t * r * s
        }
        
        // 最適化によるループ削除防止
        #expect(result.c3.x != 0.0)
    }
}
