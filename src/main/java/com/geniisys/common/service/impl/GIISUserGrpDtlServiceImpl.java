/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISUserGrpDtlDAO;
import com.geniisys.common.entity.GIISUserGrpDtl;
import com.geniisys.common.service.GIISUserGrpDtlService;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISUserGrpDtlServiceImpl.
 */
public class GIISUserGrpDtlServiceImpl implements GIISUserGrpDtlService {

	/** The giis user grp dtl dao. */
	private GIISUserGrpDtlDAO giisUserGrpDtlDAO;
	
	/**
	 * Gets the giis user grp dtl dao.
	 * 
	 * @return the giis user grp dtl dao
	 */
	public GIISUserGrpDtlDAO getGiisUserGrpDtlDAO() {
		return giisUserGrpDtlDAO;
	}
	
	/**
	 * Sets the giis user grp dtl dao.
	 * 
	 * @param giisUserGrpDtlDAO the new giis user grp dtl dao
	 */
	public void setGiisUserGrpDtlDAO(GIISUserGrpDtlDAO giisUserGrpDtlDAO) {
		this.giisUserGrpDtlDAO = giisUserGrpDtlDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpDtlService#getGiisUserGrpDtlGrpList(java.lang.String)
	 */
	@Override
	public List<GIISUserGrpDtl> getGiisUserGrpDtlGrpList(String userGrp) throws SQLException {
		return this.getGiisUserGrpDtlDAO().getGiisUserGrpDtlGrpList(userGrp);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpDtlService#setGiisUserGrpDtl(com.geniisys.common.entity.GIISUserGrpDtl)
	 */
	@Override
	public void setGiisUserGrpDtl(GIISUserGrpDtl giisUserGrpDtl) throws SQLException {
		this.getGiisUserGrpDtlDAO().setGiisUserGrpDtl(giisUserGrpDtl);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpDtlService#deleteGiisUserGrpDtl(com.geniisys.common.entity.GIISUserGrpDtl)
	 */
	@Override
	public void deleteGiisUserGrpDtl(GIISUserGrpDtl giisUserGrpDtl) throws SQLException {
		this.getGiisUserGrpDtlDAO().deleteGiisUserGrpDtl(giisUserGrpDtl);
	}
	
	@Override
	public JSONObject getUserGrpDtl(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss041UserGrpDtls");
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valAddDeleteDtl(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("action", request.getParameter("addDelete"));
		
		this.getGiisUserGrpDtlDAO().valAddDeleteDtl(params);
	}
	
	@Override
	public JSONArray getAllIssCodes(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("grpIssCd", request.getParameter("grpIssCd"));
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("notIn", request.getParameter("notIn"));
		params.put("notInDeleted", request.getParameter("notInDeleted"));
		
		List<Map<String, Object>> issCdList = this.getGiisUserGrpDtlDAO().getAllIssCodes(params);
		return new JSONArray(issCdList);
	}
	
}
