CREATE OR REPLACE PACKAGE BODY CPI.giri_binder_peril_pkg
AS
/*
     **  Created by       : Anthony Santos
     **  Date Created     : 06.29.2011
     **  Reference By     : (GIRIS026- Post FRPS
     **
     */
   PROCEDURE create_binder_peril_giris026 (
      p_line_cd       giri_distfrps_wdistfrps_v.line_cd%TYPE,
      p_frps_yy       giri_distfrps_wdistfrps_v.frps_yy%TYPE,
      p_frps_seq_no   giri_distfrps_wdistfrps_v.frps_seq_no%TYPE
   )
   IS
      v_tsi_amt        giuw_perilds.tsi_amt%TYPE;
      v_ri_comm_rt     giri_wfrperil.ri_comm_rt%TYPE;
      v_ri_shr_pct     giri_wfrperil.ri_shr_pct%TYPE;
      v_wholding_vat   giri_frps_ri.ri_wholding_vat%TYPE;

      CURSOR bperil
      IS
         SELECT   t2.pre_binder_id, t2.ri_cd, t4.peril_seq_no,
                  SUM (t3.ri_tsi_amt) ri_tsi_amt,
                  SUM (t3.ri_prem_amt) ri_prem_amt,
                  SUM (t3.ri_comm_amt) ri_comm_amt, SUM (tsi_amt) tsi_amt,
                  SUM (prem_amt) prem_amt, SUM (t3.ri_prem_vat) ri_prem_vat,
                  SUM (t3.ri_comm_vat) ri_comm_vat,
                  SUM (t3.prem_tax) prem_tax,
                  t5.local_foreign_sw local_foreign_sw, t3.ri_comm_rt ri_comm_rt --added ri_comm_rt edgar 10/17/2014
             FROM giri_wfrps_ri t2,
                  giri_wfrperil t3,
                  giri_wfrps_peril_grp t4,
                  giis_reinsurer t5
            WHERE t2.line_cd = t3.line_cd
              AND t2.frps_yy = t3.frps_yy
              AND t2.frps_seq_no = t3.frps_seq_no
              AND t2.ri_seq_no = t3.ri_seq_no
              AND t3.line_cd = t4.line_cd
              AND t3.frps_yy = t4.frps_yy
              AND t3.frps_seq_no = t4.frps_seq_no
              AND t2.ri_cd = t5.ri_cd
              AND t3.peril_cd = t4.peril_cd
              AND t4.line_cd = p_line_cd
              AND t4.frps_yy = p_frps_yy
              AND t4.frps_seq_no = p_frps_seq_no
              AND NOT EXISTS (SELECT 1 -- bonok :: 09.30.2014
                                FROM giri_binder_peril
                               WHERE fnl_binder_id = t2.pre_binder_id)
         GROUP BY t2.pre_binder_id,
                  t4.peril_seq_no,
                  t2.ri_cd,
                  t5.local_foreign_sw, t3.ri_comm_rt; --added ri_comm_rt edgar 10/17/2014
   BEGIN
      FOR c2_rec IN bperil
      LOOP
         IF c2_rec.local_foreign_sw != 'L'
         THEN
            v_wholding_vat := c2_rec.ri_prem_vat;
         END IF;

