"""Render one packed Blender scene on a short-lived Modal T4 container."""

from pathlib import Path

import modal

app = modal.App("lemon-blender-render")
image = modal.Image.from_registry("ghcr.io/petri-hub/lemon-render:latest")


@app.function(
    image=image,
    gpu="T4",
    max_containers=1,
    min_containers=0,
    buffer_containers=0,
    single_use_containers=True,
    scaledown_window=2,
    timeout=600,
    retries=0,
)
def render_scene(scene_bytes: bytes, frame: int, samples: int, percentage: int) -> bytes:
    import tempfile

    import bpy

    with tempfile.TemporaryDirectory() as directory:
        source = Path(directory) / "scene.blend"
        output = Path(directory) / "render.png"
        source.write_bytes(scene_bytes)
        bpy.ops.wm.open_mainfile(filepath=str(source), load_ui=False, use_scripts=False)
        scene = bpy.context.scene
        if scene.camera is None:
            raise ValueError("The active scene has no camera")
        scene.frame_set(frame)
        scene.render.engine = "CYCLES"
        scene.render.resolution_percentage = percentage
        scene.render.image_settings.file_format = "PNG"
        scene.render.filepath = str(output)
        scene.cycles.samples = samples
        scene.cycles.device = "GPU"

        cycles = bpy.context.preferences.addons["cycles"].preferences
        cycles.compute_device_type = "CUDA"
        cycles.get_devices()
        devices = [device for device in cycles.devices if device.type == "CUDA"]
        if not devices:
            raise RuntimeError("No CUDA device available to Cycles; refusing CPU fallback")
        for device in cycles.devices:
            device.use = device.type == "CUDA"
        print("Cycles GPU devices:", ", ".join(device.name for device in devices))
        bpy.ops.render.render(write_still=True)
        return output.read_bytes()


@app.local_entrypoint()
def main(input: str, output: str, frame: int = 1, samples: int = 32, percentage: int = 50):
    source = Path(input).expanduser().resolve()
    destination = Path(output).expanduser().resolve()
    if source == destination:
        raise ValueError("Input and output must be different files")
    if not source.is_file() or source.suffix.lower() != ".blend":
        raise ValueError("Input must be an existing .blend file")
    if destination.exists():
        raise FileExistsError(f"Refusing to overwrite {destination}")
    if destination.suffix.lower() != ".png":
        raise ValueError("Output must be a .png file")
    if frame < 1 or not 1 <= samples <= 4096 or not 1 <= percentage <= 100:
        raise ValueError("Frame must be positive, samples 1–4096, percentage 1–100")
    result = render_scene.remote(source.read_bytes(), frame, samples, percentage)
    destination.parent.mkdir(parents=True, exist_ok=True)
    with destination.open("xb") as result_file:
        result_file.write(result)
    print(f"Saved render to {destination}")
