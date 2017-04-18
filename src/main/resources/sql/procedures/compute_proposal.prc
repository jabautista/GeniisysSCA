DROP PROCEDURE CPI.COMPUTE_PROPOSAL;

CREATE OR REPLACE PROCEDURE CPI.compute_proposal (
      p_line_cd        IN   VARCHAR2,
      p_subline_cd     IN   VARCHAR2,
      p_iss_cd         IN   VARCHAR2,
      p_quotation_yy   IN   NUMBER,
      p_quotation_no   IN   NUMBER,
      v_proposal_no     OUT NUMBER
   )

   IS

   BEGIN
      SELECT MAX (proposal_no)
        INTO v_proposal_no
        FROM gipi_pack_quote
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND quotation_yy = p_quotation_yy
         AND quotation_no = p_quotation_no;

      v_proposal_no := v_proposal_no + 1;

   END;
/


