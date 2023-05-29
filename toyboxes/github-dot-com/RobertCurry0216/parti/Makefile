include .env

NAME := parti-example
DEST := ./builds/$(NAME).pdx
SOURCE := ./example

all: build run

build:
	pdc $(SOURCE) $(DEST)

run:
	$(RUN_SIMULATOR) $(DEST)

.PHONY: build run