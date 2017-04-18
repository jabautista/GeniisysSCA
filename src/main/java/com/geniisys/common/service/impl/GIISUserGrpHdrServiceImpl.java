/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.service.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISUserGrpHdrDAO;
import com.geniisys.common.entity.GIISUserGrpDtl;
import com.geniisys.common.entity.GIISUserGrpHdr;
import com.geniisys.common.entity.GIISUserGrpLine;
import com.geniisys.common.entity.GIISUserGrpModule;
import com.geniisys.common.entity.GIISUserGrpTran;
import com.geniisys.common.service.GIISUserGrpHdrService;
import com.geniisys.framework.util.ApplicationWideParameters;
import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.PaginatedList;
import com.geniisys.framework.util.TableGridUtil;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIISUserGrpHdrServiceImpl.
 */
public class GIISUserGrpHdrServiceImpl implements GIISUserGrpHdrService {

	/** The log. */
	private Logger log = Logger.getLogger(GIISUserGrpHdrServiceImpl.class);
	
	/** The giis user grp hdr dao. */
	private GIISUserGrpHdrDAO giisUserGrpHdrDAO;
	
	/**
	 * Gets the giis user grp hdr dao.
	 * 
	 * @return the giis user grp hdr dao
	 */
	public GIISUserGrpHdrDAO getGiisUserGrpHdrDAO() {
		return giisUserGrpHdrDAO;
	}
	
