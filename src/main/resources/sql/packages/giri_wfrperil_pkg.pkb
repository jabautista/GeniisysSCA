CREATE OR REPLACE PACKAGE BODY CPI.Giri_Wfrperil_Pkg
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 02.17.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Contains the Insert / Update / Delete procedure of the table
    */

    PROCEDURE del_giri_wfrperil(
        p_line_cd        GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy        GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no    GIRI_WFRPERIL.frps_seq_no%TYPE)
    IS
    BEGIN
        DELETE GIRI_WFRPERIL
         WHERE line_cd = p_line_cd
           AND frps_yy = p_frps_yy
           AND frps_seq_no = p_frps_seq_no;
    END del_giri_wfrperil;
    
    PROCEDURE del_giri_wfrperil_1 (
        p_frps_yy        GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no    GIRI_WFRPERIL.frps_seq_no%TYPE)
    IS
    BEGIN
        DELETE GIRI_WFRPERIL
         WHERE frps_yy = p_frps_yy
           AND frps_seq_no = p_frps_seq_no;
    END del_giri_wfrperil_1;
    
    PROCEDURE del_giri_wfrperil_2(
		p_line_cd		GIRI_WFRPERIL.line_cd%TYPE,
		p_frps_yy		GIRI_WFRPERIL.frps_yy%TYPE,
		p_frps_seq_no	GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_cd         GIRI_WFRPERIL.ri_cd%TYPE)
	IS
	BEGIN
		DELETE GIRI_WFRPERIL
		 WHERE line_cd = p_line_cd
		   AND frps_yy = p_frps_yy
		   AND frps_seq_no = p_frps_seq_no
           AND ri_cd = p_ri_cd;
	END del_giri_wfrperil_2;    
    
    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 06.28.2011
    **  Reference By     : (GIRIS002 - Enter RI Acceptance)
    **  Description     : Retrieves perils based on giri_wfrps_ri record
    */
    FUNCTION get_giri_wfrperil (
        p_line_cd        GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy        GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no    GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_seq_no      GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_ri_cd          GIRI_WFRPERIL.ri_cd%TYPE,
        p_dist_no        GIRI_DISTFRPS_WDISTFRPS_V.dist_no%TYPE, 
        p_dist_seq_no    GIRI_DISTFRPS_WDISTFRPS_V.dist_seq_no%TYPE
    ) RETURN giri_wfrperil_tab PIPELINED IS
        v_frperil        giri_wfrperil_type;
    BEGIN
        FOR i IN (
            SELECT line_cd, frps_yy, frps_seq_no, ri_seq_no, peril_cd, ri_cd, 
                   ri_shr_pct, ri_tsi_amt, ri_prem_amt, ann_ri_s_amt, ann_ri_pct,
                   ri_comm_rt, ri_comm_amt, ri_comm_vat, ri_prem_vat, prem_tax
              FROM giri_wfrperil
             WHERE line_cd = p_line_cd
               AND frps_yy = p_frps_yy
               AND frps_seq_no = p_frps_seq_no
               AND ri_seq_no = p_ri_seq_no
               AND ri_cd = p_ri_cd
        ) LOOP
            v_frperil.line_cd       :=   i.line_cd; 
            v_frperil.frps_yy       :=   i.frps_yy; 
            v_frperil.frps_seq_no   :=   i.frps_seq_no; 
            v_frperil.ri_seq_no     :=   i.ri_seq_no; 
            v_frperil.peril_cd      :=   i.peril_cd; 
            v_frperil.ri_cd         :=   i.ri_cd; 
            v_frperil.ri_shr_pct    :=   i.ri_shr_pct; 
            v_frperil.ri_tsi_amt    :=   i.ri_tsi_amt; 
            v_frperil.ri_prem_amt   :=   i.ri_prem_amt; 
            v_frperil.ann_ri_s_amt  :=   i.ann_ri_s_amt; 
            v_frperil.ann_ri_pct    :=   i.ann_ri_pct;
            v_frperil.ri_comm_rt    :=   i.ri_comm_rt; 
            v_frperil.ri_comm_amt   :=   i.ri_comm_amt; 
            v_frperil.ri_comm_vat   :=   i.ri_comm_vat; 
            v_frperil.ri_prem_vat   :=   i.ri_prem_vat; 
            v_frperil.prem_tax      :=   i.prem_tax;
            
            FOR j IN (
                SELECT peril_sname, peril_name
                  FROM giis_peril
                 WHERE line_cd = i.line_cd
                   AND peril_cd = i.peril_cd
            ) LOOP
                v_frperil.peril_sname := j.peril_sname;
                v_frperil.peril_name := j.peril_name;
            END LOOP;
            
            FOR k IN (
                SELECT dist_prem, dist_tsi
                  FROM GIUW_PERILDS_DTL
                 WHERE dist_no       = p_dist_no
                     AND dist_seq_no = p_dist_seq_no
                     AND peril_cd    = i.peril_cd
                     AND share_cd    = 999
            ) LOOP
                v_frperil.dist_prem := nvl(k.dist_prem, 0);
                v_frperil.dist_tsi  := nvl(k.dist_tsi, 0);
            END LOOP;
                
            PIPE ROW(v_frperil);
        END LOOP;
    END get_giri_wfrperil;
    
    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 07.04.2011
    **  Reference By     : (GIRIS002 - Enter RI Acceptance)
    */
    PROCEDURE set_giri_wfrperil (
        p_line_cd         GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy         GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no     GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_seq_no       GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_ri_cd           GIRI_WFRPERIL.ri_cd%TYPE,
        p_peril_cd        GIRI_WFRPERIL.peril_cd%TYPE,
        p_ri_shr_pct      GIRI_WFRPERIL.ri_shr_pct%TYPE,
        p_ri_tsi_amt      GIRI_WFRPERIL.ri_tsi_amt%TYPE,
        p_ri_prem_amt     GIRI_WFRPERIL.ri_prem_amt%TYPE,
        p_ann_ri_s_amt    GIRI_WFRPERIL.ann_ri_s_amt%TYPE,
        p_ann_ri_pct      GIRI_WFRPERIL.ann_ri_pct%TYPE,
        p_ri_comm_rt      GIRI_WFRPERIL.ri_comm_rt%TYPE,
        p_ri_comm_amt     GIRI_WFRPERIL.ri_comm_amt%TYPE,
        p_ri_prem_vat     GIRI_WFRPERIL.ri_prem_vat%TYPE,
        p_ri_comm_vat     GIRI_WFRPERIL.ri_comm_vat%TYPE,
        p_prem_tax        GIRI_WFRPERIL.prem_tax%TYPE,
        p_ri_comm_amt2    GIRI_WFRPERIL.ri_comm_amt2%TYPE
    ) IS
    BEGIN
        UPDATE giri_wfrperil
           SET --peril_cd        =   p_peril_cd,
               ri_shr_pct      =   p_ri_shr_pct,
               ri_tsi_amt      =   p_ri_tsi_amt,
               ri_prem_amt     =   p_ri_prem_amt,
               --ann_ri_s_amt    =   p_ann_ri_s_amt, -- bonok :: 09.30.2014 :: to prevent saving null value in these columns
               --ann_ri_pct      =   p_ann_ri_pct,
               ri_comm_rt      =   p_ri_comm_rt,
               ri_comm_amt     =   p_ri_comm_amt,
               ri_prem_vat     =   p_ri_prem_vat,
               ri_comm_vat     =   p_ri_comm_vat,
               prem_tax        =   p_prem_tax,
               ri_comm_amt2    =   p_ri_comm_amt2
         WHERE line_cd         =   p_line_cd
           AND frps_yy         =   p_frps_yy
           AND frps_seq_no     =   p_frps_seq_no
           AND ri_seq_no       =   p_ri_seq_no
           AND ri_cd           =   p_ri_cd
           AND peril_cd        = p_peril_cd; -- andrew - added column peril_cd in the condtion - SR 0009759
    END set_giri_wfrperil;
    
    
    PROCEDURE get_sum_frperil_amounts (
        p_line_cd           IN  GIRI_WFRPERIL.line_cd%TYPE,
        p_frps_yy           IN  GIRI_WFRPERIL.frps_yy%TYPE,
        p_frps_seq_no       IN  GIRI_WFRPERIL.frps_seq_no%TYPE,
        p_ri_seq_no         IN  GIRI_WFRPERIL.ri_seq_no%TYPE,
        p_ri_cd             IN  GIRI_WFRPERIL.ri_cd%TYPE,
        p_sum_comm_amt      OUT NUMBER,
        p_sum_prem_amt      OUT NUMBER,
        p_sum_prem_vat      OUT NUMBER,
        p_sum_tsi_amt       OUT NUMBER
    ) IS
    BEGIN
      BEGIN
        SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem, 
               --SUM(ri_comm_amt) sum_comm, SUM(ri_prem_vat) sum_prem_vat
               SUM(ri_prem_amt * (ri_comm_rt/100)) sum_comm, SUM(ri_prem_vat) sum_prem_vat -- bonok :: 06.21.2013 :: recomputed for ri_comm_amt
          INTO p_sum_tsi_amt, p_sum_prem_amt, 
               p_sum_comm_amt, p_sum_prem_vat
          FROM giri_wfrperil
             WHERE line_cd = p_line_cd
               AND frps_yy = p_frps_yy
               AND frps_seq_no = p_frps_seq_no
               AND ri_seq_no = p_ri_seq_no
               AND ri_cd = p_ri_cd; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
               p_sum_tsi_amt  := 0; 
               p_sum_prem_amt := 0; 
               p_sum_comm_amt := 0; 
               p_sum_prem_vat := 0;     
      END;     
    END get_sum_frperil_amounts;
    
   /*
   **  Created by       : Jerome Orio 
   **  Date Created     : 07.22.2011 
   **  Reference By     : (GIRIS001- Create RI Placement) 
   **  Description      : offset_process program unit  
   */ 
    PROCEDURE offset_process(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE
        ) IS
    /*BETH 022499 this procedure is called after creation of records
    **            in giri_wfrperil , to make sure that values of prem_amt
    **            and tsi_amt in giri_wfrperil will tally with those
    **            in distribution tables
    */
      v_add_tsi         NUMBER := 0;
      v_add_tsi2       NUMBER := 0;
      v_add_prem       NUMBER := 0;
      v_add_prem2       NUMBER := 0;
    BEGIN
      FOR DIST_FRPS IN(SELECT '1'
                         FROM giri_wdistfrps 
                        WHERE line_cd     = p_line_cd
                          AND frps_yy     = p_frps_yy
                          AND frps_seq_no = p_frps_seq_no) LOOP
             FOR A1 IN( SELECT t6.peril_cd,  t2.dist_tsi, t2.dist_prem
                          FROM giuw_perilds_dtl T2,                 
                               giis_dist_share T3,
                               giri_wdistfrps T4,
                               giis_peril T6
                                          WHERE T2.line_cd     = T6.line_cd
                                            AND T2.peril_cd    = T6.peril_cd
                                            AND T2.line_cd     = T3.line_cd
                                    AND T2.share_cd    = T3.share_cd
                                            AND T3.share_type  = '3'
                                            AND T2.dist_no     = T4.dist_no
                                            AND T2.dist_seq_no = T4.dist_seq_no
                                            AND T4.line_cd     = p_line_cd
                                            AND T4.frps_yy     = p_frps_yy
                                            AND T4.frps_seq_no = p_frps_seq_no) LOOP
             v_add_tsi := 0;
             v_add_prem := 0;
             FOR A2 IN(SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                         FROM giri_wfrperil
                        WHERE line_cd     = p_line_cd
                          AND frps_yy     = p_frps_yy
                          AND frps_seq_no = p_frps_seq_no
                          AND peril_cd    = A1.peril_cd) LOOP
                 IF A1.dist_tsi != A2.sum_tsi THEN
                    v_add_tsi := nvl(A1.dist_tsi,0) - NVl(A2.sum_tsi,0); 
                 END IF;
                 IF A1.dist_prem != A2.sum_prem THEN
                    v_add_prem := nvl(A1.dist_prem,0) - NVl(A2.sum_prem,0); 
                 END IF;
             END LOOP;
             IF (v_add_tsi != 0) OR (v_add_prem != 0) THEN
                 FOR A3 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                              FROM giri_wfrps_ri
                             WHERE line_cd     = p_line_cd
                               AND frps_yy     = p_frps_yy
                               AND frps_seq_no = p_frps_seq_no) LOOP
                      FOR A4 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                                   FROM giri_wfrperil
                                  WHERE line_cd     = p_line_cd
                                    AND frps_yy     = p_frps_yy
                                    AND frps_seq_no = p_frps_seq_no
                                    AND ri_cd = A3.ri_cd) LOOP
                          IF A3.RI_TSI_AMT > A4.sum_tsi AND nvl(v_add_tsi,0) > 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 > v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = p_line_cd
                                AND frps_yy     = p_frps_yy
                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                          ELSIF A3.RI_TSI_AMT < A4.sum_tsi AND nvl(v_add_tsi,0) < 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 < v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = p_line_cd
                                AND frps_yy     = p_frps_yy
                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                           END IF;
                          IF A3.RI_prem_AMT > A4.sum_prem AND nvl(v_add_prem,0) > 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 > v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = p_line_cd
                                AND frps_yy     = p_frps_yy
                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                          ELSIF A3.RI_prem_AMT < A4.sum_prem AND nvl(v_add_prem,0) < 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 < v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = p_line_cd
                                AND frps_yy     = p_frps_yy
                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                           END IF;
                        end loop;

      end loop; 
      end if;
      end loop;
      exit; 
      end loop;
      FOR DIST_FRPS1 IN(SELECT '1'
                          FROM giri_distfrps 
                         WHERE line_cd     = p_line_cd
                           AND frps_yy     = p_frps_yy
                           AND frps_seq_no = p_frps_seq_no) LOOP
             FOR A1 IN( SELECT t6.peril_cd,  t2.dist_tsi, t2.dist_prem
                          FROM giuw_perilds_dtl T2, 				
                               giis_dist_share T3,
                               giri_distfrps T4,
                               giis_peril T6
                         WHERE T2.line_cd     = T6.line_cd
                           AND T2.peril_cd    = T6.peril_cd
                           AND T2.line_cd     = T3.line_cd
                           AND T2.share_cd    = T3.share_cd
                           AND T3.share_type  = '3'
                           AND T2.dist_no     = T4.dist_no
                           AND T2.dist_seq_no = T4.dist_seq_no
                           AND T4.line_cd     = p_line_cd
                           AND T4.frps_yy     = p_frps_yy
                           AND T4.frps_seq_no = p_frps_seq_no) LOOP
             v_add_tsi := 0;
             v_add_prem := 0;
             FOR A2 IN(SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                         FROM giri_wfrperil
                            WHERE line_cd     = p_line_cd
                                AND frps_yy     = p_frps_yy
                                AND frps_seq_no = p_frps_seq_no
                          AND peril_cd    = A1.peril_cd) LOOP
                 IF A1.dist_tsi != A2.sum_tsi THEN
                    v_add_tsi := nvl(A1.dist_tsi,0) - NVl(A2.sum_tsi,0); 
                 END IF;
                 IF A1.dist_prem != A2.sum_prem THEN
                    v_add_prem := nvl(A1.dist_prem,0) - NVl(A2.sum_prem,0); 
                 END IF;
             END LOOP;
             IF (v_add_tsi != 0) OR (v_add_prem != 0) THEN
                 FOR A3 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                              FROM giri_wfrps_ri
                             WHERE line_cd     = p_line_cd
                                             AND frps_yy     = p_frps_yy
                                             AND frps_seq_no = p_frps_seq_no) LOOP
                      FOR A4 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                                   FROM giri_wfrperil
                                  WHERE line_cd    = p_line_cd
                                                  AND frps_yy     = p_frps_yy
                                                    AND frps_seq_no = p_frps_seq_no
                                    AND ri_cd = A3.ri_cd) LOOP
                          IF A3.RI_TSI_AMT > A4.sum_tsi AND nvl(v_add_tsi,0) > 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 > v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = p_line_cd
                                                AND frps_yy     = p_frps_yy
                                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                          ELSIF A3.RI_TSI_AMT < A4.sum_tsi AND nvl(v_add_tsi,0) < 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 < v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = p_line_cd
                                                AND frps_yy     = p_frps_yy
                                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                           END IF;
                          IF A3.RI_prem_AMT > A4.sum_prem AND nvl(v_add_prem,0) > 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 > v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = p_line_cd
                                                AND frps_yy     = p_frps_yy
                                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                          ELSIF A3.RI_prem_AMT < A4.sum_prem AND nvl(v_add_prem,0) < 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 < v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = p_line_cd
                                                AND frps_yy     = p_frps_yy
                                                AND frps_seq_no = p_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                           END IF;
                        end loop;

      end loop; 
      end if;
      end loop;
      exit; 
      end loop;
      Giri_Wfrperil_Pkg.FINAL_OFFSET(p_dist_no, p_dist_seq_no, p_line_cd, p_frps_yy, p_frps_seq_no);
    END;     
       
 /*
   **  Created by       : Jerome Orio 
   **  Date Created     : 07.22.2011 
   **  Reference By     : (GIRIS001- Create RI Placement) 
   **  Description      : FINAL_OFFSET program unit  
   */     
    PROCEDURE FINAL_OFFSET(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE
        ) IS
    /*BETH 022499 process final offsetting of prem _amt and tsi
    **            to make sure that thier values tallie between tables 
    **            giri_wfrperil and giri_wfrps_ri
    */
      v_add_tsi  	   NUMBER := 0;
      v_add_tsi2	   NUMBER := 0;
      v_add_prem	   NUMBER := 0;
      v_add_prem2	   NUMBER := 0;
      v_add2_prem	   NUMBER := 0;
      v_add2_prem2	   NUMBER := 0;
    BEGIN
      FOR A1 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                   FROM giri_wfrps_ri
                  WHERE line_cd     = p_line_cd
                    AND frps_yy     = p_frps_yy
               AND frps_seq_no = p_frps_seq_no) LOOP
          v_add_tsi :=  0;
          v_add_prem := 0;
          FOR A2 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                       FROM giri_wfrperil
                      WHERE line_cd    = p_line_cd
                    AND frps_yy     = p_frps_yy
                    AND frps_seq_no = p_frps_seq_no
                        AND ri_cd = A1.ri_cd) LOOP
              IF A1.ri_tsi_amt != A2.sum_tsi THEN
                 v_add_tsi := nvl(A1.ri_tsi_amt,0) - NVl(A2.sum_tsi,0); 
              END IF;
              IF A1.ri_prem_amt != A2.sum_prem THEN
                 v_add_prem := nvl(A1.Ri_prem_amt,0) - NVl(A2.sum_prem,0); 
              END IF;
          END LOOP;
          IF (v_add_tsi != 0) OR (v_add_prem != 0) THEN
               FOR A3 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                            FROM giri_wfrps_ri
                           WHERE line_cd     = p_line_cd
                         AND frps_yy     = p_frps_yy
                         AND frps_seq_no = p_frps_seq_no
                             AND ri_cd      !=  A1.RI_CD) LOOP
               FOR A4 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem, MAX(PERIL_CD) peril_cd
                            FROM giri_wfrperil
                           WHERE line_cd    = p_line_cd
                     AND frps_yy     = p_frps_yy
                     AND frps_seq_no = p_frps_seq_no
                             AND ri_cd = A3.ri_cd) LOOP
                   IF A3.RI_TSI_AMT > A4.sum_tsi AND nvl(v_add_tsi,0) < 0 THEN
                      v_add_tsi2 := 0;
                      v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                      IF v_add_tsi2 > v_add_tsi THEN
                      v_add_tsi2 := v_add_tsi;
                      END IF;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                       WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no  
                         AND ri_cd       = A1.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt - v_add_tsi2
                       WHERE line_cd     = p_line_cd
                         AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no  
                         AND ri_cd       = A3.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                   ELSIF A3.RI_TSI_AMT < A4.sum_tsi AND nvl(v_add_tsi,0) > 0 THEN
                         v_add_tsi2 := 0;
                      v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                      IF v_add_tsi2 < v_add_tsi THEN
                         v_add_tsi2 := v_add_tsi;
                      END IF;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                       WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no  
                         AND ri_cd       = A1.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt - v_add_tsi2
                       WHERE line_cd     = p_line_cd
                 AND frps_yy     = p_frps_yy
                 AND frps_seq_no = p_frps_seq_no  
                         AND ri_cd       = A3.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);   
                  END IF;

                  IF A3.RI_prem_AMT > A4.sum_prem AND nvl(v_add_prem,0) < 0 THEN
                     v_add_prem2 := 0;
                     v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                     IF v_add_prem2 > v_add_prem THEN
                        v_add_prem2 := v_add_prem;
                     END IF;
                     UPDATE giri_wfrperil
                        SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                            ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                      WHERE line_cd     = p_line_cd
                    AND frps_yy     = p_frps_yy
                AND frps_seq_no = p_frps_seq_no  
                        AND ri_cd       = A1.ri_cd
                        AND peril_cd    = A4.peril_cd
                        AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                     UPDATE giri_wfrperil
                        SET ri_prem_amt = ri_prem_amt - v_add_prem2,
                            ri_comm_amt = (ri_prem_amt - v_add_prem2)*(ri_comm_rt/100)
                      WHERE line_cd     = p_line_cd
                    AND frps_yy     = p_frps_yy
                AND frps_seq_no = p_frps_seq_no  
                        AND ri_cd       = A3.ri_cd
                        AND peril_cd    = A4.peril_cd
                        AND ABS(ri_prem_amt) > 0.01;
                     v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                     ELSIF A3.RI_prem_AMT < A4.sum_prem AND nvl(v_add_prem,0) > 0 THEN
                           v_add_prem2 := 0;
                           v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                           IF v_add_prem2 < v_add_prem THEN
                              v_add_prem2 := v_add_prem;
                           END IF;
                           UPDATE giri_wfrperil
                              SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                  ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                            WHERE line_cd     = p_line_cd
                      AND frps_yy     = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no  
                              AND ri_cd       = A1.ri_cd
                              AND peril_cd    = A4.peril_cd
                              AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                           UPDATE giri_wfrperil
                              SET ri_prem_amt = ri_prem_amt - v_add_prem2,
                                  ri_comm_amt = (ri_prem_amt - v_add_prem2)*(ri_comm_rt/100)
                            WHERE line_cd     = p_line_cd
                      AND frps_yy     = p_frps_yy
                      AND frps_seq_no = p_frps_seq_no  
                              AND ri_cd       = A3.ri_cd
                              AND peril_cd    = A4.peril_cd
                              AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                           v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                     END IF;

                        end loop;
    END LOOP;
    END IF;
    END LOOP;

      FOR A1 IN
          ( SELECT peril_cd, dist_prem prem
              FROM giuw_perilds_dtl T1, giis_dist_share T2
             WHERE T1.line_cd    = T2.line_cd
               AND T1.share_cd   = T2.share_cd
               AND T2.share_type = '3'
               AND dist_no       = p_dist_no
               AND dist_seq_no   = p_dist_seq_no
               AND T1.line_cd    = p_line_cd
          ) LOOP
          v_add2_prem := 0;
          FOR A2 IN
              ( SELECT SUM(ri_prem_amt) prem
                  FROM giri_wfrperil
                 WHERE line_cd    = p_line_cd
               AND frps_yy     = p_frps_yy
               AND frps_seq_no = p_frps_seq_no
                   AND peril_cd = A1.peril_cd
                GROUP BY peril_cd
              ) LOOP
              IF A1.prem <> A2.prem THEN
                 v_add2_prem := A1.prem - A2.prem;
                 FOR A3 IN        
                     ( SELECT peril_cd, dist_prem prem
                         FROM giuw_perilds_dtl T1, giis_dist_share T2
                        WHERE T1.line_cd    = T2.line_cd
                          AND T1.share_cd   = T2.share_cd
                          AND T2.share_type = '3'
                          AND dist_no       = p_dist_no
                          AND dist_seq_no   = p_dist_seq_no
                          AND T1.line_cd    = p_line_cd
                          AND T1.peril_cd <> A1.peril_cd
                     ) LOOP
                     FOR A4 IN
                         ( SELECT SUM(ri_prem_amt) prem
                             FROM giri_wfrperil
                            WHERE line_cd    = p_line_cd
                          AND frps_yy     = p_frps_yy
                          AND frps_seq_no = p_frps_seq_no
                              AND peril_cd = A3.peril_cd
                           GROUP BY peril_cd
                         ) LOOP
                     IF (v_add2_prem > 0 AND (A3.prem < A4.prem)) THEN
                         v_add2_prem2 := A4.prem - A3.prem;
                         IF v_add2_prem <= v_add2_prem2 THEN
                            v_add2_prem2 := v_add2_prem;
                            v_add2_prem := 0;
                         ELSE
                            v_add2_prem := v_add2_prem - v_add2_prem2;
                         END IF;
                         FOR A5 IN
                             (SELECT MIN(ri_cd) ri_cd
                                FROM giri_wfrperil
                               WHERE line_cd    = p_line_cd
                             AND frps_yy     = p_frps_yy
                             AND frps_seq_no = p_frps_seq_no
                             )LOOP
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add2_prem2                    
                              WHERE line_cd    = p_line_cd
                                AND frps_yy     = p_frps_yy
                            AND frps_seq_no = p_frps_seq_no
                                AND peril_cd = A1.peril_cd
                                AND ri_cd = A5.ri_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt - v_add2_prem2                    
                              WHERE line_cd    = p_line_cd
                                AND frps_yy     = p_frps_yy
                            AND frps_seq_no = p_frps_seq_no
                                AND peril_cd = A3.peril_cd
                                AND ri_cd = A5.ri_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                            EXIT;
                         END LOOP;
                     ELSIF v_add2_prem < 0 AND (A4.prem < A3.prem) THEN
                         v_add2_prem2 := A4.prem - A3.prem;
                         IF v_add2_prem  >= v_add2_prem2 THEN
                            v_add2_prem2 := v_add2_prem;
                            v_add2_prem := 0;
                         ELSE
                            v_add2_prem := v_add2_prem - v_add2_prem2;
                         END IF;
                         FOR A5 IN
                             (SELECT MIN(ri_cd) ri_cd
                                FROM giri_wfrperil
                               WHERE line_cd    = p_line_cd
                             AND frps_yy     = p_frps_yy
                             AND frps_seq_no = p_frps_seq_no
                             )LOOP
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add2_prem2                    
                              WHERE line_cd    = p_line_cd
                                AND frps_yy     = p_frps_yy
                            AND frps_seq_no = p_frps_seq_no
                                AND peril_cd = A1.peril_cd
                                AND ri_cd = A5.ri_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt - v_add2_prem2                    
                              WHERE line_cd    = p_line_cd
                                AND frps_yy     = p_frps_yy
                            AND frps_seq_no = p_frps_seq_no
                                AND peril_cd = A3.peril_cd
                                AND ri_cd = A5.ri_cd
                                AND ABS(ri_prem_amt) > 0.01;--issa09.10.2007 to resolve diff of -0.01 and 0.01 in giris002, ri acceptance
                             EXIT;
                         END LOOP;
                      END IF;
                     END LOOP;
                     IF v_add2_prem = 0 THEN
                        exit;
                      END IF;
                END LOOP;
             END IF;
       END LOOP;
      END LOOP;  
    END;
    
   /*
   **  Created by       : Jerome Orio 
   **  Date Created     : 07.22.2011 
   **  Reference By     : (GIRIS001- Create RI Placement) 
   **  Description      : CREATE_WFRPERIL_R program unit  
   */  
    PROCEDURE CREATE_WFRPERIL_R(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_tot_fac_spct      IN GIRI_DISTFRPS.tot_fac_spct%TYPE
        ) IS
        cursor param_prem_tax is
            select param_value_n
              from giis_parameters
             where param_name like 'RI PREMIUM TAX';
      CURSOR mwfrperil_area IS
        SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
               T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
               T5.ri_shr_pct, (T5.ri_shr_pct/100) * T1.tsi_amt ri_tsi_amt, 
               (nvl(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt ri_prem_amt,
               T6.ri_comm_rt, 
               (T6.ri_comm_rt/100) * ((nvl(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt) ri_comm_amt,
               ((nvl(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt) * (T7.input_vat_rate/100) ri_prem_vat,
               ((T6.ri_comm_rt/100) * ((nvl(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt)) * (T7.input_vat_rate/100) ri_comm_vat,
               /*T8.param_value_n,*/ T7.local_foreign_sw			--Lem 
          FROM giuw_perilds T1, 
               giuw_perilds_dtl T2, 
               giis_dist_share T3,
               giri_distfrps T4,
               giri_wfrps_ri T5,
               giis_peril T6, 
               giis_reinsurer T7/*,
               giis_parameters T8	*/		--Lem
         WHERE T1.line_cd     = T6.line_cd
           AND T1.peril_cd    = T6.peril_cd
           AND T1.dist_no     = T2.dist_no
           AND T1.dist_seq_no = T2.dist_seq_no
           AND T1.line_cd     = T2.line_cd
           AND T1.peril_cd    = T2.peril_cd
           AND T2.line_cd     = T3.line_cd
           AND T2.share_cd    = T3.share_cd
           AND T3.share_type  = '3'
           AND T7.ri_cd       = T5.ri_cd
           AND T1.dist_no     = T4.dist_no
           AND T1.dist_seq_no = T4.dist_seq_no
           AND T4.line_cd     = T5.line_cd
           AND T4.frps_yy     = T5.frps_yy
           AND T4.frps_seq_no = T5.frps_seq_no
           AND T4.line_cd     = p_line_cd
           AND T4.frps_yy     = p_frps_yy
           /*AND T8.param_name	= 'RI PREMIUM TAX'*/			--Lem
           AND T4.frps_seq_no = p_frps_seq_no;
     v_comm_amt           giri_frps_ri.ri_comm_amt%TYPE :=0;
     v_comm_rt            giri_frps_ri.ri_comm_rt%TYPE  :=0;
     v_comm_vat           giri_frps_ri.ri_comm_vat%TYPE  :=0;
      CURSOR sum_spct IS
         SELECT SUM(ri_shr_pct) sum_spct
           FROM giri_wfrps_ri
          WHERE line_cd     = p_line_cd
            AND frps_yy     = p_frps_yy
            AND frps_seq_no = p_frps_seq_no;  
      v_spct_total       NUMBER :=0;
      v_dist_no          NUMBER(8);
      v_prem_vat           giri_frps_ri.ri_prem_vat%TYPE  :=0;
        v_tax_rate					giis_parameters.param_value_n%TYPE:=0;
     BEGIN
        FOR v in param_prem_tax LOOP
            v_tax_rate := v.param_value_n;
        END LOOP;
      FOR A1 IN(SELECT policy_id
                  FROM giuw_pol_dist 
                 WHERE dist_no = p_dist_no)LOOP 
          FOR A2 IN(SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE policy_id = A1.policy_id
                       AND negate_date = (SELECT MAX(negate_date)
                                            FROM giuw_pol_dist
                                           WHERE policy_id = A1.policy_id
                                             AND negate_date IS NOT NULL)
                                        ORDER BY dist_no desc )LOOP
              v_dist_no := a2.dist_no;
              EXIT;
          END LOOP;
          EXIT;
      END LOOP;
      FOR c1_rec in mwfrperil_area LOOP
            v_comm_amt :=  c1_rec.ri_comm_amt;
            v_comm_rt  :=  c1_rec.ri_comm_rt;
            v_comm_vat  :=  c1_rec.ri_comm_vat;
            
            --BETH 042099 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            IF v_dist_no IS NOT NULL THEN
               FOR C1 IN(SELECT frps_yy, frps_seq_no,line_cd
                            FROM giri_distfrps
                           WHERE dist_no = v_dist_no)LOOP
                   FOR C2 IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat
                               FROM giri_frps_ri a, giri_frperil b
                              WHERE a.line_cd       = b.line_cd
                                AND a.frps_YY       = b.frps_yy
                                AND a.frps_seq_no   = b.frps_seq_no
                                AND a.ri_cd         = b.ri_cd
                                AND a.ri_seq_no     = b.ri_seq_no
                                AND b.peril_cd      = c1_rec.peril_cd
                                AND a.line_cd       = c1.line_cd
                                AND a.frps_YY       = c1.frps_yy
                                                AND a.frps_seq_no   = c1.frps_seq_no
                                AND a.fnl_binder_id = c1_rec.pre_binder_id
                                AND a.ri_cd         = c1_rec.ri_cd
                                AND reverse_sw    = 'N')LOOP
                       v_comm_amt :=  c2.ri_comm_amt;
                       v_comm_rt  :=  c2.ri_comm_rt;
                       v_comm_vat  :=  c2.ri_comm_vat;
                       EXIT;
                    END LOOP;
                    EXIT;
               END LOOP;          
            END IF;
            FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat
                            FROM giri_frps_ri a, giri_frperil b
                           WHERE a.line_cd       = b.line_cd
                             AND a.frps_YY       = b.frps_yy
                                                     AND a.frps_seq_no   = b.frps_seq_no
                             AND a.ri_cd         = b.ri_cd
                             AND b.peril_cd      = c1_rec.peril_cd
                             AND a.line_cd       = c1_rec.line_cd
                             AND a.frps_YY       = c1_rec.frps_yy
                                                     AND a.frps_seq_no   = c1_rec.frps_seq_no
                             AND a.fnl_binder_id = c1_rec.pre_binder_id
                             AND a.ri_cd         = c1_rec.ri_cd
                             AND reverse_sw    = 'N')LOOP
                v_comm_amt :=  c2_rec.ri_comm_amt;
                v_comm_rt  :=  c2_rec.ri_comm_rt;
                v_comm_vat  :=  c2_rec.ri_comm_vat;
                EXIT;
            END LOOP;
        v_prem_vat := nvl(c1_rec.ri_prem_vat,0); --A.R.C. 05.09.2007
        giri_wfrps_ri_pkg.ADJUST_PREM_VAT(v_prem_vat,c1_rec.ri_cd,p_line_cd,p_iss_cd,p_par_yy,p_par_seq_no,p_subline_cd,p_issue_yy,p_pol_seq_no,p_renew_no);  --A.R.C. 05.09.2007    
        --msg_alert (v_prem_vat,'I',FALSE); 	
        IF c1_rec.local_foreign_sw != 'L' then			--L.D.G.	07/14/2008 
          INSERT INTO giri_wfrperil
            (line_cd, frps_yy, frps_seq_no,            
             ri_seq_no, peril_cd, ri_cd,                  
             ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
             ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
             ri_comm_amt, ri_prem_vat, ri_comm_vat,
             prem_tax)
          VALUES
            (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
             c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
             nvl(c1_rec.ri_shr_pct,0), nvl(c1_rec.ri_tsi_amt,0), nvl(c1_rec.ri_prem_amt,0),            
             nvl(c1_rec.ri_tsi_amt,0), nvl(c1_rec.ri_shr_pct,0), v_comm_rt,             
             v_comm_amt, v_prem_vat, v_comm_vat, round(c1_rec.ri_prem_amt*(V_TAX_RATE / 100),2));  --Lem
        ELSE
        INSERT INTO giri_wfrperil
          (line_cd, frps_yy, frps_seq_no,            
           ri_seq_no, peril_cd, ri_cd,                  
           ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
           ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
           ri_comm_amt, ri_prem_vat, ri_comm_vat
           ,prem_tax)
        VALUES
          (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
           c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
           c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_prem_amt,            
           c1_rec.ri_tsi_amt, c1_rec.ri_shr_pct, v_comm_rt,             
           v_comm_amt, v_prem_vat, v_comm_vat, 0); 
      END IF;							--L.D.G.	07/14/2008 
      END LOOP;
      FOR A3 IN sum_spct LOOP
          v_spct_total := A3.sum_spct;
      END LOOP;
      IF p_tot_fac_spct = v_spct_total THEN
         GIRI_WFRPERIL_PKG.offset_process(p_dist_no, p_dist_seq_no, p_line_cd, p_frps_yy, p_frps_seq_no);
      END IF;
    END;    

   /*
   **  Created by       : Jerome Orio 
   **  Date Created     : 07.22.2011 
   **  Reference By     : (GIRIS001- Create RI Placement) 
   **  Description      : CREATE_WFRPERIL_M program unit  
   */ 
    --populates giri_wfrperil after records are inserted in giri_wfrps_ri
    PROCEDURE CREATE_WFRPERIL_M(
        p_dist_no           giuw_perilds_dtl.dist_no%TYPE,
        p_dist_seq_no       giuw_perilds_dtl.dist_seq_no%TYPE,
        p_line_cd           GIRI_WFRPS_PERIL_GRP.line_cd%TYPE,
        p_frps_yy           GIRI_WFRPS_PERIL_GRP.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WFRPS_PERIL_GRP.frps_seq_no%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_par_yy            IN gipi_parlist.par_yy%TYPE,
        p_par_seq_no        IN gipi_parlist.par_seq_no%TYPE,
        p_subline_cd        IN VARCHAR2,
        p_issue_yy          IN VARCHAR2,
        p_pol_seq_no        IN VARCHAR2,
        p_renew_no          IN VARCHAR2,
        p_tot_fac_spct      IN GIRI_DISTFRPS.tot_fac_spct%TYPE    
        ) IS
        CURSOR param_prem_tax
      IS
         SELECT param_value_n
           FROM giis_parameters
          WHERE param_name LIKE 'RI PREMIUM TAX';

      CURSOR mwfrperil_area
      IS
         SELECT t4.line_cd, t5.frps_yy, t5.frps_seq_no, t5.pre_binder_id,
                t5.ri_seq_no, t2.peril_cd, t5.ri_cd, t5.ri_shr_pct,
                (t5.ri_shr_pct / 100) * t1.tsi_amt ri_tsi_amt,
                  (NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100)
                * t1.prem_amt ri_prem_amt,
                t6.ri_comm_rt,
                  (t6.ri_comm_rt / 100)
                * ((NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100) * t1.prem_amt)
                                                                 ri_comm_amt,
                  ((NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100) * t1.prem_amt
                  )
                * (input_vat_rate / 100) ri_prem_vat,
                (  (t6.ri_comm_rt / 100)
                 * ((NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100) * t1.prem_amt
                   )
                 * (input_vat_rate / 100)
                ) ri_comm_vat,
                
                /*T8.param_value_n,*/
                t7.local_foreign_sw                                     --Lem
                                   ,
                t4.dist_seq_no                   --added by mikel 11.28.2011;
           FROM giuw_perilds t1,
                giuw_perilds_dtl t2,
                giis_dist_share t3,
                giri_wdistfrps t4,
                giri_wfrps_ri t5,
                giis_peril t6,
                giis_reinsurer t7                                          /*,
                                                          giis_parameters T8*/
          WHERE t1.line_cd = t6.line_cd
            AND t1.peril_cd = t6.peril_cd
            AND t1.dist_no = t2.dist_no
            AND t1.dist_seq_no = t2.dist_seq_no
            AND t1.line_cd = t2.line_cd
            AND t1.peril_cd = t2.peril_cd
            AND t2.line_cd = t3.line_cd
            AND t2.share_cd = t3.share_cd
            AND t3.share_type = '3'
            AND t7.ri_cd = t5.ri_cd
            AND t1.dist_no = t4.dist_no
            AND t1.dist_seq_no = t4.dist_seq_no
            AND t4.line_cd = t5.line_cd
            AND t4.frps_yy = t5.frps_yy
            AND t4.frps_seq_no = t5.frps_seq_no
            AND t4.line_cd = p_line_cd
            AND t4.frps_yy = p_frps_yy
            AND t4.frps_seq_no = p_frps_seq_no;

      --AND T8.param_name  = 'RI PREMIUM TAX';
      v_prem         NUMBER                               := 0;
      v_tsi          NUMBER                               := 0;
      v_prem_vat     NUMBER                               := 0;
      v_prem_tax     giri_wfrperil.prem_tax%TYPE          := 0;          --Lem
      v_comm_amt     giri_frps_ri.ri_comm_amt%TYPE        := 0;
      v_comm_rt      giri_frps_ri.ri_comm_rt%TYPE         := 0;
      v_comm_vat     NUMBER                               := 0;

      CURSOR sum_premtotal
      IS
         SELECT SUM (t2.dist_prem) sum_prem
           FROM giuw_perilds_dtl t2,
                giis_dist_share t3,
                giri_wdistfrps t4,
                giis_peril t6
          WHERE t2.line_cd = t6.line_cd
            AND t2.peril_cd = t6.peril_cd
            AND t2.line_cd = t3.line_cd
            AND t2.share_cd = t3.share_cd
            AND t3.share_type = '3'
            AND t2.dist_no = t4.dist_no
            AND t2.dist_seq_no = t4.dist_seq_no
            AND t4.frps_yy = p_frps_yy
            AND t4.frps_seq_no = p_frps_seq_no;

      CURSOR sum_tsitotal
      IS
         SELECT SUM (t2.dist_tsi) sum_tsi
           FROM giuw_perilds_dtl t2,
                giis_dist_share t3,
                giri_wdistfrps t4,
                giis_peril t6
          WHERE t2.line_cd = t6.line_cd
            AND t2.peril_cd = t6.peril_cd
            AND t2.line_cd = t3.line_cd
            AND t2.share_cd = t3.share_cd
            AND t3.share_type = '3'
            AND t2.dist_no = t4.dist_no
            AND t2.dist_seq_no = t4.dist_seq_no
            AND t6.peril_type = 'B'
            AND t4.line_cd = p_line_cd
            AND t4.frps_yy = p_frps_yy
            AND t4.frps_seq_no = p_frps_seq_no;

/*BETH 022499 this cursor is created for policy which are distributed by perils
**            it uses a formula which is derived through ratio and propotion
**            to arrived at the correct values of prem_amt and tsi-amt
*/
      CURSOR mwfrperil_area2
      IS
         SELECT t4.line_cd, t5.frps_yy, t5.frps_seq_no, t5.pre_binder_id,
                t5.ri_seq_no, t2.peril_cd, t5.ri_cd, t5.ri_shr_pct,
                (t2.dist_tsi / v_tsi) * t5.ri_tsi_amt ri_tsi_amt,
                (t2.dist_prem / v_prem) * t5.ri_prem_amt ri_prem_amt,
                t6.ri_comm_rt,
                  (t6.ri_comm_rt / 100)
                * ((t2.dist_prem / v_prem) * t5.ri_prem_amt) ri_comm_amt,
                (  (t2.dist_prem / v_prem)
                 * t5.ri_prem_amt
                 * t7.input_vat_rate
                 / 100
                ) ri_prem_vat,
                (  (t6.ri_comm_rt / 100)
                 * ((t2.dist_prem / v_prem) * t5.ri_prem_amt)
                 * (t7.input_vat_rate / 100)
                ) ri_comm_vat,
                
                /*T8.param_value_n,*/
                t7.local_foreign_sw, t4.dist_seq_no                      --Lem
           FROM giuw_perilds t1,
                giuw_perilds_dtl t2,
                giis_dist_share t3,
                giri_wdistfrps t4,
                giri_wfrps_ri t5,
                giis_peril t6,
                giis_reinsurer t7                                          /*,
                                                          giis_parameters T8*/
          WHERE t1.line_cd = t6.line_cd
            AND t1.peril_cd = t6.peril_cd
            AND t1.dist_no = t2.dist_no
            AND t1.dist_seq_no = t2.dist_seq_no
            AND t1.line_cd = t2.line_cd
            AND t1.peril_cd = t2.peril_cd
            AND t2.line_cd = t3.line_cd
            AND t2.share_cd = t3.share_cd
            AND t3.share_type = '3'
            AND t5.ri_cd = t7.ri_cd
            AND t1.dist_no = t4.dist_no
            AND t1.dist_seq_no = t4.dist_seq_no
            AND t4.line_cd = t5.line_cd
            AND t4.frps_yy = t5.frps_yy
            AND t4.frps_seq_no = t5.frps_seq_no
            AND t4.line_cd = p_line_cd
            AND t4.frps_yy = p_frps_yy
            --AND T8.param_name  = 'RI PREMIUM TAX'
            AND t4.frps_seq_no = p_frps_seq_no;

      CURSOR sum_spct
      IS
         SELECT SUM (ri_shr_pct) sum_spct
           FROM giri_wfrps_ri
          WHERE line_cd = p_line_cd
            AND frps_yy = p_frps_yy
            AND frps_seq_no = p_frps_seq_no;

      v_pol_flag     VARCHAR2 (1);
      v_spct_total   NUMBER                               := 0;
      v_cnt2         NUMBER                               := 0;
      v_dist_no      NUMBER (8);
      v_tax_rate     giis_parameters.param_value_n%TYPE   := 0;
   BEGIN
      FOR v IN param_prem_tax
      LOOP
         v_tax_rate := v.param_value_n;
      END LOOP;

      FOR a1 IN (SELECT policy_id
                   FROM giuw_pol_dist
                  WHERE dist_no = p_dist_no)
      LOOP
         FOR a2 IN (SELECT   dist_no
                        FROM giuw_pol_dist
                       WHERE policy_id = a1.policy_id
                         AND negate_date =
                                (SELECT MAX (negate_date)
                                   FROM giuw_pol_dist
                                  WHERE policy_id = a1.policy_id
                                    AND negate_date IS NOT NULL)
                    ORDER BY dist_no DESC)
         LOOP
            v_dist_no := a2.dist_no;
            EXIT;
         END LOOP;

         EXIT;
      END LOOP;

--BETH 020999 add a condition that seperates creation of records in giri_wfrperil
--            depending on what type of distribution
      FOR a1 IN (SELECT post_flag
                   FROM giuw_pol_dist
                  WHERE dist_no = p_dist_no)
      LOOP
         v_pol_flag := a1.post_flag;
         EXIT;
      END LOOP;

      IF v_pol_flag = 'P'
      THEN
         FOR a1 IN sum_premtotal
         LOOP
--       v_prem  := A1.sum_prem;
            IF a1.sum_prem = 0
            THEN                                   --added by grace, 02022004
               v_prem := 1;              --to resolve ora-01467 (zero divide)
            ELSE                                --for endts with zero (0) prem
               v_prem := a1.sum_prem;
            END IF;                                --end of added codes, grace

            EXIT;
         END LOOP;

         FOR a2 IN sum_tsitotal
         LOOP
--         v_tsi  := A2.sum_tsi;           --commented by bdarusin, 12132002
            IF a2.sum_tsi = 0
            THEN                                --added by bdarusin, 12132002
               v_tsi := 1;               --to resolve ora-01467 (zero divide)
            ELSE                                 --for endts with zero (0) tsi
               v_tsi := a2.sum_tsi;
            END IF;                             --end of added codes, bdarusin

            EXIT;
         END LOOP;

         FOR c1_rec IN mwfrperil_area2
         LOOP
            v_comm_amt := c1_rec.ri_comm_amt;
            v_comm_rt := c1_rec.ri_comm_rt;
            v_comm_vat := c1_rec.ri_comm_vat;

            --BETH 042099 check if there is an existing record in the
            --     final table and get ri_comm_amt and ri_comm_rt from it
            IF v_dist_no IS NOT NULL
            THEN
               FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd
                            FROM giri_distfrps
                           WHERE dist_no = v_dist_no)
               LOOP
                  FOR c2 IN (SELECT b.ri_comm_rt, b.ri_comm_amt,
                                    b.ri_comm_vat
                               FROM giri_frps_ri a, giri_frperil b
                              WHERE a.line_cd = b.line_cd
                                AND a.frps_yy = b.frps_yy
                                AND a.frps_seq_no = b.frps_seq_no
                                AND a.ri_cd = b.ri_cd
                                AND a.ri_seq_no = b.ri_seq_no
                                AND b.peril_cd = c1_rec.peril_cd
                                AND a.line_cd = c1.line_cd
                                AND a.frps_yy = c1.frps_yy
                                AND a.frps_seq_no = c1.frps_seq_no
                                AND a.fnl_binder_id = c1_rec.pre_binder_id
                                AND a.ri_cd = c1_rec.ri_cd
                                AND reverse_sw = 'N')
                  LOOP
                     v_comm_amt := c2.ri_comm_amt;
                     v_comm_rt := c2.ri_comm_rt;
                     v_comm_vat := c2.ri_comm_vat;
                     EXIT;
                  END LOOP;

                  EXIT;
               END LOOP;
            END IF;

            --BETH 040699 check if there is an existing record in the
            --     final table and get ri_comm_amt and ri_comm_rt from it
            FOR c2_rec IN (SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat
                             FROM giri_frps_ri a, giri_frperil b
                            WHERE a.line_cd = b.line_cd
                              AND a.frps_yy = b.frps_yy
                              AND a.frps_seq_no = b.frps_seq_no
                              AND a.ri_cd = b.ri_cd
                              AND b.peril_cd = c1_rec.peril_cd
                              AND a.line_cd = c1_rec.line_cd
                              AND a.frps_yy = c1_rec.frps_yy
                              AND a.frps_seq_no = c1_rec.frps_seq_no
                              AND a.fnl_binder_id = c1_rec.pre_binder_id
                              AND a.ri_cd = c1_rec.ri_cd
                              AND reverse_sw = 'N')
            LOOP
               v_comm_amt := c2_rec.ri_comm_amt;
               v_comm_rt := c2_rec.ri_comm_rt;
               v_comm_vat := c2_rec.ri_comm_vat;
               EXIT;
            END LOOP;

            v_prem_vat := NVL (c1_rec.ri_prem_vat, 0);     --A.R.C. 05.09.2007
            giri_wfrps_ri_pkg.adjust_prem_vat (v_prem_vat,
                                               c1_rec.ri_cd,
                                               p_line_cd,
                                               p_iss_cd,
                                               p_par_yy,
                                               p_par_seq_no,
                                               p_subline_cd,
                                               p_issue_yy,
                                               p_pol_seq_no,
                                               p_renew_no
                                              );           --A.R.C. 05.09.2007

            --msg_alert (c1_rec.ri_prem_amt||'-'||V_TAX_RATE,'I',FALSE);
            IF c1_rec.local_foreign_sw != 'L'
            THEN                                           --L.D.G. 07/14/2008
               INSERT INTO giri_wfrperil
                           (line_cd, frps_yy,
                            frps_seq_no, ri_seq_no,
                            peril_cd, ri_cd,
                            ri_shr_pct,
                            ri_tsi_amt,
                            ri_prem_amt,
                            ann_ri_s_amt,
                            ann_ri_pct, ri_comm_rt,
                            ri_comm_amt, ri_prem_vat, ri_comm_vat,
                            prem_tax
                           )
                    VALUES (c1_rec.line_cd, c1_rec.frps_yy,
                            c1_rec.frps_seq_no, c1_rec.ri_seq_no,
                            c1_rec.peril_cd, c1_rec.ri_cd,
                            NVL (c1_rec.ri_shr_pct, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_prem_amt, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_shr_pct, 0), v_comm_rt,
                            v_comm_amt, v_prem_vat, v_comm_vat,
                            ROUND (c1_rec.ri_prem_amt * (v_tax_rate / 100), 2)
                           );                                            --Lem
            ELSE
               INSERT INTO giri_wfrperil
                           (line_cd, frps_yy,
                            frps_seq_no, ri_seq_no,
                            peril_cd, ri_cd,
                            ri_shr_pct,
                            ri_tsi_amt,
                            ri_prem_amt,
                            ann_ri_s_amt,
                            ann_ri_pct, ri_comm_rt,
                            ri_comm_amt, ri_prem_vat, ri_comm_vat, prem_tax
                           )
                    VALUES (c1_rec.line_cd, c1_rec.frps_yy,
                            c1_rec.frps_seq_no, c1_rec.ri_seq_no,
                            c1_rec.peril_cd, c1_rec.ri_cd,
                            NVL (c1_rec.ri_shr_pct, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_prem_amt, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_shr_pct, 0), v_comm_rt,
                            v_comm_amt, v_prem_vat, v_comm_vat, 0
                           );
            END IF;                                        --Lem    07/14/2008
         END LOOP;
      ELSE -- DITO 
         FOR c1_rec IN mwfrperil_area
         LOOP
            v_comm_amt := c1_rec.ri_comm_amt;
            v_comm_rt := c1_rec.ri_comm_rt;
            v_comm_vat := c1_rec.ri_comm_vat;

            --BETH 042099 check if there is an existing record in the
            --     final table and get ri_comm_amt and ri_comm_rt from it
           -- v_dist_no:= 738;
           IF v_dist_no IS NOT NULL
           THEN
               FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd
                            FROM giri_distfrps
                           WHERE dist_no = v_dist_no
                             AND dist_seq_no = c1_rec.dist_seq_no
--added by mikel; to get the corresponding frps number when its distribution were grouped into two or more distribution
                        )
               LOOP
                  FOR c2 IN (SELECT b.ri_comm_rt, b.ri_comm_amt,
                                    b.ri_comm_vat
                               FROM giri_frps_ri a, giri_frperil b
                              WHERE a.line_cd = b.line_cd
                                AND a.frps_yy = b.frps_yy
                                AND a.frps_seq_no = b.frps_seq_no
                                AND a.ri_cd = b.ri_cd
                                AND a.ri_seq_no = b.ri_seq_no
                                AND b.peril_cd = c1_rec.peril_cd
                                AND a.line_cd = c1.line_cd
                                AND a.frps_yy = c1.frps_yy
                                AND a.frps_seq_no = c1.frps_seq_no
                                AND a.fnl_binder_id = c1_rec.pre_binder_id
                                AND a.ri_cd = c1_rec.ri_cd
                                AND reverse_sw = 'N')
                  LOOP
                     v_comm_amt := c2.ri_comm_amt;
                     v_comm_rt := c2.ri_comm_rt;
                     v_comm_vat := c2.ri_comm_vat;
                     EXIT;
                  END LOOP;

                  EXIT;
               END LOOP;
          END IF;


            --BETH 040699 check if there is an existing record in the
            --     final table and get ri_comm_amt and ri_comm_rt from it
            FOR c2_rec IN (SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat
                             FROM giri_frps_ri a, giri_frperil b
                            WHERE a.line_cd = b.line_cd
                              AND a.frps_yy = b.frps_yy
                              AND a.frps_seq_no = b.frps_seq_no
                              AND a.ri_cd = b.ri_cd
                              AND b.peril_cd = c1_rec.peril_cd
                              AND a.line_cd = c1_rec.line_cd
                              AND a.frps_yy = c1_rec.frps_yy
                              AND a.frps_seq_no = c1_rec.frps_seq_no
                              AND a.fnl_binder_id = c1_rec.pre_binder_id
                              AND a.ri_cd = c1_rec.ri_cd
                              AND reverse_sw = 'N')
            LOOP
               v_comm_amt := c2_rec.ri_comm_amt;
               v_comm_rt := c2_rec.ri_comm_rt;
               v_comm_vat := c2_rec.ri_comm_vat;
               EXIT;
            END LOOP;

            v_prem_vat := NVL (c1_rec.ri_prem_vat, 0);     --A.R.C. 05.09.2007
            giri_wfrps_ri_pkg.adjust_prem_vat (v_prem_vat,
                                               c1_rec.ri_cd,
                                               p_line_cd,
                                               p_iss_cd,
                                               p_par_yy,
                                               p_par_seq_no,
                                               p_subline_cd,
                                               p_issue_yy,
                                               p_pol_seq_no,
                                               p_renew_no
                                              );           --A.R.C. 05.09.2007

            --msg_alert (c1_rec.ri_prem_amt||'-'||V_TAX_RATE,'I',FALSE);
            IF c1_rec.local_foreign_sw != 'L'
            THEN                                        --L.D.G.    07/14/2008
               INSERT INTO giri_wfrperil
                           (line_cd, frps_yy,
                            frps_seq_no, ri_seq_no,
                            peril_cd, ri_cd,
                            ri_shr_pct,
                            ri_tsi_amt,
                            ri_prem_amt,
                            ann_ri_s_amt,
                            ann_ri_pct, ri_comm_rt,
                            ri_comm_amt, ri_prem_vat, ri_comm_vat,
                            prem_tax
                           )
                    VALUES (c1_rec.line_cd, c1_rec.frps_yy,
                            c1_rec.frps_seq_no, c1_rec.ri_seq_no,
                            c1_rec.peril_cd, c1_rec.ri_cd,
                            NVL (c1_rec.ri_shr_pct, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_prem_amt, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_shr_pct, 0), v_comm_rt,
                            v_comm_amt, v_prem_vat, v_comm_vat,
                            ROUND (c1_rec.ri_prem_amt * (v_tax_rate / 100), 2)
                           );                                            --Lem
            ELSE
               INSERT INTO giri_wfrperil
                           (line_cd, frps_yy,
                            frps_seq_no, ri_seq_no,
                            peril_cd, ri_cd,
                            ri_shr_pct,
                            ri_tsi_amt,
                            ri_prem_amt,
                            ann_ri_s_amt,
                            ann_ri_pct, ri_comm_rt,
                            ri_comm_amt, ri_prem_vat, ri_comm_vat, prem_tax
                           )
                    VALUES (c1_rec.line_cd, c1_rec.frps_yy,
                            c1_rec.frps_seq_no, c1_rec.ri_seq_no,
                            c1_rec.peril_cd, c1_rec.ri_cd,
                            NVL (c1_rec.ri_shr_pct, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_prem_amt, 0),
                            NVL (c1_rec.ri_tsi_amt, 0),
                            NVL (c1_rec.ri_shr_pct, 0),v_comm_rt, -- v_comm_rt,
                            v_comm_amt, v_prem_vat, v_comm_vat, 0
                           );                                            --Lem
            END IF;                                     --L.D.G.    07/14/2008
         END LOOP;
      END IF;

      FOR a3 IN sum_spct
      LOOP
         v_spct_total := a3.sum_spct;
      END LOOP;

      FOR a3 IN sum_spct
      LOOP
         v_spct_total := a3.sum_spct;
      END LOOP;

      IF p_tot_fac_spct = v_spct_total
      THEN
         giri_wfrperil_pkg.offset_process (p_dist_no,
                                           p_dist_seq_no,
                                           p_line_cd,
                                           p_frps_yy,
                                           p_frps_seq_no
                                          );
      END IF;
    END;
    
    
     /*
     **  Created by       : Robert John Virrey
     **  Date Created     : 08.12.2011
     **  Reference By     : (GIUTS004- Reverse Binder)
     **  Description      : Copy data from GIRI_FRPERIL to GIRI_WFRPERIL
     **                     for records not tagged for reversal.
     */
    PROCEDURE copy_frperil(
        p_line_cd       IN giri_frperil.line_cd%TYPE,
        p_frps_yy       IN giri_frperil.frps_yy%TYPE,
        p_frps_seq_no   IN giri_frperil.frps_seq_no%TYPE,
        p_ri_cd         IN giri_frperil.ri_cd%TYPE,
        p_ri_seq_no     IN giri_frperil.ri_seq_no%TYPE
    ) 
    IS
      CURSOR frperil IS
        SELECT line_cd, frps_yy, frps_seq_no,
               ri_seq_no, ri_cd, peril_cd,
               ri_shr_pct, ri_tsi_amt, ri_prem_amt,
               ann_ri_s_amt, ann_ri_pct,
               ri_comm_rt, ri_comm_amt,
               --added other columns j.diago 09.17.2014
               ri_prem_vat, ri_comm_vat, 
               prem_tax
          FROM giri_frperil a
         WHERE a.line_cd       = p_line_cd
           AND a.frps_yy       = p_frps_yy
           AND a.frps_seq_no   = p_frps_seq_no
           AND a.ri_cd         = p_ri_cd
           AND a.ri_seq_no     = p_ri_seq_no;
    BEGIN
      FOR c1_rec IN frperil LOOP
        INSERT INTO giri_wfrperil
            (line_cd, frps_yy, frps_seq_no,
               ri_seq_no, ri_cd, peril_cd,
               ri_shr_pct, ri_tsi_amt, ri_prem_amt,
               ann_ri_s_amt, ann_ri_pct,
               ri_comm_rt, ri_comm_amt,
               ri_prem_vat, ri_comm_vat, 
               prem_tax)
          VALUES
            (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,
             c1_rec.ri_seq_no, c1_rec.ri_cd, c1_rec.peril_cd,
             c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_prem_amt,
             c1_rec.ann_ri_s_amt, c1_rec.ann_ri_pct,
             c1_rec.ri_comm_rt, c1_rec.ri_comm_amt,
             c1_rec.ri_prem_vat, c1_rec.ri_comm_vat, 
             c1_rec.prem_tax);
      END LOOP;
    END copy_frperil;
    
    /*
    **  Created by       : Emman 
    **  Date Created     : 08.17.2011 
    **  Reference By     : (GIUTS021 - Redistribution) 
    **  Description      : CREATE_WFRPERIL_R program unit  
    */  
    PROCEDURE CREATE_WFRPERIL_R_GIUTS021 (p_dist_no     GIUW_POL_DIST.dist_no%TYPE,
                                 v_line_cd     IN giri_distfrps.line_cd%TYPE,
                                 v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                 v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE)
    IS
      CURSOR mwfrperil_area IS
        SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
               T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
               T5.ri_shr_pct, (T5.ri_shr_pct/100) * T1.tsi_amt ri_tsi_amt, 
               (T5.ri_shr_pct/100) * T1.prem_amt ri_prem_amt,
               T6.ri_comm_rt, 
               (T6.ri_comm_rt/100) * ((T5.ri_shr_pct/100) * T1.prem_amt) ri_comm_amt
          FROM giuw_perilds T1, 
               giuw_perilds_dtl T2, 
               giis_dist_share T3,
               giri_distfrps T4,
               giri_wfrps_ri T5,
               giis_peril T6
         WHERE T1.line_cd     = T6.line_cd
           AND T1.peril_cd    = T6.peril_cd
           AND T1.dist_no     = T2.dist_no
           AND T1.dist_seq_no = T2.dist_seq_no
           AND T1.line_cd     = T2.line_cd
           AND T1.peril_cd    = T2.peril_cd
           AND T2.line_cd     = T3.line_cd
           AND T2.share_cd    = T3.share_cd
           AND T3.share_type  = '3'
           AND T1.dist_no     = T4.dist_no
           AND T1.dist_seq_no = T4.dist_seq_no
           AND T4.line_cd     = T5.line_cd
           AND T4.frps_yy     = T5.frps_yy
           AND T4.frps_seq_no = T5.frps_seq_no
           AND T4.line_cd     = v_line_cd
           AND T4.frps_yy     = v_frps_yy
           AND T4.frps_seq_no = v_frps_seq_no;
     v_comm_amt           giri_frps_ri.ri_comm_amt%TYPE :=0;
     v_comm_rt            giri_frps_ri.ri_comm_rt%TYPE  :=0;
      CURSOR sum_spct IS
         SELECT SUM(ri_shr_pct) sum_spct
           FROM giri_wfrps_ri
          WHERE line_cd     = v_line_cd
            AND frps_yy     = v_frps_yy
            AND frps_seq_no = v_frps_seq_no;  
      v_spct_total       NUMBER :=0;
      v_dist_no          NUMBER(8);

    BEGIN
      FOR A1 IN(SELECT policy_id
                  FROM giuw_pol_dist 
                 WHERE dist_no = p_dist_no)LOOP 
          FOR A2 IN(SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE policy_id = A1.policy_id
                       AND negate_date = (SELECT MAX(negate_date)
                                            FROM giuw_pol_dist
                                           WHERE policy_id = A1.policy_id
                                             AND negate_date IS NOT NULL)
                                        ORDER BY dist_no desc )LOOP
              v_dist_no := a2.dist_no;
              EXIT;
          END LOOP;
          EXIT;
      END LOOP;
      FOR c1_rec in mwfrperil_area LOOP
            v_comm_amt :=  c1_rec.ri_comm_amt;
            v_comm_rt  :=  c1_rec.ri_comm_rt;
            --BETH 042099 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            IF v_dist_no IS NOT NULL THEN
               FOR C1 IN(SELECT frps_yy, frps_seq_no,line_cd
                            FROM giri_distfrps
                           WHERE dist_no = v_dist_no)LOOP
                   FOR C2 IN(SELECT b.ri_comm_rt, b.ri_comm_amt
                               FROM giri_frps_ri a, giri_frperil b
                              WHERE a.line_cd       = b.line_cd
                                AND a.frps_YY       = b.frps_yy
                                AND a.frps_seq_no   = b.frps_seq_no
                                AND a.ri_cd         = b.ri_cd
                                AND a.ri_seq_no     = b.ri_seq_no
                                AND b.peril_cd      = c1_rec.peril_cd
                                AND a.line_cd       = c1.line_cd
                                AND a.frps_YY       = c1.frps_yy
                         AND a.frps_seq_no   = c1.frps_seq_no
                                AND a.fnl_binder_id = c1_rec.pre_binder_id
                                AND a.ri_cd         = c1_rec.ri_cd
                                AND reverse_sw    = 'N')LOOP
                       v_comm_amt :=  c2.ri_comm_amt;
                       v_comm_rt  :=  c2.ri_comm_rt;
                       EXIT;
                    END LOOP;
                    EXIT;
               END LOOP;          
            END IF;
            FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt
                            FROM giri_frps_ri a, giri_frperil b
                           WHERE a.line_cd       = b.line_cd
                             AND a.frps_YY       = b.frps_yy
                  AND a.frps_seq_no   = b.frps_seq_no
                             AND a.ri_cd         = b.ri_cd
                             AND b.peril_cd      = c1_rec.peril_cd
                             AND a.line_cd       = c1_rec.line_cd
                             AND a.frps_YY       = c1_rec.frps_yy
                  AND a.frps_seq_no   = c1_rec.frps_seq_no
                             AND a.fnl_binder_id = c1_rec.pre_binder_id
                             AND a.ri_cd         = c1_rec.ri_cd
                             AND reverse_sw    = 'N')LOOP
                v_comm_amt :=  c2_rec.ri_comm_amt;
                v_comm_rt  :=  c2_rec.ri_comm_rt;
                EXIT;
            END LOOP;
        INSERT INTO giri_wfrperil
          (line_cd, frps_yy, frps_seq_no,            
           ri_seq_no, peril_cd, ri_cd,                  
           ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
           ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
           ri_comm_amt)
        VALUES
          (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
           c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
           c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_prem_amt,            
           c1_rec.ri_tsi_amt, c1_rec.ri_shr_pct, v_comm_rt,             
           v_comm_amt);
      END LOOP;
    END CREATE_WFRPERIL_R_GIUTS021;
    
    /*
    **  Created by       : Emman 
    **  Date Created     : 08.17.2011 
    **  Reference By     : (GIUTS021 - Redistribution) 
    **  Description      : CREATE_WFRPERIL_R program unit
    **                     populates giri_wfrperil after records are inserted in giri_wfrps_ri
    */ 
    PROCEDURE CREATE_WFRPERIL_M_GIUTS021 (p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                                 p_v_post_flag IN VARCHAR2,
                                 v_line_cd     IN giri_distfrps.line_cd%TYPE,
                                 v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                                 v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE,
                                 p_ratio       IN NUMBER, --added edgar 09/29/2014
                                 p_neg_distno  IN giuw_pol_dist.dist_no%TYPE)--added edgar 10/17/2014
    IS
      CURSOR mwfrperil_area IS
        SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
               T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
               T5.ri_shr_pct, (T5.ri_shr_pct/100) * T1.tsi_amt ri_tsi_amt, 
               /*(T5.ri_shr_pct/100) * T1.prem_amt ri_prem_amt,
               T6.ri_comm_rt, 
              (T6.ri_comm_rt/100) * ((T5.ri_shr_pct/100) * T1.prem_amt) ri_comm_amt*/--commented out replace columns below edgar 09/29/2014
             (NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100)
             * t1.prem_amt ri_prem_amt,
             NVL(t6.ri_comm_rt,0) ri_comm_rt,
               (NVL(t6.ri_comm_rt,0) / 100)
             * ((NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100) * t1.prem_amt)
                                                                 ri_comm_amt,
               ((NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100) * t1.prem_amt
               )
             * (NVL(input_vat_rate,0) / 100) ri_prem_vat,
             (  (NVL(t6.ri_comm_rt,0) / 100)
              * ((NVL (t5.ri_shr_pct2, t5.ri_shr_pct) / 100) * t1.prem_amt)
              * (NVL(input_vat_rate,0) / 100)
             ) ri_comm_vat,
             t7.local_foreign_sw,
             t4.dist_seq_no 
          FROM giuw_perilds T1, 
               giuw_perilds_dtl T2,                 
               giis_dist_share T3,
               giri_wdistfrps T4,
               giri_wfrps_ri T5,
               giis_peril T6
               ,giis_reinsurer t7 --edgar 09/29/2014
         WHERE T1.line_cd     = T6.line_cd
           AND T1.peril_cd    = T6.peril_cd
           AND T1.dist_no     = T2.dist_no
           AND T1.dist_seq_no = T2.dist_seq_no
           AND T1.line_cd     = T2.line_cd
           AND T1.peril_cd    = T2.peril_cd
           AND T2.line_cd     = T3.line_cd
           AND T2.share_cd    = T3.share_cd
           AND T3.share_type  = '3'
           AND t7.ri_cd = t5.ri_cd   --edgar 09/29/2014        
           AND T1.dist_no     = T4.dist_no
           AND T1.dist_seq_no = T4.dist_seq_no
           AND T4.line_cd     = T5.line_cd
           AND T4.frps_yy     = T5.frps_yy
           AND T4.frps_seq_no = T5.frps_seq_no
           AND T4.line_cd     = v_line_cd
           AND T4.frps_yy     = v_frps_yy
           AND T4.frps_seq_no = v_frps_seq_no;
     v_prem               NUMBER :=0;
     v_tsi                NUMBER :=0;
     v_comm_amt           giri_frps_ri.ri_comm_amt%TYPE :=0;
     v_comm_rt            giri_frps_ri.ri_comm_rt%TYPE  :=0;
     /*added fields edgar 09/29/2014*/
     v_prem_vat           NUMBER                               := 0;
     v_prem_tax           giri_wfrperil.prem_tax%TYPE          := 0; 
     v_comm_vat           NUMBER                               := 0;
     v_ri_tsi_amt         giri_wfrperil.ri_tsi_amt%TYPE        := 0;
     v_ri_prem_amt        giri_wfrperil.ri_prem_amt%TYPE       := 0;
     v_ri_prem_vat_rate   giis_reinsurer.input_vat_rate%TYPE;
     v_ri_comm_vat_rate   giis_reinsurer.input_vat_rate%TYPE;
     v_ri_prem_tax_rate   giis_reinsurer.int_tax_rt%TYPE;
     v_tsi_ratio          giri_frps_ri.ri_shr_pct%TYPE;
     v_ri_shr_pct         giri_wfrperil.ri_shr_pct%TYPE;
     v_peril_dist_sw      BOOLEAN;
     v_iss_cd             gipi_parlist.ISS_CD%TYPE;
     CURSOR sum_premtotal IS
         SELECT SUM(t2.dist_prem) sum_prem
          FROM giuw_perilds_dtl T2,                 
               giis_dist_share T3,
               giri_wdistfrps T4,
               giis_peril T6
         WHERE T2.line_cd     = T6.line_cd
           AND T2.peril_cd    = T6.peril_cd
           AND T2.line_cd     = T3.line_cd
           AND T2.share_cd    = T3.share_cd
           AND T3.share_type  = '3'
           AND T2.dist_no     = T4.dist_no
           AND T2.dist_seq_no = T4.dist_seq_no
           AND T4.line_cd     = v_line_cd
           AND T4.frps_yy     = v_frps_yy
           AND T4.frps_seq_no = v_frps_seq_no;

     CURSOR sum_tsitotal IS
         SELECT SUM(t2.dist_tsi) sum_tsi
          FROM giuw_perilds_dtl T2,                 
               giis_dist_share T3,
               giri_wdistfrps T4,
               giis_peril T6
         WHERE T2.line_cd     = T6.line_cd
           AND T2.peril_cd    = T6.peril_cd
           AND T2.line_cd     = T3.line_cd
           AND T2.share_cd    = T3.share_cd
           AND T3.share_type  = '3'
           AND T2.dist_no     = T4.dist_no
           AND T2.dist_seq_no = T4.dist_seq_no
           AND T6.peril_type = 'B'
           AND T4.line_cd     = v_line_cd
           AND T4.frps_yy     = v_frps_yy
           AND T4.frps_seq_no = v_frps_seq_no;

    /*BETH 022499 this cursor is created for policy which are distributed by perils
    **            it uses a formula which is derived through ratio and propotion
    **            to arrived at the correct values of prem_amt and tsi-amt
    */
      CURSOR mwfrperil_area2 IS
        SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
               T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
               T5.ri_shr_pct, (T2.dist_TSI/v_TSI) * T5.ri_tsi_amt ri_tsi_amt, 
               (T2.dist_prem/v_prem) * T5.ri_prem_amt ri_prem_amt,
               NVL(t6.ri_comm_rt,0) ri_comm_rt, --edgar 09/30/2014
               (NVL(t6.ri_comm_rt,0)/100) * ((T2.dist_prem/v_prem) * T5.ri_prem_amt) ri_comm_amt
               /*added columns edgar 09/29/2014*/
               ,((t2.dist_prem / v_prem) * t5.ri_prem_amt * NVL(t7.input_vat_rate,0)
              / 100
             ) ri_prem_vat,
             (  (NVL(t6.ri_comm_rt,0) / 100)
              * ((t2.dist_prem / v_prem) * t5.ri_prem_amt)
              * (NVL(t7.input_vat_rate,0) / 100)
             ) ri_comm_vat,
             t7.local_foreign_sw,
             t1.tsi_amt perilds_tsi, t2.dist_tsi facul_tsi,
             t1.prem_amt perilds_prem, t2.dist_prem facul_prem,
             t4.tot_fac_tsi, t4.tot_fac_prem, t5.ri_tsi_amt frps_ri_tsi,
             t5.ri_prem_amt frps_ri_prem, t2.dist_spct dist_spct,
             NVL (t2.dist_spct1, t2.dist_spct) dist_spct1,
             t5.ri_shr_pct frps_ri_shr_pct, t4.tot_fac_spct, t4.dist_seq_no --edgar 10/17/2014
          FROM giuw_perilds T1, 
               giuw_perilds_dtl T2,                 
               giis_dist_share T3,
               giri_wdistfrps T4,
               giri_wfrps_ri T5,
               giis_peril T6
               ,giis_reinsurer t7 --edgar 09/29/2014               
         WHERE T1.line_cd     = T6.line_cd
           AND T1.peril_cd    = T6.peril_cd
           AND T1.dist_no     = T2.dist_no
           AND T1.dist_seq_no = T2.dist_seq_no
           AND T1.line_cd     = T2.line_cd
           AND T1.peril_cd    = T2.peril_cd
           AND T2.line_cd     = T3.line_cd
           AND T2.share_cd    = T3.share_cd
           AND T3.share_type  = '3'
           AND t5.ri_cd = t7.ri_cd --edgar 09/29/2014      
           AND T1.dist_no     = T4.dist_no
           AND T1.dist_seq_no = T4.dist_seq_no
           AND T4.line_cd     = T5.line_cd
           AND T4.frps_yy     = T5.frps_yy
           AND T4.frps_seq_no = T5.frps_seq_no
           AND T4.line_cd     = v_line_cd
           AND T4.frps_yy     = v_frps_yy
           AND T4.frps_seq_no = v_frps_seq_no;

      CURSOR sum_spct IS
         SELECT SUM(ri_shr_pct) sum_spct
           FROM giri_wfrps_ri
          WHERE line_cd     = v_line_cd
            AND frps_yy     = v_frps_yy
            AND frps_seq_no = v_frps_seq_no;  

      v_pol_flag         VARCHAR2(1);    
      v_spct_total       NUMBER :=0;
     
      v_cnt2             NUMBER :=0;
      v_dist_no          NUMBER(8);

     BEGIN
      FOR A1 IN(SELECT policy_id
                  FROM giuw_pol_dist 
                 WHERE dist_no = p_dist_no)LOOP 
          FOR A2 IN(SELECT dist_no
                      FROM giuw_pol_dist
                     WHERE policy_id = A1.policy_id
                       AND negate_date = (SELECT MAX(negate_date)
                                            FROM giuw_pol_dist
                                           WHERE policy_id = A1.policy_id
                                             AND negate_date IS NOT NULL)
                                        ORDER BY dist_no desc )LOOP
              v_dist_no := a2.dist_no;
              EXIT;
          END LOOP;
          EXIT;
      END LOOP;
        v_peril_dist_sw := adjust_binder_pkg.check_if_peril_dist (p_dist_no);   --edgar 09/29/2014
      IF p_v_post_flag = 'P' OR v_peril_dist_sw = TRUE THEN                     --added condition v_peril_dist_sw edgar 09/29/2014
         FOR A1 IN sum_premtotal LOOP
             v_prem  := A1.sum_prem;
             /*added edgar 09/29/2014 to handle divide by zero*/
             IF a1.sum_prem = 0
             THEN
                v_prem := 1;
             ELSE  
                v_prem := a1.sum_prem;
             END IF;     
             /*ended edgar 09/29/2014*/    
             EXIT;
         END LOOP;
         FOR A2 IN sum_tsitotal LOOP
             v_tsi  := A2.sum_tsi;
            /*added edgar 09/29/2014 to handle divide by zero*/
             IF a2.sum_tsi = 0
             THEN        
                v_tsi := 1;   
             ELSE               
                v_tsi := a2.sum_tsi;
             END IF;  
             /*ended edgar 09/29/2014*/             
             EXIT;
         END LOOP;

        FOR c1_rec in mwfrperil_area2 LOOP
            /*added NVL in comm_amt adn comm_rt edgar 09/29/2014*/
            v_comm_amt :=  NVL(c1_rec.ri_comm_amt, 0);
            v_comm_rt  :=  NVL(c1_rec.ri_comm_rt, 0);
            /*added edgar 09/29/2014*/
             FOR i IN (SELECT iss_cd
                         FROM gipi_parlist
                        WHERE par_id = (SELECT par_id 
                                          FROM giuw_pol_dist
                                         WHERE dist_no = p_dist_no))
             LOOP
                v_iss_cd := i.iss_cd;
             END LOOP;
             
             v_comm_vat := NVL (c1_rec.ri_comm_vat, 0);
             v_ri_tsi_amt := NVL (c1_rec.ri_tsi_amt, 0);
             v_ri_prem_amt := NVL (c1_rec.ri_prem_amt, 0);
             v_ri_shr_pct := NVL (c1_rec.ri_shr_pct, 0);
             
             IF c1_rec.tot_fac_spct = 0 THEN
                v_tsi_ratio := 0;
             ELSE
                 v_tsi_ratio :=
                      (c1_rec.frps_ri_shr_pct / c1_rec.tot_fac_spct)
                    * (c1_rec.dist_spct);
             END IF;


             v_ri_tsi_amt := c1_rec.perilds_tsi * (v_tsi_ratio / 100);


             v_ri_shr_pct := v_tsi_ratio;            
            /*ended edgar 09/29/2014*/
            --BETH 042099 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            /*--IF v_dist_no IS NOT NULL THEN
            --   FOR C1 IN(SELECT frps_yy, frps_seq_no,line_cd
            --                FROM giri_distfrps
            --               WHERE dist_no = v_dist_no)LOOP
            --       FOR C2 IN(SELECT b.ri_comm_rt, b.ri_comm_amt
            --                        ,b.ri_comm_vat, b.prem_tax, b.ri_tsi_amt, b.ri_prem_amt, b.ri_prem_vat --added columns edgar 09/29/2014
            --                   FROM giri_frps_ri a, giri_frperil b
            --                  WHERE a.line_cd       = b.line_cd
            --                    AND a.frps_YY       = b.frps_yy
            --                    AND a.frps_seq_no   = b.frps_seq_no
            --                    AND a.ri_cd         = b.ri_cd
            --                    AND a.ri_seq_no     = b.ri_seq_no
            --                    AND b.peril_cd      = c1_rec.peril_cd
            --                    AND a.line_cd       = c1.line_cd
            --                    AND a.frps_YY       = c1.frps_yy
            --             AND a.frps_seq_no   = c1.frps_seq_no
            --                    --AND a.fnl_binder_id = c1_rec.pre_binder_id --commented out edgar 10/17/2014
            --                    AND a.ri_cd         = c1_rec.ri_cd
            --                    AND reverse_sw    = 'N')LOOP
            --           --v_comm_amt :=  c2.ri_comm_amt; --commented out edgar 10/17/2014 recomputed below
            --           v_comm_amt :=  ROUND((c1_rec.ri_prem_amt*(c2.ri_comm_rt/100)),2); --edgar 10/17/2014
            --           v_comm_rt  :=  c2.ri_comm_rt;
            --           EXIT;
            --        END LOOP;
            --        EXIT;
            --   END LOOP;          
            --END IF;*/ --commented out edgar 10/17/2014
            --BETH 040699 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            --added outer loop edgar 10/17/2014 to get original line_cd, frps_yy and frps_seq_no
            FOR A2 IN
               ( SELECT d060.line_cd, d060.frps_yy, d060.frps_seq_no
                   FROM giri_distfrps d060
                  WHERE d060.dist_no = p_neg_distno
                    AND d060.dist_seq_no = c1_rec.dist_seq_no
               ) LOOP
                FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt
                                     , b.ri_comm_vat, b.prem_tax, b.ri_prem_vat, b.ri_tsi_amt, b.ri_prem_amt --added columns edgar 09/29/2014
                                FROM giri_frps_ri a, giri_frperil b
                               WHERE a.line_cd       = b.line_cd
                                 AND a.frps_YY       = b.frps_yy
                      AND a.frps_seq_no   = b.frps_seq_no
                                 AND a.ri_cd         = b.ri_cd
                                 AND b.peril_cd      = c1_rec.peril_cd
                                 AND a.line_cd       = a2.line_cd/*c1_rec.line_cd*/                 --edgar 10/17/2014
                                 AND a.frps_YY       = a2.frps_yy/*c1_rec.frps_yy*/                 --edgar 10/17/2014
                                 AND a.frps_seq_no   = a2.frps_seq_no/*c1_rec.frps_seq_no*/         --edgar 10/17/2014
                                 --AND a.fnl_binder_id = c1_rec.pre_binder_id                       --commented edgar 10/17/2014
                                 AND a.ri_cd         = c1_rec.ri_cd
                                 AND a.ri_seq_no     = b.ri_seq_no                                  --edgar 10/17/2014
                                 AND a.ri_seq_no     = c1_rec.ri_seq_no                             --edgar 10/17/2014
                                 AND NVL(reverse_sw,'N')    = 'N')LOOP                              --added NVL edgar 10/17/2014
                    --v_comm_amt :=  c2_rec.ri_comm_amt;                                            --commented out edgar 10/17/2014 recomputed below
                    v_comm_amt :=  ROUND((c1_rec.ri_prem_amt*(NVL(c2_rec.ri_comm_rt,0)/100)),2);    --edgar 10/17/2014
                    v_comm_rt  :=  NVL(c2_rec.ri_comm_rt,0);                                        --edgar 10/17/2014
                    EXIT;
                END LOOP;
             END LOOP;
            /*added edgar 10/17/2014 to recompute ri_comm_vat, ri_prem_vat and prem_tax*/
             binder_adjust_web_pkg.GET_RI_TAXES_MULTIPLIER ( c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no ,   v_iss_cd 
									     , c1_rec.ri_cd ,  v_ri_comm_vat_rate  ,  v_ri_prem_vat_rate  ,  v_ri_prem_tax_rate,  p_dist_no  );
             v_comm_vat :=
                ROUND (  NVL (v_comm_amt, 0)
                       * nvl(v_ri_comm_vat_rate,0)/100 ,2 
                      );
             v_prem_vat :=
                ROUND (  NVL (v_ri_prem_amt, 0)
                       * nvl(v_ri_prem_vat_rate,0) /100 ,2
                      );
             v_prem_tax :=
                ROUND (  NVL (v_ri_prem_amt, 0)
                       * nvl(v_ri_prem_tax_rate,0) /100 ,2
                      );            
            /*ended edgar 10/17/2014*/
          IF c1_rec.local_foreign_sw != 'L' then
              INSERT INTO giri_wfrperil
                (line_cd, frps_yy, frps_seq_no,            
                 ri_seq_no, peril_cd, ri_cd,                  
                 ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                 ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                 ri_comm_amt, ri_prem_vat, ri_comm_vat, prem_tax) --added fields to insert edgar 09/29/2014
              VALUES
                (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                 c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                 /*c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_prem_amt,            
                 c1_rec.ri_tsi_amt, c1_rec.ri_shr_pct, commented out edgar 09/29/2014*/
                  v_ri_shr_pct ,v_ri_tsi_amt ,v_ri_prem_amt ,v_ri_tsi_amt, v_ri_shr_pct , v_comm_rt, --added fields to insert edgar 09/29/2014            
                 v_comm_amt, v_prem_vat, v_comm_vat, v_prem_tax);--added fields to insert edgar 09/29/2014 
          ELSE/*added edgar 09/29/2014*/
                INSERT INTO giri_wfrperil
                    (line_cd, frps_yy, frps_seq_no,            
                     ri_seq_no, peril_cd, ri_cd,                  
                     ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                     ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                     ri_comm_amt, ri_prem_vat, ri_comm_vat
                     ,prem_tax)
                  VALUES
                    (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                     c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                     v_ri_shr_pct , v_ri_tsi_amt , v_ri_prem_amt ,            
                     v_ri_tsi_amt, v_ri_shr_pct , v_comm_rt,             
                     v_comm_amt, v_prem_vat, v_comm_vat, v_prem_tax );     /*ended edgar 09/29/2014*/       
          END IF;
        END LOOP;
      ELSE
        FOR c1_rec in mwfrperil_area LOOP
             /*added NVL in comm_amt adn comm_rt edgar 09/29/2014*/
             v_comm_amt := NVL(c1_rec.ri_comm_amt,0);
             v_comm_rt := NVL(c1_rec.ri_comm_rt,0);
             v_comm_vat := c1_rec.ri_comm_vat; --edgar 09/29/2014
            --BETH 042099 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it    
         /*added edgar 09/29/2014*/
             FOR i IN (SELECT iss_cd
                         FROM gipi_parlist
                        WHERE par_id = (SELECT par_id
                                          FROM giuw_pol_dist
                                         WHERE dist_no = p_dist_no))
             LOOP
                v_iss_cd := i.iss_cd;
             END LOOP;
             v_prem_tax := 0;
             v_ri_tsi_amt := c1_rec.ri_tsi_amt;
             v_ri_prem_amt := c1_rec.ri_prem_amt;
             v_ri_shr_pct := NVL (c1_rec.ri_shr_pct, 0);
             /*ended edgar 09/29/2014*/               
            /*--IF v_dist_no IS NOT NULL THEN
            --   FOR C1 IN(SELECT frps_yy, frps_seq_no,line_cd
            --                FROM giri_distfrps
            --               WHERE dist_no = v_dist_no
            --                 AND dist_seq_no = c1_rec.dist_seq_no--edgar 09/29/2014
            --               )LOOP
            --       FOR C2 IN(SELECT b.ri_comm_rt, b.ri_comm_amt
            --                        , b.ri_comm_vat, b.prem_tax, b.ri_prem_vat, b.ri_tsi_amt, b.ri_prem_amt --added columns edgar 09/29/2014
            --                   FROM giri_frps_ri a, giri_frperil b
            --                  WHERE a.line_cd       = b.line_cd
            --                    AND a.frps_YY       = b.frps_yy
            --                    AND a.frps_seq_no   = b.frps_seq_no
            --                    AND a.ri_cd         = b.ri_cd
            --                    AND a.ri_seq_no     = b.ri_seq_no
            --                    AND b.peril_cd      = c1_rec.peril_cd
            --                    AND a.line_cd       = c1.line_cd
            --                    AND a.frps_YY       = c1.frps_yy
            --             AND a.frps_seq_no   = c1.frps_seq_no
            --                    --AND a.fnl_binder_id = c1_rec.pre_binder_id --commented out edgar 10/17/2014
            --                    AND a.ri_cd         = c1_rec.ri_cd
            --                    AND reverse_sw    = 'N')LOOP
            --           --v_comm_amt :=  c2.ri_comm_amt; --commented out edgar 10/17/2014 replaced with codes below
            --           v_comm_amt :=  ROUND((c1_rec.ri_prem_amt*(c2.ri_comm_rt/100)),2);--edgar 10/17/2014
            --           v_comm_rt  :=  c2.ri_comm_rt;                        
            --           EXIT;
            --        END LOOP;
            --        EXIT;
            --   END LOOP;          
            --END IF;*/--commented out edgar 10/17/2014
            --BETH 040699 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            --added outer loop edgar 10/17/2014 to get original line_cd, frps_yy and frps_seq_no
            FOR A2 IN
               ( SELECT d060.line_cd, d060.frps_yy, d060.frps_seq_no
                   FROM giri_distfrps d060
                  WHERE d060.dist_no = p_neg_distno
                    AND d060.dist_seq_no = c1_rec.dist_seq_no
               ) LOOP            
                FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt
                                     , b.ri_comm_vat, b.prem_tax, b.ri_prem_vat , b.ri_tsi_amt, b.ri_prem_amt --added columns edgar 09/29/2014
                                FROM giri_frps_ri a, giri_frperil b
                               WHERE a.line_cd       = b.line_cd
                                 AND a.frps_YY       = b.frps_yy
                      AND a.frps_seq_no   = b.frps_seq_no
                                 AND a.ri_cd         = b.ri_cd
                                 AND b.peril_cd      = c1_rec.peril_cd
                                 AND a.line_cd       = a2.line_cd/*c1_rec.line_cd*/             --edgar 10/17/2014
                                 AND a.frps_YY       = a2.frps_yy/*c1_rec.frps_yy*/             --edgar 10/17/2014
                                 AND a.frps_seq_no   = a2.frps_seq_no/*c1_rec.frps_seq_no*/     --edgar 10/17/2014
                                 --AND a.fnl_binder_id = c1_rec.pre_binder_id                   --commented out edgar 10/17/2014
                                 AND a.ri_cd         = c1_rec.ri_cd
                                 AND a.ri_seq_no     = b.ri_seq_no                              --edgar 10/17/2014
                                 AND a.ri_seq_no     = c1_rec.ri_seq_no                         --edgar 10/17/2014
                                 AND NVL(reverse_sw,'N')    = 'N')LOOP                          --added NVL edgar 10/17/2014
                    --v_comm_amt :=  c2_rec.ri_comm_amt;                                        --commented out edgar 10/17/2014 replaced with codes below
                    v_comm_amt :=  ROUND((c1_rec.ri_prem_amt*(NVL(c2_rec.ri_comm_rt,0)/100)),2);--edgar 10/17/2014
                    v_comm_rt  :=  NVL(c2_rec.ri_comm_rt,0);                                    --edgar 10/17/2014                   
                    EXIT;
                END LOOP;
            END LOOP;
            /*added edgar 10/17/2014 to recompute ri_comm_vat, ri_prem_vat and prem_tax*/
             binder_adjust_web_pkg.GET_RI_TAXES_MULTIPLIER ( c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no ,   v_iss_cd 
									     , c1_rec.ri_cd ,  v_ri_comm_vat_rate  ,  v_ri_prem_vat_rate  ,  v_ri_prem_tax_rate,  p_dist_no  );
             v_comm_vat :=
                ROUND (  NVL (v_comm_amt, 0)
                       * nvl(v_ri_comm_vat_rate,0)/100 ,2 
                      );
             v_prem_vat :=
                ROUND (  NVL (v_ri_prem_amt, 0)
                       * nvl(v_ri_prem_vat_rate,0) /100 ,2
                      );
             v_prem_tax :=
                ROUND (  NVL (v_ri_prem_amt, 0)
                       * nvl(v_ri_prem_tax_rate,0) /100 ,2
                      );            
            /*ended edgar 10/17/2014*/
         IF c1_rec.local_foreign_sw != 'L' then	
          INSERT INTO giri_wfrperil
            (line_cd, frps_yy, frps_seq_no,            
             ri_seq_no, peril_cd, ri_cd,                  
             ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
             ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
             ri_comm_amt, ri_prem_vat, ri_comm_vat, prem_tax) --added fields to insert edgar 09/29/2014
          VALUES
            (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
             c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
             /*c1_rec.ri_shr_pct, c1_rec.ri_tsi_amt, c1_rec.ri_prem_amt,            
             c1_rec.ri_tsi_amt, c1_rec.ri_shr_pct, commente out edgar 09/29/2014*/
             v_ri_shr_pct ,v_ri_tsi_amt ,v_ri_prem_amt ,v_ri_tsi_amt, v_ri_shr_pct , v_comm_rt,  --added fields to insert edgar 09/29/2014            
             v_comm_amt,  v_prem_vat, v_comm_vat, v_prem_tax);--added fields to insert edgar 09/29/2014 
         ELSE/*added edgar 09/29/2014*/
                INSERT INTO giri_wfrperil
                    (line_cd, frps_yy, frps_seq_no,            
                     ri_seq_no, peril_cd, ri_cd,                  
                     ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                     ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                     ri_comm_amt, ri_prem_vat, ri_comm_vat
                     ,prem_tax)
                  VALUES
                    (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                     c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                     v_ri_shr_pct , v_ri_tsi_amt , v_ri_prem_amt ,            
                     v_ri_tsi_amt, v_ri_shr_pct , v_comm_rt,             
                     v_comm_amt, v_prem_vat, v_comm_vat, v_prem_tax );     /*ended edgar 09/29/2014*/  
         END IF;
        END LOOP;
      END IF;
    END;
    
    /*
    **  Created by      : Emman
    **  Date Created    : 08.17.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : process final offsetting of prem _amt and tsi
    **                      to make sure that this values tallies between tables 
    **                      giri_wfrperil and giri_wfrps_ri
    */
    PROCEDURE FINAL_OFFSET_GIUTS021 (p_dist_no     IN  GIUW_POL_DIST.dist_no%TYPE,
                                     v_dist_seq_no IN  giuw_policyds.dist_seq_no%TYPE,
                                     v_line_cd     IN  giri_distfrps.line_cd%TYPE,
                                     v_frps_yy     IN  giri_distfrps.frps_yy%TYPE,
                                     v_frps_seq_no IN  giri_distfrps.frps_seq_no%TYPE)
    IS
      v_add_tsi         NUMBER := 0;
      v_add_tsi2       NUMBER := 0;
      v_add_prem       NUMBER := 0;
      v_add_prem2       NUMBER := 0;
      v_add2_prem       NUMBER := 0;
      v_add2_prem2       NUMBER := 0;
    BEGIN
      FOR A1 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                   FROM giri_wfrps_ri
                  WHERE line_cd     = v_line_cd
                    AND frps_yy     = v_frps_yy
                AND frps_seq_no = v_frps_seq_no) LOOP
          v_add_tsi :=  0;
          v_add_prem := 0;
          FOR A2 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                       FROM giri_wfrperil
                      WHERE line_cd     = v_line_cd
                     AND frps_yy     = v_frps_yy
                    AND frps_seq_no = v_frps_seq_no
                        AND ri_cd = A1.ri_cd) LOOP
              IF A1.ri_tsi_amt != A2.sum_tsi THEN
                 v_add_tsi := nvl(A1.ri_tsi_amt,0) - NVl(A2.sum_tsi,0); 
              END IF;
              IF A1.ri_prem_amt != A2.sum_prem THEN
                 v_add_prem := nvl(A1.Ri_prem_amt,0) - NVl(A2.sum_prem,0); 
              END IF;
          END LOOP;
          IF (v_add_tsi != 0) OR (v_add_prem != 0) THEN
               FOR A3 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                            FROM giri_wfrps_ri
                           WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                         AND frps_seq_no = v_frps_seq_no
                             AND ri_cd      !=  A1.RI_CD) LOOP
               FOR A4 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem, MAX(PERIL_CD) peril_cd
                            FROM giri_wfrperil
                           WHERE line_cd     = v_line_cd
                      AND frps_yy     = v_frps_yy
                     AND frps_seq_no = v_frps_seq_no
                             AND ri_cd = A3.ri_cd) LOOP
                   IF A3.RI_TSI_AMT > A4.sum_tsi AND nvl(v_add_tsi,0) < 0 THEN
                      v_add_tsi2 := 0;
                      v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                      IF v_add_tsi2 > v_add_tsi THEN
                      v_add_tsi2 := v_add_tsi;
                      END IF;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                       WHERE line_cd     = v_line_cd
                  AND frps_yy     = v_frps_yy
                 AND frps_seq_no = v_frps_seq_no  
                         AND ri_cd       = A1.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt - v_add_tsi2
                       WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                 AND frps_seq_no = v_frps_seq_no  
                         AND ri_cd       = A3.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                   ELSIF A3.RI_TSI_AMT < A4.sum_tsi AND nvl(v_add_tsi,0) > 0 THEN
                         v_add_tsi2 := 0;
                      v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                      IF v_add_tsi2 < v_add_tsi THEN
                         v_add_tsi2 := v_add_tsi;
                      END IF;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                       WHERE line_cd     = v_line_cd
                  AND frps_yy     = v_frps_yy
                 AND frps_seq_no = v_frps_seq_no  
                         AND ri_cd       = A1.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      UPDATE giri_wfrperil
                         SET ri_tsi_amt = ri_tsi_amt - v_add_tsi2
                       WHERE line_cd     = v_line_cd
                  AND frps_yy     = v_frps_yy
                 AND frps_seq_no = v_frps_seq_no  
                         AND ri_cd       = A3.ri_cd
                         AND peril_cd    = A4.peril_cd;
                      v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);   
                  END IF;

                  IF A3.RI_prem_AMT > A4.sum_prem AND nvl(v_add_prem,0) < 0 THEN
                     v_add_prem2 := 0;
                     v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                     IF v_add_prem2 > v_add_prem THEN
                        v_add_prem2 := v_add_prem;
                     END IF;
                     UPDATE giri_wfrperil
                        SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                            ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                      WHERE line_cd     = v_line_cd
                     AND frps_yy     = v_frps_yy
                AND frps_seq_no = v_frps_seq_no  
                        AND ri_cd       = A1.ri_cd
                        AND peril_cd    = A4.peril_cd;
                     UPDATE giri_wfrperil
                        SET ri_prem_amt = ri_prem_amt - v_add_prem2,
                            ri_comm_amt = (ri_prem_amt - v_add_prem2)*(ri_comm_rt/100)
                      WHERE line_cd     = v_line_cd
                     AND frps_yy     = v_frps_yy
                AND frps_seq_no = v_frps_seq_no  
                        AND ri_cd       = A3.ri_cd
                        AND peril_cd    = A4.peril_cd;
                     v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                     ELSIF A3.RI_prem_AMT < A4.sum_prem AND nvl(v_add_prem,0) > 0 THEN
                           v_add_prem2 := 0;
                           v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                           IF v_add_prem2 < v_add_prem THEN
                              v_add_prem2 := v_add_prem;
                           END IF;
                           UPDATE giri_wfrperil
                              SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                  ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                            WHERE line_cd     = v_line_cd
                       AND frps_yy     = v_frps_yy
                      AND frps_seq_no = v_frps_seq_no  
                              AND ri_cd       = A1.ri_cd
                              AND peril_cd    = A4.peril_cd;
                           UPDATE giri_wfrperil
                              SET ri_prem_amt = ri_prem_amt - v_add_prem2,
                                  ri_comm_amt = (ri_prem_amt - v_add_prem2)*(ri_comm_rt/100)
                            WHERE line_cd     = v_line_cd
                       AND frps_yy     = v_frps_yy
                      AND frps_seq_no = v_frps_seq_no  
                              AND ri_cd       = A3.ri_cd
                              AND peril_cd    = A4.peril_cd;
                           v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                     END IF;

                        end loop;
    END LOOP;
    END IF;
    END LOOP;

      FOR A1 IN
          ( SELECT peril_cd, dist_prem prem
              FROM giuw_perilds_dtl T1, giis_dist_share T2
             WHERE T1.line_cd    = T2.line_cd
               AND T1.share_cd   = T2.share_cd
               AND T2.share_type = '3'
               AND dist_no       = p_dist_no
               AND dist_seq_no   = v_dist_seq_no
               AND T1.line_cd    = v_line_cd
          ) LOOP
          v_add2_prem := 0;
          FOR A2 IN
              ( SELECT SUM(ri_prem_amt) prem
                  FROM giri_wfrperil
                 WHERE line_cd     = v_line_cd
                AND frps_yy     = v_frps_yy
               AND frps_seq_no = v_frps_seq_no
                   AND peril_cd = A1.peril_cd
                GROUP BY peril_cd
              ) LOOP
              IF A1.prem <> A2.prem THEN
                 v_add2_prem := A1.prem - A2.prem;
                 FOR A3 IN        
                     ( SELECT peril_cd, dist_prem prem
                         FROM giuw_perilds_dtl T1, giis_dist_share T2
                        WHERE T1.line_cd    = T2.line_cd
                          AND T1.share_cd   = T2.share_cd
                          AND T2.share_type = '3'
                          AND dist_no       = p_dist_no
                          AND dist_seq_no   = v_dist_seq_no
                          AND T1.line_cd    = v_line_cd
                          AND T1.peril_cd <> A1.peril_cd
                     ) LOOP
                     FOR A4 IN
                         ( SELECT SUM(ri_prem_amt) prem
                             FROM giri_wfrperil
                            WHERE line_cd     = v_line_cd
                           AND frps_yy     = v_frps_yy
                          AND frps_seq_no = v_frps_seq_no
                              AND peril_cd = A3.peril_cd
                           GROUP BY peril_cd
                         ) LOOP
                     IF (v_add2_prem > 0 AND (A3.prem < A4.prem)) THEN
                         v_add2_prem2 := A4.prem - A3.prem;
                         IF v_add2_prem <= v_add2_prem2 THEN
                            v_add2_prem2 := v_add2_prem;
                            v_add2_prem := 0;
                         ELSE
                            v_add2_prem := v_add2_prem - v_add2_prem2;
                         END IF;
                         FOR A5 IN
                             (SELECT MIN(ri_cd) ri_cd
                                FROM giri_wfrperil
                               WHERE line_cd     = v_line_cd
                              AND frps_yy     = v_frps_yy
                             AND frps_seq_no = v_frps_seq_no
                             )LOOP
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add2_prem2                    
                              WHERE line_cd     = v_line_cd
                                AND frps_yy     = v_frps_yy
                            AND frps_seq_no = v_frps_seq_no
                                AND peril_cd = A1.peril_cd
                                AND ri_cd = A5.ri_cd;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt - v_add2_prem2                    
                              WHERE line_cd     = v_line_cd
                                AND frps_yy     = v_frps_yy
                            AND frps_seq_no = v_frps_seq_no
                                AND peril_cd = A3.peril_cd
                                AND ri_cd = A5.ri_cd;
                            EXIT;
                         END LOOP;
                     ELSIF v_add2_prem < 0 AND (A4.prem < A3.prem) THEN
                         v_add2_prem2 := A4.prem - A3.prem;
                         IF v_add2_prem  >= v_add2_prem2 THEN
                            v_add2_prem2 := v_add2_prem;
                            v_add2_prem := 0;
                         ELSE
                            v_add2_prem := v_add2_prem - v_add2_prem2;
                         END IF;
                         FOR A5 IN
                             (SELECT MIN(ri_cd) ri_cd
                                FROM giri_wfrperil
                               WHERE line_cd     = v_line_cd
                              AND frps_yy     = v_frps_yy
                             AND frps_seq_no = v_frps_seq_no
                             )LOOP
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add2_prem2                    
                              WHERE line_cd     = v_line_cd
                                AND frps_yy     = v_frps_yy
                            AND frps_seq_no = v_frps_seq_no
                                AND peril_cd = A1.peril_cd
                                AND ri_cd = A5.ri_cd;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt - v_add2_prem2                    
                              WHERE line_cd     = v_line_cd
                                AND frps_yy     = v_frps_yy
                            AND frps_seq_no = v_frps_seq_no
                                AND peril_cd = A3.peril_cd
                                AND ri_cd = A5.ri_cd;
                             EXIT;
                         END LOOP;
                      END IF;
                     END LOOP;
                     IF v_add2_prem = 0 THEN
                        exit;
                      END IF;
                END LOOP;
             END IF;
       END LOOP;
      END LOOP;  
    END FINAL_OFFSET_GIUTS021;
    
    /*
    **  Created by      : Emman
    **  Date Created    : 08.17.2011
    **  Reference By    : (GIUTS021 - Redistribution)
    **  Description     : this procedure is called after creation of records
    **                      in giri_wfrperil , to make sure that values of prem_amt
    **                      and tsi_amt in giri_wfrperil will tally with those
    **                      in distribution tables
    */
    PROCEDURE OFFSET_RI(p_dist_no     IN giuw_pol_dist.dist_no%TYPE,
                        v_dist_seq_no IN giuw_policyds.dist_seq_no%TYPE,
                        v_line_cd     IN giri_distfrps.line_cd%TYPE,
                        v_frps_yy     IN giri_distfrps.frps_yy%TYPE,
                        v_frps_seq_no IN giri_distfrps.frps_seq_no%TYPE)
    IS
      v_add_tsi         NUMBER := 0;
      v_add_tsi2       NUMBER := 0;
      v_add_prem       NUMBER := 0;
      v_add_prem2       NUMBER := 0;
    BEGIN
      FOR DIST_FRPS IN(SELECT '1'
                         FROM giri_wdistfrps 
                        WHERE line_cd     = v_line_cd
                      AND frps_yy     = v_frps_yy
                  AND frps_seq_no = v_frps_seq_no) LOOP
             FOR A1 IN( SELECT t6.peril_cd,  t2.dist_tsi, t2.dist_prem
                       FROM giuw_perilds_dtl T2,                 
                   giis_dist_share T3,
                       giri_wdistfrps T4,
                       giis_peril T6
                 WHERE T2.line_cd     = T6.line_cd
                   AND T2.peril_cd    = T6.peril_cd
                   AND T2.line_cd     = T3.line_cd
                       AND T2.share_cd    = T3.share_cd
                   AND T3.share_type  = '3'
                   AND T2.dist_no     = T4.dist_no
                   AND T2.dist_seq_no = T4.dist_seq_no
                   AND T4.line_cd     = v_line_cd
                   AND T4.frps_yy     = v_frps_yy
                   AND T4.frps_seq_no = v_frps_seq_no) LOOP
             v_add_tsi := 0;
             v_add_prem := 0;
             FOR A2 IN(SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                                 FROM giri_wfrperil
                             WHERE line_cd     = v_line_cd
                          AND frps_yy     = v_frps_yy
                          AND frps_seq_no = v_frps_seq_no
                                  AND peril_cd    = A1.peril_cd) LOOP
                 IF A1.dist_tsi != A2.sum_tsi THEN
                    v_add_tsi := nvl(A1.dist_tsi,0) - NVl(A2.sum_tsi,0); 
                 END IF;
                 IF A1.dist_prem != A2.sum_prem THEN
                    v_add_prem := nvl(A1.dist_prem,0) - NVl(A2.sum_prem,0); 
                 END IF;
             END LOOP;
             IF (v_add_tsi != 0) OR (v_add_prem != 0) THEN
                 FOR A3 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                              FROM giri_wfrps_ri
                             WHERE line_cd     = v_line_cd
                       AND frps_yy     = v_frps_yy
                       AND frps_seq_no = v_frps_seq_no) LOOP
                      FOR A4 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                                   FROM giri_wfrperil
                                  WHERE line_cd     = v_line_cd
                             AND frps_yy     = v_frps_yy
                            AND frps_seq_no = v_frps_seq_no
                                    AND ri_cd = A3.ri_cd) LOOP
                          IF A3.RI_TSI_AMT > A4.sum_tsi AND nvl(v_add_tsi,0) > 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 > v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                          ELSIF A3.RI_TSI_AMT < A4.sum_tsi AND nvl(v_add_tsi,0) < 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 < v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                           END IF;
                          IF A3.RI_prem_AMT > A4.sum_prem AND nvl(v_add_prem,0) > 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 > v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                          ELSIF A3.RI_prem_AMT < A4.sum_prem AND nvl(v_add_prem,0) < 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 < v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                           END IF;
                        end loop;

      end loop; 
      end if;
      end loop;
      exit; 
      end loop;
      FOR DIST_FRPS1 IN(SELECT '1'
                         FROM giri_distfrps 
                        WHERE line_cd     = v_line_cd
                      AND frps_yy     = v_frps_yy
                  AND frps_seq_no = v_frps_seq_no) LOOP
             FOR A1 IN( SELECT t6.peril_cd,  t2.dist_tsi, t2.dist_prem
                       FROM giuw_perilds_dtl T2,                 
                   giis_dist_share T3,
                       giri_distfrps T4,
                       giis_peril T6
                 WHERE T2.line_cd     = T6.line_cd
                   AND T2.peril_cd    = T6.peril_cd
                   AND T2.line_cd     = T3.line_cd
                       AND T2.share_cd    = T3.share_cd
                   AND T3.share_type  = '3'
                   AND T2.dist_no     = T4.dist_no
                   AND T2.dist_seq_no = T4.dist_seq_no
                   AND T4.line_cd     = v_line_cd
                   AND T4.frps_yy     = v_frps_yy
                   AND T4.frps_seq_no = v_frps_seq_no) LOOP
             v_add_tsi := 0;
             v_add_prem := 0;
             FOR A2 IN(SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                                 FROM giri_wfrperil
                             WHERE line_cd     = v_line_cd
                          AND frps_yy     = v_frps_yy
                          AND frps_seq_no = v_frps_seq_no
                                  AND peril_cd    = A1.peril_cd) LOOP
                 IF A1.dist_tsi != A2.sum_tsi THEN
                    v_add_tsi := nvl(A1.dist_tsi,0) - NVl(A2.sum_tsi,0); 
                 END IF;
                 IF A1.dist_prem != A2.sum_prem THEN
                    v_add_prem := nvl(A1.dist_prem,0) - NVl(A2.sum_prem,0); 
                 END IF;
             END LOOP;
             IF (v_add_tsi != 0) OR (v_add_prem != 0) THEN
                 FOR A3 IN (SELECT ri_tsi_amt, ri_prem_amt, ri_cd
                              FROM giri_wfrps_ri
                             WHERE line_cd     = v_line_cd
                       AND frps_yy     = v_frps_yy
                       AND frps_seq_no = v_frps_seq_no) LOOP
                      FOR A4 IN (SELECT SUM(ri_tsi_amt) sum_tsi, SUM(ri_prem_amt) sum_prem
                                   FROM giri_wfrperil
                                  WHERE line_cd     = v_line_cd
                             AND frps_yy     = v_frps_yy
                            AND frps_seq_no = v_frps_seq_no
                                    AND ri_cd = A3.ri_cd) LOOP
                          IF A3.RI_TSI_AMT > A4.sum_tsi AND nvl(v_add_tsi,0) > 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 > v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                          ELSIF A3.RI_TSI_AMT < A4.sum_tsi AND nvl(v_add_tsi,0) < 0 THEN
                             v_add_tsi2 := 0;
                             v_add_tsi2 := A3.ri_tsi_amt - A4.sum_tsi;
                             IF v_add_tsi2 < v_add_tsi THEN
                                v_add_tsi2 := v_add_tsi;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_tsi_amt = ri_tsi_amt + v_add_tsi2
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_tsi := NVL(v_add_tsi,0) - NVL(v_add_tsi2,0);
                           END IF;
                          IF A3.RI_prem_AMT > A4.sum_prem AND nvl(v_add_prem,0) > 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 > v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                          ELSIF A3.RI_prem_AMT < A4.sum_prem AND nvl(v_add_prem,0) < 0 THEN
                             v_add_prem2 := 0;
                             v_add_prem2 := A3.ri_prem_amt - A4.sum_prem;
                             IF v_add_prem2 < v_add_prem THEN
                                v_add_prem2 := v_add_prem;
                             END IF;
                             UPDATE giri_wfrperil
                                SET ri_prem_amt = ri_prem_amt + v_add_prem2,
                                    ri_comm_amt = (ri_prem_amt + v_add_prem2)*(ri_comm_rt/100)
                              WHERE line_cd     = v_line_cd
                         AND frps_yy     = v_frps_yy
                        AND frps_seq_no = v_frps_seq_no  
                                AND ri_cd       = A3.ri_cd
                                AND peril_cd    = A1.peril_cd;
                             v_add_prem := NVL(v_add_prem,0) - NVL(v_add_prem2,0);
                           END IF;
                        end loop;

      end loop; 
      end if;
      end loop;
      exit; 
      end loop;
      Giri_Wfrperil_Pkg.FINAL_OFFSET_GIUTS021(p_dist_no, v_dist_seq_no, v_line_cd, v_frps_yy, v_frps_seq_no);
    END OFFSET_RI;
    
    /*
    **  Created by        : D.Alcantara
    **  Date Created     : 05.28.2012
    **  Reference By     : (GIRIS002 - Enter RI Acceptance)
    **                      BUT_PRINT_BINDER, when_button_pressed
    */
    FUNCTION validate_binder_giris002 (
        p_line_cd           GIRI_DISTFRPS_WDISTFRPS_V.line_cd%TYPE,
        p_frps_yy           GIRI_DISTFRPS_WDISTFRPS_V.frps_yy%TYPE,
        p_frps_seq_no       GIRI_DISTFRPS_WDISTFRPS_V.frps_seq_no%TYPE,
        p_dist_no           GIRI_DISTFRPS_WDISTFRPS_V.dist_no%TYPE,
        p_dist_seq_no       GIRI_DISTFRPS_WDISTFRPS_V.dist_seq_no%TYPE
    ) RETURN VARCHAR2 IS
        v_mesg              VARCHAR2(100);
        v_ctr				NUMBER :=0;
        v_count			    NUMBER;
        v_dist_spct			giuw_perilds_dtl.dist_tsi%type;
        
        CURSOR tmp_area IS
            SELECT peril_cd, SUM(ri_tsi_amt) sum_ri_shr_pct
              FROM giri_wfrperil
             WHERE line_cd     = p_line_cd
               AND frps_yy     = p_frps_yy
               AND frps_seq_no = p_frps_seq_no
             GROUP BY peril_cd;
    BEGIN
        BEGIN
            SELECT COUNT(peril_cd)
              INTO v_count
              FROM giri_wfrperil
             WHERE line_cd     = p_line_cd
               AND frps_yy     = p_frps_yy
               AND frps_seq_no = p_frps_seq_no; 
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL; 
        END;
        
        IF v_count IS NULL OR v_count = 0 THEN
            v_mesg := 'There are no perils for this FRPS yet. ';
        ELSE    
            FOR c1_rec IN tmp_area LOOP
                BEGIN
                    SELECT dist_tsi
                      INTO v_dist_spct
                      FROM giuw_perilds_dtl T1, giis_dist_share T2
                     WHERE T1.line_cd    = T2.line_cd
                       AND T1.share_cd   = T2.share_cd
                       AND T2.share_type = '3'
                       AND dist_no       = p_dist_no
                       AND dist_seq_no   = p_dist_seq_no
                       AND T1.line_cd    = p_line_cd
                       AND peril_cd      = c1_rec.peril_cd;
                END;
                IF c1_rec.sum_ri_shr_pct != v_dist_spct THEN
                    v_ctr := v_ctr+1;
                ELSE
                    NULL;
                END IF;      
            END LOOP;
            
            IF v_ctr != 0 THEN
                v_mesg := 'The total facultative placement ' ||
                      'is not equal to the distribution.';
            END IF;
        END IF;
        
        RETURN v_mesg;
    END validate_binder_giris002;
    
   /*
   **  Created by       : Bonok
   **  Date Created     : 09.25.2014
   **  Reference By     : (GIRIS001 - Create RI Placement)
   **                      Program Unit - CREATE_WFRPERIL_R
   */
   PROCEDURE create_wfrperil_r_giris001(
      p_dist_no               giuw_perilds_dtl.dist_no%TYPE,
      p_line_cd               giri_wfrps_peril_grp.line_cd%TYPE,
      p_frps_yy               giri_wfrps_peril_grp.frps_yy%TYPE,
      p_frps_seq_no           giri_wfrps_peril_grp.frps_seq_no%TYPE,
      p_iss_cd            IN  gipi_parlist.iss_cd%TYPE,
      p_tot_fac_spct      IN  giri_distfrps.tot_fac_spct%TYPE
   ) IS
      CURSOR param_prem_tax IS
      SELECT param_value_n
        FROM giis_parameters
       WHERE param_name LIKE 'RI PREMIUM TAX';
       
      CURSOR mwfrperil_area IS
      SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
             T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
             T5.ri_shr_pct, (T5.ri_shr_pct/100) * T1.tsi_amt ri_tsi_amt, 
             (NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt ri_prem_amt,
             T6.ri_comm_rt,
             (T6.ri_comm_rt/100) * ((NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt) ri_comm_amt,
             ((NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt) * (T7.input_vat_rate/100) ri_prem_vat,
             ((T6.ri_comm_rt/100) * ((NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt)) * (T7.input_vat_rate/100) ri_comm_vat,
             T7.local_foreign_sw
        FROM giuw_perilds T1, 
             giuw_perilds_dtl T2, 
             giis_dist_share T3,
             giri_distfrps T4,
             giri_wfrps_ri T5,
             giis_peril T6, 
             giis_reinsurer T7
       WHERE T1.line_cd     = T6.line_cd
         AND T1.peril_cd    = T6.peril_cd
         AND T1.dist_no     = T2.dist_no
         AND T1.dist_seq_no = T2.dist_seq_no
         AND T1.line_cd     = T2.line_cd
         AND T1.peril_cd    = T2.peril_cd
         AND T2.line_cd     = T3.line_cd
         AND T2.share_cd    = T3.share_cd
         AND T3.share_type  = '3'
         AND T7.ri_cd       = T5.ri_cd
         AND T1.dist_no     = T4.dist_no
         AND T1.dist_seq_no = T4.dist_seq_no
         AND T4.line_cd     = T5.line_cd
         AND T4.frps_yy     = T5.frps_yy
         AND T4.frps_seq_no = T5.frps_seq_no
         AND T4.line_cd     = p_line_cd
         AND T4.frps_yy     = p_frps_yy
         AND T4.frps_seq_no = p_frps_seq_no ; 

      v_comm_amt           giri_frps_ri.ri_comm_amt%TYPE :=0;
      v_comm_rt            giri_frps_ri.ri_comm_rt%TYPE  :=0;
      v_comm_vat           giri_frps_ri.ri_comm_vat%TYPE  :=0;

      CURSOR sum_spct IS
      SELECT SUM(ri_shr_pct) sum_spct
        FROM giri_wfrps_ri
       WHERE line_cd     = p_line_cd
         AND frps_yy     = p_frps_yy
         AND frps_seq_no = p_frps_seq_no; 
            
      v_spct_total         NUMBER :=0;
      v_dist_no            NUMBER(8);
      v_prem_vat           giri_frps_ri.ri_prem_vat%TYPE := 0;
      v_tax_rate				giis_parameters.param_value_n%TYPE := 0;
   	
      -- jbfactor 09.20.2014 added new fields and a new cursor for peril distribution
      v_ri_tsi_amt         giri_wfrperil.ri_tsi_amt%TYPE := 0;
      v_ri_prem_amt        giri_wfrperil.ri_prem_amt%TYPE := 0;
      v_ri_prem_vat_rate   giis_reinsurer.input_vat_rate%TYPE;
      v_ri_comm_vat_rate   giis_reinsurer.input_vat_rate%TYPE;
      v_ri_prem_tax_rate   giis_reinsurer.int_tax_rt%TYPE; 
      v_tsi_ratio          giri_frps_ri.ri_shr_pct%TYPE; 
      v_ri_shr_pct         giri_wfrperil.ri_shr_pct%TYPE; 
      v_prem_tax				giri_wfrperil.prem_tax%TYPE; 
      v_post_flag 			giuw_pol_dist.post_flag%TYPE; 
      v_prem               NUMBER := 0;
      v_tsi                NUMBER := 0;
      v_peril_dist_sw		BOOLEAN;
    
      /*jbfactor 09.21.2014   this cursor is created for policy which are distributed by perils
      **            it uses a formula which is derived through ratio and propotion
      **            to arrived at the correct values of prem_amt and tsi-amt
      */
      CURSOR mwfrperil_area2 IS
      SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
             T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
             T5.ri_shr_pct, (T2.dist_TSI/v_TSI) * T5.ri_tsi_amt ri_tsi_amt, 
             (T2.dist_prem/v_prem) * T5.ri_prem_amt ri_prem_amt,
             T6.ri_comm_rt, (T6.ri_comm_rt/100) * ((T2.dist_prem/v_prem) * T5.ri_prem_amt) ri_comm_amt,
             ((T2.dist_prem/v_prem) * T5.ri_prem_amt * T7.input_vat_rate/100) ri_prem_vat,
             ((T6.ri_comm_rt/100) * ((T2.dist_prem/v_prem) * T5.ri_prem_amt) * (T7.input_vat_rate/100)) ri_comm_vat,
             T7.local_foreign_sw , T1.tsi_amt perilds_tsi , t2.dist_tsi facul_tsi, t1.prem_amt perilds_prem 
             ,t2.dist_prem facul_prem, t4.tot_fac_tsi , t4.tot_fac_prem, t5.ri_tsi_amt frps_ri_tsi , t5.ri_prem_amt frps_ri_prem 
             ,t2.dist_spct dist_spct , NVL(t2.dist_spct1, t2.dist_spct ) dist_spct1, T5.ri_shr_pct frps_ri_shr_pct
             ,t4.tot_fac_spct 
        FROM giuw_perilds T1, 
             giuw_perilds_dtl T2,                 
             giis_dist_share T3,
             giri_distfrps T4,
             giri_wfrps_ri T5,
             giis_peril T6,
             giis_reinsurer T7
       WHERE T1.line_cd     = T6.line_cd
         AND T1.peril_cd    = T6.peril_cd
         AND T1.dist_no     = T2.dist_no
         AND T1.dist_seq_no = T2.dist_seq_no
         AND T1.line_cd     = T2.line_cd
         AND T1.peril_cd    = T2.peril_cd
         AND T2.line_cd     = T3.line_cd
         AND T2.share_cd    = T3.share_cd
         AND T3.share_type  = '3'
         AND T5.ri_cd       = T7.ri_cd
         AND T1.dist_no     = T4.dist_no
         AND T1.dist_seq_no = T4.dist_seq_no
         AND T4.line_cd     = T5.line_cd
         AND T4.frps_yy     = T5.frps_yy
         AND T4.frps_seq_no = T5.frps_seq_no
         AND T4.line_cd     = p_line_cd
         AND T4.frps_yy     = p_frps_yy
         AND T4.frps_seq_no = p_frps_seq_no
         /*AND NOT EXISTS  ( SELECT 1  from giri_frps_ri t 
                                          WHERE t.fnl_binder_id = t5.pre_binder_id
                                             AND t.line_cd = :d120.line_cd 
                                             AND t.frps_yy = :d120.frps_yy
                                             AND t.frps_seq_no = :d120.frps_seq_no
                                     ) -- jbfactor 09.21.2014 commented out */ ;
         									 
      CURSOR sum_premtotal IS
      SELECT SUM(t2.dist_prem) sum_prem
        FROM giuw_perilds_dtl T2, 				
             giis_dist_share T3,
             giri_distfrps T4,
             giis_peril T6
       WHERE T2.line_cd     = T6.line_cd
         AND T2.peril_cd    = T6.peril_cd
         AND T2.line_cd     = T3.line_cd
         AND T2.share_cd    = T3.share_cd
         AND T3.share_type  = '3'
         AND T2.dist_no     = T4.dist_no
         AND T2.dist_seq_no = T4.dist_seq_no
         AND T4.line_cd     = p_line_cd
         AND T4.frps_yy     = p_frps_yy
         AND T4.frps_seq_no = p_frps_seq_no;

      CURSOR sum_tsitotal IS
      SELECT SUM(t2.dist_tsi) sum_tsi
        FROM giuw_perilds_dtl T2, 				
             giis_dist_share T3,
             giri_distfrps T4,
             giis_peril T6
       WHERE T2.line_cd     = T6.line_cd
         AND T2.peril_cd    = T6.peril_cd
         AND T2.line_cd     = T3.line_cd
         AND T2.share_cd    = T3.share_cd
         AND T3.share_type  = '3'
         AND T2.dist_no     = T4.dist_no
         AND T2.dist_seq_no = T4.dist_seq_no
         AND T6.peril_type  = 'B'
         AND T4.line_cd     = p_line_cd
         AND T4.frps_yy     = p_frps_yy
         AND T4.frps_seq_no = p_frps_seq_no;

   BEGIN
      -- jbfactor 09.21.2014 added checking for pol_flag
      FOR A1 IN (SELECT post_flag
                   FROM giuw_pol_dist
                  WHERE dist_no = p_dist_no) 
      LOOP
         v_post_flag := A1.post_flag;
         EXIT; 
      END LOOP;       
    	
      v_peril_dist_sw := binder_adjust_web_pkg.check_if_peril_dist(p_dist_no); -- jbfactor 09.21.2014 final validation to check if dist is by peril or by one risk
     	
      FOR v in param_prem_tax LOOP
         v_tax_rate := v.param_value_n;
      END LOOP;
    	
      -- jbfactor 09.21.2014 separated the codes for peril distribution from one risk distribution.
      -- patterned code changes based on create_wfrperil_m. For peril distribution, cursor mwfrperil_area2 will
      -- be used. For one risk distribution, cursor mwfrperil_area will be used.

      IF v_post_flag = 'P' OR v_peril_dist_sw = TRUE  THEN 	
         FOR A1 IN sum_premtotal LOOP
            IF A1.sum_prem = 0 THEN           
               v_prem := 1;                   
            ELSE                                                                 
               v_prem := A1.sum_prem;
            END IF;                                                    
            EXIT;
         END LOOP;
         
         FOR A2 IN sum_tsitotal LOOP
            IF A2.sum_tsi = 0 THEN           
               v_tsi := 1;                   
            ELSE                                                                            
               v_tsi := A2.sum_tsi;
            END IF;                                                   
            EXIT;
         END LOOP; 	

         FOR c1_rec in mwfrperil_area2 LOOP
            v_comm_amt :=  NVL(c1_rec.ri_comm_amt,0);
            v_comm_rt  :=  NVL(c1_rec.ri_comm_rt,0);
            v_comm_vat :=  NVL(c1_rec.ri_comm_vat,0) ;
              
            v_ri_tsi_amt := NVL(c1_rec.ri_tsi_amt,0);
            v_ri_prem_amt := NVL(c1_rec.ri_prem_amt,0);
            v_ri_shr_pct := NVL(c1_rec.ri_shr_pct,0) ;
            IF c1_rec.tot_fac_spct = 0 THEN
               v_tsi_ratio := 0;
            ELSE
               v_tsi_ratio :=  (c1_rec.frps_ri_shr_pct/ c1_rec.tot_fac_spct)  * (c1_rec.dist_spct );
            END IF;
   	      
            IF c1_rec.frps_ri_tsi = 0 AND c1_rec.frps_ri_shr_pct <> 0 THEN
               v_ri_tsi_amt :=  c1_rec.perilds_tsi * ( v_tsi_ratio / 100 ) ; 
            END IF; 
   	        
            v_ri_shr_pct := v_tsi_ratio   ;        
            binder_adjust_web_pkg.get_ri_taxes_multiplier (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no, p_iss_cd,
                                                           c1_rec.ri_cd, v_ri_comm_vat_rate, v_ri_prem_vat_rate, v_ri_prem_tax_rate, p_dist_no);                                 
            v_comm_vat :=  ROUND(NVL(c1_rec.ri_comm_amt,0) * nvl(v_ri_comm_vat_rate,0) /100 ,2 ) ; 
            v_prem_vat :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_vat_rate,0) /100 ,2 ) ; 
            v_prem_tax :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_tax_rate,0) /100 ,2 ) ;    
   	        
   --         if c1_rec.pre_binder_id = 14141 then 
   --         msg_alert ('Peril Code: ' || c1_rec.peril_cd  || ' ; RI Prem VAT1 : ' || v_prem_vat, 'I',    FALSE ); -- reikoh          
   --         end if; 
   	        
            FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat, b.prem_tax, b.ri_prem_vat /*jbfactor 09.20.2014 added fields */
                                 ,b.ri_tsi_amt, b.ri_prem_amt, b.ri_shr_pct
                            FROM giri_frps_ri a, giri_frperil b  
                           WHERE a.line_cd       = b.line_cd
                             AND a.frps_yy       = b.frps_yy
                             AND a.frps_seq_no   = b.frps_seq_no
                             AND a.ri_cd         = b.ri_cd
                             AND a.ri_seq_no		 = b.ri_seq_no
                             AND b.peril_cd      = c1_rec.peril_cd
                             AND a.line_cd       = c1_rec.line_cd
                             AND a.frps_yy       = c1_rec.frps_yy
                             AND a.frps_seq_no   = c1_rec.frps_seq_no
                             AND a.fnl_binder_id = c1_rec.pre_binder_id 
                             AND a.ri_cd         = c1_rec.ri_cd
                             AND a.ri_seq_no		 = c1_rec.ri_seq_no
                             AND reverse_sw    = 'N')
            LOOP
               v_comm_amt     := c2_rec.ri_comm_amt;
               v_comm_rt      := c2_rec.ri_comm_rt;
               v_comm_vat     := c2_rec.ri_comm_vat;
               -- jbfactor added new fields
               v_prem_vat     := c2_rec.ri_prem_vat;
               v_prem_tax     := c2_rec.prem_tax ; 
               v_ri_tsi_amt   := c2_rec.ri_tsi_amt;
               v_ri_prem_amt  := c2_rec.ri_prem_amt; 			        
               v_ri_shr_pct   := c2_rec.ri_shr_pct; 			           
               EXIT;
            END LOOP;                             
      
            IF c1_rec.local_foreign_sw != 'L' then      
               INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat,
                      prem_tax)
               VALUES(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      v_ri_shr_pct, v_ri_tsi_amt, v_ri_prem_amt,            
                      /* nvl(c1_rec.ri_tsi_amt,0) -- jbfactor 09.21.2014 */ v_ri_tsi_amt, v_ri_shr_pct, v_comm_rt,             
                      v_comm_amt, v_prem_vat, v_comm_vat, v_prem_tax );  
            ELSE
               INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat
                      ,prem_tax)
               VALUES(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      v_ri_shr_pct ,v_ri_tsi_amt ,  v_ri_prem_amt ,            
                      /*nvl(c1_rec.ri_tsi_amt,0) -- jbfactor 09.21.2014 */ v_ri_tsi_amt, v_ri_shr_pct, v_comm_rt,             
                      v_comm_amt, v_prem_vat, v_comm_vat, v_prem_tax );  
            END IF;                
         END LOOP;	
      ELSE
         FOR A1 IN(SELECT policy_id
                     FROM giuw_pol_dist 
                    WHERE dist_no = p_dist_no)
         LOOP 
            FOR A2 IN(SELECT dist_no
                        FROM giuw_pol_dist
                       WHERE policy_id = A1.policy_id
                         AND negate_date = (SELECT MAX(negate_date)
                                              FROM giuw_pol_dist
                                             WHERE policy_id = A1.policy_id
                                               AND negate_date IS NOT NULL)
                                             ORDER BY dist_no DESC)
            LOOP
               v_dist_no := a2.dist_no;
               EXIT;
            END LOOP;
            EXIT;
         END LOOP;
         
         FOR c1_rec in mwfrperil_area LOOP
            v_comm_amt :=  c1_rec.ri_comm_amt;
            v_comm_rt  :=  c1_rec.ri_comm_rt;
            v_comm_vat  :=  c1_rec.ri_comm_vat;
   			        
            v_ri_tsi_amt := c1_rec.ri_tsi_amt;
            v_ri_prem_amt := c1_rec.ri_prem_amt;
            v_ri_shr_pct := c1_rec.ri_shr_pct;
   			                
            -- jbfactor 09.20.2014 add additional fields 
            binder_adjust_web_pkg.get_ri_taxes_multiplier(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no, p_iss_cd 
                                                          ,c1_rec.ri_cd, v_ri_comm_vat_rate, v_ri_prem_vat_rate, v_ri_prem_tax_rate, p_dist_no);   

            v_comm_vat :=  ROUND(NVL(c1_rec.ri_comm_amt,0) * nvl(v_ri_comm_vat_rate,0) /100 ,2); 
            v_prem_vat :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_vat_rate,0) /100 ,2); 
            v_prem_tax :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_tax_rate,0) /100 ,2); 					     
   			        
            --BETH 042099 check if there is an existing record in the 
            --final table and get ri_comm_amt and ri_comm_rt from it      
            IF v_dist_no IS NOT NULL THEN     
               FOR C1 IN(SELECT frps_yy, frps_seq_no,line_cd
                           FROM giri_distfrps
                          WHERE dist_no = v_dist_no)
               LOOP
                  FOR C2 IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat, b.prem_tax, b.ri_prem_vat
                                   /* jbfactor 09.22.2014 added new fields */
                                   ,b.ri_shr_pct, b.ri_tsi_amt, b.ri_prem_amt 
                              FROM giri_frps_ri a, giri_frperil b
                             WHERE a.line_cd       = b.line_cd
                               AND a.frps_YY       = b.frps_yy
                               AND a.frps_seq_no   = b.frps_seq_no
                               AND a.ri_cd         = b.ri_cd
                               AND a.ri_seq_no     = b.ri_seq_no
                               AND b.peril_cd      = c1_rec.peril_cd
                               AND a.line_cd       = c1.line_cd
                               AND a.frps_YY       = c1.frps_yy
                               AND a.frps_seq_no   = c1.frps_seq_no
                               AND a.fnl_binder_id = c1_rec.pre_binder_id
                               AND a.ri_cd         = c1_rec.ri_cd
                               AND reverse_sw      = 'N')
                  LOOP
                     v_comm_amt := c2.ri_comm_amt;
                     v_comm_rt := c2.ri_comm_rt;
                     v_comm_vat := c2.ri_comm_vat;
                     -- jbfactor 09.20.2014 
                     v_prem_tax := c2.prem_tax;
                     v_prem_vat := c2.ri_prem_vat;     
                     v_ri_tsi_amt := c2.ri_tsi_amt;
                     v_ri_prem_amt := c2.ri_prem_amt; 			        
                     EXIT;
                  END LOOP;
                  EXIT;
               END LOOP;          
            END IF;  
                         
            FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat, b.prem_tax, b.ri_prem_vat /*jbfactor 09.20.2014 added fields */
                                 ,b.ri_tsi_amt, b.ri_prem_amt, b.ri_shr_pct 
                            FROM giri_frps_ri a, giri_frperil b  
                           WHERE a.line_cd       = b.line_cd
                             AND a.frps_YY       = b.frps_yy
                             AND a.frps_seq_no   = b.frps_seq_no
                             AND a.ri_cd         = b.ri_cd
                             AND a.ri_seq_no     = b.ri_seq_no --Added by carlo SR-23424 01-23-2017
                             AND b.peril_cd      = c1_rec.peril_cd
                             AND a.line_cd       = c1_rec.line_cd
                             AND a.frps_YY       = c1_rec.frps_yy
                             AND a.frps_seq_no   = c1_rec.frps_seq_no
                             AND a.fnl_binder_id = c1_rec.pre_binder_id 
                             AND a.ri_cd         = c1_rec.ri_cd
                             AND reverse_sw      = 'N')
            LOOP
               v_comm_amt :=  c2_rec.ri_comm_amt;
               v_comm_rt  :=  c2_rec.ri_comm_rt;
               v_comm_vat  :=  c2_rec.ri_comm_vat;
               -- jbfactor added new fields
               v_prem_vat := c2_rec.ri_prem_vat;
               v_prem_tax := c2_rec.prem_tax ; 			        
               v_ri_tsi_amt := c2_rec.ri_tsi_amt;
               v_ri_prem_amt := c2_rec.ri_prem_amt;
               v_ri_shr_pct := c2_rec.ri_shr_pct;
               EXIT;
            END LOOP;                        
            -- v_prem_vat := nvl(c1_rec.ri_prem_vat,0); --A.R.C. 05.09.2007  -- jbfactor 09.20.2014 commented out 
            -- ADJUST_PREM_VAT(:d120.ri_prem_vat,:d120.ri_cd); --A.R.C. 05.09.2007 --comment out by Melvin John O. Ostia 08282014
            -- binder_adjust.adjust_prem_vat_new(v_prem_vat,:d120.ri_cd,:v100.line_cd,:v100.frps_yy,:v100.frps_seq_no);--replace by this code 08282014

            IF c1_rec.local_foreign_sw != 'L' then			--L.D.G.	07/14/2008 
               INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat,
                      prem_tax)
               VALUES(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor 09.22.2014 replaced with: */ v_ri_shr_pct 
                      , /*nvl(c1_rec.ri_tsi_amt,0) -- jbfactor 09.22.2014 replaced with: */ v_ri_tsi_amt 
                      , /*(nvl(c1_rec.ri_prem_amt,0) -- jbfactor 09.22.2014 replaced with: */ v_ri_prem_amt            
                      , /*nvl(c1_rec.ri_tsi_amt,0) -- jbfactor 09.22.2014 */ v_ri_tsi_amt
                      , /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor 09.22.2014*/ v_ri_shr_pct, v_comm_rt,             
                      v_comm_amt, v_prem_vat, v_comm_vat, /*round(c1_rec.ri_prem_amt*(V_TAX_RATE / 100),2) -- jbfactor 09.20.2014 */ v_prem_tax );  --Lem
            ELSE
               INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat
                      ,prem_tax)
               VALUES
                     (c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      /*c1_rec.ri_shr_pct -- jbfactor 09.22.2014 */ v_ri_shr_pct , /*c1_rec.ri_tsi_amt */ v_ri_tsi_amt
                      , /*c1_rec.ri_prem_amt*/ v_ri_prem_amt , /*c1_rec.ri_tsi_amt*/ v_ri_tsi_amt
                      , /*c1_rec.ri_shr_pct*/ v_ri_shr_pct , v_comm_rt,             
                      v_comm_amt, v_prem_vat, v_comm_vat, /*0 -- jbfactor 09.20.2014 */ v_prem_tax ); 
            END IF;							--L.D.G.	07/14/2008  			         
         END LOOP;			        	
      END IF;
         
      FOR A3 IN sum_spct LOOP
         v_spct_total := A3.sum_spct;
      END LOOP;
      
      IF p_tot_fac_spct = v_spct_total THEN
         --offset_process; --comment out by Melvin John O. Ostia 07152014
         NULL;
      END IF;
   --   msg_alert ('dumaan rito : END NG GIRI_WFRPERIL_R FINAL  ', 'I', FALSE ); 
   END;
   
   /*
   **  Created by       : Bonok
   **  Date Created     : 09.25.2014
   **  Reference By     : (GIRIS001 - Create RI Placement)
   **                      Program Unit - CREATE_WFRPERIL_M
   */
   --populates giri_wfrperil after records are inserted in giri_wfrps_ri
   PROCEDURE create_wfrperil_m_giris001(
      p_dist_no               giuw_perilds_dtl.dist_no%TYPE,
      p_line_cd               giri_wfrps_peril_grp.line_cd%TYPE,
      p_frps_yy               giri_wfrps_peril_grp.frps_yy%TYPE,
      p_frps_seq_no           giri_wfrps_peril_grp.frps_seq_no%TYPE,
      p_iss_cd            IN  gipi_parlist.iss_cd%TYPE,
      p_tot_fac_spct      IN  giri_distfrps.tot_fac_spct%TYPE
   ) IS
      CURSOR param_prem_tax IS
      SELECT param_value_n
        FROM giis_parameters
       WHERE param_name LIKE 'RI PREMIUM TAX';
   		 
      CURSOR mwfrperil_area IS
      SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
             T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
             T5.ri_shr_pct, (T5.ri_shr_pct/100) * T1.tsi_amt ri_tsi_amt, 
             (NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt ri_prem_amt,
             T6.ri_comm_rt, 
             (T6.ri_comm_rt/100) * ((NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt) ri_comm_amt,
             ((NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt) * (input_vat_rate/100) ri_prem_vat,
             ((T6.ri_comm_rt/100) * ((NVL(T5.ri_shr_pct2,T5.ri_shr_pct)/100) * T1.prem_amt) * (input_vat_rate/100)) ri_comm_vat,
             /*T8.param_value_n,*/ T7.local_foreign_sw		--Lem	
             ,T4.dist_seq_no --added by mikel 11.28.2011;
        FROM giuw_perilds T1, 
             giuw_perilds_dtl T2, 				
             giis_dist_share T3,
             giri_wdistfrps T4,
             giri_wfrps_ri T5,
             giis_peril T6, 
             giis_reinsurer T7
       WHERE T1.line_cd     = T6.line_cd
         AND T1.peril_cd    = T6.peril_cd
         AND T1.dist_no     = T2.dist_no
         AND T1.dist_seq_no = T2.dist_seq_no
         AND T1.line_cd     = T2.line_cd
         AND T1.peril_cd    = T2.peril_cd
         AND T2.line_cd     = T3.line_cd
         AND T2.share_cd    = T3.share_cd
         AND T3.share_type  = '3'
         AND T7.ri_cd       = T5.ri_cd
         AND T1.dist_no     = T4.dist_no
         AND T1.dist_seq_no = T4.dist_seq_no
         AND T4.line_cd     = T5.line_cd
         AND T4.frps_yy     = T5.frps_yy
         AND T4.frps_seq_no = T5.frps_seq_no
         AND T4.line_cd     = p_line_cd
         AND T4.frps_yy     = p_frps_yy
         AND T4.frps_seq_no = p_frps_seq_no;
      
      v_prem               NUMBER :=0;
      v_tsi                NUMBER :=0;
      v_prem_vat				NUMBER :=0;
      v_prem_tax				giri_wfrperil.prem_tax%TYPE := 0;
      v_comm_amt           giri_frps_ri.ri_comm_amt%TYPE :=0;
      v_comm_rt            giri_frps_ri.ri_comm_rt%TYPE  :=0;
      v_comm_vat				NUMBER := 0;
      -- jbfactor 09.20.2014 added new fields 
      v_ri_tsi_amt 			giri_wfrperil.ri_tsi_amt%TYPE := 0 ;
      v_ri_prem_amt 			giri_wfrperil.ri_prem_amt%TYPE := 0 ;
      v_ri_prem_vat_rate   giis_reinsurer.input_vat_rate%TYPE ;
      v_ri_comm_vat_rate   giis_reinsurer.input_vat_rate%TYPE;
      v_ri_prem_tax_rate   giis_reinsurer.int_tax_rt%TYPE; 
      v_tsi_ratio 			giri_frps_ri.ri_shr_pct%TYPE ; 
      v_ri_shr_pct			giri_wfrperil.ri_shr_pct%TYPE ; 
      v_peril_dist_sw		BOOLEAN;
	  --added by robert 10.13.15 GENQA 5053
	  v_allied_facul       BOOLEAN;
      v_ann_ri_s_amt       giri_wfrperil.ann_ri_s_amt%TYPE;
      v_ann_ri_pct         giri_wfrperil.ann_ri_pct%TYPE;	  

      CURSOR sum_premtotal IS
      SELECT SUM(t2.dist_prem) sum_prem
        FROM giuw_perilds_dtl T2, 				
             giis_dist_share T3,
             giri_wdistfrps T4,
             giis_peril T6
       WHERE T2.line_cd     = T6.line_cd
         AND T2.peril_cd    = T6.peril_cd
         AND T2.line_cd     = T3.line_cd
         AND T2.share_cd    = T3.share_cd
         AND T3.share_type  = '3'
         AND T2.dist_no     = T4.dist_no
         AND T2.dist_seq_no = T4.dist_seq_no
         AND T4.line_cd     = p_line_cd
         AND T4.frps_yy     = p_frps_yy
         AND T4.frps_seq_no = p_frps_seq_no;

      CURSOR sum_tsitotal IS
      SELECT SUM(t2.dist_tsi) sum_tsi
        FROM giuw_perilds_dtl T2, 				
             giis_dist_share T3,
             giri_wdistfrps T4,
             giis_peril T6
       WHERE T2.line_cd     = T6.line_cd
         AND T2.peril_cd    = T6.peril_cd
         AND T2.line_cd     = T3.line_cd
         AND T2.share_cd    = T3.share_cd
         AND T3.share_type  = '3'
         AND T2.dist_no     = T4.dist_no
         AND T2.dist_seq_no = T4.dist_seq_no
         AND T6.peril_type  = 'B'
         AND T4.line_cd     = p_line_cd
         AND T4.frps_yy     = p_frps_yy
         AND T4.frps_seq_no = p_frps_seq_no;

      /*BETH 022499 this cursor is created for policy which are distributed by perils
      **            it uses a formula which is derived through ratio and propotion
      **            to arrived at the correct values of prem_amt and tsi-amt
      */
      CURSOR mwfrperil_area2 IS
      SELECT T4.line_cd, T5.frps_yy, T5.frps_seq_no,T5.pre_binder_id,
             T5.ri_seq_no, T2.peril_cd, T5.ri_cd,
             T5.ri_shr_pct, (T2.dist_TSI/v_TSI) * T5.ri_tsi_amt ri_tsi_amt, 
             (T2.dist_prem/v_prem) * T5.ri_prem_amt ri_prem_amt,
             T6.ri_comm_rt, 
             (T6.ri_comm_rt/100) * ((T2.dist_prem/v_prem) * T5.ri_prem_amt) ri_comm_amt,
             ((T2.dist_prem/v_prem) * T5.ri_prem_amt * T7.input_vat_rate/100) ri_prem_vat,
             ((T6.ri_comm_rt/100) * ((T2.dist_prem/v_prem) * T5.ri_prem_amt) * (T7.input_vat_rate/100)) ri_comm_vat,
             /*T8.param_value_n,*/ T7.local_foreign_sw--Lem
             ,T1.tsi_amt perilds_tsi , t2.dist_tsi facul_tsi, t1.prem_amt perilds_prem 
             ,t2.dist_prem facul_prem, t4.tot_fac_tsi , t4.tot_fac_prem, t5.ri_tsi_amt frps_ri_tsi 
             ,t5.ri_prem_amt frps_ri_prem , t2.dist_spct dist_spct , NVL(t2.dist_spct1, t2.dist_spct ) dist_spct1
             ,T5.ri_shr_pct frps_ri_shr_pct , t4.tot_fac_spct
             ,T4.dist_seq_no --added by robert SR 21734 02.17.16 
         FROM giuw_perilds T1, 
              giuw_perilds_dtl T2, 				
              giis_dist_share T3,
              giri_wdistfrps T4,
              giri_wfrps_ri T5,
              giis_peril T6,
              giis_reinsurer T7
        WHERE T1.line_cd     = T6.line_cd
          AND T1.peril_cd    = T6.peril_cd
          AND T1.dist_no     = T2.dist_no
          AND T1.dist_seq_no = T2.dist_seq_no
          AND T1.line_cd     = T2.line_cd
          AND T1.peril_cd    = T2.peril_cd
          AND T2.line_cd     = T3.line_cd
          AND T2.share_cd    = T3.share_cd
          AND T3.share_type  = '3'
          AND T5.ri_cd		  = T7.ri_cd
          AND T1.dist_no     = T4.dist_no
          AND T1.dist_seq_no = T4.dist_seq_no
          AND T4.line_cd     = T5.line_cd
          AND T4.frps_yy     = T5.frps_yy
          AND T4.frps_seq_no = T5.frps_seq_no
          AND T4.line_cd     = p_line_cd
          AND T4.frps_yy     = p_frps_yy
          AND T4.frps_seq_no = p_frps_seq_no;

      CURSOR sum_spct IS
      SELECT SUM(ri_shr_pct) sum_spct
        FROM giri_wfrps_ri
       WHERE line_cd     = p_line_cd
         AND frps_yy     = p_frps_yy
         AND frps_seq_no = p_frps_seq_no;  

      v_pol_flag         VARCHAR2(1);    
      v_spct_total       NUMBER := 0;
      v_cnt2             NUMBER := 0;
      v_dist_no          NUMBER(8);
      v_tax_rate			 giis_parameters.param_value_n%TYPE := 0;
      
   BEGIN
 	   FOR v in param_prem_tax LOOP
 		   v_tax_rate := v.param_value_n;
 	   END LOOP;
  
      FOR A1 IN(SELECT policy_id
                  FROM giuw_pol_dist 
             WHERE dist_no = p_dist_no)
      LOOP 
         FOR A2 IN(SELECT dist_no
                     FROM giuw_pol_dist
                    WHERE policy_id = A1.policy_id
                      AND negate_date = (SELECT MAX(negate_date)
                                           FROM giuw_pol_dist
                                          WHERE policy_id = A1.policy_id
                                            AND negate_date IS NOT NULL)
                                          ORDER BY dist_no DESC)
         LOOP
            v_dist_no := a2.dist_no;
            EXIT;
         END LOOP;
         EXIT;
      END LOOP;  
      
      --BETH 020999 add a condition that seperates creation of records in giri_wfrperil
      --            depending on what type of distribution 
      FOR A1 IN (SELECT post_flag
                   FROM giuw_pol_dist
                  WHERE dist_no = p_dist_no) 
      LOOP
         v_pol_flag := A1.post_flag;
         EXIT; 
      END LOOP;   
             
      v_peril_dist_sw := binder_adjust_web_pkg.check_if_peril_dist(p_dist_no ); -- jbfactor 09.21.2014 final validation to check if dist is by peril or by one risk   
             
      IF v_pol_flag = 'P' OR v_peril_dist_sw = TRUE THEN
         FOR A1 IN sum_premtotal LOOP
            IF A1.sum_prem = 0 THEN            --added by grace, 02022004
         	   v_prem := 1;                    --to resolve ora-01467 (zero divide)
            ELSE															 --for endts with zero (0) prem		
         	   v_prem := A1.sum_prem;
            END IF;													 --end of added codes, grace
            EXIT;
         END LOOP;
     
         FOR A2 IN sum_tsitotal LOOP
            IF A2.sum_tsi = 0 THEN            --added by bdarusin, 12132002
         	   v_tsi := 1;                    --to resolve ora-01467 (zero divide)
            ELSE															 --for endts with zero (0) tsi					
         	   v_tsi := A2.sum_tsi;
            END IF;													 --end of added codes, bdarusin
            EXIT;
         END LOOP; 
    
         FOR c1_rec in mwfrperil_area2 LOOP
            -- jbfactor 09.20.2014 added NVL for ri_comm_amt , ri_comm_rt, ri_comm_vat 
            v_comm_amt :=  NVL(c1_rec.ri_comm_amt,0);
            v_comm_rt  :=  NVL(c1_rec.ri_comm_rt,0);
            v_comm_vat :=  NVL(c1_rec.ri_comm_vat,0) ;
            -- jbfactor 09.20.2014 added new fields        
            v_ri_tsi_amt := NVL(c1_rec.ri_tsi_amt,0);
            v_ri_prem_amt := NVL(c1_rec.ri_prem_amt,0);
            v_ri_shr_pct := NVL(c1_rec.ri_shr_pct,0) ;         
                   
            -- jbfactor 09.20.2014 added recomputation for endorsement of allied peril (non-zero TSI) and non-zero premium
            IF c1_rec.tot_fac_spct = 0 THEN
               v_tsi_ratio := 0;
            ELSE
               v_tsi_ratio := (c1_rec.frps_ri_shr_pct/c1_rec.tot_fac_spct) * (c1_rec.dist_spct);
            END IF;
         
            IF c1_rec.frps_ri_tsi = 0 AND c1_rec.frps_ri_shr_pct <> 0 THEN
               v_ri_tsi_amt :=  c1_rec.perilds_tsi * ( v_tsi_ratio / 100 ) ; 

            END IF; 
            
            v_ri_shr_pct := v_tsi_ratio   ;        
           
            -- jbfactor 09.20.2014 add additional fields 
            binder_adjust_web_pkg.get_ri_taxes_multiplier(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no, p_iss_cd 
                                                          ,c1_rec.ri_cd, v_ri_comm_vat_rate, v_ri_prem_vat_rate, v_ri_prem_tax_rate, p_dist_no);
   									     
            v_comm_vat :=  ROUND(NVL(c1_rec.ri_comm_amt,0) * nvl(v_ri_comm_vat_rate,0) /100 ,2 ) ; 
            v_prem_vat :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_vat_rate,0) /100 ,2 ) ; 
            v_prem_tax :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_tax_rate,0) /100 ,2 ) ; 					     
            --added by robert 10.13.15 GENQA 5053
			v_allied_facul := giuw_pol_dist_final_pkg.check_peril_dist (p_dist_no, c1_rec.dist_seq_no); --modified param by robert SR 21734 02.17.16

            IF v_allied_facul
            THEN
               v_ann_ri_s_amt := 0;
               v_ann_ri_pct := 0;
            ELSE
               v_ann_ri_s_amt := v_ri_tsi_amt;
               v_ann_ri_pct := v_ri_shr_pct;
            END IF;
			--end robert 10.13.15 GENQA 5053				
            --BETH 042099 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            IF v_dist_no IS NOT NULL THEN
               FOR C1 IN(SELECT frps_yy, frps_seq_no,line_cd
                           FROM giri_distfrps
                          WHERE dist_no = v_dist_no)
               LOOP
                  FOR C2 IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat, b.prem_tax, b.ri_tsi_amt, b.ri_prem_amt, b.ri_prem_vat
                              FROM giri_frps_ri a, giri_frperil b
                             WHERE a.line_cd       = b.line_cd
                               AND a.frps_YY       = b.frps_yy
                               AND a.frps_seq_no   = b.frps_seq_no
                               AND a.ri_cd         = b.ri_cd
                               AND a.ri_seq_no     = b.ri_seq_no
                               AND b.peril_cd      = c1_rec.peril_cd
                               AND a.line_cd       = c1.line_cd
                               AND a.frps_YY       = c1.frps_yy
                               AND a.frps_seq_no   = c1.frps_seq_no
                               AND a.fnl_binder_id = c1_rec.pre_binder_id
                               AND a.ri_cd         = c1_rec.ri_cd
                               AND reverse_sw    = 'N')
                  LOOP
                     v_comm_amt :=  c2.ri_comm_amt;
                     v_comm_rt  :=  c2.ri_comm_rt;
                     v_comm_vat :=  c2.ri_comm_vat;
                     -- jbfactor 09.20.2014 added retrieval of additional field 
                     v_prem_tax := c2.prem_tax ; 
                     v_ri_tsi_amt := c2.ri_tsi_amt;
                     v_ri_prem_amt := c2.ri_prem_amt; 
                     v_prem_vat := c2.ri_prem_vat;
                     EXIT;
                  END LOOP;
                  EXIT;
               END LOOP;          
            END IF;      
             
            --BETH 040699 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat, b.prem_tax, b.ri_prem_vat, b.ri_tsi_amt, b.ri_prem_amt 
                            FROM giri_frps_ri a, giri_frperil b
                           WHERE a.line_cd       = b.line_cd
                             AND a.frps_YY       = b.frps_yy
                             AND a.frps_seq_no   = b.frps_seq_no
                             AND a.ri_cd         = b.ri_cd
                             AND b.peril_cd      = c1_rec.peril_cd
                             AND a.line_cd       = c1_rec.line_cd
                             AND a.frps_YY       = c1_rec.frps_yy
                             AND a.frps_seq_no   = c1_rec.frps_seq_no
                             AND a.fnl_binder_id = c1_rec.pre_binder_id 
                             AND a.ri_cd         = c1_rec.ri_cd
                             AND reverse_sw      = 'N')
            LOOP
               v_comm_amt :=  c2_rec.ri_comm_amt;
               v_comm_rt  :=  c2_rec.ri_comm_rt;
               v_comm_vat  :=  c2_rec.ri_comm_vat;
               -- jbfactor 09.20.2014 added field 
               v_prem_tax := c2_rec.prem_tax; 
               v_prem_vat := c2_rec.ri_prem_vat; 
               v_ri_tsi_amt := c2_rec.ri_tsi_amt;
               v_ri_prem_amt := c2_rec.ri_prem_amt;
               EXIT;
            END LOOP;      
                         
            -- v_prem_vat := nvl(c1_rec.ri_prem_vat,0); --A.R.C. 05.09.2007  -- jbfactor 09.20.2014 moved code to higher part 
            --ADJUST_PREM_VAT(:d120.ri_prem_vat,:d120.ri_cd); --A.R.C. 05.09.2007 --comment out by Melvin John O. Ostia 08282014
            --  binder_adjust.adjust_prem_vat_new(v_prem_vat,:d120.ri_cd,:v100.line_cd,:v100.frps_yy,:v100.frps_seq_no);--replace by this code 08282014 -- jbfactor commented 09.20.2014
            --msg_alert (c1_rec.ri_prem_amt||'-'||V_TAX_RATE,'I',FALSE); 	
           
            IF c1_rec.local_foreign_sw != 'L' then		--L.D.G. 07/14/2008
               INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat,
                      prem_tax)
               VALUES(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor replaced with : */ v_ri_shr_pct , /* nvl(c1_rec.ri_tsi_amt,0) --jbfactor replaced with:*/ v_ri_tsi_amt , /*nvl(c1_rec.ri_prem_amt,0) -- jbfactor 09.20.2014 replaced with:*/ v_ri_prem_amt ,            
                      --v_ri_tsi_amt /*NVL(c1_rec.ri_tsi_amt,0)*/, /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor replaced with:*/ v_ri_shr_pct , v_comm_rt,  removed by robert 10.13.15 GENQA 5053           
                      v_ann_ri_s_amt, v_ann_ri_pct , v_comm_rt, --added by robert 10.13.15 GENQA 5053  
					  v_comm_amt, v_prem_vat, v_comm_vat, /*round(c1_rec.ri_prem_amt*(V_TAX_RATE / 100),2)  --- replaced by jbfactor 09.20.2014 */ v_prem_tax );  --Lem
            ELSE
	            INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat
                     ,prem_tax)
	            VALUES(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor replaced with :*/ v_ri_shr_pct , /*nvl(c1_rec.ri_tsi_amt,0) -- jbfactor 09.20.2014 replaced with: */ v_ri_tsi_amt , /*nvl(c1_rec.ri_prem_amt,0) -- jbfactor 09.20.2014 replaced with:*/ v_ri_prem_amt ,            
                      --v_ri_tsi_amt /*NVL(c1_rec.ri_tsi_amt,0)*/, /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor replaced with:*/ v_ri_shr_pct , v_comm_rt,  removed by robert 10.13.15 GENQA 5053           
                      v_ann_ri_s_amt, v_ann_ri_pct , v_comm_rt, --added by robert 10.13.15 GENQA 5053  
                      v_comm_amt, v_prem_vat, v_comm_vat, /*0 -- replaced by jbfactor 09.20.2014 */ v_prem_tax );  
	         END IF;				--Lem	07/14/2008 
         END LOOP;
      ELSE 	
         FOR c1_rec in mwfrperil_area LOOP  
            v_comm_amt :=  c1_rec.ri_comm_amt;
            v_comm_rt  :=  c1_rec.ri_comm_rt;
            v_comm_vat :=  c1_rec.ri_comm_vat;
            --BETH 042099 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it  
            v_prem_tax := 0 ; -- jbfactor 09.20.2014    
            v_ri_tsi_amt := c1_rec.ri_tsi_amt;
            v_ri_prem_amt := c1_rec.ri_prem_amt; 
            v_ri_shr_pct := NVL(c1_rec.ri_shr_pct,0); 
            
            binder_adjust_web_pkg.get_ri_taxes_multiplier(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no, p_iss_cd 
									                               ,c1_rec.ri_cd, v_ri_comm_vat_rate, v_ri_prem_vat_rate, v_ri_prem_tax_rate, p_dist_no);
									     
				v_comm_vat :=  ROUND(NVL(c1_rec.ri_comm_amt,0) * nvl(v_ri_comm_vat_rate,0) /100 ,2 ) ; 
				v_prem_vat :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_vat_rate,0) /100 ,2 ) ; 
				v_prem_tax :=  ROUND(NVL(c1_rec.ri_prem_amt,0) * nvl(v_ri_prem_tax_rate,0) /100 ,2 ) ; 					  
          
            IF v_dist_no IS NOT NULL THEN
               FOR C1 IN(SELECT frps_yy, frps_seq_no,line_cd
                           FROM giri_distfrps
                          WHERE dist_no = v_dist_no
                            AND dist_seq_no = c1_rec.dist_seq_no) --added by mikel; to get the corresponding frps number when its distribution were grouped into two or more distribution
               LOOP
                  FOR C2 IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat, b.prem_tax, b.ri_prem_vat, b.ri_tsi_amt, b.ri_prem_amt /* jbfactor 09.20.2014 added prem_tax and prem_vat */ 
                              FROM giri_frps_ri a, giri_frperil b
                             WHERE a.line_cd       = b.line_cd
                               AND a.frps_YY       = b.frps_yy
                               AND a.frps_seq_no   = b.frps_seq_no
                               AND a.ri_cd         = b.ri_cd
                               AND a.ri_seq_no     = b.ri_seq_no
                               AND b.peril_cd      = c1_rec.peril_cd
                               AND a.line_cd       = c1.line_cd
                               AND a.frps_YY       = c1.frps_yy
                               AND a.frps_seq_no   = c1.frps_seq_no
                               AND a.fnl_binder_id = c1_rec.pre_binder_id
                               AND a.ri_cd         = c1_rec.ri_cd
                               AND reverse_sw      = 'N')
                  LOOP
                     v_comm_amt :=  c2.ri_comm_amt;
                     v_comm_rt  :=  c2.ri_comm_rt;
                     v_comm_vat :=  c2.ri_comm_vat;
                     -- jbfactor 09.20.2014 
                     v_prem_tax := c2.prem_tax; 
                     v_prem_vat := c2.ri_prem_vat; 
                     v_ri_tsi_amt := c2.ri_tsi_amt;
                     v_ri_prem_amt := c2.ri_prem_amt; 
                     EXIT;
                  END LOOP;
                EXIT;
               END LOOP;          
            END IF;
            
            --BETH 040699 check if there is an existing record in the 
            --     final table and get ri_comm_amt and ri_comm_rt from it       
            FOR c2_rec IN(SELECT b.ri_comm_rt, b.ri_comm_amt, b.ri_comm_vat, b.prem_tax, b.ri_prem_vat , b.ri_tsi_amt, b.ri_prem_amt  /* jbfactor 09.20.2014 added prem_tax */ 
                            FROM giri_frps_ri a, giri_frperil b 
                           WHERE a.line_cd       = b.line_cd
                             AND a.frps_YY       = b.frps_yy
                             AND a.frps_seq_no   = b.frps_seq_no
                             AND a.ri_cd         = b.ri_cd
                             AND b.peril_cd      = c1_rec.peril_cd
                             AND a.line_cd       = c1_rec.line_cd
                             AND a.frps_YY       = c1_rec.frps_yy
                             AND a.frps_seq_no   = c1_rec.frps_seq_no
                             AND a.fnl_binder_id = c1_rec.pre_binder_id 
                             AND a.ri_cd         = c1_rec.ri_cd
                             AND reverse_sw    = 'N')
            LOOP
               v_comm_amt :=  c2_rec.ri_comm_amt;
               v_comm_rt  :=  c2_rec.ri_comm_rt;
               v_comm_vat :=  c2_rec.ri_comm_vat;
               -- jbfactor 09.20.2014 
               v_prem_tax := c2_rec.prem_tax ; 
               v_prem_vat := c2_rec.ri_prem_vat; 
               v_ri_tsi_amt := c2_rec.ri_tsi_amt;
               v_ri_prem_amt := c2_rec.ri_prem_amt;  
               EXIT;
            END LOOP;     
                      
            -- v_prem_vat := nvl(c1_rec.ri_prem_vat,0); --A.R.C. 05.09.2007  -- jbfactor commented out 09.20.2014 
            --ADJUST_PREM_VAT(:d120.ri_prem_vat,:d120.ri_cd); --A.R.C. 05.09.2007 --comment out by Melvin John O. Ostia 08282014
            --  binder_adjust.adjust_prem_vat_new(v_prem_vat,:d120.ri_cd,:v100.line_cd,:v100.frps_yy,:v100.frps_seq_no);--replace by this code 08282014 -- jbfactor commented out 09.20.2014 
            --msg_alert (c1_rec.ri_prem_amt||'-'||V_TAX_RATE,'I',FALSE); 	 

            IF c1_rec.local_foreign_sw != 'L' then					--L.D.G.	07/14/2008 
               INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat,
                      prem_tax)
               VALUES(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor replaced with:*/ v_ri_shr_pct , /*nvl(c1_rec.ri_tsi_amt,0) -- jbfactor 09.20.2014 replaced with: */ v_ri_tsi_amt , /*nvl(c1_rec.ri_prem_amt,0) -- jbfactor 09.20.2014 replaced with: */ v_ri_prem_amt ,        
                      NVL(c1_rec.ri_tsi_amt,0), NVL(c1_rec.ri_shr_pct,0), v_comm_rt,             
                      v_comm_amt, v_prem_vat, v_comm_vat, /*round(c1_rec.ri_prem_amt*(V_TAX_RATE / 100),2) -- jbfactor replaced with */ v_prem_tax );  --Lem
            ELSE
               INSERT INTO giri_wfrperil
                     (line_cd, frps_yy, frps_seq_no,            
                      ri_seq_no, peril_cd, ri_cd,                  
                      ri_shr_pct, ri_tsi_amt, ri_prem_amt,            
                      ann_ri_s_amt, ann_ri_pct, ri_comm_rt,             
                      ri_comm_amt, ri_prem_vat, ri_comm_vat,
                      prem_tax)
               VALUES(c1_rec.line_cd, c1_rec.frps_yy, c1_rec.frps_seq_no,            
                      c1_rec.ri_seq_no, c1_rec.peril_cd, c1_rec.ri_cd,                  
                      /*nvl(c1_rec.ri_shr_pct,0) -- jbfactor replaced with: */ v_ri_shr_pct , /* nvl(c1_rec.ri_tsi_amt,0) -- jbfactor 09.20.2014 replaced with: */ v_ri_tsi_amt ,/* nvl(c1_rec.ri_prem_amt,0) -- jbfactor 09.20.2014 replaced with :*/ v_ri_prem_amt ,        
                      nvl(c1_rec.ri_tsi_amt,0), nvl(c1_rec.ri_shr_pct,0), v_comm_rt,             
                      v_comm_amt, v_prem_vat, v_comm_vat, /* 0 -- jbfactor 09.20.2014 replaced with */ v_prem_tax ); --Lem
            END IF;						--L.D.G.	07/14/2008 
         END LOOP;
      END IF;
  
      FOR A3 IN sum_spct LOOP
         v_spct_total := A3.sum_spct;
      END LOOP;
      
      IF p_tot_fac_spct = v_spct_total THEN
         --offset_process; --comment out by Melvin John O. Ostia07152014
         NULL;
      END IF;
   END;

END GIRI_WFRPERIL_PKG;
/


