import argparse
from label_toolkit.LabelStudioHelper import LabelStudioHelper


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--email", type=str, required=True)
    parser.add_argument("--overwrite", action="store_true")
    args = parser.parse_args()

    label_studio_helper = LabelStudioHelper()
    label_studio_helper.add_user(args.email, args.overwrite)
