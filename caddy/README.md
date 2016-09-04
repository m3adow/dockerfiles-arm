# Caddy for ARMv6

These are two Dockerfiles for ARMv6 devices, particularly the Raspbery Pi 1 (Model A & B), a dynamic and a static one.

`Dockerfile.dynamic` is intended for testing of Caddy Plugins. It will recompile Caddy on every container start. Needed plugins can be passed as a comma separated list (e.g. `filemanager,ipfilter,upload`) either via `CADDY_PLUGINS` environment variable or as the first run argument with a prepended `recompile=`.

`Dockerfile.static` is intended for a more production focussed use. It will only compile caddy on container building. Needed plugins need to be passed via comma separated list in the `static/caddy-enabled-plugins` file. Due to the static nature of its plugins, you'll need to build this container by yourself.

**Examples:**

```bash
# Dynamic
## Env var
$ docker run -e CADDY_PLUGINS="filemanager,ipfilter,upload" container4armhf/caddy
## Argument
$ docker run container4armhf/caddy "recompile=filemanager,ipfilter,upload"

# Static
$ cat static/caddy-enabled-plugins 
filemanager,ipfilter,upload
$ docker build -t caddy-fm-ipf-up -f Dockerfile.static .


```

