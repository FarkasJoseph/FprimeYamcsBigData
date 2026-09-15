module BigData {

  @ A single row of height samples
  array HeightRow = [16] F32 default 0.0

  @ A fixed-size 16x16 grid of height samples, row-major.
  @ Declared as a top-level array-of-arrays (rather than nested inside a
  @ struct) so ground tools (fprime-xtce) generate a correct 2D ArrayParameterType;
  @ nested arrays inside struct members are not translated correctly by fprime-xtce.
  array HeightGridRows = [16] HeightRow

  @ Metadata describing the physical extent of a HeightGridRows grid, so ground
  @ tools can interpret its raw cell values
  struct HeightGridMeta {
    originX: F32   @< World-frame X of grid origin (m)
    originY: F32   @< World-frame Y of grid origin (m)
    cellSize: F32  @< Edge length of one cell (m)
  }


  struct MapChunk {
    map_id: U32
    sequence: U32
    is_last: U8
    data: [256] U8 @< !binary
  }

  array FloatSamples = [64] F32 @< !binary

}
