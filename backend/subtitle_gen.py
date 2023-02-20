import time
import subprocess
from flask import Flask, request, send_file
import whisper
from helpers import *


app = Flask(__name__)

@app.route("/upload", methods=["POST"])
def up():
    resp = request.files['dat']
    resp.save("/home/d4rk/projects/mini_project_23/subtitleGen/backend/download/viaud")
    return "done"


@app.route("/processing")
def subGen():
    conv = subprocess.call(["ffmpeg", "-i", "download/viaud", "-f", "mp3", "download/audio.mp3", "-y"], stderr=subprocess.DEVNULL, stdout=subprocess.DEVNULL)
    if conv == 0:
        model = whisper.load_model("base")
        result = model.transcribe("download/audio.mp3", fp16=False)
    else:
        return("couldn't convert")

    with open('download/subtitle.srt', 'w', encoding="utf-8") as srt:
                write_srt(result["segments"], file=srt, line_length=0)

    with open('download/subtitle.vtt', 'w', encoding="utf-8") as vtt:
                write_vtt(result["segments"], file=vtt, line_length=0)

    return "done"


@app.route("/download/srt")
def down1():
    return send_file("download/subtitle.srt", as_attachment=True)

@app.route("/download/vtt")
def down2():
    return send_file("download/subtitle.vtt", as_attachment=True)



app.run(host="0.0.0.0", port=1234)