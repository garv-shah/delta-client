import simd

/// A sequence of voxels along a ray.
///
/// Algorithm explanation: https://github.com/sketchpunk/FunWithWebGL2/blob/master/lesson_074_voxel_ray_intersection/test.html
public struct VoxelRay: Sequence, IteratorProtocol {
  public var count: Int

  private let step: SIMD3<Int>
  private let initialVoxel: SIMD3<Int>
  private let boundaryDistanceStep: SIMD3<Float>

  private var isFirst = true
  private var nextBoundaryDistance: SIMD3<Float>
  private var previousVoxel: SIMD3<Int>

  public init(along ray: Ray, count: Int? = nil) {
    self.init(from: ray.origin, direction: ray.direction, count: count)
  }

  public init(from position: SIMD3<Float>, direction: SIMD3<Float>, count: Int? = nil) {
    step = SIMD3<Int>(simd_sign(direction))

    initialVoxel = SIMD3<Int>([
      position.x.rounded(.down),
      position.y.rounded(.down),
      position.z.rounded(.down)
    ])

    nextBoundaryDistance = [
      (position.x.rounded(.down) + (step.x == -1 ? 0 : 1) - position.x) / direction.x,
      (position.y.rounded(.down) + (step.y == -1 ? 0 : 1) - position.y) / direction.y,
      (position.z.rounded(.down) + (step.z == -1 ? 0 : 1) - position.z) / direction.z
    ]

    boundaryDistanceStep = [
      Float(step.x) / direction.x,
      Float(step.y) / direction.y,
      Float(step.z) / direction.z
    ]

    previousVoxel = initialVoxel
    self.count = count ?? Int.max
  }

  public mutating func next() -> BlockPosition? {
    if count == 0 {
      return nil
    }

    count -= 1

    var voxel: SIMD3<Int>
    if isFirst {
      isFirst = false
      voxel = initialVoxel
    } else {
      voxel = previousVoxel

      let minBoundaryDistance = abs(nextBoundaryDistance).min()
      if abs(nextBoundaryDistance.x) == minBoundaryDistance {
        nextBoundaryDistance.x += boundaryDistanceStep.x
        voxel.x += step.x
      } else if abs(nextBoundaryDistance.y) == minBoundaryDistance {
        nextBoundaryDistance.y += boundaryDistanceStep.y
        voxel.y += step.y
      } else {
        nextBoundaryDistance.z += boundaryDistanceStep.z
        voxel.z += step.z
      }
    }

    previousVoxel = voxel
    return BlockPosition(x: voxel.x, y: voxel.y, z: voxel.z)
  }
}
