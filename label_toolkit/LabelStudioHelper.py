from label_studio_sdk.client import LabelStudio
from .Utils import *


class LabelStudioHelper:
    def __init__(self):
        self._logger = get_logger("LabelStudioHelper")
        self._config = read_data_from_json(PROJ_ROOT / "config" / "config.json")
        self._client = LabelStudio(
            base_url=self._config["label_studio_url"],
            api_key=self._config["label_studio_access_token"],
        )

        self._updaate_users_info()

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
