package com.geniisys.giuts.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.geniisys.common.entity.GIISReports;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.entity.GIPIVehicle;
import com.geniisys.gipi.entity.GIPIWPolbas;
import com.geniisys.giri.entity.GIRIBinder;
import com.geniisys.giuts.dao.BatchPrintingDAO;
import com.geniisys.giuts.service.BatchPrintingService;
import com.geniisys.gixx.entity.GIXXPolbasic;

public class BatchPrintingServiceImpl implements BatchPrintingService{

	
	private BatchPrintingDAO batchPrintingDAO;
	
	public void setBatchPrintingDAO(BatchPrintingDAO batchPrintingDAO) {
		this.batchPrintingDAO = batchPrintingDAO;
	}

	public BatchPrintingDAO getBatchPrintingDAO() {
		return batchPrintingDAO;
	}
	
	@Override
	public List<GIISReports> getDocTypeList() throws SQLException {
		List<GIISReports> docTypeList = new ArrayList<GIISReports>();
		docTypeList = this.getBatchPrintingDAO().getDocTypeList();
		return docTypeList;
	}

	@Override
	public Map<String, Object> initializVariable(Map<String, Object> paramsOut) throws SQLException {
		return this.getBatchPrintingDAO().initializVariable(paramsOut);
	}

	@Override
	public List<GIXXPolbasic> getPolicyEndtId(HttpServletRequest request, String USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("pRi", request.getParameter("pRi"));
		params.put("assured", request.getParameter("assured"));
		params.put("line", request.getParameter("line"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("user", request.getParameter("user"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("polEndt", request.getParameter("polEndt"));
		params.put("bond", request.getParameter("bond"));
		params.put("pLcSu", request.getParameter("pLcSu"));
		params.put("userId", USER);
		return this.getBatchPrintingDAO().getPolicyEndtId(params);
	}

	@Override
	public String extractPolDocRec(Map<String, Object> params) throws SQLException {
		return this.getBatchPrintingDAO().extractPolDocRec(params);
		//this.getBatchPrintingDAO().extractPolDocRec(params);
	}
	
	@Override
	public void deleteExtractTables(Integer extractId) throws SQLException {
		this.getBatchPrintingDAO().deleteExtractTables(extractId);
	}

	@Override
	public void updatePolRec(Integer policyId) throws SQLException {
		this.getBatchPrintingDAO().updatePolRec(policyId);
		
	}
	
	@Override
	public List<GIRIBinder> getBatchBinderId(HttpServletRequest request, String USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("line", request.getParameter("line"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("cedant", request.getParameter("cedant"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("userId", USER);
		return this.getBatchPrintingDAO().getBatchBinderId(params);
	}
	
	@Override
	public void updateBinderRec(Integer binderId) throws SQLException {
		this.getBatchPrintingDAO().updateBinderRec(binderId);
	}
	
	@Override
	public List<GIPIWPolbas> getBatchCoverNote(HttpServletRequest request, String USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("line", request.getParameter("line"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("userId", USER);
		return this.getBatchPrintingDAO().getBatchCoverNote(params);
	}

	@Override
	public void updateCoverNoteRec(Integer parId) throws SQLException {
		this.getBatchPrintingDAO().updateCoverNoteRec(parId);
	}

	@Override
	public List<GIPIVehicle> getBatchCoc(HttpServletRequest request, String USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("pLcMc", request.getParameter("pLcMc"));
		params.put("pScLto", request.getParameter("pScLto"));
		params.put("pLto", request.getParameter("pLto"));
		params.put("userId", USER);
		params.put("user", request.getParameter("user"));
		return this.getBatchPrintingDAO().getBatchCoc(params);
	}

	@Override
	public void updateCocRec(Integer policyId) throws SQLException {
		this.getBatchPrintingDAO().updateCocRec(policyId);
	}

	@Override
	public List<GIPIPolbasic> getBatchInvoice(HttpServletRequest request, String USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("line", request.getParameter("line"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("user", request.getParameter("user"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("pLcSu", request.getParameter("pLcSu"));
		params.put("pBondPol", request.getParameter("pBondPol"));
		params.put("userId", USER);
		return this.getBatchPrintingDAO().getBatchInvoice(params);
	}

	@Override
	public void updateInvoiceRec(Integer policyId) throws SQLException {
		this.getBatchPrintingDAO().updateInvoiceRec(policyId);
	}
	
	@Override
	public List<GIPIPolbasic> getBatchRiInvoice(HttpServletRequest request, String USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("line", request.getParameter("line"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("cedant", request.getParameter("cedant"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("user", request.getParameter("user"));
		params.put("userId", USER);
		return this.getBatchPrintingDAO().getBatchRiInvoice(params);
	}
	
	@Override
	public List<GIPIPolbasic> getBondsRenewalPolId(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("pLcSu", request.getParameter("pLcSu"));
		return this.getBatchPrintingDAO().getBondsRenewalPolId(params);
	}

	@Override
	public List<GIPIPolbasic> getRenewalPolId(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("line", request.getParameter("line"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		return this.getBatchPrintingDAO().getRenewalPolId(params);
	}

	@Override
	public List<GIPIPolbasic> getBondsPolicyPolId(HttpServletRequest request, String USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("printGroup", request.getParameter("printGroup"));
		params.put("docList", request.getParameter("docList"));
		params.put("assured", request.getParameter("assured"));
		params.put("subline", request.getParameter("subline"));
		params.put("issue", request.getParameter("issue"));
		params.put("startSeq", request.getParameter("startSeq"));
		params.put("endSeq", request.getParameter("endSeq"));
		params.put("startDate", request.getParameter("startDate"));
		params.put("endDate", request.getParameter("endDate"));
		params.put("dateList", request.getParameter("dateList"));
		params.put("pRi", request.getParameter("pRi"));
		params.put("pLcSu", request.getParameter("pLcSu"));
		params.put("userId", USER);
		return this.getBatchPrintingDAO().getBondsPolicyPolId(params);
	}	
}
