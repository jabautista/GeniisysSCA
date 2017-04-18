CREATE OR REPLACE PACKAGE BODY CPI.gipir928e_pkg
AS
   /*
   **  Created by   :  Rdjmanalad
   **  Date Created : 6/5/2012
   **  Reference By : GIPIR928E - Production Report(Detailed)
   **  Description  : 
   */
    FUNCTION populate_gipir928e (
        p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_cd       gipi_uwreports_ext.iss_cd%TYPE,
        p_line_cd      gipi_uwreports_ext.line_cd%TYPE,
        p_scope        gipi_uwreports_ext.SCOPE%TYPE,
        p_subline_cd   gipi_uwreports_ext.subline_cd%TYPE,
        p_user_id      gipi_uwreports_ext.user_id%TYPE
    )
      RETURN report_tab PIPELINED AS
        rep            report_type;
    BEGIN
        FOR i IN(SELECT DISTINCT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd, 
                        DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd_header, 
                        g.iss_name iss_name,
                        b.line_cd line_cd,
                        e.line_name line_name,
                        b.subline_cd subline_cd,
                        f.subline_name subline_name,
                        SUM(NVL(b.fa_dist_prem,0)) fa_peril_prem,
                        SUM(NVL(b.nr_dist_prem,0)
                           +NVL(b.tr_dist_prem,0)
                           +NVL(b.fa_dist_prem,0))total_prem,
                        SUM(DECODE(c.peril_type,'B',NVL(b.nr_dist_tsi,0),0)
                           +DECODE(c.peril_type,'B',NVL(b.tr_dist_tsi,0),0)
                           +DECODE(c.peril_type,'B',NVL(b.fa_dist_tsi,0),0)) total_tsi,
                        SUM(DECODE(c.peril_type,'B',NVL(b.fa_dist_tsi,0),0)) fa_peril_tsi
                   FROM gipi_uwreports_dist_peril_ext b,  
                        giis_peril c,
                        giis_subline f,
                        giis_dist_share d,
                        giis_issource g,
                        giis_line e
                  WHERE 1 = 1
                    AND b.line_cd    = c.line_cd
                    AND b.peril_cd   = c.peril_cd
                    AND b.line_cd    = f.line_cd
                    AND b.subline_cd = f.subline_cd
                    AND b.line_cd    = d.line_cd
                    AND b.share_cd   = d.share_cd
                    AND b.line_cd   = e.line_cd
                    AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = g.iss_cd
                    AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL( p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                    AND b.line_cd=nvl(upper(p_line_cd),b.line_cd)
                    AND b.user_id = p_user_id -- marco - 02.05.2013 - changed from user
                    AND ((p_scope=3 AND b.endt_seq_no=b.endt_seq_no)
                     OR  (p_scope=1 AND b.endt_seq_no=0)
                     OR  (p_scope=2 AND b.endt_seq_no>0))
                    AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
					/* added security rights control by robert 01.02.14*/
					AND check_user_per_iss_cd2 (b.line_cd,DECODE (p_iss_param,1, b.cred_branch,b.iss_cd),'GIPIS901A', p_user_id) =1
					AND check_user_per_line2 (b.line_cd,DECODE (p_iss_param,1, b.cred_branch,b.iss_cd),'GIPIS901A', p_user_id) = 1
					/* robert 01.02.14 end of added code */
                  GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd), 
                        g.iss_name,
                        b.line_cd,
                        e.line_name,
                        b.subline_cd,
                        f.subline_name)
        LOOP
            rep.iss_cd              := i.iss_cd;
            rep.iss_cd_header       := i.iss_cd_header;
            rep.iss_name            := i.iss_name;
            rep.line_cd             := i.line_cd;
            rep.line_name           := i.line_name;
            rep.subline_cd          := i.subline_cd;
            rep.subline_name        := i.subline_name;
            rep.fa_peril_prem       := i.fa_peril_prem;
            rep.total_prem          := i.total_prem;
            rep.total_tsi           := i.total_tsi;
            rep.fa_peril_tsi        := i.fa_peril_tsi;
            rep.company_name        := giisp.v('COMPANY_NAME');
            rep.company_addr        := giisp.v('COMPANY_ADDRESS');
            
            SELECT to_date1, from_date1
              INTO rep.date_to, rep.date_from
              FROM gipi_uwreports_dist_peril_ext
             WHERE user_id = p_user_id
               AND ROWNUM = 1;
            
            IF p_iss_param = 1 THEN
                rep.iss_header     := 'Crediting Branch ';
            ELSIF p_iss_param = 2 THEN
                rep.iss_header     := 'Issue Source     ';
            ELSE 
                rep.iss_header     := NULL;
            END IF;
             
            PIPE ROW (rep);
        END LOOP;          
        RETURN;
   END;
   
    FUNCTION get_gipir928e_detail (
        p_iss_param    gipi_uwreports_ext.iss_cd%TYPE,
        p_iss_cd       gipi_uwreports_dist_peril_ext.iss_cd%TYPE,
        p_line_cd      gipi_uwreports_dist_peril_ext.line_cd%TYPE,
        p_scope        gipi_uwreports_ext.SCOPE%TYPE,
        p_subline_cd   gipi_uwreports_dist_peril_ext.subline_cd%TYPE,
        p_user_id      gipi_uwreports_dist_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
      RETURN rep_detail_tab PIPELINED AS
        rep            rep_detail_type;
    BEGIN
        FOR i IN( SELECT DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) iss_cd,
                         b.line_cd line_cd,
                         b.subline_cd subline_cd,
                         SUM(DECODE(c.peril_type,'B',NVL(DECODE(b.share_type,1,b.nr_dist_tsi,2,b.tr_dist_tsi,3,b.fa_dist_tsi),0),0))nr_peril_ts,
                         SUM(NVL(DECODE(B.SHARE_TYPE,1,b.nr_dist_prem,2,tr_dist_prem,fa_dist_prem),0)) nr_peril_prem,
                         b.share_cd share_cd,
                         d.subline_name,
                         b.trty_name
                    FROM gipi_uwreports_dist_peril_ext b,  
                         giis_peril c,
                         giis_subline d
                   WHERE 1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.subline_cd = d.subline_cd
                     AND b.line_cd = d.line_cd
                     AND DECODE(p_iss_param,1,b.cred_branch,b.iss_cd) = NVL(p_iss_cd, DECODE(p_iss_param,1,b.cred_branch,b.iss_cd))
                     AND b.line_cd=NVL(UPPER(p_line_cd),b.line_cd)
                     AND b.user_id = p_user_id -- marco - 02.05.2013 - changed from user
                     AND ((p_scope=3 AND b.endt_seq_no=b.endt_seq_no)
                      OR (p_scope=1 AND b.endt_seq_no=0)
                      OR (p_scope=2 AND b.endt_seq_no>0))
                     AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
                   GROUP BY DECODE(p_iss_param,1,b.cred_branch,b.iss_cd), 
                         b.line_cd,b.subline_cd,
                         b.share_type,
                         b.share_cd,
                         d.subline_name,
                         b.trty_name
                   ORDER BY b.share_cd)               
        LOOP
            rep.iss_cd              := i.iss_cd;
            rep.line_cd             := i.line_cd;
            rep.subline_cd          := i.subline_cd;
            rep.nr_peril_ts         := i.nr_peril_ts;
            rep.nr_peril_prem       := i.nr_peril_prem;
            rep.share_cd            := i.share_cd;
            rep.subline_name        := i.subline_name;
            rep.trty_name           := i.trty_name;
            PIPE ROW (rep);
        END LOOP;  
        RETURN; 
    END;  
      
END gipir928e_pkg;
/


