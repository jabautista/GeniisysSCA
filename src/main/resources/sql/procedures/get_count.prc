DROP PROCEDURE CPI.GET_COUNT;

CREATE OR REPLACE PROCEDURE CPI.Get_Count
AS
  TYPE tab_total         IS TABLE OF GIAC_RECAP_COUNT.total%TYPE;
  TYPE tab_total_losspd  IS TABLE OF GIAC_RECAP_COUNT.total_losspd%TYPE;
  TYPE tab_total_osloss  IS TABLE OF GIAC_RECAP_COUNT.total_osloss%TYPE;
  TYPE tab_rowno         IS TABLE OF GIAC_RECAP_ROW.rowno%TYPE;
  TYPE tab_rowtitle      IS TABLE OF GIAC_RECAP_ROW.rowtitle%TYPE;
  TYPE tab_line_cd       IS TABLE OF GIAC_RECAP_ROW.line_cd%TYPE;
  TYPE tab_tariff_cd     IS TABLE OF GIAC_RECAP_ROW.tariff_cd%TYPE;

  vv_total         tab_total;
  vv_total_losspd  tab_total_losspd;
  vv_total_osloss  tab_total_osloss;
  vv_rowno         tab_rowno;
  vv_rowtitle      tab_rowtitle;
  vv_line_cd       tab_line_cd;
  vv_tariff_cd     tab_tariff_cd;
  v_max_rowno      NUMBER(5,2);

  v_subline_lto    GIIS_SUBLINE.subline_cd%TYPE;
  v_total_cnt      NUMBER(15);
  
  --mikel 04.29.2013
  --Line cd parameters
   v_line_fi  giis_line.line_cd%TYPE;
   v_line_mn  giis_line.line_cd%TYPE;
   v_line_mh  giis_line.line_cd%TYPE;
   v_line_av  giis_line.line_cd%TYPE;
   v_line_su  giis_line.line_cd%TYPE;
   v_line_mc  giis_line.line_cd%TYPE;
   v_line_ac  giis_line.line_cd%TYPE;
   v_line_en  giis_line.line_cd%TYPE;
   
   
  
   /* Modified by: mikel 04.25.2013
   ** Modifications: get count per rowno
   */
   -- start -- mikel 04.25.2013
   --Procdure to get rowno of perils OTHER THAN CTPL NON-LTO for mc subline_type_cds
   FUNCTION get_mc_rowno(
      p_line_mc GIIS_LINE.line_cd%TYPE,
      p_rowno   GIAC_RECAP_SUMM_EXT.rowno%TYPE,
      p_rowtitle  GIAC_RECAP_SUMM_EXT.rowtitle%TYPE,
      p_peril_cd  giac_recap_row_dtl.peril_cd%TYPE) RETURN CHAR AS
      v_exs BOOLEAN := FALSE;
      v_rowno GIAC_RECAP_SUMM_EXT.rowno%TYPE;
      v_rowtitle GIAC_RECAP_SUMM_EXT.rowtitle%TYPE;
   BEGIN
      --Get the rowno of the OTHER THAN CTPL NON-LTO
      FOR OCTPL IN (SELECT a.rowno + b.rowno rowno
                     FROM giac_recap_row a, giac_recap_other_rows_mc b
                    WHERE a.line_cd = b.line_cd 
                      AND a.rowno = p_rowno
                      AND b.peril_cd = p_peril_cd)
      LOOP
        
        v_rowno := octpl.rowno;
        RETURN(v_rowno);
        v_exs := TRUE;
        EXIT;
      END LOOP; 
      
      --other perils
      IF v_exs = FALSE THEN
        BEGIN
            SELECT a.rowno + b.rowno
              INTO v_rowno
              FROM giac_recap_row a, giac_recap_other_rows_mc b
             WHERE a.line_cd = b.line_cd 
               AND a.rowno = p_rowno
               AND b.peril_cd IS NULL;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20110, 'No set-up for GIAC_RECAP_OTHER_ROWS_MC.');
        END;       
      END IF;                
      
      RETURN(v_rowno);
                        
   END;
   
   --Procdure to get rowtitle of perils OTHER THAN CTPL NON-LTO for mc subline_type_cds
   FUNCTION get_mc_rowtitle(
      p_line_mc GIIS_LINE.line_cd%TYPE,
      p_rowno   GIAC_RECAP_SUMM_EXT.rowno%TYPE,
      p_rowtitle  GIAC_RECAP_SUMM_EXT.rowtitle%TYPE,
      p_peril_cd  giac_recap_row_dtl.peril_cd%TYPE) RETURN CHAR AS
      v_exs BOOLEAN := FALSE;
      v_rowno GIAC_RECAP_SUMM_EXT.rowno%TYPE;
      v_rowtitle GIAC_RECAP_SUMM_EXT.rowtitle%TYPE;
   BEGIN
      --Get the rowno of the OTHER THAN CTPL NON-LTO
      FOR OCTPL IN (SELECT b.rowtitle, a.rowno + b.rowno rowno
                     FROM giac_recap_row a, giac_recap_other_rows_mc b
                    WHERE a.line_cd = b.line_cd 
                      AND a.rowno = p_rowno
                      AND b.peril_cd = p_peril_cd)
      LOOP
        
        v_rowtitle := octpl.rowtitle;
        RETURN(v_rowtitle);
        v_exs := TRUE;
        EXIT;
      END LOOP; 
      
      --other perils
      IF v_exs = FALSE THEN
        BEGIN
            SELECT b.rowtitle
              INTO v_rowtitle
              FROM giac_recap_row a, giac_recap_other_rows_mc b
             WHERE a.line_cd = b.line_cd 
               AND a.rowno = p_rowno
               AND b.peril_cd IS NULL;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR (-20120, 'No set-up for GIAC_RECAP_OTHER_ROWS_MC.');
        END;       
      END IF;                
      
      RETURN(v_rowtitle);
                        
   END;
   
    --count for rowno 23 RECAP I - PREMIUMS WRITTEN
    PROCEDURE count_rowno23_28_i
    IS
       v_recap_subline_type   giis_mc_subline_type.recap_subline_type%TYPE;
       v_subline_lto          giis_subline.subline_cd%TYPE := giisp.v ('MC_SUBLINE_LTO');
       v_rowno                giac_recap_summ_ext.rowno%TYPE;
       v_rowtitle             giac_recap_summ_ext.rowtitle%TYPE;
       v_exs                  BOOLEAN                                    := FALSE;
       v_recap_line_cd        giis_subline.recap_line_cd%TYPE;  
    BEGIN
       --rowno 23
       FOR rec IN (SELECT   line_cd, subline_cd, peril_cd, subline_type_cd
                       FROM giac_recap_dtl_ext b
                      WHERE b.subline_cd = v_subline_lto
                        AND b.line_cd = 'MC'
                        AND b.peril_cd != giisp.n ('CTPL')
                        AND b.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
                   GROUP BY b.line_cd, b.subline_cd, b.iss_cd,
                            b.issue_yy, b.pol_seq_no, b.renew_no,
                            b.peril_cd, b.subline_type_cd
                     HAVING SUM (DECODE (b.date_tag,'A', 1,'C', -10000,'S', 0,0)) > 0)
       LOOP
          v_recap_subline_type := NULL;
            
          SELECT recap_subline_type
            INTO v_recap_subline_type
            FROM giis_mc_subline_type
           WHERE subline_cd = v_subline_lto
             AND subline_type_cd = rec.subline_type_cd;

          IF v_recap_subline_type IS NULL
          THEN
             raise_application_error (-20130,'No set-up for recap_subline_type in giis_mc_subline_type.');
          ELSIF v_recap_subline_type = '1'
          THEN
             v_rowno := 23.1;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '2'
          THEN
             v_rowno := 23.2;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '3'
          THEN
             v_rowno := 23.3;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '4'
          THEN
             v_rowno := 23.4;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          END IF;

          v_exs := FALSE;

          FOR exs IN (SELECT DISTINCT 'X'
                                 FROM giac_recap_count
                                WHERE rowno = v_rowno)
          LOOP
             v_exs := TRUE;
          END LOOP;

          IF v_exs = FALSE
          THEN
             INSERT INTO giac_recap_count
                         (rowno, rowtitle, total)
                  VALUES (v_rowno, v_rowtitle, 0);
          END IF;

          UPDATE giac_recap_count
             SET total = NVL(total,0) + 1
           WHERE rowno = v_rowno;
       END LOOP;
       
       --rowno 28
       FOR rec IN (SELECT   line_cd, subline_cd, peril_cd, subline_type_cd
                       FROM giac_recap_dtl_ext b
                      WHERE b.subline_cd != v_subline_lto
                        AND b.line_cd = 'MC'
                        AND b.peril_cd != giisp.n ('CTPL')
                        AND b.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
                   GROUP BY b.line_cd, b.subline_cd, b.iss_cd,
                            b.issue_yy, b.pol_seq_no, b.renew_no,
                            b.peril_cd, b.subline_type_cd
                     HAVING SUM (DECODE (b.date_tag,'A', 1,'C', -10000,'S', 0,0)) > 0)
       LOOP
          v_recap_line_cd := NULL;
          
          SELECT recap_line_cd
            INTO v_recap_line_cd
            FROM giis_subline
           WHERE line_cd = 'MC' 
             AND subline_cd = rec.subline_cd;

          IF v_recap_line_cd IS NULL
          THEN
             raise_application_error (-20130,'No set-up for recap_line_cd in giis_subline.');
          ELSIF v_recap_line_cd = 'PC'
          THEN
             v_rowno := 28.1;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_line_cd = 'CV'
          THEN
             v_rowno := 28.2;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_line_cd = 'MC'
          THEN
             v_rowno := 28.3;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          END IF;

          v_exs := FALSE;

          FOR exs IN (SELECT DISTINCT 'X'
                                 FROM giac_recap_count
                                WHERE rowno = v_rowno)
          LOOP
             v_exs := TRUE;
          END LOOP;

          IF v_exs = FALSE
          THEN
             INSERT INTO giac_recap_count
                         (rowno, rowtitle, total)
