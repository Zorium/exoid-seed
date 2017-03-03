#!/bin/sh
[ -z "$VERBOSE" ] && export VERBOSE=0
export NODE_ENV=test
export RETHINK_DB=obelix_test
export JWT_ES256_PRIVATE_KEY="-----BEGIN EC PRIVATE KEY-----
MHcCAQEEILw3KNnF6TtQhmyb3yzYNMXPblmZSxL69t+3Ux2yeyREoAoGCCqGSM49
AwEHoUQDQgAEr/bOaXkss53qbZRjRiPOwWM9/7PDNF2oPsNx5O1tzv/IX3qfbUc/
lWYxkbO48wRCfxM6/vtkBIka7PXw2gky+Q==
-----END EC PRIVATE KEY-----" # debug
export JWT_ES256_PUBLIC_KEY="-----BEGIN PUBLIC KEY-----
MFkwEwYHKoZIzj0CAQYIKoZIzj0DAQcDQgAEr/bOaXkss53qbZRjRiPOwWM9/7PD
NF2oPsNx5O1tzv/IX3qfbUc/lWYxkbO48wRCfxM6/vtkBIka7PXw2gky+Q==
-----END PUBLIC KEY-----" # debug

node_modules/gulp/bin/gulp.js test
