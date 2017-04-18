CREATE OR REPLACE PACKAGE BODY CPI.GIPIR928C_PKG
AS

/* created by rmanalad  5/24/2012
*  
*
*/
    FUNCTION get_main_data(
        p_iss_cd            gipi_uwreports_dist_peril_ext.iss_cd%type,
        p_iss_param         NUMBER, 
        p_line_cd           gipi_uwreports_dist_peril_ext.line_cd%type, 
        p_scope             NUMBER, 
        p_subline_cd        gipi_uwreports_dist_peril_ext.subline_cd%type,
        p_user_id           gipi_uwreports_dist_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
    )
      RETURN main_tab PIPELINED IS
        v_main_data         get_main_data_type;
        v_param_date        NUMBER;
    BEGIN
        FOR rec IN (SELECT b.line_name line_name,
                           c.subline_cd subline_cd,
                           d.peril_name peril_name,
                           DECODE (a.peril_type, 'A', 0, SUM (NVL (a.nr_dist_tsi, 0))) nrdisttsi,
                           SUM (NVL (a.nr_dist_prem, 0)) nrdistprem,
                           DECODE (a.peril_type, 'A', 0, SUM (NVL (a.tr_dist_tsi, 0))) trdisttsi,
                           SUM (NVL (a.tr_dist_prem, 0)) trdistprem,
                           DECODE (a.peril_type, 'A', 0, SUM (NVL (a.fa_dist_tsi, 0))) fadisttsi,
                           SUM (NVL (a.fa_dist_prem, 0)) fadistprem,
                           DECODE (a.peril_type, 'A', 0, SUM (NVL (a.nr_dist_tsi, 0)))
                               + DECODE (a.peril_type, 'A', 0, SUM (NVL (a.tr_dist_tsi, 0)))
                               + DECODE (a.peril_type, 'A', 0, SUM (NVL (a.fa_dist_tsi, 0)))totaltsi,
                           SUM (NVL (a.nr_dist_prem, 0))
                               + SUM (NVL (a.tr_dist_prem, 0))
                               + SUM (NVL (a.fa_dist_prem, 0)) totalprem
                      FROM gipi_uwreports_dist_peril_ext a,
                           giis_line b,
                           giis_subline c,
                           giis_peril d
                     WHERE a.line_cd    = b.line_cd
                       AND a.line_cd    = c.line_cd
                       AND a.subline_cd = c.subline_cd
                       AND a.line_cd    = d.line_cd
                       AND a.peril_cd   = d.peril_cd
                       AND DECODE (P_ISS_PARAM, 1, a.cred_branch, a.iss_cd) =
                           NVL (P_ISS_CD, DECODE (P_ISS_PARAM, 1, a.cred_branch, a.iss_cd))
                       AND a.line_cd = NVL (UPPER (P_LINE_CD), a.line_cd)
                       AND a.user_id = p_user_id -- marco - 02.05.2013 - changed from user
                       AND ((P_SCOPE = 3 AND a.endt_seq_no = a.endt_seq_no)
                        OR (P_SCOPE = 1 AND a.endt_seq_no = 0)
                        OR (P_SCOPE = 2 AND a.endt_seq_no > 0))
                       AND a.subline_cd = NVL (P_SUBLINE_CD, a.subline_cd)
                     GROUP BY b.line_name,
                           c.subline_cd,
                           d.peril_name, 
                           a.peril_type
                     ORDER BY b.line_name,
                           c.subline_cd,
                           d.peril_name, 
                           a.peril_type)
        LOOP
            v_main_data.line_name       := rec.line_name;
            v_main_data.subline_cd      := rec.subline_cd;
            v_main_data.peril_name      := rec.peril_name;
            v_main_data.nrdisttsi       := rec.nrdisttsi;
            v_main_data.nrdistprem      := rec.nrdistprem;
            v_main_data.trdisttsi       := rec.trdisttsi;
            v_main_data.trdistprem      := rec.trdistprem;
            v_main_data.fadisttsi       := rec.fadisttsi;
            v_main_data.fadistprem      := rec.fadistprem;
            v_main_data.totaltsi        := rec.totaltsi;
            v_main_data.totalprem       := rec.totalprem;
            v_main_data.company_name    := giisp.v('COMPANY_NAME');
            v_main_data.company_address := giisp.v('COMPANY_ADDRESS');
        
            BEGIN  
                IF P_SCOPE = 1 THEN
                    v_main_data.toggle := 'Policies Only';
                ELSIF P_SCOPE = 2 THEN
                    v_main_data.toggle := 'Endorsements Only';
                ELSIF P_SCOPE = 3 THEN
                    v_main_data.toggle := 'Policies and Endorsements';
                END IF;
            END;
        
            BEGIN
                SELECT from_date1, 
                       to_date1,
                       param_date
                  INTO v_main_data.date_from, 
                       v_main_data.date_to,
                       v_param_date
                  FROM gipi_uwreports_dist_peril_ext
                 WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from user
                   AND ROWNUM = 1;
                
                --v_main_data.date_from := '1-apr-2012'; -- comment out by marco - hardcoded? :(
                --v_main_data.date_to := '30-apr-2012';
                
                IF v_param_date = 1 THEN
                    v_main_data.based_on := 'Based on Issue Date';
                ELSIF v_param_date = 2 THEN
                    v_main_data.based_on := 'Based on Inception Date';
                ELSIF v_param_date = 3 THEN
                    v_main_data.based_on := 'Based on Booking month - year';
                ELSIF v_param_date = 4 THEN
                    v_main_data.based_on := 'Based on Acctg Entry Date';
                END IF; 
            END;
        
            PIPE ROW (v_main_data);
        END LOOP;
        RETURN;
    END;
    
END gipir928c_pkg;
/


