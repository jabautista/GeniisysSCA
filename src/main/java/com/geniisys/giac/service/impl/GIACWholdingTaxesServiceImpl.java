package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACWholdingTaxesDAO;
import com.geniisys.giac.entity.GIACWholdingTaxes;
import com.geniisys.giac.service.GIACWholdingTaxesService;
import com.seer.framework.util.StringFormatter;

public class GIACWholdingTaxesServiceImpl implements GIACWholdingTaxesService {

	/** The logger **/
	private static Logger log = Logger.getLogger(GIACWholdingTaxesServiceImpl.class);
	
	/** The GIAC Wholding Taxes DAO **/
	private GIACWholdingTaxesDAO giacWholdingTaxesDAO;

	public void setGiacWholdingTaxesDAO(GIACWholdingTaxesDAO giacWholdingTaxesDAO) {
		this.giacWholdingTaxesDAO = giacWholdingTaxesDAO;
	}

	public GIACWholdingTaxesDAO getGiacWholdingTaxesDAO() {
		return giacWholdingTaxesDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACWholdingTaxesService#validateGiacs022WhtaxCode(java.util.Map)
	 */
	@Override
	public void validateGiacs022WhtaxCode(Map<String, Object> params)
			throws SQLException {
		log.info("validateGiacs022WhtaxCode");
		this.getGiacWholdingTaxesDAO().validateGiacs022WhtaxCode(params);
	}

	@Override
	public String validateItemNo(Map<String, Object> params)
			throws SQLException {
		log.info("validateItemNo " + params.get("itemNo"));
		return this.getGiacWholdingTaxesDAO().validateItemNo(params);
	}

	@Override
	public JSONObject showGiacs318(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs318WhtaxList");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> giacWhtaxList = StringFormatter.escapeHTMLInMap(TableGridUtil.getTableGrid(request, params));
		
		return new JSONObject(giacWhtaxList);
	}

	@Override
	public void valDeleteWhtax(HttpServletRequest request) throws SQLException {
		if(request.getParameter("whtaxId") != null){
			Integer whtaxId = Integer.parseInt(request.getParameter("whtaxId"));
			this.giacWholdingTaxesDAO.valDeleteWhtax(whtaxId);
		}
	}

	@Override
	public void saveGiacs318(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACWholdingTaxes.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIACWholdingTaxes.class));
		params.put("appUser", userId);		
		this.giacWholdingTaxesDAO.saveGiacs318(params);
	}	
	
	@Override
	public JSONObject showAllGiacs318(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs318AllRec");
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("branchCd", request.getParameter("branchCd"));
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
}
