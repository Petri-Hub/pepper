.PHONY: build test-on-system test-on-ocale format-apply format-check lint check-architecture test-architecture serve

-include .env

export JEST_ROBLOX_OPEN_CLOUD_API_KEY
export JEST_ROBLOX_UNIVERSE_ID
export JEST_ROBLOX_PLACE_ID

format-apply:
	stylua src tests

format-check:
	stylua src tests --check

check-architecture:
	python3 scripts/architecture check

lint:
	selene src tests

dist:
	mkdir -p dist

build: dist
	rojo build --output ./dist/development.rbxlx

test-architecture:
	python3 -B scripts/architecture/test_architecture.py

test-on-system:
	jest-roblox-cli

test-on-ocale:
	jest-roblox-cli --backend open-cloud

serve:
	rojo serve
