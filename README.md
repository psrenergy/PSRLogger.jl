# PSRLog.jl

A minimal and opinionated way to deal with compositional loggers built with LoggingExtras.jl. 

The package also has helps users to deal with logs in multiple languages.

## Basic usage

PSRLog will log messages to different locations.

```julia
import PSRLog

log_file = "my_application.log"
psr_logger = PSRLog.create_psr_logger(log_file)

# Only goes to file
PSRLog.debug("debug message")

# Goes to file and console
PSRLog.info("info message")
PSRLog.warn("warn message")
PSRLog.log_error("error message")

# Goes to console and file and then runs exit(1) if the session is not iterative.
PSRLog.fatal_error("Application cannot continue")
```

## Log in differnt languages

PSRLog stores some constants that help users deal with logs in different languages.

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
PSRLog.set_dict(langs_dict)
PSRLog.set_language("pt")
psr_logger = PSRLog.create_psr_logger(log_path)
# It will log the portuguese version "Olá!"
PSRLog.info(1)
# It will display the message "O arquivo file.txt não existe"
PSRLog.info(2, "file.txt")
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
