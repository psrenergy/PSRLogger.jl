module TestLogLevels

using Test
using Logging
import PSRLogger

function test_debug_levels_debug_with_level_999()
    log_path = "log_debug_levels_test.log"
    level = -1000
    psr_logger = PSRLogger.create_psr_logger(log_path; min_level_console = Logging.LogLevel(level), min_level_file = Logging.LogLevel(level))
    PSRLogger.debug("debug")
    PSRLogger.debug("debug -999"; level = -999)
    PSRLogger.debug("debug -1"; level = -1)
    logs_on_file = readlines(log_path)
    @test length(logs_on_file) == 3
    @test occursin("debug", logs_on_file[1])
    @test occursin("debug -999", logs_on_file[2])
    @test occursin("debug -1", logs_on_file[3])
    PSRLogger.close_psr_logger(psr_logger)
    rm(log_path)
end

function test_debug_levels_2()
    log_path = "log_debug_levels_test.log"
    level = -100
    psr_logger = PSRLogger.create_psr_logger(log_path; min_level_console = Logging.LogLevel(level), min_level_file = Logging.LogLevel(level))
    PSRLogger.debug("debug")
    PSRLogger.debug("debug -999"; level = -999)
    PSRLogger.debug("debug -1"; level = -1)
    logs_on_file = readlines(log_path)
    @test length(logs_on_file) == 1
    @test occursin("debug -1", logs_on_file[1])
    PSRLogger.close_psr_logger(psr_logger)
    rm(log_path)
end

function test_debug_levels_assertion_error_1()
    log_path = "test_debug_levels_assertion_error.log"
    level = -100
    psr_logger = PSRLogger.create_psr_logger(log_path; min_level_console = Logging.LogLevel(level), min_level_file = Logging.LogLevel(level))
    @test_throws AssertionError PSRLogger.debug("debug"; level = 1)
    PSRLogger.close_psr_logger(psr_logger)
    rm(log_path)
end

function test_debug_levels_assertion_error_2()
    log_path = "test_debug_levels_assertion_error.log"
    level = -10000
    psr_logger = PSRLogger.create_psr_logger(log_path; min_level_console = Logging.LogLevel(level), min_level_file = Logging.LogLevel(level))
    @test_throws AssertionError PSRLogger.debug("debug"; level = -1001)
    PSRLogger.close_psr_logger(psr_logger)
    rm(log_path)
end

function test_log_levels_on_file()
    log_path = "log_file_levels_test.log"
    psr_logger = PSRLogger.create_psr_logger(log_path; min_level_console = Logging.Info, min_level_file = Logging.Warn)
    PSRLogger.debug("debug")
    PSRLogger.info("info")
    PSRLogger.warn("warn")
    PSRLogger.non_fatal_error("non_fatal_error")
    logs_on_file = readlines(log_path)
    @test length(logs_on_file) == 2
    @test occursin("warn", logs_on_file[1])
    @test occursin("non_fatal_error", logs_on_file[2])
    PSRLogger.close_psr_logger(psr_logger)
    rm(log_path)
end

function test_log_names_with_dict()
    level_dict = Dict(
            "Debug" => "debug",
            "Info" => "info",
            "Warn" => "warn",
            "Error" => "error"
    )
    log_path = "log_names_test.log"
    psr_logger = PSRLogger.create_psr_logger(log_path, level_dict)
    PSRLogger.debug("test")
    PSRLogger.info("test")
    PSRLogger.warn("test")
    PSRLogger.non_fatal_error("test")
    logs_on_file = readlines(log_path)
    @test occursin("[debug]", logs_on_file[1])
    @test occursin("[info]", logs_on_file[2])
    @test occursin("[warn]", logs_on_file[3])
    @test occursin("[error]", logs_on_file[4])
    PSRLogger.close_psr_logger(psr_logger)
    rm(log_path)
end

function runtests()
    for name in names(@__MODULE__; all = true)
        if startswith("$name", "test_")
            @testset "$(name)" begin
                getfield(@__MODULE__, name)()
            end
        end
    end
end

TestLogLevels.runtests()

end # module
