DROP PROCEDURE CPI.DEL_CSV_PATH_CSV;

CREATE OR REPLACE PROCEDURE CPI.del_csv_path_csv (filename IN varchar2) IS
aaa utl_file.file_type;
BEGIN
  aaa := sys.utl_file.fopen('CSV_PATH',filename,'r');
  IF sys.utl_file.is_open(aaa) THEN
  sys.utl_file.fclose(aaa);
  sys.utl_file.fremove('CSV_PATH', filename);
  END IF;
END;
/


