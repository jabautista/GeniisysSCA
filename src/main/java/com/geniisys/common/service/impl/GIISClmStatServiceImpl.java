package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import com.geniisys.common.dao.GIISClmStatDAO;
import com.geniisys.common.entity.GIISClmStat;
import com.geniisys.common.entity.GIISUser;
import com.geniisys.common.service.GIISClmStatService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;

public class GIISClmStatServiceImpl implements GIISClmStatService{
	private GIISClmStatDAO giisClmStatDAO;
		
	/**
	 * @return the giisClmStatDAO
	 */
	public GIISClmStatDAO getGiisClmStatDAO() {
		return giisClmStatDAO;
	}

	/**
	 * @param giisClmStatDAO the giisClmStatDAO to set
	 */
	public void setGiisClmStatDAO(GIISClmStatDAO giisClmStatDAO) {
		this.giisClmStatDAO = giisClmStatDAO;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.service.GIISClmStatService#getClmStatDtls(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getClmStatDtls(Map<String, Object> params)
			throws SQLException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		System.out.println("startRow: " + grid.getStartRow() + " endRow: " + grid.getEndRow());
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		
		List<Map<String, Object>> clmStatList = this.getGiisClmStatDAO().getClmStatDtls(params);
		
		params.put("rows", new JSONArray((List<Map<String, Object>>)StringFormatter.replaceQuotesInList(clmStatList)));
		grid.setNoOfPages(clmStatList);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("Pages: " + grid.getNoOfPages());
		System.out.println("Total: " + grid.getNoOfRows());
		return params;
	}

	@Override
	public String getClmStatDesc(String clmStatCd) throws SQLException {
		// TODO Auto-generated method stub
		return this.getGiisClmStatDAO().getClmStatDesc(clmStatCd);
	}
	
	//Claim Status Maintenance
		@Override
		public JSONObject showClaimStatusMaintenance(HttpServletRequest request)
				throws SQLException, JSONException {
			Map<String, Object> params = new HashMap<String, Object>();	
			params.put("ACTION", "getClaimStatusMaintenance");	
			return this.giisClmStatDAO.showClaimStatusMaintenance(request, params); 
		}

		@Override
		public Map<String, Object> saveClaimStatusMaintenance(String parameter,
				GIISUser USER) throws SQLException, JSONException, ParseException {
			JSONObject objParameters = new JSONObject(parameter);
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRows")), USER.getUserId(), GIISClmStat.class));
			params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("delRows")), USER.getUserId(), GIISClmStat.class));
			return this.giisClmStatDAO.saveClaimStatusMaintenance(params);
		}

		@Override
		public Map<String, Object> chkIfValidInput(HttpServletRequest request)
				throws SQLException {
			Map<String, Object> params = new HashMap<String, Object>();	
			params.put("txtField", request.getParameter("txtField"));	
			params.put("searchString", request.getParameter("searchString"));
			return this.giisClmStatDAO.chkIfValidInput(params);
		}	

}
