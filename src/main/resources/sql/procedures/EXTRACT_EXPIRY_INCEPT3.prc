CREATE OR REPLACE PROCEDURE CPI.EXTRACT_EXPIRY_INCEPT3 (
/*
** Modified by   : Kenneth
** Date Modified : 10/08/2015
** Modifications : Modified procedure to retrieve correct Incept and Expiry Date.
*/
   p_pol_eff_date    OUT   VARCHAR2,
   p_pol_eff_date2   OUT   gipi_polbasic.incept_date%TYPE,
   p_expiry_date     OUT   VARCHAR2,
   p_expiry_date2    OUT   gipi_polbasic.expiry_date%TYPE,
   p_loss_date             gicl_claims.loss_date%TYPE,
   p_line_cd               gicl_claims.line_cd%TYPE,
   p_subline_cd            gicl_claims.subline_cd%TYPE,
   p_pol_iss_cd            gicl_claims.iss_cd%TYPE,
   p_issue_yy              gicl_claims.issue_yy%TYPE,
   p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
   p_renew_no              gicl_claims.renew_no%TYPE
)
IS
    v_loss_date VARCHAR2(10)    :=NULL; --added by mapgarza SR 21926  
BEGIN
   IF p_loss_date IS NOT NULL THEN --added by mapgarza SR 21926
      v_loss_date := TO_CHAR(p_loss_date, 'MM/DD/RRRR HH:MI AM');
   END IF;                          --end of codes added by mapgarza SR 21926
   FOR rec in (SELECT TO_DATE (TO_CHAR (incept_date, 'MM/DD/RRRR') || stime, --Modified by Jerome Bautista 11.24.2015 SR 20922
                   'MM/DD/RRRR HH:MI AM'
                  ) incept_date2,
          TO_DATE (   TO_CHAR (DECODE (pol_flag, '4', eff_date, expiry_date),
                               'MM/DD/RRRR'
                              )
                   || stime,
                   'MM/DD/RRRR HH:MI AM'
                  ) expiry_date2,
          TO_CHAR (incept_date, 'MM-DD-RRRR') || ' ' || stime incept_date,
             TO_CHAR (DECODE (pol_flag, '4', eff_date, expiry_date),
                      'MM-DD-RRRR'
                     )
          || ' '
          || stime expiry_date, endt_seq_no -- Added by Jerome Bautista 11.24.2015 SR 20922
--     INTO p_pol_eff_date2, -- Commented out Jerome Bautista 11.24.2015 SR 20922
--          p_expiry_date2,
--          p_pol_eff_date,
--          p_expiry_date
     FROM (SELECT   a.incept_date, a.expiry_date, a.eff_date,
                    SUBSTR (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                     'MM/DD/YYYY HH:MI AM'
                                    ),
                              INSTR (TO_CHAR (TO_DATE (b.subline_time,
                                                       'SSSSS'),
                                              'MM/DD/YYYY HH:MM AM'
                                             ),
                                     '/',
                                     1,
                                     2
                                    )
                            + 6
                           ) stime,
                    a.pol_flag,
                    a.endt_seq_no -- Added by Jerome Bautista 11.24.2015 SR 20922
               FROM gipi_polbasic a, giis_subline b
              WHERE a.pol_flag IN ('1', '2', '3', '4', 'X')
                AND a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_pol_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
                AND TO_DATE
                         (   TO_CHAR (a.eff_date, 'MM/DD/RRRR')
                          || SUBSTR
                                  (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                            'MM/DD/YYYY HH:MI AM'
                                           ),
                                     INSTR
                                          (TO_CHAR (TO_DATE (b.subline_time,
                                                             'SSSSS'
                                                            ),
                                                    'MM/DD/YYYY HH:MM AM'
                                                   ),
                                           '/',
                                           1,
                                           2
                                          )
                                   + 6
                                  ),
                          'MM/DD/RRRR HH:MI AM'
                         --) <= NVL (p_loss_date, SYSDATE) --removed by mapgarza SR 21926
                         ) <= NVL (TO_DATE(v_loss_date,'MM/DD/RRRR HH:MI AM'), SYSDATE)--added by mapgarza SR 21926                         
                AND a.line_cd = b.line_cd
                AND a.subline_cd = b.subline_cd
           ORDER BY --NVL (a.back_stat, 1) DESC, --Commented out by Jerome Bautista 11.24.2015 SR 20922
                    a.eff_date DESC,
                    a.endt_seq_no DESC)
    WHERE ROWNUM = 1)
    LOOP
        p_expiry_date2 := rec.expiry_date2;
        p_pol_eff_date2 := rec.incept_date2;
        p_expiry_date := rec.expiry_date;
        p_pol_eff_date := rec.incept_date;
        
        FOR b in (SELECT TO_DATE (TO_CHAR (incept_date, 'MM/DD/RRRR') || stime,
                   'MM/DD/RRRR HH:MI AM'
                  ) incept_date2,
          TO_DATE (   TO_CHAR (DECODE (pol_flag, '4', eff_date, expiry_date),
                               'MM/DD/RRRR'
                              )
                   || stime,
                   'MM/DD/RRRR HH:MI AM'
                  ) expiry_date2,
          TO_CHAR (incept_date, 'MM-DD-RRRR') || ' ' || stime incept_date,
             TO_CHAR (DECODE (pol_flag, '4', eff_date, expiry_date),
                      'MM-DD-RRRR'
                     )
          || ' '
          || stime expiry_date, endt_seq_no -- Added by Jerome Bautista 11.24.2015 SR 20922
        FROM (SELECT   a.incept_date, a.expiry_date, a.eff_date,
                    SUBSTR (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                     'MM/DD/YYYY HH:MI AM'
                                    ),
                              INSTR (TO_CHAR (TO_DATE (b.subline_time,
                                                       'SSSSS'),
                                              'MM/DD/YYYY HH:MM AM'
                                             ),
                                     '/',
                                     1,
                                     2
                                    )
                            + 6
                           ) stime,
                    a.pol_flag,
                    a.endt_seq_no -- Added by Jerome Bautista 11.24.2015 SR 20922
               FROM gipi_polbasic a, giis_subline b
              WHERE a.pol_flag IN ('1', '2', '3', '4', 'X')
                AND a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_pol_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
                AND TO_DATE
                         (   TO_CHAR (a.eff_date, 'MM/DD/RRRR')
                          || SUBSTR
                                  (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                            'MM/DD/YYYY HH:MI AM'
                                           ),
                                     INSTR
                                          (TO_CHAR (TO_DATE (b.subline_time,
                                                             'SSSSS'
                                                            ),
                                                    'MM/DD/YYYY HH:MM AM'
                                                   ),
                                           '/',
                                           1,
                                           2
                                          )
                                   + 6
                                  ),
                          'MM/DD/RRRR HH:MI AM'
                         --) <= NVL (p_loss_date, SYSDATE) --removed by mapgarza SR 21926
                         ) <= NVL (TO_DATE(v_loss_date,'MM/DD/RRRR HH:MI AM'), SYSDATE)--added by mapgarza SR 21926                         
                AND a.line_cd = b.line_cd
                AND a.subline_cd = b.subline_cd
                AND NVL(a.endt_seq_no,0) > 0
                AND NVL(a.endt_seq_no,0) > rec.endt_seq_no
           ORDER BY --NVL (a.back_stat, 1) DESC,
                    --a.eff_date DESC,
                    a.endt_seq_no DESC)
           WHERE ROWNUM = 1)
        LOOP
            p_expiry_date2 := b.expiry_date2;
            p_pol_eff_date2 := b.incept_date2;
            p_expiry_date := b.expiry_date;
            p_pol_eff_date := b.incept_date;
        EXIT;
        END LOOP;
        
        FOR c in (SELECT TO_DATE (TO_CHAR (incept_date, 'MM/DD/RRRR') || stime,
                   'MM/DD/RRRR HH:MI AM'
                  ) incept_date2,
          TO_DATE (   TO_CHAR (DECODE (pol_flag, '4', eff_date, expiry_date),
                               'MM/DD/RRRR'
                              )
                   || stime,
                   'MM/DD/RRRR HH:MI AM'
                  ) expiry_date2,
          TO_CHAR (incept_date, 'MM-DD-RRRR') || ' ' || stime incept_date,
             TO_CHAR (DECODE (pol_flag, '4', eff_date, expiry_date),
                      'MM-DD-RRRR'
                     )
          || ' '
          || stime expiry_date, endt_seq_no -- Added by Jerome Bautista 11.24.2015 SR 20922
        FROM (SELECT   a.incept_date, a.expiry_date, a.eff_date,
                    SUBSTR (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                     'MM/DD/YYYY HH:MI AM'
                                    ),
                              INSTR (TO_CHAR (TO_DATE (b.subline_time,
                                                       'SSSSS'),
                                              'MM/DD/YYYY HH:MM AM'
                                             ),
                                     '/',
                                     1,
                                     2
                                    )
                            + 6
                           ) stime,
                    a.pol_flag,
                    a.endt_seq_no -- Added by Jerome Bautista 11.24.2015 SR 20922
               FROM gipi_polbasic a, giis_subline b
              WHERE a.pol_flag IN ('1', '2', '3', '4', 'X')
                AND a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_pol_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
                AND TO_DATE
                         (   TO_CHAR (a.eff_date, 'MM/DD/RRRR')
                          || SUBSTR
                                  (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                            'MM/DD/YYYY HH:MI AM'
                                           ),
                                     INSTR
                                          (TO_CHAR (TO_DATE (b.subline_time,
                                                             'SSSSS'
                                                            ),
                                                    'MM/DD/YYYY HH:MM AM'
                                                   ),
                                           '/',
                                           1,
                                           2
                                          )
                                   + 6
                                  ),
                          'MM/DD/RRRR HH:MI AM'
                         ) <= NVL (p_loss_date, SYSDATE)
                AND a.line_cd = b.line_cd
                AND a.subline_cd = b.subline_cd
                AND NVL(a.endt_seq_no,0) > 0
                AND NVL(a.back_stat,5) = 2
                AND NVL(a.endt_seq_no,0) > rec.endt_seq_no
           ORDER BY --NVL (a.back_stat, 1) DESC,
                    --a.eff_date DESC,
                    a.endt_seq_no DESC)
           WHERE ROWNUM = 1)
           
           LOOP
                p_expiry_date2 := c.expiry_date2;
                p_pol_eff_date2 := c.incept_date2;
                p_expiry_date := c.expiry_date;
                p_pol_eff_date := c.incept_date;
           EXIT;
           END LOOP;
    EXIT;
    END LOOP;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      FOR a1 IN
         (SELECT TO_DATE (TO_CHAR (incept_date, 'MM/DD/RRRR') || stime,
                          'MM/DD/RRRR HH:MI AM'
                         ) incept_date2,
                 TO_DATE (TO_CHAR (expiry_date, 'MM/DD/RRRR') || stime,
                          'MM/DD/RRRR HH:MI AM'
                         ) expiry_date2,
                    TO_CHAR (incept_date, 'MM-DD-RRRR')
                 || ' '
                 || stime incept_date,
                    TO_CHAR (expiry_date, 'MM-DD-RRRR')
                 || ' '
                 || stime expiry_date
            FROM (SELECT a.incept_date, a.expiry_date, a.eff_date,
                         SUBSTR
                            (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                      'MM/DD/YYYY HH:MI AM'
                                     ),
                               INSTR (TO_CHAR (TO_DATE (b.subline_time,
                                                        'SSSSS'
                                                       ),
                                               'MM/DD/YYYY HH:MM AM'
                                              ),
                                      '/',
                                      1,
                                      2
                                     )
                             + 6
                            ) stime
                    FROM gipi_polbasic a, giis_subline b
                   WHERE a.pol_flag IN ('1', '2', '3', '4', 'X')
                     AND a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.iss_cd = p_pol_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND NVL (a.endt_seq_no, 0) = 0
                     AND a.line_cd = b.line_cd
                     AND a.subline_cd = b.subline_cd))
      LOOP
         p_expiry_date2 := NVL (p_expiry_date2, a1.expiry_date2);
         p_pol_eff_date2 := NVL (p_pol_eff_date2, a1.incept_date2);
         p_expiry_date := NVL (p_expiry_date, a1.expiry_date);
         p_pol_eff_date := NVL (p_pol_eff_date, a1.incept_date);
         EXIT;
      END LOOP;
END;
/
