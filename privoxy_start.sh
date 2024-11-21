#!/bin/sh
CFG_DIR=/etc/privoxy
CFG_FILE=/etc/privoxy/config
PID_FILE=/var/run/privoxy.pid

if [ ! -f "${CFG_FILE}" ]; then
        echo "Configuration file ${CFG_FILE} not found!"
        exit 1
fi

cd $CFG_DIR
[ -f default.filter ] || cp -v default.filter.new default.filter
[ -f user.filter ] || cp -v user.filter.new user.filter
[ -f match-all.action ] || cp -v match-all.action.new match-all.action
[ -f default.action ] || cp -v default.action.new default.action
[ -f user.action ] || cp -v user.action.new user.action

chmod 660 $CFG_DIR/*
chmod 774 $CFG_DIR/templates
chown privoxy:privoxy $CFG_DIR/*
