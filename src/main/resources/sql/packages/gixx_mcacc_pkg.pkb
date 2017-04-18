CREATE OR REPLACE PACKAGE BODY CPI.GIXX_MCACC_PKG AS

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 27, 2010
**  Reference By : 
**  Description  : Function to get motor accessory records which is used in policy document report. 
*/ 
   FUNCTION get_accessory_amount(p_extract_id IN GIXX_MCACC.extract_id%TYPE,
                                 p_item_no    IN GIXX_MCACC.item_no%TYPE,
                                 p_acc_amt    IN GIXX_MCACC.acc_amt%TYPE)
      RETURN NUMBER
   IS
      v_currency_rt       gipi_item.currency_rt%TYPE          := 1;
      v_policy_currency   gixx_invoice.policy_currency%TYPE;
   BEGIN
      FOR a IN (SELECT a.currency_rt, NVL (policy_currency, 'N') policy_currency
                  FROM gixx_item b, gixx_invoice a
                 WHERE a.extract_id = b.extract_id
                   AND a.extract_id = p_extract_id
                   AND b.item_no = p_item_no)
      LOOP
         v_currency_rt := a.currency_rt;
         v_policy_currency := a.policy_currency;
      END LOOP;

      IF v_policy_currency = 'Y' THEN
         RETURN (NVL (p_acc_amt, 0));
      ELSE
         RETURN (NVL ((p_acc_amt * NVL (v_currency_rt, 1)), 0));
      END IF;
   END; 

