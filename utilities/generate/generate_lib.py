import shutil
import json
from collections import defaultdict
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, select_autoescape
import sys
import os

current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.join(current_dir, '..', 'common')
sys.path.append(parent_dir)

import utils

HEADER = utils.generate_header()

# --- Configuration Paths ---
ROOT_DIR = Path("../../frontend/roommate_expense_tracker")
REPOSITORY_SOURCE = Path("../data/repositories.txt")
# Lib paths
LIB_DIR = ROOT_DIR / "lib"
APP_FILE = LIB_DIR / "app" / "view" / "app.dart"
MAIN_FILE = LIB_DIR / "main.dart"
DI_SETUP_FILE = LIB_DIR / "config" / "di_setup.dart"
ROOT_PUBSPEC_FILE = ROOT_DIR / "pubspec.yaml"
FAILURE_DIR = LIB_DIR / "features" / "failures"
LIB_UPDATE_TEMPLATE_DIR = Path("../templates/lib_templates")

# New Jinja environment for lib file updates
lib_env = Environment(
    loader=FileSystemLoader(LIB_UPDATE_TEMPLATE_DIR),
    trim_blocks=True,
    lstrip_blocks=True,
    keep_trailing_newline=True
)
lib_env.filters['snake_to_pascal'] = utils.snake_to_pascal
lib_env.filters['snake_to_camel'] = utils.snake_to_camel

def read_repositories(filepath):
    """Reads repository names from a text file, one per line."""
    try:
        with open(filepath, 'r') as f:
            return [line.strip() for line in f if line.strip()]
    except FileNotFoundError:
        print(f"Error: Repository source file not found at {filepath}")
        return []

def generate_app_file(repositories: list, output_path: Path):
    """Generates app.dart using a Jinja template."""
    output_path.parent.mkdir(parents=True, exist_ok=True) # Ensure parent directories exist
    template = lib_env.get_template('app.dart.jinja')
    rendered_content = template.render(
      repositories=repositories,
      header=HEADER,
    )
    output_path.write_text(rendered_content)
    print(f"Generated: {output_path.relative_to(LIB_DIR)}")

def generate_main_file(repositories: list, output_path: Path):
    """Generates main.dart using a Jinja template."""
    output_path.parent.mkdir(parents=True, exist_ok=True) # Ensure parent directories exist
    template = lib_env.get_template('main.dart.jinja')
    rendered_content = template.render(
      repositories=repositories,
      header=HEADER,
    )
    output_path.write_text(rendered_content)
    print(f"Generated: {output_path.relative_to(LIB_DIR)}")

def generate_di_setup_file(repositories: list, output_path: Path):
    """Generates main.dart using a Jinja template."""
    output_path.parent.mkdir(parents=True, exist_ok=True) # Ensure parent directories exist
    template = lib_env.get_template('di_setup.dart.jinja')
    rendered_content = template.render(
      repositories=repositories,
      header=HEADER,
    )
    output_path.write_text(rendered_content)
    print(f"Generated: {output_path.relative_to(LIB_DIR)}")


def generate_root_pubspec_file(repositories: list, output_path: Path):
    """Generates pubspec.yaml using a Jinja template."""
    output_path.parent.mkdir(parents=True, exist_ok=True) # Ensure parent directories exist
    template = lib_env.get_template('pubspec.yaml.jinja')
    rendered_content = template.render(
      header=utils.generate_pound_header(),
      repositories=repositories,
    )
    output_path.write_text(rendered_content)
    print(f"Generated: {output_path.relative_to(ROOT_DIR)}")

def generate_failure_files(repositories: list, output_dir: Path):
    """Generates individual failure files for each repository."""
    output_dir.mkdir(parents=True, exist_ok=True) # Ensure the failure directory exists
    print(f"\n--- Generating failure files in {output_dir.relative_to(LIB_DIR)} ---")
    for repository in repositories:
        template = lib_env.get_template('failures.dart.jinja')
        rendered_content = template.render(
          repository=repository,
          header=HEADER,
        )
        failure_file_name = f'{repository}_failures.dart' # e.g., customer_failures.dart
        failure_file_path = output_dir / failure_file_name
        failure_file_path.write_text(rendered_content)
        print(f"Generated: {failure_file_path.relative_to(LIB_DIR)}")



# --- Main Execution ---
if __name__ == "__main__":
    print("\n" + "="*50)
    print("--- Dart Lib File Updates ---")
    print(f"Repository source: {REPOSITORY_SOURCE.resolve()}")
    print(f"App file target: {APP_FILE.resolve()}")
    print(f"Main file target: {MAIN_FILE.resolve()}")
    print(f"DI Setup file target: {DI_SETUP_FILE.resolve()}")
    print(f"Failure directory target: {FAILURE_DIR.resolve()}")
    print("="*50)
    try:
        # --- Part 2: Update Lib Files ---
        updated_repos = read_repositories(REPOSITORY_SOURCE)
        if not updated_repos:
            print(f"No repositories found in '{REPOSITORY_SOURCE}' for lib updates. Skipping lib file generation.")
        else:
            print(f"Loaded {len(updated_repos)} repositories for lib updates: {', '.join(updated_repos)}")
            # Generate app.dart
            generate_app_file(updated_repos, APP_FILE)

            # Generate main.dart
            generate_main_file(updated_repos, MAIN_FILE)

            # Generate main.dart
            generate_di_setup_file(updated_repos, DI_SETUP_FILE)

            # Generate failure files
            generate_failure_files(updated_repos, FAILURE_DIR)

            # Generate pubspec file
            generate_root_pubspec_file(updated_repos, ROOT_PUBSPEC_FILE)
            print("\n--- All lib file updates complete! ---")
            utils.run_flutter_pub_get("../../frontend/roommate_expense_tracker")

            utils.run_flutter_pub_get(ROOT_DIR)
            utils.format_dart_files(ROOT_DIR)

    except FileNotFoundError as e:
        print(f"Error: Required file not found - {e.filename}")
        exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON mapping file: {e}")
        exit(1)
    except Exception as e:
        print(f"An unexpected error occurred during execution: {e}")
        exit(1)