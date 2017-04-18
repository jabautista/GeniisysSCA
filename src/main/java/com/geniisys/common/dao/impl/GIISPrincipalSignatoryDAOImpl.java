/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.common.dao.impl
	File Name: GIISPrincipalSignatoryDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: May 24, 2011
	Description: 
*/


package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.common.dao.GIISPrincipalSignatoryDAO;
import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISCosignorRes;
import com.geniisys.common.entity.GIISPrincipalRes;
import com.geniisys.common.entity.GIISPrincipalSignatory;
import com.geniisys.framework.util.JSONUtil;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPrincipalSignatoryDAOImpl implements GIISPrincipalSignatoryDAO{
	
	private Logger log = Logger.getLogger(GIISPrincipalSignatoryDAOImpl.class);
	private SqlMapClient sqlMapClient;
//	@SuppressWarnings("unchecked")
//	@Override
//	public List<GIISPrincipalSignatory> getPrincipalSignatories(
//			Map<String, Object> params) throws SQLException {
//		log.info("GETTING PRINCIPAL SIGNATORIES FOR ASSURED NO: "+params.get("assdNo"));
//		return this.getSqlMapClient().queryForList("getPrincipalSignatories",params);
//	}
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	@Override
	public GIISPrincipalRes getAssuredPrincipalResInfo(int assdNo)
			throws SQLException {
		log.info("GETTING PRINCIPAL RES INFORMATION FOR ASSURED NO: "+assdNo);
		return (GIISPrincipalRes) this.getSqlMapClient().queryForObject("getAssuredPrincipalResInfo", assdNo);
	}
	@Override
	public String validatePrincipalORCoSignorId(Map<String, Object> params)
			throws SQLException {
		String mode = (String) params.get("mode");
		String result = "";
		if ("P".equals(mode)) {
			log.info("CHECKING IF PRINCIPAL ID("+params.get("id")+") IS ALREADY EXISTING IN GIIS_COSIGNOR_RES..");
			result = (String) this.getSqlMapClient().queryForObject("validatePrincipalId", params);  //modified by Halley 10.07.13
		}else if ("C".equals(mode)) {
			log.info("CHECKING IF COSIGNOR ID("+params.get("id")+") IS ALREADY EXISTING IN GIIS_PRIN_SIGNTRY..");
			result = (String) this.getSqlMapClient().queryForObject("validateCosignorId", params);  //modified by Halley 10.07.13
		}
		log.info("result: "+result);
		return result;
	}
	@Override
	public String validateCTCNo(String ctcNo) throws SQLException {
		log.info("VALIDATING CTC NO: "+ctcNo);
		return (String) this.getSqlMapClient().queryForObject("validateCTCNo", ctcNo);
	}
	@SuppressWarnings("unchecked")
	@Override
	public void savePrincipalSignatory(Map<String, Object>params) throws SQLException, JSONException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			System.out.println(params.get("strParameters"));
			String strParameters = (String) params.get("strParameters");
			JSONObject objParameters = new JSONObject(strParameters);
			System.out.println(objParameters);
			String userId = (String) params.get("userId");
			Integer assdNo =   (Integer)params.get("assdNo");
			
			log.info("SAVING PRINCIPAL RES INFO..");
			List<GIISPrincipalRes> setPrincipal = (List<GIISPrincipalRes>) JSONUtil.prepareObjectListFromJSON( new JSONArray(objParameters.getString("setPrincipal")), userId, GIISPrincipalRes.class);
			log.info("No of signatories to process: "+setPrincipal.size());
			for (GIISPrincipalRes prin : setPrincipal ){
				this.getSqlMapClient().insert("saveGIISPrincipalRes", prin);
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("PREPARING PRINCIPAL SIGNATORIES PARAMETERS..");
			//JSONArray prinArray = new JSONArray(objParameters.getString("setRowsPrincipal"));
			List<GIISPrincipalSignatory> setPrincipalSignatories = (List<GIISPrincipalSignatory>) JSONUtil.prepareObjectListFromJSON( new JSONArray(objParameters.getString("setRowsPrincipal")), userId, GIISPrincipalSignatory.class);
			log.info("No of signatories to process: "+setPrincipalSignatories.size());
			Map<String, Object> setParams;
			for (GIISPrincipalSignatory prinSig : setPrincipalSignatories ){
				setParams = new HashMap<String, Object>();
				setParams.put("prinSignor", prinSig.getPrinSignor());
				setParams.put("designation", prinSig.getDesignation());
				setParams.put("prinId", prinSig.getPrinId());
				setParams.put("resCert", prinSig.getResCert());
				setParams.put("issuePlace", prinSig.getIssuePlace());
				setParams.put("issueDate", prinSig.getIssueDate());
				setParams.put("userId", userId);
				setParams.put("remarks", prinSig.getRemarks());
				setParams.put("address", prinSig.getAddress());		
				setParams.put("assdNo", assdNo);
				setParams.put("controlTypeCd", prinSig.getControlTypeCd());
				setParams.put("bondSw", prinSig.getBondSw());
				setParams.put("indemSw", prinSig.getIndemSw());
				setParams.put("ackSw", prinSig.getAckSw());
				setParams.put("certSw", prinSig.getCertSw());
				setParams.put("riSw", prinSig.getRiSw());
				this.getSqlMapClient().insert("saveGIISPrincipalSignatory", setParams);
			}
			this.getSqlMapClient().executeBatch();
			
			log.info("PREPARING COSIGNOR PARAMETERS..");
			List<GIISCosignorRes> setCosignors = (List<GIISCosignorRes>) JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("setRowsCosignor")), userId, GIISCosignorRes.class);
			log.info("No. of cosignor to process: "+setCosignors.size());
			Map<String, Object> setParamsCos;
			for (GIISCosignorRes giisCosignorRes : setCosignors) {
				setParamsCos = new HashMap<String, Object>();
				setParamsCos = new HashMap<String, Object>();
				setParamsCos.put("cosignName", giisCosignorRes.getCosignName());
				setParamsCos.put("designation",giisCosignorRes.getDesignation());
				setParamsCos.put("cosignId",giisCosignorRes.getCosignId());
				setParamsCos.put("cosignResNo", giisCosignorRes.getCosignResNo());
				setParamsCos.put("cosignResPlace", giisCosignorRes.getCosignResPlace());
				setParamsCos.put("cosignResDate", giisCosignorRes.getCosignResDate());
				setParamsCos.put("userId", userId);
				setParamsCos.put("remarks", giisCosignorRes.getRemarks());
				setParamsCos.put("address", giisCosignorRes.getAddress());		
				setParamsCos.put("assdNo", assdNo);
				setParamsCos.put("controlTypeCd", giisCosignorRes.getControlTypeCd());
				this.getSqlMapClient().insert("saveGIISCosignor", setParamsCos);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally {
			this.getSqlMapClient().endTransaction();
		}	
	}
	@Override
	public GIISAssured getInitialAssdNo() throws SQLException {
		return (GIISAssured) this.getSqlMapClient().queryForObject("getInitialAssdNo");
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getPrinSignatoryIDList(Integer assdNo)throws SQLException {
		return this.sqlMapClient.queryForList("getPrincipalSignatoryIDList", assdNo);
	}
	@Override
	public String validateCTCNo2(Map<String, Object> params)
			throws SQLException {
		log.info("VALIDATING CTC NO: "+params.get("CTCNo"));
		return (String) this.getSqlMapClient().queryForObject("validateCTCNo2", params);
	}
}
