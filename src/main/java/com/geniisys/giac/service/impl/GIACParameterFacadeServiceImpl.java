package com.geniisys.giac.service.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACParameterDAO;
import com.geniisys.giac.entity.GIACParameter;
import com.geniisys.giac.service.GIACParameterFacadeService;

public class GIACParameterFacadeServiceImpl implements
		GIACParameterFacadeService {
	
	/** The GIAC Parameter DAO */
	private GIACParameterDAO giacParameterDAO;

	public GIACParameterDAO getGiacParameterDAO() {
		return giacParameterDAO;
	}

	public void setGiacParameterDAO(GIACParameterDAO giacParameterDAO) {
		this.giacParameterDAO = giacParameterDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACParameterFacadeService#getParamValueN(java.lang.String)
	 */
	@Override
	public Integer getParamValueN(String paramName1) throws SQLException {
		return this.getGiacParameterDAO().getParamValueN(paramName1);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACParameterFacadeService#getParamValueV(java.lang.String)
	 */
	@Override
	public GIACParameter getParamValueV(String paramName) throws SQLException {
		return this.getGiacParameterDAO().getParamValueV(paramName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACParameterFacadeService#getParamValueV2(java.lang.String)
	 */
	@Override
	public String getParamValueV2(String paramName) throws SQLException {
		return this.getGiacParameterDAO().getParamValueV2(paramName);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACParameterFacadeService#getParamValues(java.lang.String)
	 */
	@Override
	public List<GIACParameter> getParamValues(String paramName)
			throws SQLException {
		return this.getGiacParameterDAO().getParamValues(paramName);
	}

	@Override
	public String getGlobalBranchCdByUserId(String paramName)
			throws SQLException {
	
		return getGiacParameterDAO().getGlobalBranchCdByUserId(paramName);
	}
	
	@Override
	public JSONObject showGiacs301(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs301RecList");		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("paramName") != null){
			String paramName = request.getParameter("paramName");
			this.giacParameterDAO.valDeleteRec(paramName);
		}
	}

	@Override
	public void saveGiacs301(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACParameter.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACParameter.class));
		params.put("appUser", userId);
		this.giacParameterDAO.saveGiacs301(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("paramName") != null){
			String paramName = request.getParameter("paramName");
			this.giacParameterDAO.valAddRec(paramName);
		}
	}
	
	//added john 10.23.2014
	@Override
	public BigDecimal getParamValueN2(String paramName1) throws SQLException {
		return this.getGiacParameterDAO().getParamValueN2(paramName1);
	}

}