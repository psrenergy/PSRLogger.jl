module TestPsrLogger

using Test
import PSRLogger

function test_create_and_close_psr_logger()
    log_path = "test_log.log"
    psr_logger = PSRLogger.create_psr_logger(log_path)
    @test isfile(log_path)
    PSRLogger.close_psr_logger(psr_logger)
    return rm(log_path)
end

function test_create_two_psr_loggers_in_different_files()
    log_path1 = "test_log1.log"
    log_path2 = "test_log2.log"
    psr_logger1 = PSRLogger.create_psr_logger(log_path1)
    psr_logger2 = PSRLogger.create_psr_logger(log_path2)
    @test isfile(log_path1)
    @test isfile(log_path2)
    PSRLogger.close_psr_logger(psr_logger1)
    PSRLogger.close_psr_logger(psr_logger2)
    rm(log_path1)
    return rm(log_path2)
end

function test_create_two_psr_loggers_in_the_same_file()
    log_path = "test_log.log"
    psr_logger1 = PSRLogger.create_psr_logger(log_path)
    @test isfile(log_path)
    psr_logger2 = PSRLogger.create_psr_logger(log_path)
    @test isfile(log_path)
    PSRLogger.close_psr_logger(psr_logger1)
    PSRLogger.close_psr_logger(psr_logger2)
    return rm(log_path)
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

TestPsrLogger.runtests()

end # module
