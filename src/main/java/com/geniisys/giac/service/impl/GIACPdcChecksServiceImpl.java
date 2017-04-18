package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACPdcChecksDAO;
import com.geniisys.giac.entity.GIACCollectionDtl;
import com.geniisys.giac.entity.GIACPdcPayts;
import com.geniisys.giac.service.GIACPdcChecksService;

public class GIACPdcChecksServiceImpl implements GIACPdcChecksService {
	
	private GIACPdcChecksDAO giacPdcChecksDAO;

	@Override
	public JSONObject showGiacs032(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs032RecList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("checkFlag", request.getParameter("checkFlag"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public Map<String, Object> checkDateForDeposit(HttpServletRequest request) throws SQLException {
		if(request.getParameter("dcbDate") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("dcbDate", request.getParameter("dcbDate"));
			params.put("fundCd", request.getParameter("fundCd"));
			params.put("branchCd", request.getParameter("branchCd"));
			return this.giacPdcChecksDAO.checkDateForDeposit(params);
		} else {
			return null;
		}
	}
	
	public void saveForDeposit(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemId", request.getParameter("itemId"));
		params.put("dcbNo", request.getParameter("dcbNo"));
		params.put("dcbDate", request.getParameter("dcbDate"));
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		giacPdcChecksDAO.saveForDeposit(params);
	}
	
	public JSONObject showReplacementHistory(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs032ReplacementHistory");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		params.put("itemNo", request.getParameter("itemNo"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public void saveReplacePDC(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACCollectionDtl.class));
		params.put("appUser", userId);
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("oldAmt", request.getParameter("oldAmt"));
		params.put("itemId", request.getParameter("itemId"));
		
		giacPdcChecksDAO.saveReplacePDC(params);
	}
	
	public JSONObject showGiacs031(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs031RecList");
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("gaccTranId") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("gaccTranId", request.getParameter("gaccTranId"));
			params.put("issCd", request.getParameter("issCd"));
			params.put("premSeqNo", request.getParameter("premSeqNo"));
			params.put("instNo", request.getParameter("instNo"));
			giacPdcChecksDAO.valAddRec(params);
		}
	}
	
	@Override
	public void saveGiacs031(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACPdcPayts.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACPdcPayts.class));
		params.put("appUser", userId);
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("gaccTranId", request.getParameter("gaccTranId"));
		giacPdcChecksDAO.saveGiacs031(params);
	}
	
	public JSONObject queryPolicyDummyTable(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs031QueryPolicy");
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("sublineCd", request.getParameter("sublineCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("issYy", request.getParameter("issYy"));
		params.put("polSeqNo", request.getParameter("polSeqNo"));
		params.put("renewNo", request.getParameter("renewNo"));
		params.put("dueSw", request.getParameter("dueSw"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	public Map<String, Object> applyPDC(HttpServletRequest request, String userId) 
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("itemId", Integer.parseInt(request.getParameter("itemId")));
		params.put("gaccTranId", Integer.parseInt(request.getParameter("gaccTranId")));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		return giacPdcChecksDAO.applyPDC(params);
	}
	
	public GIACPdcChecksDAO getGiacPdcChecksDAO() {
		return giacPdcChecksDAO;
	}

	public void setGiacPdcChecksDAO(GIACPdcChecksDAO giacPdcChecksDAO) {
		this.giacPdcChecksDAO = giacPdcChecksDAO;
	}

}

