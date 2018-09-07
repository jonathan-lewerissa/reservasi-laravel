<!DOCTYPE html>
<html lang="en">
<head>
    @include('layouts.userHead')
</head>
<body>
    <div class="container">
        <p>Yth. {{$data['nama_permohonan']}},</p>
        <p>Reservasi dengan kode {{$data['kode_permohonan']}} telah kami setujui.</p>
        <p>Berikut adalah rincian permohonan anda : </p>
        <br>
        <p>Nama Kegiatan : {{$data['nama_kegiatan']}}</p>
        <p>Tanggal : {{$data['tanggal']}}</p>
        <p>Waktu Mulai : {{$data['waktu_mulai']}}</p>
        <p>Waktu Selesai : {{$data['waktu_selesai']}}</p>
        <br>
        <p>Apabila ada kesalahan atau pergantian jadwal, silahkan hubungi kami.</p>
        <p>Terima kasih, <br> Laboratorium Pemrograman 2</p>
    </div>
</body>
</html>