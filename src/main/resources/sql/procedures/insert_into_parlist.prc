DROP PROCEDURE CPI.INSERT_INTO_PARLIST;

CREATE OR REPLACE PROCEDURE CPI.insert_into_parlist (
    p_policy_id          IN gipi_polbasic.policy_id%type,
    p_assd_no            IN gipi_polbasic.assd_no%TYPE,
    p_par_yy             IN gipi_parlist.par_yy%TYPE,
    p_new_par_id        OUT NUMBER,
    p_msg               OUT VARCHAR2,
    p_proc_renew_flag    IN VARCHAR2,
    p_new_pack_par_id    IN VARCHAR2,
    p_user               IN gipi_parhist.user_id%TYPE,
    p_proc_same_polno_sw    IN  giex_expiry.same_polno_sw%TYPE  --nieko 07212016 SR 22730, KB 3722
) 
IS
  x_renew_flag     VARCHAR2(2);
  v_remarks        gipi_parlist.remarks%TYPE;
  v_status         gipi_parlist.par_status%TYPE;
  v_iss_cd         gipi_parlist.iss_cd%TYPE;--vj 03.31.09
  var_iss_cred     giis_parameters.param_value_v%TYPE:=giisp.v('CRED_BRANCH_RENEWAL'); --03.31.09
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : insert_into_parlist program unit 
  */
  BEGIN
     p_new_par_id := NULL;
    SELECT parlist_par_id_s.nextval
      INTO p_new_par_id
      FROM DUAL;            
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        --BELL;
        p_msg := 'Cannot generate new PAR ID.';
        --RAISE FORM_TRIGGER_FAILURE;
  END;
    
  BEGIN
   --beth 09192000 load_tag = 'R'
   --     load tag is used to determine how does a PAR is created
    FOR A IN (
      SELECT   line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no,cred_branch --cred_branch added by VJ 03.31.09
        FROM   gipi_polbasic
       WHERE   policy_id  =  p_policy_id) LOOP
          
      FOR rem IN (SELECT remarks
                    FROM giex_expiry
                   WHERE policy_id  =  p_policy_id) LOOP
          v_remarks := rem.remarks;
          EXIT;
      END LOOP;                          

   --inserted by bdarusin, aug 22, 2001
   --gipi_parlist.status = 2 if policy is for renewal, 10 if for auto-renewal
       IF p_proc_renew_flag = 2 THEN
          v_status  :=  2;
       ELSIF p_proc_renew_flag = 3 THEN
          v_status  :=  10;
       END IF;
                           
       IF v_remarks IS NULL THEN
          v_remarks :=  a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                 a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no;
       ELSE
             v_remarks :=  a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||
                                 a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no||' '||v_remarks;
       END IF;
           
        /*code added by VJ 03.31.09*/
        IF NVL(var_iss_cred,'N')='Y' THEN 
          v_iss_cd := a.cred_branch;
        ELSIF  NVL(var_iss_cred,'N')='N' THEN 
          v_iss_cd := a.iss_cd;
        END IF;
        /*end, 03.31.09*/ 
        
        --added by apollo cruz 02.12.2015
        IF NVL(giisp.v('ALLOW_OTHER_BRANCH_RENEWAL'), 'N') = 'Y' THEN
           v_iss_cd := get_user_iss_cd(p_user);
        END IF;
        
        IF NVL(p_proc_same_polno_sw,'N') = 'Y' THEN
           v_iss_cd := a.iss_cd;
        END IF;          
           
       INSERT INTO gipi_parlist
         (par_id,            line_cd,                iss_cd,
         par_yy,      quote_seq_no,        par_type,
         assd_no,            underwriter,        assign_sw, 
         par_status,     load_tag,             remarks,
         pack_par_id)
       VALUES (
            p_new_par_id,        a.line_cd,        /*A.iss_cd*/v_iss_cd,--replaced by VJ 03.31.09
         p_par_yy,                                0,                'P',
         p_assd_no,                                p_user,                    'Y',
         v_status,                                'R',                     v_remarks,
         p_new_pack_par_id);
       
                
      /* The parstat_cd of the existing PAR should be in coherence with the
      ** renew flag of the corresponding record being processed.
      ** Updated by  : MiB
      ** Last Update : 10 September 1997
      */
      IF p_proc_renew_flag = 2 THEN
         x_renew_flag  :=  'R';
      ELSIF p_proc_renew_flag = 3 THEN
         x_renew_flag  :=  'A';
      END IF;
      INSERT INTO gipi_parhist (
        par_id,                                user_id,                parstat_date,
        entry_source,                    parstat_cd)
      VALUES(
           p_new_par_id,    p_user,                        sysdate,
           'DB',                                    x_renew_flag);
      EXIT;
    END LOOP;
  END; 
END;
/


