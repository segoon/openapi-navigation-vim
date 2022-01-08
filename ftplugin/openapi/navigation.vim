if exists("b:did_ftplugin_openapi")
    finish
endif
let b:did_ftplugin_openapi = 1

call openapi#navigation#SetupKeymap()
