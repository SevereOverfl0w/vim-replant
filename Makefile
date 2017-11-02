.DEFAULT_GOAL=lua/replant.lua

lua:
	mkdir -p lua
lua/replant.lua: lua src/*
	cd src && lua $(URNPATH)/bin/urn.lua replant.lisp --output $(abspath $@)

repl:
	lua $(URNPATH)/bin/urn.lua
