#!/bin/bash
#
# Cloud9 Environment Configuration
# --------------------------------
# Automate the setup of AWS Cloud9 IDE by installing the necessary 
# packages and tools to provide a ready-to-code environment.
#
# Usage:       
#    Execute this script with appropriate permissions to install the
#    required components for AWS Cloud9. Ensure that 'hm_bash_utils.sh' 
#    is present in the same directory as this script or adjust the source 
#    path accordingly.
#
# Prerequisites:
#     - 'hm_bash_utils.sh' script containing utility functions
#     - Script must have execution permissions set 
#       $ chmod +x install_Cloud9.sh
#
# -------------------------------------------------------------------------------------
# Script Name: install_Cloud9.sh
# Author:      Harmony
# Created on:  05 nov 2023
# Version:     1.0
# License:     MIT License
# -------------------------------------------------------------------------------------

source scripts/hm_bash_utils.sh

error_log_file="logs/Cloud9_errors.log"

print_title "Starting Cloud9 Environment Setup"

install_package "Node.js" \
                "sudo yum install -y nodejs" \
                $error_log_file

install_package "Development Packages" \
                "sudo yum groupinstall -y 'Development Tools' && sudo yum install -y glibc-static" \
                $error_log_file

install_package "Python 3 and pip" \
                "sudo yum install -y python3-pip && pip3 install wheel" \
                $error_log_file

install_package "Python devel and CodeIntel" \
                "sudo yum install -y python3.9-devel && pip3 install CodeIntel" \
                $error_log_file

install_package "C9 script" \
                "wget https://d3kgj69l4ph6w4.cloudfront.net/static/c9-install-2.0.0.sh && chmod +x c9-install-2.0.0.sh && ./c9-install-2.0.0.sh" \
                $error_log_file

print_title "Cloud9 Environment Setup Finished, check $error_log_file for any errors"
