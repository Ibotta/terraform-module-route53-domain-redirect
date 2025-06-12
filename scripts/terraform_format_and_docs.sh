#!/usr/bin/env bash

set -euo pipefail

function install_mise() {
  if ! command -v mise &> /dev/null; then
    echo "Installing mise..."
    curl -fsSL https://mise.run | sh
    # Source mise for current session
    export PATH="$HOME/.local/bin:$PATH"
    eval "$(mise activate bash)"
  fi
}

function install_tools() {
  echo "Installing Terraform..."
  mise install terraform || { echo "ERROR: Failed to install Terraform" >&2; exit 1; }
  
  echo "Installing Terraform Docs..."
  mise install terraform-docs || { echo "ERROR: Failed to install terraform-docs" >&2; exit 1; }
}

function format_and_generate() {
  # Change to project root
  cd "$(git rev-parse --show-toplevel 2>/dev/null || dirname "${BASH_SOURCE[0]}")/"
  
  echo "Formatting Terraform code..."
  terraform fmt -recursive .
  
  if [[ -f docs-header.md ]]; then
    echo "Generating documentation..."
    local base_dir
    base_dir="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
    terraform-docs -c "${base_dir}/.terraform-docs.yml" . > README.md
  else
    echo "Skipping documentation generation: no 'docs-header.md' found"
  fi
}

function check_git_status() {
  echo
  echo "=============================================="
  echo "Terraform format and docs generation complete!"
  echo "Results can be seen below."
  echo "=============================================="
  echo
  
  if git status --porcelain | grep -q .; then
    echo "===================================================================="
    echo "ERROR: Terraform files are not formatted or docs are not up to date!"
    echo "Below is the output of 'git status'. Any 'modified' files indicate"
    echo "that formatting or documentation changes were made."
    echo "===================================================================="
    echo
    git --no-pager diff
    git status
    return 1
  else
    echo "========================================================"
    echo "SUCCESS: Terraform is formatted and docs are up to date."
    echo "========================================================"
    return 0
  fi
}

function main() {
  install_mise
  install_tools
  
  # Disable exit on error for the format/generate phase
  # We want to check git status regardless of success/failure
  set +e
  format_and_generate
  local format_status=$?
  set -e
  
  if [[ ${format_status} -eq 0 ]]; then
    # Format/generate succeeded, check if there are changes
    if ! check_git_status; then
      exit 1
    fi
  else
    # Format/generate failed
    echo "==================================================="
    echo "ERROR: Failed to format or generate documentation"
    echo "See error messages above for details."
    echo "==================================================="
    echo
    git --no-pager diff
    git status
    exit 1
  fi
}

# Only run main if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi