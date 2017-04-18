ALTER TABLE cpi.giis_reinsurer ADD (
CONSTRAINT local_foreign_sw_chk
CHECK (local_foreign_sw IN ('A','F','L')))