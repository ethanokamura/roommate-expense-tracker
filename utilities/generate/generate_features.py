import shutil
import json
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, select_autoescape
import sys
import os

# Adjust sys.path to find utils.py in the common directory
current_dir = os.path.dirname(os.path.abspath(__file__))
parent_dir = os.path.join(current_dir, '..', 'common')
sys.path.append(parent_dir)

import utils # Assuming utils.py contains snake_to_pascal, snake_to_camel, read_schema, read_json, run_flutter_pub_get, format_dart_files

HEADER = utils.generate_header()

# --- Configuration Paths ---
ROOT_DIR = Path("../../frontend/roommate_expense_tracker")

# Input data files (reusing from repository script)
REPO_MODEL_MAPPING_FILE = Path("../data/model_map.json")
SCHEMA_KEY_MAPPING_FILE = Path("../data/table_keys.json")

# Feature template directory (as shown in your screenshot)
FEATURE_TEMPLATE_DIR = Path("../templates/feature_template")

# Output root for all generated packages (reusing from repository script)
OUTPUT_PACKAGES_ROOT = ROOT_DIR / "lib" / "features"

# --- Jinja2 Environment Setup ---
feature_env = Environment(
    loader=FileSystemLoader(str(FEATURE_TEMPLATE_DIR)),
    trim_blocks=True,
    lstrip_blocks=True,
    keep_trailing_newline=True # Important for consistent Dart formatting
)
feature_env.filters['snake_to_pascal'] = utils.snake_to_pascal
feature_env.filters['snake_to_camel'] = utils.snake_to_camel

# --- Feature Generation Function ---
def create_dart_feature_from_template(
    feature_base_name: str,
    output_dir: Path,
    models_for_feature: list,
    schema_key_mapping: dict,
):
    """
    Creates a new Dart feature package and generates its associated cubits and states.

    Args:
        feature_base_name (str): The base name for the new feature (e.g., 'customer').
        output_dir (Path): The root directory where the new feature package will be created.
        models_for_feature (list): A list of table names (strings) that are relevant
                                   to this specific feature's cubit and state.
        schema_key_mapping (dict): The dictionary containing primary and foreign keys for all tables.
    """
    full_feature_folder_name = feature_base_name # e.g., 'customer_feature'
    feature_object_name = utils.snake_to_pascal(feature_base_name) # e.g., 'CustomerFeature'

    target_feature_path = output_dir / full_feature_folder_name
    
    # Determine if this feature needs 'wineryId' based on its associated models
    needs_winery_id = False
    for model in models_for_feature:
        model_keys = schema_key_mapping.get(model, {})

    feature_render_context = {
        "feature": feature_base_name,
        "feature_pascal": feature_object_name,
        "feature_camel": utils.snake_to_camel(feature_base_name),
        "full_feature_folder_name": full_feature_folder_name,
        "object_name": feature_object_name,
        "models_to_generate": models_for_feature,
        "schema_key_mapping": schema_key_mapping,
        "needs_winery_id": needs_winery_id,
        "header": HEADER,
    }

    if target_feature_path.exists():
        print(f"\n--- Feature '{full_feature_folder_name}' already exists. Skipping structure generation. ---")
        # Ensure subdirectories exist for rendering templates in place
        (target_feature_path / "cubit").mkdir(parents=True, exist_ok=True)
        (target_feature_path / "page_data").mkdir(parents=True, exist_ok=True)
        (target_feature_path / "pages").mkdir(parents=True, exist_ok=True)
        (target_feature_path / "widgets").mkdir(parents=True, exist_ok=True)
    else:
        print(f"\n--- Creating new Feature: '{full_feature_folder_name}' ---")
        target_feature_path.mkdir(parents=True, exist_ok=True)

        # Helper function for feature template file paths
        def get_feature_target_item_path(item_path: Path) -> Path:
            relative_path = item_path.relative_to(FEATURE_TEMPLATE_DIR)
            processed_components = []
            for component in relative_path.parts:
                if component == "_feature_name_": # For the root lib file or pubspec.yaml if named that way
                    processed_components.append(f"{feature_base_name}")
                elif component == "pubspec.yaml.jinja": # Handle explicit pubspec.yaml template
                    processed_components.append("pubspec.yaml")
                elif component.endswith(".jinja"): # General case for .jinja files
                    # Replace {{ feature }} in component name itself before suffix removal
                    processed_component_name = component.replace("{{ feature }}", feature_base_name)
                    processed_components.append(Path(processed_component_name).with_suffix('').name) # Remove .jinja suffix
                elif '{{' in component and '}}' in component: # For folder names with jinja vars
                    processed_component = component
                    for key, value in feature_render_context.items():
                        # Only replace keys present in context and ensure it's a string
                        processed_component = processed_component.replace(f'{{{{ {key} }}}}', str(value))
                    processed_components.append(processed_component)
                else:
                    processed_components.append(component)

            final_relative_path = Path(*processed_components)
            return target_feature_path / final_relative_path

        # Walk through the feature template directory and render its files
        for root, dirs, files in FEATURE_TEMPLATE_DIR.walk():
            current_root_path = Path(root)

            # Create subdirectories in the target feature
            for dir_name in list(dirs):
                template_dir_path = current_root_path / dir_name
                target_dir_path = get_feature_target_item_path(template_dir_path)
                if not target_dir_path.exists():
                    target_dir_path.mkdir(parents=True, exist_ok=True)

            # Process files in the current directory
            for file_name in files:
                source_file_path = current_root_path / file_name
                target_file_path = get_feature_target_item_path(source_file_path)

                target_file_path.parent.mkdir(parents=True, exist_ok=True) # Ensure target's parent directory exists

                if file_name.endswith(".jinja"):
                    # For files that are templates, render them
                    relative_template_path = source_file_path.relative_to(FEATURE_TEMPLATE_DIR)
                    template = feature_env.get_template(str(relative_template_path))
                    rendered_content = template.render(feature_render_context)
                    target_file_path.write_text(rendered_content)
                else:
                    # For static files, just copy them
                    shutil.copy2(source_file_path, target_file_path)

        print(f"  Base feature structure created for '{full_feature_folder_name}'.")
    
    # Always regenerate cubit and state for safety and updates
    print(f"  Regenerating cubit and state for '{full_feature_folder_name}':")
    
    # Cubit file
    cubit_template_path = "cubit/{{ feature }}_cubit.dart.jinja"
    cubit_output_path = target_feature_path / "cubit" / f"{feature_base_name}_cubit.dart"
    cubit_output_path.parent.mkdir(parents=True, exist_ok=True) # Ensure cubit directory exists
    cubit_template = feature_env.get_template(cubit_template_path)
    rendered_cubit = cubit_template.render(feature_render_context)
    cubit_output_path.write_text(rendered_cubit)
    print(f"    - Generated/Overwrote cubit: {cubit_output_path.name}")

    # State file
    state_template_path = "cubit/{{ feature }}_state.dart.jinja"
    state_output_path = target_feature_path / "cubit" / f"{feature_base_name}_state.dart"
    state_output_path.parent.mkdir(parents=True, exist_ok=True) # Ensure cubit directory exists
    state_template = feature_env.get_template(state_template_path)
    rendered_state = state_template.render(feature_render_context)
    state_output_path.write_text(rendered_state)
    print(f"    - Generated/Overwrote state: {state_output_path.name}")

    print(f"  Finished cubit and state generation for '{full_feature_folder_name}'.")
    return target_feature_path

