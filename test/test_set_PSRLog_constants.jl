module TestConstants

using Test
import PSRLog

function test_set_and_get_language()
    PSRLog.set_language("pt")
    @test PSRLog.get_language() == "pt"
end

function test_set_and_get_valid_dict()
    valid_dict = Dict(
        1 => Dict(
            "en" => "hi!",
            "pt" => "oi!",
        ),
        2 => Dict(
            "en" => "bye!",
            "pt" => "tchau!",
        )
    )
    PSRLog.set_dict(valid_dict)
    @test PSRLog.get_dict() == valid_dict
end

function test_set_and_get_valid_dict_with_code_strings()
    valid_dict = Dict(
        "1" => Dict(
            "en" => "hi!",
            "pt" => "oi!",
        ),
        "2" => Dict(
            "en" => "bye!",
            "pt" => "tchau!",
        )
    )
    PSRLog.set_dict(valid_dict)
    @test PSRLog.get_dict() == valid_dict
end

function test_set_invalid_code_dict()
    invalid_dict = Dict(
        "en" => Dict(
            "en" => "hi!",
            "pt" => "oi!",
        ),
    )
    @test_throws ErrorException PSRLog.set_dict(invalid_dict)
end

function test_set_invalid_language_dict()
    invalid_dict = Dict(
        1 => Dict(
            2 => "hi!",
            "pt" => "oi!",
        ),
    )
    @test_throws ErrorException PSRLog.set_dict(invalid_dict)
end

function test_set_invalid_empty_language_dict()
    invalid_dict = Dict(
        1 => Dict(
            "" => "hi!",
            "pt" => "oi!",
        ),
    )
    @test_throws ErrorException PSRLog.set_dict(invalid_dict)
end


function test_set_empty_language_dict()
    invalid_dict = Dict()
    @test_throws ErrorException PSRLog.set_dict(invalid_dict)
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

TestConstants.runtests()

end # module
