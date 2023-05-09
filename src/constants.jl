const FatalErrorLevel = Logging.LogLevel(3000)

function set_language(lang::String)
    PSRLOG_LANG[1] = lang
    return lang
end

function get_language()
    return PSRLOG_LANG[1]
end

function is_valid_dict(dict::Dict)::Bool
    if isempty(dict)
        println("Dictionary of codes and languages is empty.")
        return false
    else
        codes = dict |> keys |> collect
        for code in codes
            if isa(code, Int)
                continue
            end
            if isa(code, String) && !isnothing(tryparse(Int, code))
                continue
            end
            println(
                "Dictionary of codes and languages has a code that is not an Int representation.",
            )
            return false
        end
        for v in values(dict)
            if !isa(v, Dict)
                println("Dictionary of codes and languages has invalid structure, the ")
            end
            for ks in keys(v)
                if !isa(ks, String)
                    println(
                        "Dictionary of codes and languages has a language that is not a String.",
                    )
                    return false
                elseif isempty(ks)
                    println(
                        "Dictionary of codes and languages has a language that is an empty String.",
                    )
                    return false
                end
            end
        end
    end
    return true
end

function set_dict(dict::Dict)
    if !is_valid_dict(dict)
        error("The dictionary of codes and language is invalid.")
    end
    PSRLOG_LOG_DICT[1] = dict
    return dict
end

function get_dict()
    return PSRLOG_LOG_DICT[1]
end
