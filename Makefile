include .env

NAME := super-date-box
DIR := ./builds
DEST := $(DIR)/$(NAME).pdx
SOURCE := ./source


all: build run

build:
	dir "$(DIR)" || mkdir "$(DIR)"
	$(PYTHON) ./inc_build.py
	pdc $(SOURCE) $(DEST)


run:
	$(RUN_SIMULATOR) $(DEST)

.PHONY: run build