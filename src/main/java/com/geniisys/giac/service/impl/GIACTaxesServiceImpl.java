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
import com.geniisys.giac.dao.GIACTaxesDAO;
import com.geniisys.giac.entity.GIACTaxes;
import com.geniisys.giac.service.GIACTaxesService;

public class GIACTaxesServiceImpl implements GIACTaxesService{

	private GIACTaxesDAO giacTaxesDAO;

	public GIACTaxesDAO getGiacTaxesDAO() {
		return giacTaxesDAO;
	}

	public void setGiacTaxesDAO(GIACTaxesDAO giacTaxesDAO) {
		this.giacTaxesDAO = giacTaxesDAO;
	}

	@Override
	public JSONObject showGIACS320(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS320RecList");
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("taxCd", request.getParameter("taxCd"));
		this.getGiacTaxesDAO().valDeleteRec(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("taxCd", request.getParameter("taxCd"));
		this.getGiacTaxesDAO().valAddRec(params);
	}
	
	@Override
	public void saveGIACS320(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACTaxes.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACTaxes.class));
		params.put("appUser", userId);
		this.getGiacTaxesDAO().saveGIACS320(params);
	}

	@Override
	public Integer checkAccountCode(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("glAcctCategory", request.getParameter("glAcctCategory"));
		params.put("glControlAcct", request.getParameter("glControlAcct"));
		params.put("glSubAcct1", request.getParameter("glSubAcct1"));
		params.put("glSubAcct2", request.getParameter("glSubAcct2"));
		params.put("glSubAcct3", request.getParameter("glSubAcct3"));
		params.put("glSubAcct4", request.getParameter("glSubAcct4"));
		params.put("glSubAcct5", request.getParameter("glSubAcct5"));
		params.put("glSubAcct6", request.getParameter("glSubAcct6"));
		params.put("glSubAcct7", request.getParameter("glSubAcct7"));
		return this.getGiacTaxesDAO().checkAccountCode(params);
	}
	
}
