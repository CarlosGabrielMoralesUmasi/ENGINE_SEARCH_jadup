#!/bin/bash
#
# Utility Functions for Package Installation Script
# ------------------------------------------------
# This script provides a set of utility functions to be sourced by other shell
# scripts for installing packages and reporting their status. It is intended to
# standardize the output and error handling for package installations.
#
# Functions:
#   print_title
#   print_success
#   print_failed
#   print_finish
#   install_package
#
# Usage:
#   Source this script in other installation scripts to utilize its functions.
#
# -------------------------------------------------------------------------------------
# Author:      Harmony
# Created on:  05 nov 2023
# Version:     1.0
# License:     MIT License
# -------------------------------------------------------------------------------------

print() {
  echo -e "$1  ==== $2 ====\e[0m"
}

# Function: print_title
# Description: Prints a title for the installation step in bold blue color.
# Usage: print_title "Title of the Step"
# Parameters:
#   $1 - The title text to be printed
print_title() {
  echo -e "******* $1 *******\e[0m"
}

# Function: print_success
# Description: Prints a success message in bold green color indicating the
#              successful installation of a package.
# Usage: print_success "Package Name"
# Parameters:
#   $1 - The name of the package that was successfully installed
print_success() {
  echo -e "\e[1;32m    $1 successfully.\e[0m"
}

# Function: print_failed
# Description: Prints a failure message in bold red color indicating that the
#              installation of a package has failed and refers to the log file.
# Usage: print_failed "Package Name"
# Parameters:
#   $1 - The name of the package that failed to install
print_failed() {
  echo -e "\e[1;31m    Failed $1 -> Check the logs for details.\e[0m"
}

# Function: install_package
# Description: Attempts to install a package and prints a status message. Logs errors
#              to a specified file.
# Usage: install_package "Package Name" "install_command" "error_log_file"
# Parameters:
#   $1 - The name of the package to install
#   $2 - The command that installs the package
#   $3 - The file path for logging errors
install_package() {
  package_name=$1
  install_command=$2
  error_log_file=$3

  print "\e[1;34m" "Installing $package_name"
  if eval $install_command > /dev/null 2>> $error_log_file; then
    print_success $package_name
  else
    print_failed $package_name
  fi
}

run_command() {
  description=$1
  command=$2
  error_log_file=$3

  print "\e[93m" "Starting $description"
  if eval $command > /dev/null 2>> $error_log_file; then
    print_success $description
  else
    print_failed $description
  fi
}