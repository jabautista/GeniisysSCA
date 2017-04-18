CREATE OR REPLACE PACKAGE BODY CPI.giris055_pkg
AS
   /*  Created by : J. Diago
   **  Date Created : 10.02.2013
   **  Description : Package used by GIRIS055 (View Binder Status) Module
   */
   FUNCTION get_giris055_dtls (
      p_user_id         giis_users.user_id%TYPE,
      p_line_cd         giri_binder.line_cd%TYPE,
      p_binder_yy       giri_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_binder.binder_seq_no%TYPE,
      p_binder_date     VARCHAR2,
      p_reverse_date    VARCHAR2,
      --added SR5800 11.8.2016 optimized by MarkS  
      p_order_by             VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from                 NUMBER,
      p_to                   NUMBER,
      p_dsp_ri_name     VARCHAR2,
      p_dsp_status      VARCHAR2
      --SR5800 11.8.2016 optimized by MarkS  
   )
      RETURN giris055_dtls_tab PIPELINED
   IS
      v_rec       giris055_dtls_type;
      v_exist     VARCHAR2 (1)                 := 'N';
      v_ri_flag   giri_distfrps.ri_flag%TYPE;
      v_reverse_date giri_binder.reverse_date%TYPE;
      v_binder_date giri_binder.binder_date%TYPE;
      --SR5800 11.8.2016 optimized by MarkS  
      TYPE cur_type IS REF CURSOR;
      c        cur_type;
      v_sql   VARCHAR2(32767);
      --SR5800 11.8.2016 optimized by MarkS
   BEGIN
   --SR5800 11.8.2016 optimized by MarkS  
    v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM ( SELECT line_cd, binder_yy, binder_seq_no,
                                                          line_cd
                                                       || ''-''
                                                       || LTRIM (TO_CHAR (binder_yy, ''09''))
                                                       || ''-''
                                                       || LTRIM (TO_CHAR (binder_seq_no, ''09999'')) binder_no,
                                                       (SELECT ri_name FROM giis_reinsurer WHERE ri_cd  = gb.ri_cd) ri_name, 
                                                       fnl_binder_id, (TO_CHAR (binder_date, ''MM-DD-RRRR'')) binder_date, 
                                                       (TO_CHAR (reverse_date, ''MM-DD-RRRR'')) reverse_date,
                                                       DECODE((TO_CHAR (reverse_date, ''MM-DD-RRRR'')),NULL,(SELECT rv_meaning
                                                                                                 FROM cg_ref_codes
                                                                                                WHERE rv_domain = ''GIRI_DISTFRPS.RI_FLAG''
                                                                                                  AND rv_low_value = ''2''),
                                                                                (SELECT rv_meaning
                                                                                                 FROM cg_ref_codes
                                                                                                WHERE rv_domain = ''GIRI_DISTFRPS.RI_FLAG''
                                                                                                  AND rv_low_value = ''3'')) dsp_status
                                                  FROM giri_binder gb
                                                 WHERE 1 = 1
                                                   AND UPPER (line_cd) = NVL (UPPER ( '''|| p_line_cd ||'''), line_cd)
                                                   AND binder_yy = NVL (:p_binder_yy, binder_yy)
                                                   AND binder_seq_no = NVL (:p_binder_seq_no, binder_seq_no)
                                                   AND TRUNC (binder_date) =
                                                          NVL (TO_DATE (:p_binder_date, ''MM-DD-RRRR''),
                                                               TRUNC (binder_date)
                                                              )
                                                   AND NVL (TRUNC (reverse_date),
                                                            TO_DATE (''01-01-1900'', ''MM-DD-RRRR'')
                                                           ) =
                                                          NVL (TO_DATE (:p_reverse_date, ''MM-DD-RRRR''),
                                                               NVL (TRUNC (reverse_date),
                                                                    TO_DATE (''01-01-1900'', ''MM-DD-RRRR'')
                                                                   ))   
                                                   AND EXISTS (SELECT ''X'' FROM TABLE (security_access.get_branch_line (''UW'', ''GIRIS055'',''' || p_user_id || '''))
                                                                WHERE LINE_CD= gb.line_cd and BRANCH_CD = gb.iss_cd) ';
    IF  p_dsp_ri_name IS NOT NULL THEN
        v_sql := v_sql || 'AND UPPER((SELECT ri_name FROM giis_reinsurer WHERE ri_cd  = gb.ri_cd)) LIKE UPPER(NVL('''|| p_dsp_ri_name ||''', ''%'')) ';
    END IF;
    
    IF  p_dsp_status IS NOT NULL THEN
        v_sql := v_sql || 'AND UPPER(DECODE((TO_CHAR (reverse_date, ''MM-DD-RRRR'')),NULL,(SELECT rv_meaning
                                                                                                 FROM cg_ref_codes
                                                                                                WHERE rv_domain = ''GIRI_DISTFRPS.RI_FLAG''
                                                                                                  AND rv_low_value = ''2''),
                                                                                (SELECT rv_meaning
                                                                                                 FROM cg_ref_codes
                                                                                                WHERE rv_domain = ''GIRI_DISTFRPS.RI_FLAG''
                                                                                                  AND rv_low_value = ''3''))) LIKE UPPER(NVL('''|| p_dsp_status ||''', ''%'')) ';
    END IF;       
                                                        
    IF p_order_by IS NOT NULL
      THEN
      
        IF p_order_by = 'binderNo'
        THEN        
          v_sql := v_sql || ' ORDER BY binder_no ';
        ELSIF p_order_by = 'dspRiName'
        THEN
          v_sql := v_sql || ' ORDER BY ri_name ';
        ELSIF p_order_by = 'binderDate'
        THEN
          v_sql := v_sql || ' ORDER BY gb.binder_date ';
        ELSIF p_order_by = 'reverseDate'
        THEN
          v_sql := v_sql || ' ORDER BY reverse_date ';           
        ELSIF p_order_by = 'dspParticulars'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_particulars ';
        ELSIF p_order_by = 'dspStatus'
        THEN
          v_sql := v_sql || ' ORDER BY dsp_status ';
        END IF;
        
        IF p_asc_desc_flag IS NOT NULL
        THEN
           v_sql := v_sql || p_asc_desc_flag;
        ELSE
           v_sql := v_sql || ' ASC';
        END IF; 
    END IF;         
    v_sql := v_sql ||                                                                          ') innersql ';
    v_sql := v_sql || ' ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '|| p_from ||' AND ' || p_to; 
    OPEN c FOR v_sql using p_binder_yy,p_binder_seq_no,p_binder_date,p_reverse_date;
    LOOP
        FETCH c INTO      v_rec.count_, 
                          v_rec.rownum_, 
                          v_rec.line_cd, 
                          v_rec.binder_yy, 
                          v_rec.binder_seq_no,
                          v_rec.binder_no,
                          v_rec.dsp_ri_name, 
                          v_rec.fnl_binder_id,
                          v_rec.binder_date,
                          v_rec.reverse_date,
                          v_rec.dsp_status
                          ;                       
        EXIT WHEN c%NOTFOUND;
        FOR b IN (SELECT DISTINCT t6.assd_name assd_name,
                                   t5.line_cd line_cd,
                                   t5.subline_cd subline_cd,
                                   t5.iss_cd iss_cd, t5.issue_yy issue_yy,
                                   t5.pol_seq_no pol_seq_no,
                                   t5.renew_no renew_no,
                                   t5.endt_iss_cd endt_iss_cd,
                                   t5.endt_yy endt_yy,
                                   t5.endt_seq_no endt_seq_no,
                                   t3.ri_flag ri_flag
                              FROM giri_frps_ri t2,
                                   giri_distfrps t3,
                                   giuw_pol_dist t4,
                                   gipi_polbasic t5,
                                   giis_assured t6,
                                   gipi_parlist t7
                             WHERE t2.frps_yy = t3.frps_yy
                               AND t2.frps_seq_no = t3.frps_seq_no
                               AND t2.line_cd = t3.line_cd
                               AND t3.dist_no = t4.dist_no
                               AND t4.policy_id = t5.policy_id
                               AND t7.assd_no = t6.assd_no
                               AND t5.par_id = t7.par_id
                               AND t2.fnl_binder_id = v_rec.fnl_binder_id
                               AND t2.line_cd = v_rec.line_cd)
         LOOP
            v_rec.nbt_assd_name := b.assd_name;
            v_rec.nbt_line_cd := b.line_cd;
            v_rec.nbt_subline_cd := b.subline_cd;
            v_rec.nbt_iss_cd := b.iss_cd;
            v_rec.nbt_issue_yy := b.issue_yy;
            v_rec.nbt_pol_seq_no := b.pol_seq_no;
            v_rec.nbt_renew_no := b.renew_no;
            IF b.endt_seq_no != 0
            THEN
               v_rec.nbt_endt_iss_cd := b.endt_iss_cd;
               v_rec.nbt_endt_yy := b.endt_yy;
               v_rec.nbt_endt_seq_no := b.endt_seq_no;
            ELSE
               v_rec.nbt_endt_iss_cd := '';
               v_rec.nbt_endt_yy := '';
               v_rec.nbt_endt_seq_no := '';
            END IF;
            v_exist := 'Y';
            v_rec.dist_peril_sw := 'Y';
         END LOOP;
         IF v_exist = 'N'
         THEN
            FOR c IN (SELECT DISTINCT t6.assd_name assd_name,
                                      t5.line_cd line_cd,
                                      t5.subline_cd subline_cd,
                                      t5.iss_cd iss_cd, t5.issue_yy issue_yy,
                                      t5.pol_seq_no pol_seq_no,
                                      t5.renew_no renew_no,
                                      t5.endt_iss_cd endt_iss_cd,
                                      t5.endt_yy endt_yy,
                                      t5.endt_seq_no endt_seq_no
                                 FROM giri_endttext t1,
                                      gipi_polbasic t5,
                                      giis_assured t6,
                                      gipi_parlist t7
                                WHERE t5.policy_id = t1.policy_id
                                  AND t7.assd_no = t6.assd_no
                                  AND t5.par_id = t7.par_id
                                  AND t5.line_cd = v_rec.line_cd
                                  AND t1.fnl_binder_id = v_rec.fnl_binder_id)
            LOOP
               v_rec.nbt_assd_name := c.assd_name;
               v_rec.nbt_line_cd := c.line_cd;
               v_rec.nbt_subline_cd := c.subline_cd;
               v_rec.nbt_iss_cd := c.iss_cd;
               v_rec.nbt_issue_yy := c.issue_yy;
               v_rec.nbt_pol_seq_no := c.pol_seq_no;
               v_rec.nbt_renew_no := c.renew_no;
               v_rec.nbt_endt_iss_cd := c.endt_iss_cd;
               v_rec.nbt_endt_yy := c.endt_yy;
               v_rec.nbt_endt_seq_no := c.endt_seq_no;
               v_rec.dist_peril_sw := 'N';
              
            END LOOP;
         END IF;
         PIPE ROW (v_rec);
    END LOOP;      
    CLOSE c;
      RETURN;
   -- end SR5800 11.8.2016 optimized by MarkS  
----------------------------------------------------------------------------------------------
   --SR5800 11.8.2016 commented out for optimization by MarkS
--      FOR i IN (SELECT line_cd, binder_yy, binder_seq_no,
--                          line_cd
--                       || '-'
--                       || LTRIM (TO_CHAR (binder_yy, '09'))
--                       || '-'
--                       || LTRIM (TO_CHAR (binder_seq_no, '09999')) binder_no,
--                       ri_cd, fnl_binder_id, binder_date, reverse_date
--                  FROM giri_binder
--                 WHERE 1 = 1
--                   AND UPPER (line_cd) = NVL (UPPER (p_line_cd), line_cd)
--                   AND binder_yy = NVL (p_binder_yy, binder_yy)
--                   AND binder_seq_no = NVL (p_binder_seq_no, binder_seq_no)
--                   AND TRUNC (binder_date) =
--                          NVL (TO_DATE (p_binder_date, 'MM-DD-RRRR'),
--                               TRUNC (binder_date)
--                              )
--                   AND NVL (TRUNC (reverse_date),
--                            TO_DATE ('01-01-1900', 'MM-DD-RRRR')
--                           ) =
--                          NVL (TO_DATE (p_reverse_date, 'MM-DD-RRRR'),
--                               NVL (TRUNC (reverse_date),
--                                    TO_DATE ('01-01-1900', 'MM-DD-RRRR')
--                                   )
--                              )
--                   AND check_user_per_line2 (line_cd,
--                                             iss_cd,
--                                             'GIRIS055',
--                                             p_user_id
--                                            ) = 1
--                   AND check_user_per_iss_cd_acctg2 (line_cd,
--                                                     iss_cd,
--                                                     'GIRIS055',
--                                                     p_user_id
--                                                    ) = 1)
--      LOOP
--         v_exist := 'N';
--         v_rec.fnl_binder_id := i.fnl_binder_id;
--         v_rec.line_cd := i.line_cd;
--         v_rec.binder_yy := i.binder_yy;
--         v_rec.binder_seq_no := i.binder_seq_no;
--         v_rec.binder_no := i.binder_no;
--         v_rec.binder_date := TO_CHAR (i.binder_date, 'MM-DD-RRRR');
--         v_rec.reverse_date := TO_CHAR (i.reverse_date, 'MM-DD-RRRR');
--         v_rec.dsp_ri_name := get_ri_name (i.ri_cd);

--         FOR b IN (SELECT DISTINCT t6.assd_name assd_name,
--                                   t5.line_cd line_cd,
--                                   t5.subline_cd subline_cd,
--                                   t5.iss_cd iss_cd, t5.issue_yy issue_yy,
--                                   t5.pol_seq_no pol_seq_no,
--                                   t5.renew_no renew_no,
--                                   t5.endt_iss_cd endt_iss_cd,
--                                   t5.endt_yy endt_yy,
--                                   t5.endt_seq_no endt_seq_no,
--                                   t3.ri_flag ri_flag
--                              FROM giri_frps_ri t2,
--                                   giri_distfrps t3,
--                                   giuw_pol_dist t4,
--                                   gipi_polbasic t5,
--                                   giis_assured t6,
--                                   gipi_parlist t7
--                             WHERE t2.frps_yy = t3.frps_yy
--                               AND t2.frps_seq_no = t3.frps_seq_no
--                               AND t2.line_cd = t3.line_cd
--                               AND t3.dist_no = t4.dist_no
--                               AND t4.policy_id = t5.policy_id
--                               AND t7.assd_no = t6.assd_no
--                               AND t5.par_id = t7.par_id
--                               AND t2.fnl_binder_id = i.fnl_binder_id
--                               AND t2.line_cd = i.line_cd)
--         LOOP
--            v_rec.nbt_assd_name := b.assd_name;
--            v_rec.nbt_line_cd := b.line_cd;
--            v_rec.nbt_subline_cd := b.subline_cd;
--            v_rec.nbt_iss_cd := b.iss_cd;
--            v_rec.nbt_issue_yy := b.issue_yy;
--            v_rec.nbt_pol_seq_no := b.pol_seq_no;
--            v_rec.nbt_renew_no := b.renew_no;

--            IF i.reverse_date IS NULL
--            THEN
--               v_ri_flag := b.ri_flag;
--            ELSE
--               v_ri_flag := '3';
--            END IF;

--            IF b.endt_seq_no != 0
--            THEN
--               v_rec.nbt_endt_iss_cd := b.endt_iss_cd;
--               v_rec.nbt_endt_yy := b.endt_yy;
--               v_rec.nbt_endt_seq_no := b.endt_seq_no;
--            ELSE
--               v_rec.nbt_endt_iss_cd := '';
--               v_rec.nbt_endt_yy := '';
--               v_rec.nbt_endt_seq_no := '';
--            END IF;

--            v_exist := 'Y';
--            v_rec.dist_peril_sw := 'Y';
--         END LOOP;

--         IF v_exist = 'N'
--         THEN
--            FOR c IN (SELECT DISTINCT t6.assd_name assd_name,
--                                      t5.line_cd line_cd,
--                                      t5.subline_cd subline_cd,
--                                      t5.iss_cd iss_cd, t5.issue_yy issue_yy,
--                                      t5.pol_seq_no pol_seq_no,
--                                      t5.renew_no renew_no,
--                                      t5.endt_iss_cd endt_iss_cd,
--                                      t5.endt_yy endt_yy,
--                                      t5.endt_seq_no endt_seq_no
--                                 FROM giri_endttext t1,
--                                      gipi_polbasic t5,
--                                      giis_assured t6,
--                                      gipi_parlist t7
--                                WHERE t5.policy_id = t1.policy_id
--                                  AND t7.assd_no = t6.assd_no
--                                  AND t5.par_id = t7.par_id
--                                  AND t5.line_cd = i.line_cd
--                                  AND t1.fnl_binder_id = i.fnl_binder_id)
--            LOOP
--               v_rec.nbt_assd_name := c.assd_name;
--               v_rec.nbt_line_cd := c.line_cd;
--               v_rec.nbt_subline_cd := c.subline_cd;
--               v_rec.nbt_iss_cd := c.iss_cd;
--               v_rec.nbt_issue_yy := c.issue_yy;
--               v_rec.nbt_pol_seq_no := c.pol_seq_no;
--               v_rec.nbt_renew_no := c.renew_no;
--               v_rec.nbt_endt_iss_cd := c.endt_iss_cd;
--               v_rec.nbt_endt_yy := c.endt_yy;
--               v_rec.nbt_endt_seq_no := c.endt_seq_no;
--               v_rec.dist_peril_sw := 'N';

--               IF i.reverse_date IS NULL
--               THEN
--                  v_ri_flag := '2';
--               ELSE
--                  v_ri_flag := '3';
--               END IF;
--            END LOOP;
--         END IF;

--         FOR a IN (SELECT rv_meaning
--                     FROM cg_ref_codes
--                    WHERE rv_domain = 'GIRI_DISTFRPS.RI_FLAG'
--                      AND rv_low_value = v_ri_flag)
--         LOOP
--            v_rec.dsp_status := a.rv_meaning;
--         END LOOP;

--         PIPE ROW (v_rec);
--      END LOOP;

--      RETURN;
--end SR5800 11.8.2016 optimized by MarkS
   END get_giris055_dtls;

   FUNCTION get_distbyperil_dtls (
      p_fnl_binder_id   giri_binder.fnl_binder_id%TYPE
   )
      RETURN binder_distbyperil_tab PIPELINED
   IS
      v_rec   binder_distbyperil_type;
   BEGIN
      FOR i IN (SELECT peril_seq_no, ri_shr_pct, ri_tsi_amt, ri_prem_amt,
                       ri_comm_amt
                  FROM giri_binder_peril
                 WHERE fnl_binder_id = p_fnl_binder_id)
      LOOP
         v_rec.ri_shr_pct := i.ri_shr_pct;
         v_rec.ri_tsi_amt := i.ri_tsi_amt;
         v_rec.ri_prem_amt := i.ri_prem_amt;
         v_rec.ri_comm_amt := i.ri_comm_amt;

         BEGIN
            SELECT DISTINCT a.peril_name
                       INTO v_rec.nbt_peril_name
                       FROM giri_binder_peril b,
                            giri_frps_ri c,
                            giri_frps_peril_grp d,
                            giis_peril a
                      WHERE c.fnl_binder_id = b.fnl_binder_id
                        AND c.line_cd = d.line_cd
                        AND c.frps_yy = d.frps_yy
                        AND c.frps_seq_no = d.frps_seq_no
                        AND b.peril_seq_no = d.peril_seq_no
                        AND d.line_cd = a.line_cd
                        AND d.peril_cd = a.peril_cd
                        AND b.fnl_binder_id = p_fnl_binder_id
                        AND b.peril_seq_no = i.peril_seq_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.nbt_peril_name := '';
            WHEN OTHERS
            THEN
               v_rec.nbt_peril_name := '';
         END;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_distbyperil_dtls;
END;
/