# --- Main Execution ---
if __name__ == "__main__":
    print("--- Dart Feature Generator ---")
    print(f"Repository-Model mapping file: {REPO_MODEL_MAPPING_FILE.resolve()}")
    print(f"Schema Key Mapping file: {SCHEMA_KEY_MAPPING_FILE.resolve()}")
    print(f"Feature template: {FEATURE_TEMPLATE_DIR.resolve()}")
    print(f"Output root for packages: {OUTPUT_PACKAGES_ROOT.resolve()}")
    print("-" * 50)

    try:
        repo_model_mapping = utils.read_json(REPO_MODEL_MAPPING_FILE)
        if not repo_model_mapping:
            print(f"No repository-model mapping found in '{REPO_MODEL_MAPPING_FILE}'. Exiting.")
            exit(1)
        print(f"Loaded mapping for {len(repo_model_mapping)} repositories/features.")

        schema_key_mapping = utils.read_json(SCHEMA_KEY_MAPPING_FILE)
        if not schema_key_mapping:
            print(f"No schema key mapping found in '{SCHEMA_KEY_MAPPING_FILE}'. Exiting.")
            exit(1)
        print(f"Loaded schema key mapping for {len(schema_key_mapping)} tables.")

        OUTPUT_PACKAGES_ROOT.mkdir(parents=True, exist_ok=True)
        print(f"Ensured output directory '{OUTPUT_PACKAGES_ROOT}' exists.")

        created_feature_paths = []
        # Iterate through repository mappings to determine which features to create
        # Assuming each repository corresponds to a feature of the same base name.
        for feature_base_name, models_for_feature in repo_model_mapping.items():
            try:
                print(f"Processing feature '{feature_base_name}'...")
                path = create_dart_feature_from_template(
                    feature_base_name=feature_base_name,
                    output_dir=OUTPUT_PACKAGES_ROOT,
                    models_for_feature=models_for_feature,
                    schema_key_mapping=schema_key_mapping,
                )
                if path:
                    created_feature_paths.append(path)
            except Exception as e:
                print(f"Error processing feature '{feature_base_name}': {e}")

        print("\n--- Post-Creation Steps ---")
        if created_feature_paths:
            for feature_path in created_feature_paths:
                print(f"\nProcessing '{feature_path.name}'...")
                utils.run_flutter_pub_get(feature_path)
                utils.format_dart_files(feature_path)
        else:
            print("No new features were created/processed.")

        print("\n--- All operations complete! ---")
        print(f"Features created in: {OUTPUT_PACKAGES_ROOT}")

    except FileNotFoundError as e:
        print(f"Error: Required file not found - {e.filename}")
        exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON mapping file: {e}")
        exit(1)
    except Exception as e:
        print(f"An unexpected error occurred during execution: {e}")
        exit(1)

