/***************************************************
 * Project Name	: 	Geniisys Web
 * Version		:	1.0 	 
 * Author		:	Computer Professionals, Inc. 
 * Module		: 	
 * Created By	:	Fons
 * Create Date	:	05.03.2013
 ***************************************************/
package com.geniisys.gicl.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gicl.dao.GICLClaimTableMaintenanceDAO;
import com.geniisys.gicl.entity.GICLClaimPayee;
import com.geniisys.gicl.service.GICLClaimTableMaintenanceService;
import com.seer.framework.util.StringFormatter;


public class GICLClaimTableMaintenanceServiceImpl implements GICLClaimTableMaintenanceService{
	
	private GICLClaimTableMaintenanceDAO giclClaimTableMaintenanceDAO;
	
	public GICLClaimTableMaintenanceDAO getGiclClaimTableMaintenanceDAO() {
		return giclClaimTableMaintenanceDAO;
	}

	public void setGiclClaimTableMaintenanceDAO(
			GICLClaimTableMaintenanceDAO giclClaimTableMaintenanceDAO) {
		this.giclClaimTableMaintenanceDAO = giclClaimTableMaintenanceDAO;
	}
	
	//Claim Payee
	@Override
	public JSONObject showMenuClaimPayeeClass(HttpServletRequest request) throws SQLException,JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getClaimPayeeClass");	
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("classDesc", request.getParameter("classDesc"));
		return this.giclClaimTableMaintenanceDAO.getClaimPayeeClass(request, params); 
	}

	@Override
	public JSONObject showMenuClaimPayeeInfo(HttpServletRequest request, String payeeClassCd) throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getClaimPayeeInfo");			
		params.put("payeeClassCd", payeeClassCd);		
		return this.giclClaimTableMaintenanceDAO.getClaimPayeeInfo(request, params);
	}
	
	@Override
	public JSONObject getBankAcctHstryField(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getBankAcctHstryField");	
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeNo", request.getParameter("payeeNo"));
		return this.giclClaimTableMaintenanceDAO.getBankAcctHstryField(request, params);
	}
	
	@Override
	public JSONObject getBankAcctHstryValue(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getBankAcctHstryValue");	
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));
		params.put("payeeNo", request.getParameter("payeeNo"));
		params.put("field", request.getParameter("field"));
		return this.giclClaimTableMaintenanceDAO.getBankAcctHstryValue(request, params);
	}

	@Override
	public JSONObject showBankAcctApprovals(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("ACTION", "getBankAcctApprovals");	
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));	
		return this.giclClaimTableMaintenanceDAO.getBankAcctApprovals(request, params);
	}

	@Override
	public Map<String, Object> saveGicls150(String parameter, GIISUser USER)
			throws SQLException, JSONException, ParseException {
		
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GICLClaimPayee.class));
		return this.giclClaimTableMaintenanceDAO.saveGicls150(params);
	}
	
	@Override
	public Map<String, Object> validateMobileNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("param", request.getParameter("param"));	
		params.put("field", request.getParameter("field"));	
		params.put("ctype", request.getParameter("ctype"));
		return this.giclClaimTableMaintenanceDAO.validateMobileNo(params);
	}

	@Override
	public Map<String, Object> validateUserFunc(HttpServletRequest request, GIISUser USER)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("user", USER.getUserId());	
		params.put("funcCode",request.getParameter("funcCode"));
		params.put("moduleName", request.getParameter("moduleName"));
		return this.giclClaimTableMaintenanceDAO.validateUserFunc(params);
	}

	@Override
	public Map<String, Object> saveBankAcctDtls(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParameters = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();		
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GICLClaimPayee.class));
		return this.giclClaimTableMaintenanceDAO.saveBankAcctDtls(params);
	}
	
	@Override
	public Map<String, Object> approveBankAcctDtls(String parameter,
			GIISUser USER) throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(parameter);
		Map<String, Object> params = new HashMap<String, Object>();				
		params.put("payeeClassCd", objParams.getString("payeeClassCd"));
		if((objParams.getString("payeeNo").equals(""))){
			params.put("payeeNo", "");
		}else{
			params.put("payeeNo", objParams.getString("payeeNo"));
		}	
		params.put("bankAcctAppTag", objParams.getString("bankAcctAppTag"));
		params.put("userId", USER.getUserId());
		return this.giclClaimTableMaintenanceDAO.approveBankAcctDtls(params);
	}

	@Override
	public Map<String, Object> getBankAcctDtls(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("payeeClassCd", request.getParameter("payeeClassCd"));	
		params.put("payeeNo", request.getParameter("payeeNo"));
		return this.giclClaimTableMaintenanceDAO.getBankAcctDtls(params);
	}	
}
