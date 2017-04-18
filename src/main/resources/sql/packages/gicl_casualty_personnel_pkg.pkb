CREATE OR REPLACE PACKAGE BODY CPI.GICL_CASUALTY_PERSONNEL_PKG
AS
/**
*Rey Jadlocon 
* 10-17-2011
**/

 PROCEDURE del_gicl_casualty_personnel(
            p_claim_id          gicl_casualty_personnel.claim_id%TYPE,
            p_item_no           gicl_casualty_personnel.item_no%TYPE
            )IS
     BEGIN  
            DELETE FROM gicl_casualty_personnel
             WHERE claim_id = p_claim_id
               AND item_no = p_item_no;
     END;

/**
* Rey Jadlocon
*10-17-2011
**/
FUNCTION get_personnel_list(
                            p_claim_id          gicl_casualty_personnel.claim_id%TYPE,
                            p_item_no           gicl_casualty_personnel.item_no%TYPE)
         RETURN personnel_list_tab PIPELINED
       IS 
         v_personnel        personnel_list_type;
 BEGIN
        FOR i IN(SELECT a.item_no,a.personnel_no,a.name,a.include_tag,a.user_id,a.last_update,a.capacity_cd,b.position,a.amount_covered,a.remarks,a.claim_id
                   FROM gicl_casualty_personnel a, giis_position b
                  WHERE a.capacity_cd = b.position_cd(+)
                    AND a.claim_id = p_claim_id
                    AND a.item_no = p_item_no)
        LOOP
                v_personnel.item_no                 := i.item_no;
                v_personnel.claim_id                := i.claim_id;
                v_personnel.personnel_no            := i.personnel_no;
                v_personnel.name                    := i.name;
                v_personnel.include_tag             := i.include_tag;
                v_personnel.user_id                 := i.user_id;
                v_personnel.last_update             := i.last_update;
                v_personnel.capacity_cd             := i.capacity_cd;
                v_personnel.position                := i.position;
                v_personnel.amount_covered          := i.amount_covered;
                v_personnel.remarks                 := i.remarks;
                PIPE ROW(v_personnel);

        END LOOP;
        
      RETURN;
   END;
   
/**
* Rey Jadlocon
* 02-22-2012
**/
FUNCTION personnel_lov(p_dsp_line_cd            VARCHAR2,
                          p_subline_cd             VARCHAR2,
                          p_pol_iss_cd             VARCHAR2,
                          p_issue_yy               NUMBER,
                          p_pol_seq_no             NUMBER,
                          p_renew_no               NUMBER,
                          p_item_no                NUMBER,
                          p_claim_id               NUMBER,
                          p_personnel_no           NUMBER,
                          p_loss_date              DATE,
                          p_expiry_date            DATE)
       RETURN personnel_lov_tab PIPELINED
       IS
                personnel personnel_lov_type;
   BEGIN
          FOR per IN(SELECT DISTINCT e.personnel_no, e.NAME,e.capacity_cd,e.amount_covered
                       FROM gipi_polbasic c, gipi_item b, gipi_casualty_personnel e
                      WHERE c.policy_id = b.policy_id
                        AND b.policy_id = e.policy_id
                        AND b.item_no = e.item_no
                        AND c.line_cd = p_dsp_line_cd
                        AND c.subline_cd = p_subline_cd
                        AND c.iss_cd = p_pol_iss_cd
                        AND c.issue_yy = p_issue_yy
                        AND c.pol_seq_no = p_pol_seq_no
                        AND c.renew_no = p_renew_no
                        AND b.item_no = p_item_no
                        AND e.personnel_no NOT IN (
                               SELECT personnel_no
                                 FROM gicl_casualty_personnel
                                WHERE 1 = 1
                                  AND claim_id = p_claim_id
                                  AND item_no = p_item_no
                                  AND personnel_no <> NVL (p_personnel_no, -1))
                        AND c.pol_flag IN ('1', '2', '3', 'X')
                        AND TRUNC (c.eff_date) <= p_loss_date
                        AND TRUNC (DECODE (NVL (c.endt_expiry_date, c.expiry_date),
                                           c.expiry_date,p_expiry_date,
                                           c.endt_expiry_date
                                          )                                          
                                  ) >= p_loss_date)
      LOOP
                personnel.personnel_no          := per.personnel_no;
                personnel.name                  := per.name;
                personnel.capacity_cd           := per.capacity_cd;
                personnel.amount_covered        := per.amount_covered;
                FOR p IN (SELECT position
                            FROM giis_position
                           WHERE position_cd = per.capacity_cd)
                LOOP
                        personnel.position      := p.position;
                END LOOP;
          PIPE ROW(personnel);
      END LOOP;
   END;
   
/**
* Rey Jadlocon
* 03-07-2012
**/
PROCEDURE insert_delete_personnel(p_claim_id                gicl_casualty_personnel.claim_id%TYPE,
                                  p_item_no                 gicl_casualty_personnel.item_no%TYPE,
                                  p_personnel_no            gicl_casualty_personnel.personnel_no%TYPE,
                                  p_name                    gicl_casualty_personnel.name%TYPE,
                                  p_include_tag             gicl_casualty_personnel.include_tag%TYPE,
                                  p_user_id                 gicl_casualty_personnel.user_id%TYPE,
                                  p_last_update             gicl_casualty_personnel.last_update%TYPE,
                                  p_capacity_cd             gicl_casualty_personnel.capacity_cd%TYPE,
                                  p_amount_covered          gicl_casualty_personnel.amount_covered%TYPE
                                  )
            IS
    BEGIN 
            MERGE INTO gicl_casualty_personnel
                 USING dual
                    ON (claim_id = p_claim_id
                   AND personnel_no = p_personnel_no
                   AND item_no = p_item_no)
           WHEN NOT MATCHED THEN
                INSERT (claim_id,item_no,personnel_no,name,include_tag,user_id,last_update,capacity_cd,amount_covered)
                VALUES (p_claim_id,p_item_no,p_personnel_no,p_name,p_include_tag,p_user_id,sysdate,p_capacity_cd,p_amount_covered)
          WHEN MATCHED THEN
                UPDATE 
                   SET
                       name                     = p_name,
                       include_tag              = p_include_tag,
                       user_id                  = p_user_id,
                       last_update              = sysdate,
                       capacity_cd              = p_capacity_cd,
                       amount_covered           = p_amount_covered;
 END;
 
 /**
 * Rey Jadlocon
 * 03-29-2012
 **/
PROCEDURE delete_personnel(p_claim_id                gicl_casualty_personnel.claim_id%TYPE,
                           p_item_no                 gicl_casualty_personnel.item_no%TYPE,
                           p_personnel_no            gicl_casualty_personnel.personnel_no%TYPE)
    IS
    BEGIN
        DELETE FROM gicl_casualty_personnel
              WHERE claim_id = p_claim_id
                AND item_no = p_item_no
                AND personnel_no = p_personnel_no;
                
    END;
    

PROCEDURE delete_personnel_by_item(p_claim_id                gicl_casualty_personnel.claim_id%TYPE,
                           p_item_no                 gicl_casualty_personnel.item_no%TYPE)
    IS
    BEGIN
        DELETE FROM gicl_casualty_personnel
              WHERE claim_id = p_claim_id
                AND item_no = p_item_no;
                
    END;
 

END GICL_CASUALTY_PERSONNEL_PKG;
/


