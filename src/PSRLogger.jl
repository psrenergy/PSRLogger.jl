module PSRLogger

using LoggingExtras
using Dates
using TOML

const PSRLOG_LANG = String["en"]
const PSRLOG_LOG_DICT = [Dict()]

include("constants.jl")
include("psr_logger.jl")
include("logs.jl")

end # module PSRLogger
