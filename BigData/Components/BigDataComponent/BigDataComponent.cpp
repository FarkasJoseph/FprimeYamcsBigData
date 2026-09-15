// ======================================================================
// \title  BigDataComponent.cpp
// \author farkas
// \brief  cpp file for BigDataComponent component implementation class
// ======================================================================

#include "BigData/Components/BigDataComponent/BigDataComponent.hpp"

namespace BigData {

// ----------------------------------------------------------------------
// Component construction and destruction
// ----------------------------------------------------------------------

BigDataComponent ::BigDataComponent(const char* const compName) : BigDataComponentComponentBase(compName) {
    HeightGridMeta new_meta{};
    new_meta.set_originX(0);
    new_meta.set_originY(0);
    new_meta.set_cellSize(1);
    gridMetas.emplace_back(new_meta);
    gridRows.emplace_back(HeightGridRows{});

    new_meta.set_originX(1);
    new_meta.set_originY(-0.5);
    new_meta.set_cellSize(1.771);
    gridMetas.emplace_back(new_meta);

    HeightGridRows rows{};
    for (HeightGridRows::SizeType i = 0; i < rows.SIZE; ++i) {
        HeightRow& row = rows[i];
        for (HeightRow::SizeType i = 0; i < row.SIZE; ++i) {
            row[i] = rand() / 5000.0;
        }
    }
    gridRows.emplace_back(rows);
}

BigDataComponent ::~BigDataComponent() {}

// ----------------------------------------------------------------------
// Handler implementations for commands
// ----------------------------------------------------------------------

void BigDataComponent ::REPORT_HEIGHT_MAP_cmdHandler(FwOpcodeType opCode, U32 cmdSeq, U8 map_id) {
    FW_ASSERT(map_id < gridMetas.size());
    this->tlmWrite_HeightMapMeta(gridMetas[map_id]);
    this->tlmWrite_HeightMapRows(gridRows[map_id]);

    U8 rawDestinationArray[HeightGridRows::SERIALIZED_SIZE];

    Fw::ExternalSerializeBuffer serializeBuffer(rawDestinationArray, sizeof(rawDestinationArray));

    Fw::SerializeStatus status = gridRows[map_id].serializeTo(serializeBuffer);

    if (status == Fw::FW_SERIALIZE_OK) {
        U32 finalByteLength = serializeBuffer.getSize();
        streamHeightMap(map_id, rawDestinationArray, finalByteLength);
        this->log_ACTIVITY_HI_SerializationStatus(Fw::SerialStatus::OK);
    } else {
        this->log_ACTIVITY_HI_SerializationStatus(Fw::SerialStatus::FORMAT_ERROR);
    }

    this->cmdResponse_out(opCode, cmdSeq, Fw::CmdResponse::OK);
}

void BigDataComponent ::SEND_FLOAT_SAMPLES_cmdHandler(FwOpcodeType opCode, U32 cmdSeq, F32 seed) {
    FloatSamples samples;
    for (FloatSamples::SizeType i = 0; i < samples.SIZE; ++i) {
        samples[i] = seed + static_cast<F32>(i);
    }
    this->tlmWrite_FloatSamplesTlm(samples);
    this->cmdResponse_out(opCode, cmdSeq, Fw::CmdResponse::OK);
}

void BigDataComponent ::streamHeightMap(U32 mapId, U8 const* rawMapData, U32 totalSize) {
    U32 const chunkSize = 256;
    U32 bytesRemaining = totalSize;
    U32 sequenceNum = 0;
    U8 const* currentPtr = rawMapData;

    while (bytesRemaining > 0) {
        MapChunk chunk;
        chunk.set_map_id(mapId);
        chunk.set_sequence(sequenceNum);

        U32 currentChunkSize = (bytesRemaining > chunkSize) ? chunkSize : bytesRemaining;
        chunk.set_is_last((bytesRemaining <= chunkSize) ? 1 : 0);

        U8* dataBuffer = chunk.get_data();
        std::memcpy(dataBuffer, currentPtr, currentChunkSize);

        this->tlmWrite_MapStream(chunk);

        bytesRemaining -= currentChunkSize;
        currentPtr += currentChunkSize;
        sequenceNum++;

        // Os::Task::delay(Fw::TimeInterval(0, 500000)); 
        Os::Task::delay(Fw::TimeInterval(1, 0)); 
    }
}

}  // namespace BigData
