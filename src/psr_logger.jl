"""
    close_psr_logger(logger::TeeLogger)

* `logger`: TeeLogger with console and file logs
"""
function close_psr_logger(logger::TeeLogger)
    # TODO use some API
    log_io_stream = logger.loggers[2].logger.stream
    if isopen(log_io_stream)
        close(log_io_stream)
    end
    return nothing
end

"""
remove_log_file_path_on_logger_creation(log_file_path::String)

* `log_file_path`: Remove log file in path log_file_path
"""
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

function choose_level_to_print(level::LogLevel, level_dict::Dict)
    if level >= Logging.Info || level == Logging.Debug
        return level_dict[string(level)]
    end
    return string(level_dict["Debug Level"]*" ", level.level)
end

"""
    create_psr_logger(
        log_file_path::String; 
        min_level_console::Logging.LogLevel = Logging.Info, 
        min_level_file::Logging.LogLevel = Logging.Debug
    )

* `log_file_path`: Log file path
* `min_level_console`: Minimum level shown in console
* `min_level_file`: Minimum level shown in file
* `level_dict`: Dictionary to select logging name to print
"""
function create_psr_logger(
        log_file_path::String; 
        min_level_console::Logging.LogLevel = Logging.Info, 
        min_level_file::Logging.LogLevel = Logging.Debug,
        level_dict::Dict = Dict(
            "Debug Level" => "Debug Level",
            "Debug" => "Debug",
            "Info" => "Info",
            "Warn" => "Warn",
            "Error" => "Error"
        )
    )
    remove_log_file_path_on_logger_creation(log_file_path)

    # Console logger only min_level_console and up
    format_logger_console = FormatLogger() do io, args
        level_to_print = choose_level_to_print(args.level, level_dict)
        println(io, "[", level_to_print, "] ", args.message)
    end
    console_logger = MinLevelLogger(format_logger_console, min_level_console);

    # File logger logs min_level_file and up
    format_logger_file = FormatLogger(log_file_path; append=true) do io, args
        level_to_print = choose_level_to_print(args.level, level_dict)
        println(io, now(), " ", "[", level_to_print, "] ", args.message)
    end
    file_logger = MinLevelLogger(format_logger_file, min_level_file);
    logger = TeeLogger(
        console_logger,
        file_logger
    )
    global_logger(logger)
    return logger
end