--                  VALUES (v_rowno, v_rowtitle, 1);
                  VALUES (v_rowno, v_rowtitle, 0);     --modified by albert 12042013, count is doubled for the first policy counted if first value is 1                
          END IF;

          UPDATE giac_recap_count
             SET total = NVL(total,0) + 1
           WHERE rowno = v_rowno;
       END LOOP;
    END;
    
    --count for rowno 23 RECAP II - LOSSES INCURRED
    PROCEDURE count_rowno23_28_ii
    IS
       v_recap_subline_type   giis_mc_subline_type.recap_subline_type%TYPE;
       v_subline_lto          giis_subline.subline_cd%TYPE := giisp.v ('MC_SUBLINE_LTO');
       v_rowno                giac_recap_summ_ext.rowno%TYPE;
       v_rowtitle             giac_recap_summ_ext.rowtitle%TYPE;
       v_exs                  BOOLEAN                                    := FALSE;
       v_recap_line_cd        giis_subline.recap_line_cd%TYPE;  
    BEGIN
       --rowno 23
       FOR rec IN (SELECT   line_cd, subline_cd, peril_cd, subline_type_cd
                       FROM GIAC_RECAP_LOSSPD_EXT b
                      WHERE b.subline_cd = v_subline_lto
                        AND b.line_cd = 'MC'
                        AND b.peril_cd != giisp.n ('CTPL')
                   GROUP BY b.line_cd, b.subline_cd, b.iss_cd,
                            b.issue_yy, b.pol_seq_no, b.renew_no,
                            b.peril_cd, b.subline_type_cd)
       LOOP
          v_recap_subline_type := NULL;
            
          SELECT recap_subline_type
            INTO v_recap_subline_type
            FROM giis_mc_subline_type
           WHERE subline_cd = v_subline_lto
             AND subline_type_cd = rec.subline_type_cd;

          IF v_recap_subline_type IS NULL
          THEN
             raise_application_error (-20130,'No set-up for recap_subline_type in giis_mc_subline_type.');
          ELSIF v_recap_subline_type = '1'
          THEN
             v_rowno := 23.1;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '2'
          THEN
             v_rowno := 23.2;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '3'
          THEN
             v_rowno := 23.3;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '4'
          THEN
             v_rowno := 23.4;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          END IF;

          v_exs := FALSE;

          FOR exs IN (SELECT DISTINCT 'X'
                                 FROM giac_recap_count
                                WHERE rowno = v_rowno)
          LOOP
             v_exs := TRUE;
          END LOOP;

          IF v_exs = FALSE
          THEN
             INSERT INTO giac_recap_count
                         (rowno, rowtitle, total_losspd)
                  VALUES (v_rowno, v_rowtitle, 1);
          END IF;

          UPDATE giac_recap_count
             SET total_losspd = NVL(total_losspd,0) + 1
           WHERE rowno = v_rowno;
       END LOOP;
       
       --rowno 28
       FOR rec IN (SELECT   line_cd, subline_cd, peril_cd, subline_type_cd
                       FROM GIAC_RECAP_LOSSPD_EXT b
                      WHERE b.subline_cd != v_subline_lto
                        AND b.line_cd = 'MC'
                        AND b.peril_cd != giisp.n ('CTPL')
                   GROUP BY b.line_cd, b.subline_cd, b.iss_cd,
                            b.issue_yy, b.pol_seq_no, b.renew_no,
                            b.peril_cd, b.subline_type_cd)
       LOOP
          v_recap_line_cd := NULL;
          
          SELECT recap_line_cd
            INTO v_recap_line_cd
            FROM giis_subline
           WHERE line_cd = 'MC' 
             AND subline_cd = rec.subline_cd;

          IF v_recap_line_cd IS NULL
          THEN
             raise_application_error (-20130,'No set-up for recap_line_cd in giis_subline.');
          ELSIF v_recap_line_cd = 'PC'
          THEN
             v_rowno := 28.1;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_line_cd = 'CV'
          THEN
             v_rowno := 28.2;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_line_cd = 'MC'
          THEN
             v_rowno := 28.3;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          END IF;

          v_exs := FALSE;

          FOR exs IN (SELECT DISTINCT 'X'
                                 FROM giac_recap_count
                                WHERE rowno = v_rowno)
          LOOP
             v_exs := TRUE;
          END LOOP;

          IF v_exs = FALSE
          THEN
             INSERT INTO giac_recap_count
                         (rowno, rowtitle, total_losspd)
                  VALUES (v_rowno, v_rowtitle, 1);
          END IF;

          UPDATE giac_recap_count
             SET total_losspd = NVL(total_losspd,0) + 1
           WHERE rowno = v_rowno;
       END LOOP;
    END;
    
    --count for rowno 23 RECAP V - LOSSES AND CLAIMS --mikel 05.04.2013
    PROCEDURE count_rowno23_28_v
    IS
       v_recap_subline_type   giis_mc_subline_type.recap_subline_type%TYPE;
       v_subline_lto          giis_subline.subline_cd%TYPE := giisp.v ('MC_SUBLINE_LTO');
       v_rowno                giac_recap_summ_ext.rowno%TYPE;
       v_rowtitle             giac_recap_summ_ext.rowtitle%TYPE;
       v_exs                  BOOLEAN                                    := FALSE;
       v_recap_line_cd        giis_subline.recap_line_cd%TYPE;  
    BEGIN
       --rowno 23
       FOR rec IN (SELECT   line_cd, subline_cd, peril_cd, subline_type_cd
                       FROM GIAC_RECAP_OSLOSS_EXT b
                      WHERE b.subline_cd = v_subline_lto
                        AND b.line_cd = 'MC'
                        AND b.peril_cd != giisp.n ('CTPL')
                   GROUP BY b.line_cd, b.subline_cd, b.iss_cd,
                            b.issue_yy, b.pol_seq_no, b.renew_no,
                            b.peril_cd, b.subline_type_cd)
       LOOP
          v_recap_subline_type := NULL;
            
          SELECT recap_subline_type
            INTO v_recap_subline_type
            FROM giis_mc_subline_type
           WHERE subline_cd = v_subline_lto
             AND subline_type_cd = rec.subline_type_cd;

          IF v_recap_subline_type IS NULL
          THEN
             raise_application_error (-20130,'No set-up for recap_subline_type in giis_mc_subline_type.');
          ELSIF v_recap_subline_type = '1'
          THEN
             v_rowno := 23.1;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '2'
          THEN
             v_rowno := 23.2;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '3'
          THEN
             v_rowno := 23.3;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_subline_type = '4'
          THEN
             v_rowno := 23.4;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          END IF;

          v_exs := FALSE;

          FOR exs IN (SELECT DISTINCT 'X'
                                 FROM giac_recap_count
                                WHERE rowno = v_rowno)
          LOOP
             v_exs := TRUE;
          END LOOP;

          IF v_exs = FALSE
          THEN
             INSERT INTO giac_recap_count
                         (rowno, rowtitle, total_osloss)
                  VALUES (v_rowno, v_rowtitle, 1);
          END IF;

          UPDATE giac_recap_count
             SET total_osloss = NVL(total_osloss,0) + 1
           WHERE rowno = v_rowno;
       END LOOP;
       
       --rowno 28
       FOR rec IN (SELECT   line_cd, subline_cd, peril_cd, subline_type_cd
                       FROM GIAC_RECAP_OSLOSS_EXT b
                      WHERE b.subline_cd != v_subline_lto
                        AND b.line_cd = 'MC'
                        AND b.peril_cd != giisp.n ('CTPL')
                   GROUP BY b.line_cd, b.subline_cd, b.iss_cd,
                            b.issue_yy, b.pol_seq_no, b.renew_no,
                            b.peril_cd, b.subline_type_cd)
       LOOP
          v_recap_line_cd := NULL;
          
          SELECT recap_line_cd
            INTO v_recap_line_cd
            FROM giis_subline
           WHERE line_cd = 'MC' 
             AND subline_cd = rec.subline_cd;

          IF v_recap_line_cd IS NULL
          THEN
             raise_application_error (-20130,'No set-up for recap_line_cd in giis_subline.');
          ELSIF v_recap_line_cd = 'PC'
          THEN
             v_rowno := 28.1;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_line_cd = 'CV'
          THEN
             v_rowno := 28.2;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          ELSIF v_recap_line_cd = 'MC'
          THEN
             v_rowno := 28.3;
             v_rowtitle := get_mc_rowtitle (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
             v_rowno := get_mc_rowno (rec.line_cd, v_rowno, v_rowtitle, rec.peril_cd);
          END IF;

          v_exs := FALSE;

          FOR exs IN (SELECT DISTINCT 'X'
                                 FROM giac_recap_count
                                WHERE rowno = v_rowno)
          LOOP
             v_exs := TRUE;
          END LOOP;

          IF v_exs = FALSE
          THEN
             INSERT INTO giac_recap_count
                         (rowno, rowtitle, total_osloss)
                  VALUES (v_rowno, v_rowtitle, 1);
          END IF;

          UPDATE giac_recap_count
             SET total_osloss = NVL(total_osloss,0) + 1
           WHERE rowno = v_rowno;
       END LOOP;
    END;
    -- EndOfDeclaration -- mikel 04.25.2013
    
   
BEGIN
  EXECUTE IMMEDIATE 'TRUNCATE TABLE GIAC_RECAP_COUNT';

  v_subline_lto := Giisp.v('MC_SUBLINE_LTO');
  
  --mikel 04.29.2013
  --Get the paramet line_cd's
  v_line_fi  := giisp.v('LINE_CODE_FI');
  v_line_mn  := giisp.v('LINE_CODE_MN');
  v_line_mh  := giisp.v('LINE_CODE_MH');
  v_line_av  := giisp.v('LINE_CODE_AV');
  v_line_su  := giisp.v('LINE_CODE_SU');
  v_line_mc  := giisp.v('LINE_CODE_MC');
  v_line_ac  := giisp.v('LINE_CODE_AC');
  v_line_en  := giisp.v('LINE_CODE_EN');
  v_line_mc  := giisp.v('LINE_CODE_MC');
  
  --row 23 and 28
  count_rowno23_28_i; --mikel 04.25.2013
  
  --row 23 and 28
  count_rowno23_28_ii; --mikel 04.26.2013
  
  --row 23 and 28
  count_rowno23_28_v; --mikel 05.04.2013

  SELECT rowno,
         rowtitle,
         line_cd,
         tariff_cd,
         NULL,
         NULL,
         NULL
    BULK COLLECT INTO
         vv_rowno,
         vv_rowtitle,
         vv_line_cd,
         vv_tariff_cd,
         vv_total,
         vv_total_losspd,
         vv_total_osloss
    FROM GIAC_RECAP_ROW
   ORDER BY rowno;


  -- row 1 to 4
  FOR i IN 1..4
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total(i)
      FROM GIAC_RECAP_DTL_EXT c
     WHERE 1=1
       AND c.line_cd               = vv_line_cd(i)
       AND SUBSTR(c.tariff_cd,1,1) = vv_tariff_cd(i)
       AND c.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL d
                   WHERE d.rowno    = vv_rowno(i)
                     AND d.peril_cd = c.peril_cd
                     AND d.line_cd  = c.line_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no
    HAVING SUM(DECODE(c.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;

  END LOOP;

  -- row 5-7
  FOR i IN 5..7
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total(i)
      FROM GIAC_RECAP_DTL_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
       AND c.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL d
                   WHERE d.rowno    = vv_rowno(i)
                     AND d.peril_cd = c.peril_cd
                     AND d.line_cd  = c.line_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no
    HAVING SUM(DECODE(c.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;
  END LOOP;

  -- row 8
  BEGIN
    SELECT COUNT(COUNT(*))
      INTO vv_total(8)
      FROM GIAC_RECAP_DTL_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(8)
       AND c.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       AND NOT EXISTS(SELECT 'X'
                        FROM GIAC_RECAP_ROW_DTL b
                       WHERE b.rowno <= 7
                         AND b.peril_cd = c.peril_cd
                         AND b.line_cd  = c.line_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no
    HAVING SUM(DECODE(c.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;
  END;

  FOR i IN 9..11
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total(i)
      FROM GIAC_RECAP_DTL_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
       AND c.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no
    HAVING SUM(DECODE(c.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;

  END LOOP;

  FOR i IN 12..16
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total(i)
      FROM GIAC_RECAP_DTL_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
       AND c.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL d
                   WHERE d.rowno         = vv_rowno(i)
                     AND d.bond_class_no = c.bond_class_subline)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no
    HAVING SUM(DECODE(c.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;
  END LOOP;

  -- row 29 -- AC
  --FOR i IN 28..29
  FOR i IN 31..32 --mikel 04.29.2013; for rowno 29 and 30
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total(i)
      FROM GIAC_RECAP_DTL_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
       AND c.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no
    HAVING SUM(DECODE(c.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;
  END LOOP;

  -- ROW 17 - 20
  FOR i IN 17..20
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total(i)
      FROM GIAC_RECAP_DTL_EXT a
     WHERE 1=1
       AND a.line_cd = vv_line_cd(i)
       AND a.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL b
                   WHERE b.rowno           = vv_rowno(i)
                     AND b.peril_cd        = a.peril_cd
                     AND b.subline_cd      = a.subline_cd
                     AND b.subline_type_cd = a.subline_type_cd )
     GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no
    HAVING SUM(DECODE(a.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;
  END LOOP;

  v_max_rowno := 21;
  
  --row 21 (total count of CTPL non-LTO), added by albert 12042013
  BEGIN
    SELECT COUNT(COUNT(*))
      INTO vv_total(v_max_rowno)
      FROM giac_recap_dtl_ext a
     WHERE 1=1
       AND a.line_cd = vv_line_cd(v_max_rowno)
       AND a.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       AND EXISTS(SELECT 'X'
                    FROM giac_recap_row_dtl b
                   WHERE b.rowno = vv_rowno(v_max_rowno)
                     AND b.peril_cd = a.peril_cd
                     AND b.subline_cd = a.subline_cd)
  GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no
  HAVING SUM(DECODE(a.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;
  END;

/*--  FOR sub IN (SELECT f.subline_cd subline_cd, NVL(g.total,0) total --mikel 04.26.2013; added ' '|| for indention
--                FROM (SELECT d.subline_cd
--                        FROM GIIS_SUBLINE d
--                       WHERE d.line_cd     = vv_line_cd(21)
--                         AND d.subline_cd <> v_subline_lto) f,
--                     (SELECT c.subline_cd, COUNT(*) total
--                        FROM (SELECT b.subline_cd
--                                FROM GIAC_RECAP_DTL_EXT b,
--                                     GIIS_SUBLINE       a
--                               WHERE 1=1
--                                 AND a.subline_cd  = b.subline_cd
--                                 AND a.line_cd     = a.line_cd
--                                 AND a.subline_cd <> v_subline_lto
--                                 AND a.line_cd     = vv_line_cd(21)
--                                 AND EXISTS ( SELECT 'X' --added by mikel 04.17.2013; to select CTPL NON-LTO only
--                                                FROM giac_recap_row_dtl c
--                                               WHERE c.rowno = 21
--                                                 AND c.peril_cd = b.peril_cd)
--                              GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
--                              HAVING SUM(DECODE(b.date_tag,'A',1,'C',-10000,'S',0,0)) > 0) c
--                       GROUP BY c.subline_cd) g
--               WHERE f.subline_cd = g.subline_cd (+)
--               ORDER BY 1)--order by added by ramon 04/27/2010
--  LOOP
--    v_max_rowno := v_max_rowno + 0.01;
--    INSERT INTO GIAC_RECAP_COUNT
--      (rowno,       rowtitle, total)
--    VALUES
--      (v_max_rowno, sub.subline_cd, sub.total);
--  END LOOP;*/ --commented out count breakdown of CTPL non-LTO per subline, albert 12042013

  /*-- row 23
  SELECT COUNT(COUNT(*))
    INTO vv_total(22)
    FROM GIAC_RECAP_DTL_EXT b
   WHERE 1=1
     AND b.subline_cd  = v_subline_lto
     AND b.line_cd     = vv_line_cd(22)
     AND NOT EXISTS(SELECT 'X'
                      FROM GIAC_RECAP_ROW_DTL a
                     WHERE rowno BETWEEN 17 AND 20
                       AND a.peril_cd =  b.peril_cd)
  GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
  HAVING SUM(DECODE(b.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;*/ --comment out by mikel 04.25.2013

  -- row 24-27
  FOR i IN 24..27
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total(i-1)
      FROM GIAC_RECAP_DTL_EXT b
     WHERE 1=1
       AND b.subline_cd  <> v_subline_lto
       AND b.line_cd     = vv_line_cd(i-1)
       AND b.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL a
                   WHERE rowno = vv_rowno(i-1)
                     AND a.peril_cd =  b.peril_cd)
     GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
    HAVING SUM(DECODE(b.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;
  END LOOP;

  /*-- row 28
  SELECT COUNT(COUNT(*))
    INTO vv_total(27)
    FROM GIAC_RECAP_DTL_EXT b
   WHERE 1=1
     AND b.subline_cd  <> v_subline_lto
     AND b.line_cd     = vv_line_cd(27)
     AND NOT EXISTS(SELECT 'X'
                      FROM GIAC_RECAP_ROW_DTL a
                     WHERE rowno BETWEEN 24 AND 27
                       AND a.peril_cd =  b.peril_cd)
    AND NOT EXISTS (SELECT 'X' --added by mikel 04.17.2013; to exlcude CTPL
                      FROM giac_recap_row_dtl c
                     WHERE c.rowno = 21 
                       AND c.peril_cd = b.peril_cd)                       
   GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no
  HAVING SUM(DECODE(b.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;*/ --comment out by mikel 04.25.2013

  v_max_rowno := 0;

  SELECT MAX(rowno)
    INTO v_max_rowno
    FROM GIAC_RECAP_ROW;

  IF v_max_rowno IS NULL THEN
     RAISE_APPLICATION_ERROR(-20099,'NO RECORDS IN GIAC_RECAP_ROW.');
  END IF;

  FOR i IN (SELECT 1, line_cd, subline_cd, ROWNUM -- mildred 04.15.2013
             FROM (SELECT 1, a.line_cd, a.subline_cd
              FROM GIIS_SUBLINE a,
                   GIIS_LINE b                    -- albert 08162013
             WHERE a.line_cd = b.line_cd
                   /*NOT EXISTS(SELECT 'X'
                                FROM GIAC_RECAP_ROW b
                               WHERE b.line_cd = a.line_cd)*/--ramon 04/27/2010
                   --a.subline_cd IN (SELECT rowtitle FROM giac_recap_summary_v
               AND a.subline_cd IN (SELECT subline_cd rowtitle FROM giac_recap_dtl_ext x -- albert 08162013 
                                     WHERE x.line_cd = b.line_cd
                                    MINUS
                                    SELECT rowtitle FROM GIAC_RECAP_ROW)
               --AND a.line_cd NOT IN (Giisp.v('LINE_CODE_MC'),Giisp.v('LINE_CODE_SU'))
               AND b.line_cd NOT IN (v_line_fi, v_line_mn, v_line_mh, v_line_av,
                                     v_line_su, v_line_mc, v_line_ac, v_line_en) --albert 08162013
             UNION
            SELECT 2, line_cd, rowtitle FROM GIAC_RECAP_OTHER_ROWS
             WHERE line_cd IN (Giisp.v('LINE_CODE_SU'))
          ORDER BY 2,3)) -- changed order by from 1, 4 to 2,3 mildred 04.15.2013
  LOOP
    BEGIN
      SELECT COUNT(COUNT(*))
        INTO v_total_cnt
        FROM GIAC_RECAP_DTL_EXT a
       WHERE a.line_cd    = i.line_cd
         AND a.subline_cd = i.subline_cd
         AND a.premium_amt IS NOT NULL                        --nieko 03252014 include only policies with premium amount
       GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                a.pol_seq_no, a.renew_no
      HAVING SUM(DECODE(a.date_tag,'A',1,'C',-10000,'S',0,0)) > 0;  --albert 04102014
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_total_cnt := 0;
    END;

    INSERT INTO GIAC_RECAP_COUNT
      (rowno,                  rowtitle,     total)
    VALUES
      (i.ROWNUM + v_max_rowno, i.subline_cd, v_total_cnt);

  END LOOP;

/***************************************************************************************
* LOSSES_PD count
****************************************************************************************/

  -- row 1 to 4
  FOR i IN 1..4
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(i)
      FROM GIAC_RECAP_LOSSPD_EXT c
     WHERE 1=1
       AND c.line_cd               = vv_line_cd(i)
       AND SUBSTR(c.tariff_cd,1,1) = vv_tariff_cd(i)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL d
                   WHERE d.rowno    = vv_rowno(1)
                     AND d.peril_cd = c.peril_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

  -- row 5-7
  FOR i IN 5..7
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(i)
      FROM GIAC_RECAP_LOSSPD_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL d
                   WHERE d.rowno    = vv_rowno(1)
                     AND d.peril_cd = c.peril_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

  -- row 8
  BEGIN
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(8)
      FROM GIAC_RECAP_LOSSPD_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(8)
       AND NOT EXISTS(SELECT 'X'
                        FROM GIAC_RECAP_ROW_DTL b
                       WHERE b.rowno <= 7
                         AND b.peril_cd = c.peril_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END;

  -- row 9-11
  FOR i IN 9..11
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(i)
      FROM GIAC_RECAP_LOSSPD_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

   -- row 12-16
   FOR i IN 12..16
   LOOP
     SELECT COUNT(COUNT(*))
       INTO vv_total_losspd(i)
       FROM giac_recap_losspd_ext c
      WHERE 1=1
        AND c.line_cd = vv_line_cd(i)
        AND EXISTS(SELECT 'x'
                     FROM giac_recap_row_dtl d
                    WHERE d.rowno         = vv_rowno(i)
--                      AND d.bond_class_no = c.bond_class_subline)
                  )
      GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
   END LOOP;

  -- row 29 -- AC
  --FOR i IN 28..29
  FOR i IN 31..32 --mikel 04.29.2013; for rowno 29 and 30
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(i)
      FROM GIAC_RECAP_LOSSPD_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

  -- ROW 17 - 20
  FOR i IN 17..20
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(i)
      FROM GIAC_RECAP_LOSSPD_EXT a
     WHERE 1=1
       AND a.line_cd = vv_line_cd(i)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL b
                   WHERE b.rowno           = vv_rowno(i)
                     AND b.peril_cd        = a.peril_cd
                     AND b.subline_cd      = a.subline_cd
                     AND b.subline_type_cd = a.subline_type_cd )
     GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no;
  END LOOP;

  v_max_rowno := 21;

  --row 21 (total count of CTPL non-LTO), added by albert 12042013
  BEGIN
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(v_max_rowno)
      FROM giac_recap_losspd_ext a
     WHERE 1=1
       AND a.line_cd = vv_line_cd(v_max_rowno)
       AND EXISTS(SELECT 'X'
                    FROM giac_recap_row_dtl b
                   WHERE b.rowno = vv_rowno(v_max_rowno)
                     AND b.peril_cd = a.peril_cd
                     AND b.subline_cd = a.subline_cd)
  GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no;
  END;
  
  
/*--  FOR sub IN (SELECT f.subline_cd, NVL(g.total,0) total
--                FROM (SELECT d.subline_cd
--                        FROM GIIS_SUBLINE d
--                       WHERE d.line_cd     = vv_line_cd(21)
--                         AND d.subline_cd <> v_subline_lto) f,
--                     (SELECT c.subline_cd, COUNT(*) total
--                        FROM (SELECT b.subline_cd
--                                FROM GIAC_RECAP_LOSSPD_EXT b,
--                                     GIIS_SUBLINE       a
--                               WHERE 1=1
--                                 AND a.subline_cd  = b.subline_cd
--                                 AND a.line_cd     = a.line_cd
--                                 AND a.subline_cd <> v_subline_lto
--                                 AND a.line_cd     = vv_line_cd(21)
--                              GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no) c
--                       GROUP BY c.subline_cd) g
--               WHERE f.subline_cd = g.subline_cd (+)
--               ORDER BY 1)--order by added by ramon 04/27/2010
--  LOOP
--    UPDATE GIAC_RECAP_COUNT
--       SET total_losspd = sub.total
--     WHERE rowtitle     = sub.subline_cd;
--  END LOOP;*/  --commented out count breakdown of CTPL non-LTO per subline, albert 12042013 

  /*-- row 23
  SELECT COUNT(COUNT(*))
    INTO vv_total_losspd(22)
    FROM GIAC_RECAP_LOSSPD_EXT b
   WHERE 1=1
     AND b.subline_cd  = v_subline_lto
     AND b.line_cd     = vv_line_cd(22)
     AND NOT EXISTS(SELECT 'X'
                      FROM GIAC_RECAP_ROW_DTL a
                     WHERE rowno BETWEEN 17 AND 20
                       AND a.peril_cd =  b.peril_cd)
  GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no;*/ --comment out by mikel 04.26.2013

  -- row 24-27
  FOR i IN 24..27
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_losspd(i-1)
      FROM GIAC_RECAP_LOSSPD_EXT b
     WHERE 1=1
       AND b.subline_cd  <> v_subline_lto
       AND b.line_cd      = vv_line_cd(i-1)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL a
                   WHERE rowno = vv_rowno(i-1)
                     AND a.peril_cd =  b.peril_cd)
     GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no;
  END LOOP;

  /*-- row 28
  SELECT COUNT(COUNT(*))
    INTO vv_total_losspd(27)
    FROM GIAC_RECAP_LOSSPD_EXT b
   WHERE 1=1
     AND b.subline_cd  <> v_subline_lto
     AND b.line_cd      = vv_line_cd(27)
     AND NOT EXISTS(SELECT 'X'
                      FROM GIAC_RECAP_ROW_DTL a
                     WHERE rowno BETWEEN 24 AND 27
                       AND a.peril_cd =  b.peril_cd)
   GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no;*/ --comment out by mikel 04.26.2013
  
  FOR i IN
      (SELECT 1, line_cd, subline_cd, ROWNUM   -- mikel 04.29.2013
         FROM (SELECT   1, a.line_cd, a.subline_cd, ROWNUM
                   FROM giis_subline a,
                        giis_line b                 --albert 10032013     
                  WHERE 1 = 1
                  /*NOT EXISTS(SELECT 'X'
                               FROM GIAC_RECAP_ROW b
                              WHERE b.line_cd = a.line_cd)*/--ramon 04/27/2010
                        /*a.subline_cd IN (
                                 SELECT rowtitle
                                   FROM giac_recap_summary_v
                                 MINUS
                                 SELECT rowtitle
                                   FROM giac_recap_row)
                    AND a.line_cd NOT IN (giisp.v ('LINE_CODE_MC'), giisp.v ('LINE_CODE_SU'))*/ --comment out by mikel 04.29.2013
                    --mikel 04.29.2013; select other rows
                    AND a.line_cd NOT IN(v_line_fi, v_line_mn, v_line_mh, v_line_av,
                                         v_line_su, v_line_mc, v_line_ac, v_line_en)
                    AND a.line_cd = b.line_cd                               --albert 10032013
                    AND a.subline_cd IN (SELECT subline_cd rowtitle         
                                           FROM giac_recap_losspd_ext x             
                                          WHERE x.line_cd = b.line_cd
                                         MINUS
                                         SELECT rowtitle
                                           FROM giac_recap_row)
               UNION
               SELECT   2, line_cd, rowtitle, ROWNUM
                   FROM giac_recap_other_rows
                  WHERE line_cd IN (giisp.v ('LINE_CODE_SU'))
               ORDER BY 2,3)) --mikel 04.29.2013; changed order by from 1, 4 to 2,3 
  LOOP
    v_total_cnt := 0;
    BEGIN
      SELECT COUNT(COUNT(*))
        INTO v_total_cnt
        FROM GIAC_RECAP_LOSSPD_EXT a
       WHERE a.line_cd    = i.line_cd
         AND a.subline_cd = i.subline_cd
       GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                a.pol_seq_no, a.renew_no;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_total_cnt := 0;
    END;

    UPDATE GIAC_RECAP_COUNT
       SET total_losspd = v_total_cnt
     WHERE rowtitle = i.subline_cd;
     
    --mikel 05.07.2013; 
    IF SQL%NOTFOUND THEN
        BEGIN
        SELECT DISTINCT rowno
        --SELECT MAX(rowno)
          INTO v_max_rowno
          FROM giac_recap_losspd_summ_ext
         WHERE line_cd = i.line_cd
           AND rowtitle = i.subline_cd;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_max_rowno := NULL;
        END;       
        
        IF v_max_rowno IS NOT NULL THEN     
            INSERT INTO GIAC_RECAP_COUNT
            --    (rowno, rowtitle, total_osloss)
                (rowno, rowtitle, total_losspd)
            VALUES
                (v_max_rowno, i.subline_cd, v_total_cnt);
        END IF;        
    END IF; 

    
  END LOOP;

/***************************************************************************************
* OSLOSSES count
****************************************************************************************/

  -- row 1 to 4
  FOR i IN 1..4
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(i)
      FROM GIAC_RECAP_OSLOSS_EXT c
     WHERE 1=1
       AND c.line_cd               = vv_line_cd(i)
       AND SUBSTR(c.tariff_cd,1,1) = vv_tariff_cd(i)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL d
                   WHERE d.rowno    = vv_rowno(1)
                     AND d.peril_cd = c.peril_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

  -- row 5-7
  FOR i IN 5..7
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(i)
      FROM GIAC_RECAP_OSLOSS_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL d
                   WHERE d.rowno    = vv_rowno(1)
                     AND d.peril_cd = c.peril_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

  -- row 8
  BEGIN
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(8)
      FROM GIAC_RECAP_OSLOSS_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(8)
       AND NOT EXISTS(SELECT 'X'
                        FROM GIAC_RECAP_ROW_DTL b
                       WHERE b.rowno <= 7
                         AND b.peril_cd = c.peril_cd)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END;

  -- row 9-11
  FOR i IN 9..11
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(i)
      FROM GIAC_RECAP_OSLOSS_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

   -- row 12-16
   FOR i IN 12..16
   LOOP
     SELECT COUNT(COUNT(*))
       INTO vv_total_osloss(i)
       FROM giac_recap_osloss_ext c
      WHERE 1=1
        AND c.line_cd = vv_line_cd(i)
        AND EXISTS(SELECT 'x'
                     FROM giac_recap_row_dtl d
                    WHERE d.rowno         = vv_rowno(i)
--                      AND d.bond_class_no = c.bond_class_subline)
                  )
      GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
   END LOOP;

  -- row 29 -- AC
  --FOR i IN 28..29
  FOR i IN 31..32 --mikel 04.29.2013; for rowno 29 and 30
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(i)
      FROM GIAC_RECAP_OSLOSS_EXT c
     WHERE 1=1
       AND c.line_cd = vv_line_cd(i)
     GROUP BY c.line_cd, c.subline_cd, c.iss_cd, c.issue_yy, c.pol_seq_no, c.renew_no;
  END LOOP;

  -- ROW 17 - 20
  FOR i IN 17..20
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(i)
      FROM GIAC_RECAP_OSLOSS_EXT a
     WHERE 1=1
       AND a.line_cd = vv_line_cd(i)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL b
                   WHERE b.rowno           = vv_rowno(i)
                     AND b.peril_cd        = a.peril_cd
                     AND b.subline_cd      = a.subline_cd
                     AND b.subline_type_cd = a.subline_type_cd )
     GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no;
  END LOOP;

  v_max_rowno := 21;
  
  --row 21 (total count of CTPL non-LTO), added by albert 12042013
  BEGIN
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(v_max_rowno)
      FROM giac_recap_osloss_ext a
     WHERE 1=1
       AND a.line_cd = vv_line_cd(v_max_rowno)
       AND EXISTS(SELECT 'X'
                    FROM giac_recap_row_dtl b
                   WHERE b.rowno = vv_rowno(v_max_rowno)
                     AND b.peril_cd = a.peril_cd
                     AND b.subline_cd = a.subline_cd)
  GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no;
  END;

/*--  FOR sub IN (SELECT f.subline_cd, NVL(g.total,0) total
--                FROM (SELECT d.subline_cd
--                        FROM GIIS_SUBLINE d
--                       WHERE d.line_cd     = vv_line_cd(21)
--                         AND d.subline_cd <> v_subline_lto) f,
--                     (SELECT c.subline_cd, COUNT(*) total
--                        FROM (SELECT b.subline_cd
--                                FROM GIAC_RECAP_OSLOSS_EXT b,
--                                     GIIS_SUBLINE       a
--                               WHERE 1=1
--                                 AND a.subline_cd  = b.subline_cd
--                                 AND a.line_cd     = a.line_cd
--                                 AND a.subline_cd <> v_subline_lto
--                                 AND a.line_cd     = vv_line_cd(21)
--                              GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no) c
--                       GROUP BY c.subline_cd) g
--               WHERE f.subline_cd = g.subline_cd (+)
--               ORDER BY 1)--order by added by ramon 04/27/2010
--  LOOP
--    UPDATE GIAC_RECAP_COUNT
--       SET total_osloss = sub.total
--     WHERE rowtitle     = sub.subline_cd;
--  END LOOP;*/    --commented out count breakdown of CTPL non-LTO per subline, albert 12042013

  -- row 23

  SELECT COUNT(COUNT(*))
    INTO vv_total_osloss(22)
    FROM GIAC_RECAP_OSLOSS_EXT b
   WHERE 1=1
     AND b.subline_cd  = v_subline_lto
     AND b.line_cd     = vv_line_cd(22)
     AND NOT EXISTS(SELECT 'X'
                      FROM GIAC_RECAP_ROW_DTL a
                     WHERE rowno BETWEEN 17 AND 20
                       AND a.peril_cd =  b.peril_cd)
  GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no;

  -- row 24-27
  FOR i IN 24..27
  LOOP
    SELECT COUNT(COUNT(*))
      INTO vv_total_osloss(i-1)
      FROM GIAC_RECAP_OSLOSS_EXT b
     WHERE 1=1
       AND b.subline_cd  <> v_subline_lto
       AND b.line_cd      = vv_line_cd(i-1)
       AND EXISTS(SELECT 'X'
                    FROM GIAC_RECAP_ROW_DTL a
                   WHERE rowno = vv_rowno(i-1)
                     AND a.peril_cd =  b.peril_cd)
     GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no;
  END LOOP;

  -- row 28
  /*SELECT COUNT(COUNT(*))
    INTO vv_total_osloss(27)
    FROM GIAC_RECAP_OSLOSS_EXT b
   WHERE 1=1
     AND b.subline_cd  <> v_subline_lto
     AND b.line_cd      = vv_line_cd(27)
     AND NOT EXISTS(SELECT 'X'
                      FROM GIAC_RECAP_ROW_DTL a
                     WHERE rowno BETWEEN 24 AND 27
                       AND a.peril_cd =  b.peril_cd)
   GROUP BY b.line_cd, b.subline_cd, b.iss_cd, b.issue_yy, b.pol_seq_no, b.renew_no;*/--comment out by albert 03032014

  FOR i IN
      (SELECT 1, line_cd, subline_cd, ROWNUM              -- mikel 04.29.2013
         FROM (SELECT   1, a.line_cd, a.subline_cd, ROWNUM
                   FROM giis_subline a,
                        giis_line b                     --albert 03032014
                  WHERE 1 = 1
                  /*NOT EXISTS(SELECT 'X'
                               FROM GIAC_RECAP_ROW b
                              WHERE b.line_cd = a.line_cd)*/ --ramon 04/27/2010
                        /*a.subline_cd IN (
                                 SELECT rowtitle
                                   FROM giac_recap_summary_v
                                 MINUS
                                 SELECT rowtitle
                                   FROM giac_recap_row)
                    AND a.line_cd NOT IN (giisp.v ('LINE_CODE_MC'), giisp.v ('LINE_CODE_SU'))*/ --comment out by mikel 05.04.2013
                    --mikel 05.04.2013; select other rows
                    AND a.line_cd NOT IN(v_line_fi, v_line_mn, v_line_mh, v_line_av,
                                         v_line_su, v_line_mc, v_line_ac, v_line_en)
                    --added by albert 03032014
                    AND a.line_cd = b.line_cd
                    AND a.subline_cd IN (SELECT subline_cd rowtitle
                                           FROM giac_recap_osloss_ext x
                                          WHERE x.line_cd = b.line_cd
                                         MINUS
                                         SELECT rowtitle
                                           FROM giac_recap_row)
                    --end albert 03032014                     
               UNION
               SELECT   2, line_cd, rowtitle, ROWNUM
                   FROM giac_recap_other_rows
                  WHERE line_cd IN (giisp.v ('LINE_CODE_SU'))
               ORDER BY 2,3)) --mikel 04.29.2013; changed order by from 1, 4 to 2,3
               
  LOOP
    v_total_cnt := 0;
    BEGIN
      SELECT COUNT(COUNT(*))
        INTO v_total_cnt
        FROM GIAC_RECAP_OSLOSS_EXT a
       WHERE a.line_cd    = i.line_cd
         AND a.subline_cd = i.subline_cd
       GROUP BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                a.pol_seq_no, a.renew_no;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_total_cnt := 0;
    END;

    UPDATE GIAC_RECAP_COUNT
       SET total_osloss = v_total_cnt
     WHERE rowtitle = i.subline_cd;
    
    --mikel 05.07.2013; 
    IF SQL%NOTFOUND THEN
        BEGIN
        /*insert into mikel (line_cd, subline_cd)
        values
        (i.line_cd, i.subline_cd);*/        
        SELECT DISTINCT rowno
          INTO v_max_rowno
          FROM giac_recap_osloss_summ_ext
         WHERE line_cd = i.line_cd
           AND rowtitle = i.subline_cd;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_max_rowno := NULL;
        END;       
        
        IF v_max_rowno IS NOT NULL THEN   
        /*insert into mikel
        values
        (i.line_cd, i.subline_cd);*/  
            INSERT INTO GIAC_RECAP_COUNT
                (rowno, rowtitle, total_osloss)
            VALUES
                (v_max_rowno, i.subline_cd, v_total_cnt);
        END IF;        
    END IF;
      
  END LOOP;


/***************************************************************************************/
  FORALL i IN vv_rowno.FIRST..vv_rowno.LAST
    INSERT INTO GIAC_RECAP_COUNT
      (rowno,       rowtitle,       total,       total_losspd,       total_osloss)
    VALUES
      (vv_rowno(i), vv_rowtitle(i), vv_total(i), vv_total_losspd(i), vv_total_osloss(i));

  COMMIT;
END;
/


