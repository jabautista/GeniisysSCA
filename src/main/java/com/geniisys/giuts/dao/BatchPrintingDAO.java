package com.geniisys.giuts.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.common.entity.GIISReports;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.giri.entity.GIRIBinder;
import com.geniisys.gixx.entity.GIXXPolbasic;

public interface BatchPrintingDAO {
	List<GIISReports> getDocTypeList() throws SQLException;
	Map<String, Object> initializVariable (Map<String, Object> paramsOut) throws SQLException;
	List<GIXXPolbasic> getPolicyEndtId(Map<String, Object> params) throws SQLException;
	String extractPolDocRec (Map<String, Object> params) throws SQLException;
	void deleteExtractTables(Integer extractId) throws SQLException;
	void updatePolRec(Integer policyId) throws SQLException;
	List<GIRIBinder> getBatchBinderId(Map<String, Object> params) throws SQLException;
	void updateBinderRec(Integer binderId) throws SQLException;
	List<GIPIWPolbas> getBatchCoverNote(Map<String, Object> params) throws SQLException;
	void updateCoverNoteRec(Integer parId) throws SQLException;
	List<GIPIVehicle> getBatchCoc(Map<String, Object> params) throws SQLException;
	void updateCocRec (Integer policyId) throws SQLException;
	List<GIPIPolbasic> getBatchInvoice(Map<String, Object> params) throws SQLException;
	void updateInvoiceRec (Integer policyId) throws SQLException;
	List<GIPIPolbasic> getBatchRiInvoice(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getBondsRenewalPolId(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getRenewalPolId(Map<String, Object> params) throws SQLException;
	List<GIPIPolbasic> getBondsPolicyPolId(Map<String, Object> params) throws SQLException;
}

