// ======================================================================
// \title  BigDataComponent.hpp
// \author farkas
// \brief  hpp file for BigDataComponent component implementation class
// ======================================================================

#ifndef BigData_BigDataComponent_HPP
#define BigData_BigDataComponent_HPP

#include "BigData/Components/BigDataComponent/BigDataComponentComponentAc.hpp"

#include <vector>

namespace BigData {

class BigDataComponent final : public BigDataComponentComponentBase {
  public:
    // ----------------------------------------------------------------------
    // Component construction and destruction
    // ----------------------------------------------------------------------

    //! Construct BigDataComponent object
    BigDataComponent(const char* const compName  //!< The component name
    );

    //! Destroy BigDataComponent object
    ~BigDataComponent();

  private:
    // ----------------------------------------------------------------------
    // Handler implementations for commands
    // ----------------------------------------------------------------------

    //! Handler implementation for command REPORT_HEIGHT_MAP
    //!
    //! TODO
    void REPORT_HEIGHT_MAP_cmdHandler(FwOpcodeType opCode,  //!< The opcode
                                      U32 cmdSeq,           //!< The command sequence number
                                      U8 map_id             //!< The ID of the wanted height map
                                      ) override;

    //! Handler implementation for command SEND_FLOAT_SAMPLES
    void SEND_FLOAT_SAMPLES_cmdHandler(FwOpcodeType opCode,  //!< The opcode
                                       U32 cmdSeq,           //!< The command sequence number
                                       F32 seed              //!< Starting value; each sample is seed + index
                                       ) override;

    std::vector<HeightGridMeta> gridMetas{};
    std::vector<HeightGridRows> gridRows{};


    void streamHeightMap(U32 mapId, U8 const* rawMapData, U32 totalSize);
};

}  // namespace BigData

#endif
