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

SELECT usename AS username, usesysid, usecreatedb, usesuper, valuntil AS expiry
FROM pg_user;



-- 1. CREATE TABLE 
	-- Membuat tabel kategori untuk menyimpan jenis buku yang tersedia
	CREATE TABLE kategori (
	    id SERIAL PRIMARY KEY,  -- Kolom ID kategori
	    nama VARCHAR(255) NOT NULL  -- Kolom nama kategori buku
	);

		-- Menambahkan data dummy ke dalam tabel kategori
		INSERT INTO kategori (nama) VALUES
		('Teknologi'),
		('Sastra'), 
		('Pendidikan'),
		('Sejarah'),
		('Fiksi'),
		('Biografi'),
		('Sains'),
		('Self-Help');

		-- Cek data dalam tabel
		SELECT * FROM kategori;
		
	-- Membuat tabel anggota untuk menyimpan data anggota perpustakaan
	CREATE TABLE anggota (
	    id SERIAL PRIMARY KEY,  -- Kolom ID anggota
	    nama VARCHAR(255) NOT NULL,  -- Kolom nama anggota
	    alamat VARCHAR(255),  -- Kolom alamat anggota
	    telepon VARCHAR(15)  -- Kolom nomor telepon anggota
	);
		-- Menambahkan data dummy ke dalam tabel anggota
		INSERT INTO anggota (nama, alamat, telepon) VALUES
		('Alice Johnson', '123 Main St, Jakarta', '08123456789'),
		('Bob Smith', '456 Elm St, Bandung', '08234567890'),
		('Charlie Brown', '789 Pine St, Surabaya', '08345678901'),
		('Diana Prince', '101 Maple St, Yogyakarta', '08456789012'),
		('Edward Norton', '202 Oak St, Bali', '08567890123'),
		('Fiona Apple', '303 Birch St, Medan', '08678901234'),
		('George Clooney', '404 Cedar St, Semarang', '08789012345'),
		('Hannah Montana', '505 Walnut St, Makassar', '08890123456');
		
		-- Cek data dalam tabel
		SELECT * FROM anggota;
	
	-- Membuat tabel buku untuk menyimpan data buku yang ada di perpustakaan
	CREATE TABLE buku (
	    id SERIAL PRIMARY KEY,  -- Kolom ID buku
	    judul VARCHAR(255) NOT NULL,  -- Kolom judul buku
	    penulis VARCHAR(255) NOT NULL,  -- Kolom penulis buku
	    penerbit VARCHAR(255) NOT NULL,  -- Kolom penerbit buku
	    tahunTerbit INTEGER NOT NULL,  -- Kolom tahun terbit buku
	    stok INT NOT NULL,  -- Kolom stok buku yang tersedia
	    kategori_id INT REFERENCES kategori(id) ON DELETE CASCADE  -- Kolom referensi ke kategori buku
	);

		-- Menambahkan data dummy ke dalam tabel buku
		INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id) VALUES
		('Belajar Python', 'John Smith', 'Tech Publisher', 2022, 10, 1),
		('Sastra Klasik', 'Jane Austen', 'Literature Press', 2020, 5, 2),
		('Matematika Dasar', 'Albert Einstein', 'Education Hub', 2019, 7, 3),
		('Pemrograman Java', 'James Gosling', 'Code World', 2021, 8, 1),
		('Sejarah Dunia Modern', 'Howard Zinn', 'History Works', 2018, 4, 4),
		('Buku Cerita Anak', 'Roald Dahl', 'Kids Publisher', 2017, 6, 2),
		('Fisika untuk Pemula', 'Brian Cox', 'Science Books', 2016, 9, 3),
		('Desain Web Praktis', 'Chris Taylor', 'Tech Publisher', 2023, 3, 1),
		('Psikologi Modern', 'Sigmund Freud', 'Mind Press', 2015, 2, 2),
		('Panduan SQL', 'Emily Clark', 'Code World', 2023, 5, 1),
		('Kisah Hidup Steve Jobs', 'Walter Isaacson', 'Biografi Press', 2012, 15, 6),
		('Sains dan Alam Semesta', 'Neil deGrasse Tyson', 'Science Hub', 2020, 4, 7),
		('Kembangkan Diri Anda', 'Tony Robbins', 'Self-Help Publisher', 2018, 6, 8),
		('Novel Fantasi', 'J.K. Rowling', 'Fantasy Press', 2021, 12, 5);

		-- Cek data dalam tabel
		SELECT * FROM buku;

	-- Membuat tabel log peminjaman untuk mencatat data peminjaman buku
	CREATE TABLE log_peminjaman (
	    id_peminjaman SERIAL PRIMARY KEY,  -- Kolom ID peminjaman
	    anggota_id INT REFERENCES anggota(id) ON DELETE CASCADE,  -- Kolom referensi ke ID anggota
	    buku_id INT REFERENCES buku(id) ON DELETE CASCADE,  -- Kolom referensi ke ID buku
	    tanggal_peminjaman DATE NOT NULL,  -- Kolom tanggal peminjaman
	    tanggal_pengembalian DATE,  -- Kolom tanggal pengembalian (nullable)
	    status VARCHAR(50) CHECK (status IN ('Kembali', 'Dipinjam', 'Terlambat')),  -- Kolom status peminjaman
	    denda NUMERIC(10, 2) DEFAULT 0.00  -- Kolom denda yang dikenakan (default 0)
	);
	
	-- Membuat tabel log denda untuk mencatat jumlah denda
		CREATE TABLE log_denda (
		    id_denda SERIAL PRIMARY KEY,  -- Kolom ID denda
		    peminjaman_id INT REFERENCES log_peminjaman(id_peminjaman) ON DELETE CASCADE,  -- Kolom referensi ke ID peminjaman
		    jumlah_denda NUMERIC(10, 2) NOT NULL,  -- Kolom jumlah denda
		    tanggal_denda DATE NOT NULL DEFAULT CURRENT_DATE,  -- Kolom tanggal denda
		    status_pembayaran VARCHAR(20) DEFAULT 'Belum Dibayar'  -- Kolom status pembayaran denda
		    CHECK (status_pembayaran IN ('Belum Dibayar', 'Sudah Dibayar'))  -- Menjamin nilai yang valid untuk status pembayaran
		);


