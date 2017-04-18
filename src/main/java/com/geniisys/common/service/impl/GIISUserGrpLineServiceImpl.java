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

import com.geniisys.common.dao.GIISUserGrpLineDAO;
import com.geniisys.common.entity.GIISUserGrpLine;
import com.geniisys.common.service.GIISUserGrpLineService;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISUserGrpLineServiceImpl.
 */
public class GIISUserGrpLineServiceImpl implements GIISUserGrpLineService {

	/** The giis user grp line dao. */
	private GIISUserGrpLineDAO giisUserGrpLineDAO;
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpLineService#getGiisUserGrpLineList(java.lang.String)
	 */
	@Override
	public List<GIISUserGrpLine> getGiisUserGrpLineList(String userGrp) throws SQLException {
		return this.getGiisUserGrpLineDAO().getGiisUserGrpLineList(userGrp);
	}
	
	/**
	 * Sets the giis user grp line dao.
	 * 
	 * @param giisUserGrpLineDAO the new giis user grp line dao
	 */
	public void setGiisUserGrpLineDAO(GIISUserGrpLineDAO giisUserGrpLineDAO) {
		this.giisUserGrpLineDAO = giisUserGrpLineDAO;
	}
	
	/**
	 * Gets the giis user grp line dao.
	 * 
	 * @return the giis user grp line dao
	 */
	public GIISUserGrpLineDAO getGiisUserGrpLineDAO() {
		return giisUserGrpLineDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpLineService#setGiisUserGrpLine(com.geniisys.common.entity.GIISUserGrpLine)
	 */
	@Override
	public void setGiisUserGrpLine(GIISUserGrpLine giisUserGrpLine) throws SQLException {
		this.getGiisUserGrpLineDAO().setGiisUserGrpLine(giisUserGrpLine);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpLineService#deleteGiisUserGrpLine(com.geniisys.common.entity.GIISUserGrpLine)
	 */
	@Override
	public void deleteGiisUserGrpLine(GIISUserGrpLine giisUserGrpLine) throws SQLException {
		this.getGiisUserGrpLineDAO().deleteGiisUserGrpLine(giisUserGrpLine);
	}

	@Override
	public JSONObject getUserGrpLine(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss041UserGrpLines");
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("issCd", request.getParameter("issCd"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(StringFormatter.escapeHTMLInMap(recList));
	}

	@Override
	public void valDeleteLine(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("lineCd", request.getParameter("lineCd"));
		
		this.getGiisUserGrpLineDAO().valDeleteLine(params);
	}

	@Override
	public JSONArray getAllLineCodes(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userGrp", request.getParameter("userGrp"));
		params.put("tranCd", request.getParameter("tranCd"));
		params.put("issCd", request.getParameter("issCd"));
		params.put("notIn", request.getParameter("notIn").toString());
		params.put("notInDeleted", request.getParameter("notInDeleted").toString());
		
		List<Map<String, Object>> lineCdList = this.getGiisUserGrpLineDAO().getAllLineCodes(params);
		return new JSONArray(lineCdList);
	}
	
}
