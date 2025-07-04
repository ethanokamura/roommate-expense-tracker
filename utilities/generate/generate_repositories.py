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

SCHEMA_FILE = Path("../data/schema.txt")
REPO_MODEL_MAPPING_FILE = Path("../data/model_map.json")
SCHEMA_KEY_MAPPING_FILE = Path("../data/table_keys.json")
REPOSITORY_SOURCE = Path("../data/repositories.txt")
REPO_TEMPLATE_DIR = Path("../templates/repository_template")
MODEL_TEMPLATE_DIR = Path("../templates/model_template")
# Output root for all generated packages
OUTPUT_PACKAGES_ROOT = ROOT_DIR / "packages"

# --- SQL to Dart Type Mappings ---
SQL_TO_DART_TYPE = {
    'UUID': 'String?',
    'VARCHAR': 'String',
    'TEXT': 'String',
    'BOOLEAN': 'bool',
    'TIMESTAMP': 'DateTime?',
    'DATE': 'DateTime?',
    'DATETIME': 'DateTime?',
    'INTEGER': 'int',
    'INT': 'int',
    'DECIMAL': 'double',
    'ENUM': 'String',
    'JSONB': 'Map<String, dynamic>',
}

DEFAULTS = {
    'UUID': "''",
    'VARCHAR': "''",
    'TEXT': "''",
    'BOOLEAN': 'false',
    'TIMESTAMP': 'DateTime.now().toUtc()',
    'DATE': 'DateTime.now().toUtc()',
    'DATETIME': 'DateTime.now().toUtc()',
    'INTEGER': '0',
    'INT': '0',
    'DECIMAL': '0.0',
    'ENUM': "''",
    'JSONB': 'const {}',
}

# --- Utility Functions ---
def map_sql_type(sql_type):
    base = sql_type.split("(")[0]
    return SQL_TO_DART_TYPE.get(base.upper(), "String")

def default_value(sql_type):
    base = sql_type.split("(")[0].upper()
    return DEFAULTS.get(base, "''")

# --- Jinja2 Environment Setup ---
# Environment for repository templates
repo_env = Environment(
    loader=FileSystemLoader(str(REPO_TEMPLATE_DIR)),
    trim_blocks=True,
    lstrip_blocks=True,
    keep_trailing_newline=True
)
repo_env.filters['dashed'] = utils.dashed
repo_env.filters['snake_to_pascal'] = utils.snake_to_pascal
repo_env.filters['snake_to_camel'] = utils.snake_to_camel

# Environment for model templates
model_env = Environment(
    loader=FileSystemLoader(str(MODEL_TEMPLATE_DIR)),
    autoescape=select_autoescape(['html', 'xml']),
    trim_blocks=True,
    lstrip_blocks=True,
    keep_trailing_newline=True
)
model_env.filters['snake_to_pascal'] = utils.snake_to_pascal

# --- Model Generation Function (Leverages model_env) ---
def generate_dart_class_with_jinja(table_name, fields, import_prefix: str, schema_key_mapping: dict):
    class_name = utils.snake_to_pascal(table_name)
    has_bool = False
    has_datetime = False

    # Get key info for the current table
    # Use .get() with a default empty dict to prevent KeyError if a table somehow isn't in the mapping
    current_table_keys = schema_key_mapping.get(table_name, {"primary": [], "foreign": [], "not_null": [], "unique": []})
    primary_keys = current_table_keys.get("primary", [])
    foreign_keys = current_table_keys.get("foreign", [])
    not_null = current_table_keys.get("not_null", [])
    unique_keys = current_table_keys.get("unique", [])

    processed_fields = []
    for column, sql_type in fields:
        camel_name = utils.snake_to_camel(column)
        dart_type = map_sql_type(sql_type)
        is_nullable = dart_type.endswith('?')
        dart_type_clean = dart_type.replace('?', '')
        default = default_value(sql_type)
        needs_default_in_constructor = not is_nullable and default != ''

        default_value_part = f" = {default}" if needs_default_in_constructor else ''
        default_value_part_colon = f": {default}"
        json_parse_logic = ""
        default_value_json = default

        # ----------------------------------------------------

        if dart_type.startswith("DateTime"):
            has_datetime = True
            json_parse_logic = (
                f"json[{camel_name}Converter] != null\n"
                f"          ? DateTime.tryParse(json[{camel_name}Converter].toString())?.toUtc() ?? {default}\n"
                f"          : {default}"
            )
        elif dart_type == "int":
            json_parse_logic = (
                f"int.tryParse(json[{camel_name}Converter]?.toString() ?? '') ?? {default}"
            )
        elif dart_type == "double":
            json_parse_logic = (
                f"double.tryParse(json[{camel_name}Converter]?.toString() ?? '') ?? {default}"
            )
        elif dart_type == "bool":
            has_bool = True
            json_parse_logic = (
                f"{class_name}._parseBool(json[{camel_name}Converter])"
            )
        elif dart_type == "Map<String, dynamic>":
             json_parse_logic = (
                f"json[{camel_name}Converter] as Map<String, dynamic>? ?? {default}"
            )
        else: # String types
            json_parse_logic = (
                f"json[{camel_name}Converter]?.toString() ?? {default}"
            )

        if is_nullable and default == "''":
            default_value_json = 'null'

        processed_fields.append({
            'header': HEADER,
            'column': column,
            'camel_name': camel_name,
            'dart_type': dart_type,
            'dart_type_clean': dart_type_clean,
            'default_value_part': default_value_part,
            'default_value_part_colon': default_value_part_colon,
            'json_parse_logic': json_parse_logic,
            'default_value_json': default_value_json,
            'is_primary_key': column in primary_keys,
            'is_foreign_key': column in foreign_keys,
            'is_not_null': column in not_null,
            'is_unique_key': column in unique_keys,
            
        })

    template = model_env.get_template('dart_model.dart.jinja')
    return template.render(
        class_name=class_name,
        fields=processed_fields,
        has_bool=has_bool,
        has_datetime=has_datetime,
        import_prefix=import_prefix,
        header=HEADER,
    )

