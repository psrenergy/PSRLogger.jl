function close_psr_logger(logger::TeeLogger)
    # TODO use some API
    log_io_stream = logger.loggers[2].stream
    if isopen(log_io_stream)
        close(log_io_stream)
    end
    return nothing
end

function remove_log_file_path_on_logger_creation(log_file_path::String)
    try 
        rm(log_file_path; force = true)
    catch err
        if isa(err, Base.IOError)
            error("Cannot create a logger if $log_file_path still has IOStreams open.")
        end
    end
    return nothing
end

function create_psr_logger(log_file_path::String)
    remove_log_file_path_on_logger_creation(log_file_path)

    # Console logger only info and up
    format_logger_console = FormatLogger() do io, args
        println(io, "[", args.level, "] ", args.message)
    end
    console_logger = MinLevelLogger(format_logger_console, Logging.Info);

    # File logger logs everything
    format_logger_file = FormatLogger(log_file_path; append=true) do io, args
        println(io, now(), " ", "[", args.level, "] ", args.message)
    end
    logger = TeeLogger(
        console_logger,
        format_logger_file
    )
    global_logger(logger)
    return logger
end