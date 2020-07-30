[![logo](test/header.png)](https://github.com/manim-kindergarten/manim_action_renderer)

[![Test Github Action](https://github.com/manim-kindergarten/manim_action_renderer/workflows/Test%20Github%20Action/badge.svg)](https://github.com/manim-kindergarten/manim_action_renderer/actions)
[![MIT License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://choosealicense.com/licenses/mit/)

一个使用manim渲染视频的GitHub Action

在带有python3.7和texlive-full的[docker镜像](https://github.com/manim-kindergarten/manim_texlive_docker)上运行。

## 输入Inputs

* `source_file`

    **必要的**，带有你想要渲染的场景的源文件（相对于当前repo的相对路径）。例如：
    ```yaml
    - uses: manim-kindergarten/manim_action_renderer@master
      with:
        source_file: path/to/your/file.py
    ```

* `scene_names`

    在源文件中想要渲染的场景名，字符串形式。默认为全部渲染。多个场景需要用空格隔开，或写成多行，例如：
    ```yaml
    - uses: manim-kindergarten/manim_action_renderer@master
      with:
        source_file: path/to/your/file.py
        scene_names: |
          SceneName1
          SceneName2
    ```

* `args`

    向manim命令行传入的参数，通过这个控制导出视频的分辨率。默认为`-w`即`1440@60`。

* `manim_repo`

    渲染视频时需要使用的manim存储库，默认为https://github.com/manim-kindergarten/manim （推荐，因为可以即拿即用）<br/>
    可以改为任何manim源码的repo（确保可以直接运行，并且含有文件`manim.py`以使用`python manim.py ... ...`命令）<br/>
    目前支持 https://github.com/ManimCommunity/manim ，但无法使用https://github.com/3b1b/manim

* `community_ver`

    使用的`manim_repo`是否是community版（比如一个ManimCommunity/manim的fork）

* `extra_packages`

    需要用到的额外python模块，使用`pip`安装。每两个之间用空格隔开，或写成多行，例如：`"packageA packageB"`，或：
    ```yaml
    - uses: manim-kindergarten/manim_action_renderer@master
      with:
        extra_packages: |
          packageA
          packageB
    ```

* `extra_system_packages`

    需要用到的系统文件，使用`apk`安装。

* `extra_repos`

    需要clone到当前工作区的额外存储库，每两个之间用空格隔开，或写成多行。

* `pre_render`

    在渲染前要执行的shell命令。

* `post_render`

    在渲染后要执行的shell命令。
    
* `merge_assets`

    在当前repo和manim repo同时含有assets文件夹时是否将素材合并，默认为true。**注意**，如果改为false，可能会报错。
    
* `fonts_dir`

    视频中需要的额外字体ttf文件所在文件夹在当前文件夹中的相对路径，将在渲染前自动安装文件夹中的字体。

## 输出Outputs

* `video_path`

    渲染结束后所有视频存放的目录（`./outputs/`），用于将结果上传至artifacts中。

## 例子Example

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

由于拉拽镜像，安装依赖等原因，开始渲染场景之前需要4分钟左右的时间<br/>
最终生成的视频文件将投放至该Action运行页面的artifacts部分（国内下载较慢）

## 许可证License

[MIT开源许可证](https://github.com/manim-kindergarten/manim_action_renderer/blob/master/LICENSE)
