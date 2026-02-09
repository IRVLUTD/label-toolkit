from pathlib import Path
import json
from label_toolkit.utils import PROJ_ROOT


def setup_env(confg_json_file):
    with open(confg_json_file, "r") as f:
        config = json.load(f)

    env = f"""# Docker environment variables
PROJ_DIR={PROJ_ROOT}
LABEL_STUDIO_HOST=http://label-studio:{config['label_studio_bind_port']}
LABEL_STUDIO_USERNAME={config['label_studio_username']}
LABEL_STUDIO_PASSWORD={config['label_studio_password']}
LABEL_STUDIO_USER_TOKEN={config['label_studio_user_token']}
LABEL_STUDIO_IMAGE={config['label_studio_image']}
LABEL_STUDIO_DATA_DIR={config['label_studio_data_dir']}
LABEL_STUDIO_FILES_DIR={config['label_studio_files_dir']}
LABEL_STUDIO_BIND_PORT={config['label_studio_bind_port']}
ML_BACKEND_SAM1_MODEL_PATH={config['ml_backend_sam1_model_path']}
ML_BACKEND_SAM2_IMAGE_MODEL_PATH={config['ml_backend_sam2_image_model_path']}
ML_BACKEND_MODEL_SERVER_DIR={config['ml_backend_model_server_dir']}
ML_BACKEND_BIND_PORT={config['ml_backend_model_bind_port']}
SAM_CHOICE={config['sam_choice']}
LOG_LEVEL={config['log_level']}
"""
    env_file = PROJ_ROOT / ".env"
    env_file.write_text(env)


if __name__ == "__main__":
    config_json_path = PROJ_ROOT / "config.json"
    setup_env(config_json_path)
