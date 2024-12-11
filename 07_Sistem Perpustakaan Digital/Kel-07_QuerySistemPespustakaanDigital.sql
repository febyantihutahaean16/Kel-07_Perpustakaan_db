-- Database: Perpustakaan_Kel-07_SBD

-- DROP DATABASE IF EXISTS "Perpustakaan_Kel-07_SBD";

CREATE DATABASE "Perpustakaan_Kel-07_SBD"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United;/ States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- 3. IMPLEMENTASI
	-- 3.1 Authorization
		-- 3.1.1 Role Admin
			-- 3.1.1.1 Create Role Admin
			CREATE ROLE admin;

			-- 3.1.1.2 Memberikan hak akses untuk admin			
			-- Memberikan hak akses ALL PRIVILEGES pada skema public kepada admin
			GRANT ALL PRIVILEGES ON SCHEMA public TO admin;

		-- 3.1.2 Role Anggota
			-- 3.1.2.1 Create Role Admin
			CREATE ROLE anggota;

			-- 3.1.2.2 Memberikan hak akses untuk anggota
			GRANT SELECT, INSERT, UPDATE ON TABLE buku, log_peminjaman, log_denda TO anggota;

	-- Note 	: Set Role agar kita menjadi Admin 
	SET ROLE admin;


	-- 3.2 CREATE TABEL USER
		-- 3.2.1 Admin
			-- 3.2.1.1 Create Tabel  
			CREATE TABLE admin (
			    id SERIAL PRIMARY KEY, 
			    nama VARCHAR(255) NOT NULL,  
			    email VARCHAR(255) UNIQUE NOT NULL,  
			    password VARCHAR(255) NOT NULL,
			    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP 
			);
			
			-- 3.2.1.2 Insert Data
			INSERT INTO admin (nama, email, password)
			VALUES 
			('FebyantiHutahaean', 'feby@gmail.com', 'feby1602'),
			('VinciG.Baringbing', 'vinci@gmail.com', 'vinci2707'),
			('WindaSembiring', 'winda@gmail.com', 'winda1234'),
			('RickySilaen', 'ricky@gmail.com', 'ricky5678');
			
				-- Cek data dalam tabel
				SELECT * FROM admin;
				
			-- 3.2.1.3 Menambahkan admin yang baru diinsert ke dalam role admin
			-- jangan lupa untuk melakukan create role terlebih dahulu
			CREATE ROLE "FebyantiHutahaean";
			CREATE ROLE "VinciG.Baringbing";
			CREATE ROLE "WindaSembiring";
			CREATE ROLE "RickySilaen";
			
			-- ini untuk memberikan hak akses kepada admin
			GRANT admin TO "FebyantiHutahaean", 
							"VinciG.Baringbing",
							"WindaSembiring", 
							"RickySilaen";

		-- 3.2.2 Anggota
			-- 3.2.2.1 Create Tipe Data Alamat 
				CREATE TYPE alamat_type AS (
				    jalan VARCHAR(255),
				    kota VARCHAR(100),
				    provinsi VARCHAR(100),
				    kode_pos VARCHAR(10),
				    negara VARCHAR(100)
				);
				
			-- 3.2.2.2 Create Tabel 
			CREATE TABLE anggota (
			    id SERIAL PRIMARY KEY,  
			    nama VARCHAR(255) NOT NULL, 
			    email VARCHAR(255) UNIQUE NOT NULL,  
			    password VARCHAR(255) NOT NULL, 
			    alamat alamat_type, 
			    telepon VARCHAR(15), 
			    tanggal_daftar TIMESTAMP DEFAULT CURRENT_TIMESTAMP  
			);

			-- 3.2.2.3 Insert Data 
			INSERT INTO anggota (nama, email, password, alamat, telepon, tanggal_daftar)
			VALUES 
			('Febiola Alya Hutagalung', 'febiola@gmail.com', 'febiola123', 
			  ('Jalan Raya Toba No. 1', 'Parapat', 'Sumatera Utara', '22381', 'Indonesia'), '081234567890', CURRENT_TIMESTAMP),
			('Jessica Anastasya Purba', 'jessica.purba@gmail.com', 'jessica123', 
			  ('Jalan Toba Indah No. 5', 'Balige', 'Sumatera Utara', '22382', 'Indonesia'), '081234567891', CURRENT_TIMESTAMP),
			('Aan Kristian Sitinjak', 'aan.sitinjak@gmail.com', 'aan123', 
			  ('Jalan Sisingamangaraja No. 12', 'Toba Samosir', 'Sumatera Utara', '22383', 'Indonesia'), '081234567892', CURRENT_TIMESTAMP),
			('Ferry Bastian Siagian', 'ferry.siagian@gmail.com', 'ferry123', 
			  ('Jalan Batu Gantung No. 3', 'Sibolga', 'Sumatera Utara', '22384', 'Indonesia'), '081234567893', CURRENT_TIMESTAMP),
			('Kevin Christian B. Rumapea', 'kevin.rumapea@gmail.com', 'kevin123', 
			  ('Jalan Pintu Angin No. 9', 'Samosir', 'Sumatera Utara', '22385', 'Indonesia'), '081234567894', CURRENT_TIMESTAMP),
			('Estina Pangaribuan', 'estina.pangaribuan@gmail.com', 'estina123', 
			  ('Jalan Raya Samosir No. 2', 'Tuktuk', 'Sumatera Utara', '22386', 'Indonesia'), '081234567895', CURRENT_TIMESTAMP),
			('Valencia L Tobing', 'valencia.tobing@gmail.com', 'valencia123', 
			  ('Jalan Parapat No. 7', 'Parapat', 'Sumatera Utara', '22387', 'Indonesia'), '081234567896', CURRENT_TIMESTAMP),
			('Andri Agung Exaudi Sigiro', 'andri.sigiro@gmail.com', 'andri123', 
			  ('Jalan Danau Toba No. 8', 'Balige', 'Sumatera Utara', '22388', 'Indonesia'), '081234567897', CURRENT_TIMESTAMP),
			('Ayu Enissa Maretty Sinaga', 'ayu.sinaga@gmail.com', 'ayu123', 
			  ('Jalan Raja Sisingamangaraja No. 10', 'Ajibata', 'Sumatera Utara', '22389', 'Indonesia'), '081234567898', CURRENT_TIMESTAMP),
			('Indra Aziz Nugraha', 'indra.nugraha@gmail.com', 'indra123', 
			  ('Jalan Tuktuk No. 6', 'Samosir', 'Sumatera Utara', '22390', 'Indonesia'), '081234567899', CURRENT_TIMESTAMP),
			('Daniel Haganta Ginting', 'daniel.ginting@gmail.com', 'daniel123', 
			  ('Jalan Merdeka No. 11', 'Toba Samosir', 'Sumatera Utara', '22391', 'Indonesia'), '081234567900', CURRENT_TIMESTAMP),
			('Diva Lorenza Marbun', 'diva.marbun@gmail.com', 'diva123', 
			  ('Jalan Raya Samosir No. 15', 'Parapat', 'Sumatera Utara', '22392', 'Indonesia'), '081234567901', CURRENT_TIMESTAMP);

				-- Cek data dalam tabel
				SELECT * FROM anggota;

			-- 3.2.2.4 Menambahkan anggota yang baru diinsert ke dalam role anggota
			-- jangan lupa untuk melakukan create role terlebih dahulu
			CREATE ROLE "Febiola Alya Hutagalung";
			CREATE ROLE "Jessica Anastasya Purba";
			CREATE ROLE "Aan Kristian Sitinjak";
			CREATE ROLE "Ferry Bastian Siagian";
			CREATE ROLE "Kevin Christian B. Rumapea";
			CREATE ROLE "Estina Pangaribuan";
			CREATE ROLE "Valencia L Tobing";
			CREATE ROLE "Andri Agung Exaudi Sigiro";
			CREATE ROLE "Ayu Enissa Maretty Sinaga";
			CREATE ROLE "Indra Aziz Nugraha";
			CREATE ROLE "Daniel Haganta Ginting";
			CREATE ROLE "Diva Lorenza Marbun";
			
			GRANT anggota TO "Febiola Alya Hutagalung",
								"Jessica Anastasya Purba",
								"Aan Kristian Sitinjak",
								"Ferry Bastian Siagian",
								"Kevin Christian B. Rumapea",
								"Estina Pangaribuan",
								"Valencia L Tobing",
								"Andri Agung Exaudi Sigiro",
								"Ayu Enissa Maretty Sinaga",
								"Indra Aziz Nugraha",
								"Daniel Haganta Ginting",
								"Diva Lorenza Marbun";

	-- 3.3 CREATE TABLE 
		-- 3.3.1 Tabel Kategori
			CREATE TABLE kategori (
			    id SERIAL PRIMARY KEY,  
			    nama VARCHAR(255) NOT NULL  
			);
			
			-- Cek data dalam tabel
			SELECT * FROM kategori;
		
		-- 3.3.2 Tabel buku
		CREATE TABLE buku (
		    id SERIAL PRIMARY KEY,  
		    judul VARCHAR(255) UNIQUE NOT NULL DEFAULT 'Unknown', 
		    penulis VARCHAR(255) NOT NULL DEFAULT 'Unknown',  
		    penerbit VARCHAR(255) NOT NULL DEFAULT 'Unknown',  
		    tahunTerbit INTEGER NOT NULL DEFAULT 0,  
		    stok INT NOT NULL DEFAULT 10,  
		    kategori_id INT REFERENCES kategori(id) ON DELETE CASCADE  
		);
		
			-- Cek data dalam tabel
			SELECT * FROM buku;

		-- 3.3.3 Tabel log_peminjaman
		CREATE TABLE log_peminjaman (
		    id_peminjaman SERIAL PRIMARY KEY,  
		    anggota_id INT REFERENCES anggota(id) ON DELETE CASCADE,  
		    buku_id INT REFERENCES buku(id) ON DELETE CASCADE,  
		    tanggal_peminjaman DATE NOT NULL,  
		    tanggal_pengembalian DATE,  
		    status VARCHAR(50) CHECK (status IN ('Kembali', 'Dipinjam', 'Terlambat')), 
		    denda NUMERIC(10, 2) DEFAULT 0.00  
		);
			-- Cek data dalam tabel
			SELECT * FROM log_peminjaman;

		-- 3.3.4 Tabel log_denda
		CREATE TABLE log_denda (
		    id_denda SERIAL PRIMARY KEY,  
		    peminjaman_id INT REFERENCES log_peminjaman(id_peminjaman) ON DELETE CASCADE,  
		    jumlah_denda NUMERIC(10, 2) NOT NULL,  
		    tanggal_denda DATE NOT NULL DEFAULT CURRENT_DATE, 
		    status_pembayaran VARCHAR(20) DEFAULT 'Belum Dibayar'  
		    CHECK (status_pembayaran IN ('Belum Dibayar', 'Sudah Dibayar'))  
		);
			-- Cek data dalam tabel
			SELECT * FROM log_denda;

	-- 3.4 Insert Data (Disini kami menggunakan API Crawling, yang diimplementasikan melalui Visual Studio Code)

	-- 3.5 Create Trigger Insert Data
	
		-- 3.5.1 Tabel kategori
		
		-- 3.5.1.1 Create Function
		CREATE OR REPLACE FUNCTION cek_kategori() RETURNS TRIGGER AS $$
		BEGIN
		    IF NEW.nama = '' THEN
		        RAISE NOTICE 'Nama kategori tidak boleh kosong';
		        RETURN NULL; 
		    END IF;
		
		    IF EXISTS (SELECT 1 FROM kategori WHERE nama = NEW.nama) THEN
		        RAISE NOTICE 'Kategori dengan nama % sudah ada', NEW.nama;
		        RETURN NULL; 
		    END IF;
		    
		    RETURN NEW;
		END;
		$$ LANGUAGE plpgsql;
		
		-- 3.5.1.2 Create Trigger 
		CREATE TRIGGER before_insert_kategori
		BEFORE INSERT ON kategori
		FOR EACH ROW EXECUTE FUNCTION cek_kategori();

		
		-- 3.5.1.3 Pengujian
			-- Insert kategori kosong(gagal)
			INSERT INTO kategori (nama) VALUES ('');

				-- Memeriksa data dalam tabel
				SELECT * FROM kategori;
				
			-- Insert kategori yang sudah ada (gagal)						
			INSERT INTO kategori (nama) VALUES ('Teknologi');
			
				-- Memeriksa data dalam tabel
				SELECT * FROM kategori;

			-- Insert kategori (berhasil)	
			INSERT INTO kategori (nama) VALUES ('Komedi');
			-- Expected output: Data berhasil disisipkan tanpa peringatan
	
				-- Memeriksa data dalam tabel
				SELECT * FROM kategori;
							
	-- 3.5.2 Tabel Anggota
		
		-- 3.5.2.1 Create Function
		CREATE OR REPLACE FUNCTION cek_anggota() RETURNS TRIGGER AS $$
		BEGIN
		    
		    IF NEW.telepon IS NOT NULL AND NEW.telepon !~ '^\d{10,15}$' THEN
		        RAISE NOTICE 'Nomor telepon % tidak valid', NEW.telepon;
		        RETURN NULL; 
		    END IF;
		
		    IF EXISTS (SELECT 1 FROM anggota WHERE nama = NEW.nama) THEN
		        RAISE NOTICE 'Anggota dengan nama % sudah ada', NEW.nama;
		        RETURN NULL; 
		    END IF;
		    
		    RETURN NEW;
		END;
		$$ LANGUAGE plpgsql;
		
		-- 3.5.2.2 Create Trigger
		CREATE TRIGGER before_insert_anggota
		BEFORE INSERT ON anggota
		FOR EACH ROW EXECUTE FUNCTION cek_anggota();

		-- 3.5.2.3 Pengujian
			-- Insert nomor telpon < 10 (Gagal)
			INSERT INTO anggota (nama, alamat, telepon) VALUES ('John Doe', ('Jalan Raya Samosir No. 15', 'Parapat', 'Sumatera Utara', '22392', 'Indonesia'), '12345');
			
				-- Verifikasi tabel anggota
				SELECT * FROM anggota;
	
			-- Insert nama yang sudah ada(Gagal)
			INSERT INTO anggota (nama, email, password, alamat, telepon, tanggal_daftar)
			VALUES 
			('Febiola Alya Hutagalung', 'febiola@gmail.com', 'febiola123', 
			  ('Jalan Raya Toba No. 1', 'Parapat', 'Sumatera Utara', '22381', 'Indonesia'), '081234567890', CURRENT_TIMESTAMP);
	
				-- Verifikasi tabel anggota
				SELECT * FROM anggota;

			-- Insert anggota berhasil
			INSERT INTO anggota (nama, email, password, alamat, telepon, tanggal_daftar)
			VALUES 
			('James Tambunan', 'james@gmail.com', 'james123', 
			  ('Jalan Bunga No. 1', 'Parapat', 'Sumatera Utara', '22381', 'Indonesia'), '086521541528', CURRENT_TIMESTAMP);
	
				-- Verifikasi tabel anggota
				SELECT * FROM anggota;
	
	-- 3.5.3 Tabel Buku
		-- 3.5.3.1 Create Function
		CREATE OR REPLACE FUNCTION cek_buku() RETURNS TRIGGER AS $$
		BEGIN
		    
		    IF NEW.judul IS NULL OR NEW.judul = '' THEN
		        RAISE NOTICE 'Judul buku tidak boleh kosong';
		        RETURN NULL;
		    END IF;
		
		    IF NEW.penulis IS NULL OR NEW.penulis = '' THEN
		        RAISE NOTICE 'Penulis buku tidak boleh kosong';
		        RETURN NULL; 
		    END IF;
		
		    IF NEW.penerbit IS NULL OR NEW.penerbit = '' THEN
		        RAISE NOTICE 'Penerbit buku tidak boleh kosong';
		        RETURN NULL; 
		    END IF;
		

		    IF NEW.stok < 1 THEN
		        RAISE NOTICE 'Stok buku harus bernilai positif dan tidak 0!';
		        RETURN NULL; 
		    END IF;
			
		    IF EXISTS (
		        SELECT 1
		        FROM buku
		        WHERE judul = NEW.judul AND penulis = NEW.penulis
		    ) THEN
		        RAISE NOTICE 'Buku dengan judul % dan penulis % sudah ada', NEW.judul, NEW.penulis;
		        RETURN NULL; 
		    END IF;
		
		    RETURN NEW;
		END;
		$$ LANGUAGE plpgsql;
		
		-- 3.5.3.2 Create Trigger
		CREATE TRIGGER before_insert_buku
		BEFORE INSERT ON buku
		FOR EACH ROW EXECUTE FUNCTION cek_buku();
		
		-- 3.5.3.3 Pengujian
			-- Insert buku dengan judul kosong (Gagal)
			INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
			VALUES ('', 'John Doe', 'Publisher A', 2023, 5, 1);
			
				-- Verifikasi tabel buku
				SELECT * FROM buku;
				
			-- Insert Stok negatif (Gagal)
			INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
			VALUES ('Book A', 'John Doe', 'Publisher A', 2023, -3, 1);
	
				-- Verifikasi tabel buku
				SELECT * FROM buku;
	
			-- Insert stok 0 (Gagal)
			INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
			VALUES ('Book A', 'John Doe', 'Publisher A', 2023, 0, 1);
	
				-- Verifikasi tabel buku
				SELECT * FROM buku;
				
			-- Insert buku dengan judul dan penulis yang sama
			INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
			VALUES ('Belajar Python', 'John Smith', 'Tech Publisher', 2023, 10, 1);
	
				-- Verifikasi tabel buku
				SELECT * FROM buku;
				
			-- Insert data berhasil
			INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
			VALUES ('Pemrograman Ruby', 'Yukihiro Matsumoto', 'Tech Publisher', 2023, 8, 1);
			
				-- Verifikasi tabel buku
				SELECT * FROM buku;

	-- 3.6 Create Proses Peminjaman Buku menggunakan Trigger dan Fungsi
	
		-- 3.6.1 Create Function
		CREATE OR REPLACE FUNCTION lakukan_peminjaman() RETURNS TRIGGER AS $$
		BEGIN
		    IF NOT EXISTS (SELECT 1 FROM anggota WHERE id = NEW.anggota_id) THEN
		        RAISE EXCEPTION 'Data anggota dengan ID % tidak ditemukan', NEW.anggota_id;
		    END IF;
		
		    IF NOT EXISTS (SELECT 1 FROM buku WHERE id = NEW.buku_id) THEN
		        RAISE EXCEPTION 'Data buku dengan ID % tidak ditemukan', NEW.buku_id;
		    END IF;
		
		    IF (SELECT stok FROM buku WHERE id = NEW.buku_id) <= 0 THEN
		        RAISE EXCEPTION 'Stok buku tidak mencukupi untuk peminjaman';
		    END IF;
		
		    UPDATE buku
		    SET stok = stok - 1
		    WHERE id = NEW.buku_id;
		
		    NEW.status := 'Dipinjam';
		    NEW.tanggal_pengembalian := NEW.tanggal_peminjaman + INTERVAL '7 days';
		
		    RETURN NEW;
		END;
		$$ LANGUAGE plpgsql;

		-- 3.6.2 Create Trigger
		CREATE TRIGGER peminjaman_trigger
		BEFORE INSERT ON log_peminjaman
		FOR EACH ROW
		EXECUTE FUNCTION lakukan_peminjaman();

		
		-- 3.6.3 Pengujian 
			
			-- Lakukan peminjaman dengan ID anggota yang tidak tersedia (Gagal)
			INSERT INTO log_peminjaman (anggota_id, buku_id, tanggal_peminjaman)
			VALUES (999, 1, CURRENT_DATE);
			
				-- Memeriksa data dalam tabel
				SELECT * FROM log_peminjaman;
			
			-- Lakukan peminjaman dengan ID buku yang tidak tersedia (Gagal)
			INSERT INTO log_peminjaman (anggota_id, buku_id, tanggal_peminjaman)
			VALUES (1, 500000, CURRENT_DATE);
			
				-- Memeriksa data dalam tabel
				SELECT * FROM log_peminjaman;
			
			-- Lakukan peminjaman dengan Stok Buku Tidak Cukup (Gagal)
			UPDATE buku SET stok = 0 WHERE id = 1;
			INSERT INTO log_peminjaman (anggota_id, buku_id, tanggal_peminjaman)
			VALUES (1, 1, CURRENT_DATE);
			
				-- Memeriksa data dalam tabel
				SELECT * FROM log_peminjaman;
			
			-- Lakukan peminjaman berhasil
			INSERT INTO log_peminjaman (anggota_id, buku_id, tanggal_peminjaman)
			VALUES (3, 2, CURRENT_DATE);
			
				-- Memeriksa data dalam tabel
				SELECT * FROM log_peminjaman;
	

	-- 3.7 Create Proses Pengembalian Buku menggunakan Transaksi Manual

		-- 3.7.1 Create Transaction
		CREATE OR REPLACE FUNCTION proses_pengembalian_transaksi(
		    p_id_peminjaman INT, 
		    p_tanggal_pengembalian DATE
		) RETURNS VOID AS $$
		DECLARE
		    batas_pengembalian DATE;
		    lama_terlambat INT;
		    jumlah_denda NUMERIC(10, 2);
		    current_status TEXT;
		BEGIN
		    SELECT status INTO current_status
		    FROM log_peminjaman
		    WHERE id_peminjaman = p_id_peminjaman;
		
		    IF NOT FOUND THEN
		        RAISE EXCEPTION 'Peminjaman dengan ID % tidak ditemukan', p_id_peminjaman;
		    END IF;
		
		    IF current_status = 'Kembali' OR current_status = 'Terlambat' THEN
		        RAISE NOTICE 'Pengembalian tidak dapat diproses. Status saat ini: %.', current_status;
		        RETURN;
		    END IF;
		
		    SELECT tanggal_peminjaman + INTERVAL '7 days' INTO batas_pengembalian
		    FROM log_peminjaman WHERE id_peminjaman = p_id_peminjaman;
		
		    lama_terlambat := GREATEST((p_tanggal_pengembalian - batas_pengembalian)::INTEGER, 0);
		
		    IF p_tanggal_pengembalian <= batas_pengembalian THEN
		        UPDATE log_peminjaman
		        SET status = 'Kembali', tanggal_pengembalian = p_tanggal_pengembalian
		        WHERE id_peminjaman = p_id_peminjaman;
		    ELSE
		        jumlah_denda := lama_terlambat * 2000;
		        UPDATE log_peminjaman
		        SET status = 'Terlambat', tanggal_pengembalian = p_tanggal_pengembalian, denda = jumlah_denda
		        WHERE id_peminjaman = p_id_peminjaman;
		
		        INSERT INTO log_denda (peminjaman_id, jumlah_denda)
		        VALUES (p_id_peminjaman, jumlah_denda);
		    END IF;
		
		    UPDATE buku
		    SET stok = stok + 1
		    WHERE id = (SELECT buku_id FROM log_peminjaman WHERE id_peminjaman = p_id_peminjaman);
		
		    RAISE NOTICE 'Pengembalian berhasil diproses. Status: %, Denda: %',
		        CASE WHEN p_tanggal_pengembalian <= batas_pengembalian THEN 'Kembali' ELSE 'Terlambat' END,
		        COALESCE(jumlah_denda, 0);
		END;
		$$ LANGUAGE plpgsql;

	
		-- 3.7.2 Pengujian 
			-- Lakukan pengembalian lebih awal
			select proses_pengembalian_transaksi(6, '2024-12-13');
		
				-- Memeriksa isi data dalam tabel
				SELECT * FROM log_peminjaman;
				
			-- Lakukan pengembalian tepat waktu
			select proses_pengembalian_transaksi(6, '2024-12-17');
		
				-- Memeriksa isi data dalam tabel
				SELECT * FROM log_peminjaman;
				
			-- Lakukan pengembalian terlambat
			select proses_pengembalian_transaksi(3, '2024-12-18');
		
				-- Memeriksa isi data dalam tabel
				SELECT * FROM log_peminjaman;
	
	
	-- 3.8 Proses Pembayaran Denda menggunakan Transaksi Manual
		-- 3.8.1 Create transaction
		CREATE OR REPLACE FUNCTION proses_pembayaran_denda(
		    p_id_denda INT
		) RETURNS VOID AS $$
		DECLARE
		    current_status_pembayaran VARCHAR(20);
		BEGIN
		    SELECT status_pembayaran INTO current_status_pembayaran
		    FROM log_denda
		    WHERE id_denda = p_id_denda;
		
		    IF NOT FOUND THEN
		        RAISE EXCEPTION 'Denda dengan ID % tidak ditemukan', p_id_denda;
		    END IF;
		
		    IF current_status_pembayaran = 'Sudah Dibayar' THEN
		        RAISE NOTICE 'Denda dengan ID % sudah dibayar sebelumnya.', p_id_denda;
		        RETURN;
		    END IF;
		
		    UPDATE log_denda
		    SET status_pembayaran = 'Sudah Dibayar'
		    WHERE id_denda = p_id_denda;
		
		    RAISE NOTICE 'Pembayaran denda dengan ID % berhasil diproses. Status: Sudah Dibayar', p_id_denda;
		END;
		$$ LANGUAGE plpgsql;

	
		-- 3.8.2 Pengujian
			-- Lakukan bayar denda dengan Id  tidak ditemukan(Gagal)
			SELECT proses_pembayaran_denda(8);
			
				-- Memeriksa isi data dalam tabel
				SELECT * FROM log_denda;
	
			-- Lakukan bayar denda(Berhasil)
			SELECT proses_pembayaran_denda(2);
			
				-- Memeriksa isi data dalam tabel
				SELECT * FROM log_denda;
	

	-- 3.9 Create Tabel Laporan 
		-- 3.9.1 Tabel laporan jumlah denda peminjaman setiap anggota
			-- 3.9.1.1 Create View
			CREATE VIEW anggota_peminjaman_denda AS
			SELECT
			    a.id AS anggota_id,
			    a.nama AS nama_anggota,
			    b.judul AS judul_buku,
			    lp.tanggal_peminjaman,
			    lp.tanggal_pengembalian,
			    lp.status AS status_peminjaman,
			    COALESCE(ld.jumlah_denda, 0.00) AS jumlah_denda,
			    COALESCE(ld.status_pembayaran, 'Belum Dibayar') AS status_denda  
			FROM
			    anggota a
			JOIN
			    log_peminjaman lp ON a.id = lp.anggota_id
			JOIN
			    buku b ON lp.buku_id = b.id
			LEFT JOIN
			    log_denda ld ON lp.id_peminjaman = ld.peminjaman_id;
		
			-- 3.9.1.2 Menampilkan hasil tabel laporan
			SELECT * FROM anggota_peminjaman_denda;
	
	
		-- 3.9.2 Tabel laporan buku paling sering dipinjam per-tahun
			-- 3.9.2.1 Create View
			CREATE VIEW laporan_buku_per_tahun AS
			SELECT 
			    b.judul, 
			    b.penulis, 
			    b.penerbit, 
			    b.tahunTerbit, 
			    EXTRACT(YEAR FROM lp.tanggal_peminjaman) AS tahun,  
			    lp.status,  
			    COUNT(lp.id_peminjaman) AS jumlah_peminjaman
			FROM 
			    buku b
			JOIN 
			    log_peminjaman lp ON b.id = lp.buku_id
			GROUP BY 
			    b.id, b.judul, b.penulis, b.penerbit, b.tahunTerbit, tahun, lp.status
			ORDER BY 
			    jumlah_peminjaman DESC, tahun DESC, lp.status DESC;
			
			-- 3.9.2.2 Menampilkan hasil tabel laporan 
				SELECT * FROM laporan_buku_per_tahun;
		
		
		-- 3.9.3 Tabel laporan buku paling sering dipinjam per-bulan
			-- 3.9.3.1 Create View
			CREATE VIEW laporan_buku_per_bulan AS
			SELECT 
			    b.judul, 
			    b.penulis, 
			    b.penerbit, 
			    b.tahunTerbit, 
			    DATE_TRUNC('month', lp.tanggal_peminjaman) AS bulan,  
			    lp.status,  
			    COUNT(lp.id_peminjaman) AS jumlah_peminjaman
			FROM 
			    buku b
			JOIN 
			    log_peminjaman lp ON b.id = lp.buku_id
			GROUP BY 
			    b.id, b.judul, b.penulis, b.penerbit, b.tahunTerbit, bulan, lp.status
			ORDER BY 
			    jumlah_peminjaman DESC, bulan DESC, lp.status DESC;
			
			-- 3.9.3.2 Menampilkan hasil tabel laporan 
			SELECT * FROM laporan_buku_per_bulan;
		

		-- 3.9.4 Tabel laporan buku paling sering dipinjam per-minggu
			-- 3.9.4.1 Create View
			CREATE VIEW laporan_buku_per_minggu AS
			SELECT 
			    b.judul, 
			    b.penulis, 
			    b.penerbit, 
			    b.tahunTerbit, 
			    DATE_TRUNC('week', lp.tanggal_peminjaman) AS minggu,  
			    lp.status,  
			    COUNT(lp.id_peminjaman) AS jumlah_peminjaman
			FROM 
			    buku b
			JOIN 
			    log_peminjaman lp ON b.id = lp.buku_id
			GROUP BY 
			    b.id, b.judul, b.penulis, b.penerbit, b.tahunTerbit, minggu, lp.status
			ORDER BY 
			    jumlah_peminjaman DESC, minggu DESC, lp.status DESC;
				
			-- 3.9.4.2 Menampilkan hasil tabel laporan buku
				SELECT * FROM laporan_buku_per_minggu;
		
		
	-- 3.10 Stored Procedure untuk Laporan buku paling sering dibaca 
		-- 3.10.1 Create Stored Procedure
			CREATE OR REPLACE PROCEDURE laporan_buku_terpopuler(
			    IN tanggal_mulai DATE,
			    IN tanggal_akhir DATE
			)
			LANGUAGE plpgsql
			AS $$
			BEGIN
			    RAISE NOTICE 'Laporan Buku Paling Sering Dipinjam (% - %)', tanggal_mulai, tanggal_akhir;
			
			    -- Masukkan hasil ke tabel sementara
			    CREATE TEMP TABLE temp_laporan_buku AS
			    SELECT 
			        b.judul, 
			        COUNT(lp.id_peminjaman) AS total_peminjaman
			    FROM 
			        buku b
			    JOIN 
			        log_peminjaman lp ON b.id = lp.buku_id
			    WHERE 
			        lp.tanggal_peminjaman BETWEEN tanggal_mulai AND tanggal_akhir
			    GROUP BY 
			        b.judul
			    ORDER BY 
			        total_peminjaman DESC
			    LIMIT 10;
			
			    RAISE NOTICE 'Laporan berhasil dibuat. Data tersedia di tabel sementara temp_laporan_buku.';
			END;
			$$;


		-- 3.10.2 Memanggil laporan buku terpopuler
			CALL laporan_buku_terpopuler('2024-01-01', '2024-01-31');
			

	-- 3.11 Cursor untuk Laporan buku paling sering dibaca 
		-- 3.11.1 Create cursor
		CREATE OR REPLACE PROCEDURE laporan_buku_populer()
		LANGUAGE plpgsql
		AS $$
		DECLARE
		    cur_populer CURSOR FOR
		        SELECT 
		            b.id, 
		            b.judul, 
		            COUNT(p.buku_id) AS total_peminjaman
		        FROM 
		            buku b
		        LEFT JOIN 
		            log_peminjaman p ON b.id = p.buku_id
		        GROUP BY 
		            b.id, b.judul
		        ORDER BY 
		            total_peminjaman DESC;
		
		    buku_id INTEGER;
		    buku_judul TEXT;
		    total_pinjam INTEGER;
		BEGIN
		    OPEN cur_populer;
		
		    RAISE NOTICE 'ID Buku | Judul Buku | Total Peminjaman';
		
		    LOOP
		        FETCH cur_populer INTO buku_id, buku_judul, total_pinjam;
		        EXIT WHEN NOT FOUND;
		        RAISE NOTICE '% | % | %', buku_id, buku_judul, total_pinjam;
		    END LOOP;
		
		    CLOSE cur_populer;
		END;
		$$;

	
		-- 3.11.2 Memanggil laporan buku terpopuler	
		CALL laporan_buku_populer();


	-- 3.12 Backup/Restore
		-- 3.12.1 Perintah Backup
		pg_dump -U postgres -d Perpustakaan_Kel-07_SBD -F c -f 
		"C:\Semester3\SBD\PROYEK\07_Sistem Perpustakaan Digital\07_BackupRestoreSistemPerpustakaanDigital.backup"

		-- 3.12.2 Perintah Restore
		pg_dump -U postgres -d Perpustakaan_Kel-07_SBD -F c -f 
		"C:\Semester3\SBD\PROYEK\07_Sistem Perpustakaan Digital\07_BackupRestoreSistemPerpustakaanDigital.backup"

	-- 3.13 Fitur Mencari Buku
		-- 3.12.1 Create View
		CREATE OR REPLACE FUNCTION cari_buku(judul_buku VARCHAR)
		RETURNS TABLE (
		    id INTEGER,
		    judul VARCHAR,
		    penulis VARCHAR,
		    penerbit VARCHAR,
		    tahunTerbit INTEGER,
		    stok INTEGER,
		    kategori_id INTEGER
		) AS $$
		BEGIN
		    RETURN QUERY
		    SELECT b.id, b.judul, b.penulis, b.penerbit, b.tahunTerbit, b.stok, b.kategori_id
		    FROM buku b
		    WHERE b.judul ILIKE '%' || judul_buku || '%'; 
		END;
		$$ LANGUAGE plpgsql;


		-- 3.12.2 Pengujian
		SELECT * FROM cari_buku('art');
