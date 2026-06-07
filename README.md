# 🎵 SafisAudio App

> Implementasi Arsitektur **MVVM (Model-View-ViewModel)** pada Flutter untuk aplikasi Audio Enhancement berbasis Artificial Intelligence (AI).

---

## 📖 Deskripsi Proyek

**SafisAudio App** merupakan aplikasi mobile berbasis Flutter yang digunakan untuk meningkatkan kualitas audio (*Audio Enhancement*) menggunakan teknologi Artificial Intelligence (AI).

Pada tahap pengembangan saat ini, aplikasi telah mampu:

* ✅ Mengunggah file audio/video ke server FastAPI
* ✅ Memproses audio menggunakan AI Noise Reduction
* ✅ Memutar hasil audio yang telah ditingkatkan kualitasnya
* ✅ Mengunduh hasil audio yang telah diproses
* ✅ Menyimpan riwayat proses audio menggunakan SQLite
* ✅ Mengimplementasikan arsitektur MVVM (Model-View-ViewModel)

---

## 🏗️ Konsep MVVM (Model-View-ViewModel)

MVVM merupakan pola arsitektur yang memisahkan antarmuka pengguna (*View*), logika aplikasi (*ViewModel*), dan data (*Model*) sehingga kode menjadi lebih terstruktur, mudah dipelihara, dan mudah dikembangkan.

### 1️⃣ Model

Model bertugas merepresentasikan data yang digunakan aplikasi.

**File:**

```text
lib/model/history_model.dart
```

**Data yang disimpan:**

* id
* fileName
* enhancedFile
* createdAt

---

### 2️⃣ View

View bertugas menampilkan antarmuka pengguna dan menerima interaksi dari pengguna.

**File:**

```text
lib/view/pages/home_page.dart
lib/view/pages/history_page.dart
lib/view/pages/main_navigation_page.dart
```

**Fungsi:**

* Menampilkan tombol upload
* Menampilkan status proses
* Menampilkan daftar riwayat audio
* Menampilkan Bottom Navigation Bar

---

### 3️⃣ ViewModel

ViewModel bertugas menghubungkan View dengan Repository.

**File:**

```text
lib/viewmodel/upload_viewmodel.dart
```

**Fungsi:**

* Mengelola proses upload file
* Mengelola proses download file
* Mengelola pemutaran audio
* Mengatur status aplikasi
* Menyediakan data ke View menggunakan Provider

ViewModel menggunakan:

```dart
extends ChangeNotifier
```

untuk memberi tahu UI ketika terjadi perubahan data.

---

### 4️⃣ Repository

Repository berfungsi sebagai penghubung antara ViewModel dan Service.

**Folder:**

```text
lib/repository/
```

**Berisi:**

* upload_repository.dart
* download_repository.dart
* audio_player_repository.dart
* history_repository.dart

---

### 5️⃣ Service

Service bertugas berkomunikasi langsung dengan API maupun plugin.

**Folder:**

```text
lib/services/
```

**Berisi:**

* upload_service.dart
* download_service.dart
* audio_player_service.dart

---

### 6️⃣ Database

Aplikasi menggunakan SQLite untuk menyimpan riwayat pemrosesan audio.

**Folder:**

```text
lib/data/database/
```

**File:**

```text
database_helper.dart
```

**Fungsi:**

* Membuat database
* Membuat tabel
* Insert data
* Read data
* Delete data

---

### 7️⃣ Shared Layer

**Folder:**

```text
lib/shared/theme/
```

**File:**

```text
app_theme.dart
```

Digunakan untuk menyimpan konfigurasi tema aplikasi sehingga tampilan dapat dikelola dari satu tempat.

---

## 📂 Struktur Folder MVVM

```text
lib
│
├── data
│   └── database
│       └── database_helper.dart
│
├── model
│   └── history_model.dart
│
├── repository
│   ├── upload_repository.dart
│   ├── download_repository.dart
│   ├── audio_player_repository.dart
│   └── history_repository.dart
│
├── services
│   ├── upload_service.dart
│   ├── download_service.dart
│   └── audio_player_service.dart
│
├── shared
│   └── theme
│       └── app_theme.dart
│
├── view
│   ├── pages
│   │   ├── home_page.dart
│   │   ├── history_page.dart
│   │   └── main_navigation_page.dart
│   │
│   └── widgets
│
├── viewmodel
│   └── upload_viewmodel.dart
│
└── main.dart
```

---

## 🚀 Cara Menjalankan Aplikasi

### Backend (FastAPI)

Masuk ke folder backend:

```bash
cd backend
```

Aktifkan virtual environment:

```bash
venv\Scripts\activate
```

Jalankan server FastAPI:

```bash
uvicorn app.main:app --reload --host 0.0.0.0
```

Backend berjalan pada:

```text
http://127.0.0.1:8000
```

Swagger Documentation:

```text
http://127.0.0.1:8000/docs
```

---

### Flutter App

Masuk ke folder mobile:

```bash
cd mobile
```

Install dependency:

```bash
flutter pub get
```

Jalankan aplikasi:

```bash
flutter run
```

Atau:

```bash
flutter run -d windows
```

---

## 🛠️ Teknologi yang Digunakan

| Komponen              | Teknologi            |
| --------------------- | -------------------- |
| Frontend              | Flutter              |
| Bahasa Pemrograman    | Dart                 |
| Backend               | FastAPI              |
| Bahasa Backend        | Python               |
| Database Lokal        | SQLite               |
| State Management      | Provider             |
| Architecture Pattern  | MVVM                 |
| Audio Processing      | Librosa, Noisereduce |
| Multimedia Processing | FFmpeg               |

---

## 📚 Refleksi

Pada tugas ini saya mempelajari penerapan arsitektur MVVM (Model-View-ViewModel) secara khusus pada framework Flutter. Sebelumnya saya sudah pernah mempelajari konsep MVVM pada platform lain, sehingga saya telah mengetahui prinsip dasar pemisahan antara View, ViewModel, dan Model. Namun melalui tugas ini saya memperoleh pemahaman baru dan memperdalam mengenai bagaimana MVVM dapat diimplementasikan, khususnya dalam Flutter menggunakan Provider dan ChangeNotifier sebagai mekanisme state management. Saya belajar lebih dalam untuk bagaimana View hanyaboleh menampilkan antarmuka pengguna, sementara ViewModel menangani logika aplikasi dan berkomunikasi dengan Repository. Selain itu saya juga belajar bagaimana Repository digunakan sebagai lapisan penghubung antara ViewModel dan Service sehingga kode menjadi lebih terstruktur dan mudah dikembangkan. Tantangan yang saya hadapi adalah menyesuaikan pola MVVM dengan struktur project Flutter, terutama saat melakukan refactor dari kode yang awalnya masih sederhana menjadi arsitektur yang lebih terorganisir. Dari tugas ini saya memahami bahwa penerapan MVVM pada Flutter dapat meningkatkan keterbacaan kode, mempermudah pemeliharaan aplikasi, dan memudahkan penambahan fitur kedepannya.

---

## 👨‍🎓 Informasi Mahasiswa

| Keterangan       | Isi                |
| ---------------- | ------------------ |
| Nama             | Aditya Ardian Syah |
| NIM              | 0706012414005      |
| Nama Aplikasi    | SafisAudio App     |
| Framework        | Flutter            |
| Arsitektur       | MVVM               |
| Backend          | FastAPI            |
| Database Lokal   | SQLite             |
| State Management | Provider           |

---

⭐ Tugas Implementasi MVVM pada Flutter - SafisAudio App
