#!/bin/bash
stack build && stack install && sh -c 'stack exec erin-hello -- configuration.txt'
