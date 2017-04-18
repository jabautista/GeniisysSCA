CREATE OR REPLACE PACKAGE BODY CPI.giac_tax_collns_pkg
AS
    /*
   **  Created by   :  Alfie Ni?o Bioc
   **  Date Created :  11.22.2010
   **  Reference By : (GIACS007 - Direct Trans - Direct Premium Collections)
   **  Description  : Retrieves listing of tax collections
   */
   FUNCTION get_tax_collns_listing (
      p_gacc_tran_id   giac_tax_collns.gacc_tran_id%TYPE
   )
      RETURN giac_tax_collns_tab PIPELINED
   IS
      v_taxes   giac_tax_collns_type;

      CURSOR cursor_taxes
      IS
         SELECT gacc_tran_id, transaction_type, b160_iss_cd,
                b160_prem_seq_no, gtc.b160_tax_cd, tax_name, tax_amt,
                inst_no, gtc.fund_cd
           FROM giac_tax_collns gtc, giac_taxes gt
          WHERE gt.tax_cd = gtc.b160_tax_cd
            AND gtc.gacc_tran_id = p_gacc_tran_id;
   BEGIN
      FOR loop_taxes IN cursor_taxes
      LOOP
         v_taxes.gacc_tran_id := loop_taxes.gacc_tran_id;
         v_taxes.transaction_type := loop_taxes.transaction_type;
         v_taxes.b160_iss_cd := loop_taxes.b160_iss_cd;
         v_taxes.b160_prem_seq_no := loop_taxes.b160_prem_seq_no;
         v_taxes.b160_tax_cd := loop_taxes.b160_tax_cd;
         v_taxes.tax_name := loop_taxes.tax_name;
         v_taxes.inst_no := loop_taxes.inst_no;
         v_taxes.fund_cd := loop_taxes.fund_cd;
         v_taxes.tax_amt := loop_taxes.tax_amt;
         PIPE ROW (v_taxes);
      END LOOP;
   END get_tax_collns_listing;
   
   PROCEDURE delete_giac_tax_collns_rec (
     p_gacc_tran_id giac_acctrans.tran_id%TYPE,
     p_b160_iss_cd  giac_tax_collns.b160_iss_cd%TYPE,
     p_b160_prem_seq_no giac_tax_collns.b160_prem_seq_no%TYPE,
     p_inst_no giac_tax_collns.inst_no%TYPE--,
     --p_b160_tax_cd giac_tax_collns.b160_tax_cd%TYPE  commented by tonio june 16, 2011
     )
   IS
     v_tax_cd NUMBER;
   BEGIN
   /*(
     IF p_b160_tax_cd != 0 THEN
       v_tax_cd := p_b160_tax_cd;
     END IF;
   */
     DELETE FROM GIAC_TAX_COLLNS
       WHERE b160_iss_cd      = p_b160_iss_cd 
         AND b160_prem_seq_no = p_b160_prem_seq_no 
         AND inst_no          = p_inst_no 
         AND gacc_tran_id     = p_gacc_tran_id;
         --AND b160_tax_Cd      = NVL(v_tax_cd, b160_tax_cd); commented by tonio june 16, 2011
         
   END delete_giac_tax_collns_rec;
   
    /*
   **  Created by   :  Robert Virrey
   **  Date Created :  08.24.2012
   **  Reference By : (GIACS007 - DIRECT PREMIUM COLLECTIONS)
   **  Description  : Retrieves listing of tax collections
   */
    FUNCTION get_tax_collns_listing2 (
       p_gacc_tran_id       giac_tax_collns.gacc_tran_id%TYPE,
       p_b160_iss_cd        giac_tax_collns.b160_iss_cd%TYPE,
       p_b160_prem_seq_no   giac_tax_collns.b160_prem_seq_no%TYPE,
       p_inst_no            giac_tax_collns.inst_no%TYPE
    )
       RETURN giac_tax_collns_tab PIPELINED
    IS
       v_taxes   giac_tax_collns_type;

       CURSOR cursor_taxes
       IS
          SELECT   gtac.gacc_tran_id, gtac.transaction_type, gtac.b160_iss_cd, 
                   gtac.b160_prem_seq_no, gtac.b160_tax_cd, a100.tax_name, 
                   gtac.tax_amt, gtac.inst_no, gtac.fund_cd
              FROM giac_tax_collns gtac,
                   giac_taxes a100
             WHERE a100.tax_cd = gtac.b160_tax_cd
               AND a100.fund_cd = gtac.fund_cd
               AND gtac.gacc_tran_id = p_gacc_tran_id
               AND b160_iss_cd = p_b160_iss_cd
               AND b160_prem_seq_no = p_b160_prem_seq_no
               AND gtac.inst_no = p_inst_no;
    BEGIN
       FOR loop_taxes IN cursor_taxes
       LOOP
          v_taxes.gacc_tran_id := loop_taxes.gacc_tran_id;
          v_taxes.transaction_type := loop_taxes.transaction_type;
          v_taxes.b160_iss_cd := loop_taxes.b160_iss_cd;
          v_taxes.b160_prem_seq_no := loop_taxes.b160_prem_seq_no;
          v_taxes.b160_tax_cd := loop_taxes.b160_tax_cd;
          v_taxes.tax_name := loop_taxes.tax_name;
          v_taxes.inst_no := loop_taxes.inst_no;
          v_taxes.fund_cd := loop_taxes.fund_cd;
          v_taxes.tax_amt := loop_taxes.tax_amt;
          PIPE ROW (v_taxes);
       END LOOP;
    END get_tax_collns_listing2;

      
END;
/


