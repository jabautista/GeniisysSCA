package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISReinsurerDAO;
import com.geniisys.common.entity.CGRefCodes;
import com.geniisys.common.entity.GIISReinsurer;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISReinsurerService;
import com.geniisys.fire.entity.GIISFireOccupancy;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISReinsurerServiceImpl implements GIISReinsurerService {
	
	/** The DAO */
	private GIISReinsurerDAO giisReinsurerDAO;
	
	/** The Log */
	private static Logger log = Logger.getLogger(GIISReinsurerServiceImpl.class);

	public void setGiisReinsurerDAO(GIISReinsurerDAO giisReinsurerDAO) {
		log.info("setGiisReinsurerDAO");
		this.giisReinsurerDAO = giisReinsurerDAO;
	}
	
	public GIISReinsurerDAO getGiisReinsurerDAO() {
		return giisReinsurerDAO;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISReinsurerService#getGiisReinsurerList(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGiisReinsurerList(Integer pageNo, String keyword) throws SQLException {
		List<GIISReinsurer> reinsurerList = this.getGiisReinsurerDAO().getGiisReinsurerList(keyword);
		PaginatedList paginatedList = new PaginatedList(reinsurerList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISReinsurerService#getAllGiisReinsurer()
	 */
	@Override
	public List<GIISReinsurer> getAllGiisReinsurer() throws SQLException {
		return this.getGiisReinsurerDAO().getGiisReinsurerList(null);
	}

	@Override
	public String getInputVatRate(String riCd) throws SQLException {
		return this.getGiisReinsurerDAO().getInputVatRate(riCd);
	}

	@Override
	public GIISReinsurer getGiisReinsurerByRiCd(Integer riCd)
			throws SQLException {
		return this.getGiisReinsurerDAO().getGiisReinsurerByRiCd(riCd);
	}

	@Override
	public String checkIfBinderExist(Map<String, Object> params)	//added by steven 5.17.2012
			throws SQLException {
		return this.getGiisReinsurerDAO().checkIfBinderExist(params);
	}

	@Override
	public String getReinsurerName(String riCd) throws SQLException {		
		return this.getGiisReinsurerDAO().getReinsurerName(riCd);
	}

	@Override
	public JSONObject showGiiss030(HttpServletRequest request)
			throws SQLException, JSONException {		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiiss030RecList");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}

	@Override
	public List<CGRefCodes> getRIBaseList() throws SQLException {
		return this.getGiisReinsurerDAO().getRIBaseList();		
	}

	@Override
	public Map<String, Object> validateGIISS030MobileNo(HttpServletRequest request)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();	
		params.put("param", request.getParameter("param"));	
		params.put("field", request.getParameter("field"));	
		params.put("ctype", request.getParameter("ctype"));
		return this.getGiisReinsurerDAO().validateGIISS030MobileNo(params);
	}
	
	@Override
	public Map<String, Object> getGIISS030MaxRiCd() throws SQLException {
		return this.getGiisReinsurerDAO().getGIISS030MaxRiCd();
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		if(request.getParameter("riName") != null){
			String recId = request.getParameter("riName");
			this.getGiisReinsurerDAO().valAddRec(recId);
		}		
	}

	@Override
	public void saveGiiss030(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISReinsurer.class));
		params.put("appUser", userId);
		this.getGiisReinsurerDAO().saveGiiss030(params);
	}
	
	@Override
	public JSONObject getAllReinsurer(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAllReinsurer");
		Map<String, Object> map = TableGridUtil.getTableGrid(request, params);			
		return new JSONObject(StringFormatter.escapeHTMLInMap(map));
	}
	
}