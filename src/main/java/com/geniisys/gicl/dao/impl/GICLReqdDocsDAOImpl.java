/**************************************************/
/**
	Project: Geniisys
	Package: com.geniisys.gicl.dao.impl
	File Name: GICLReqdDocsDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Aug 5, 2011
	Description: 
*/


package com.geniisys.gicl.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONObject;

import atg.taglib.json.util.JSONException;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.gicl.dao.GICLReqdDocsDAO;
import com.geniisys.gicl.entity.GICLReqdDocs;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GICLReqdDocsDAOImpl implements GICLReqdDocsDAO{
	
	private SqlMapClient sqlMapClient;
	private static Logger log = Logger.getLogger(GICLReqdDocsDAOImpl.class);
	
	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		log.info("setSqlMapClient");
		this.sqlMapClient = sqlMapClient;
	}

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveClaimDocs(Map<String, Object> params) throws SQLException ,JSONException, Exception{
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
				this.getSqlMapClient().startBatch();
			System.out.println(params.get("strParameters"));
			String strParameters = (String) params.get("strParameters");
			JSONObject objParameters = new JSONObject(strParameters);
			String claimId = objParameters.getString("claimId");
			String lineCd = objParameters.getString("lineCd");
			String sublineCd = objParameters.getString("sublineCd");
			String issCd = objParameters.getString("issCd");
			String userId = (String) params.get("userId");
			String mode = (String) params.get("mode");
			log.info("CLAIM ID: "+claimId);
			System.out.println("MODE IS: "+mode);
			if (mode.equals("insert")) {
				log.info("SAVING CLAIM REQUIRED DOCS FOR CLAIM ID: "+claimId);
				JSONArray docs = new JSONArray(objParameters.getString("addDocs"));
				Map<String, Object> docsParams;
				for (int i = 0; i < docs.length(); i++) {
					System.out.println("docCd:"+ docs.getJSONObject(i).getString("clmDocCd"));
					docsParams = new HashMap<String, Object>();
					docsParams.put("lineCd", lineCd);
					docsParams.put("sublineCd", sublineCd);
					docsParams.put("issCd", issCd);
					docsParams.put("userId", userId);
					docsParams.put("claimId", claimId);
					docsParams.put("clmDocCd", docs.getJSONObject(i).getString("clmDocCd"));
					this.getSqlMapClient().insert("saveRequiredClaimDocs", docsParams);
				}
			}else if (mode.equals("update")) {
				Map<String, Object>param;
				List<GICLReqdDocs>modRows = (List<GICLReqdDocs>) JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("modifiedRows")), userId, GICLReqdDocs.class);
				System.out.println(modRows.size());
				log.info("UPDATING CLAIM REQUIRED DOCS");
				for (GICLReqdDocs giclReqdDocs : modRows) {
					param = new HashMap<String, Object>();
					param.put("lineCd", lineCd);
					param.put("sublineCd", sublineCd);
					param.put("issCd", issCd);
					param.put("userId", userId);
					param.put("claimId", Integer.parseInt(claimId));
					param.put("clmDocCd", giclReqdDocs.getClmDocCd());
					param.put("docSbmttdDt", giclReqdDocs.getDocSbmttdDt());
					param.put("docCmpltdDt", giclReqdDocs.getDocCmpltdDt());
					param.put("rcvdBy", giclReqdDocs.getRcvdBy());
					param.put("frwdBy", giclReqdDocs.getFrwdBy());
					param.put("frwdFr", giclReqdDocs.getFrwdFr());
					param.put("remarks", giclReqdDocs.getRemarks());
					this.getSqlMapClient().insert("saveRequiredClaimDocs", param);
				}
				this.getSqlMapClient().executeBatch();
				List<GICLReqdDocs>delRows = (List<GICLReqdDocs>) JSONUtil.prepareObjectListFromJSON(new JSONArray(objParameters.getString("deletedRows")), userId, GICLReqdDocs.class);
				System.out.println(delRows.size());
				log.info("DELETING CLAIM REQUIRED DOCS");
				for (GICLReqdDocs giclReqdDocs : delRows) {
					param = new HashMap<String, Object>();
					param.put("claimId", Integer.parseInt(claimId));
					param.put("clmDocCd", giclReqdDocs.getClmDocCd());
					this.getSqlMapClient().delete("deleteRequireDocs", param);
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			//throw new SQLException();
			throw e;
		}finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getPrePrintDetails(Map<String, Object> params)
			throws SQLException {
		log.info("RETRIEVING PRE PRINT DETAILS OF ASSURED: "+params.get("assuredName"));
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getPrePrintDetails", params);
	}

	@Override
	public String validateClmReqDocs(Map<String, Object> params)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("validateClmReqDocs", params);
	}

	/*@SuppressWarnings("unchecked")
	@Override
	public List<GICLReqdDocs> getDocumentTableGridListing(Map<String, Object>params)
			throws SQLException {
		log.info("RETRIEVING CLAIM DOCUMENTS");
		return this.getSqlMapClient().queryForList("getDocumentsListing", params);
	}*/

}
