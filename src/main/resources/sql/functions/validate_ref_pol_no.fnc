DROP FUNCTION CPI.VALIDATE_REF_POL_NO;

CREATE OR REPLACE FUNCTION CPI.Validate_Ref_Pol_No (
	   p_par_id	  		   GIPI_WPOLBAS.par_id%TYPE,
	   p_ref_pol_no		   GIPI_WPOLBAS.ref_pol_no%TYPE
	   )
	RETURN VARCHAR2
	IS
	v_msg		    VARCHAR2(5000);
    v_policy_no     VARCHAR2(5000);
	v_par_no        VARCHAR2(5000);
	v_cnt1		    NUMBER:=0;
	v_cnt2		    NUMBER:=0;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : to validate if ref pol no is already existing in other policy/PAR
  */
  /*B540_Refpolno_Wvi_A_Gipis002(p_ref_pol_no, v_policy_no);
  IF v_policy_no IS NOT NULL THEN
  	 v_policy_no := LTRIM(v_policy_no,', ');
     v_msg := 'Reference Policy No. '||p_ref_pol_no||' already exists in Policy No(s). '||v_policy_no;
  END IF;
     
  B540_Refpolno_Wvi_B_Gipis002(p_ref_pol_no, p_par_id, v_par_no);
   
  IF v_par_no IS NOT NULL THEN
  	 v_par_no := LTRIM(v_par_no,', ');
     v_msg := 'Reference Policy No. '||p_ref_pol_no||' already exists in Par No(s). '||v_par_no;	          
  END IF;*/
      FOR A IN (SELECT line_cd||'-'||
                       subline_cd||'-'||
                       iss_cd||'-'||
                       ltrim(to_char(issue_yy,'09'))||'-'||
                       ltrim(to_char(pol_seq_no,'0000009'))||'-'||
                       ltrim(to_char(renew_no,'09')) policy_no
                  FROM gipi_polbasic
                 WHERE pol_flag in ('1','2','3','4','X')
                   AND ref_pol_no = p_ref_pol_no)
      LOOP
        IF v_cnt1 <= 5 THEN
          v_policy_no := v_policy_no||', '||A.policy_no;
        END IF;
        v_cnt1 := v_cnt1+1;             
      END LOOP;
       
      IF v_policy_no IS NOT NULL THEN
        IF v_cnt1 > 5 THEN
           v_msg := 'Reference Policy No. '||p_ref_pol_no||' already exists in VARIOUS POLICIES.';
        ELSE
           v_policy_no := ltrim(v_policy_no,', ');
           v_msg := 'Reference Policy No. '||p_ref_pol_no||' already exists in Policy No(s). '||v_policy_no||'.';
        END IF;
      END IF;
         
      FOR B IN (SELECT b.line_cd||'-'||
                       b.iss_cd||'-'||
                       ltrim(to_char(b.par_yy,'09'))||'-'|| 
                       ltrim(to_char(b.par_seq_no,'000009'))||'-'||
                       ltrim(to_char(b.quote_seq_no,'09')) par_no
                  FROM gipi_wpolbas a,
                       gipi_parlist b
                 WHERE a.par_id = b.par_id
                   AND a.ref_pol_no = p_ref_pol_no
                   AND b.par_id <> p_par_id)
      LOOP
        IF v_cnt2 <= 5 THEN
          v_par_no := v_par_no||', '||B.par_no;     	         	 	  
        END IF;
        v_cnt2:=v_cnt2+1;
      END LOOP;	 
      
      v_msg := v_msg||'-*|@geniisys@|*-';
      
      IF v_par_no IS NOT NULL THEN
        IF v_cnt2 > 5 THEN
           v_msg := v_msg||'Reference Policy No. '||p_ref_pol_no||' already exists in VARIOUS PAR(s).';
        ELSE
           v_par_no := ltrim(v_par_no,', ');
           v_msg := v_msg||'Reference Policy No. '||p_ref_pol_no||' already exists in Par No(s) '||v_par_no||'.';          
        END IF;
      END IF;  
  RETURN v_msg;
END;
/