-- 2. MEMBUAT TRIGGER INSERT DATA
	-- Trigger untuk tabel kategori
	CREATE OR REPLACE FUNCTION cek_kategori() RETURNS TRIGGER AS $$
	BEGIN
	    -- Cek jika nama kategori kosong
	    IF NEW.nama = '' THEN
	        RAISE NOTICE 'Nama kategori tidak boleh kosong';
	        RETURN NULL; -- Membatalkan insert jika nama kategori kosong
	    END IF;
	
	    -- Cek jika kategori dengan nama yang sama sudah ada
	    IF EXISTS (SELECT 1 FROM kategori WHERE nama = NEW.nama) THEN
	        RAISE NOTICE 'Kategori dengan nama % sudah ada', NEW.nama;
	        RETURN NULL; -- Membatalkan insert jika kategori sudah ada
	    END IF;
	    
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Membuat trigger untuk memanggil fungsi cek_kategori sebelum insert ke tabel kategori
	CREATE TRIGGER before_insert_kategori
	BEFORE INSERT ON kategori
	FOR EACH ROW EXECUTE FUNCTION cek_kategori();

		INSERT INTO kategori (nama) VALUES ('');
		-- Expected output: NOTICE: Nama kategori tidak boleh kosong

			-- Verifikasi tabel kategori
			SELECT * FROM kategori;
								
		INSERT INTO kategori (nama) VALUES ('Teknologi');
		-- Expected output: NOTICE: Kategori dengan nama Teknologi sudah ada

			-- Verifikasi tabel kategori
			SELECT * FROM kategori;
						
		INSERT INTO kategori (nama) VALUES ('Dongeng');
		-- Expected output: Data berhasil disisipkan tanpa peringatan

			-- Verifikasi tabel kategori
			SELECT * FROM kategori;
						
	-- Trigger untuk tabel anggota
	CREATE OR REPLACE FUNCTION cek_anggota() RETURNS TRIGGER AS $$
	BEGIN
	    -- Cek jika telepon tidak sesuai format (hanya angka dengan panjang 10-15 digit)
	    IF NEW.telepon IS NOT NULL AND NEW.telepon !~ '^\d{10,15}$' THEN
	        RAISE NOTICE 'Nomor telepon % tidak valid', NEW.telepon;
	        RETURN NULL; -- Membatalkan insert jika nomor telepon tidak valid
	    END IF;
	
	    -- Cek jika anggota dengan nama yang sama sudah ada
	    IF EXISTS (SELECT 1 FROM anggota WHERE nama = NEW.nama) THEN
	        RAISE NOTICE 'Anggota dengan nama % sudah ada', NEW.nama;
	        RETURN NULL; -- Membatalkan insert jika anggota dengan nama yang sama sudah ada
	    END IF;
	    
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Membuat trigger untuk memanggil fungsi cek_anggota sebelum insert ke tabel anggota
	CREATE TRIGGER before_insert_anggota
	BEFORE INSERT ON anggota
	FOR EACH ROW EXECUTE FUNCTION cek_anggota();

		INSERT INTO anggota (nama, alamat, telepon) VALUES ('John Doe', 'Jl. Kebon Jeruk', '12345');
		-- Expected output: NOTICE: Nomor telepon 12345 tidak valid

			-- Verifikasi tabel anggota
			SELECT * FROM anggota;

		
		INSERT INTO anggota (nama, alamat, telepon) VALUES ('Taylor Swift', 'Jl. Merdeka', '08765432101');
		-- Expected output: NOTICE: Anggota dengan nama Taylor Swift sudah ada

			-- Verifikasi tabel anggota
			SELECT * FROM anggota;

		
		INSERT INTO anggota (nama, alamat, telepon) VALUES ('Taylor Swift', 'Jl. Fearless', '086762489019');
		-- Expected output: Data berhasil disisipkan tanpa peringatan

			-- Verifikasi tabel anggota
			SELECT * FROM anggota;


	-- Fungsi trigger untuk validasi data pada tabel buku
	CREATE OR REPLACE FUNCTION cek_buku() RETURNS TRIGGER AS $$
	BEGIN
	    -- Cek jika judul, penulis, atau penerbit kosong
	    IF NEW.judul IS NULL OR NEW.judul = '' THEN
	        RAISE NOTICE 'Judul buku tidak boleh kosong';
	        RETURN NULL; -- Membatalkan insert
	    END IF;
	
	    IF NEW.penulis IS NULL OR NEW.penulis = '' THEN
	        RAISE NOTICE 'Penulis buku tidak boleh kosong';
	        RETURN NULL; -- Membatalkan insert
	    END IF;
	
	    IF NEW.penerbit IS NULL OR NEW.penerbit = '' THEN
	        RAISE NOTICE 'Penerbit buku tidak boleh kosong';
	        RETURN NULL; -- Membatalkan insert
	    END IF;
	
	    -- Cek jika stok kurang dari 1
	    IF NEW.stok < 1 THEN
	        RAISE NOTICE 'Stok buku harus bernilai positif dan tidak 0!';
	        RETURN NULL; -- Membatalkan insert
	    END IF;
	
	    -- Cek jika buku dengan judul dan penulis yang sama sudah ada
	    IF EXISTS (
	        SELECT 1
	        FROM buku
	        WHERE judul = NEW.judul AND penulis = NEW.penulis
	    ) THEN
	        RAISE NOTICE 'Buku dengan judul % dan penulis % sudah ada', NEW.judul, NEW.penulis;
	        RETURN NULL; -- Membatalkan insert
	    END IF;
	
	    RETURN NEW;
	END;
	$$ LANGUAGE plpgsql;
	
	-- Membuat trigger untuk memanggil fungsi cek_buku sebelum insert ke tabel buku
	CREATE TRIGGER before_insert_buku
	BEFORE INSERT ON buku
	FOR EACH ROW EXECUTE FUNCTION cek_buku();
	
		-- Contoh Pengujian
		-- 1. Menyisipkan data dengan judul kosong
		INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
		VALUES ('', 'John Doe', 'Publisher A', 2023, 5, 1);
		-- Expected Output: NOTICE: Judul buku tidak boleh kosong

			-- Verifikasi tabel buku
			SELECT * FROM buku;
			
		-- 2. Menyisipkan data dengan stok negatif
		INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
		VALUES ('Book A', 'John Doe', 'Publisher A', 2023, -3, 1);
		-- Expected Output: NOTICE: Stok buku harus bernilai positif dan tidak 0!

			-- Verifikasi tabel buku
			SELECT * FROM buku;

		-- 3.1. Menyisipkan data dengan stok negatif
		INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
		VALUES ('Book A', 'John Doe', 'Publisher A', 2023, 0, 1);
		-- Expected Output: NOTICE: Stok buku harus bernilai positif dan tidak 0!

			-- Verifikasi tabel buku
			SELECT * FROM buku;
			
		-- 3. Menyisipkan buku dengan judul dan penulis yang sama
		INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
		VALUES ('Belajar Python', 'John Smith', 'Tech Publisher', 2023, 10, 1);
		-- Expected Output: NOTICE: Buku dengan judul Belajar Python dan penulis John Smith sudah ada

			-- Verifikasi tabel buku
			SELECT * FROM buku;
			
		-- 4. Menyisipkan data yang valid
		INSERT INTO buku (judul, penulis, penerbit, tahunTerbit, stok, kategori_id)
		VALUES ('Pemrograman Ruby', 'Yukihiro Matsumoto', 'Tech Publisher', 2023, 8, 1);
		-- Expected Output: Data berhasil disisipkan tanpa peringatan

			-- Verifikasi tabel buku
			SELECT * FROM buku;

