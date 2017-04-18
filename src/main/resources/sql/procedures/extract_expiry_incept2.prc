DROP PROCEDURE CPI.EXTRACT_EXPIRY_INCEPT2;

CREATE OR REPLACE PROCEDURE CPI.extract_expiry_incept2 (
/*
** Modified by   : Joanne
** Date Modified : 02/19/2013
** Modifications : Modified procedure to retrieve correct Incept and Expiry Date.
*/
   p_pol_eff_date  OUT VARCHAR2,
   p_pol_eff_date2 OUT GIPI_POLBASIC.incept_date%TYPE,
   p_expiry_date   OUT  VARCHAR2,  
   p_expiry_date2  OUT  GIPI_POLBASIC.expiry_date%TYPE,
   p_loss_date              gicl_claims.loss_date%TYPE,
   p_line_cd                gicl_claims.line_cd%TYPE,
   p_subline_cd             gicl_claims.subline_cd%TYPE,
   p_pol_iss_cd             gicl_claims.iss_cd%TYPE,
   p_issue_yy               gicl_claims.issue_yy%TYPE,
   p_pol_seq_no             gicl_claims.pol_seq_no%TYPE,
   p_renew_no               gicl_claims.renew_no%TYPE
)
IS
BEGIN
   SELECT TO_DATE (TO_CHAR (incept_date, 'MM/DD/RRRR') || stime,
                   'MM/DD/RRRR HH:MI AM'
                  ) incept_date2,
          TO_DATE (TO_CHAR (expiry_date, 'MM/DD/RRRR') || stime,
                   'MM/DD/RRRR HH:MI AM'
                  ) expiry_date2,
          TO_CHAR (incept_date, 'MM-DD-RRRR') ||' '|| stime incept_date,
          TO_CHAR (expiry_date, 'MM-DD-RRRR') ||' '|| stime expiry_date        
                  
     INTO p_pol_eff_date2,
          p_expiry_date2,
          p_pol_eff_date,
          p_expiry_date
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
                           ) stime
               FROM gipi_polbasic a, giis_subline b
              WHERE a.pol_flag IN ('1', '2', '3', 'X')
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
           ORDER BY NVL (a.back_stat, 1) DESC,
                    a.eff_date DESC,
                    a.endt_seq_no DESC)
    WHERE ROWNUM = 1;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      FOR a1 IN (SELECT TO_DATE (TO_CHAR (incept_date, 'MM/DD/RRRR') || stime,
                               'MM/DD/RRRR HH:MI AM'
                              ) incept_date2,
                      TO_DATE (TO_CHAR (expiry_date, 'MM/DD/RRRR') || stime,
                               'MM/DD/RRRR HH:MI AM'
                              ) expiry_date2,
                      TO_CHAR (incept_date, 'MM-DD-RRRR') ||' '|| stime incept_date,
                      TO_CHAR (expiry_date, 'MM-DD-RRRR') ||' '|| stime expiry_date        
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
                                       ) stime
                           FROM gipi_polbasic a, giis_subline b
                          WHERE a.pol_flag IN ('1', '2', '3', 'X')
                            AND a.line_cd = p_line_cd
                            AND a.subline_cd = p_subline_cd
                            AND a.iss_cd = p_pol_iss_cd
                            AND a.issue_yy = p_issue_yy
                            AND a.pol_seq_no = p_pol_seq_no
                            AND a.renew_no =p_renew_no
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


