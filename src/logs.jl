# Additional level
macro fatal_error(msg)
    quote
        @error $(esc(msg))
        if !isinteractive()
            exit(1)
        end
    end
end

# Debug with level
# interpolate with a number
# Remove fatal error
# find a way to set level of file and console via function
# Remove log_...
# Remove PSRLog from functions names

# Direct logs
function debug(msg::String)
    @debug msg
    return nothing
end
function info(msg::String)
    @info msg
    return nothing
end
function warn(msg::String)
    @warn msg
    return nothing
end
function _error(msg::String)
    @error msg
    return nothing
end
function fatal_error(msg::String)
    @fatal_error msg
    return nothing
end

function log_msg(level::Int, msg::String)
    @logmsg level msg
    return nothing
end

# logs via code and language
function get_raw_message(dict::Dict, code::Int, lang::String)
    # Code could be an Int
    if haskey(dict, code)
        langs_dict = dict[code]
        if haskey(langs_dict, lang)
            return langs_dict[lang]
        else
            error("Message of code $code does not have the language $lang.")
        end
    # Code could also be a string that parses to Int
    elseif haskey(dict, "$code")
        langs_dict = dict[code]
        if haskey(langs_dict, lang)
            return langs_dict[lang]
        else
            error("Message of code $code does not have the language $lang.")
        end
    else
        error("Message of code $code does not exist.")
    end
end

function prepare_msg(code::Int, replacements...)
    dict = get_dict()
    lang = get_language()
    raw_message = get_raw_message(dict, code, lang)
    treated_message = treat_message(raw_message, replacements...)
    return treated_message
end

function treat_message(raw_message::String, replacements...)
    splitted_message = split(raw_message, "@@@")
    num_correct_replacements = length(splitted_message) - 1
    # If the is no @@@ in the message we can return the raw_message
    if num_correct_replacements == 0
        return raw_message
    end
    if num_correct_replacements != length(replacements)
        error("Invalid interpolation, log should have $num_correct_replacements args.")
    end
    treated_message = ""
    for i in 1:num_correct_replacements
        treated_message *= string(splitted_message[i], replacements[i])
    end
    return treated_message
end

function debug(code::Int, replacements...)
    msg = prepare_msg(code, replacements...)
    debug(msg)
    return nothing
end
function info(code::Int, replacements...)
    msg = prepare_msg(code, replacements...)
    info(msg)
    return nothing
end
function warn(code::Int, replacements...)
    msg = prepare_msg(code, replacements...)
    warn(msg)
    return nothing
end
function _error(code::Int, replacements...)
    msg = prepare_msg(code, replacements...)
    _error(msg)
    return nothing
end
function fatal_error(code::Int, replacements...)
    msg = prepare_msg(code, replacements...)
    fatal_error(msg)
    return nothing
end
