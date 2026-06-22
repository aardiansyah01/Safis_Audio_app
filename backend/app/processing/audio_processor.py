import noisereduce as nr
import librosa
import soundfile as sf
import numpy as np
import os
import subprocess


def enhance_audio(
    input_path,
    output_path,
    noise_reduction,
    audio_enhancement
):

    extension = os.path.splitext(input_path)[1].lower()

    if extension == ".mp4":

        temp_audio = input_path.replace(
            ".mp4",
            "_temp.wav"
        )

        subprocess.run([
            "ffmpeg",
            "-y",
            "-i",
            input_path,
            "-vn",
            temp_audio
        ], check=True)

        audio_data, sample_rate = librosa.load(
            temp_audio,
            sr=None
        )

        prop_decrease = noise_reduction / 100

        reduced_noise = nr.reduce_noise(
            y=audio_data,
            sr=sample_rate,
            prop_decrease=prop_decrease
        )

        gain = 1 + (audio_enhancement / 100)

        enhanced_audio = reduced_noise * gain

        enhanced_audio = np.clip(
            enhanced_audio,
            -1.0,
            1.0
        )

        enhanced_wav = input_path.replace(
            ".mp4",
            "_enhanced.wav"
        )

        sf.write(
            enhanced_wav,
            enhanced_audio,
            sample_rate
        )

        subprocess.run([
            "ffmpeg",
            "-y",
            "-i",
            input_path,
            "-i",
            enhanced_wav,
            "-c:v",
            "copy",
            "-map",
            "0:v:0",
            "-map",
            "1:a:0",
            output_path
        ], check=True)

        if os.path.exists(temp_audio):
            os.remove(temp_audio)

        if os.path.exists(enhanced_wav):
            os.remove(enhanced_wav)

        return output_path

    audio_data, sample_rate = librosa.load(
        input_path,
        sr=None
    )

    prop_decrease = noise_reduction / 100

    reduced_noise = nr.reduce_noise(
        y=audio_data,
        sr=sample_rate,
        prop_decrease=prop_decrease
    )

    gain = 1 + (audio_enhancement / 100)

    enhanced_audio = reduced_noise * gain

    enhanced_audio = np.clip(
        enhanced_audio,
        -1.0,
        1.0
    )

    sf.write(
        output_path,
        enhanced_audio,
        sample_rate
    )

    return output_path