/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  April 27, 2010
**  Reference By : 
**  Description  : Function to get motor accessory records which is used in policy document report. 
*/ 
   FUNCTION get_pol_doc_accessory (p_extract_id GIXX_MCACC.extract_id%TYPE,
                                   p_item_no    IN GIXX_MCACC.item_no%TYPE) 
     RETURN pol_doc_accessory_tab PIPELINED IS
     
     v_accessory  pol_doc_accessory_type;
     
   BEGIN
     FOR i IN (
       SELECT mcacc.extract_id  extract_id, 
              mcacc.item_no     mcacc_item_no, 
              accessory.accessory_desc accessory_accessory_desc, 
              NVL(mcacc.acc_amt, accessory.acc_amt) mcacc_acc_amt
         FROM GIIS_ACCESSORY ACCESSORY, 
              GIXX_MCACC MCACC
        WHERE mcacc.extract_id   = p_extract_id
          AND mcacc.item_no      = p_item_no
          AND mcacc.accessory_cd = accessory.accessory_cd)
     LOOP
        v_accessory.extract_id               := i.extract_id;
        v_accessory.mcacc_item_no            := i.mcacc_item_no;
        v_accessory.accessory_accessory_desc := i.accessory_accessory_desc;
        v_accessory.mcacc_acc_amt            := i.mcacc_acc_amt;
        v_accessory.f_acc_amt                := GET_ACCESSORY_AMOUNT(p_extract_id, i.mcacc_item_no, i.mcacc_acc_amt);
       PIPE ROW(v_accessory);
     END LOOP;
     RETURN;
   END get_pol_doc_accessory;
   
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 04, 2011
**  Reference By :  Package Policy Documents
**  Description  : Function to get motor accessory records which is used in package policy document report. 
*/ 
   FUNCTION get_accessory_amount_pack(p_extract_id IN GIXX_MCACC.extract_id%TYPE,
                                      p_item_no    IN GIXX_MCACC.item_no%TYPE,
                                      p_acc_amt    IN GIXX_MCACC.acc_amt%TYPE)
      RETURN NUMBER
   IS
      v_currency_rt       gipi_item.currency_rt%TYPE  := 1;
      v_policy_currency   gixx_pack_invoice.policy_currency%TYPE;
   BEGIN
      FOR a IN (SELECT a.currency_rt, NVL (policy_currency, 'N') policy_currency
                  FROM gixx_item b, gixx_pack_invoice a
                 WHERE a.extract_id = b.extract_id
                   AND a.extract_id = p_extract_id
                   AND b.item_no = p_item_no)
      LOOP
         v_currency_rt := a.currency_rt;
         v_policy_currency := a.policy_currency;
      END LOOP;

      IF v_policy_currency = 'Y' THEN
         RETURN (NVL (p_acc_amt, 0));
      ELSE
         RETURN (NVL ((p_acc_amt * NVL (v_currency_rt, 1)), 0));
      END IF;
   END; 

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  April 04, 2011
**  Reference By :  Package Policy Documents
**  Description  : Function to get motor accessory records which is used in package policy document report. 
*/ 
   FUNCTION get_pack_pol_doc_accessory(p_extract_id IN GIXX_MCACC.extract_id%TYPE,
                                       p_policy_id  IN GIXX_MCACC.policy_id%TYPE,
                                       p_item_no    IN GIXX_MCACC.item_no%TYPE) 
   RETURN pol_doc_accessory_tab PIPELINED IS
     
     v_accessory  pol_doc_accessory_type;
     
   BEGIN
     FOR i IN (
       SELECT mcacc.extract_id  extract_id, 
              mcacc.item_no     mcacc_item_no, 
              accessory.accessory_desc accessory_accessory_desc, 
              NVL(mcacc.acc_amt, accessory.acc_amt) mcacc_acc_amt
         FROM GIIS_ACCESSORY ACCESSORY, 
              GIXX_MCACC MCACC
        WHERE mcacc.extract_id   = p_extract_id
          AND mcacc.item_no      = p_item_no
          AND mcacc.policy_id    = p_policy_id
          AND mcacc.accessory_cd = accessory.accessory_cd)
     LOOP
        v_accessory.extract_id               := i.extract_id;
        v_accessory.mcacc_item_no            := i.mcacc_item_no;
        v_accessory.accessory_accessory_desc := i.accessory_accessory_desc;
        v_accessory.mcacc_acc_amt            := i.mcacc_acc_amt;
        v_accessory.f_acc_amt                := GET_ACCESSORY_AMOUNT_PACK(p_extract_id, i.mcacc_item_no, i.mcacc_acc_amt);
       PIPE ROW(v_accessory);
     END LOOP;
     RETURN;
   END get_pack_pol_doc_accessory;
   
   
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 7, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves Accessory information
  */
  FUNCTION get_mcacc_list (
        p_extract_id        GIXX_MCACC.EXTRACT_ID%TYPE,
        p_item_no           gixx_mcacc.item_no%TYPE
   ) RETURN mcacc_tab PIPELINED
   IS
        v_mcacc     mcacc_type;
   BEGIN
        FOR rec IN (SELECT extract_id, item_no,
                           accessory_cd, acc_amt,
                           policy_id
                      FROM gixx_mcacc
                     WHERE extract_id = p_extract_id
                       AND item_no = p_item_no)
        LOOP
            v_mcacc.extract_id := rec.extract_id;
            v_mcacc.item_no := rec.item_no;
            v_mcacc.acc_amt := rec.acc_amt;
            v_mcacc.accessory_cd := rec.accessory_cd;
            v_mcacc.policy_id := rec.policy_id;
            
            FOR a IN (SELECT accessory_desc
                           FROM giis_accessory
                          WHERE accessory_cd = rec.accessory_cd)
            LOOP
                v_mcacc.accessory_desc := a.accessory_desc;
                EXIT;
            END LOOP;
            
            FOR total IN (SELECT SUM(acc_amt) total_acc_amt
                            FROM gixx_mcacc
                           WHERE extract_id = p_extract_id
                             AND item_no = p_item_no)
            LOOP
                v_mcacc.total_acc_amt := total.total_acc_amt;
            END LOOP;
            
            PIPE ROW(v_mcacc);
        END LOOP;
   END get_mcacc_list;
   
END GIXX_MCACC_PKG;
/


