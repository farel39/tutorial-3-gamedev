## Nama    : Argya Farel Kasyara
## NPM     : 2306152424


## Fitur yang Diimplementasikan

Berikut adalah 3 mekanika pergerakan lanjutan yang telah ditambahkan ke dalam `CharacterBody2D`:

1. **Double Jump**: Karakter dapat melompat saat berada di udara (maksimal 2 kali lompatan berturut-turut).
2. **Dashing (Double-Tap)**: Karakter dapat melakukan gerakan *dash* cepat ke depan dengan menekan tombol arah (kiri/kanan) sebanyak dua kali dengan cepat (*double-tap*).
3. **Crouching**: Karakter dapat berjongkok dengan menekan tombol bawah. Saat berjongkok, ukuran (*scale*) karakter menjadi lebih kecil dan kecepatan berjalannya melambat.

---

## Proses Pengerjaan & Penjelasan Logika

### 1. Implementasi Double Jump
* **Proses**: Menambahkan variabel `max_jumps` untuk menentukan batas lompatan, dan `current_jumps` untuk melacak berapa kali karakter sudah melompat.
* **Logika**: Setiap kali karakter berada di lantai (`is_on_floor()`), `current_jumps` di-reset ke 0. Ketika tombol lompat ditekan, sistem mengecek apakah `current_jumps < max_jumps`. Jika ya, nilai `velocity.y` diatur kembali ke `jump_speed` dan `current_jumps` bertambah 1.

### 2. Implementasi Dashing (Double-Tap)
* **Proses**: Diperlukan logika untuk menyimpan memori tentang *input* terakhir. Saya menggunakan fungsi `Time.get_unix_time_from_system()` dari Godot untuk mencatat *timestamp*.
* **Logika**: Dibuat fungsi khusus `_check_dash(direction)`. Saat pemain menekan tombol Kiri atau Kanan, sistem mencatat arah dan waktu saat itu. Jika pemain menekan tombol yang sama lagi sebelum jeda waktu habis (misal: 0.25 detik), *state* `is_dashing` menjadi `true`. Selama *state* ini aktif, variabel kecepatan akan di- *override* oleh `dash_speed` yang jauh lebih cepat selama durasi `dash_timer`.

### 3. Implementasi Crouching
* **Proses**: Menambahkan pemantau *input* untuk arah bawah ("ui_down").
* **Logika**: Ketika tombol bawah ditahan dan karakter berada di darat, *state* `is_crouching` menjadi aktif. Saya menerapkan modifikasi visual cepat dengan mengubah `scale.y = 0.5` agar karakter terlihat gepeng/merunduk. Variabel kecepatan berjalan yang diaplikasikan ke `velocity.x` juga diganti dengan `crouch_speed` yang lebih kecil dari `walk_speed`. Saat tombol dilepas, skala kembali ke 1.0 dan kecepatan kembali normal.

---

## Polishing 

Untuk mencapai pengalaman bermain yang lebih baik dan imersif, saya telah mengimplementasikan beberapa fitur *polishing* tambahan yang tidak dibahas pada tutorial dasar:

1. **Implementasi Sprite Animasi (`AnimatedSprite2D`)**: Saya mengeksplorasi penggunaan node `AnimatedSprite2D` untuk memberikan transisi visual yang halus berdasarkan *state* karakter (Idle, Walk, Jump, Crouch).
2. **Koreksi Arah Hadap (*Sprite Flipping*)**: Wajah dan badan karakter sekarang secara dinamis merespons *input* arah jalan pemain. Jika berjalan ke kiri, properti `flip_h` diaktifkan sehingga karakter menatap ke arah yang benar.
3. **Mekanika *Crouch* Berbasis Kolisi Dinamis**: Menghindari *bug* fisika yang umum terjadi pada *platformer*, saya tidak memanipulasi skala *root node* secara kasar saat jongkok. Sebaliknya, saya mengatur dua buah `CollisionShape2D` (satu tinggi, satu pendek) dan menggunakan kode untuk melakukan *toggle* mengaktifkan/menonaktifkan *collision* yang tepat sesuai status karakter, dipadukan dengan pemanggilan animasi jongkok.

## Referensi
* **Dokumentasi Resmi Godot 4**: *CharacterBody2D, Input, dan Time classes.* (https://docs.godotengine.org/en/stable/)
* **Youtube Playlist**: https://www.youtube.com/playlist?list=PLCcur7_Y2zTdKIQ2oM2Ec8MEfeBnAbEXT
