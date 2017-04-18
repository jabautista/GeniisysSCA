package com.geniisys.giac.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.geniisys.giac.entity.GIACOpText;

public interface GIACOpTextDAO {

	List<GIACOpText> getGIACOpText(Integer gaccTranId) throws SQLException;
	HashMap<String, Object> whenNewFormsInsGIACS025(Integer gaccTranId) throws SQLException;
	String saveORPreview(Map<String, Object> allParams) throws SQLException;
	List<GIACOpText> generateParticulars(Integer gaccTranId) throws SQLException;
	HashMap<String, Object> checkInsertTaxCollnsGIACS025(HashMap<String, Object> insertTax) throws SQLException;
	List<GIACOpText> getGIACOpTextTableGrid(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> genSeqNos(HashMap<String, Object> map) throws SQLException;
	String checkPrintSeqNoORPreview(HashMap<String, Object> map) throws SQLException;
	HashMap<String, Object> sumAmountsORPreview(HashMap<String, Object> params) throws SQLException;
	HashMap<String, Object> validatePrintOP(HashMap<String, Object> map) throws SQLException;
	
	Map<String, Object> newFormInstanceGIACS050(Map<String, Object> params) throws SQLException;
	String checkVATOR(Map<String, Object> params) throws SQLException;
	HashMap<String, Object> validateORForPrint(Map<String, Object> params) throws SQLException;
	List<Integer> getPrintSeqNoList(Integer gaccTranId) throws SQLException;
	List<Integer> getItemSeqNoList(Integer gaccTranId) throws SQLException;
	void adjustOpTextOndDiscrep(Map<String, Object> params) throws SQLException;
	String validateORAcctgEntries(String paramName) throws SQLException;
	String validateBalanceAcctgEntrs(Integer gaccTranId) throws SQLException;
	
	void adjDocStampsGiacs025(Map<String, Object> params) throws SQLException;//added john 10.24.2014
	void recomputeOpText(Map<String, Object> params) throws SQLException;//added john 7.1.2015
	
}
