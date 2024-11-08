import argparse
from pathlib import Path
from label_toolkit.utils import PROJ_ROOT, read_data_from_json
from label_toolkit.utils import generate_random_color
from label_toolkit.LabelStudioHelper import LabelStudioHelper


def generate_label_interface(label_names):
    """Generate a dynamic Label Studio interface with BrushLabels, KeypointLabels, and RectangleLabels."""
    template = """<View>
    <Image name="image" value="$image" zoom="true"/>

    <Header value="Brush Labels"/>
    <BrushLabels name="brushTag" toName="image">
      {brush_labels}
    </BrushLabels>

    <Header value="Keypoint Labels"/>
    <KeyPointLabels name="keypointTag" toName="image" smart="true">
      {keypoint_labels}
    </KeyPointLabels>

    <Header value="Rectangle Labels"/>
    <RectangleLabels name="rectangleTag" toName="image" smart="true">
      {rectangle_labels}
    </RectangleLabels>

    <TextArea name="referring" toName="image" editable="true" perRegion="true" required="true"
              maxSubmissions="1" rows="5" placeholder="Referring Expression" displayMode="region-list"/>
    </View>"""

    brush_labels = []
    keypoint_labels = []
    rectangle_labels = []

    for label in label_names:
        color = generate_random_color()
        brush_labels.append(f'<Label value="{label}" background="{color}"/>')
        keypoint_labels.append(
            f'<Label value="{label}" background="{color}" showInline="true"/>'
        )
        rectangle_labels.append(
            f'<Label value="{label}" background="{color}" showInline="true"/>'
        )

    return template.format(
        brush_labels="\n      ".join(brush_labels),
        keypoint_labels="\n      ".join(keypoint_labels),
        rectangle_labels="\n      ".join(rectangle_labels),
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser("Add projects to Label Studio")
    parser.add_argument(
        "--scene_folder", type=str, default=None, help="Secene folder path"
    )
    parser.add_argument(
        "--overwrite",
        action="store_true",
        help="Force overwrite the existing project",
    )
    args = parser.parse_args()

    if args.scene_folder is None:
        print("Please provide the scene folder path")
        exit()

    scene_folder = Path(args.scene_folder).resolve()
    overwrite = args.overwrite

    label_studio_helper = LabelStudioHelper()

    scene_name = scene_folder.name

    print(f">>>>>>>>>> Adding project {scene_name} <<<<<<<<<<<<")

    label_names = read_data_from_json(scene_folder / "meta.json")["object_labels"]
    interface_xml = generate_label_interface(label_names)
    storage_path = f"/label-studio/files/{scene_name}"

    if scene_name in label_studio_helper.projects_info:
        print(f"Project {scene_name} already exists.")
        if not overwrite:
            exit()

    label_studio_helper.add_project(
        title=scene_name,
        description=f"Annotate objects in {scene_name} with SAM backend",
        label_config=interface_xml,
        overwrite=overwrite,
    )

    label_studio_helper.add_ml_backend(
        project_title=scene_name,
        ml_title="Segmentation Anything Model",
        ml_url="http://label-studio-ml-backend:9090",
        ml_is_interactive=True,
    )

    label_studio_helper.add_local_storage(
        project_title=scene_name,
        storage_title=scene_name,
        storage_path=storage_path,
        use_blob_urls=True,
        regex_filter=".*.jpg",
        sync_storage=True,
    )