# --- Repository Generation Function (Leverages repo_env) ---
def create_dart_repository_from_template(
    base_repo_name: str,
    output_dir: Path,
    all_tables_schema: dict,
    models_to_generate: list,
    schema_key_mapping: dict,
):
    """
    Creates a new Dart repository package and generates its associated models.

    Args:
        base_repo_name (str): The base name for the new repository (e.g., 'customer').
        output_dir (Path): The directory where the new repository will be created.
        all_tables_schema (dict): The complete parsed schema from schema.txt.
        models_to_generate (list): A list of table names (strings) that belong
                                   to this specific repository.
        schema_key_mapping (dict): The dictionary containing primary and foreign keys for all tables.
    """
    full_repo_folder_name = f'{base_repo_name}_repository' # e.g., 'customer_repository'
    object_name = utils.snake_to_pascal(base_repo_name) # e.g., 'Customer'

    target_repository_path = output_dir / full_repo_folder_name
    target_models_dir = target_repository_path / "lib" / "src" / "models" # Standard model location
    target_lib_dir = target_repository_path / "lib" # Ensure lib directory exists

    repo_exists = target_repository_path.exists()

    repo_render_context = {
        "repository_name": base_repo_name,
        "full_repository_folder_name": full_repo_folder_name,
        "object_name": object_name,
        "models_to_generate": models_to_generate,
        "schema_key_mapping": schema_key_mapping,
        "needs_winery_id": base_repo_name != 'winery'
    }

    if repo_exists:
        print(f"\n--- Repository '{full_repo_folder_name}' already exists. Skipping repository structure generation. ---")
        # Ensure model directory exists even if repo existed, in case it was deleted
        target_models_dir.mkdir(parents=True, exist_ok=True)

    else:
        print(f"\n--- Creating new Repository: '{full_repo_folder_name}' ---")
        target_repository_path.mkdir(parents=True, exist_ok=True)
        target_lib_dir.mkdir(parents=True, exist_ok=True) # Ensure lib directory exists
        target_models_dir.mkdir(parents=True, exist_ok=True) # Ensure models directory exists

        # Helper function for repository template file paths
        def get_repo_target_item_path(item_path: Path) -> Path:
            relative_path = item_path.relative_to(REPO_TEMPLATE_DIR)
            processed_components = []
            for component in relative_path.parts:
                if component == "_repository_name_":
                    processed_components.append(full_repo_folder_name)
                elif component == "_repository_name_.dart.jinja":
                    processed_components.append(f"{full_repo_folder_name}.dart")
                elif '{{' in component and '}}' in component:
                    processed_component = component
                    for key, value in repo_render_context.items():
                        processed_component = processed_component.replace(f'{{{{ {key} }}}}', str(value))
                    processed_components.append(processed_component)
                else:
                    processed_components.append(component)

            final_relative_path = Path(*processed_components)
            if final_relative_path.suffix == '.jinja':
                final_relative_path = final_relative_path.with_suffix('')
            return target_repository_path / final_relative_path

        # Walk through the repository template directory and render its files
        for root, dirs, files in REPO_TEMPLATE_DIR.walk():
            current_root_path = Path(root)

            # Create subdirectories in the target repository
            for dir_name in list(dirs):
                template_dir_path = current_root_path / dir_name
                target_dir_path = get_repo_target_item_path(template_dir_path)
                if not target_dir_path.exists():
                    target_dir_path.mkdir(parents=True, exist_ok=True)

            # Process files in the current directory
            for file_name in files:
                source_file_path = current_root_path / file_name
                target_file_path = get_repo_target_item_path(source_file_path)

                # Skip models directory in template, as we'll generate those dynamically
                if "lib/src/models" in str(source_file_path.relative_to(REPO_TEMPLATE_DIR)):
                    continue # Skip files in the template's models dir, we generate these below

                target_file_path.parent.mkdir(parents=True, exist_ok=True)

                if file_name.endswith(".jinja"):
                    relative_template_path = source_file_path.relative_to(REPO_TEMPLATE_DIR)
                    template = repo_env.get_template(str(relative_template_path))
                    rendered_content = template.render(repo_render_context)
                    target_file_path.write_text(rendered_content)
                else:
                    shutil.copy2(source_file_path, target_file_path)

        print(f"  Base repository structure created for '{full_repo_folder_name}'.")

    # --- Delete all existing models before regenerating ---
    print(f"  Cleaning existing models in '{target_models_dir}'...")
    for item in target_models_dir.iterdir():
        if item.is_file() and item.suffix == ".dart": # Only delete .dart files
            item.unlink()
            print(f"    - Deleted: {item.name}")
    print("  Finished cleaning existing models.")

    # --- Always Generate/Overwrite Models for this specific repository ---
    print(f"  Generating/overwriting models for '{full_repo_folder_name}':")
    model_import_prefix = f'package:app_core/app_core.dart'

    for table_name in models_to_generate:
        if table_name in all_tables_schema:
            try:
                dart_code = generate_dart_class_with_jinja(table_name, all_tables_schema[table_name], import_prefix=model_import_prefix, schema_key_mapping=schema_key_mapping)
                model_file_path = target_models_dir / f"{table_name}.dart"
                model_file_path.write_text(dart_code) # This will overwrite if file exists
                print(f"    - Generated/Overwrote model: {utils.snake_to_pascal(table_name)}.dart")
            except Exception as e:
                print(f"    - Error generating model '{table_name}': {e}")
        else:
            print(f"    - Warning: Model '{table_name}' from mapping not found in schema.txt. Skipping.")

    print(f"  Finished model generation for '{full_repo_folder_name}'.")
    return target_repository_path

