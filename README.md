[![logo](test/header.png)](https://github.com/manim-kindergarten/manim_action_renderer)

[![Test Github Action](https://github.com/manim-kindergarten/manim_action_renderer/workflows/Test%20Github%20Action/badge.svg)](https://github.com/manim-kindergarten/manim_action_renderer/actions)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://choosealicense.com/licenses/mit/)

[中文README文件](https://github.com/manim-kindergarten/manim_action_renderer/blob/master/README-CN.md)

A GitHub Action that uses manim to render video

It runs on [a docker image](https://github.com/manim-kindergarten/manim_texlive_docker) with python3.7 and texlive-full environments.

## Inputs

* `source_file`

    **Required**, the source file with the scenes you want to render (relative to the current repo). E.g.:
    ```yaml
    - uses: manim-kindergarten/manim_action_renderer@master
      with:
        source_file: path/to/your/file.py
    ```

* `scene_names`

    The name of the scenes to be rendered in the source file, in the form of a string. The default is to render all (with a `-a` flag). Multiple scenes need to be separated by spaces in `""` or write them in multiple lines, e.g.:
    ```yaml
    - uses: manim-kindergarten/manim_action_renderer@master
      with:
        source_file: path/to/your/file.py
        scene_names: |
          SceneName1
          SceneName2
    ```

* `args`

    The arguments passed to the manim command line. Usually controls the resolution of the exported video. The default is `-w` which is `1440@60`.

* `manim_repo`

    The manim repository that needs to be used when rendering the video, the default is https://github.com/manim-kindergarten/manim (recommended, because it can be used without changes)<br/>
    You can set it to any repo you want (make sure it can be used wihout changes and through command `python manim.py ... ...`)<br/>
    This can be changed to https://github.com/ManimCommunity/manim now. <br/>
    But at present, this will throw an error when set to https://github.com/3b1b/manim .

* `community_ver`

    Whether the manim repo is a community version (e.g. a fork of ManimCommunity/manim) or not. The default is false.

* `extra_packages`

    Additional python modules that need to be used, use `pip` to install them. Use a space to separate every two or write them in multiple lines, e.g.: `"packageA packageB"` or :
    ```yaml
    - uses: manim-kindergarten/manim_action_renderer@master
      with:
        extra_packages: |
          packageA
          packageB
    ```

* `extra_system_packages`

    The system packages that need to be used, use the `apk` to install them.

* `extra_repos`

    Extra repositories you want to clone to the current workspace. Use a space to separate every two repos, or write them in multiple lines.

* `pre_render`

    The shell command to be executed before rendering.

* `post_render`

    The shell command to be executed after rendering.

* `merge_assets`

    Whether merge the two assets/ folder when both the current repo and manim repo have assets/. The default is `true`, **notice**, if it is set to false, it may cause error if there are two assets.
    
* `fonts_dir`

    The extra font files dir relative to the current repo. They will be installed automatically.

## Outputs

* `video_path`

    The directory (`./outputs/`) where all videos are stored after rendering is used to upload the results to artifacts.

## Example

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Rendering Scenes
        uses: manim-kindergarten/manim_action_renderer@master
        id: renderer
        with:
          source_file: example_scenes.py
          scene_names: |
            OpeningManimExample
            WriteStuff
          args: "--high_quality"
      - name: Save output as artifacts
        uses: actions/upload-artifact@v2
        with:
          name: Videos
          path: ${{ steps.renderer.outputs.video_path }}
```

Due to pull image from DockerHub, install dependencies, etc., it takes about 4 minutes before starting to render the scenes<br/>
The final generated video file will be delivered to the artifacts part of the action running page.

## License

[MIT](https://github.com/manim-kindergarten/manim_action_renderer/blob/master/LICENSE)
