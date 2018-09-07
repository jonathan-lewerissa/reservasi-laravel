<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

use App\Http\Requests;
use DB;

class apiController extends Controller
{
    public function acc(Request $request)
	{
		if ((!isset($request->kode_permohonan)) or (!isset($request->username)) or (!isset($request->secret))){
			return [
				'status' => 400,
				'message' => 'Invalid request'
			];
		}
		if($request->secret != 'supposedtobesomerandomstring'){
			return [
				'status' => 403,
				'message' => 'Forbidden acces, secret key mismatch'
			];
		}
		try {
			$result = DB::select('call setujuiPermohonan(?,?)', array($request->kode_permohonan, $request->username));
			/*
			$email_pemohon = DB::select('SELECT email_pemohon FROM pemohon WHERE nama_pemohon = ?', array($data['nama_permohonan']));
			
			$email_pemohon = $email_pemohon[0]->email_pemohon; 
		
			$data['email_pemohon'] = $email_pemohon;
		
			Mail::send('mail.terima', ['data' => $data], function($message) use($data){
				$message->from('laboratoriumpemrograman2@gmail.com','LP2');
				$message->subject('Reservasi Laboratorium Pemrograman 2');
				$message->to($data['email_pemohon']);
			});
			*/
			return [
				'status' => 200,
				'message' => $result[0]->pesan
			];
		} catch (Exception $err){
			return [
				'status' => 500,
				'message' => $err->getMessage()
			];
		}
		
		
		
	}
}
