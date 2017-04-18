CREATE OR REPLACE PACKAGE BODY CPI.GIXX_CASUALTY_PERSONNEL_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 29, 2010
**  Reference By : 
**  Description  : Function to get casualty personnel records which is used in policy document report. 
*/ 
    FUNCTION get_pol_doc_ca_personnel(p_extract_id IN GIXX_CASUALTY_PERSONNEL.extract_id%TYPE,
                                      p_item_no    IN GIXX_CASUALTY_PERSONNEL.item_no%TYPE) 
      RETURN pol_doc_ca_personnel_tab PIPELINED IS
     
     v_personnel  pol_doc_ca_personnel_type;
     
   BEGIN
     FOR i IN (
          SELECT A.extract_id, A.item_no, A.personnel_no, A.NAME cpersonnel_name, 
                 b.position cpersonnel_position, A.capacity_cd cpersonnel_capacity_cd,
                 A.amount_covered cpersonnel_amt_covered,
                 DECODE (SUBSTR (A.remarks, 1, 1),
                         '.', NULL,
                         A.remarks
                        ) cpersonnel_remarks
            FROM gixx_casualty_personnel A, 
                 giis_position b
           WHERE A.extract_id  = p_extract_id
             AND A.item_no     = p_item_no 
             AND A.capacity_cd = b.position_cd (+)
        ORDER BY a.personnel_no, A.amount_covered, b.position, A.NAME)
     LOOP
        v_personnel.extract_id              := i.extract_id;
        v_personnel.item_no                 := i.item_no;
        v_personnel.personnel_no            := i.personnel_no;
        v_personnel.cpersonnel_name         := i.cpersonnel_name;
        v_personnel.cpersonnel_position     := i.cpersonnel_position;
        v_personnel.cpersonnel_capacity_cd  := i.cpersonnel_capacity_cd;
        v_personnel.cpersonnel_amt_covered  := i.cpersonnel_amt_covered;
        v_personnel.cpersonnel_remarks      := i.cpersonnel_remarks;
       PIPE ROW(v_personnel);
     END LOOP;
     RETURN;
   END get_pol_doc_ca_personnel;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 07, 2011
**  Reference By :  Package Policy Documents
**  Description  : Function to get casualty personnel records which is used in package policy document report. 
*/ 
    FUNCTION get_pack_pol_doc_ca_personnel(p_extract_id IN GIXX_CASUALTY_PERSONNEL.extract_id%TYPE,
                                           p_policy_id  IN GIXX_CASUALTY_PERSONNEL.policy_id%TYPE,
                                           p_item_no    IN GIXX_CASUALTY_PERSONNEL.item_no%TYPE) 
      RETURN pol_doc_ca_personnel_tab PIPELINED IS
     
     v_personnel  pol_doc_ca_personnel_type;
     
   BEGIN
     FOR i IN (
          SELECT A.extract_id, A.item_no, 
                 A.personnel_no, A.NAME||' '||'('||b.position||')' cpersonnel_name, 
                 b.position cpersonnel_position, A.capacity_cd cpersonnel_capacity_cd,
                 NVL(A.amount_covered,0) cpersonnel_amt_covered,
                 DECODE (SUBSTR (A.remarks, 1, 1),
                         '.', NULL,
                         A.remarks
                        ) cpersonnel_remarks
            FROM gixx_casualty_personnel A, 
                 giis_position b
           WHERE A.extract_id  = p_extract_id
             AND A.policy_id   = p_policy_id
             AND A.item_no     = p_item_no 
             AND A.capacity_cd = b.position_cd (+)
        ORDER BY A.amount_covered, b.position, A.NAME)
     LOOP
        v_personnel.extract_id              := i.extract_id;
        v_personnel.item_no                 := i.item_no;
        v_personnel.personnel_no            := i.personnel_no;
        v_personnel.cpersonnel_name         := i.cpersonnel_name;
        v_personnel.cpersonnel_position     := i.cpersonnel_position;
        v_personnel.cpersonnel_capacity_cd  := i.cpersonnel_capacity_cd;
        v_personnel.cpersonnel_amt_covered  := GIXX_CASUALTY_PERSONNEL_PKG.get_personnel_amt_coverage(p_extract_id, i.cpersonnel_amt_covered);
        v_personnel.cpersonnel_remarks      := i.cpersonnel_remarks;
       PIPE ROW(v_personnel);
     END LOOP;
     RETURN;
   END get_pack_pol_doc_ca_personnel;

FUNCTION get_personnel_amt_coverage(p_extract_id   IN GIXX_CASUALTY_PERSONNEL.extract_id%TYPE,
                              	    p_amt_coverage IN GIXX_CASUALTY_PERSONNEL.amount_covered%TYPE) 
   RETURN NUMBER IS

	v_currency_rt	      GIXX_ITEM.currency_rt%TYPE;
	v_policy_currency     GIXX_PACK_INVOICE.policy_currency%TYPE;
    v_amt_coverage        NUMBER;
    
    BEGIN
        FOR A IN (
                SELECT A.currency_rt, NVL(policy_currency,'N') policy_currency
                    FROM GIXX_ITEM A, GIXX_PACK_INVOICE b
                   WHERE A.extract_id = p_extract_id
                     AND A.extract_id = b.extract_id)
          LOOP
            v_currency_rt     := A.currency_rt;
            v_policy_currency := A.policy_currency;
            EXIT;
          END LOOP;
          
          IF NVL(v_policy_currency, 'N') = 'Y' THEN
            v_amt_coverage := p_amt_coverage;
          ELSE
            v_amt_coverage := p_amt_coverage * NVL(v_currency_rt,1);
          END IF;
      
      RETURN(v_amt_coverage);
    END;
    
    
    
    /*
    ** Created by:    Marie Kris Felipe
    ** Date Created:  March 5, 2013
    ** Reference by:  GIPIS101 - Policy Information (Summary)
    ** Description:   Retrieves personnel information for casualty item 
    */
    FUNCTION get_casualty_personnel_info(
        p_extract_id       gixx_casualty_personnel.extract_id%TYPE,
        p_item_no          gixx_casualty_personnel.item_no%TYPE
    ) RETURN gixx_casualty_personnel_tab PIPELINED
    IS
        v_casualty_personnel    gixx_casualty_personnel_type;
    BEGIN
        FOR rec IN (SELECT extract_id, item_no, personnel_no,
                           NAME, capacity_cd, amount_covered,
                           policy_id, include_tag, delete_sw, remarks
                      FROM gixx_casualty_personnel
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP                       
            v_casualty_personnel.extract_id := rec.extract_id;
            v_casualty_personnel.item_no := rec.item_no;
            v_casualty_personnel.personnel_no := rec.personnel_no;
            v_casualty_personnel.NAME := rec.NAME;
            v_casualty_personnel.capacity_cd := rec.capacity_cd;
            v_casualty_personnel.amount_covered := rec.amount_covered;
            v_casualty_personnel.policy_id := rec.policy_id;
            v_casualty_personnel.include_tag := rec.include_tag;
            v_casualty_personnel.delete_sw := rec.delete_sw;
            v_casualty_personnel.remarks := rec.remarks;
        
            PIPE ROW(v_casualty_personnel);
            
        END LOOP;
    END get_casualty_personnel_info;
   
END GIXX_CASUALTY_PERSONNEL_PKG;
/


