module BigData {
    @ Component for F Prime FSW framework.
    active component BigDataComponent {

        # One async command/port is required for active components
        # This should be overridden by the developers with a useful command/port
        @ TODO
        async command REPORT_HEIGHT_MAP(
                                            map_id: U8 @< The ID of the wanted height map
        )

        @ Generate and downlink a fixed-size array of F32 samples, tagged "!binary" (see
        @ BigData.FloatSamples), to exercise numeric-typed (non-U8) binary blob telemetry.
        async command SEND_FLOAT_SAMPLES(
                                            seed: F32 @< Starting value; each sample is seed + index
        )

        telemetry HeightMapMeta: BigData.HeightGridMeta id 0x01 update on change

        telemetry HeightMapRows: BigData.HeightGridRows id 0x02 update on change

        telemetry MapStream: BigData.MapChunk id 0x03 update on change

        telemetry FloatSamplesTlm: BigData.FloatSamples id 0x04 update on change

        event SerializationStatus(status: Fw.SerialStatus) severity activity high id 0 format "Serialization status {}"

        # telemetry Temperatures: BigData.Temperatures id 0x03 update on change

        # @ Temperature exceeded 
        # event ExampleStateEvent(example_state: Fw.On) severity activity high id 0 format "State set to {}"


        ##############################################################################
        #### Uncomment the following examples to start customizing your component ####
        ##############################################################################

        # @ Example async command
        # async command COMMAND_NAME(param_name: U32)

        # @ Example telemetry counter
        # telemetry ExampleCounter: U64

        # @ Example event
        # event ExampleStateEvent(example_state: Fw.On) severity activity high id 0 format "State set to {}"

        # @ Example port: receiving calls from the rate group
        # sync input port run: Svc.Sched

        # @ Example parameter
        # param PARAMETER_NAME: U32

        ###############################################################################
        # Standard AC Ports: Required for Channels, Events, Commands, and Parameters  #
        ###############################################################################
        @ Port for requesting the current time
        time get port timeCaller

        @ Enables command handling
        import Fw.Command

        @ Enables event handling
        import Fw.Event

        @ Enables telemetry channels handling
        import Fw.Channel

        @ Port to return the value of a parameter
        param get port prmGetOut

        @Port to set the value of a parameter
        param set port prmSetOut

    }
}