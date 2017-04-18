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

import com.geniisys.common.dao.GIISLineDAO;
import com.geniisys.common.entity.GIISLine;
import com.geniisys.common.service.GIISLineFacadeService;
import com.geniisys.framework.util.JSONUtil;
import com.ibm.disthub2.impl.matching.selector.ParseException;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISLineFacadeServiceImpl.
 */
public class GIISLineFacadeServiceImpl implements GIISLineFacadeService{
	
	/** The giis line dao. */
	private GIISLineDAO giisLineDAO;

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISLineFacadeService#getLineListing()
	 */
	@Override
	public List<GIISLine> getLineListing() {		
		return giisLineDAO.getLineListing();
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISLineFacadeService#getLineListingByUserId(java.lang.String)
	 */
	@Override
	public List<GIISLine> getLineListingByUserId(String userId) {		
		return giisLineDAO.getLineListingByUserId(userId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISLineFacadeService#getGIISLineName(java.lang.String)
	 */
	@Override
	public GIISLine getGIISLineName(String lineCd) throws SQLException {
		return giisLineDAO.getGIISLineName(lineCd);
	}
	
	//for attribute giisLineDao
	/**
	 * Gets the giis line dao.
	 * 
	 * @return the giis line dao
	 */
	public GIISLineDAO getGiisLineDAO() {
		return giisLineDAO;
	}

	/**
	 * Sets the giis line dao.
	 * 
	 * @param giisLineDao the new giis line dao
	 */
	public void setGiisLineDAO(GIISLineDAO giisLineDao) {
		this.giisLineDAO = giisLineDao;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISLineFacadeService#getGiisLineList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISLine> getGiisLineList() throws SQLException {
		return (List<GIISLine>) StringFormatter.escapeHTMLInList(this.getGiisLineDAO().getGiisLineList());
	}

	@Override
	public String getPackPolFlag(String lineCd) throws SQLException {
		return this.getGiisLineDAO().getPackPolFlag(lineCd);
	}

	@Override
	public List<GIISLine> getCheckedLineIssourceList(Map<String, Object> params)
			throws SQLException {
		return this.getGiisLineDAO().getCheckedLineIssourceList(params);
	}

	@Override
	public String getMenuLineCd(String lineCd) throws SQLException {
		return this.getGiisLineDAO().getMenuLineCd(lineCd);
	}
	
	public List<GIISLine> getPolLinesForAssd(Integer assdNo) throws SQLException{
		return this.getGiisLineDAO().getPolLinesForAssd(assdNo);
	}
	
	@Override
	public List<GIISLine> getCheckedPackLineIssourceList(Map<String, Object> params)
			throws SQLException {
		return this.getGiisLineDAO().getCheckedPackLineIssourceList(params);
	}
	
	@Override
	public Map<String, Object> validatePolLineCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiisLineDAO().validatePolLineCd(params);
	}
	
	@Override
	public Map<String, Object> validateLineCd(Map<String, Object> params)
			throws SQLException {
		return this.getGiisLineDAO().validateLineCd(params);
	}

	@Override
	public List<GIISLine> validateLineCdGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.getGiisLineDAO().validateLineCdGiexs006(params);
	}

	@Override
	public GIISLine getGiisLineGiuts036(String lineCd) throws SQLException {
		return this.getGiisLineDAO().getGiisLineGiuts036(lineCd);
	}

	@Override
	public List<GIISLine> getAllRecapsCd()
			throws SQLException {
		return this.getGiisLineDAO().getAllRecapsCd();
	}

	@Override
	public String saveLine(HttpServletRequest request, String userId) throws JSONException, SQLException, ParseException {
		
		JSONObject objParameters = new JSONObject(request.getParameter("parameters"));
		Map<String, Object> allParams = new HashMap<String, Object>();
		allParams.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), userId, GIISLine.class));
		allParams.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), userId, GIISLine.class));
		return this.getGiisLineDAO().saveInvoice(allParams);
	}

	@Override
	public String validateDeleteLine(String lineCd)
			throws JSONException, SQLException, ParseException {
		return this.getGiisLineDAO().validateDeleteLine(lineCd);
	}

	@Override
	public String validateAddLine(String lineCd) throws JSONException,
			SQLException, ParseException {
		return this.giisLineDAO.validateAddLine(lineCd);
	}

	@Override
	public String validateAcctLineCd(String acctLineCd)
			throws SQLException {
		return this.giisLineDAO.validateAcctLineCd(acctLineCd);
	}

	@Override
	public List<GIISLine> getLineListingLOV(Map<String, Object> params) throws SQLException {
		return this.giisLineDAO.getLineListingLOV(params);
	}

	@Override
	public String validateLineCdGiris051(Map<String, Object> params)
			throws SQLException {
		return this.giisLineDAO.validateLineCdGiris051(params);
	}

	@Override
	public String getLineCd(String lineName) throws SQLException {
		return this.giisLineDAO.getLineCd(lineName);
	}

	@Override
	public String getLineNameGicls201(HttpServletRequest request, String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("userId", userId);
		
		params = this.giisLineDAO.getLineNameGicls201(params);
		
		return new JSONObject(params).toString();
	}

	@Override
	public String validateGIRIS051LinePPW(HttpServletRequest request) throws SQLException {
		return this.giisLineDAO.validateGIRIS051LinePPW(request.getParameter("lineName"));
	}

	@Override
	public String validateLineCd2(HttpServletRequest request)
			throws SQLException {
		return this.giisLineDAO.validateLineCd2(request.getParameter("lineCd"));
	}

	@Override
	public Map<String, Object> validateGIACS102LineCd(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("lineCd", request.getParameter("lineCd"));
		params.put("lineName", request.getParameter("lineName"));
		return this.getGiisLineDAO().validateGIACS102LineCd(params);
	}
	//added by steven 12.12.2013
	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null){
			String recId = request.getParameter("lineCd");
			this.giisLineDAO.valDeleteRec(recId);
		}
	}

	@Override
	public void saveGiiss001(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISLine.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISLine.class));
		params.put("appUser", userId);
		this.giisLineDAO.saveGiiss001(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", request.getParameter("lineCd"));
		param.put("acctlineCd", request.getParameter("acctlineCd"));
		this.giisLineDAO.valAddRec(param);
	}
	
	@Override
	public void valMenuLineCd(HttpServletRequest request) throws SQLException {
		if(request.getParameter("lineCd") != null){
			String recId = request.getParameter("lineCd");
			this.giisLineDAO.valMenuLineCd(recId);
		}
	}
	//end steve 

	@Override
	public String getGiisLineName2(String lineCd) throws SQLException {
		return this.giisLineDAO.getGiisLineName2(lineCd);
	}
}