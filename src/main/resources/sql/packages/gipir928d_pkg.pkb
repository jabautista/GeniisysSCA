CREATE OR REPLACE PACKAGE BODY CPI.GIPIR928D_PKG
AS
	/*
   **  Created by   :  Steven Ramirez
   **  Date Created : 05.31.2012
   **  Reference By : GIPIR928D - Underwriting Production Report(Distribution -Dist Reg per Line Subline)
   **  Description  :
   */
   	
	FUNCTION populate_gipir928d(
		P_ISS_CD  gipi_uwreports_dist_peril_ext.iss_cd%type, 
		P_ISS_PARAM NUMBER,
		P_LINE_CD  gipi_uwreports_dist_peril_ext.line_cd%type, 
		P_SCOPE NUMBER, 
		P_SUBLINE_CD gipi_uwreports_dist_peril_ext.subline_cd%type,
        p_user_id    gipi_uwreports_dist_peril_ext.user_id%TYPE -- marco - 02.05.2013 - added parameter
		)
      RETURN report_tab PIPELINED
   IS
      rep  report_type;
      v_param_date NUMBER;
	  v_date_from 	DATE;
	  v_date_to 	DATE;
   BEGIN
   
   
   FOR i IN (SELECT INITCAP( B.LINE_NAME) line_name,
       INITCAP(C.SUBLINE_NAME) subline_name,
       COUNT( DISTINCT A.POLICY_NO) policies,
       SUM (decode( a.peril_type,'A',0, NVL(A.NR_DIST_TSI,0) )) net_ret_tsi,
       SUM( NVL(A.NR_DIST_PREM,0)) net_ret_premium,
       SUM( decode( a.peril_type,'A',0, NVL(A.TR_DIST_TSI,0))) treaty_tsi,
       SUM( NVL(A.TR_DIST_PREM,0)) treaty_premium,
       SUM( decode( a.peril_type, 'A',0, NVL(A.FA_DIST_TSI,0))) facultative_tsi,
       SUM( NVL(A.FA_DIST_PREM,0)) facultative_premium,
       SUM( decode( a.peril_type,'A',0, NVL(A.NR_DIST_TSI,0) )) + SUM( decode( a.peril_type,'A',0, NVL(A.TR_DIST_TSI,0) )) + SUM( decode( a.peril_type, 'A',0, NVL(A.FA_DIST_TSI,0))) total_sum_sinsured,
       SUM( NVL(A.NR_DIST_PREM,0)) + SUM( NVL(A.TR_DIST_PREM,0)) + SUM( NVL(A.FA_DIST_PREM,0)) total_premium
		FROM  gipi_uwreports_dist_peril_ext  A,    
			   GIIS_LINE    B,                
			   GIIS_SUBLINE  C
		WHERE A.LINE_CD = B.LINE_CD
		  	AND A.SUBLINE_CD = C.SUBLINE_CD
		  	AND A.LINE_CD = C.LINE_CD
			AND DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd) = NVL( P_ISS_CD, DECODE(P_ISS_PARAM,1,a.cred_branch,a.iss_cd))
		  	AND a.line_cd = NVL(UPPER(P_LINE_CD),a.line_cd)
		 	AND a.user_id = p_user_id -- marco - 02.05.2013 - changed from user
			AND ((P_SCOPE=3 AND a.endt_seq_no=a.endt_seq_no)
					OR  (P_SCOPE=1 AND a.endt_seq_no=0)
					OR  (P_SCOPE=2 AND a.endt_seq_no>0))
			AND a.subline_cd = NVL(P_SUBLINE_CD, a.subline_cd)
			GROUP BY B.LINE_NAME, C.SUBLINE_NAME)
   
    LOOP
        rep.line_name     	  	:= i.line_name;
		rep.subline_name      	:= i.subline_name;
		rep.policy_no			:= i.policies;
        rep.nr_dist_tsi   	 	:= i.net_ret_tsi;
        rep.nr_dist_prem    	:= i.net_ret_premium;
        rep.tr_dist_tsi    	 	:= i.treaty_tsi;
        rep.tr_dist_prem    	:= i.treaty_premium;
        rep.fa_dist_tsi     	:= i.facultative_tsi;
        rep.fa_dist_prem    	:= i.facultative_premium;
        rep.total_sum_sinsured  := i.total_sum_sinsured;
        rep.total_premium       := i.total_premium;
        rep.company_name    := giisp.v('COMPANY_NAME');
        rep.company_address := giisp.v('COMPANY_ADDRESS');
        
        BEGIN  
            if P_SCOPE = 1 then
                rep.toggle := 'Policies Only';
            elsif P_SCOPE = 2 then
                rep.toggle := 'Endorsements Only';
            elsif P_SCOPE = 3 then
                rep.toggle := 'Policies and Endorsements';
            end if;
        END;
        
        
        BEGIN
            SELECT from_date1, 
                   to_date1,
                   param_date
            INTO v_date_from, 
                 v_date_to,
                 v_param_date
            FROM gipi_uwreports_dist_peril_ext
            WHERE user_id = p_user_id -- marco - 02.05.2013 - changed from user
            AND ROWNUM = 1;
            
            rep.date_from := v_date_from;
            rep.date_to := v_date_to;
            
            IF v_param_date = 1 THEN
                rep.based_on := 'Based on Issue Date';
            ELSIF v_param_date = 2 THEN
                rep.based_on := 'Based on Inception Date';
            ELSIF v_param_date = 3 THEN
                rep.based_on := 'Based on Booking month - year';
            ELSIF v_param_date = 4 THEN
                rep.based_on := 'Based on Acctg Entry Date';
            END IF; 
        END;
		
        PIPE ROW (rep);
		
    END LOOP;
   
   RETURN;
   END;
	
END gipir928D_pkg;
/


