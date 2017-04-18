CREATE OR REPLACE PACKAGE BODY CPI.giri_frperil_pkg
AS
   /*
     **  Created by       : Anthony Santos
     **  Date Created     : 06.29.2011
     **  Reference By     : (GIRIS026- Post FRPS
     **
     */
   PROCEDURE create_giri_frperil_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   )
   IS
      v_wholding_vat   giri_frperil.ri_wholding_vat%TYPE;

      CURSOR wfrperil_area
      IS
         SELECT t1.line_cd, t1.frps_yy, t1.frps_seq_no, t1.ri_seq_no,
                t1.ri_cd, peril_cd, t1.ri_shr_pct, t1.ri_tsi_amt,
                t1.ri_prem_amt, t1.ann_ri_s_amt, t1.ann_ri_pct,
                t1.ri_comm_rt, t1.ri_comm_amt, t1.ri_prem_vat,
                t1.ri_comm_vat, t3.local_foreign_sw, t1.prem_tax
           FROM giri_wfrperil t1, giri_wfrps_ri t2, giis_reinsurer t3
          WHERE t1.line_cd = t2.line_cd
            AND t1.frps_yy = t2.frps_yy
            AND t1.frps_seq_no = t2.frps_seq_no
            AND t1.ri_seq_no = t2.ri_seq_no
            AND t1.ri_cd = t3.ri_cd
            AND t1.line_cd = p_line_cd
            AND t1.frps_yy = p_frps_yy
            AND t1.frps_seq_no = p_frps_seq_no
            AND NOT EXISTS (SELECT 1 -- bonok :: 09.30.2014
                              FROM giri_frperil
                             WHERE line_cd = t1.line_cd
                               AND frps_yy = t1.frps_yy
                               AND frps_seq_no = t1.frps_seq_no
                               AND ri_seq_no = t1.ri_seq_no
                               AND ri_cd = t1.ri_cd);
   BEGIN
      FOR c1_rec IN wfrperil_area
      LOOP
         IF c1_rec.local_foreign_sw != 'L'
         THEN
            v_wholding_vat := c1_rec.ri_prem_vat;
         END IF;

         INSERT INTO giri_frperil
                     (line_cd, frps_yy, frps_seq_no,
                      ri_seq_no, ri_cd, peril_cd,
                      ri_shr_pct, ri_tsi_amt,
                      ri_prem_amt, ann_ri_s_amt,
                      ann_ri_pct, ri_comm_rt,
                      ri_comm_amt, ri_prem_vat,
                      ri_comm_vat, ri_wholding_vat, prem_tax
                     )
              VALUES (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
                      c1_rec.ri_seq_no, c1_rec.ri_cd, c1_rec.peril_cd,
                      c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt,
                      c1_rec.ri_prem_amt, c1_rec.ann_ri_s_amt,
                      c1_rec.ann_ri_pct, c1_rec.ri_comm_rt,
                      c1_rec.ri_comm_amt, c1_rec.ri_prem_vat,
                      c1_rec.ri_comm_vat, v_wholding_vat, c1_rec.prem_tax
                     );

         v_wholding_vat := 0;
      END LOOP;
   END;
   
   /*
    **  Created by      : Emman
    **  Date Created    : 08.17.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : The procedure CREATE_GIRI_FRPERIL
    */
    PROCEDURE CREATE_GIRI_FRPERIL_GIUTS021 (p_line_cd     IN giri_distfrps.line_cd%TYPE,
                                   p_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                   p_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE)
    IS
      v_wholding_vat   giri_frperil.ri_wholding_vat%TYPE := 0; --edgar 09/30/2014
      CURSOR wfrperil_area IS
        SELECT T1.line_cd, T1.frps_yy, T1.frps_seq_no, 
               T1.ri_seq_no, T1.ri_cd, peril_cd, 
               T1.ri_shr_pct, T1.ri_tsi_amt, T1.ri_prem_amt, 
               T1.ann_ri_s_amt, T1.ann_ri_pct, T1.ri_comm_rt, 
               T1.ri_comm_amt, T1.ri_prem_vat, T1.ri_comm_vat, T1.prem_tax, T1.ri_comm_amt2, t3.local_foreign_sw --edgar 09/30/2014
          FROM giri_wfrperil T1, giri_wfrps_ri T2, giis_reinsurer t3 --edgar 09/30/2014
         WHERE T1.line_cd     = T2.line_cd
           AND T1.frps_yy     = T2.frps_yy
           AND T1.frps_seq_no = T2.frps_seq_no
           AND T1.ri_seq_no   = T2.ri_seq_no
           AND t1.ri_cd       = t3.ri_cd     --edgar 09/30/2014
           AND T1.line_cd     = p_line_cd
           AND T1.frps_yy     = p_frps_yy
           AND T1.frps_seq_no = p_frps_seq_no;
    BEGIN
      FOR c1_rec IN wfrperil_area LOOP
          /*added edgar 09/30/2014*/   
         IF c1_rec.local_foreign_sw != 'L'
         THEN
            v_wholding_vat := c1_rec.ri_prem_vat;
         END IF;
         /*end edgar 09/30/2014*/        
        INSERT INTO giri_frperil
          (line_cd, frps_yy, frps_seq_no, 
           ri_seq_no, ri_cd, peril_cd, 
           ri_shr_pct, ri_tsi_amt, ri_prem_amt, 
           ann_ri_s_amt, ann_ri_pct, ri_comm_rt, 
           ri_comm_amt, ri_prem_vat, ri_comm_vat, prem_tax, ri_comm_amt2, ri_wholding_vat)--edgar 09/29/2014
        VALUES
          (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no, 
           c1_rec.ri_seq_no, c1_rec.ri_cd, c1_rec.peril_cd, 
           c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_prem_amt, 
           c1_rec.ann_ri_s_amt, c1_rec.ann_ri_pct, c1_rec.ri_comm_rt, 
           c1_rec.ri_comm_amt, c1_rec.ri_prem_vat, c1_rec.ri_comm_vat, c1_rec.prem_tax, c1_rec.ri_comm_amt2, v_wholding_vat);--edgar 09/29/2014
        v_wholding_vat := 0; --edgar 09/30/2014          
      END LOOP;
    END CREATE_GIRI_FRPERIL_GIUTS021;
END;
/


