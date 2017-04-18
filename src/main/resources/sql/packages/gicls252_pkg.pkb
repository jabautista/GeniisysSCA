CREATE OR REPLACE PACKAGE BODY CPI.gicls252_pkg
AS
/*
**  Created by   : Chamille Ambat
**  Date Created : 2.1.2013
**  Description  : Populate GICLS252(Claim Status)
**  Modified by  : Gzelle 06.11.2013
*/
   FUNCTION get_clm_status (
      p_user_id         giis_users.user_id%TYPE,
      p_clm_stat_type   giis_clm_stat.clm_stat_type%TYPE,
      p_date_col        VARCHAR,
      p_date_as_of      VARCHAR,
      p_date_from       VARCHAR,
      p_date_to         VARCHAR
   )
      RETURN clm_status_tab PIPELINED
   IS
      v_list            clm_status_type;
      v_clm_stat_cd     VARCHAR2(2);
      v_clm_stat_type   VARCHAR2(2);
   BEGIN
      SELECT DECODE (p_clm_stat_type
                     , 'X' , 'CC'
                     , 'C' , 'CD'
                     , 'D' , 'DN'
                     , 'W' , 'WD', '%')
        INTO v_clm_stat_cd 
        FROM DUAL;
       
--      SELECT DECODE (p_clm_stat_type  removed by kenneth L. 04.11.2014
--                     , 'X' , 'D'
--                     , 'C' , 'S'
--                     , 'D' , 'D'
--                     , 'W' , 'D'
--                     , 'N' , 'N' ,p_clm_stat_type)
--        INTO v_clm_stat_type
--        FROM DUAL;
   
      FOR i IN (SELECT gc.*, gs.clm_stat_desc claim_status,
                          gc.line_cd
                       || '-'
                       || gc.subline_cd
                       || '-'
                       || gc.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (gc.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (gc.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (gc.renew_no, '09')) policy_no
                  FROM gicl_claims gc, giis_clm_stat gs
                 WHERE gs.clm_stat_cd = gc.clm_stat_cd
                   AND gs.clm_stat_cd LIKE v_clm_stat_cd 
                   AND gs.clm_stat_type LIKE NVL(p_clm_stat_type,'%') --AND gs.clm_stat_type LIKE NVL(v_clm_stat_type,'%') Replaced by Kenneth L. 04.11.2014
                   AND claim_id IN (SELECT claim_id 
                                      FROM gicl_claims 
                                     WHERE check_user_per_iss_cd2 (gc.line_cd, gc.iss_cd, 'GICLS252', p_user_id) = 1
                   AND (   (    (DECODE (p_date_col,
                                         'lossDate', TRUNC(gc.loss_date),--gc.dsp_loss_date,
                                         'fileDate', TRUNC(gc.clm_file_date),
                                         'closeDate', TRUNC(gc.close_date),
                                         'entryDate', TRUNC(gc.entry_date)
                                        ) >=
                                           TO_DATE (p_date_from, 'MM-DD-YYYY')
                                )
                            AND (DECODE (p_date_col,
                                         'lossDate', TRUNC(gc.loss_date),--gc.dsp_loss_date,
                                         'fileDate', TRUNC(gc.clm_file_date),
                                         'closeDate', TRUNC(gc.close_date),
                                         'entryDate', TRUNC(gc.entry_date)
                                        ) <= TO_DATE (p_date_to, 'MM-DD-YYYY')
                                )
                           )
                        OR (DECODE (p_date_col,
                                    'lossDate', TRUNC(gc.loss_date),--gc.dsp_loss_date,
                                    'fileDate', TRUNC(gc.clm_file_date),
                                    'closeDate', TRUNC(gc.close_date),
                                    'entryDate', TRUNC(gc.entry_date)
                                   ) <= TO_DATE (p_date_as_of, 'MM-DD-YYYY')
                           )
                       ))
                       ORDER BY UPPER(line_cd||'-'||subline_cd||'-'||iss_cd||'-'||LTRIM(TO_CHAR(clm_yy,'09'))||'-'||LTRIM(TO_CHAR(clm_seq_no,'0000009')))
                  /* AND check_user_per_line2 (gc.line_cd,
                                             gc.iss_cd,
                                             'GICLS252',
                                             p_user_id
                                            ) = 1*/)
      LOOP
         v_list.claim_id        := get_claim_number (i.claim_id);
         v_list.policy_no       := i.policy_no;
         v_list.assured_name    := i.assured_name;
         v_list.claim_status    := i.claim_status;
         v_list.close_date      := TO_CHAR (i.close_date, 'MM-DD-YYYY HH:MI:SS AM'); --kenneth L 11.19.2013
         v_list.dsp_loss_date   := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY HH:MI:SS AM'); --kenneth L 11.19.2013
         v_list.clm_file_date   := TO_CHAR (i.clm_file_date, 'MM-DD-YYYY HH:MI:SS AM'); --kenneth L 11.19.2013
         v_list.remarks         := i.remarks;
         v_list.entry_date      := TO_CHAR (i.entry_date, 'MM-DD-YYYY HH:MI:SS AM'); --kenneth L 11.19.2013
         v_list.in_hou_adj      := i.in_hou_adj;
         v_list.loss_res_amt    := i.loss_res_amt;
         v_list.exp_res_amt     := i.exp_res_amt;
         v_list.loss_pd_amt     := i.loss_pd_amt;
         v_list.exp_pd_amt      := i.exp_pd_amt;
         v_list.line_cd         := i.line_cd;
         v_list.subline_cd      := i.subline_cd;
         v_list.issue_yy        := i.issue_yy;
         v_list.pol_seq_no      := i.pol_seq_no;
         v_list.renew_no        := i.renew_no;
         v_list.pol_iss_cd      := i.pol_iss_cd;
         v_list.clm_yy          := i.clm_yy;
         v_list.clm_seq_no      := i.clm_seq_no;
         v_list.iss_cd          := i.iss_cd;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_status;
END;
/


