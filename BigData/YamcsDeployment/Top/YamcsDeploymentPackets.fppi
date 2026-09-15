telemetry packets YamcsDeploymentPackets {

  packet CDH id 1 group 1 {
    CdhCore.cmdDisp.CommandsDispatched
    CdhCore.cmdDisp.CommandsDropped

    FileHandling.fileUplink.FilesReceived
    FileHandling.fileUplink.FilesReceivedFailed
    FileHandling.fileUplink.PacketsReceived
    FileHandling.fileDownlink.FilesSent
    FileHandling.fileDownlink.PacketsSent
    FileHandling.fileManager.CommandsExecuted

    BigData.cmdSeq.CS_LoadCommands
    BigData.cmdSeq.CS_CancelCommands
    BigData.cmdSeq.CS_CommandsExecuted
    BigData.cmdSeq.CS_SequencesCompleted
    ComCcsds.comQueue.comQueueDepth
    ComCcsds.comQueue.buffQueueDepth
    ComCcsds.commsBufferManager.TotalBuffs
    ComCcsds.commsBufferManager.CurrBuffs
    ComCcsds.commsBufferManager.HiBuffs
    #CdhCore.tlmSend.SendLevel

    BigData.rateGroup1.RgMaxTime
    BigData.rateGroup2.RgMaxTime
    BigData.rateGroup3.RgMaxTime
  }

  packet CDHErrors id 2 group 1 {
    CdhCore.$health.PingLateWarnings

    FileHandling.fileUplink.Warnings
    FileHandling.fileDownlink.Warnings
    FileHandling.fileManager.Errors

    BigData.cmdSeq.CS_Errors
    ComCcsds.commsBufferManager.NoBuffs
    ComCcsds.commsBufferManager.EmptyBuffs

    BigData.rateGroup1.RgCycleSlips
    BigData.rateGroup2.RgCycleSlips
    BigData.rateGroup3.RgCycleSlips
  }

  packet SystemRes1 id 5 group 2 {
    BigData.systemResources.MEMORY_TOTAL
    BigData.systemResources.MEMORY_USED
    BigData.systemResources.NON_VOLATILE_TOTAL
    BigData.systemResources.NON_VOLATILE_FREE
  }

  packet SystemRes3 id 6 group 2 {
    BigData.systemResources.CPU
    BigData.systemResources.CPU_00
    BigData.systemResources.CPU_01
    BigData.systemResources.CPU_02
    BigData.systemResources.CPU_03
    BigData.systemResources.CPU_04
    BigData.systemResources.CPU_05
    BigData.systemResources.CPU_06
    BigData.systemResources.CPU_07
    BigData.systemResources.CPU_08
    BigData.systemResources.CPU_09
    BigData.systemResources.CPU_10
    BigData.systemResources.CPU_11
    BigData.systemResources.CPU_12
    BigData.systemResources.CPU_13
    BigData.systemResources.CPU_14
    BigData.systemResources.CPU_15
  }

  packet DataProducts id 21 group 3 {
    DataProducts.dpCat.CatalogDps
    DataProducts.dpCat.DpsSent

    DataProducts.dpMgr.NumSuccessfulAllocations
    DataProducts.dpMgr.NumFailedAllocations
    DataProducts.dpMgr.NumDataProducts
    DataProducts.dpMgr.NumBytes

    DataProducts.dpWriter.NumBuffersReceived
    DataProducts.dpWriter.NumBytesWritten
    DataProducts.dpWriter.NumSuccessfulWrites
    DataProducts.dpWriter.NumFailedWrites
    DataProducts.dpWriter.NumErrors

    DataProducts.dpBufferManager.TotalBuffs
    DataProducts.dpBufferManager.CurrBuffs
    DataProducts.dpBufferManager.HiBuffs
    DataProducts.dpBufferManager.NoBuffs
    DataProducts.dpBufferManager.EmptyBuffs
  }

 packet Version1 id 22 group 2 {
  CdhCore.version.FrameworkVersion
   CdhCore.version.ProjectVersion
 }

 packet Version_Library1 id 23 group 2 {
   CdhCore.version.LibraryVersion01
   CdhCore.version.LibraryVersion02
 }

 packet Version_Library2 id 24 group 2 {
   CdhCore.version.LibraryVersion03
   CdhCore.version.LibraryVersion04
 }

 packet Version_Library3 id 25 group 2 {
   CdhCore.version.LibraryVersion05
   CdhCore.version.LibraryVersion06
 }

 packet Version_Library4 id 26 group 2 {
   CdhCore.version.LibraryVersion07
   CdhCore.version.LibraryVersion08
 }

 packet Version_Library5 id 27 group 2 {
   CdhCore.version.LibraryVersion09
   CdhCore.version.LibraryVersion10
 }

 packet Version_Custom1 id 28 group 2 {
   CdhCore.version.CustomVersion01
 }

 packet Version_Custom2 id 29 group 2 {
   CdhCore.version.CustomVersion02
 }

 packet Version_Custom3 id 30 group 2 {
   CdhCore.version.CustomVersion03
 }

 packet Version_Custom4 id 31 group 2 {
   CdhCore.version.CustomVersion04
 }

 packet Version_Custom5 id 32 group 2 {
   CdhCore.version.CustomVersion05
 }

 packet Version_Custom6 id 33 group 2 {
   CdhCore.version.CustomVersion06
 }

 packet Version_Custom7 id 34 group 2 {
   CdhCore.version.CustomVersion07
 }

 packet Version_Custom8 id 35 group 2 {
   CdhCore.version.CustomVersion08
 }

 packet Version_Custom9 id 36 group 2 {
   CdhCore.version.CustomVersion09
 }

 packet Version_Custom10 id 37 group 2 {
   CdhCore.version.CustomVersion10
 }

 packet HeightMap_Telem id 40 group 1 {
    bigDataComponent.HeightMapMeta
    bigDataComponent.HeightMapRows
 }

 packet MapChunk id 41 group 1 {
    bigDataComponent.MapStream
 }

packet FloatSamples id 42 group 1 {
    bigDataComponent.FloatSamplesTlm
 }

} omit {
  CdhCore.cmdDisp.CommandErrors
  CdhCore.events.EventsDropped
  CdhCore.tlmSend.SectionEnabled 
  CdhCore.tlmSend.GroupConfigs 
  DataProducts.dpBufferAccumulator.BA_NumQueuedBuffers
  cmdSeq.CS_CurrentSequence
}
