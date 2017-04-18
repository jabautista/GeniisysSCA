CREATE OR REPLACE PACKAGE BODY CPI.giacr136c_pkg
AS
   FUNCTION get_giacr136c_dtls (
      p_cession_year   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_quarter        VARCHAR2,
      p_share_cd       VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN get_giacr136c_tab PIPELINED
   IS
      v_list   get_giacr136c_type;
      v_q   VARCHAR2(36);
      v_header       BOOLEAN := TRUE;
   BEGIN
     BEGIN
        FOR i IN (SELECT param_value_v
                    FROM giis_parameters
                   WHERE param_name = 'COMPANY_NAME')
        LOOP
           v_list.company_name := i.param_value_v;
           EXIT;
        END LOOP;
     END;

     BEGIN
        BEGIN
           SELECT param_value_v
             INTO v_list.company_address
             FROM giac_parameters
            WHERE param_name = 'COMPANY_ADDRESS';
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_list.company_address := ' ';
        END;
     END;   
     
      FOR i IN (SELECT   a.line_cd, trty_name,
                         d.line_name || ' - ' || b.trty_name line_trty_name,
                         a.trty_com_rt, a.cession_year,
                         TO_CHAR (TO_DATE (a.cession_mm, 'MM'),
                                  'MONTH'
                                 ) cf_month,
                         a.cession_mm, a.branch_cd, a.prnt_ri_cd, c.ri_sname,
                         a.trty_shr_pct, SUM (a.premium_amt) premium, A.SHARE_CD,
                         --added by MarkS SR5867 
                         DECODE(TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH'),
                                                                          LAG(TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH'),1,0) OVER(ORDER BY  a.share_cd, a.cession_mm, branch_cd),DECODE(a.share_cd,LAG(a.share_cd,1,0) OVER(ORDER BY  a.share_cd, a.cession_mm, branch_cd),
                                                                                                                                                                                                                                                                            NULL,TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH')),TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH')) cf_month_dum-- added by MarkS SR5867                                                                                                                                                                                                                                          NULL,TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH')),TO_CHAR(TO_DATE(a.cession_mm,'MM'),'MONTH')) month,-- added by MarkS SR5867
                         --
                    FROM gixx_trty_prem_comm a,
                         giis_dist_share b,
                         giis_reinsurer c,
                         giis_line d
                   WHERE a.user_id = UPPER (p_user_id)
                     AND a.line_cd = b.line_cd
                     AND a.line_cd = d.line_cd
                     AND a.line_cd = NVL (p_line_cd, b.line_cd)
                     AND a.share_cd = b.share_cd
                     AND a.treaty_yy = b.trty_yy
                     AND a.prnt_ri_cd = c.ri_cd
                     AND cession_mm BETWEEN   DECODE (p_quarter,
                                                      1, 3,
                                                      2, 6,
                                                      3, 9,
                                                      4, 12,
                                                      NULL, 3
                                                     )
                                            - 2
                                        AND DECODE (p_quarter,
                                                    1, 3,
                                                    2, 6,
                                                    3, 9,
                                                    4, 12,
                                                    NULL, 3
                                                   )
                     AND cession_year =
                            TO_NUMBER (NVL (p_cession_year,
                                            TO_CHAR (SYSDATE, 'YYYY')
                                           )
                                      )
                GROUP BY a.cession_mm,
                         a.line_cd,
                         b.trty_name,
                         a.trty_com_rt,
                         a.cession_year,
                         a.branch_cd,
                         a.prnt_ri_cd,
                         c.ri_sname,
                         a.trty_shr_pct,
                         d.line_name,
                         a.share_cd
                ORDER BY a.share_cd,
                         a.line_cd,
                         trty_name,
                         a.cession_year,
                         cession_mm,
                         a.branch_cd,
                         c.ri_sname)
      LOOP
        v_header := FALSE;
        v_list.header_flag := 'N';
        
         BEGIN
            IF p_quarter = 1 OR p_quarter IS NULL
            THEN
                v_q := 'FIRST QUARTER ';
            ELSIF p_quarter = 2
            THEN
                v_q := 'SECOND QUARTER ';
            ELSIF p_quarter = 3
            THEN
                v_q := 'THIRD QUARTER ';
            ELSIF p_quarter = 4
            THEN
                v_q := 'FOURTH QUARTER ';
            END IF;
            v_list.quarter_year := v_q || ' ' || p_cession_year;
         END;

         v_list.line_treaty := i.line_trty_name;
         v_list.cf_month := i.cf_month;
         v_list.shr_pct := i.trty_shr_pct;
         v_list.premium_amt := i.premium;
         v_list.branch_cd := i.branch_cd;
         v_list.ri_sname := i.ri_sname;
         v_list.line_cd := i.line_cd;
         v_list.cession_mm := i.cession_mm;
         v_list.trty_name := i.trty_name;
         v_list.trty_com_rt := i.trty_com_rt;
         v_list.share_cd := i.share_cd;
         --added by MarkS SR5867 
         v_list.cf_month_dum := i.cf_month_dum;
         PIPE ROW (v_list);
      END LOOP;

       IF v_header THEN
            v_list.header_flag  := 'Y';
            PIPE ROW(v_list);
       END IF;   
       
      RETURN;
   END get_giacr136c_dtls;

   FUNCTION get_giacr136c_recap (
      p_cession_year   VARCHAR2,
      p_line_cd        VARCHAR2,
      p_quarter        VARCHAR2,
      p_share_cd       VARCHAR2,
      p_trty_name      VARCHAR2,
      p_user_id        VARCHAR2,
      p_cf_month       VARCHAR2,
      p_trty_com_rt    NUMBER
   )
      RETURN get_giacr136c_tab PIPELINED
   IS
      v_list   get_giacr136c_type;
   BEGIN
      FOR i IN (SELECT DISTINCT TO_CHAR (TO_DATE (cession_mm, 'MM'),
                                         'MONTH'
                                        ) month_grand,
                                a.cession_year, a.cession_mm,
                                a.line_cd line_cd_grand, trty_name,
                                a.trty_com_rt, b.ri_sname ri_sname_grand,
                                SUM (a.premium_amt) premium_shr_grand
                           FROM gixx_trty_prem_comm a,
                                giis_reinsurer b,
                                giis_dist_share c
                          WHERE a.prnt_ri_cd = b.ri_cd
                            AND a.line_cd = c.line_cd
                            AND a.share_cd = c.share_cd
                            AND a.treaty_yy = c.trty_yy
                            AND a.user_id = UPPER (p_user_id)
                            AND a.line_cd = p_line_cd
                            AND a.cession_year = p_cession_year
                            AND trty_name = p_trty_name
                            AND a.trty_com_rt = p_trty_com_rt
                            AND a.cession_mm BETWEEN   DECODE (p_quarter,
                                                               1, 3,
                                                               2, 6,
                                                               3, 9,
                                                               4, 12,
                                                               NULL, 3
                                                              )
                                                     - 2
                                                 AND DECODE (p_quarter,
                                                             1, 3,
                                                             2, 6,
                                                             3, 9,
                                                             4, 12,
                                                             NULL, 3
                                                            )
                            AND TO_CHAR (TO_DATE (cession_mm, 'MM'), 'MONTH') =
                                   NVL (p_cf_month,
                                        TO_CHAR (TO_DATE (cession_mm, 'MM'),
                                                 'MONTH'
                                                )
                                       )
                       GROUP BY a.line_cd,
                                trty_name,
                                a.trty_com_rt,
                                a.cession_year,
                                a.cession_mm,
                                b.ri_sname
                       ORDER BY a.line_cd,
                                trty_name,
                                a.trty_com_rt,
                                a.cession_year,
                                a.cession_mm,
                                b.ri_sname)
      LOOP
         v_list.month_grand := i.month_grand;
         v_list.ri_sname_grand := i.ri_sname_grand;
         v_list.premium_shr_grand := i.premium_shr_grand;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacr136c_recap;
END;
/
