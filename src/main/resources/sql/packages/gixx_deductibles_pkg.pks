CREATE OR REPLACE PACKAGE CPI.Gixx_Deductibles_Pkg AS 

    TYPE pol_doc_deductible_type IS RECORD(
        extract_id                      GIXX_DEDUCTIBLES.extract_id%TYPE,
        deductibles_item_no             GIXX_DEDUCTIBLES.item_no%TYPE,
        deductdesc_deductible_title     GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
        deductibles_deductible_text     GIXX_DEDUCTIBLES.deductible_text%TYPE,
        deductibles_deductible_amt      GIXX_DEDUCTIBLES.deductible_amt%TYPE,
        deductibles_ded_line_cd         GIXX_DEDUCTIBLES.ded_line_cd%TYPE,
        deductibles_ded_subline_cd      GIXX_DEDUCTIBLES.ded_subline_cd%TYPE,
        deductibles_ded_deductible_cd   GIXX_DEDUCTIBLES.ded_deductible_cd%TYPE,
        deductibles_deductible_rt       GIXX_DEDUCTIBLES.deductible_rt%TYPE,
        deductibles_peril_sname         GIIS_PERIL.peril_sname%TYPE,
        deductible_amount               GIXX_DEDUCTIBLES.deductible_amt%TYPE,
        f_deductible_amount             GIXX_DEDUCTIBLES.deductible_amt%TYPE,
		deductdesc_ded_type             GIIS_DEDUCTIBLE_DESC.ded_type%TYPE
        );
        
    TYPE pol_doc_deductible_tab IS TABLE OF pol_doc_deductible_type;
    
    FUNCTION get_pol_doc_deductible(p_extract_id IN GIXX_DEDUCTIBLES.extract_id%TYPE,
                                    p_item_no    IN GIXX_DEDUCTIBLES.item_no%TYPE)
      RETURN pol_doc_deductible_tab PIPELINED;

    TYPE pol_doc_policy_deductible_type IS RECORD (
        extract_id21             GIXX_DEDUCTIBLES.extract_id%TYPE,
        deduct_item_no           GIXX_DEDUCTIBLES.item_no%TYPE,
        deduct_peril_cd          GIXX_DEDUCTIBLES.peril_cd%TYPE,    
        deductdesc_deduct_title  GIIS_DEDUCTIBLE_DESC.deductible_title%TYPE,
        deductibles_deduct_text  GIXX_DEDUCTIBLES.deductible_text%TYPE,
        deductibles_deduct_amt   GIXX_DEDUCTIBLES.deductible_amt%TYPE,
        deduct_ded_line_cd       GIXX_DEDUCTIBLES.ded_line_cd%TYPE,
        deduct_ded_subline_cd    GIXX_DEDUCTIBLES.ded_subline_cd%TYPE,
        deduct_ded_deductible_cd GIXX_DEDUCTIBLES.ded_deductible_cd%TYPE,
        deduct_deductible_rt     GIXX_DEDUCTIBLES.deductible_rt%TYPE,
        deduct_peril_sname       GIIS_PERIL.peril_sname%TYPE,
        deduct_amount            GIXX_DEDUCTIBLES.deductible_amt%TYPE
        );
        
    TYPE pol_doc_policy_deductible_tab IS TABLE OF pol_doc_policy_deductible_type;
    
    FUNCTION get_pol_doc_policy_deductible RETURN pol_doc_policy_deductible_tab PIPELINED;
	
	FUNCTION get_ded_amt_total(p_extract_id    GIXX_DEDUCTIBLES.extract_id%TYPE,
   							  p_item_no		  GIXX_DEDUCTIBLES.item_no%TYPE)
	 RETURN NUMBER;
	 
	FUNCTION is_exist(p_extract_id    GIXX_DEDUCTIBLES.extract_id%TYPE,
   					  p_item_no		 GIXX_DEDUCTIBLES.item_no%TYPE)
	 RETURN VARCHAR2;

	FUNCTION get_deductible_amount (
		p_extract_id		IN GIXX_INVOICE.extract_id%TYPE,
		p_item_no			IN GIXX_ITEM.item_no%TYPE,
		p_deductible_amt	IN GIXX_DEDUCTIBLES.deductible_amt%TYPE)
	RETURN NUMBER;
    
    FUNCTION get_pack_pol_doc_deductible(p_extract_id IN GIXX_DEDUCTIBLES.extract_id%TYPE,
                                         p_item_no    IN GIXX_DEDUCTIBLES.item_no%TYPE,
                                         p_policy_id  IN GIXX_DEDUCTIBLES.policy_id%TYPE)
    RETURN pol_doc_deductible_tab PIPELINED;    
    
    -- added by Kris 02.27.2013 for GIPIS101
    TYPE item_deductible_type IS RECORD (
      extract_id             gixx_deductibles.extract_id%TYPE,
      policy_id              gixx_deductibles.policy_id%TYPE,
      ded_deductible_cd      gixx_deductibles.ded_deductible_cd%TYPE,
      item_no                gixx_deductibles.item_no%TYPE,
      ded_line_cd            gixx_deductibles.ded_line_cd%TYPE,
      deductible_rt          gixx_deductibles.deductible_rt%TYPE,
      deductible_text        gixx_deductibles.deductible_text%TYPE,
      ded_subline_cd         gixx_deductibles.ded_subline_cd%TYPE,
      deductible_amt         gixx_deductibles.deductible_amt%TYPE,
      total_deductible_amt   NUMBER(20,2), --gixx_deductibles.deductible_amt%TYPE,
      deductible_name        giis_deductible_desc.deductible_title%TYPE
   );

   TYPE item_deductible_tab IS TABLE OF item_deductible_type;

   FUNCTION get_item_deductibles (
      p_extract_id  gixx_deductibles.extract_id%TYPE,
      p_item_no     gixx_deductibles.item_no%TYPE
   )
   RETURN item_deductible_tab PIPELINED;
   
   FUNCTION get_en_deductibles (
      p_extract_id  gixx_deductibles.extract_id%TYPE,
      p_item_no     gixx_deductibles.item_no%TYPE
   )
   RETURN item_deductible_tab PIPELINED;
   -- end 02.27.2013 for GIPIS101

END Gixx_Deductibles_Pkg;
/


