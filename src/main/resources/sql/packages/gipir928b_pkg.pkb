CREATE OR REPLACE PACKAGE BODY CPI.GIPIR928B_PKG
AS
    FUNCTION get_line (P_SUBLINE_CD GIIS_SUBLINE.SUBLINE_CD%TYPE, 
                       P_SCOPE NUMBER, 
                       P_ISS_CD GIPI_UWREPORTS_DIST_PERIL_EXT.ISS_CD%TYPE,
                       P_LINE_CD GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE, 
                       P_ISS_PARAM NUMBER,
                       p_user_id    GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE) -- marco - 02.05.2013 - added parameter
    RETURN gipir928b_tab PIPELINED
    IS
        v_data get_line_type;
        f_from VARCHAR2(50);
        f_to_date VARCHAR2(50);
        param_date NUMBER(1);
    BEGIN
    FOR rec IN (SELECT --a.acct_ent_date,
                        B.LINE_NAME      line_name,
                        B.LINE_CD        line_cd,
                        SUM (DECODE(A.peril_type,'A', 0,  NVL(A.NR_DIST_TSI, 0) ))   NET_RET_TSi,
                        SUM( NVL(A.NR_DIST_PREM, 0) ) NET_RET_PREM,
                        SUM(DECODE (A.peril_type, 'A',0, NVL(A.TR_DIST_TSI,0) ))  TREATY_TSI,
                        SUM( NVL(A.TR_DIST_PREM,0) ) TREATY_PREM,
                        SUM(DECODE(A. peril_type, 'A',0, NVL(A.FA_DIST_TSI,0) ))  FACULTATIVE_TSI,
                        SUM( NVL(A.FA_DIST_PREM,0) ) FACULTATIVE_PREM,
                        SUM(DECODE(A.peril_type,'A', 0,  NVL(A.NR_DIST_TSI,0) ) )  + SUM(DECODE (A.peril_type, 'A',0, NVL(A.TR_DIST_TSI,0) ))  + SUM(DECODE(A. peril_type, 'A',0, NVL(A.FA_DIST_TSI,0) ))   TOTAL_TSI,
                        SUM( NVL(A.NR_DIST_PREM,0) )  +  SUM( NVL(A.TR_DIST_PREM,0) ) + SUM( NVL(A.FA_DIST_PREM,0) )    tOTAL_PREMIUM
                   FROM GIPI_UWREPORTS_DIST_PERIL_EXT A,
                        GIIS_LINE    B,
                        GIIS_SUBLINE  C
                  WHERE A.LINE_CD = B.LINE_CD
                    AND A.SUBLINE_CD = C.SUBLINE_CD
                    AND A.LINE_CD = C.LINE_CD
                    --  AND a.iss_cd = NVL(UPPER(:p_iss_cd),a.iss_cd)
                    AND DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd))
                    AND a.line_cd = NVL(UPPER(P_LINE_CD),a.line_cd)
                    AND a.user_id = p_user_id
                    AND ((P_SCOPE=3 AND a.endt_seq_no=a.endt_seq_no)
                    OR  (P_SCOPE=1 AND a.endt_seq_no=0)
                    OR  (P_SCOPE=2 AND a.endt_seq_no>0))
                    AND a.subline_cd = NVL(P_SUBLINE_CD, a.subline_cd)
                  GROUP BY B.LINE_NAME, B.LINE_CD
                  ORDER BY b.LINE_NAME)
           LOOP
            v_data.line_name    := rec.line_name;
            v_data.line_cd      := rec.line_cd;
            v_data.net_ret_tsi  := rec.net_ret_tsi;
            v_data.net_ret_prem := rec.net_ret_prem;
            v_data.treaty_tsi   := rec.treaty_tsi;
            v_data.treaty_prem  := rec.treaty_prem;
            v_data.facultative_tsi := rec.facultative_tsi;
            v_data.facultative_prem := rec.facultative_prem;
            v_data.total_tsi := rec.total_tsi;
            v_data.total_premium := rec.total_premium;
            BEGIN
              SELECT param_value_v
              INTO v_data.v_company
              FROM giis_parameters
              WHERE param_name = 'COMPANY_NAME';
            END;
            v_data.address := giisp.v('COMPANY_ADDRESS');
            BEGIN
              SELECT TO_CHAR(from_date1, 'fmMonth DD, RRRR'), TO_CHAR(to_date1,'fmMonth DD, RRRR')
                INTO f_from, f_to_date
                FROM gipi_uwreports_dist_peril_ext
               WHERE user_id = p_user_id
                 AND ROWNUM = 1;
              v_data.fromto_date := 'From ' || f_from || ' to ' || f_to_date; 
            END;
            BEGIN
              SELECT param_date
              INTO param_date
              FROM gipi_uwreports_dist_peril_ext
              WHERE user_id = p_user_id
                AND ROWNUM = 1;
                
              if param_date = 1 THEN
                v_data.based_on := 'Based on Issue Date';
              ELSIF param_date = 2 THEN
                v_data.based_on := 'Based on Inception Date';
              ELSIF param_date = 3 THEN
                v_data.based_on := 'Based on Booking month - year';
              ELSIF param_date = 4 THEN
                v_data.based_on := 'Based on Acctg Entry Date';
              END IF;
            END;
            BEGIN
              IF P_SCOPE = 1 THEN
                v_data.policy_label := 'Policies Only';
              ELSIF P_SCOPE = 2 THEN
                v_data.policy_label := 'Endorsements Only';
              elsif P_SCOPE = 3 THEN
                v_data.policy_label := 'Policies and Endorsements';
              END IF;  	
            END;
            PIPE ROW(v_data);
           END LOOP;   
    END;
    FUNCTION get_subline (P_SUBLINE_CD GIIS_SUBLINE.SUBLINE_CD%TYPE, 
                           P_SCOPE NUMBER, 
                           P_ISS_CD GIPI_UWREPORTS_DIST_PERIL_EXT.ISS_CD%TYPE,
                           P_LINE_CD GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE, 
                           P_ISS_PARAM NUMBER,
                           P_LINE_CD1 GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE,
                           p_user_id    GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE) -- marco - 02.05.2013 - added parameter
    RETURN gipir928b_subline_tab PIPELINED
    IS
        v_data  get_subline_type;
    BEGIN
    FOR rec IN (SELECT --a.acct_ent_date,
                        C.SUBLINE_CD     subline_cd,

                        SUM (DECODE(A.peril_type,'A', 0,  NVL(A.NR_DIST_TSI, 0) ))   NET_RET_TSi,
                        SUM( NVL(A.NR_DIST_PREM, 0) ) NET_RET_PREM,
                        SUM(DECODE (A.peril_type, 'A',0, NVL(A.TR_DIST_TSI,0) ))  TREATY_TSI,
                        SUM( NVL(A.TR_DIST_PREM,0) ) TREATY_PREM,
                        SUM(DECODE(A. peril_type, 'A',0, NVL(A.FA_DIST_TSI,0) ))  FACULTATIVE_TSI,
                        SUM( NVL(A.FA_DIST_PREM,0) ) FACULTATIVE_PREM,
                        SUM(DECODE(A.peril_type,'A', 0,  NVL(A.NR_DIST_TSI,0) ) )  + SUM(DECODE (A.peril_type, 'A',0, NVL(A.TR_DIST_TSI,0) ))  + SUM(DECODE(A. peril_type, 'A',0, NVL(A.FA_DIST_TSI,0) ))   TOTAL_TSI,
                        SUM( NVL(A.NR_DIST_PREM,0) )  +  SUM( NVL(A.TR_DIST_PREM,0) ) + SUM( NVL(A.FA_DIST_PREM,0) )    tOTAL_PREMIUM
                   FROM GIPI_UWREPORTS_DIST_PERIL_EXT A,
                        GIIS_SUBLINE  C
                  WHERE A.LINE_CD = P_LINE_CD1
                    AND A.SUBLINE_CD = C.SUBLINE_CD
                    AND A.LINE_CD = C.LINE_CD
                    --  AND a.iss_cd = NVL(UPPER(:p_iss_cd),a.iss_cd)
                    AND DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd))
                    AND a.line_cd = NVL(UPPER(P_LINE_CD),a.line_cd)
                    AND a.user_id = p_user_id
                    AND ((P_SCOPE=3 AND a.endt_seq_no=a.endt_seq_no)
                    OR  (P_SCOPE=1 AND a.endt_seq_no=0)
                    OR  (P_SCOPE=2 AND a.endt_seq_no>0))
                    AND a.subline_cd = NVL(P_SUBLINE_CD, a.subline_cd)
                  GROUP BY C.subline_cd
                  ORDER BY c.subline_cd)
                  LOOP
                    v_data.subline_cd    := rec.subline_cd;
                    v_data.net_ret_tsi  := rec.net_ret_tsi;
                    v_data.net_ret_prem := rec.net_ret_prem;
                    v_data.treaty_tsi   := rec.treaty_tsi;
                    v_data.treaty_prem  := rec.treaty_prem;
                    v_data.facultative_tsi := rec.facultative_tsi;
                    v_data.facultative_prem := rec.facultative_prem;
                    v_data.total_tsi := rec.total_tsi;
                    v_data.total_premium := rec.total_premium;
                    PIPE ROW(v_data);
                  END LOOP;
    
    
    
    END;
    FUNCTION get_policy (P_SUBLINE_CD GIIS_SUBLINE.SUBLINE_CD%TYPE, 
                           P_SCOPE NUMBER, 
                           P_ISS_CD GIPI_UWREPORTS_DIST_PERIL_EXT.ISS_CD%TYPE,
                           P_LINE_CD GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE, 
                           P_ISS_PARAM NUMBER,
                           P_LINE_CD1 GIPI_UWREPORTS_DIST_PERIL_EXT.LINE_CD%TYPE,
                           P_SUBLINE_CD1 GIIS_SUBLINE.SUBLINE_CD%TYPE,
                           p_user_id    GIPI_UWREPORTS_DIST_PERIL_EXT.user_id%TYPE) -- marco - 02.05.2013 - added parameter
    RETURN gipir928b_policy_tab PIPELINED
    IS
        v_data   get_policy_type;
    BEGIN
        FOR rec IN (SELECT --a.acct_ent_date,
                        A.POLICY_NO     policy_no,

                        SUM (DECODE(A.peril_type,'A', 0,  NVL(A.NR_DIST_TSI, 0) ))   NET_RET_TSi,
                        SUM( NVL(A.NR_DIST_PREM, 0) ) NET_RET_PREM,
                        SUM(DECODE (A.peril_type, 'A',0, NVL(A.TR_DIST_TSI,0) ))  TREATY_TSI,
                        SUM( NVL(A.TR_DIST_PREM,0) ) TREATY_PREM,
                        SUM(DECODE(A. peril_type, 'A',0, NVL(A.FA_DIST_TSI,0) ))  FACULTATIVE_TSI,
                        SUM( NVL(A.FA_DIST_PREM,0) ) FACULTATIVE_PREM,
                        SUM(DECODE(A.peril_type,'A', 0,  NVL(A.NR_DIST_TSI,0) ) )  + SUM(DECODE (A.peril_type, 'A',0, NVL(A.TR_DIST_TSI,0) ))  + SUM(DECODE(A. peril_type, 'A',0, NVL(A.FA_DIST_TSI,0) ))   TOTAL_TSI,
                        SUM( NVL(A.NR_DIST_PREM,0) )  +  SUM( NVL(A.TR_DIST_PREM,0) ) + SUM( NVL(A.FA_DIST_PREM,0) )    tOTAL_PREMIUM
                   FROM GIPI_UWREPORTS_DIST_PERIL_EXT A,
                        GIIS_SUBLINE  C
                  WHERE A.LINE_CD = P_LINE_CD1
                    AND A.SUBLINE_CD = P_SUBLINE_CD1
                    AND A.LINE_CD = C.LINE_CD
                    AND a.subline_cd = c.subline_cd -- added by apollo cruz 05.07.2015 for proper joining of tables - GENQA sr#4365
                    --  AND a.iss_cd = NVL(UPPER(:p_iss_cd),a.iss_cd)
                    AND DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd))
                    AND a.line_cd = NVL(UPPER(P_LINE_CD),a.line_cd)
                    AND a.user_id = p_user_id
                    AND ((P_SCOPE=3 AND a.endt_seq_no=a.endt_seq_no)
                    OR  (P_SCOPE=1 AND a.endt_seq_no=0)
                    OR  (P_SCOPE=2 AND a.endt_seq_no>0))
                    AND a.subline_cd = NVL(P_SUBLINE_CD, a.subline_cd)
                  GROUP BY a.policy_no
                  ORDER BY a.policy_no)
     LOOP
     v_data.policy_no    := rec.policy_no;
     v_data.net_ret_tsi  := rec.net_ret_tsi;
     v_data.net_ret_prem := rec.net_ret_prem;
     v_data.treaty_tsi   := rec.treaty_tsi;
     v_data.treaty_prem  := rec.treaty_prem;
     v_data.facultative_tsi := rec.facultative_tsi;
     v_data.facultative_prem := rec.facultative_prem;
     v_data.total_tsi := rec.total_tsi;
     v_data.total_premium := rec.total_premium;
     PIPE ROW(v_data);
     
     
     END LOOP;
    
    
     END;
   
END gipir928b_pkg;
/


