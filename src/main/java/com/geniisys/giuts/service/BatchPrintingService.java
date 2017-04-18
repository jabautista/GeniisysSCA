package com.geniisys.giuts.service;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISReports;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.giri.entity.GIRIBinder;
import com.geniisys.gixx.entity.GIXXPolbasic;

public interface BatchPrintingService {
	List<GIISReports> getDocTypeList() throws SQLException;
	Map<String, Object> initializVariable(Map<String, Object> paramsOut) throws SQLException;
	List<GIXXPolbasic> getPolicyEndtId(HttpServletRequest request, String USER) throws SQLException;
	String extractPolDocRec(Map<String, Object> params) throws SQLException;
	void deleteExtractTables(Integer extractId) throws SQLException;
	void updatePolRec(Integer policyId) throws SQLException;
	List<GIRIBinder> getBatchBinderId(HttpServletRequest request, String USER) throws SQLException;
	void updateBinderRec(Integer binderId) throws SQLException;
	List<GIPIWPolbas> getBatchCoverNote(HttpServletRequest request, String USER) throws SQLException;
	void updateCoverNoteRec(Integer parId) throws SQLException;
	List<GIPIVehicle> getBatchCoc(HttpServletRequest request, String USER) throws SQLException;
	void updateCocRec (Integer policyId) throws SQLException;
	List<GIPIPolbasic> getBatchInvoice(HttpServletRequest request, String USER) throws SQLException;
	void updateInvoiceRec (Integer policyId) throws SQLException;
	List<GIPIPolbasic> getBatchRiInvoice (HttpServletRequest request, String USER) throws SQLException;
	List<GIPIPolbasic> getBondsRenewalPolId (HttpServletRequest request) throws SQLException;
	List<GIPIPolbasic> getRenewalPolId (HttpServletRequest request) throws SQLException;
	List<GIPIPolbasic> getBondsPolicyPolId (HttpServletRequest request, String USER) throws SQLException;
}
