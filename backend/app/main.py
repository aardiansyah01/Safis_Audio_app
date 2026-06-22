from fastapi import FastAPI, UploadFile, File, Form
from fastapi.responses import FileResponse
import shutil
import os

from app.processing.audio_processor import enhance_audio

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Backend Running"}

@app.post("/upload")
async def upload_file(
    file: UploadFile = File(...),
    noise_reduction: int = Form(50),
    audio_enhancement: int = Form(50)
):

    upload_path = f"app/uploads/{file.filename}"

    with open(upload_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    file_ext = os.path.splitext(file.filename)[1]

    output_filename = (
        f"enhanced_{os.path.splitext(file.filename)[0]}"
        f"{file_ext}"
    )

    output_path = f"app/outputs/{output_filename}"

    enhance_audio(
        upload_path,
        output_path,
        noise_reduction,
        audio_enhancement
    )

    return {
        "message": "Audio enhanced successfully",
        "original_file": file.filename,
        "enhanced_file": output_filename
    }

@app.get("/download/{filename}")
def download_file(filename: str):

    file_path = f"app/outputs/{filename}"

    return FileResponse(
        path=file_path,
        filename=filename,
        media_type="application/octet-stream"
    )