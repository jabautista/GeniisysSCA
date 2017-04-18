package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIACEomRepDAO;
import com.geniisys.common.entity.GIACEomRep;
import com.geniisys.common.entity.GIACEomRepDtl;
import com.geniisys.common.service.GIACEomRepService;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIACEomRepServiceImpl implements GIACEomRepService{

	private GIACEomRepDAO giacEomRepDAO;
	
	public GIACEomRepDAO getGiacEomRepDAO() {
		return giacEomRepDAO;
	}

	public void setGiacEomRepDAO(GIACEomRepDAO giacEomRepDAO) {
		this.giacEomRepDAO = giacEomRepDAO;
	}
	
	@Override
	public JSONObject showGiacs350(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs350RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("repCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("repCd", request.getParameter("repCd"));
			this.giacEomRepDAO.valAddRec(params);
		}
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("repCd") != null){
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("repCd", request.getParameter("repCd"));
			this.giacEomRepDAO.valDeleteRec(params);
		}
	}

	@Override
	public void saveGiacs350(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACEomRep.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACEomRep.class));
		params.put("appUser", userId);
		this.giacEomRepDAO.saveGiacs350(params);
	}

	@Override
	public JSONObject showGiacs351(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs351RecList");		
		params.put("repCd", request.getParameter("repCd"));
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void validateGLAcctNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("glAcctCategory", request.getParameter("glAcctCategory"));
		params.put("glAcctControlAcct", request.getParameter("glAcctControlAcct"));
		params.put("glSubAcct1", request.getParameter("glSubAcct1"));
		params.put("glSubAcct2", request.getParameter("glSubAcct2"));
		params.put("glSubAcct3", request.getParameter("glSubAcct3"));
		params.put("glSubAcct4", request.getParameter("glSubAcct4"));
		params.put("glSubAcct5", request.getParameter("glSubAcct5"));
		params.put("glSubAcct6", request.getParameter("glSubAcct6"));
		params.put("glSubAcct7", request.getParameter("glSubAcct7"));
		System.out.println("Validate GL Account No ::::::::::::::::::::::: " + params);
		this.giacEomRepDAO.validateGLAcctNo(params);
	}

	@Override
	public void valAddDtlRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("repCd", request.getParameter("repCd"));
		params.put("glAcctCategory", request.getParameter("glAcctCategory"));
		params.put("glAcctControlAcct", request.getParameter("glAcctControlAcct"));
		params.put("glSubAcct1", request.getParameter("glSubAcct1"));
		params.put("glSubAcct2", request.getParameter("glSubAcct2"));
		params.put("glSubAcct3", request.getParameter("glSubAcct3"));
		params.put("glSubAcct4", request.getParameter("glSubAcct4"));
		params.put("glSubAcct5", request.getParameter("glSubAcct5"));
		params.put("glSubAcct6", request.getParameter("glSubAcct6"));
		params.put("glSubAcct7", request.getParameter("glSubAcct7"));
		System.out.println("Validate GL Account No to be added in table grid ::::::::::::::::::::::: " + params);
		this.giacEomRepDAO.valAddDtlRec(params);
	}

	@Override
	public void saveGiacs351(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACEomRepDtl.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACEomRepDtl.class));
		params.put("appUser", userId);
		this.giacEomRepDAO.saveGiacs351(params);
	}

}
