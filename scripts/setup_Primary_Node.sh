#!/bin/bash

PROJECT_DIR=$(pwd)

source scripts/hm_bash_utils.sh

error_log_file="logs/Primary_Node_errors.log"

print_title "Initializing Primary Node Setup for Harmony"

install_package "Git Version Control" \
                "sudo yum install -y git" \
                $error_log_file

install_package "Nginx HTTP and reverse proxy server" \
                "sudo yum install -y nginx" \
                $error_log_file

install_package "Python 3 virtual environment support" \
                "sudo yum install -y python3 python3-virtualenv" \
                $error_log_file

run_command "Creating a Python 3 virtual environment" \
            "python3 -m venv .venv" \
            $error_log_file

run_command "Activating the virtual environment" \
            "source ./.venv/bin/activate" \
            $error_log_file

install_package "Installing Harmony Web Browser Requirements" \
                "pip3 install -r requirements.txt" \
                $error_log_file

run_command "Setup Harmony service config" \
            "sed -i 's|WorkingDirectory=.*|WorkingDirectory=$PROJECT_DIR|' scripts/Harmony.service && sed -i 's|ExecStart=.*|ExecStart=$PROJECT_DIR/.venv/bin/gunicorn -b 0.0.0.0:8000 website.app.app:app|' scripts/Harmony.service" \
            $error_log_file

run_command "Setup Harmony service daemon" \
            "sudo cp scripts/Harmony.service /etc/systemd/system/Harmony.service && sudo systemctl daemon-reload && sudo systemctl restart Harmony.service && sudo systemctl enable Harmony" \
            $error_log_file

sudo systemctl status Harmony 

# run_command "Setup Harmony Nginx" \
#             "sudo systemctl start nginx && sudo systemctl enable nginx && sudo cp scripts/HarmonyWeb.conf /etc/nginx/conf.d/ && sudo systemctl restart nginx" \
#             $error_log_file

print_title "Primary Node Setup Finished, check $error_log_file for any errors"
