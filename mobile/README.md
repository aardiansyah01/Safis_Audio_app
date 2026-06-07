README.md
SafisAudio App - Implementasi MVVM pada Flutter

Deskripsi Proyek :
SafisAudio App merupakan aplikasi mobile berbasis Flutter yang digunakan untuk melakukan peningkatan kualitas audio (Audio Enhancement) menggunakan teknologi Artificial Intelligence (AI). Pada tahap pengembangan saat ini-
aplikasi telah mampu:
Mengunggah file audio/video ke server FastAPI.
Memproses audio menggunakan AI Noise Reduction.
Memutar hasil audio yang telah ditingkatkan kualitasnya.
Mengunduh hasil audio yang telah diproses.
Menyimpan riwayat proses audio menggunakan SQLite.
Mengimplementasikan arsitektur MVVM (Model-View-ViewModel).
Konsep MVVM (Model-View-ViewModel)

MVVM merupakan pola arsitektur yang memisahkan tampilan (UI), logika bisnis, dan data sehingga kode menjadi lebih terstruktur, mudah dipelihara, dan mudah dikembangkan.

1. Model
   Model bertugas merepresentasikan data yang digunakan aplikasi.

Pada project ini:
lib/model/history_model.dart

Digunakan untuk menyimpan data riwayat audio yang telah diproses.

Contoh atribut:
id
fileName
enhancedFile
createdAt

2. View
   View bertugas menampilkan antarmuka pengguna dan menerima interaksi dari pengguna.

Pada project ini:
lib/view/pages/home_page.dart
lib/view/pages/history_page.dart
lib/view/pages/main_navigation_page.dart

Fungsi:
Menampilkan tombol upload.
Menampilkan status proses.
Menampilkan daftar riwayat audio.
Menampilkan Bottom Navigation Bar.

3. ViewModel
   ViewModel bertugas menghubungkan View dengan Repository.

Pada project ini:
lib/viewmodel/upload_viewmodel.dart

Fungsi:
Mengelola proses upload file.
Mengelola proses download file.
Mengelola pemutaran audio.
Mengatur status aplikasi.
Memberikan data ke View menggunakan Provider.

ViewModel menggunakan:
extends ChangeNotifier, untuk memberi tahu UI ketika terjadi perubahan data.

4. Repository
   Repository berfungsi sebagai penghubung antara ViewModel dan Service.

Folder:
lib/repository/

Berisi:
upload_repository.dart, yang menghubungkan ViewModel dengan Upload Service.

download_repository.dart yang menghubungkan ViewModel dengan Download Service.

audio_player_repository.dart yang menghubungkan ViewModel dengan Audio Player Service.

history_repository.dart yang menghubungkan ViewModel dengan SQLite Database.

5. Service
   Service bertugas berkomunikasi langsung dengan API atau plugin.

Folder:
lib/services/

Berisi:
upload_service.dart untuk mengirim file ke FastAPI menggunakan Dio.

download_service.dart yang mengunduh hasil audio dari server.

audio_player_service.dart untuk memutar audio hasil enhancement.

6. Database
   Menggunakan SQLite untuk menyimpan riwayat pemrosesan audio.

Folder:
lib/data/database/

Berisi:
database_helper.dart

Mengelola:
Pembuatan database
Pembuatan tabel
Insert data
Read data
Delete data
Shared Layer

7. Shared
   lib/shared/theme/

Berisi:
app_theme.dart

Digunakan untuk menyimpan konfigurasi tema aplikasi sehingga tampilan dapat dikelola dari satu tempat.

Struktur Folder MVVM
lib
│
├── data
│ └── database
│ └── database_helper.dart
│
├── model
│ └── history_model.dart
│
├── repository
│ ├── upload_repository.dart
│ ├── download_repository.dart
│ ├── audio_player_repository.dart
│ └── history_repository.dart
│
├── services
│ ├── upload_service.dart
│ ├── download_service.dart
│ └── audio_player_service.dart
│
├── shared
│ └── theme
│ └── app_theme.dart
│
├── view
│ ├── pages
│ │ ├── home_page.dart
│ │ ├── history_page.dart
│ │ └── main_navigation_page.dart
│ │
│ └── widgets
│
├── viewmodel
│ └── upload_viewmodel.dart
│
└── main.dart

Cara Menjalankan Aplikasi :

1. Menjalankan Backend

Masuk ke folder backend:

cd backend

Aktifkan virtual environment:

venv\Scripts\activate

Jalankan FastAPI:

uvicorn app.main:app --reload --host 0.0.0.0

Backend berjalan pada:

http://127.0.0.1:8000

Swagger Documentation:

http://127.0.0.1:8000/docs

2. Menjalankan Flutter

Masuk ke folder mobile:

cd mobile

Install dependency:

flutter pub get

Jalankan aplikasi:

flutter run

Atau:

flutter run -d windows

Refleksi :
Pada tugas ini saya mempelajari penerapan arsitektur MVVM (Model-View-ViewModel) secara khusus pada framework Flutter. Sebelumnya saya sudah pernah mempelajari konsep MVVM pada platform lain, sehingga saya telah mengetahui prinsip dasar pemisahan antara View, ViewModel, dan Model. Namun melalui tugas ini saya memperoleh pemahaman baru dan memperdalam mengenai bagaimana MVVM dapat diimplementasikan, khususnya dalam Flutter menggunakan Provider dan ChangeNotifier sebagai mekanisme state management.

Saya belajar lebih dalam untuk bagaimana View hanyaboleh menampilkan antarmuka pengguna, sementara ViewModel menangani logika aplikasi dan berkomunikasi dengan Repository. Selain itu saya juga belajar bagaimana Repository digunakan sebagai lapisan penghubung antara ViewModel dan Service sehingga kode menjadi lebih terstruktur dan mudah dikembangkan.

Tantangan yang saya hadapi adalah menyesuaikan pola MVVM dengan struktur project Flutter, terutama saat melakukan refactor dari kode yang awalnya masih sederhana menjadi arsitektur yang lebih terorganisir. Dari tugas ini saya memahami bahwa penerapan MVVM pada Flutter dapat meningkatkan keterbacaan kode, mempermudah pemeliharaan aplikasi, dan memudahkan penambahan fitur kedepannya.

Nama : Aditya Ardian Syah
NIM : 0706012414005
Nama Aplikasi: SafisAudio App
Framework: Flutter
Arsitektur: MVVM (Model-View-ViewModel)
Backend: FastAPI (Python)
Database Lokal: SQLite
State Management: Provider
Audio Processing: Librosa + Noisereduce + FFmpeg
