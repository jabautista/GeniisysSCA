DROP FUNCTION CPI.GIPIS002A_VALIDATE_REF_POL_NO;

CREATE OR REPLACE FUNCTION CPI.GIPIS002A_VALIDATE_REF_POL_NO (
 p_pack_par_id          GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
 p_ref_pol_no           GIPI_PACK_WPOLBAS.ref_pol_no%TYPE
)
RETURN VARCHAR2

IS
  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : March 15, 2011
  **  Reference By : (GIPIS002A - Package PAR Basic Information)
  **  Description  : Function validates if ref pol no is already existing in other policies/Package PAR
  */
  
    v_msg           VARCHAR2(5000);
    v_policy_no     VARCHAR2(5000);
    v_par_no        VARCHAR2(5000);
    v_cnt1          NUMBER:=0;
    v_cnt2          NUMBER:=0;
    
BEGIN
  
      FOR A IN (SELECT line_cd||'-'||
                       subline_cd||'-'||
                       iss_cd||'-'||
                       LTRIM(TO_CHAR(issue_yy,'09'))||'-'||
                       LTRIM(TO_CHAR(pol_seq_no,'0000009'))||'-'||
                       LTRIM(TO_CHAR(renew_no,'09')) policy_no
                  FROM GIPI_PACK_POLBASIC
                 WHERE pol_flag IN ('1','2','3','4','X')
                   AND ref_pol_no = p_ref_pol_no)
      LOOP
        IF v_cnt1 <= 5 THEN
          v_policy_no := v_policy_no||', '||A.policy_no;
        END IF;
        v_cnt1 := v_cnt1+1;             
      END LOOP;
           
      IF v_policy_no IS NOT NULL THEN
        /*IF v_cnt1 > 5 THEN
           v_msg := 'Reference Policy No. '||p_ref_pol_no||' already exists in VARIOUS POLICIES.';
        ELSE
           v_policy_no := LTRIM(v_policy_no,', ');
           v_msg := 'Reference Policy No. '||p_ref_pol_no||' already exists in Policy No(s). '||v_policy_no||'.';
        END IF;*/
        v_policy_no := LTRIM(v_policy_no,', ');
        v_msg := 'Reference Policy No. '||p_ref_pol_no||' already exists in Policy No(s). '||v_policy_no||'.';
      END IF;
             
      FOR B IN (SELECT b.line_cd||'-'||
                       b.iss_cd||'-'||
                       LTRIM(TO_CHAR(b.par_yy,'09'))||'-'|| 
                       LTRIM(TO_CHAR(b.par_seq_no,'000009'))||'-'||
                       LTRIM(TO_CHAR(b.quote_seq_no,'09')) par_no
                  FROM GIPI_PACK_WPOLBAS a,
                       GIPI_PACK_PARLIST b
                 WHERE a.pack_par_id = b.pack_par_id
                   AND a.ref_pol_no = p_ref_pol_no
                   AND b.pack_par_id <> p_pack_par_id)
      LOOP
        IF v_cnt2 <= 5 THEN
          v_par_no := v_par_no||', '||B.par_no;                             
        END IF;
        v_cnt2:=v_cnt2+1;
      END LOOP;     
          
      v_msg := v_msg||'-*|@geniisys@|*-';
          
      IF v_par_no IS NOT NULL THEN
        /*IF v_cnt2 > 5 THEN
           v_msg := v_msg||'Reference Policy No. '||p_ref_pol_no||' already exists in VARIOUS PAR(s).';
        ELSE
           v_par_no := LTRIM(v_par_no,', ');
           v_msg := v_msg||'Reference Policy No. '||p_ref_pol_no||' already exists in Par No(s). '||v_par_no||'.';          
        END IF;*/
        v_par_no := LTRIM(v_par_no,', ');
        v_msg := v_msg||'Reference Policy No. '||p_ref_pol_no||' already exists in Par No(s). '||v_par_no||'.';
      END IF;  
  RETURN v_msg;
END;
/


