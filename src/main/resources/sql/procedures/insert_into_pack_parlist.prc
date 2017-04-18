DROP PROCEDURE CPI.INSERT_INTO_PACK_PARLIST;

CREATE OR REPLACE PROCEDURE CPI.insert_into_pack_parlist (
    p_policy_id         IN  gipi_polbasic.policy_id%type,
    p_assd_no           IN  gipi_polbasic.assd_no%TYPE,
    p_par_yy            IN  gipi_parlist.par_yy%TYPE,
    p_new_par_id        OUT NUMBER,
    p_new_pack_par_id   OUT NUMBER,
    p_msg               OUT VARCHAR2,
    p_proc_renew_flag   IN  VARCHAR2,
    p_user              IN  gipi_pack_parlist.underwriter%TYPE,
    p_proc_same_polno_sw    IN  giex_expiry.same_polno_sw%TYPE  --nieko 07212016 SR 22730, KB 3722   
) 
IS
  x_renew_flag     VARCHAR2(2);
  v_remarks        gipi_parlist.remarks%TYPE;
  v_status         gipi_parlist.par_status%TYPE;
  v_issue_cd       giis_issource.iss_cd%TYPE;       --nieko 07212016 SR 22730, KB 3722  
BEGIN
  /*
  **  Created by   : Robert Virrey
  **  Date Created : 10-13-2011  
  **  Reference By : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL) 
  **  Description  : insert_into_pack_parlist program unit 
  */
  BEGIN
    SELECT gipi_pack_parlist_par_id.nextval
      INTO p_new_par_id
      FROM DUAL;            
      p_new_pack_par_id := p_new_par_id;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        --BELL;
        p_msg := 'Cannot generate new PACK PAR ID.';
        --RAISE FORM_TRIGGER_FAILURE;
  END;
  
  --nieko 07212016 SR 22730, KB 3722  
  BEGIN
    IF NVL(giisp.v('CRED_BRANCH_RENEWAL'), 'N')='Y' THEN 
      SELECT cred_branch
        INTO v_issue_cd
        FROM gipi_pack_polbasic
       WHERE pack_policy_id = p_policy_id; 
    ELSIF NVL(giisp.v('ALLOW_OTHER_BRANCH_RENEWAL'), 'N')='Y' THEN 
      v_issue_cd := get_user_iss_cd(p_user);
    END IF;
  END;
    
  BEGIN
   --beth 09192000 load_tag = 'R'
   --     load tag is used to determine how does a PAR is created
    FOR A IN (
      SELECT   line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
        FROM   gipi_pack_polbasic
       WHERE   pack_policy_id  =  p_policy_id) 
    LOOP
          
      FOR rem IN (SELECT remarks
                    FROM giex_pack_expiry
                   WHERE pack_policy_id  =  p_policy_id) 
      LOOP
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
       
       --nieko 07212016 SR 22730, KB 3722
       IF NVL(p_proc_same_polno_sw,'N') = 'Y' THEN
          v_issue_cd := a.iss_cd;
       END IF;
           
       INSERT INTO gipi_pack_parlist
         (pack_par_id,            line_cd,                iss_cd,
          par_yy,           quote_seq_no,        par_type,
          assd_no,                underwriter,        assign_sw, 
          par_status,         remarks)
       VALUES (
         p_new_par_id,        a.line_cd,        /*A.iss_cd,*/NVL(v_issue_cd, a.iss_cd),    --nieko 07212016 SR 22730, KB 3722
         p_par_yy,                                0,                'P',
         p_assd_no,                                p_user,                    'Y',
         v_status,                                v_remarks);
           
                    
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
          INSERT INTO gipi_pack_parhist (
            pack_par_id,                    user_id,                parstat_date,
            entry_source,                    parstat_cd)
          VALUES(
               p_new_par_id,    p_user,                        sysdate,
               'DB',                                    x_renew_flag);
          EXIT;
    END LOOP;
  END; 
  
END insert_into_pack_parlist;
/


