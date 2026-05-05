## shlog

Minimal POSIX shell logging utility. Single file. No dependencies.

## Install

```sh
curl -fsSL https://raw.githubusercontent.com/wakodiwe/shlog/refs/heads/main/install.sh | sh
```

Installs to `~/.local/lib/ok.sh` by default.

Override with `PREFIX`:

```sh
curl -fsSL https://raw.githubusercontent.com/wakodiwe/shlog/refs/heads/main/install.sh | PREFIX=/usr/local sh
```

Or just copy `shlog` into your project.

## Usage

```sh
shlog info "Application started"
shlog debug "Debug info"
shlog warn "Warning"
shlog error "Error"
```

| Command | Description |
|---|---|
| `debug <msg>` | Log debug message |
| `info <msg>` | Log info message |
| `warn <msg>` | Log warning message |
| `error <msg>` | Log error message |
| `setlevel <level>` | Set log level |
| `setfile <path>` | Set log file |
| `conf` | Show config |
| `tail` | Follow log |
| `rotate` | Keep last 1000 lines |
| `clear` | Clear log |

## Options

- `-v` - Print to console too
- `-h` - Show help

## Environment

| Variable | Description |
|---|---|
| `LOG_LEVEL` | Log level (debug\|info\|warn\|error) |
| `LOG_FILE` | Log file path |
| `LOG_NO_TIMESTAMP` | Set to 1 to disable timestamp |
| `LOG_FORMAT` | Custom format: `%t`=time `%l`=level `%m`=msg |

```sh
# No timestamp
LOG_NO_TIMESTAMP=1 shlog info "msg"

# Custom format
LOG_FORMAT="%l: %m" shlog info "msg"
# Output: info: msg
```

## Files

- `~/.shlog.log` - Log file
- `~/.shlog.conf` - Config

## Configuration Scope

The configuration uses two scopes:

### Persistent (saved to file)
```sh
shlog setlevel debug    # Saves to ~/.shlog.conf
shlog setfile /path     # Saves to ~/.shlog.conf
```

### Session-only (environment)
```sh
LOG_LEVEL=debug shlog info "msg"     # This session only
LOG_FILE=/path shlog info "msg"     # This session only
```

Environment variables override persistent config for the current session.

## Test

Uses [ok.sh](https://github.com/wakodiwe/ok.sh) for testing.

```sh
make test
```

## License

MIT