# --- Main Execution ---
if __name__ == "__main__":
    print("--- Dart Repository and Model Generator ---")
    print(f"Schema file: {SCHEMA_FILE.resolve()}")
    print(f"Mapping file: {REPO_MODEL_MAPPING_FILE.resolve()}")
    print(f"Schema Key Mapping file: {SCHEMA_KEY_MAPPING_FILE.resolve()}")
    print(f"Repository template: {REPO_TEMPLATE_DIR.resolve()}")
    print(f"Model template: {MODEL_TEMPLATE_DIR.resolve()}")
    print(f"Output root for packages: {OUTPUT_PACKAGES_ROOT.resolve()}")
    print("-" * 50)

    try:
        all_tables_schema = utils.read_schema(SCHEMA_FILE)
        if not all_tables_schema:
            print(f"No tables found in '{SCHEMA_FILE}'. Exiting.")
            exit(1)
        print(f"Loaded schema with {len(all_tables_schema)} tables.")

        repo_model_mapping = utils.read_json(REPO_MODEL_MAPPING_FILE)
        if not repo_model_mapping:
            print(f"No repository-model mapping found in '{REPO_MODEL_MAPPING_FILE}'. Exiting.")
            exit(1)
        print(f"Loaded mapping for {len(repo_model_mapping)} repositories.")

        schema_key_mapping = utils.read_json(SCHEMA_KEY_MAPPING_FILE)
        if not schema_key_mapping:
            print(f"No schema key mapping found in '{SCHEMA_KEY_MAPPING_FILE}'. Exiting.")
            exit(1)
        print(f"Loaded schema key mapping for {len(schema_key_mapping)} tables.")

        OUTPUT_PACKAGES_ROOT.mkdir(parents=True, exist_ok=True)
        print(f"Ensured output directory '{OUTPUT_PACKAGES_ROOT}' exists.")

        created_repo_paths = []
        for repo_base_name, table_names_for_repo in repo_model_mapping.items():
            try:
                path = create_dart_repository_from_template(
                    base_repo_name=repo_base_name,
                    output_dir=OUTPUT_PACKAGES_ROOT,
                    all_tables_schema=all_tables_schema,
                    models_to_generate=table_names_for_repo,
                    schema_key_mapping=schema_key_mapping,
                )
                if path:
                    created_repo_paths.append(path)
            except Exception as e:
                print(f"Error processing repository '{repo_base_name}': {e}")

        print("\n--- Post-Creation Steps ---")
        if created_repo_paths:
            for repo_path in created_repo_paths:
                print(f"\nProcessing '{repo_path.name}'...")
                utils.run_flutter_pub_get(repo_path)
                utils.format_dart_files(repo_path)
        else:
            print("No new repositories were created/processed.")

        print("\n--- All operations complete! ---")
        print(f"Repositories created in: {OUTPUT_PACKAGES_ROOT}")

    except FileNotFoundError as e:
        print(f"Error: Required file not found - {e.filename}")
        exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON mapping file: {e}")
        exit(1)
    except Exception as e:
        print(f"An unexpected error occurred during execution: {e}")
        exit(1)