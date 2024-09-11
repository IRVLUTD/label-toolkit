import time
from attr import fields
from label_studio_sdk.client import LabelStudio
from .utils import *


class LabelStudioHelper:
    def __init__(self):
        self._logger = get_logger("LabelStudioHelper")
        self._config = read_data_from_json(PROJ_ROOT / "config" / "config.json")
        self._client = LabelStudio(
            base_url=self._config["label_studio_url"],
            api_key=self._config["label_studio_access_token"],
        )

        self._updaate_users_info()
        self._update_projects_info()

    def add_user(self, email: str, overwrite: bool = False):
        if email in self._users_info:
            if overwrite:
                self._client.users.delete(id=self._users_info[email]["id"])
            else:
                self._logger.info(f"User {email} already exists.")
                return
        self._client.users.create(username=email.split("@")[0], email=email)

        self._updaate_users_info()

        self._logger.info(
            f"User [username: {email.split('@')[0]}, email: {email}] created successfully."
        )

    def add_project(
        self,
        title: str,
        description: str = None,
        label_config: str = "<View></View>",
        overwrite: bool = False,
    ):
        if title in self._projects_info:
            if overwrite:
                self._client.projects.delete(id=self._projects_info[title]["id"])
            else:
                self._logger.info(f"Project {title} already exists.")
                return
        self._client.projects.create(
            title=title, description=description, label_config=label_config
        )

        self._update_projects_info()

        self._logger.info(f"Project {title} created successfully.")

    def add_ml_backend(
        self,
        project_title: str,
        ml_title: str,
        ml_url: str,
        ml_is_interactive: bool = False,
    ):
        project_id = self._projects_info[project_title]["id"]
        self._client.ml.create(
            project=project_id,
            title=ml_title,
            url=ml_url,
            is_interactive=ml_is_interactive,
        )

        self._logger.info(f"ML backend {ml_title} created successfully.")

    def add_local_storage(
        self,
        project_title: str,
        storage_title: str,
        storage_path: str,
        use_blob_urls: bool = False,
        regex_filter: str = None,
    ):
        project_id = self._projects_info[project_title]["id"]
        self._client.import_storage.local.create(
            project=project_id,
            title=storage_title,
            path=storage_path,
            use_blob_urls=use_blob_urls,
            regex_filter=regex_filter,
        )

        self._logger.info(f"Local storage {storage_title} created successfully.")

    def export_annotations_by_project(self, project_title: str):
        project_id = self._projects_info[project_title]["id"]
        export = self._client.projects.exports.create_export(
            id=project_id, export_type="JSON"
        )
        annotation = b""
        for data in export:
            annotation += data

        annotation = annotation.decode("utf-8")

        save_json_file = PROJ_ROOT / "data" / f"{project_title}.json"
        save_json_file.write_text(annotation, encoding="utf-8")

        return json.loads(annotation)

    def _updaate_users_info(self):
        users = self._client.users.list()
        self._users_info = {
            user.email: {
                "id": user.id,
                "username": user.username,
                "email": user.email,
            }
            for user in users
        }
        write_data_to_json(self._users_info, PROJ_ROOT / "config" / "users_info.json")
        self._logger.debug("Users info updated.")

    def _update_projects_info(self):
        projects = self._client.projects.list()
        self._projects_info = {
            project.title: {
                "id": project.id,
                "title": project.title,
                "description": project.description,
            }
            for project in projects
        }

        print(self._projects_info)
