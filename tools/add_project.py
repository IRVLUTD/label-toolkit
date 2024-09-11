import argparse
from cProfile import label
from label_toolkit.utils import generate_random_color
from label_toolkit.LabelStudioHelper import LabelStudioHelper


def generate_label_interface(label_names):
    """Generate a dynamic Label Studio interface with BrushLabels, KeypointLabels, and RectangleLabels."""
    template = """
    <View>
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
    </View>
    """

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
        brush_labels="\n        ".join(brush_labels),
        keypoint_labels="\n        ".join(keypoint_labels),
        rectangle_labels="\n        ".join(rectangle_labels),
    )


# Example usage:
# label_names = ["Obj_1", "Obj_2", "Obj_3", "Obj_4"]
# interface_xml = generate_label_interface(label_names)
# print(interface_xml)


if __name__ == "__main__":
    # parser = argparse.ArgumentParser()
    # parser.add_argument("email", type=str, help="User email")
    # parser.add_argument(
    #     "--overwrite",
    #     action="store_true",
    #     help="Overwrite user if already exists",
    # )
    # args = parser.parse_args()

    label_studio_helper = LabelStudioHelper()
    # label_studio_helper.add_project(
    #     title="test_project",
    #     description="Test project",
    #     label_config="<View></View>",
    #     overwrite=True,
    # )
    # label_studio_helper.add_ml_backend(
    #     project_title="test_project",
    #     ml_title="Segmentation Anything Model",
    #     ml_url="http://label-studio-ml-backend:9090",
    #     ml_is_interactive=True,
    # )
    # label_studio_helper.add_local_storage(
    #     project_title="test_project",
    #     storage_title="demo_1",
    #     storage_path="/label-studio/files/demo_1",
    #     use_blob_urls=True,
    #     regex_filter=".*.jpg",
    # )
    annotat = label_studio_helper.export_annotations_by_project(
        project_title="test_project"
    )
