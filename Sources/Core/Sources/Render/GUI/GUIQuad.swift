import Metal
import simd

/// A convenient way to construct the vertices for a GUI quad.
struct GUIQuad {
  static let vertices: [(position: SIMD2<Float>, uv: SIMD2<Float>)] = [
    (position: [0, 0], uv: [0, 0]),
    (position: [1, 0], uv: [1, 0]),
    (position: [1, 1], uv: [1, 1]),
    (position: [0, 1], uv: [0, 1])
  ]
  private static let verticesBuffer = vertices.withUnsafeBufferPointer { $0 }

  var position: SIMD2<Float>
  var size: SIMD2<Float>
  var uvMin: SIMD2<Float>
  var uvSize: SIMD2<Float>
  var textureIndex: UInt16
  var tint: SIMD4<Float>

  init(
    position: SIMD2<Float>,
    size: SIMD2<Float>,
    uvMin: SIMD2<Float>,
    uvSize: SIMD2<Float>,
    textureIndex: UInt16,
    tint: SIMD4<Float> = [1, 1, 1, 1]
  ) {
    self.position = position
    self.size = size
    self.uvMin = uvMin
    self.uvSize = uvSize
    self.textureIndex = textureIndex
    self.tint = tint
  }

  /// Creates a quad instance for a solid color rectangle.
  init(
    position: SIMD2<Float>,
    size: SIMD2<Float>,
    color: SIMD4<Float>
  ) {
    self.position = position
    self.size = size
    self.tint = color
    self.uvMin = .zero
    self.uvSize = .zero
    self.textureIndex = UInt16.max
  }

  /// Creates a quad instance for the given sprite.
  init(
    for sprite: GUISpriteDescriptor,
    guiTexturePalette: GUITexturePalette,
    guiArrayTexture: MTLTexture,
    position: SIMD2<Int> = .zero
  ) {
    let textureSize: SIMD2<Float> = [
      Float(guiArrayTexture.width),
      Float(guiArrayTexture.height)
    ]

    self.position = SIMD2<Float>(position)
    size = SIMD2<Float>(sprite.size)
    uvMin = SIMD2<Float>(sprite.position) / textureSize
    uvSize = self.size / textureSize
    textureIndex = UInt16(guiTexturePalette.textureIndex(for: sprite.slice))
    tint = [1, 1, 1, 1]
  }

  /// Gets the vertices of the quad as an array.
  func toVertices() -> [GUIVertex] {
    // Basically just creating an array containing four vertices but fancilly to make it faster (I'm
    // only doing it this way because it measurably speeds up some other parts of the code).
    return Array(unsafeUninitializedCapacity: 4) { buffer, count in
      let tuple = toVertexTuple()
      buffer[0] = tuple.0
      buffer[1] = tuple.1
      buffer[2] = tuple.2
      buffer[3] = tuple.3

      count = 4
    }
  }

  /// An alternative to ``toVertices()`` that can be used in performance critical situations.
  func toVertexTuple() -> (GUIVertex, GUIVertex, GUIVertex, GUIVertex) { // swiftlint:disable:this large_tuple
    (
      GUIVertex(
        position: Self.verticesBuffer[0].position * size + position,
        uv: Self.verticesBuffer[0].uv * uvSize + uvMin,
        tint: tint,
        textureIndex: textureIndex
      ),
      GUIVertex(
        position: Self.verticesBuffer[1].position * size + position,
        uv: Self.verticesBuffer[1].uv * uvSize + uvMin,
        tint: tint,
        textureIndex: textureIndex
      ),
      GUIVertex(
        position: Self.verticesBuffer[2].position * size + position,
        uv: Self.verticesBuffer[2].uv * uvSize + uvMin,
        tint: tint,
        textureIndex: textureIndex
      ),
      GUIVertex(
        position: Self.verticesBuffer[3].position * size + position,
        uv: Self.verticesBuffer[3].uv * uvSize + uvMin,
        tint: tint,
        textureIndex: textureIndex
      )
    )
  }

  /// Translates the quad by the given amount.
  /// - Parameter amount: The amount of pixels to translate by along each axis.
  mutating func translate(amount: SIMD2<Float>) {
    self.position += amount
  }
}
