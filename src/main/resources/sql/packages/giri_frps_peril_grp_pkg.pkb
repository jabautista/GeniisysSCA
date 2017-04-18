CREATE OR REPLACE PACKAGE BODY CPI.GIRI_FRPS_PERIL_GRP_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 24, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure delete frps_peril_grp record. 
*/  
  PROCEDURE del_giri_frps_peril_grp(p_frps_seq_no IN GIRI_FRPS_PERIL_GRP.frps_seq_no%TYPE,
                                    p_frps_yy     IN GIRI_FRPS_PERIL_GRP.frps_yy%TYPE) 
  IS
  BEGIN
    DELETE FROM GIRI_FRPS_PERIL_GRP
     WHERE frps_yy     = p_frps_yy
       AND frps_seq_no = p_frps_seq_no;
  END del_giri_frps_peril_grp;
  
   /*
   **  Created by       : Anthony Santos
   **  Date Created     : 06.29.2011
   **  Reference By     : (GIRIS026- Post FRPS
   **
   */
  
  PROCEDURE create_frps_peril_grp_giris026
  (
   	  p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
  )
   IS
  CURSOR grp_area IS
    SELECT T1.line_cd, T1.frps_yy, T1.frps_seq_no,
           T1.peril_seq_no, T1.peril_cd, T1.tsi_amt,
           T1.prem_amt, peril_title, remarks,
           T1.tot_fac_spct, T1.tot_fac_tsi, T1.tot_fac_prem
      FROM giri_wfrps_peril_grp T1
     WHERE T1.line_cd     = p_line_cd
       AND T1.frps_yy     = p_frps_yy
       AND T1.frps_seq_no = p_frps_seq_no
       AND NOT EXISTS (SELECT 1 -- bonok :: 09.30.2014 :: added to prevent unique constraint
                         FROM giri_frps_peril_grp
                        WHERE line_cd     = p_line_cd
                          AND frps_yy     = p_frps_yy
                          AND frps_seq_no = p_frps_seq_no);
BEGIN
  FOR c1_rec IN grp_area LOOP
    INSERT INTO giri_frps_peril_grp
      (line_cd, frps_yy, frps_seq_no,
       peril_seq_no, peril_cd, tsi_amt,
       prem_amt, peril_title, remarks,
       tot_fac_spct, tot_fac_prem, tot_fac_tsi)
    VALUES
      (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
       c1_rec.peril_seq_no, c1_rec.peril_cd, c1_rec.tsi_amt,
       c1_rec.prem_amt, c1_rec.peril_title, c1_rec.remarks,
       c1_rec.tot_fac_spct, c1_rec.tot_fac_prem, c1_rec.tot_fac_tsi); 
 END LOOP;
END CREATE_FRPS_PERIL_GRP_GIRIS026;

END GIRI_FRPS_PERIL_GRP_PKG;
/


