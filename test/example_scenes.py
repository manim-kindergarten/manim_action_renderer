from manimlib.imports import *
from manim_sandbox.utils.imports import *

class WriteStuff(Scene):
    def construct(self):
        example_text = Text(
            "This is some text",
            font="Consolas"
        )
        example_tex = TexMobject(
            "\\sum_{k=1}^\\infty {1 \\over k^2} = {\\pi^2 \\over 6}",
        )
        group = VGroup(example_text, example_tex)
        group.arrange(DOWN)
        group.set_width(FRAME_WIDTH - 2 * LARGE_BUFF)

        self.play(Write(example_text))
        self.play(Write(example_tex))
        self.wait()
