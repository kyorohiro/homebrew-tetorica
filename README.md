

# mDrop

```
brew tap kyorohiro/tetorica
brew install tetorica-mdrop
```

## command 

```
tetorica-mdrop /path/to/share
```

## service 

```
cp file.zip "$(brew --prefix)/var/tetorica-mdrop/share/"
brew services start tetorica-mdrop
```


## Configuration File

Tetorica mDrop supports loading settings from a TOML configuration file.

### Example:

```
path = "/opt/homebrew/var/tetorica-mdrop/share"
hostname = "0.0.0.0"
port = 7878
no_bonjour = false
local_only = true
is_https = false
id = ""
password = ""
```

Start mDrop using a configuration file:

`tetorica-mdrop --config ~/.config/tetorica-mdrop/config.toml`

Example for Homebrew services:

`brew services start tetorica-mdrop`

Typical Homebrew configuration path:

`$(brew --prefix)/etc/tetorica-mdrop/config.toml`


### Parameters

#### Key	Description

```
path	Shared file or directory path
hostname	Hostname or bind address
port	HTTP server port
no_bonjour	Disable Bonjour / mDNS advertisement
local_only	Allow only local network access
is_https	Enable HTTPS mode
id	Optional access ID
password	Optional access password
```

### Priority

Command-line arguments override values from the configuration file.

#### Example:

```
tetorica-mdrop --config config.toml --port 8080
```

In this case, port 8080 is used instead of the value in config.toml.
