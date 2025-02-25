import Foundation
import simd

struct CubeGeometry {
  static let faceWinding: [UInt32] = [0, 1, 2, 2, 3, 0]

  static let cubeVertices: [SIMD3<Float>] = [
    SIMD3<Float>([0, 1, 0]),
    SIMD3<Float>([0, 0, 0]),
    SIMD3<Float>([1, 0, 0]),
    SIMD3<Float>([1, 1, 0]),
    SIMD3<Float>([0, 1, 1]),
    SIMD3<Float>([0, 0, 1]),
    SIMD3<Float>([1, 0, 1]),
    SIMD3<Float>([1, 1, 1])
  ]

  /// Indexed by ``Direction/rawValue``.
  static let faceVertices: [[SIMD3<Float>]] = [
    CubeGeometry.generateFaceVertices(facing: .down),
    CubeGeometry.generateFaceVertices(facing: .up),
    CubeGeometry.generateFaceVertices(facing: .north),
    CubeGeometry.generateFaceVertices(facing: .south),
    CubeGeometry.generateFaceVertices(facing: .west),
    CubeGeometry.generateFaceVertices(facing: .east)
  ]

  /// Indexed by ``Direction/rawValue`` and used to generate ``faceVertices``.
  static let faceVertexIndices: [[Int]] = [
    [6, 2, 1, 5],
    [3, 7, 4, 0],
    [0, 1, 2, 3],
    [7, 6, 5, 4],
    [4, 5, 1, 0],
    [3, 2, 6, 7]
  ]

  public static let shades: [Float] = [
    0.6, // down
    1.0, // up
    0.9, 0.9, // north, south
    0.7, 0.7  // east, west
  ]

  static func generateFaceVertices(facing face: Direction) -> [SIMD3<Float>] {
    let vertexIndices = faceVertexIndices[face.rawValue]

    let vertices = vertexIndices.map { index in
      return cubeVertices[index]
    }

    return vertices
  }
}