--         DELETE FROM giri_binder_peril -- bonok :: 09.30.2014
--               WHERE fnl_binder_id = c2_rec.pre_binder_id
--                 AND peril_seq_no = c2_rec.peril_seq_no;

         IF c2_rec.tsi_amt IS NULL OR c2_rec.tsi_amt = 0
         THEN
            v_ri_shr_pct := 0;
         ELSE
            v_ri_shr_pct := (c2_rec.ri_tsi_amt / c2_rec.tsi_amt) * 100;
         END IF;

        -- IF c2_rec.ri_prem_amt IS NULL OR c2_rec.ri_prem_amt = 0
        -- THEN
        --    v_ri_comm_rt := 0;
        -- ELSE
        --    FOR a IN (SELECT a.ri_comm_rt
        --                FROM giri_wfrperil a, giri_wfrps_peril_grp b
        --               WHERE a.line_cd = p_line_cd
        --                 AND a.frps_yy = p_frps_yy
        --                 AND a.frps_seq_no = p_frps_seq_no
        --                 AND a.line_cd = b.line_cd
        --                 AND a.frps_yy = b.frps_yy
        --                 AND a.frps_seq_no = b.frps_seq_no
        --                 AND b.peril_seq_no = c2_rec.peril_seq_no
        --                 AND a.peril_cd = b.peril_cd
        --                 AND a.ri_cd = c2_rec.ri_cd)
        --    LOOP
        --       v_ri_comm_rt := a.ri_comm_rt;
        --       EXIT;
        --    END LOOP;
        -- END IF;--commented out edgar 10/17/14
         v_ri_comm_rt := c2_rec.ri_comm_rt; --edgar 10/17/14

         INSERT INTO giri_binder_peril
                     (fnl_binder_id, peril_seq_no,
                      ri_tsi_amt, ri_shr_pct, ri_prem_amt,
                      ri_comm_rt, ri_comm_amt, ri_comm_vat,
                      ri_prem_vat, ri_wholding_vat, prem_tax
                     )
              VALUES (c2_rec.pre_binder_id, c2_rec.peril_seq_no,
                      c2_rec.ri_tsi_amt, v_ri_shr_pct, c2_rec.ri_prem_amt,
                      v_ri_comm_rt, c2_rec.ri_comm_amt, c2_rec.ri_comm_vat,
                      c2_rec.ri_prem_vat, v_wholding_vat, c2_rec.prem_tax
                     );

         v_wholding_vat := 0;
      END LOOP;
   END create_binder_peril_giris026;
   
   /*
    **  Created by      : Emman
    **  Date Created    : 08.17.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : The procedure CREATE_BINDER_PERIL 
    */
    PROCEDURE CREATE_BINDER_PERIL_GIUTS021 (p_line_cd     IN giri_distfrps.line_cd%TYPE,
                                           p_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                           p_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE)
    IS
      v_tsi_amt        giuw_perilds.tsi_amt%type;
      v_ri_comm_rt        giri_wfrperil.ri_comm_Rt%type;
      v_ri_shr_pct        giri_wfrperil.ri_shr_pct%type;
      v_wholding_vat   giri_frps_ri.ri_wholding_vat%TYPE := 0; --edgar 09/30/2014
      CURSOR bperil IS
        SELECT T2.pre_binder_id
               ,peril_seq_no
               ,SUM(T3.ri_tsi_amt) ri_tsi_amt
               ,SUM(T3.ri_prem_amt) ri_prem_amt
               ,SUM(T3.ri_comm_amt) ri_comm_amt
               ,SUM(tsi_amt) tsi_amt
               ,SUM(prem_amt) prem_amt
               ,SUM(t3.RI_COMM_VAT) ri_comm_vat, SUM(t3.RI_PREM_VAT) ri_prem_vat, SUM(t3.PREM_TAX) prem_tax, t5.local_foreign_sw, t3.ri_comm_rt --added edgar 09/29/2014 
          FROM giri_wfrps_ri T2
               ,giri_wfrperil T3
               ,giri_wfrps_peril_grp T4
               ,giis_reinsurer t5    --edgar 09/30/2014
         WHERE T2.line_cd       = T3.line_cd
           AND T2.frps_yy       = T3.frps_yy
           AND T2.frps_seq_no   = T3.frps_seq_no
           AND T2.ri_seq_no     = T3.ri_seq_no
           AND T3.line_cd       = T4.line_cd
           AND T3.frps_yy       = T4.frps_yy
           AND T3.frps_seq_no   = T4.frps_seq_no
           AND T3.peril_cd      = T4.peril_cd
           AND t2.ri_cd         = t5.ri_cd    --edgar 09/30/2014
           AND T4.line_cd       = p_line_cd
           AND T4.frps_yy       = p_frps_yy
           AND T4.frps_seq_no   = p_frps_seq_no
      GROUP BY T2.pre_binder_id, peril_seq_no, t5.local_foreign_sw, t3.ri_comm_rt;--edgar 09/30/2014
       

    BEGIN
      FOR c2_rec IN bperil LOOP
        /*added edgar 09/30/2014*/
         IF c2_rec.local_foreign_sw != 'L'
         THEN
            v_wholding_vat := c2_rec.ri_prem_vat;
         END IF;        
        /*end edgar 09/30/2014*/
        DELETE FROM giri_binder_peril
         WHERE fnl_binder_id = c2_rec.pre_binder_id
           AND peril_seq_no  = c2_rec.peril_seq_no;
        IF c2_rec.tsi_amt IS NULL OR c2_rec.tsi_amt = 0 THEN
          v_ri_shr_pct := 0;
        ELSE
          v_ri_shr_pct := round(((c2_rec.ri_tsi_amt/c2_rec.tsi_amt)*100),9);
        END IF;
        /*IF c2_rec.ri_prem_amt IS NULL OR c2_rec.ri_prem_amt = 0 THEN
        --  v_ri_comm_rt := 0;
        --ELSE
        --  v_ri_comm_rt := round(((c2_rec.ri_comm_amt/c2_rec.ri_prem_amt)*100),9);
        END IF;*/--commented out edgar 10/14/2014 no need to recompute ri_comm_rt ing giri_binder_peril

        INSERT INTO giri_binder_peril
          (fnl_binder_id, peril_seq_no, ri_tsi_amt, 
           ri_shr_pct, ri_prem_amt, ri_comm_rt, 
           ri_comm_amt, ri_comm_vat, ri_prem_vat, prem_tax, ri_wholding_vat)--added edgar 09/29/2014 
        VALUES
          (c2_rec.pre_binder_id, c2_rec.peril_seq_no, c2_rec.ri_tsi_amt, 
           v_ri_shr_pct, c2_rec.ri_prem_amt, /*v_ri_comm_rt*/c2_rec.ri_comm_rt, --edgar 10/14/2014
           c2_rec.ri_comm_amt, c2_rec.ri_comm_vat, c2_rec.ri_prem_vat, c2_rec.prem_tax, v_wholding_vat);--added edgar 09/29/2014 
         v_wholding_vat := 0;-- edgar 09/30/2014           
      END LOOP;
    END CREATE_BINDER_PERIL_GIUTS021;
END;
/


