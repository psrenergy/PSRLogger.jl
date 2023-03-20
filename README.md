# PSRLogger.jl

A minimal and opinionated way to deal with compositional loggers built with LoggingExtras.jl. 

The package also has helps users to deal with logs in multiple languages.

## Basic usage

PSRLogger will log messages to different locations.

```julia
import PSRLogger

log_file = "my_application.log"
psr_logger = PSRLogger.create_psr_logger(log_file)

# Only goes to file
PSRLogger.debug("debug message")

# Goes to file and console
PSRLogger.info("info message")
PSRLogger.warn("warn message")
PSRLogger.non_fatal_error("error message")

# Goes to console and file and then runs exit(1) if the session is not iterative.
PSRLogger.fatal_error("Application cannot continue")
```

## Log in differnt languages

PSRLogger stores some constants that help users deal with logs in different languages.

```julia
log_path = "langs.log"
langs_dict = Dict(
    1 => Dict(
        "en" => "Hello!",
        "pt" => "Olá!",
    ),
    2 => Dict(
        "en" => "The file @@@ does not exist.",
        "pt" => "O arquivo @@@ não existe.",
    )
)
PSRLogger.set_dict(langs_dict)
PSRLogger.set_language("pt")
psr_logger = PSRLogger.create_psr_logger(log_path)
# It will log the portuguese version "Olá!"
PSRLogger.info(1)
# It will display the message "O arquivo file.txt não existe"
PSRLogger.info(2, "file.txt")
```

One suggestion to store the codes ans messages for multiple languages is to store it on a TOML file.
```toml
[1]
"en" = "Hello!"
"pt" = "Olá!"

[2]
"en" = "The file @@@ does not exist."
"pt" = "O arquivo @@@ não existe."
```
