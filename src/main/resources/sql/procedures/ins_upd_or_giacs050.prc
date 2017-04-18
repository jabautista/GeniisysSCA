DROP PROCEDURE CPI.INS_UPD_OR_GIACS050;

CREATE OR REPLACE PROCEDURE CPI.INS_UPD_OR_GIACS050 (
    p_gacc_tran_id  IN GIAC_OP_TEXT.gacc_tran_id%TYPE,
    p_branch_cd     IN GIAC_OR_PREF.branch_cd%TYPE,
    p_fund_cd       IN GIAC_OR_PREF.fund_cd%TYPE,
    p_user          IN GIIS_USERS.user_id%TYPE,
    p_or_no         IN GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
    p_or_pref       IN VARCHAR2,
    p_doc_name      IN VARCHAR2
) IS
    CURSOR gion IS
    SELECT '1'
      FROM giac_doc_sequence
      WHERE doc_name = p_doc_name
      AND NVL(doc_pref_suf, '-') = NVL(p_or_pref, NVL(doc_pref_suf, '-'))
      AND branch_cd = p_branch_cd
      AND fund_cd = p_fund_cd;

    v_exists    VARCHAR2(1);
    v_doc_name  VARCHAR(20);

BEGIN
    /*    
    **  Created By      : d.alcantara
    **  Date Created 	: 03.15.2011
    **  Reference By 	: (GIACS050 - OR PRINTING)
    **  Description 	: Updates the doc_seq_no in giac_doc_seqeunce when an
    **                      OR is succesfully printed
    */

  OPEN gion;
  FETCH gion INTO v_exists;
    IF gion%FOUND THEN
      UPDATE giac_doc_sequence
        SET doc_seq_no = p_or_no,
            user_id = nvl(p_user, USER),
            last_update = SYSDATE
        WHERE doc_name = p_doc_name
        AND NVL(doc_pref_suf, '-') = NVL(p_or_pref, NVL(doc_pref_suf, '-'))
        AND branch_cd = p_branch_cd
        AND fund_cd = p_fund_cd;
    ELSE
      INSERT INTO giac_doc_sequence(fund_cd, 
                                    branch_cd,
                                    doc_name, doc_seq_no,
                                    user_id, last_update,
                                    doc_pref_suf)
      VALUES(p_fund_cd, 
             p_branch_cd, 
             p_doc_name, p_or_no, 
             nvl(p_user, USER), SYSDATE,
             p_or_pref);
    END IF;
  CLOSE gion;

END INS_UPD_OR_GIACS050;
/


