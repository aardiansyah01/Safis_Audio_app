from fastapi import FastAPI, UploadFile, File
from fastapi.responses import FileResponse
import shutil
import os

from app.processing.audio_processor import enhance_audio

app = FastAPI()

@app.get("/")
def home():
    return {"message": "Backend Running"}

@app.post("/upload")
async def upload_file(file: UploadFile = File(...)):

    # Save original file
    upload_path = f"app/uploads/{file.filename}"

    with open(upload_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)

    # Output filename
    output_filename = f"enhanced_{file.filename}"
    output_path = f"app/outputs/{output_filename}"

    # Process AI enhancement
    enhance_audio(upload_path, output_path)

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