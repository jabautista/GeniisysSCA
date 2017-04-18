package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACDeferredDAO;
import com.geniisys.giac.service.GIACDeferredService;

public class GIACDeferredServiceImpl implements GIACDeferredService {
	private Logger log = Logger.getLogger(GIACDeferredServiceImpl.class);
	
	private GIACDeferredDAO giacDeferredDAO;
	
	public GIACDeferredDAO getGiacDeferredDAO() {
		return giacDeferredDAO;
	}
	
	public void setGiacDeferredDAO(GIACDeferredDAO giacDeferredDAO) {
		this.giacDeferredDAO = giacDeferredDAO;
	}

	@Override
	public String checkIss(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "checkIss");
		params.put("appUser", USER.getUserId());
		return this.giacDeferredDAO.checkIss(params);
	}

	@Override
	public String checkIfDataExists(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "checkIfDataExists");
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		return this.giacDeferredDAO.checkIfDataExists(params);
	}

	@Override
	public String checkGenTag(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "checkGenTag");
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		return this.giacDeferredDAO.checkGenTag(params);
	}

	@Override
	public String checkStatus(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "checkStatus");
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		return this.giacDeferredDAO.checkStatus(params);
	}

	@Override
	public void setTranFlag(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("appUser", USER.getUserId());
		this.giacDeferredDAO.setTranFlag(params);
	}

	@Override
	public String extractMethod(HttpServletRequest request, GIISUser USER) throws SQLException {
		String msg = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		params.put("appUser", USER.getUserId());
		msg = this.giacDeferredDAO.extractMethod(params);
		return msg;
	}

	@Override
	public JSONObject getGdMain(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException {
		Map<String, Object> gdMain = new HashMap<String, Object>();
		if (request.getParameter("table").equals("gdGross")) {
			log.info("Getting GiacDeferredGross records.");
			gdMain.put("ACTION", "getGdGross");
		}else if (request.getParameter("table").equals("gdRiCeded")) {
			log.info("Getting GiacDeferredRiPremCeded records gor gdriceded.");
			gdMain.put("ACTION", "getGdRiCeded");
		}else if (request.getParameter("table").equals("gdInc")) {
			log.info("Getting GiacDeferredCommIncome records.");
			gdMain.put("ACTION", "getGdInc");
		}else if (request.getParameter("table").equals("gdNetPrem")) {
			log.info("Getting GiacDeferredNetPremV records.");
			gdMain.put("ACTION", "getGdNetPrem");
		}else if (request.getParameter("table").equals("gdRetrocede")) {
			log.info("Getting GiacDeferredRiPremCeded records for gdretrocede.");
			gdMain.put("ACTION", "getGdRetrocede");
		}else if (request.getParameter("table").equals("gdExp")) {
			log.info("Getting GiacDeferredCommExpense records.");
			gdMain.put("ACTION", "getGdExp");
		}
		gdMain.put("year", Integer.parseInt(request.getParameter("year")));
		gdMain.put("mM", Integer.parseInt(request.getParameter("mM")));
		gdMain.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		gdMain.put("userId", USER.getUserId());
		Map<String, Object> gdMainTableGrid = TableGridUtil.getTableGrid(request, gdMain);
		JSONObject jsonGdMain = new JSONObject(gdMainTableGrid);
		request.setAttribute("gdMain", jsonGdMain);
		return jsonGdMain;
	}

	@Override
	public JSONObject getExtractHistory(HttpServletRequest request) throws SQLException, ParseException, JSONException {
		Map<String, Object> extractHist = new HashMap<String, Object>();
		extractHist.put("ACTION", "getExtractHistory");
		extractHist.put("fundCd", request.getParameter("fundCd"));
		Map<String, Object> extractHistTableGrid = TableGridUtil.getTableGrid(request, extractHist);
		JSONObject jsonExtractHist = new JSONObject(extractHistTableGrid);
		request.setAttribute("extractHistory", jsonExtractHist);
		return jsonExtractHist;
	}
	
	@Override
	public JSONObject getGdDetail(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException {
		Map<String, Object> gdDtl = new HashMap<String, Object>();
		if (request.getParameter("table").equals("gdGross")) {
			log.info("Getting GiacDeferredGross detail records.");
			gdDtl.put("ACTION", "getGdGrossDtl");
		}else if (request.getParameter("table").equals("gdRiCeded")) {
			log.info("Getting GiacDeferredRiPremCeded detail records gor gdriceded.");
			gdDtl.put("ACTION", "getGdRiCededDtl");
			gdDtl.put("shareType", request.getParameter("shareType"));
		}else if (request.getParameter("table").equals("gdInc")) {
			log.info("Getting GiacDeferredCommIncome detail records.");
			gdDtl.put("ACTION", "getGdIncDtl");
			gdDtl.put("shareType", request.getParameter("shareType"));
		}else if (request.getParameter("table").equals("gdNetPrem")) {
			log.info("Getting GiacDeferredNetPremV detail records.");
			gdDtl.put("ACTION", "getGdNetPremDtl");
		}else if (request.getParameter("table").equals("gdRetrocede")) {
			log.info("Getting GiacDeferredRiPremCeded detail records for gdretrocede.");
			gdDtl.put("ACTION", "getGdRetrocedeDtl");
			gdDtl.put("shareType", request.getParameter("shareType"));
		}else if (request.getParameter("table").equals("gdExp")) {
			log.info("Getting GiacDeferredCommExpense detail records.");
			gdDtl.put("ACTION", "getGdExpDtl");
		}
		gdDtl.put("year", Integer.parseInt(request.getParameter("year")));
		gdDtl.put("mM", Integer.parseInt(request.getParameter("mM")));
		gdDtl.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		gdDtl.put("issCd", request.getParameter("issCd"));
		gdDtl.put("lineCd", request.getParameter("lineCd"));
		gdDtl.put("userId", USER.getUserId());
		Map<String, Object> gdDtlTableGrid = TableGridUtil.getTableGrid(request, gdDtl);
		JSONObject jsonGdDtl = new JSONObject(gdDtlTableGrid);
		request.setAttribute("gdDtl", jsonGdDtl);
		return jsonGdDtl;
	}	
	
	@Override
	public String checkIfComputed(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "checkIfComputed");
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		return this.giacDeferredDAO.checkIfComputed(params);
	}

	@Override
	public String computeMethod(HttpServletRequest request, GIISUser USER) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("isComputed", request.getParameter("isComputed"));
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		params.put("appUser", USER.getUserId());
		return this.giacDeferredDAO.computeMethod(params);
	}

	@Override
	public String cancelAcctEntries(HttpServletRequest request, GIISUser USER) throws SQLException {
		String message = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		message = this.giacDeferredDAO.cancelAcctEnries(params);
		System.out.println(message);
		return message;
	}

	@Override
	public String reversePostedTrans(HttpServletRequest request, GIISUser USER) throws SQLException {
		String status = "";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("year", Integer.parseInt(request.getParameter("year")));
		param.put("mM", Integer.parseInt(request.getParameter("mM")));
		param.put("tranDate", request.getParameter("tranDate"));
		param.put("userId", USER.getUserId());
		status = this.giacDeferredDAO.reversePostedTrans(param);
		return status;
	}

	@Override
	public String generateAcctEntries(HttpServletRequest request, GIISUser USER) throws SQLException {
		String status = "";
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("year", Integer.parseInt(request.getParameter("year")));
		param.put("mM", Integer.parseInt(request.getParameter("mM")));
		param.put("tranDate", request.getParameter("tranDate"));
		param.put("userId", USER.getUserId());
		param.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		param.put("moduleId", request.getParameter("moduleId"));
		param.put("table", request.getParameter("table"));
		status = this.giacDeferredDAO.generateAcctEntries(param);
		log.info("PARAMETERS: "+ param);
		return status;
	}
	
	@Override
	public String setGenTag(HttpServletRequest request, GIISUser USER) throws SQLException {
		String message = "";
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("appUser", USER.getUserId());
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		params.put("userId", USER.getUserId());
		message = this.giacDeferredDAO.setGenTag(params);
		System.out.println(message);
		return message;
	}

	@Override
	public JSONObject getDeferredAcctEntries(HttpServletRequest request) throws SQLException, ParseException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		log.info("Getting Accounting Entries for "+request.getParameter("table"));
		params.put("ACTION", "getDeferredAcctEntries");
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		params.put("table", request.getParameter("table"));
		Map<String, Object> acctEntriesTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject acctEntries = new JSONObject(acctEntriesTableGrid);
		request.setAttribute("acctEntries", acctEntries);
		return acctEntries;
	}

	@Override
	public JSONObject getDeferredGLSummary(HttpServletRequest request) throws SQLException, ParseException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		log.info("Getting GL Summary for "+request.getParameter("table"));
		params.put("ACTION", "getDeferredGLSummary");
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("procedureId", Integer.parseInt(request.getParameter("procedureId")));
		params.put("table", request.getParameter("table"));
		Map<String, Object> glSummaryTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonGLSummary = new JSONObject(glSummaryTableGrid);
		request.setAttribute("jsonGLSummary", jsonGLSummary);
		return jsonGLSummary;
	}
	
	@Override
	public JSONObject getBranchList(HttpServletRequest request, GIISUser USER) throws SQLException, ParseException, JSONException{
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBranchList");
		params.put("year", Integer.parseInt(request.getParameter("year")));
		params.put("mM", Integer.parseInt(request.getParameter("mM")));
		params.put("userId", USER.getUserId());
		log.info("Getting List of Branches for " + params);
		Map<String, Object> branchTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBranch = new JSONObject(branchTableGrid);
		request.setAttribute("branchList", jsonBranch);
		return jsonBranch;
	}

}
