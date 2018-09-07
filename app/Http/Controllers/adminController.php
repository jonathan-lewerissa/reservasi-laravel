<?php

namespace App\Http\Controllers;
use Mail;
use Session;

use Illuminate\Http\Request;

use App\Http\Requests;

use DB;

class adminController extends Controller
{
    public function index(){
        $jumlah = DB::select('select count(*) as "jumlah" from daftar_permohonan where status_permohonan="Diproses"');
		$now = DB::select('select count(*) as "jumlah" from waktu_kegiatan where tanggal_kegiatan=curdate() and waktu_mulai_kegiatan <= curtime() and waktu_selesai_kegiatan>=curtime() and nama_ruangan="Laboratorium Pemrograman 2";');
    	return view('admin.indexadmin', ['jumlah'=>$jumlah, 'now'=>$now]);
    }
    public function accRuangan(){
    	$listPermohonan = DB::select('select * from daftar_permohonan where status_permohonan = "Diproses" order by tanggal_masuk_permohonan ASC');
    	return view('admin.accruangan', ['listPermohonan'=>$listPermohonan]);
    }
    public function acc(Request $request){
        $pesan = DB::select('call setujuiPermohonan(?,?)', array($request['kode_permohonan'], $request->session()->get('username_admin')));
		
		$kode = $request['kode_permohonan'];
		
		$data = [
			'kode_permohonan'=>$request['kode_permohonan'],
			'nama_kegiatan'=>DB::select('SELECT nama_kegiatan FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->nama_kegiatan,
			'nama_permohonan'=>DB::select('SELECT nama_pemohon_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->nama_pemohon_peminjaman,
			'tanggal'=>DB::select('SELECT tanggal_mulai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->tanggal_mulai_permohonan_peminjaman,
			'waktu_mulai'=>DB::select('SELECT waktu_mulai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->waktu_mulai_permohonan_peminjaman,
			'waktu_selesai'=>DB::select('SELECT waktu_selesai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->waktu_selesai_permohonan_peminjaman,
		];

		$email_pemohon = DB::select('SELECT email_pemohon FROM pemohon WHERE nama_pemohon = ?', array($data['nama_permohonan']));
		$email_pemohon = $email_pemohon[0]->email_pemohon; 
		
		$data['email_pemohon'] = $email_pemohon;
		
        if($pesan[0]->status==1){
			Mail::send('mail.terima', ['data' => $data], function($message) use($data){
				$message->from('laboratoriumpemrograman2@gmail.com','LP2');
				$message->subject('Reservasi Laboratorium Pemrograman 2');
				$message->to($data['email_pemohon']);
			});
			return redirect()->back();
		}
        else{
			Mail::send('mail.tolak', ['data' => $data], function($message) use($data){
				$message->from('laboratoriumpemrograman2@gmail.com','LP2');
				$message->subject('Reservasi Laboratorium Pemrograman 2');
				$message->to($data['email_pemohon']);
			});
			
            session::flash('msg', $pesan[0]->pesan);
            return redirect()->back();
        }
    }
    public function del(request $request){
        $pesan = DB::select('call tolakPermohonan(?,?)', array($request->session()->get('username_admin'), $request['kode_permohonan']));
		$kode = $request['kode_permohonan'];
		$data = [
			'kode_permohonan'=>$request['kode_permohonan'],
			'nama_kegiatan'=>DB::select('SELECT nama_kegiatan FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->nama_kegiatan,
			'nama_permohonan'=>DB::select('SELECT nama_pemohon_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->nama_pemohon_peminjaman,
			'tanggal'=>DB::select('SELECT tanggal_mulai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->tanggal_mulai_permohonan_peminjaman,
			'waktu_mulai'=>DB::select('SELECT waktu_mulai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->waktu_mulai_permohonan_peminjaman,
			'waktu_selesai'=>DB::select('SELECT waktu_selesai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=?', array($kode))[0]->waktu_selesai_permohonan_peminjaman,
		];

		$email_pemohon = DB::select('SELECT email_pemohon FROM pemohon WHERE nama_pemohon = ?', array($data['nama_permohonan']));
		$email_pemohon = $email_pemohon[0]->email_pemohon; 
		
		$data['email_pemohon'] = $email_pemohon;
		
			Mail::send('mail.tolak', ['data' => $data], function($message) use($data){
				$message->from('laboratoriumpemrograman2@gmail.com','LP2');
				$message->subject('Reservasi Laboratorium Pemrograman 2');
				$message->to($data['email_pemohon']);
			});
		
        return redirect()->back();
    }
    public function editpeminjaman(){
        $peminjaman=DB::select('SELECT * FROM daftar_permohonan WHERE status_permohonan="Disetujui" AND kode_permohonan IN (SELECT kode_permohonan FROM waktu_kegiatan WHERE tanggal_kegiatan >= CURDATE()) ORDER BY tanggal_mulai_permohonan_peminjaman ASC');
        return view('admin.pinjamacc', ['peminjaman'=>$peminjaman]);
    }
    public function halamaneditpinjam($kodepeminjaman){
        $datapinjam = DB::select('select * from daftar_permohonan where kode_permohonan=?', array($kodepeminjaman));
        $ruangan=DB::select('select * from ruangan');
        $rutinitas=DB::select('select * from rutinitas');
        $pemohon=DB::select('select * from pemohon where nama_pemohon=?', array($datapinjam[0]->nama_pemohon_peminjaman));
        return view('admin.formeditpinjam', ['data'=>$datapinjam, 'ruangan'=>$ruangan, 'rutinitas'=>$rutinitas, 'pemohon'=>$pemohon]);
    }
    public function updatepeminjaman(Request $request){
        $update = DB::select('call updatePeminjaman(?,?,?,?,?, ?,?,?,?)', array($request->session()->get('username_admin'), $request['kode_peminjaman'],$request['keg'],$request['tglmulai'],$request['wktmulai'],$request['wktselesai'],$request['ruang'],$request['rutin'],$request['kali']));
        if($update[0]->pesan==1){
            session::flash('edit', 'Pengubahan peminjaman berhasil dilakukan.');
        }else{
            session::flash('edit', 'Pengubahan peminjaman gagal dilakukan.');
        }
        return redirect('/admin/editpeminjaman');
    }
    public function hapuspeminjaman(Request $request){
        DB::select('call hapusPeminjaman(?,?)', array($request->kode_permohonan, $request->session()->get('username_admin')));
        return redirect()->back();
    }
    public function setting(){
        return view('admin.setelan');
    }
    public function tambahruang(Request $request){
        $pesan = DB::select('call tambahRuangan(?)', array($request['ruangan']));
        if($pesan[0]->pesan==1){
            session::flash('ruang_ok', 'Ruangan telah ditambahkan');
            return redirect()->back();
        }else{
            session::flash('ruang_ko', 'Ruangan sudah ada');
            return redirect()->back();
        }
    }
    public function tambahinterval(Request $request){
        $pesan = DB::select('call tambahRutinitas(?,?,?)', array($request['interval'],$request['keterangan'],$request->session()->get('username_admin')));
        session::flash('interval_ok', 'Interval telah ditambahkan');
        return redirect()->back();
    }
    public function gantipassword(Request $request){
        $pesan = DB::select('call gantiPasswordAdmin(?,?,?)', array($request['passwordlama'], $request['passwordbaru1'], $request->session()->get('username_admin')));
        session::flash('hasil', $pesan[0]->message);
        return redirect()->back();
    }
    public function editInfo(){
        $daftar_info = DB::select('select * from info_center;');
        return view('admin.info', ['daftar_info' => $daftar_info]);
    }
    public function tambahPengumuman(Request $request){
        DB::select('call tambahInfo(?,?)', array($request['pengumuman'], $request->session()->get('username_admin')));
        return redirect()->back();
    }
    public function hapusInfo($kodeinfo){
        DB::select('delete from info_center where no_info = ?', array($kodeinfo));
        return redirect()->back();
    }
	public function potongSekarang($namaruang){
		DB::select('call potongKegiatanSekarang(?)', array($namaruang));
		return redirect()->back();
	}
}