-- 3. Membuat Transaction dan Trigger untuk  Proses Peminjaman Buku, Proses Pengembalian Buku, dan Proses Pembayaran Denda
	-- Fungsi Proses Peminjaman Buku
	CREATE OR REPLACE FUNCTION lakukan_peminjaman() RETURNS TRIGGER AS $$
	BEGIN
	    -- Cek apakah data anggota dan buku valid
	    IF NOT EXISTS (SELECT 1 FROM anggota WHERE id = NEW.anggota_id) THEN
	        RAISE EXCEPTION 'Data anggota dengan ID % tidak ditemukan', NEW.anggota_id;
	    END IF;
	
	    IF NOT EXISTS (SELECT 1 FROM buku WHERE id = NEW.buku_id) THEN
	        RAISE EXCEPTION 'Data buku dengan ID % tidak ditemukan', NEW.buku_id;
	    END IF;
	
	    -- Cek stok buku sebelum insert
	    IF (SELECT stok FROM buku WHERE id = NEW.buku_id) <= 0 THEN
	        RAISE EXCEPTION 'Stok buku tidak mencukupi untuk peminjaman';
	    END IF;
	
	    -- Kurangi stok buku
	    UPDATE buku
	    SET stok = stok - 1
	    WHERE id = NEW.buku_id;
	
	    -- Tentukan status peminjaman sebagai 'Dipinjam'
	    NEW.status := 'Dipinjam';
	    
	    -- Tentukan tanggal pengembalian default (misal: 7 hari setelah tanggal pinjam)
	    NEW.tanggal_pengembalian := NEW.tanggal_peminjaman + INTERVAL '7 days';
	
	    RETURN NEW; -- Lanjutkan proses insert
	END;
	$$ LANGUAGE plpgsql;

		-- Trigger untuk peminjaman
		CREATE TRIGGER peminjaman_trigger
		BEFORE INSERT ON log_peminjaman
		FOR EACH ROW
		EXECUTE FUNCTION lakukan_peminjaman();
	
	-- Pengujian 
		-- Mencoba insert peminjaman dengan ID buku yang tidak ada
		INSERT INTO log_peminjaman (anggota_id, buku_id, tanggal_peminjaman)
		VALUES (1, 999, CURRENT_DATE);
		
			-- Memeriksa data dalam tabel
			SELECT * FROM log_peminjaman;
		
		-- Mencoba Insert dengan Stok Buku Tidak Cukup
		UPDATE buku SET stok = 0 WHERE id = 1;
		INSERT INTO log_peminjaman (anggota_id, buku_id, tanggal_peminjaman)
		VALUES (1, 1, CURRENT_DATE);
		
			-- Memeriksa data dalam tabel
			SELECT * FROM log_peminjaman;
		
		-- Insert berhasil
		INSERT INTO log_peminjaman (anggota_id, buku_id, tanggal_peminjaman)
		VALUES (3, 5, '08-12-2024'),
				(11, 1, '08-12-2024'),
				(6, 10, '08-12-2024'),
				(11, 6, '09-12-2024'),
				(5, 9, '09-12-2024'),
				(1, 6, '08-12-2024'),
				(2, 6, CURRENT_DATE),
				(1, 7, CURRENT_DATE),
				(2, 9, CURRENT_DATE),
				(4, 1, CURRENT_DATE),
				(8, 10, CURRENT_DATE),
				(2, 7, CURRENT_DATE);
		
			-- Memeriksa data dalam tabel
			SELECT * FROM log_peminjaman;

	-- Fungsi Proses Pengembalian Buku
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
	    -- Ambil status peminjaman
	    SELECT status INTO current_status
	    FROM log_peminjaman
	    WHERE id_peminjaman = p_id_peminjaman;
	
	    IF NOT FOUND THEN
	        RAISE EXCEPTION 'Peminjaman dengan ID % tidak ditemukan', p_id_peminjaman;
	    END IF;
	
	    IF current_status = 'Kembali' THEN
	        RAISE NOTICE 'Pengembalian tidak dapat diproses: Status peminjaman sudah Kembali.';
	        RETURN;  -- Hentikan eksekusi jika status sudah "Kembali"
	    ELSIF current_status = 'Terlambat' THEN
	        RAISE NOTICE 'Pengembalian tidak dapat diproses: Status peminjaman sudah Terlambat.';
	        RETURN;  -- Hentikan eksekusi jika status sudah "Terlambat"
	    END IF;
	
	    -- Ambil batas pengembalian dan hitung keterlambatan
	    SELECT tanggal_peminjaman + INTERVAL '7 days' INTO batas_pengembalian
	    FROM log_peminjaman WHERE id_peminjaman = p_id_peminjaman;
	
	    lama_terlambat := GREATEST((p_tanggal_pengembalian - batas_pengembalian)::INTEGER, 0);
	    
	    -- Perbarui status dan hitung denda jika ada
	    IF p_tanggal_pengembalian <= batas_pengembalian THEN
	        UPDATE log_peminjaman
	        SET status = 'Kembali', tanggal_pengembalian = p_tanggal_pengembalian
	        WHERE id_peminjaman = p_id_peminjaman;
	    ELSE
	        jumlah_denda := lama_terlambat * 2000;
	        UPDATE log_peminjaman
	        SET status = 'Terlambat', tanggal_pengembalian = p_tanggal_pengembalian, denda = jumlah_denda
	        WHERE id_peminjaman = p_id_peminjaman;
	        
	        -- Catat denda dalam tabel log_denda
	        INSERT INTO log_denda (peminjaman_id, jumlah_denda)
	        VALUES (p_id_peminjaman, jumlah_denda);
	    END IF;
	
	    -- Tambahkan stok buku kembali
	    UPDATE buku
	    SET stok = stok + 1
	    WHERE id = (SELECT buku_id FROM log_peminjaman WHERE id_peminjaman = p_id_peminjaman);
	
	    RAISE NOTICE 'Pengembalian berhasil diproses. Status: %, Denda: %',
	        CASE WHEN p_tanggal_pengembalian <= batas_pengembalian THEN 'Kembali' ELSE 'Terlambat' END,
	        COALESCE(jumlah_denda, 0);
	END;
	$$ LANGUAGE plpgsql;

	-- Pengujian 
	-- Lebih awal dari bata pengembalian
	SELECT proses_pengembalian_transaksi(9, '10-12-2024'),
			proses_pengembalian_transaksi(8, '10-12-2024'),
			proses_pengembalian_transaksi(16, '10-12-2024'),
			proses_pengembalian_transaksi(19, '10-12-2024');

		-- Memeriksa isi data dalam tabel
		SELECT * FROM log_peminjaman;
		
	-- Tepat waktu
	SELECT proses_pengembalian_transaksi(18, '16-12-2024');

		-- Memeriksa isi data dalam tabel
		SELECT * FROM log_peminjaman;
		
	-- Terlambat
	select proses_pengembalian_transaksi(20, '20-12-2024'),
			proses_pengembalian_transaksi(21, '20-12-2024'),
			proses_pengembalian_transaksi(23, '20-12-2024'),
			proses_pengembalian_transaksi(24, '20-12-2024'),
			proses_pengembalian_transaksi(25, '20-12-2024');

		-- Memeriksa isi data dalam tabel
		SELECT * FROM log_peminjaman;


	-- Fungsi Proses Pembayaran Denda
	CREATE OR REPLACE FUNCTION proses_pembayaran_denda(
	    p_id_denda INT  -- ID denda yang ingin dibayar
	) RETURNS VOID AS $$
	DECLARE
	    current_status_pembayaran VARCHAR(20);
	BEGIN
	    -- Ambil status pembayaran denda
	    SELECT status_pembayaran INTO current_status_pembayaran
	    FROM log_denda
	    WHERE id_denda = p_id_denda;
	
	    IF NOT FOUND THEN
	        RAISE EXCEPTION 'Denda dengan ID % tidak ditemukan', p_id_denda;
	    END IF;
	
	    IF current_status_pembayaran = 'Sudah Dibayar' THEN
	        RAISE NOTICE 'Denda dengan ID % sudah dibayar sebelumnya.', p_id_denda;
	        RETURN;  -- Hentikan eksekusi jika denda sudah dibayar
	    END IF;
	
	    -- Perbarui status pembayaran denda menjadi 'Sudah Dibayar'
	    UPDATE log_denda
	    SET status_pembayaran = 'Sudah Dibayar'
	    WHERE id_denda = p_id_denda;
	
	    RAISE NOTICE 'Pembayaran denda dengan ID % berhasil diproses. Status: Sudah Dibayar', p_id_denda;
	END;
	$$ LANGUAGE plpgsql;

	-- Pengujian
		-- Id denda tidak ditemukan
		SELECT proses_pembayaran_denda(8);
		
			-- Memeriksa isi data dalam tabel
			SELECT * FROM log_denda;

		-- Berhasil
		SELECT proses_pembayaran_denda(1),
				proses_pembayaran_denda(2),
				proses_pembayaran_denda(4),
				proses_pembayaran_denda(5);
		
			-- Memeriksa isi data dalam tabel
			SELECT * FROM log_denda;

			