	/**
	 * Sets the giis user grp hdr dao.
	 * 
	 * @param giisUserGrpHdrDAO the new giis user grp hdr dao
	 */
	public void setGiisUserGrpHdrDAO(GIISUserGrpHdrDAO giisUserGrpHdrDAO) {
		this.giisUserGrpHdrDAO = giisUserGrpHdrDAO;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpHdrService#getGiisUserGrpList(java.lang.String)
	 */
	@Override
	public List<GIISUserGrpHdr> getGiisUserGrpList(String param) throws SQLException {
		return this.getGiisUserGrpHdrDAO().getGiisUserGrpList(param);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpHdrService#getGiisUserGroupList(java.lang.String, int)
	 */
	@SuppressWarnings("deprecation")
	@Override
	public PaginatedList getGiisUserGroupList(String param, int pageNo) throws SQLException {
		PaginatedList userGroups = new PaginatedList(this.getGiisUserGrpHdrDAO().getGiisUserGrpList(param), ApplicationWideParameters.PAGE_SIZE);
		userGroups.gotoPage(pageNo-1);
		return userGroups;
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpHdrService#setGiisUserGrpHdr(java.util.Map)
	 */
	@Override
	public void setGiisUserGrpHdr(Map<String, Object> params) throws SQLException {
		log.info("Service preparing user grp hdr details for saving...");
		int userGrp = (Integer) params.get("userGrp");
		String userGrpDesc = (String) params.get("userGrpDesc");
		String grpIssCd = (String) params.get("grpIssCd");
		String remarks = (String) params.get("remarks");
		String userId = (String) params.get("userId");
		
		String[] pTransaction = (String[]) params.get("pTransactions");
		String[] pModules = (String[]) params.get("pModules");
		String[] pIssSources = (String[]) params.get("pIssSources");
		String[] pLines = (String[]) params.get("pLines");
		
		GIISUserGrpHdr userGrpHdr = new GIISUserGrpHdr(userGrp, userGrpDesc, grpIssCd, remarks, userId, new ArrayList<GIISUserGrpTran>());
		for (int i=0; i<pTransaction.length; i++) {
			if (!"".equals(pTransaction[i])) {
				int tranCd = Integer.parseInt(pTransaction[i]);
				GIISUserGrpTran t = new GIISUserGrpTran(userGrp, tranCd, "", "", userId);
				
				String[] issSources = pIssSources[i].split(",");
				String[] modules = pModules[i].split(",");
				
				List<GIISUserGrpDtl> issList = new ArrayList<GIISUserGrpDtl>();
				
				if (i < pLines.length) {
					String[] pplines = pLines[i].split("--");
					for (int j=0; j<issSources.length; j++) {
						System.out.println("test : " + issSources[j]);
						if (!issSources[j].equals("void")){ //added by angelo for null isssources
							List<GIISUserGrpLine> lines = new ArrayList<GIISUserGrpLine>();
							System.out.println("TRAN CD: " + tranCd + " ISS CD: " + issSources[j]);
							if (j < pplines.length) {
								//if (j < pplines.length) {
									//if (!"void".equals(issSources[j])) {
									GIISUserGrpDtl issSource = new GIISUserGrpDtl(userGrp, tranCd, issSources[j], "", userId, lines);
									issList.add(issSource);
									//}
								
									String[] tLines = pplines[j].split(",");
									for (int k=0; k<tLines.length; k++) {
										System.out.println("testing...");
										if (!tLines[k].equals("void") && !"]".contains(tLines[k]) && !"[".contains(tLines[k])) {
											lines.add(new GIISUserGrpLine(userGrp, tranCd, issSources[j], tLines[k], "", userId));
										}
									}
								//}
							}
						}
					}
				}
				/*
				System.out.println("angelo testing : " + issSources.length);
				
				if (i < issSources.length) {
					System.out.println("went here again...");
					String[] pplines = pLines[i].split("--");
					for (int j=0; j<issSources.length; j++) {
						System.out.println("test : " + issSources[j]);
						if (!issSources[j].equals("void")){ //added by angelo for null isssources
							List<GIISUserGrpLine> lines = new ArrayList<GIISUserGrpLine>();
							System.out.println("TRAN CD: " + tranCd + " ISS CD: " + issSources[j]);
							if (j < pplines.length) {
								//if (j < pplines.length) {
									//if (!"void".equals(issSources[j])) {
									GIISUserGrpDtl issSource = new GIISUserGrpDtl(userGrp, tranCd, issSources[j], "", userId, lines);
									issList.add(issSource);
									//}
								
									String[] tLines = pplines[j].split(",");
									for (int k=0; k<tLines.length; k++) {
										System.out.println("testing...");
										if (!tLines[k].equals("void") && !"]".contains(tLines[k]) && !"[".contains(tLines[k])) {
											lines.add(new GIISUserGrpLine(userGrp, tranCd, issSources[j], tLines[k], "", userId));
										}
									}
								//}
							}
						}
					}
				}*/
				List<GIISUserGrpModule> userGrpModules = new ArrayList<GIISUserGrpModule>();
				for (String m: modules) {
					if (!m.equals("void")){ //added by angelo for null lines
						// mark jm 04.06.2011 @UCPBGen
						// change "" access tag to 1
						userGrpModules.add(new GIISUserGrpModule(userGrp, tranCd, m, userId, "1"));
					}
				}
				
				t.setModules(userGrpModules);
				t.setIssueSources(issList);
				userGrpHdr.getTransactions().add(t);
			}
		}

		log.info("Service calling DAO to delete user grp hdr details...");
		this.getGiisUserGrpHdrDAO().deleteGiisUserGrpHdrDetails(userGrpHdr);
		log.info("Deletion of transactions successful!");
		
		log.info("Service calling DAO to save user grp hdr...");
		this.getGiisUserGrpHdrDAO().setGiisUserGrpHdr(userGrpHdr);
		log.info("Saving of transactions successful!");
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpHdrService#getGiisUserGrpHdr(int)
	 */
	@Override
	public GIISUserGrpHdr getGiisUserGrpHdr(int userGrp) throws SQLException {
		return (GIISUserGrpHdr) StringFormatter.replaceQuotesInObject(this.getGiisUserGrpHdrDAO().getGiisUserGrpHdr(userGrp));
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpHdrService#deleteGiisUserGrpHdr(int)
	 */
	@Override
	public void deleteGiisUserGrpHdr(int userGrp) throws SQLException {
		this.getGiisUserGrpHdrDAO().deleteGiisUserGrpHdr(userGrp);
	}
	
	/* (non-Javadoc)
	 * @see com.geniisys.common.service.GIISUserGrpHdrService#deleteGiisUserGrpHdrDetails(com.geniisys.common.entity.GIISUserGrpHdr)
	 */
	@Override
	public void deleteGiisUserGrpHdrDetails(GIISUserGrpHdr userGrpHdr)
			throws SQLException {
		this.getGiisUserGrpHdrDAO().deleteGiisUserGrpHdrDetails(userGrpHdr);
	}

	@Override
	public String getUserGrpHdrs() throws SQLException {
		List<GIISUserGrpHdr> userGrps = this.getGiisUserGrpHdrDAO().getGiisUserGrpList("");
		StringBuilder sb = new StringBuilder();
		for (GIISUserGrpHdr u: userGrps) {
			sb.append(u.getUserGrp()).append(",");
		}
		
		return sb.toString();
	}

	@Override
	public String copyUserGrp(Map<String, Object> params) throws SQLException {
		return this.getGiisUserGrpHdrDAO().copyUserGrp(params);
	}

	@Override
	public JSONObject showGIISS041(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getGIISS041RecList");
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}

	@Override
	public void valDeleteRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userGrp", request.getParameter("userGrp"));
		this.getGiisUserGrpHdrDAO().valDeleteRec(params);
	}

	@Override
	public void valAddRec(HttpServletRequest request) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("userGrp", request.getParameter("userGrp"));
		this.getGiisUserGrpHdrDAO().valAddRec(params);
	}

	@Override
	public void saveGIISS041(HttpServletRequest request, String userId)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setRows")), userId, GIISUserGrpHdr.class));
		params.put("delRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delRows")), userId, GIISUserGrpHdr.class));
		params.put("appUser", userId);
		this.getGiisUserGrpHdrDAO().saveGIISS041(params);
	}
	
}
