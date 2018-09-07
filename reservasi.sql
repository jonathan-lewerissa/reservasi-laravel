/*
SQLyog Ultimate v8.6 Beta2
MySQL - 5.6.21 : Database - reservasi_beta
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
/*Table structure for table `admin` */

DROP TABLE IF EXISTS `admin`;

CREATE TABLE `admin` (
  `username_admin` varchar(100) NOT NULL,
  `password_admin` varchar(128) NOT NULL,
  PRIMARY KEY (`username_admin`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `admin_permohonan` */

DROP TABLE IF EXISTS `admin_permohonan`;

CREATE TABLE `admin_permohonan` (
  `username_admin_antara` varchar(30) DEFAULT NULL,
  `kode_permohonan_antara` varchar(17) NOT NULL,
  PRIMARY KEY (`kode_permohonan_antara`),
  KEY `FK_admin_permohonan` (`username_admin_antara`),
  CONSTRAINT `FK_admin_permohonan` FOREIGN KEY (`username_admin_antara`) REFERENCES `admin` (`username_admin`) ON UPDATE CASCADE,
  CONSTRAINT `FK_admin_permohonan_permohonan` FOREIGN KEY (`kode_permohonan_antara`) REFERENCES `daftar_permohonan` (`kode_permohonan`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `aktivitas` */

DROP TABLE IF EXISTS `aktivitas`;

CREATE TABLE `aktivitas` (
  `catatan_aktivitas` varchar(100) NOT NULL,
  `waktu_aktivitas` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `username_aktivitas` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`waktu_aktivitas`),
  KEY `FK_aktivitas` (`username_aktivitas`),
  CONSTRAINT `FK_aktivitas` FOREIGN KEY (`username_aktivitas`) REFERENCES `admin` (`username_admin`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `daftar_permohonan` */

DROP TABLE IF EXISTS `daftar_permohonan`;

CREATE TABLE `daftar_permohonan` (
  `nama_pemohon_peminjaman` varchar(100) NOT NULL,
  `kode_permohonan` varchar(17) NOT NULL,
  `status_permohonan` varchar(20) NOT NULL DEFAULT 'Diproses',
  `nama_kegiatan` varchar(200) NOT NULL,
  `tanggal_masuk_permohonan` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `tanggal_mulai_permohonan_peminjaman` date NOT NULL,
  `waktu_mulai_permohonan_peminjaman` time NOT NULL,
  `waktu_selesai_permohonan_peminjaman` time NOT NULL,
  `badan_pelaksana_kegiatan` varchar(100) NOT NULL,
  `nama_ruangan` varchar(100) NOT NULL,
  `rutinitas_peminjaman` int(11) NOT NULL,
  `kali_peminjaman` int(11) NOT NULL,
  PRIMARY KEY (`kode_permohonan`),
  KEY `FK_daftar_permohonan` (`nama_pemohon_peminjaman`),
  KEY `FK_daftar_permohonan_ruangan` (`nama_ruangan`),
  KEY `FK_daftar_permohonan_rutinitas` (`rutinitas_peminjaman`),
  CONSTRAINT `FK_daftar_permohonan` FOREIGN KEY (`nama_pemohon_peminjaman`) REFERENCES `pemohon` (`nama_pemohon`) ON UPDATE CASCADE,
  CONSTRAINT `FK_daftar_permohonan_ruangan` FOREIGN KEY (`nama_ruangan`) REFERENCES `ruangan` (`nama_ruangan`) ON UPDATE CASCADE,
  CONSTRAINT `FK_daftar_permohonan_rutinitas` FOREIGN KEY (`rutinitas_peminjaman`) REFERENCES `rutinitas` (`frekwensi_rutinitas`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `info_center` */

DROP TABLE IF EXISTS `info_center`;

CREATE TABLE `info_center` (
  `no_info` int(11) NOT NULL AUTO_INCREMENT,
  `info_info` varchar(300) NOT NULL,
  PRIMARY KEY (`no_info`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=latin1;

/*Table structure for table `pemohon` */

DROP TABLE IF EXISTS `pemohon`;

CREATE TABLE `pemohon` (
  `nama_pemohon` varchar(100) NOT NULL,
  `nomor_telepon_pemohon` varchar(14) DEFAULT NULL,
  `email_pemohon` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`nama_pemohon`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `ruangan` */

DROP TABLE IF EXISTS `ruangan`;

CREATE TABLE `ruangan` (
  `nama_ruangan` varchar(100) NOT NULL,
  PRIMARY KEY (`nama_ruangan`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*Table structure for table `rutinitas` */

DROP TABLE IF EXISTS `rutinitas`;

CREATE TABLE `rutinitas` (
  `frekwensi_rutinitas` int(11) NOT NULL AUTO_INCREMENT,
  `keterangan_rutinitas` varchar(15) NOT NULL,
  PRIMARY KEY (`frekwensi_rutinitas`)
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=latin1;

/*Table structure for table `waktu_kegiatan` */

DROP TABLE IF EXISTS `waktu_kegiatan`;

CREATE TABLE `waktu_kegiatan` (
  `kode_permohonan` varchar(17) NOT NULL,
  `waktu_mulai_kegiatan` time NOT NULL,
  `tanggal_kegiatan` date NOT NULL,
  `waktu_selesai_kegiatan` time NOT NULL,
  `nama_ruangan` varchar(100) NOT NULL,
  UNIQUE KEY `waktu_mulai_kegiatan` (`waktu_mulai_kegiatan`,`tanggal_kegiatan`,`nama_ruangan`),
  KEY `FK_waktu_kegiatan_ruangan` (`nama_ruangan`),
  KEY `FK_waktu_kegiatan` (`kode_permohonan`),
  CONSTRAINT `FK_waktu_kegiatan` FOREIGN KEY (`kode_permohonan`) REFERENCES `daftar_permohonan` (`kode_permohonan`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/* Procedure structure for procedure `gantiPasswordAdmin` */

/*!50003 DROP PROCEDURE IF EXISTS  `gantiPasswordAdmin` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `gantiPasswordAdmin`(passwordLama varchar(32), passwordBaru varchar(32), usernameAdmin varchar(20))
BEGIN
	start transaction;
	set @pass = (select password_admin from admin where username_admin=usernameAdmin);
	if(@pass = md5(passwordLama))
	then
		update admin
		set password_admin = md5(passwordBaru)
		where username_admin = usernameAdmin;
		insert into aktivitas(catatan_aktivitas, username_aktivitas)
		values(concat(usernameAdmin,' mengganti password'), usernameAdmin);
		select 'Password berhasil diganti' as message;
	else
		select 'Password salah' as message;
		INSERT INTO aktivitas(catatan_aktivitas, username_aktivitas)
		VALUES(concat(usernameAdmin,' gagal mengganti password'), usernameAdmin);
	end if;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `hapusPeminjaman` */

/*!50003 DROP PROCEDURE IF EXISTS  `hapusPeminjaman` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `hapusPeminjaman`(kodePinjam varchar(17), userAdmin varchar(100))
BEGIN
	start transaction;
	delete from waktu_kegiatan
	where kode_permohonan = kodePinjam and tanggal_kegiatan >= curdate();
	update daftar_permohonan
	set status_permohonan = 'Dihapus'
	where kode_permohonan=kodePinjam;
	insert into aktivitas(catatan_aktivitas, username_aktivitas)
	value(concat('Admin ',userAdmin,' menghapus jadwal dengan kode ',kodePinjam),userAdmin);
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `isiPemohon` */

/*!50003 DROP PROCEDURE IF EXISTS  `isiPemohon` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `isiPemohon`(nama varchar(100), telepon varchar(14), email varchar(100))
BEGIN
	IF(nama NOT IN (SELECT nama_pemohon FROM pemohon))
	THEN
		INSERT INTO pemohon(nama_pemohon, nomor_telepon_pemohon, email_pemohon)
		VALUES (nama, telepon, email);
	ELSE
		UPDATE pemohon
		SET nomor_telepon_pemohon=telepon, email_pemohon=email
		WHERE nama = nama_pemohon;
	END IF;
END */$$
DELIMITER ;

/* Procedure structure for procedure `isiPermohonan` */

/*!50003 DROP PROCEDURE IF EXISTS  `isiPermohonan` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `isiPermohonan`(namaPemohon varchar(30),
						namaKegiatan varchar(160),
						tanggalMulai date,
						waktuMulai time,
						waktuSelesai time,
						badanPelaksana varchar(60),
						namaRuangan varchar(100),
						rutinitas int,
						kaliPinjam int)
BEGIN
	start transaction;
	set @iter = 0;
	set @flag = 1;
	set @tanggal = tanggalMulai;
	iniLoop:while @iter<kaliPinjam
	do
		IF(SELECT 1 FROM waktu_kegiatan WHERE
			tanggal_kegiatan = @tanggal
			AND 
			nama_ruangan = namaRuangan
			AND
			(
			(waktu_mulai_kegiatan>=waktuMulai AND waktu_mulai_kegiatan<=waktuSelesai)
			OR
			(waktu_selesai_kegiatan>=waktuMulai AND waktu_selesai_kegiatan<=waktuSelesai)
			OR
			(waktu_mulai_kegiatan<=waktuMulai AND waktu_selesai_kegiatan>=waktuSelesai)
			)
			= 1)
		THEN
			SET @flag=0;
			LEAVE iniLoop;
		ELSE
			SET @iter=@iter+1;
			SET @tanggal = DATE_ADD(@tanggal, INTERVAL @rutinitas DAY);
		END IF;
	end while;
	if(@flag=1)
	then
		set @uid = uuid_short();
		insert into daftar_permohonan (nama_pemohon_peminjaman,
						kode_permohonan,
						nama_kegiatan,
						tanggal_mulai_permohonan_peminjaman,
						waktu_mulai_permohonan_peminjaman,
						waktu_selesai_permohonan_peminjaman,
						badan_pelaksana_kegiatan,
						nama_ruangan,
						rutinitas_peminjaman,
						kali_peminjaman)
				values (namaPemohon,
					@uid,
					namaKegiatan,
					tanggalMulai,
					waktuMulai,
					waktuSelesai,
					badanPelaksana,
					namaRuangan,
					rutinitas,
					kaliPinjam);
		select 1 as 'pesan', @uid as 'Kode_Pemesanan';
	else
		select 0 as 'pesan';
	end if;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lihatKegiatan` */

/*!50003 DROP PROCEDURE IF EXISTS  `lihatKegiatan` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lihatKegiatan`(namaRuangan varchar(100), tanggal date)
BEGIN
	select nama_kegiatan, waktu_mulai_permohonan_peminjaman as 'waktu_mulai', waktu_selesai_permohonan_peminjaman as 'waktu_selesai'
	from daftar_permohonan
	where nama_ruangan = namaRuangan and kode_permohonan in
	(select kode_permohonan
	from waktu_kegiatan
	where tanggal_kegiatan=tanggal) order by waktu_mulai ASC;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lihatKegiatanBerikut` */

/*!50003 DROP PROCEDURE IF EXISTS  `lihatKegiatanBerikut` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lihatKegiatanBerikut`(namaRuangan varchar(100))
BEGIN
	SELECT dp.nama_kegiatan, dp.waktu_mulai_permohonan_peminjaman, dp.waktu_selesai_permohonan_peminjaman
	FROM daftar_permohonan dp
	WHERE(
	SELECT wk.kode_permohonan 
	FROM waktu_kegiatan wk
	WHERE wk.waktu_mulai_kegiatan > CURTIME() AND wk.tanggal_kegiatan = CURDATE() AND wk.nama_ruangan = namaRuangan ORDER BY wk.waktu_mulai_kegiatan ASC LIMIT 1) = dp.kode_permohonan;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `lihatKegiatanSekarang` */

/*!50003 DROP PROCEDURE IF EXISTS  `lihatKegiatanSekarang` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `lihatKegiatanSekarang`(namaRuangan varchar(100))
BEGIN
	SELECT dp.nama_kegiatan, dp.waktu_mulai_permohonan_peminjaman, dp.waktu_selesai_permohonan_peminjaman
	FROM daftar_permohonan dp
	WHERE (
	SELECT wk.kode_permohonan
	FROM waktu_kegiatan wk
	WHERE wk.waktu_mulai_kegiatan <= CURTIME() AND wk.waktu_selesai_kegiatan >= CURTIME() AND wk.tanggal_kegiatan= CURDATE() AND wk.nama_ruangan =namaRuangan) = dp.kode_permohonan;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `loginAdmin` */

/*!50003 DROP PROCEDURE IF EXISTS  `loginAdmin` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `loginAdmin`(adminName varchar(100), adminPass varchar(128))
BEGIN
	if((select 1 from admin where username_admin = adminName and password_admin = md5(adminPass)) = 1)
	then
		select 1 as 'pesan';
	else
		select 0 as 'pesan';
	end if;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `setujuiPermohonan` */

/*!50003 DROP PROCEDURE IF EXISTS  `setujuiPermohonan` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `setujuiPermohonan`(	kodePermohonan varchar(17),
							userAdmin varchar(100))
BEGIN
	set @tanggalMulaiKegiatan = (select tanggal_mulai_permohonan_peminjaman from daftar_permohonan where kode_permohonan=kodePermohonan);
	SET @waktuMulai = (SELECT waktu_mulai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=kodePermohonan);
	SET @waktuSelesai = (SELECT waktu_selesai_permohonan_peminjaman FROM daftar_permohonan WHERE kode_permohonan=kodePermohonan);
	SET @rutinitas = (SELECT rutinitas_peminjaman FROM daftar_permohonan WHERE kode_permohonan=kodePermohonan);
	set @kaliPinjam = (SELECT kali_peminjaman FROM daftar_permohonan WHERE kode_permohonan=kodePermohonan);
	SET @ruangan = (SELECT nama_ruangan FROM daftar_permohonan WHERE kode_permohonan=kodePermohonan);
	set @iterasi = 0;
	set @tanggal = @tanggalMulaiKegiatan;
	set @flag = 1;
	
	CekLoop: while @iterasi<@kaliPinjam
	do
		if(select 1 from waktu_kegiatan where
			tanggal_kegiatan = @tanggal
			and 
			nama_ruangan = @ruangan
			and
			(
			(waktu_mulai_kegiatan>=@waktuMulai and waktu_mulai_kegiatan<=@waktuSelesai)
			or
			(waktu_selesai_kegiatan>=@waktuMulai and waktu_selesai_kegiatan<=@waktuSelesai)
			or
			(waktu_mulai_kegiatan<=@waktuMulai and waktu_selesai_kegiatan>=@waktuSelesai)
			)
			= 1)
		then
			SET @flag=0;
			LEAVE CekLoop;
		else
			SET @iterasi=@iterasi+1;
			SET @tanggal = DATE_ADD(@tanggal, INTERVAL @rutinitas DAY);
		end if;
	end while;
	set @tanggal=@tanggalMulaiKegiatan;
	set @iterasi=0;
	start transaction;
	if(@flag=1)
	then
		InsertLoop:while @iterasi<@kaliPinjam
		do
			insert into waktu_kegiatan (kode_permohonan, waktu_mulai_kegiatan, tanggal_kegiatan, waktu_selesai_kegiatan, nama_ruangan)
			values (kodePermohonan, @waktuMulai, @tanggal, @waktuSelesai, @ruangan);
			set @iterasi = @iterasi+1;
			set @tanggal = date_add(@tanggal, interval @rutinitas day);
		end while;
			
		update daftar_permohonan
		set status_permohonan = 'Disetujui'
		where kode_permohonan = kodePermohonan;
		
		insert into admin_permohonan(username_admin_antara, kode_permohonan_antara)
		values(userAdmin, kodePermohonan);
		
		insert into aktivitas (catatan_aktivitas, username_aktivitas)
		values (concat(userAdmin,' menyetujui permohonan dengan kode ', kodePermohonan), userAdmin);
		
		select 'Permohonan pemesanan telah disetujui.' as 'pesan', 1 as 'status';
	else
		select 'Permohonan tidak dapat disetujui karena pada waktu yang sama ada kegiatan lain.' as 'pesan', 0 as 'status';
	end if;
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `tambahInfo` */

/*!50003 DROP PROCEDURE IF EXISTS  `tambahInfo` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahInfo`(teksInfo varchar(300), userAdmin varchar(100))
BEGIN
	start transaction;
	insert into info_center(info_info)
	values(teksInfo);
	insert into aktivitas(catatan_aktivitas, username_aktivitas)
	values(concat(userAdmin," menulis ", teksInfo, " ke dalam info center."), userAdmin);
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `tambahRutinitas` */

/*!50003 DROP PROCEDURE IF EXISTS  `tambahRutinitas` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `tambahRutinitas`(frekwensi int, keterangan varchar(15), adminName varchar(100))
BEGIN
	start transaction;
	insert into rutinitas(frekwensi_rutinitas, keterangan_rutinitas)
	values (frekwensi, keterangan)
	on duplicate key update keterangan_rutinitas=keterangan;
	
	insert into aktivitas (catatan_aktivitas, username_aktivitas)
	values (concat(adminName, ' menambahkan frekwensi rutinitas baru'), adminName);
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `tolakPermohonan` */

/*!50003 DROP PROCEDURE IF EXISTS  `tolakPermohonan` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `tolakPermohonan`(userAdmin varchar(100), kodePermohonan varchar(17))
BEGIN
    start transaction;
	update daftar_permohonan
	set status_permohonan = 'Ditolak'
	where kode_permohonan = kodePermohonan;
	
	insert into aktivitas(catatan_aktivitas, username_aktivitas)
	values(concat(userAdmin, ' menolak permohonan dengan kode ', kodePermohonan), userAdmin);
	
	insert into admin_permohonan(username_admin_antara, kode_permohonan_antara)
	values(userAdmin, kodePermohonan);
	SELECT 'Berhasil' AS 'Pesan';
	commit;
    END */$$
DELIMITER ;

/* Procedure structure for procedure `updatePeminjaman` */

/*!50003 DROP PROCEDURE IF EXISTS  `updatePeminjaman` */;

DELIMITER $$

/*!50003 CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePeminjaman`(userAdmin varchar(100),
						kodePermohonan varchar(17),
						namaKegiatan VARCHAR(160),
						tanggalMulai DATE,
						waktuMulai TIME,
						waktuSelesai TIME,
						namaRuangan VARCHAR(100),
						rutinitas INT,
						kaliPinjam INT)
BEGIN
	start transaction;
	SET @telahselesai = (SELECT COUNT(*) FROM waktu_kegiatan WHERE kode_permohonan=kodePermohonan AND (tanggal_kegiatan<CURDATE()));
	SET @iter = 0;
	SET @flag = 1;
	SET @tanggal = tanggalMulai;
	
	DELETE FROM waktu_kegiatan
	WHERE kode_permohonan = kodePermohonan AND tanggal_kegiatan >= CURDATE();
	
	ffTangga:while @iter<@telahselesai
	do
		SET @tanggal = DATE_ADD(@tanggal, INTERVAL rutinitas DAY);
		set @iter = @iter+1;
	end while;
	set @tanggalMulaiRevisi = @tanggal;
	iniLoop:WHILE @iter<kaliPinjam
	DO
		IF(SELECT 1 FROM waktu_kegiatan WHERE
			tanggal_kegiatan = @tanggal
			AND 
			nama_ruangan = namaRuangan
			AND
			(
			(waktu_mulai_kegiatan>=waktuMulai AND waktu_mulai_kegiatan<=waktuSelesai)
			OR
			(waktu_selesai_kegiatan>=waktuMulai AND waktu_selesai_kegiatan<=waktuSelesai)
			OR
			(waktu_mulai_kegiatan<=waktuMulai AND waktu_selesai_kegiatan>=waktuSelesai)
			)
			= 1)
		THEN
			SET @flag=0;
			LEAVE iniLoop;
		ELSE
			SET @iter=@iter+1;
			SET @tanggal = DATE_ADD(@tanggal, INTERVAL rutinitas DAY);
		END IF;
	END WHILE;
	IF(@flag=1)
	THEN
		update daftar_permohonan
		set 	nama_kegiatan = namaKegiatan,
			tanggal_mulai_permohonan_peminjaman = tanggalMulai,
			waktu_mulai_permohonan_peminjaman = waktuMulai,
			waktu_selesai_permohonan_peminjaman = waktuSelesai,
			nama_ruangan = namaRuangan,
			rutinitas_peminjaman = rutinitas,
			kali_peminjaman = kaliPinjam
		where kode_permohonan = kodePermohonan;
		
		set @iter = @telahselesai;
		set @tanggal = @tanggalMulaiRevisi;
		
		loopIsiUpdate:while @iter<kaliPinjam
		do
			insert into waktu_kegiatan(kode_permohonan, waktu_mulai_kegiatan, tanggal_kegiatan, waktu_selesai_kegiatan, nama_ruangan)
			values(kodePermohonan, waktuMulai, @tanggal, waktuSelesai, namaRuangan);
			set @iter=@iter+1;
			SET @tanggal = DATE_ADD(@tanggal, INTERVAL rutinitas DAY);
		end while;
		insert into aktivitas(catatan_aktivitas, username_aktivitas)
		value(concat(userAdmin,' mengubah peminjaman ', kodePermohonan), userAdmin);
		
		select 1 as 'pesan';
		commit;
	else
		select 0 as 'pesan';
		rollback;
	end if;
    END */$$
DELIMITER ;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
