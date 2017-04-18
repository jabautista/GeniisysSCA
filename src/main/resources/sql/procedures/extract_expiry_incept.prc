DROP PROCEDURE CPI.EXTRACT_EXPIRY_INCEPT;

CREATE OR REPLACE PROCEDURE CPI.extract_expiry_incept (
/*
** Modified by   : MAC
** Date Modified : 10/09/2013
** Modifications : Modified procedure to retrieve correct Incept and Expiry Date.
*/
   p_expiry_date   IN OUT   gicl_claims.expiry_date%TYPE,
   p_incept_date   IN OUT   gicl_claims.expiry_date%TYPE,
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
                   ) incept_date,
           TO_DATE (TO_CHAR (expiry_date, 'MM/DD/RRRR') || stime,
                    'MM/DD/RRRR HH:MI AM'
                   ) expiry_date
      INTO p_incept_date,
           p_expiry_date
      FROM (SELECT   a.incept_date, a.expiry_date, a.eff_date,
                     SUBSTR (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
                                      'MM/DD/YYYY HH:MI AM'
                                     ),
                               INSTR (TO_CHAR (TO_DATE (b.subline_time, 'SSSSS'),
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
                 AND TO_DATE (   TO_CHAR (a.eff_date, 'MM/DD/RRRR')
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
            ORDER BY NVL (a.back_stat, 1) DESC, a.eff_date DESC,
                     a.endt_seq_no DESC)
     WHERE ROWNUM = 1;

   UPDATE gicl_claims
      SET expiry_date = NVL (p_expiry_date, expiry_date),
          pol_eff_date = NVL (p_incept_date, pol_eff_date)
    WHERE line_cd = p_line_cd
      AND subline_cd = p_subline_cd
      AND pol_iss_cd = p_pol_iss_cd
      AND issue_yy = p_issue_yy
      AND pol_seq_no = p_pol_seq_no
      AND renew_no = p_renew_no;
END;
/


