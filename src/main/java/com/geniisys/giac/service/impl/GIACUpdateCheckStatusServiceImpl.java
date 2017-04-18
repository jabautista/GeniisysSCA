package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONObject;

import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACUpdateCheckStatusDAO;
import com.geniisys.giac.entity.GIACUpdateCheckStatus;
import com.geniisys.giac.service.GIACUpdateCheckStatusService;

public class GIACUpdateCheckStatusServiceImpl implements GIACUpdateCheckStatusService{
	
	private GIACUpdateCheckStatusDAO giacUpdateCheckStatusDAO;
	
	/**
	 * @return the giacUpdateCheckStatusDAO
	 */
	public GIACUpdateCheckStatusDAO getGiacUpdateCheckStatusDAO() {
		return giacUpdateCheckStatusDAO;
	}

	/**
	 * @param giacUpdateCheckStatusDAO the giacUpdateCheckStatusDAO to set
	 */
	public void setGiacUpdateCheckStatusDAO(GIACUpdateCheckStatusDAO giacUpdateCheckStatusDAO) {
		this.giacUpdateCheckStatusDAO = giacUpdateCheckStatusDAO;
	}
	
	@Override
	public void showUpdateCheckStatus(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getBankInfo");				
		Map<String, Object> bankAccountGrid = TableGridUtil.getTableGrid(request, params);
		params.put("ACTION", "getDisbursementInfo");
		Map<String, Object> disbursementAccountGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBankAccount = new JSONObject(bankAccountGrid);
		JSONObject jsonChkDisbursement = new JSONObject(disbursementAccountGrid);
		request.setAttribute("jsonBankAccount", jsonBankAccount);
		request.setAttribute("jsonChkDisbursement", jsonChkDisbursement);
	}

	@Override
	public JSONObject showBankAccount(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getBankInfo");				
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> bankAccountGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBankAccount = new JSONObject(bankAccountGrid);
		return jsonBankAccount;
	}

	@Override
	public JSONObject showDisbursementAccount(HttpServletRequest request,
			GIISUser USER) throws SQLException, Exception {
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("ACTION", "getDisbursementInfo");
		params.put("bankCd", request.getParameter("bankCd"));
		params.put("bankAcctCd", request.getParameter("bankAcctCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("fromDate", request.getParameter("fromDate"));
		params.put("toDate", request.getParameter("toDate"));
		params.put("status", request.getParameter("status"));
		Map<String, Object> disbursementAccountGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonChkDisbursement = new JSONObject(disbursementAccountGrid);
		return jsonChkDisbursement;
	}

	@Override
	public void saveChkDisbursement(HttpServletRequest request, GIISUser USER)
			throws SQLException, Exception {
		JSONObject objParams = new JSONObject(request.getParameter("params"));
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setClearingDate", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParams.getString("setClearingDate")), USER.getUserId(), GIACUpdateCheckStatus.class));
		getGiacUpdateCheckStatusDAO().saveChkDisbursement(params);
	}

}
