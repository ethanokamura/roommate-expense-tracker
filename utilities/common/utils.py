import json
from collections import defaultdict
from pathlib import Path
import subprocess

from datetime import datetime

# --- Utility Functions ---

def generate_header():
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')
    header = f"""\
////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                           PERFECT LINE LLC                             //
//                                                                        //
//           THIS FILE IS AUTO-GENERATED. DO NOT EDIT MANUALLY.           //
//                                                                        //
//  Any changes to this file will be overwritten the next time the code   //
//  is regenerated. If you need to modify behavior, update the source     //
//                         template instead.                              //
//                                                                        //
//                Generated on: {timestamp}                   //
//                                                                        //
////////////////////////////////////////////////////////////////////////////

"""
    return header

def generate_pound_header():
    timestamp = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S UTC')
    header = f"""\
############################################################################
##                                                                        ##
##                           PERFECT LINE LLC                             ##
##                                                                        ##
##           THIS FILE IS AUTO-GENERATED. DO NOT EDIT MANUALLY.           ##
##                                                                        ##
##  Any changes to this file will be overwritten the next time the code   ##
##  is regenerated. If you need to modify behavior, update the source     ##
##                         template instead.                              ##
##                                                                        ##
##                Generated on: {timestamp}                   ##
##                                                                        ##
############################################################################

"""
    return header


def snake_to_camel(snake_str):
    parts = snake_str.split('_')
    return parts[0] + ''.join(word.capitalize() for word in parts[1:])

def snake_to_pascal(snake_str):
    """Converts snake_case to PascalCase (e.g., 'user_name' -> 'UserName')."""
    return ''.join(word.capitalize() for word in snake_str.split('_'))

def dashed(snake_str):
    """Converts snake_case to PascalCase (e.g., 'user_name' -> 'UserName')."""
    return snake_str.replace('_', '-')

def read_json(file_path):
    with open(file_path, 'r') as f:
        return json.load(f)

def read_schema(file_path):
    tables = defaultdict(list)
    with open(file_path, 'r') as f:
        for line in f:
            parts = line.strip().split('\t')
            if len(parts) == 3:
              table, column, col_type = parts
              tables[table].append((column, col_type))
            elif len(parts) == 4:
              table, column, col_type, key = parts
              tables[table].append((column, col_type))
            else:
              continue
    return tables

def format_dart_files(target_dir_or_file: Path):
    """Runs 'dart format' on Dart files in the specified path."""
    print(f"Attempting to format Dart files in {target_dir_or_file}...")
    try:
        # 'dart format' works on directories or individual files
        result = subprocess.run(["dart", "format", target_dir_or_file], capture_output=True, text=True, check=True)
        print("Dart files formatted successfully.")
        # print(result.stdout) # Uncomment for verbose output if needed
    except subprocess.CalledProcessError as e:
        print(f"Error formatting Dart files for {target_dir_or_file}. Return code: {e.returncode}")
        # print(f"STDOUT: {e.stdout}") # Uncomment for verbose error output
        # print(f"STDERR: {e.stderr}") # Uncomment for verbose error output
        print("Please ensure the Dart SDK is installed and 'dart' is in your system's PATH.")
    except FileNotFoundError:
        print("Error: 'dart' command not found. Ensure Dart SDK is in PATH.")

def run_flutter_pub_get(repository_path: Path):
    """Runs 'flutter pub get' in the new repository directory."""
    print(f"Running 'flutter pub get' in {repository_path}...")
    try:
        if (repository_path / "pubspec.yaml").exists():
            result = subprocess.run(["flutter", "pub", "get"], cwd=repository_path, capture_output=True, text=True, check=True)
            print("flutter pub get completed successfully.")
            # print(result.stdout) # Uncomment for verbose output if needed
        else:
            print(f"No pubspec.yaml found in {repository_path}. Skipping 'flutter pub get'.")
    except subprocess.CalledProcessError as e:
        print(f"Error running 'flutter pub get' for {repository_path}. Return code: {e.returncode}")
        # print(f"STDOUT: {e.stdout}") # Uncomment for verbose error output
        # print(f"STDERR: {e.stderr}") # Uncomment for verbose error output
        print("Please ensure Flutter SDK is installed and 'flutter' is in your system's PATH.")
    except FileNotFoundError:
        print("Error: 'flutter' command not found. Ensure Flutter SDK is in PATH.")

def run_command(command: list, cwd: Path | None = None, check: bool = True, capture_output: bool = False) -> subprocess.CompletedProcess:
    """
    Runs an external command using subprocess.

    Args:
        command (list[]): The command and its arguments as a list of strings.
        cwd (Path | None): The current working directory for the command.
                           If None, the current process's working directory is used.
        check (bool): If True, raise a CalledProcessError if the command returns a non-zero exit code.
        capture_output (bool): If True, capture stdout and stderr in the returned object.

    Returns:
        subprocess.CompletedProcess: An object containing information about the completed process.

    Raises:
        subprocess.CalledProcessError: If check is True and the command returns a non-zero exit code.
        FileNotFoundError: If the command (first item in 'command') is not found.
    """
    print(f"Executing command: {' '.join(command)}")
    try:
        result = subprocess.run(
            command,
            cwd=cwd if cwd else None,
            capture_output=capture_output,
            text=True, # Decode stdout/stderr as text
            check=check
        )
        if capture_output:
            print(f"STDOUT:\n{result.stdout}")
            if result.stderr:
                print(f"STDERR:\n{result.stderr}")
        return result
    except FileNotFoundError:
        raise FileNotFoundError(f"Command not found: '{command[0]}'. Please ensure it's installed and in your system's PATH.")
    except subprocess.CalledProcessError as e:
        print(f"Command '{' '.join(command)}' failed with exit code {e.returncode}")
        if e.stdout:
            print(f"STDOUT:\n{e.stdout}")
        if e.stderr:
            print(f"STDERR:\n{e.stderr}")
        raise # Re-raise the exception after printing details