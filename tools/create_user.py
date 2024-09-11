from label_studio_sdk.client import LabelStudio


label_studio_host = "http://localhost:8080"
admin_api_key = "e6d5a079d1d37809abffa6f00f31b468faac0a23"

client = LabelStudio(
    base_url=label_studio_host,
    api_key=admin_api_key,
)

# Create a new user
client.users.create(username="user1", email="user1@gmail.com")
