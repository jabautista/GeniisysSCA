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

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISAssuredDAO;
import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISAssuredIndividualInformation;
import com.geniisys.common.entity.GIISGroup;
import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.common.service.GIISAssuredFacadeService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONArrayList;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISAssuredFacadeServiceImpl.
 */
public class GIISAssuredFacadeServiceImpl implements GIISAssuredFacadeService {

	/** The log. */
	private Logger log = Logger.getLogger(GIISAssuredFacadeServiceImpl.class);
	
	/** The giis assured dao. */
	GIISAssuredDAO giisAssuredDao;
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getGIISAssuredByAssdNo(java.lang.String)
	 */
	@Override
	public GIISAssured getGIISAssuredByAssdNo(String assdNo)
			throws SQLException {
		Integer assdNo_ = Integer.parseInt(assdNo);
		return giisAssuredDao.getGIISAssuredByAssdNo(assdNo_);
	}

	/**
	 * Gets the giis assured dao.
	 * 
	 * @return the giis assured dao
	 */
	public GIISAssuredDAO getGiisAssuredDao() {
		return giisAssuredDao;
	}

	/**
	 * Sets the giis assured dao.
	 * 
	 * @param giisAssuredDao the new giis assured dao
	 */
	public void setGiisAssuredDao(GIISAssuredDAO giisAssuredDao) {
		this.giisAssuredDao = giisAssuredDao;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getAssuredList(java.lang.Integer, java.lang.String)
	 */
	@Override
	public JSONArrayList getAssuredList(Integer pageNo, String keyword) throws SQLException {
		List<GIISAssured> assuredList = this.getGiisAssuredDao().getAssuredList(keyword);
		JSONArrayList assdArray = new JSONArrayList(assuredList, pageNo);
		//PaginatedList paginatedList = new PaginatedList(procs, ApplicationWideParameters.PAGE_SIZE);
		return assdArray;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getAssuredList(java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getAssuredListing(Integer pageNo, String keyword) throws SQLException {
		List<GIISAssured> assuredList = this.getGiisAssuredDao().getAssuredList(keyword);
		PaginatedList paginatedList = new PaginatedList(assuredList, ApplicationWideParameters.PAGE_SIZE);		
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#deleteAssured(com.geniisys.common.entity.GIISAssured)
	 */
	@Override
	public void deleteAssured(GIISAssured assured) throws SQLException {
		this.getGiisAssuredDao().deleteAssured(assured);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#saveAssured(com.geniisys.common.entity.GIISAssured)
	 */
	@Override
	public Integer saveAssured(GIISAssured assured) throws SQLException {
		Integer assuredNo = null;
		if (assured.getAssdNo() == 0) {
			assuredNo = this.getGiisAssuredDao().getAssuredNoSequence();
			assured.setAssdNo(assuredNo);
		} else {
			assuredNo = assured.getAssdNo();
		}
		log.info("AssuredNo: " + assuredNo);
		this.getGiisAssuredDao().saveAssured(assured);
		return assuredNo;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getAssuredLovList()
	 */
	@Override
	public List<GIISAssured> getAssuredLovList() throws SQLException {
		return this.getGiisAssuredDao().getAssuredLovList();
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getGiisAssuredDetails(java.lang.Integer)
	 */
	@Override
	public GIISAssured getGiisAssuredDetails(Integer assdNo) throws SQLException {
		return this.getGiisAssuredDao().getGiisAssuredDetails(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#saveGIISAssuredIntm(int, java.lang.String, java.lang.Integer)
	 */
	@Override
	public void saveGIISAssuredIntm(int assdNo, String lineCd, Integer intmNo, String userId)
			throws SQLException {
		Map<String, Object> assdIntmParams = new HashMap<String, Object>();
		assdIntmParams.put("assdNo", assdNo);
		assdIntmParams.put("lineCd", lineCd);
		assdIntmParams.put("intmNo", intmNo);
		assdIntmParams.put("appUser", userId);
		this.getGiisAssuredDao().saveGIISAssuredIntm(assdIntmParams);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#deleteGIISAssdIntm(java.lang.Integer)
	 */
	@Override
	public void deleteGIISAssdIntm(Integer assdNo) throws SQLException {
		this.getGiisAssuredDao().deleteGIISAssdIntm(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getGIISAssuredIntm(java.lang.Integer)
	 */
	@Override
	public List<GIISIntermediary> getGIISAssuredIntm(Integer assdNo)
			throws SQLException {
		return this.getGiisAssuredDao().getGIISAssuredIntm(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#saveGIISAssuredGroup(int, int)
	 */
	@Override
	public void saveGIISAssuredGroup(int assdNo, int groupCd, String remarks, String userId)
			throws SQLException {
		Map<String, Object> assdGroupParams = new HashMap<String, Object>();
		assdGroupParams.put("assdNo", assdNo);
		assdGroupParams.put("groupCd", groupCd);
		assdGroupParams.put("remarks", StringFormatter.unescapeHTML(StringFormatter.unescapeBackslash(remarks)));
		assdGroupParams.put("appUser", userId);
		this.getGiisAssuredDao().saveGIISAssuredGroup(assdGroupParams);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getGIISAssuredGroup(int)
	 */
	@Override
	public List<GIISGroup> getGIISAssuredGroup(int assdNo) throws SQLException {
		return this.getGiisAssuredDao().getGIISAssuredGroup(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#deleteGIISAssdGroup(java.lang.Integer)
	 */
	@Override
	public void deleteGIISAssdGroup(Integer assdNo) throws SQLException {
		this.getGiisAssuredDao().deleteGIISAssdGroup(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#saveGIISAssuredIndInfo(com.geniisys.common.entity.GIISAssuredIndividualInformation)
	 */
	@Override
	public void saveGIISAssuredIndInfo(
			GIISAssuredIndividualInformation assuredIndividualInformation)
			throws SQLException {
		this.getGiisAssuredDao().saveGIISAssuredIndInfo(assuredIndividualInformation);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getGIISAssuredIndividualInfo(java.lang.Integer)
	 */
	@Override
	public GIISAssuredIndividualInformation getGIISAssuredIndividualInfo(
			Integer assdNo) throws SQLException {
		return getGiisAssuredDao().getGIISAssuredIndividualInfo(assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISAssuredFacadeService#getAcctOfList(java.lang.Integer, java.lang.Integer, java.lang.String)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getAcctOfList(Integer pageNo, Integer assdNo,
			String keyword) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("assdNo", assdNo);
		params.put("keyword", keyword);
		List<GIISAssured> procs = this.getGiisAssuredDao().getAcctOfList(params);
		PaginatedList paginatedList = new PaginatedList(procs, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
		
	}

	@Override
	public String checkAssuredDependencies(Integer assdNo) throws SQLException {
		return this.getGiisAssuredDao().checkAssuredDependencies(assdNo);
	}

	@Override
	public void deleteAssured(Integer assdNo) throws SQLException {
		this.getGiisAssuredDao().deleteAssured(assdNo);
	}

	@Override
	public Map<String, Object> getAssdMailingAddress(Map<String, Object> params)
			throws SQLException {
		return this.getGiisAssuredDao().getAssdMailingAddress(params);
	}

	
	public List<GIISAssured> getExistingAssured(String assdName)
			throws SQLException{
		return this.getGiisAssuredDao().getExistingAssured(assdName);
	}

	@Override
	public Map<String, Object> checkAssdMobileNo(Map<String, Object> params)
			throws SQLException {
		return this.getGiisAssuredDao().checkAssdMobileNo(params);
	}

	@Override
	public String checkRefCd(String refCd) throws SQLException {
		return this.getGiisAssuredDao().checkRefCd(refCd);
	}

	@Override
	public String checkRefCd2(Map<String, Object> params) throws SQLException {
		return this.getGiisAssuredDao().checkRefCd2(params);
	}
	
	@Override
	public Integer getFirstRecord() throws SQLException {
		return this.getGiisAssuredDao().getFirstRecord();
	}

	@Override
	public Map<String, Object> validateAssdNo(Map<String, Object> params)
			throws SQLException {
		return this.getGiisAssuredDao().validateAssdNo(params);
	}

	@Override
	public List<GIISAssured> validateAssdNoGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.getGiisAssuredDao().validateAssdNoGiexs006(params);
	}

	@Override
	public String checkAssuredExistGiiss006b(Map<String, Object> params)
			throws SQLException {
		return getGiisAssuredDao().checkAssuredExistGiiss006b(params);
	}
	
	@Override
	public String checkAssuredExistGiiss006b2(Map<String, Object> params)
			throws SQLException {
		return getGiisAssuredDao().checkAssuredExistGiiss006b2(params);
	}

	@Override
	public String getPostQueryGiiss006b(Integer assdNo) throws SQLException {
		return getGiisAssuredDao().getPostQueryGiiss006b(assdNo);
	}

	@Override
	public void deleteGiisAssured(Map<String, Object> params)
			throws SQLException, Exception {
		this.getGiisAssuredDao().deleteGiisAssured(params);
	}

	@Override
	public void valDeleteGroupInfo(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("assdNo", Integer.parseInt(request.getParameter("assdNo")));
		params.put("groupCd", request.getParameter("groupCd"));
		this.getGiisAssuredDao().valDeleteGroupInfo(params);
	}

	@Override
	public JSONObject getAssuredIntmList(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAssuredIntmList");
		params.put("assdNo", request.getParameter("assdNo"));		
		
		Map<String, Object> intmList = TableGridUtil.getTableGrid(request, params);			
		JSONObject jsonIntmList = new JSONObject(intmList);
				
		return jsonIntmList;
	}
	
	//benjo 09.07.2016 SR-5604
	@Override
	public String checkDfltIntm(Map<String, Object>params)throws SQLException{
		return this.getGiisAssuredDao().checkDfltIntm(params);
	}
}