-- 4. MEMBUAT VIEW 
	-- 1. Lihat Jumlah Denda peminjaman setiap anggota
	CREATE VIEW anggota_peminjaman_denda AS
	SELECT
	    a.id AS anggota_id,
	    a.nama AS nama_anggota,
	    b.judul AS judul_buku,
	    lp.tanggal_peminjaman,
	    lp.tanggal_pengembalian,
	    lp.status AS status_peminjaman,
	    COALESCE(ld.jumlah_denda, 0.00) AS jumlah_denda,
	    COALESCE(ld.status_pembayaran, 'Belum Dibayar') AS status_denda  -- Menampilkan status pembayaran denda
	FROM
	    anggota a
	JOIN
	    log_peminjaman lp ON a.id = lp.anggota_id
	JOIN
	    buku b ON lp.buku_id = b.id
	LEFT JOIN
	    log_denda ld ON lp.id_peminjaman = ld.peminjaman_id;
	
	-- Menampilkan hasil dari view anggota_peminjaman_denda
	SELECT * FROM anggota_peminjaman_denda;

	
	-- 2. Laporan Buku Paling Sering Dipinjam per Tahun dengan Status
	CREATE VIEW laporan_buku_per_tahun AS
	SELECT 
	    b.judul, 
	    b.penulis, 
	    b.penerbit, 
	    b.tahunTerbit, 
	    EXTRACT(YEAR FROM lp.tanggal_peminjaman) AS tahun,  -- Mengelompokkan berdasarkan tahun
	    lp.status,  -- Menambahkan status peminjaman
	    COUNT(lp.id_peminjaman) AS jumlah_peminjaman
	FROM 
	    buku b
	JOIN 
	    log_peminjaman lp ON b.id = lp.buku_id
	GROUP BY 
	    b.id, b.judul, b.penulis, b.penerbit, b.tahunTerbit, tahun, lp.status
	ORDER BY 
	    jumlah_peminjaman DESC, tahun DESC, lp.status DESC;
	
		-- Menampilkan laporan buku paling sering dipinjam per tahun
		SELECT * FROM laporan_buku_per_tahun;
	
	
	--3. Laporan Buku Paling Sering Dipinjam per Bulan dengan Status
	CREATE VIEW laporan_buku_per_bulan AS
	SELECT 
	    b.judul, 
	    b.penulis, 
	    b.penerbit, 
	    b.tahunTerbit, 
	    DATE_TRUNC('month', lp.tanggal_peminjaman) AS bulan,  -- Mengelompokkan berdasarkan bulan
	    lp.status,  -- Menambahkan status peminjaman
	    COUNT(lp.id_peminjaman) AS jumlah_peminjaman
	FROM 
	    buku b
	JOIN 
	    log_peminjaman lp ON b.id = lp.buku_id
	GROUP BY 
	    b.id, b.judul, b.penulis, b.penerbit, b.tahunTerbit, bulan, lp.status
	ORDER BY 
	    jumlah_peminjaman DESC, bulan DESC, lp.status DESC;
		
		-- Menampilkan laporan buku paling sering dipinjam per bulan
		SELECT * FROM laporan_buku_per_bulan;
	
	-- 4. Laporan Buku Paling Sering Dipinjam per Minggu dengan Status
	CREATE VIEW laporan_buku_per_minggu AS
	SELECT 
	    b.judul, 
	    b.penulis, 
	    b.penerbit, 
	    b.tahunTerbit, 
	    DATE_TRUNC('week', lp.tanggal_peminjaman) AS minggu,  -- Mengelompokkan berdasarkan minggu
	    lp.status,  -- Menambahkan status peminjaman
	    COUNT(lp.id_peminjaman) AS jumlah_peminjaman
	FROM 
	    buku b
	JOIN 
	    log_peminjaman lp ON b.id = lp.buku_id
	GROUP BY 
	    b.id, b.judul, b.penulis, b.penerbit, b.tahunTerbit, minggu, lp.status
	ORDER BY 
	    jumlah_peminjaman DESC, minggu DESC, lp.status DESC;
		
		-- Menampilkan laporan buku paling sering dipinjam per minggu
		SELECT * FROM laporan_buku_per_minggu;
	
	
