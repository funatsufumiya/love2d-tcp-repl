# LÖVE/LÖVR TCP (telnet) REPL

TCP (telnet) REPL for LÖVE and LÖVR

## Usage

```bash
$ love --console .

# or
$ lovr --console .

# TCP (telnet) REPL is listening localhost:51335 ...
# --- Please telnet to localhost on port 51335
# --- After connecting, type 'exit' when you want to exit.
```

```bash
$ telnet 127.0.0.1 51335

> 1 + 1
2
> print("test")
test
nil
```

## Dependencies

- [stringify (MIT-LICENSE)](https://github.com/kitsunies/stringify.lua)
- [array.lua (MIT-LICENSE)](https://github.com/EvandroLG/array.lua)

### LoVR Plugins

***NOTE***: Check [Plugins](https://lovr.org/docs/Plugins) how to use them.
     You can use [prebuilt lovr executable](https://github.com/funatsufumiya/love2d-tcp-repl/releases/tag/v0.1) from releases.

- [lovr-luasocket](https://github.com/brainrom/lovr-luasocket)

## TODO

- expose global variable `_G` between server session (thread) and love2d main session
