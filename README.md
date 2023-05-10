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

One suggestion to store the codes ans messages for multiple languages is to store it on a TOML file. The function `PSRLogger.set_dict` accepts the TOML path as input. 

Dictionary TOML:
```toml
[1]
"en" = "Hello!"
"pt" = "Olá!"

[2]
"en" = "The file @@@ does not exist."
"pt" = "O arquivo @@@ não existe."
```

Set dictionary from TOML:
```julia
log_path = "langs.log"
toml_dict_path = "example.toml"
PSRLogger.set_dict(toml_dict_path)
PSRLogger.set_language("pt")
psr_logger = PSRLogger.create_psr_logger(log_path)
# It will log the portuguese version "Olá!"
PSRLogger.info(1)
# It will display the message "O arquivo file.txt não existe"
PSRLogger.info(2, "file.txt")
```

## Create logger

There arguments that can be passed using `PSRLogger.create_psr_logger`:
* `log_file_path`: Log file path. This input must be passed
* `min_level_console`: Minimum level shown in console. Default: Logging.Info
* `min_level_file`: Minimum level shown in file. Default: Logging.Debug
* `append_log`: Boolean input to append logs in existing log file (if true) or overwrite/create log file (if false). Default is false
* `brackets`: a boolean constant to determine wheter or not the tag brackets will be printed. As default, `brackets = true`. For example, `PSRLogger.info("message")` is printed as `[Info] message` if `brackets = true` and as `info message` if `brackets = false`
* `level_dict`: defined in order to change the tags. As default, 
```
level_dict = Dict(
    "Debug Level" => "Debug Level",
    "Debug" => "Debug",
    "Info" => "Info",
    "Warn" => "Warn",
    "Error" => "Error",
    "Fatal Error" => "Fatal Error"
)
```
* `color_dict`: one can customize the tag colors displayed in terminal using this dictionary. As default,
```
color_dict = Dict(
    "Debug Level" => :cyan,
    "Debug" => :cyan,
    "Info" => :cyan,
    "Warn" => :yellow,
    "Error" => :red,
    "Fatal Error" => :red
)
```
* `background_reverse_dict`: used to customize the background of a tag in terminal. As default, 
```
background_reverse_dict = Dict(
    "Debug Level" => false,
    "Debug" => false,
    "Info" => false,
    "Warn" => false,
    "Error" => false,
    "Fatal Error" => true
)
```

The next example shows how to print the tags in lowercase letters, with julia default string colors and background.
```julia
level_dict = Dict(
    "Debug Level" => "debug level",
    "Debug" => "debug",
    "Info" => "info",
    "Warn" => "warn",
    "Error" => "error",
    "Fatal Error" => "fatal error"
)
color_dict = Dict(
    "Debug Level" => :normal,
    "Debug" => :normal,
    "Info" => :normal,
    "Warn" => :normal,
    "Error" => :normal,
    "Fatal Error" => :normal
)
background_reverse_dict = Dict(
    "Debug Level" => false,
    "Debug" => false,
    "Info" => false,
    "Warn" => false,
    "Error" => false,
    "Fatal Error" => false
)

log_file = "my_application.log"
PSRLogger.create_psr_logger(log_file; level_dict, color_dict, background_reverse_dict)
```