-- Stored Procedure 
	
	CREATE OR REPLACE PROCEDURE laporan_buku_terpopuler(
    IN tanggal_mulai DATE,
    IN tanggal_akhir DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Menampilkan laporan buku terpopuler
    RAISE NOTICE 'Laporan Buku Paling Sering Dipinjam (% - %)', tanggal_mulai, tanggal_akhir;
    PERFORM * FROM (
        SELECT b.judul, COUNT(lp.id_peminjaman) AS total_peminjaman
        FROM buku b
        JOIN log_peminjaman lp ON b.id = lp.buku_id
        WHERE lp.tanggal_peminjaman BETWEEN tanggal_mulai AND tanggal_akhir
        GROUP BY b.judul
        ORDER BY total_peminjaman DESC
        LIMIT 10
    ) AS laporan;

    RAISE NOTICE 'Laporan berhasil dibuat.';
END;
$$;

CALL laporan_buku_terpopuler('2024-01-01', '2024-12-31');

-- Cursor
CREATE OR REPLACE PROCEDURE laporan_buku_populer()
LANGUAGE plpgsql AS $$
DECLARE
    -- Cursor untuk mengambil data buku dan jumlah peminjamannya
    cur_populer CURSOR FOR
        SELECT b.id, b.judul, COUNT(p.buku_id) AS total_peminjaman
        FROM buku b
        LEFT JOIN log_peminjaman p ON b.id = p.buku_id
        GROUP BY b.id, b.judul
        ORDER BY total_peminjaman DESC;

    -- Variabel untuk menyimpan data dari cursor
    buku_id INTEGER;
    buku_judul TEXT;
    total_pinjam INTEGER;
BEGIN
    -- Membuka cursor
    OPEN cur_populer;

    -- Header untuk hasil laporan
    RAISE NOTICE 'ID Buku | Judul Buku | Total Peminjaman';

    -- Loop melalui hasil cursor dan tampilkan data
    z 
        FETCH cur_populer INTO buku_id, buku_judul, total_pinjam;
        -- Berhenti jika tidak ada lagi data
        EXIT WHEN NOT FOUND;

        -- Menampilkan hasil
        RAISE NOTICE '% | % | %', buku_id, buku_judul, total_pinjam;
    END LOOP;  

    -- Menutup cursor
    CLOSE cur_populer;
END;
$$;

-- Memanggil prosedur untuk menampilkan laporan
CALL laporan_buku_populer();/ 
	



