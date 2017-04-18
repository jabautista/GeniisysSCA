/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.giac.service.impl;

import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.dao.GIACCollnBatchDAO;
import com.geniisys.giac.entity.GIACCollnBatch;
import com.geniisys.giac.service.GIACCollnBatchService;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIACCollnBatchServiceImpl.
 */
public class GIACCollnBatchServiceImpl implements GIACCollnBatchService{
	
	/** The gipi par item dao. */
	private GIACCollnBatchDAO giacCollnBatchDAO;
	
	/**
	 * @return the giacCollnBatchDAO
	 */
	public GIACCollnBatchDAO getGiacCollnBatchDAO() {
		return giacCollnBatchDAO;
	}
	/**
	 * @param giacCollnBatchDAO the giacCollnBatchDAO to set
	 */
	public void setGiacCollnBatchDAO(GIACCollnBatchDAO giacCollnBatchDAO) {
		this.giacCollnBatchDAO = giacCollnBatchDAO;
	}

	public GIACCollnBatch getDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException {
		return  giacCollnBatchDAO.getDCBNo(fundCd, branchCd, tranDate);
	}
	
	public GIACCollnBatch getNewDCBNo(String fundCd, String branchCd, Date tranDate) throws SQLException {
		return  giacCollnBatchDAO.getNewDCBNo(fundCd, branchCd, tranDate);
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCollnBatchService#getDCBDateLOV(java.lang.Integer, java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getDCBDateLOV(Integer pageNo,
			Map<String, Object> params) throws SQLException {
		List<Map<String, Object>> dcbDateList = this.getGiacCollnBatchDAO().getDCBDateLOV(params);
		PaginatedList paginatedList = new PaginatedList(dcbDateList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	
	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACCollnBatchService#getDCBNoLOV(java.lang.Integer, java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getDCBNoLOV(Integer pageNo, Map<String, Object> params)
			throws SQLException {
		List<Map<String, Object>> dcbDateList = this.getGiacCollnBatchDAO().getDCBNoLOV(params);
		PaginatedList paginatedList = new PaginatedList(dcbDateList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getDCBMaintParams(
			HashMap<String, Object> params) throws SQLException, JSONException {
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACCollnBatch> list = this.getGiacCollnBatchDAO().getDCBNosList(params);
		params.put("rows", new JSONArray((List<GIACCollnBatch>) StringFormatter.escapeHTMLInList(list)));
		params.put("noOfRecords", list.size());
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		System.out.println("TEST === "+grid.getStartRow()+" - "+grid.getEndRow() + " // " + params.get("currentPage") + " ,size= " + list.size());
		return params;
	}
	
	
	@Override
	public void saveDCBNoMaintChanges(String param, String userId)
			throws SQLException, JSONException, ParseException {
		JSONObject objParams = new JSONObject(param);
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", this.prepareDCBForInsert(new JSONArray(objParams.getString("setRows"))));
		params.put("delRows", this.prepareDCBForDelete(new JSONArray(objParams.getString("delRows"))));
		
		this.getGiacCollnBatchDAO().saveCollnBatch(params);
	}
	
	public List<GIACCollnBatch> prepareDCBForInsert(JSONArray setRows) throws JSONException, ParseException {
		List<GIACCollnBatch> dcbList = new ArrayList<GIACCollnBatch>();
		GIACCollnBatch dcb = null;
		JSONObject dcbObj = null;
		//DateFormat df = new SimpleDateFormat("EEE MMM dd hh24:mm:ss z yyyy");
		SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
		
		for(int i=0; i<setRows.length(); i++) {
			dcb = new GIACCollnBatch();
			dcbObj = setRows.getJSONObject(i);
			
			dcb.setDcbNo((dcbObj.isNull("dcbNo") || "".equals(dcbObj.getString("dcbNo"))) ? 0 : dcbObj.getInt("dcbNo"));
			dcb.setDcbYear(dcbObj.isNull("dcbYear") ? null : dcbObj.getInt("dcbYear"));
			dcb.setFundCd(dcbObj.isNull("fundCd") ? null : dcbObj.getString("fundCd"));
			dcb.setBranchCd(dcbObj.isNull("branchCd") ? null : dcbObj.getString("branchCd"));
			dcb.setTranDate(dcbObj.isNull("tranDate") ? null : df.parse(dcbObj.getString("tranDate")));
			dcb.setDcbFlag(dcbObj.isNull("dcbFlag") ? null : dcbObj.getString("dcbFlag"));
			dcb.setRemarks(dcbObj.isNull("remarks") ? null : StringFormatter.unescapeHTML2(dcbObj.getString("remarks")));
			dcb.setUserId(dcbObj.isNull("userId") ? null : dcbObj.getString("userId"));
			dcbList.add(dcb);
			//System.out.println(dcbObj.getString("dcbNo")+"/"+dcbObj.getString("dcbYear"));
		}

		return dcbList;
	}
	
	public List<Map<String, Object>> prepareDCBForDelete(JSONArray delRows) throws JSONException {
		List<Map<String, Object>> dcbList = new ArrayList<Map<String, Object>>();
		Map<String, Object> dcb = null;
		JSONObject dcbObj = null;
		
		for(int i=0; i<delRows.length(); i++) {
			dcb = new HashMap<String, Object>();
			dcbObj = delRows.getJSONObject(i);
			
			dcb.put("dcbNo", dcbObj.isNull("dcbNo") ? null : dcbObj.getInt("dcbNo"));
			dcb.put("dcbYear", dcbObj.isNull("dcbYear") ? null : dcbObj.getInt("dcbYear"));
			dcb.put("fundCd", dcbObj.isNull("fundCd") ? null : dcbObj.getString("fundCd"));
			dcb.put("branchCd", dcbObj.isNull("branchCd") ? null : dcbObj.getString("branchCd"));
			
			dcbList.add(dcb);
		}
		return dcbList;
	}
	@Override
	public Integer generateDCBNo() throws SQLException {
		Integer dcbNo = this.getGiacCollnBatchDAO().generateDCBNo();
		return dcbNo;
	}
	@Override
	public String getClosedTag(HashMap<String, Object> params)
			throws SQLException {
		return this.getGiacCollnBatchDAO().getClosedTag(params);
	}
}
