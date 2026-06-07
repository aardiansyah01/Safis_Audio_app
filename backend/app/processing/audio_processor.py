import noisereduce as nr
import librosa
import soundfile as sf

def enhance_audio(input_path, output_path):

    # Load audio
    audio_data, sample_rate = librosa.load(input_path, sr=None)

    # Noise reduction
    reduced_noise = nr.reduce_noise(
        y=audio_data,
        sr=sample_rate
    )

    # Save enhanced audio
    sf.write(
        output_path,
        reduced_noise,
        sample_rate
    )

    return output_path