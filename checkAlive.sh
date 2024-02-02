#!/bin/bash

cd /home/baydev && mysql log -e "call InsertLogEntry"
echo ok