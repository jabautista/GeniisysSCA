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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.giac.controllers.GIACOtherBranchORController;
import com.geniisys.giac.dao.GIACBranchDAO;
import com.geniisys.giac.entity.GIACBranch;
import com.geniisys.giac.service.GIACBranchService;
import com.geniisys.gipi.entity.GIPIUserEvent;
import com.seer.framework.util.Debug;
import com.seer.framework.util.StringFormatter;

/**
 * The Class GIACBranchServiceImpl.
 */
public class GIACBranchServiceImpl implements GIACBranchService{
	
	/** The gipi par item dao. */
	private GIACBranchDAO giacBranchDAO;
	
	private static Logger log = Logger.getLogger(GIACOtherBranchORController.class);
	
	/**
	 * Gets the GIACBranch dao.
	 * @return the GIACBranch dao
	 */
	public GIACBranchDAO getGiacBranchDAO() {
		return giacBranchDAO;
	}

	/**
	 * Sets the GIACBranch dao.
	 * 
	 * @param GiacBranchDAO the new GiacBranchDAO dao
	 */
	public void setGiacBranchDAO(GIACBranchDAO giacBranchDAO) {
		this.giacBranchDAO = giacBranchDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBranchService#getBranchDetails()
	 */
	@Override
	public GIACBranch getBranchDetails() throws SQLException {
		return (GIACBranch) getGiacBranchDAO().getBranchDetails();
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBranchService#getOtherBranchOR(java.lang.String, java.util.HashMap)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public HashMap<String, Object> getOtherBranchOR(String moduleId, String userId,
			HashMap<String, Object> params) throws SQLException {
		log.info("Retrieving Branch OR List...");
		Integer pageSize = ApplicationWideParameters.PAGE_SIZE;
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), pageSize);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACBranch> branchOR = this.getGiacBranchDAO().getOtherBranchOR(moduleId, userId);
		params.put("rows", new JSONArray((List<GIACBranch>) StringFormatter.replaceQuotesInList(branchOR)));
		System.out.println("branch or qty: " + branchOR.size());
		int totalPages = (int) Math.ceil(((double) branchOR.size() / (double)pageSize));
		System.out.println("total pages: " + totalPages);
		params.put("pages", totalPages);
		params.put("total", branchOR.size());
		System.out.println("params::: " + params.toString());
		log.info("Branch OR map retrieved...");
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBranchService#getDefBranchBankDtls(java.util.Map)
	 */
	@Override
	public Map<String, Object> getDefBranchBankDtls(Map<String, Object> params)	throws SQLException {
		Debug.print("BEFORE BRANCH DEFAULT DETAILS: " + params);
		Map<String, Object> resultParam = giacBranchDAO.getDefBranchBankDtls(params);
		Debug.print("AFTER BRANCH DEFAULT DETAILS: " + resultParam);
		return resultParam;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBranchService#getBranchCdLOV(java.lang.Integer, java.lang.String, java.util.Map)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getBranchCdLOV(Integer pageNo, Map<String, Object> params)
			throws SQLException {
		List<Map<String, Object>> branchCdList = this.getGiacBranchDAO().getBranchCdLOV(params);
		PaginatedList paginatedList = new PaginatedList(branchCdList, ApplicationWideParameters.PAGE_SIZE);
		paginatedList.gotoPage(pageNo);
		return paginatedList;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBranchService#getBranchesGIACS333(java.lang.String)
	 */
	@Override
	public List<GIACBranch> getBranchesGIACS333(String userId)
			throws SQLException {
		return this.getGiacBranchDAO().getBranchesGIACS333(userId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBranchService#getBranchLOV(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public void getBranchLOV(Map<String, Object> params) throws SQLException, JSONException {
		log.info("Retrieving GIAC Branch lov...");
		TableGridUtil grid = new TableGridUtil((Integer) params.get("currentPage"), ApplicationWideParameters.PAGE_SIZE);
		params.put("from", grid.getStartRow());
		params.put("to", grid.getEndRow());
		List<GIACBranch> list = this.getGiacBranchDAO().getBranchLOV(params);
		params.put("rows", new JSONArray((List<GIPIUserEvent>) StringFormatter.replaceQuotesInList(list)));
		grid.setNoOfPages(list);
		params.put("pages", grid.getNoOfPages());
		params.put("total", grid.getNoOfRows());
		log.info("GIAC Branch lov retrieved.");
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giac.service.GIACBranchService#getBranchDetails2(java.lang.String)
	 */
	@Override
	public GIACBranch getBranchDetails2(String branchCd) throws SQLException {
		return this.getGiacBranchDAO().getBranchDetails2(branchCd);
	}

	@Override
	public String validateGIACS117BranchCd(Map<String, Object> params) throws SQLException {
		return this.getGiacBranchDAO().validateGIACS117BranchCd(params);
	}
	
	@Override
	public String validateGIACS170BranchCd(Map<String, Object> params) throws SQLException {
		return this.getGiacBranchDAO().validateGIACS170BranchCd(params);
	}
	
	@Override
	public String validateGIACS078BranchCd(Map<String, Object> params) throws SQLException {
		return this.getGiacBranchDAO().validateGIACS078BranchCd(params);
	}

	@Override
	public String validateGIACBranchCd(HttpServletRequest request,  String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("branchCd", request.getParameter("branchCd"));
		return giacBranchDAO.validateGIACBranchCd(params);
	}

	@Override
	public String validateGIACS178BranchCd(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("branchCd", request.getParameter("branchCd"));
		return giacBranchDAO.validateGIACS178BranchCd(params);
	}

	@Override
	public String validateGIACS273BranchCd(HttpServletRequest request, String userId)throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("fundCd", request.getParameter("fundCd"));
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);
		
		return this.giacBranchDAO.validateGIACS273BranchCd(params);
	}

	@Override
	public JSONObject showGiacs303(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> giacs303 = new HashMap<String, Object>();
		String fundCd = null;
		
		if(request.getParameter("fundCd") == null) {
			Map<String, Object> giacs303NewFormParams = new HashMap<String, Object>();
			this.giacBranchDAO.giacs303NewFormInstance(giacs303NewFormParams);
			giacs303.put("vars", StringFormatter.escapeHTMLInMap(giacs303NewFormParams));
			//fundCd = (String) giacs303NewFormParams.get("fundCd");
		} 
		
		fundCd = request.getParameter("fundCd"); //edited by angelo 02.06.2014 --to prevent display branches on tablegrid

			
		//testing
		System.out.println("Current fund cd : " + request.getParameter("fundCd"));
		//end
		
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGiacs303BranchList");
		params.put("fundCd", fundCd);		
		
		Map<String, Object> giacBranches = TableGridUtil.getTableGrid(request, params);
		if(request.getParameter("fundCd") == null) {
			giacs303.put("branches", giacBranches);		
			return new JSONObject(giacs303);			
		} else {
			return new JSONObject(giacBranches);			
		}
	}

	@Override
	public void valDeleteBranch(HttpServletRequest request, String userId)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("branchCd", request.getParameter("branchCd"));
		params.put("fundCd", request.getParameter("fundCd"));
		
		this.giacBranchDAO.valDeleteBranch(params);
	}

	@Override
	public void saveGiacs303(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIACBranch.class));
		params.put("appUser", userId);		
		this.giacBranchDAO.saveGiacs303(params);
	}

	@Override
	public void validateBranchCdInAcctrans(HttpServletRequest request,
			String userId) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userId", userId);
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("branchCd", request.getParameter("branchCd"));
		request.setAttribute("object", giacBranchDAO.validateBranchCdInAcctrans(params));		
	}

	@Override
	public JSONObject getBatchBranchList(HttpServletRequest request, String userId) throws SQLException, ParseException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getBatchBranchList");
		params.put("batchYear", Integer.parseInt(request.getParameter("batchYear")));
		params.put("batchMonth", Integer.parseInt(request.getParameter("batchMonth")));
		params.put("userId", userId);
		params.put("pageSize", 50);
		log.info("Getting List of Branches for " + params);
		Map<String, Object> batchBranchTableGrid = TableGridUtil.getTableGrid(request, params);
		JSONObject jsonBatchBranch = new JSONObject(batchBranchTableGrid);
		request.setAttribute("batchBranchList", jsonBatchBranch);
		return jsonBatchBranch;
	}

	@Override
	public JSONObject getGIACS156Branches(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map <String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIACS156Branches");
		params.put("moduleId", request.getParameter("moduleId"));
		params.put("userId", userId);		
		Map<String, Object> grid = TableGridUtil.getTableGrid(request, params);
		JSONObject json = new JSONObject(grid);
		return json;
	}
}
