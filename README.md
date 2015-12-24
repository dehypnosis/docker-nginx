# docker-nginx
Nginx image based on [baseimage-docker](http://phusion.github.io/baseimage-docker/).

While building the following steps are executed:

* [Nginx](http://nginx.org/) 1.9.x is built with modules:
  * [openresty/echo-nginx-module](https://github.com/openresty/echo-nginx-module) - brings "echo", "sleep", "time", "exec" and more shell commands to config file;
  * [openresty/lua-nginx-module](https://github.com/openresty/lua-nginx-module) - embed the power of Lua into Nginx HTTP servers;
  * [yaoweibin/nginx_upstream_check_module](https://github.com/yaoweibin/nginx_upstream_check_module) - add the support of upstream server health checks;
  * and standard http/2 module is enabled.
* Sample Lua module and configuration module are attached.
* IPv6 is disabled inside container.

## Lua-nginx-module

Lua module gives a practically unlimited abilities for HTTP requests handling. It's extremely fast thanks to [LuaJIT](http://luajit.org/) and non-blocking thanks to Nginx nature.

[lua-example.conf](lua-example.conf) demonstrates how to use external Lua modules. For example:

````
location /lua {
    content_by_lua_block {
        ngx.say("Hello, world!")
    }
}
```

It's an equivalent for:

```
location /echo {
    echo "Hello, world!";
}
```

This module allows to plugin external Lua functions (modules), integrate into Nginx request handling phases, invoke subrequests and much more.