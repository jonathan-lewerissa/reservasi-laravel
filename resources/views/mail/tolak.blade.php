
<!DOCTYPE html>
<html lang="en">
<head>
    @include('layouts.userHead')
</head>
<body>
    <div class="container">
        <p>Yth. {{$data['nama_permohonan']}},</p>
        <p>Maaf, reservasi dengan kode {{$data['kode_permohonan']}} tidak dapat kami setujui.</p>
        <p>Berikut adalah rincian permohonan anda: </p>
        <br>
        <p>Nama Kegiatan : {{$data['nama_kegiatan']}}</p>
        <p>Tanggal : {{$data['tanggal']}}</p>
        <p>Waktu Mulai : {{$data['waktu_mulai']}}</p>
        <p>Waktu Selesai : {{$data['waktu_selesai']}}</p>
        <br>
        <br><p>Silahkan hubungi kami atau reservasi kembali dengan jadwal lain.</p>
        <br><p>Terima kasih, <br> Laboratorium Pemrograman 2</p>
    </div>        
</body>
</html>