CREATE OR REPLACE PACKAGE BODY CPI.GIAC_PARENT_COMM_INVOICE_PKG
AS
  /*
  **  Created by   :  Emman
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets the names of the parent and the child intermediary.
  */ 
  PROCEDURE get_parent_child_intm_name(p_intm_no              IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
                                    p_chld_intm_no    IN     GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
                                  p_iss_cd            IN       GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
                                  p_prem_seq_no        IN       GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
                                  p_intm_name           OUT GIIS_INTERMEDIARY.intm_name%TYPE,
                                  p_child_intm_name       OUT GIIS_INTERMEDIARY.intm_name%TYPE)
  IS
  BEGIN
           SELECT B.INTM_NAME,C.INTM_NAME PARENT
           INTO P_CHILD_INTM_NAME, P_INTM_NAME
           FROM GIAC_PARENT_COMM_INVOICE A,
                GIIS_INTERMEDIARY B,
                GIIS_INTERMEDIARY C
          WHERE A.INTM_NO=P_INTM_NO
            AND A.CHLD_INTM_NO=P_CHLD_INTM_NO
            AND A.INTM_NO=C.INTM_NO
            AND A.CHLD_INTM_NO=B.INTM_NO
            AND A.ISS_CD=P_ISS_CD
            AND A.PREM_SEQ_NO=P_PREM_SEQ_NO;
  END;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.12.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets the names of assured
  */ 
  PROCEDURE get_assd_policy_name (p_intm_no              IN     GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
                                    p_chld_intm_no    IN     GIAC_OVRIDE_COMM_PAYTS.chld_intm_no%TYPE,
                                  p_iss_cd            IN       GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
                                  p_prem_seq_no        IN       GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
                                  p_policy_no           OUT GIIS_INTERMEDIARY.intm_name%TYPE,
                                  p_assd_name              OUT GIIS_INTERMEDIARY.intm_name%TYPE)
  IS
  BEGIN
          SELECT E.ASSD_NAME,
           DECODE(A.ENDT_SEQ_NO,0,(A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||TO_CHAR(A.ISSUE_YY)||
               '-'||LTRIM(TO_CHAR(A.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(A.RENEW_NO,'09'))||'-'||
               A.ENDT_ISS_CD||'-'||TO_CHAR(A.ENDT_YY)||'-'||TO_CHAR(A.ENDT_SEQ_NO)||'-'||A.ENDT_TYPE),
               (A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||TO_CHAR(A.ISSUE_YY)||
               '-'||LTRIM(TO_CHAR(A.POL_SEQ_NO,'0999999'))||'-'||LTRIM(TO_CHAR(A.RENEW_NO,'09')))) POLICY_NO
          INTO P_ASSD_NAME, P_POLICY_NO
          FROM GIPI_POLBASIC A,
               GIPI_INVOICE B,
               GIPI_PARLIST C,
               GIAC_PARENT_COMM_INVOICE D,
               GIIS_ASSURED E
         WHERE E.ASSD_NO=C.ASSD_NO
           AND C.PAR_ID=A.PAR_ID
           AND A.POLICY_ID=B.POLICY_ID
           AND B.ISS_CD=D.ISS_CD
           AND B.PREM_SEQ_NO=D.PREM_SEQ_NO
           AND D.INTM_NO=P_INTM_NO
           AND D.CHLD_INTM_NO=P_CHLD_INTM_NO
           AND D.PREM_SEQ_NO=P_PREM_SEQ_NO
           AND D.ISS_CD=P_ISS_CD;
  END;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.13.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets issue source code of specified module
  */ 
  FUNCTION get_iss_cd_per_module (p_module_name           VARCHAR2,
                                  p_user_id giis_users.user_id%type)
    RETURN issue_source_tab PIPELINED
  IS
      v_issue_source                      issue_source_type;
  BEGIN
    FOR i IN (SELECT DISTINCT a.iss_cd, b.iss_name 
                FROM giac_parent_comm_invoice a, giis_issource b 
               WHERE a.iss_cd=b.iss_cd 
                 AND a.iss_cd = DECODE(CHECK_USER_PER_ISS_CD_ACCTG2(null, a.iss_cd, p_module_name, p_user_id), 1, a.iss_cd, NULL)
            ORDER BY a.iss_cd)
    LOOP
        v_issue_source.iss_cd     := i.iss_cd;
        v_issue_source.iss_name := i.iss_name;
    
        PIPE ROW(v_issue_source);
    END LOOP;
  END get_iss_cd_per_module;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.13.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets the list of intermediaries
  */ 
  FUNCTION get_intermediary_listing(p_iss_cd          GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
                                         p_prem_seq_no      GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE)
    RETURN intermediary_listing_tab PIPELINED
  IS
      v_intm_listing                    intermediary_listing_type;
  BEGIN
      FOR i IN (SELECT DISTINCT(a.intm_no), b.intm_name 
                FROM giac_parent_comm_invoice a, giis_intermediary b 
               WHERE a.intm_no = b.intm_no 
                 AND a.iss_cd = p_iss_cd 
                 AND a.prem_seq_no = p_prem_seq_no)
    LOOP
        v_intm_listing.intm_no                  := i.intm_no;
        v_intm_listing.intm_name              := i.intm_name;
        
        PIPE ROW(v_intm_listing);
    END LOOP;
  END get_intermediary_listing;
  
  /*
  **  Created by   :  Emman
  **  Date Created :  10.13.2010
  **  Reference By : (GIACS040 - Overriding Commission)
  **  Description  : Gets the list of child intermediaries. Also checks if listing should display distinct records or not.
  */ 
  FUNCTION get_child_intm_listing(p_iss_cd          GIAC_OVRIDE_COMM_PAYTS.iss_cd%TYPE,
                                       p_prem_seq_no      GIAC_OVRIDE_COMM_PAYTS.prem_seq_no%TYPE,
                                  p_intm_no          GIAC_OVRIDE_COMM_PAYTS.intm_no%TYPE,
                                  p_is_distinct      VARCHAR2)
    RETURN intermediary_listing_tab PIPELINED
  IS
      v_intm_listing                    intermediary_listing_type;
  BEGIN
    IF NVL(p_is_distinct, 'N') = 'Y' THEN
          FOR i IN (SELECT DISTINCT a.chld_intm_no, b.intm_name 
                    FROM giac_parent_comm_invoice a, giis_intermediary b 
                   WHERE a.iss_cd = p_iss_cd 
                     AND a.prem_seq_no = p_prem_seq_no 
                     AND a.chld_intm_no = b.intm_no 
                     AND a.intm_no = p_intm_no)
        LOOP
            v_intm_listing.intm_no                  := i.chld_intm_no;
            v_intm_listing.intm_name              := i.intm_name;
            
            PIPE ROW(v_intm_listing);
        END LOOP;
    ELSE
        FOR i IN (SELECT a.chld_intm_no, b.intm_name 
                    FROM giac_parent_comm_invoice a, giis_intermediary b 
                   WHERE a.iss_cd = p_iss_cd 
                     AND a.prem_seq_no = p_prem_seq_no 
                     AND a.chld_intm_no = b.intm_no 
                     AND a.intm_no = p_intm_no)
        LOOP
            v_intm_listing.intm_no                  := i.chld_intm_no;
            v_intm_listing.intm_name              := i.intm_name;
            
            PIPE ROW(v_intm_listing);
        END LOOP;
    END IF;
  END get_child_intm_listing;

END GIAC_PARENT_COMM_INVOICE_PKG;
/


