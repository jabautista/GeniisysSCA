package com.geniisys.giuw.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.Debug;
import com.geniisys.framework.util.ExceptionHandler;
import com.geniisys.gipi.entity.GIPIPARList;
import com.geniisys.gipi.entity.GIPIPolbasic;
import com.geniisys.gipi.exceptions.DistributionException;
import com.geniisys.gipi.exceptions.NegateDistributionException;
import com.geniisys.gipi.exceptions.PostingParException;
import com.geniisys.giuw.dao.GIUWPolDistDAO;
import com.geniisys.giuw.entity.GIUWPolDist;
import com.geniisys.giuw.entity.GIUWWPerilds;
import com.geniisys.giuw.entity.GIUWWPerildsDtl;
import com.geniisys.giuw.entity.GIUWWitemds;
import com.geniisys.giuw.entity.GIUWWpolicyds;
import com.geniisys.giuw.entity.GIUWWpolicydsDtl;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIUWPolDistDAOImpl implements GIUWPolDistDAO{

	private Logger log = Logger.getLogger(GIUWPolDistDAOImpl.class);
	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDist(Integer parId) throws SQLException {
		return this.sqlMapClient.queryForList("getGIUWPolDists", parId);
	}

	@Override
	public String checkDistFlag(Integer distNo, Integer distSeqNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("distNo", distNo);
		params.put("distSeqNo", distSeqNo);
		return (String) this.sqlMapClient.queryForObject("checkDistFlagGIUWS004", params);
	}

	@Override
	public Map<String, Object> compareGipiItemItmperil(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("compareGipiItemItmperil", params);
		return params;
	}
	
	@Override
	public Map<String, Object> compareGipiItemItmperil2(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("compareGipiItemItmperil2", params);
		return params;
	}

	@Override
	public Map<String, Object> createItems(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			Integer distNo = null;
			distNo = (Integer) params.get("distNo");
			
			if ("Recreate Items".equals((String) params.get("label"))){		/*added by Gzelle 06112014*/
				this.sqlMapClient.delete("delDistWorkingTables", params);
				this.sqlMapClient.delete("delDistMasterTables", params);
				this.getSqlMapClient().executeBatch();						
			}
			
			this.sqlMapClient.update("createItemsGIUWS004", params);
			this.getSqlMapClient().executeBatch();
			
			/*added by Gzelle 06192014*/
			this.updateSpecialDistSwGIUWS005(distNo);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> autoParam = new HashMap<String, Object>();
			autoParam.put("distNo", distNo);
			autoParam.put("autoDist", "N");
			this.updateAutoDistGIUWS005(autoParam);
			this.getSqlMapClient().executeBatch();
			
			Map<String, Object> param	= new HashMap<String, Object>();
			param.put("parId", params.get("parId"));
			param.put("distNo", params.get("distNo"));
			this.updateDistSpct1ToNull(param);
			this.getSqlMapClient().executeBatch();
			
			this.adjustAllWTablesGIUWS004(param);
			this.getSqlMapClient().executeBatch();
			/*END*/
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().commit();		/*modified by Gzelle 06192014 - rollback to commit*/
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDist1(Integer parId) throws SQLException {
		log.info("Getting GIUW_POL_DIST records ...");
		return this.sqlMapClient.queryForList("getGIUWPolDists1", parId);
	}

	@Override
	public Map<String, Object> postDist(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDist(params);
			
			this.sqlMapClient.update("postDistGIUWS004", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ // Modified by Gzelle 06172014
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = "SQL Exception occured while creating items...";
			}
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> savePrelimOneRiskDist(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDist(params);
			
			if ("N".equals((String) params.get("savePosting"))){
				List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
				Integer distNo = null;
				for (GIUWPolDist dist : polDist){
					log.info("Post form commit...");
					List<GIUWWpolicyds> ds = dist.getGiuwWpolicyds();
					for (GIUWWpolicyds polds : ds){
						distNo = polds.getDistNo();
						HashMap<String, Object> param = new HashMap<String, Object>();
						param.put("parId", dist.getParId());
						param.put("distNo", polds.getDistNo());
						param.put("distSeqNo", polds.getDistSeqNo());
						param.put("polFlag", (String) params.get("polFlag"));
						param.put("parType", (String) params.get("parType"));
						param.put("lineCd", (String) params.get("lineCd"));
						param.put("sublineCd", (String) params.get("sublineCd"));
						param.put("userId", (String) params.get("userId"));
						this.getSqlMapClient().update("postFormCommitGIUWS004", param);
					}
				}
				this.getSqlMapClient().executeBatch();
				
				/* added by Gzelle 06102014 */
				this.updateSpecialDistSwGIUWS005(distNo);
				
				Map<String, Object> paramDist = new HashMap<String, Object>();
				paramDist.put("distNo", distNo);
				
				if ("P".equals(params.get("postFlag"))) {
					log.info("Deleting/Reinserting...");
					this.deleteReinsertGIUWS004(params);
					log.info("Updating dist_spct1 to null...");
					this.updateDistSpct1ToNull(paramDist);
				}

				if ("E".equals(params.get("distSpctChk"))) {
					log.info("Updating dist_spct1 to null...");
					this.updateDistSpct1ToNull(paramDist);
				}else if ("NE".equals(params.get("distSpctChk"))) {
					log.info("Adjusting Dist Prem...");
					paramDist.put("parId", params.get("parId"));					
					this.adjustDistPremGIUWS004(paramDist);
				}
				
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("distNo", distNo);
				log.info("Adjusting All Wtables...");
				this.adjustAllWTablesGIUWS004(p);
			}
			
			params.put("giuwPolDist", this.getGIUWPolDist((Integer) params.get("parId")));
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@SuppressWarnings("unchecked")
	private void saveDist(Map<String, Object> params) throws SQLException {
		List<HashMap<String, Object>> postedRecreated = (List<HashMap<String, Object>> ) params.get("postedRecreated");
		for(int i=0, length=postedRecreated.size(); i < length; i++){
			if ((Integer) postedRecreated.get(i).get("processId") == i){
				if ("R".equals(postedRecreated.get(i).get("process"))){
					log.info("Saving recreated records... "+postedRecreated.get(i));
					this.sqlMapClient.delete("delDistWorkingTables", postedRecreated.get(i));
					this.sqlMapClient.delete("delDistMasterTables", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
					this.sqlMapClient.update("createItemsGIUWS004", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
					
					/* Gzelle 06102014 */
					Integer distNo = Integer.parseInt(postedRecreated.get(i).get("distNo").toString());
					this.updateSpecialDistSwGIUWS005(distNo);
					Map<String, Object> p = new HashMap<String, Object>();
					p.put("distNo", distNo);
					p.put("autoDist", "N");
					this.updateAutoDistGIUWS005(p);
				}else if("P".equals(postedRecreated.get(i).get("process"))){
					log.info("Saving posted records... "+postedRecreated.get(i));
					this.sqlMapClient.update("postDistGIUWS004", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
					
					/* Gzelle 06102014 */
					List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
					for (GIUWPolDist dist : polDist){
						if (!dist.getDistFlag().equals("2")){
							log.info("Updating giuw_pol_dist auto_dist after posting...");
							dist.setAutoDist("Y"); // added so auto_dist will not be reverted back to N if dist has no facul share
						}
					}
				}
			}
		}
		
		List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
		for (GIUWPolDist dist : polDist){
			log.info("Saving giuw_pol_dist records...");
			this.getSqlMapClient().insert("setGIUWPolDist", dist);
			//added by Gzelle 07042014
			HashMap<String, Object> param4 = new HashMap<String, Object>();
			param4.put("distNo", dist.getDistNo());
			this.getSqlMapClient().update("deleteWorkingBinders", param4);
		}
		
		List<GIUWWpolicyds> wpolicyds = (List<GIUWWpolicyds>) params.get("giuwWpolicydsRows");
		for (GIUWWpolicyds dist : wpolicyds){
			log.info("Saving giuw_wpolicyds records...");
			this.getSqlMapClient().insert("setGIUWWpolicyds", dist);
		}
		
		List<GIUWWpolicydsDtl> wpolicydsDtlDel = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlDelRows");
		for (GIUWWpolicydsDtl dist : wpolicydsDtlDel){
			log.info("Deleting giuw_wpolicyds_dtl records...");
			this.getSqlMapClient().delete("delGIUWWpolicydsDtl", dist);
		}
		
		List<GIUWWpolicydsDtl> wpolicydsDtl = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlSetRows");
		for (GIUWWpolicydsDtl dist : wpolicydsDtl){
			log.info("Saving giuw_wpolicyds_dtl records...");
			this.getSqlMapClient().insert("setGIUWWpolicydsDtl", dist);
		}
		this.getSqlMapClient().executeBatch();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDist2(Integer parId) throws SQLException {
		return this.sqlMapClient.queryForList("getGIUWPolDists2", parId);
	}
	
	@Override
	public Map<String, Object> createItems2(Map<String, Object> params)
			throws Exception {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if ("Recreate Items".equals((String) params.get("label"))){
				this.sqlMapClient.delete("deleteDistWorkingTables", params);
				this.sqlMapClient.delete("delDistMasterTables", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.sqlMapClient.update("createItemsGIUWS001", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo2", params);
			params.put("newItems", newItems);
			
			//this.getSqlMapClient().getCurrentConnection().rollback(); // replaced by: Nica 07.12.2012
			this.getSqlMapClient().getCurrentConnection().commit();
			
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";			
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";			
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";			
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveSetupGroupDist(Map<String, Object> allParams)
			throws SQLException, Exception {
		String message = "SUCCESS";
		String isPack = allParams.get("isPack") == null ? "N" : (allParams.get("isPack").toString().isEmpty() ? "N" : allParams.get("isPack").toString());
		List<GIUWPolDist> packPolDistList = null;
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving Set - Up Groups.");
			
			List<GIUWWitemds> setRows = (List<GIUWWitemds>) allParams.get("setRows");
			List<Map<String, Object>> recreateRows = (List<Map<String, Object>>) allParams.get("recreateRows");
			
			//creating/recreating items
			for (Map<String, Object> params:recreateRows){
				if ("Recreate Items".equals((String) params.get("label"))){
					this.sqlMapClient.delete("deleteDistWorkingTables", params);
					this.sqlMapClient.delete("delDistMasterTables", params);
					this.getSqlMapClient().executeBatch();
				}
				this.sqlMapClient.update("createItemsGIUWS001", params);
				this.getSqlMapClient().executeBatch();
			}
			
			//pre-commit
			for (GIUWWitemds set:setRows){
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					Map<String, Object> params = new HashMap<String, Object>();
					params.put("userId", set.getUserId());
					params.put("distNo", set.getDistNo());
					this.getSqlMapClient().update("preCommitGIUWS001", params);
					this.getSqlMapClient().executeBatch();
					break;
				}
			}
			
			//main saving
			for (GIUWWitemds set:setRows){
				//if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					this.getSqlMapClient().insert("preUpdateGIUWWitemds", set);
					this.getSqlMapClient().executeBatch();
				//}
				
				this.getSqlMapClient().insert("setGIUWWitemds", set);
				this.getSqlMapClient().executeBatch();
				
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					this.getSqlMapClient().insert("postUpdateGIUWWitemds", set);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			//post-form-commit
			if ("Y".equals(isPack)) {
				packPolDistList = (List<GIUWPolDist>) this.getSqlMapClient().queryForList("getPackGIUWPolDists", Integer.parseInt(allParams.get("parId").toString()));
			}
			
			Map<String, Object> distNos = new HashMap<String, Object>();
			
			for (GIUWWitemds set:setRows){
				if (!set.getOrigDistSeqNo().equals(set.getDistSeqNo().toString())){
					Map<String, Object> params = new HashMap<String, Object>();
					params = allParams;
					
					if ("Y".equals(isPack) && packPolDistList != null) {
						// emman (07.15.2011)
						for (GIUWPolDist polDist : packPolDistList) {
							if (polDist.getDistNo().equals(set.getDistNo())) {
								GIPIPARList parList = (GIPIPARList) this.getSqlMapClient().queryForObject("getGIPIPARDetailsFromParId", polDist.getParId());
								params.put("parId", parList.getParId());
								params.put("lineCd", parList.getLineCd());
								params.put("sublineCd", parList.getSublineCd());
								params.put("issCd", parList.getIssCd());
								params.put("packPolFlag", parList.getPackPolFlag());
								params.put("polFlag", parList.getPolFlag());
								params.put("parType", parList.getParType());
								break;
							}
						}
					}
					
					if(distNos.get(set.getDistNo().toString()) == null){ // added by: Nica 04.25.2013 - to call this part only once per distNo
						params.put("distNo", set.getDistNo());
						params.put("itemGrp", set.getItemGrp());
						
						log.info("Executing post-forms-commit...");
						log.info("Par Id: " + params.get("parId"));
						log.info("Line Cd: " + params.get("lineCd"));
						log.info("Subline Cd: " + params.get("sublineCd"));
						log.info("Iss Cd: " + params.get("issCd"));
						
						this.getSqlMapClient().update("createRegroupedDistRecs", params);
						this.getSqlMapClient().executeBatch();
						
						distNos.put(set.getDistNo().toString(), set.getDistNo());
						log.info("createRegroupedDistRecs: "+params);
					}
				}
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (Exception e) {
			//message = ExceptionHandler.handleException(e,(String) allParams.get("userId")); // comment out by andrew - throw the exception to the controller, see "throw e;"
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			log.info("End of saving Set - Up Groups.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#checkDistFlagGiuws003(java.util.Map)
	 */
	@Override
	public void checkDistFlagGiuws003(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkDistFlagGIUWS003", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#createItemsGiuws003(java.util.Map)
	 */
	@Override
	public Map<String, Object> createItemsGiuws003(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			//start edgar 06/19/2014
			/*HashMap<String, Object> param2 = new HashMap<String, Object>();
			param2.put("parId", params.get("parId"));
			param2.put("distNo", params.get("distNo"));
			param2.put("vProcess", "R");
			this.getSqlMapClient().update("checkPostedBinder", param2);
			this.getSqlMapClient().executeBatch();*/
			//end edgar 06/19/2014
			this.sqlMapClient.delete("delDistWorkingTables", params);
			this.sqlMapClient.delete("delDistMasterTables", params);
			this.getSqlMapClient().executeBatch();
			
			
			log.info("Emman Values: ");
			log.info("distNo:" + params.get("distNo"));
			log.info("parId:" + params.get("parId"));
			log.info("lineCd:" + params.get("lineCd"));
			log.info("sublineCd:" + params.get("sublineCd"));
			log.info("issCd:" + params.get("issCd"));
			log.info("packPolFlag:" + params.get("packPolFlag"));
			log.info("polFlag:" + params.get("polFlag"));
			log.info("parType:" + params.get("parType"));
			log.info("itemGrp:" + params.get("itemGrp"));
			
			//this.sqlMapClient.update("createItemsGIUWS003", params);  replaced by robert 11.11.15 GENQA 5053 
			this.sqlMapClient.update("createItemsGIUWS006", params);
			this.getSqlMapClient().executeBatch();
			//start edgar 06/10/2014
			//edgar 06/06/2014
			this.getSqlMapClient().getCurrentConnection().commit();
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("parId", params.get("parId"));
			param.put("distNo", params.get("distNo"));
			this.sqlMapClient.delete("updatePolDistGIUWS003", param);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			//ended edgar 06/06/2014
			HashMap<String, Object> param1 = new HashMap<String, Object>();
			param1.put("distNo", params.get("distNo"));
			log.info("Adjusting distribution : "+param1.get("distNo"));
			this.adjustPerilDistTables(param1);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit(); 
			//end edgar 06/10/2014
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo3", params);
			params.put("newItems", newItems);
			
			//this.getSqlMapClient().getCurrentConnection().rollback(); //edgar 06/19/2014
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#postDistGiuws003(java.util.Map)
	 */
	@Override
	public Map<String, Object> postDistGiuws003(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			//added by robert 11.11.15 GENQA 5053
			this.sqlMapClient.update("validateDistWperildtl", params);
			if (params.get("msgAlert") != null) {
				this.checkErrorMessage(params.get("msgAlert").toString());
			}
			
			this.sqlMapClient.update("validateWrkingTablsAmts", params);
			if (params.get("msgAlert") != null) {
				this.checkErrorMessage(params.get("msgAlert").toString());
			}
			//end robert 11.11.15 GENQA 5053
			//this.saveDistGiuws003(params); //edgar 07/04/2014
			
			//this.sqlMapClient.update("postDistGIUWS003", params); replaced by robert 11.11.15 GENQA 5053
			this.sqlMapClient.update("postDistGIUWS006", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo3", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (PostingParException e) { //added by robert 11.11.15 GENQA 5053
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	private void savePerilDistribution(Map<String, Object> params) throws SQLException{
		List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
		String moduleId = (String) params.get("moduleId");
		
		log.info("Pol Dist: " + polDist.size());
		for (GIUWPolDist dist : polDist){
			log.info("Saving giuw_pol_dist records..."+dist.getDistFlag());
			log.info("dist no\tdist flag\tmean dist flag");
			log.info(dist.getDistNo() + "\t" + dist.getDistFlag() + "\t" + dist.getMeanDistFlag());
			this.getSqlMapClient().insert("setGIUWPolDist", dist);
		}
		this.getSqlMapClient().executeBatch();
		
		List<GIUWWPerilds> wperilds = (List<GIUWWPerilds>) params.get("giuwWPerildsRows");
		log.info("WPeril Ds: " + wperilds.size());
		for (GIUWWPerilds dist : wperilds){
			log.info("Saving giuw_wperilds records...");
			this.getSqlMapClient().insert("setGIUWWPerilds", dist);
		}
		this.getSqlMapClient().executeBatch();
		
		List<GIUWWPerildsDtl> wperildsDtlDel = (List<GIUWWPerildsDtl>) params.get("giuwWPerildsDtlDelRows");
		log.info("WPeril Ds Dtl Del: " + wperildsDtlDel.size());
		for (GIUWWPerildsDtl dist : wperildsDtlDel){
			log.info("Deleting giuw_wperilds_dtl records...");
			log.info("Dist No\tDist Seq No\tLine Cd\tPeril Cd\tShare Cd");
			log.info(dist.getDistNo() + "\t" + dist.getDistSeqNo() + "\t" + dist.getLineCd() + "\t" + dist.getPerilCd() + "\t" + dist.getShareCd());
			this.getSqlMapClient().delete("delGIUWWPerildsDtl2", dist);
			
			if("GIUWS012".equals(moduleId)){
				this.getSqlMapClient().update("deleteWorkingBinderTables", dist);
			}
		}
		this.getSqlMapClient().executeBatch();
		
		List<GIUWWPerildsDtl> wperildsDtl = (List<GIUWWPerildsDtl>) params.get("giuwWPerildsDtlSetRows");
		log.info("WPeril Ds Dtl Insert: " + wperildsDtl.size());
		for (GIUWWPerildsDtl dist : wperildsDtl){
			log.info("Saving giuw_wperilds_dtl records...");
			log.info("Dist No\tDist Seq No\tLine Cd\tPeril Cd\tShare Cd\tDist Spct\tDist Spct1");
			log.info(dist.getDistNo() + "\t" + dist.getDistSeqNo() + "\t" + dist.getLineCd() + "\t" + dist.getPerilCd() + "\t" + dist.getShareCd() + "\t" + dist.getAnnDistSpct()
					+"\t" + dist.getDistSpct() + "\t" + dist.getDistSpct1());
			this.getSqlMapClient().insert("setGIUWWPerildsDtl", dist);
			this.getSqlMapClient().executeBatch();
			
			if("GIUWS012".equals(moduleId)){
				this.getSqlMapClient().update("deleteWorkingBinderTables", dist);
			}
		}
		this.getSqlMapClient().executeBatch();
		
	}
	
	@SuppressWarnings("unchecked")
	private void saveDistGiuws003(Map<String, Object> params) throws SQLException {
		List<HashMap<String, Object>> postedRecreated = (List<HashMap<String, Object>> ) params.get("postedRecreated");
		for(int i=0, length=postedRecreated.size(); i < length; i++){
			if ((Integer) postedRecreated.get(i).get("processId") == i){
				if ("R".equals(postedRecreated.get(i).get("process"))){
					log.info("Saving recreated records... "+postedRecreated.get(i));
					this.sqlMapClient.delete("delDistWorkingTables", postedRecreated.get(i));
					this.sqlMapClient.delete("delDistMasterTables", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
					//this.sqlMapClient.update("createItemsGIUWS003", postedRecreated.get(i)); replaced by robert 10.13.15 GENQA 5053
					this.sqlMapClient.update("createItemsGIUWS006", postedRecreated.get(i)); //added by robert 10.13.15 GENQA 5053
					this.getSqlMapClient().executeBatch();
				}else if("P".equals(postedRecreated.get(i).get("process"))){
					log.info("Saving posted records... "+postedRecreated.get(i));
					//this.sqlMapClient.update("postDistGIUWS003", postedRecreated.get(i)); replaced by robert 10.13.15 GENQA 5053
					this.sqlMapClient.update("postDistGIUWS006", postedRecreated.get(i)); //added by robert 10.13.15 GENQA 5053
					this.getSqlMapClient().executeBatch();
				}
			}
		}
		
		this.savePerilDistribution(params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#savePrelimPerilDist(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> savePrelimPerilDist(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			this.saveDistGiuws003(params);
			//added by robert 11.11.15 GENQA 5053
			List<GIUWPolDist> polDists = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : polDists){
				this.updateDistSpct1(dist.getDistNo());
			}
			//end robert 11.11.15 GENQA 5053
			List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			String isPack = (params.get("isPack") == null) ? "N" : params.get("isPack").toString();
			for (GIUWPolDist dist : polDist){
				log.info("Post form commit...");
				List<GIUWWPerilds> ds = dist.getGiuwWPerilds();
				for (GIUWWPerilds polds : ds){
					HashMap<String, Object> param = new HashMap<String, Object>();
					param.put("parId", dist.getParId());
					param.put("distNo", polds.getDistNo());
					param.put("distSeqNo", polds.getDistSeqNo());
					param.put("perilCd", polds.getPerilCd());
					param.put("parType", (String) params.get("parType"));
					param.put("userId", (String) params.get("userId"));
					param.put("postSw", (String) params.get("postSw"));
					param.put("polFlag", (String) params.get("polFlag"));
					
					if ("Y".equals(isPack)) {
						// emman (07.15.2011)
						GIPIPARList parList = (GIPIPARList) this.getSqlMapClient().queryForObject("getGIPIPARDetailsFromParId", dist.getParId());
						param.put("lineCd", (String) parList.getLineCd());
						param.put("sublineCd", (String) parList.getSublineCd());
					} else {
						param.put("lineCd", (String) params.get("lineCd"));
						param.put("sublineCd", (String) params.get("sublineCd"));
					}
					
					log.info("GIUWS003 Post-Form-Commit Parameters:  " + param);
					//this.getSqlMapClient().update("postFormCommitGIUWS003", param); //replaced by robert 10.13.15 GENQA 5053
					this.getSqlMapClient().update("postFormCommitGIUWS006", param); //added by robert 10.13.15 GENQA 5053
					
					this.getSqlMapClient().executeBatch();
				}
				//message = checkPerilDistributionError(dist.getDistNo()); removed by robert 10.13.15 GENQA 5053
			}
			this.getSqlMapClient().executeBatch();
			//added by edgar for adjusting distribution tables 06/11/2014
			List<GIUWPolDist> polDist6 = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : polDist6){
				log.info("Deleting Missing Shares..."+dist.getDistFlag());
				HashMap<String, Object> param6 = new HashMap<String, Object>();
				param6.put("distNo", dist.getDistNo());
				this.getSqlMapClient().update("deleteMissingShares", param6);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			List<GIUWPolDist> polDist4 = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : polDist4){
				log.info("Adjusting Distribution..."+dist.getDistFlag());
				HashMap<String, Object> param3 = new HashMap<String, Object>();
				param3.put("distNo", dist.getDistNo());
				this.adjustPerilDistTables(param3);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			
			List<GIUWPolDist> polDist5 = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : polDist5){
				log.info("Deleting Working Binders..."+dist.getDistFlag());
				HashMap<String, Object> param4 = new HashMap<String, Object>();
				param4.put("distNo", dist.getDistNo());
				this.getSqlMapClient().update("deleteWorkingBinders", param4);
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			//end of addition edgar 06/11/2014
			//added by robert 11.11.15 GENQA 5053
			List<GIUWPolDist> valPolDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : valPolDist){
				log.info("Validating Distribution Amounts..."+dist.getDistFlag());
				Map<String, Object> valMap = new HashMap<String, Object>();
				valMap.put("distNo", dist.getDistNo());
				valMap.put("msgAlert", "");
				this.sqlMapClient.update("validateDistWperildtl", valMap);
				if (valMap.get("msgAlert") != null) {
					this.checkErrorMessage(valMap.get("msgAlert").toString());
				}
				
				Map<String, Object> valMap2 = new HashMap<String, Object>();
				valMap2.put("distNo", dist.getDistNo());
				valMap2.put("msgAlert", "");
				this.sqlMapClient.update("validateWrkingTablsAmts", valMap2);
				if (valMap2.get("msgAlert") != null) {
					this.checkErrorMessage(valMap2.get("msgAlert").toString());
				}
			}
			//end robert 11.11.15 GENQA 5053
			if ("Y".equals(isPack)) {
				params.put("giuwPolDist", this.getPackGIUWPolDist1((Integer) params.get("parId")));
			} else {
				params.put("giuwPolDist", this.getGIUWPolDist1((Integer) params.get("parId")));
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (PostingParException e) { //added by robert 11.11.15 GENQA 5053
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (DistributionException e) {
			e.printStackTrace();
			message = e.getMessage();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			message = "Null Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			message = "Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@Override
	public Map<String, Object> checkDistMenu(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkDistMenu", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> savePrelimPerilDistByTsiPrem(
			Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDistGiuws006(params);
			
			if ("N".equals((String) params.get("savePosting"))){
				List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
				for (GIUWPolDist dist : polDist){
					log.info("Post form commit...");
					List<GIUWWPerilds> ds = dist.getGiuwWPerilds();
					for (GIUWWPerilds polds : ds){
						HashMap<String, Object> param = new HashMap<String, Object>();
						param.put("parId", dist.getParId());
						param.put("distNo", polds.getDistNo());
						param.put("distSeqNo", polds.getDistSeqNo());
						param.put("lineCd", (String) params.get("lineCd"));
						param.put("perilCd", polds.getPerilCd());
						param.put("sublineCd", (String) params.get("sublineCd"));
						param.put("polFlag", (String) params.get("polFlag"));
						param.put("parType", (String) params.get("parType"));
						param.put("userId", (String) params.get("userId"));
						log.info("GIUWS006 Post Form Commit Parameters: "+param);
						this.getSqlMapClient().update("postFormCommitGIUWS006", param);
						this.getSqlMapClient().executeBatch();
						
						this.updateSpecialDistSwGIUWS005(polds.getDistNo());
					}
					
					Map<String, Object> m = new HashMap<String, Object>();
					m.put("distNo", dist.getDistNo());
					//this.sqlMapClient.update("checkPerilDistributionError", m);	// replaced by code below : shan 08.26.2014
					message = checkPerilDistributionError(dist.getDistNo());
				}
				this.getSqlMapClient().executeBatch();
			}
			// shan 07.25.2014
			List<GIUWPolDist> polDist1 = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : polDist1){
				log.info("Adjusting Distribution..."+dist.getDistFlag());
				HashMap<String, Object> param3 = new HashMap<String, Object>();
				param3.put("distNo", dist.getDistNo());
				this.adjustPerilDistTables(param3);
			}
			// end 07.25.2014
			List<GIUWPolDist> polDists = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : polDists){
				this.updateDistSpct1(dist.getDistNo());
				
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("distNo", dist.getDistNo());
				this.sqlMapClient.update("deleteWorkingBinders", p);
			}
			
			params.put("giuwPolDist", this.getGIUWPolDist1((Integer) params.get("parId")));
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			message = e.getMessage(); // andrew - 05.28.2012
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();			
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
			}else{
				message = "SQL Exception occured while saving...";
			}
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@SuppressWarnings("unchecked")
	private void saveDistGiuws006(Map<String, Object> params) throws SQLException{
		List<HashMap<String, Object>> postedRecreated = (List<HashMap<String, Object>> ) params.get("postedRecreated");
		for(int i=0, length=postedRecreated.size(); i < length; i++){
			if ((Integer) postedRecreated.get(i).get("processId") == i){
				if ("R".equals(postedRecreated.get(i).get("process"))){
					log.info("Saving recreated records... "+postedRecreated.get(i));
					if ("Recreate Items".equals((String) postedRecreated.get(i).get("label"))){
						this.sqlMapClient.delete("delDistWorkingTables", postedRecreated.get(i));
						this.sqlMapClient.delete("delDistMasterTables", postedRecreated.get(i));
						this.getSqlMapClient().executeBatch();
					}
					this.sqlMapClient.update("createItemsGIUWS006", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
				}else if("P".equals(postedRecreated.get(i).get("process"))){
					log.info("Saving posted records... "+postedRecreated.get(i));
					this.sqlMapClient.update("postDistGIUWS006", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
				}
			}
		}
		
		this.savePerilDistribution(params);
	}

	@Override
	public Map<String, Object> createItemsGiuws006(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info((String) params.get("label")+" GIUWS006 :"+params);
			if ("Recreate Items".equals((String) params.get("label"))){
				this.sqlMapClient.delete("delDistWorkingTables", params);
				this.sqlMapClient.delete("delDistMasterTables", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.sqlMapClient.update("createItemsGIUWS006", params);
			this.getSqlMapClient().executeBatch();
			
			this.updateDistSpct1(Integer.parseInt(params.get("distNo").toString()));
			this.getSqlMapClient().getCurrentConnection().commit();		
			
			// shan 06.24.2014
			Map<String, Object> p = new HashMap<String, Object>();
			p.put("distNo", params.get("distNo"));
			p.put("parId", params.get("parId"));
			this.sqlMapClient.delete("updatePolDistGIUWS003", p);
			this.getSqlMapClient().executeBatch();
			// shan 07.24.2014
			HashMap<String, Object> param1 = new HashMap<String, Object>();
			param1.put("distNo", params.get("distNo"));
			log.info("Adjusting distribution : "+param1.get("distNo"));
			this.adjustPerilDistTables(param1);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit(); 
			//end 
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo3", params);
			params.put("newItems", newItems);
			
			//this.getSqlMapClient().getCurrentConnection().rollback();	
			this.getSqlMapClient().getCurrentConnection().commit();	
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> savePrelimOneRiskDistByTsiPrem(Map<String, Object> params)
			throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDistGiuws005(params);
			
			this.getSqlMapClient().executeBatch();
			
			if ("N".equals((String) params.get("savePosting"))){
				List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
				Integer distNo = null;
				for (GIUWPolDist dist : polDist){
					log.info("Post form commit GIUWS005...");
					List<GIUWWpolicyds> ds = dist.getGiuwWpolicyds();
					for (GIUWWpolicyds polds : ds){
						distNo = polds.getDistNo();
						HashMap<String, Object> param = new HashMap<String, Object>();
						param.put("parId", dist.getParId());
						param.put("distNo", polds.getDistNo());
						param.put("distSeqNo", polds.getDistSeqNo());
						param.put("polFlag", (String) params.get("polFlag"));
						param.put("parType", (String) params.get("parType"));
						param.put("lineCd", (String) params.get("lineCd"));
						param.put("sublineCd", (String) params.get("sublineCd"));
						param.put("userId", (String) params.get("userId"));
						this.getSqlMapClient().update("postFormCommitGIUWS005", param);
						Debug.print("POSTFORMS COMMIT PARAMS: " + param);
					}
				}
				this.getSqlMapClient().executeBatch();
				
				/* added by shan 06.03.2014 */
				this.updateDistSpct1(distNo);
				this.updateSpecialDistSwGIUWS005(distNo);
				Map<String, Object> p = new HashMap<String, Object>();
				p.put("distNo", distNo);
				this.adjustAllWTablesGIUWS004(p);
			}
			
			params.put("giuwPolDist", this.getGIUWPolDist((Integer) params.get("parId")));
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	private void saveDistGiuws005(Map<String, Object> params) throws SQLException {
		List<HashMap<String, Object>> postedRecreated = (List<HashMap<String, Object>> ) params.get("postedRecreated");
		for(int i=0, length=postedRecreated.size(); i < length; i++){
			if ((Integer) postedRecreated.get(i).get("processId") == i){
				if ("R".equals(postedRecreated.get(i).get("process"))){
					log.info("Saving recreated records... "+postedRecreated.get(i));
					this.sqlMapClient.delete("delDistWorkingTables", postedRecreated.get(i));
					this.sqlMapClient.delete("delDistMasterTables", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
					this.sqlMapClient.update("createItemsGIUWS005", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
					
					/* shan 06.03.2014 */
					Integer distNo = Integer.parseInt(postedRecreated.get(i).get("distNo").toString());
					this.updateSpecialDistSwGIUWS005(distNo);
					Map<String, Object> p = new HashMap<String, Object>();
					p.put("distNo", distNo);
					p.put("autoDist", "N");
					this.updateAutoDistGIUWS005(p);
					this.updateDistSpct1(distNo);
				}else if("P".equals(postedRecreated.get(i).get("process"))){
					/* added by shan 06.03.2014 */
					Map<String, Object> riParams = new HashMap<String, Object>();
					riParams.put("distNo", postedRecreated.get(i).get("distNo"));
					riParams.put("parId", params.get("parId"));					
					riParams.put("lineCd", params.get("lineCd"));
					riParams.put("sublineCd", params.get("sublineCd"));
					log.info("Creating RI Records..."+riParams.toString());
					this.sqlMapClient.update("createRiRecordsGiuws005", riParams);
					this.getSqlMapClient().executeBatch();
					/* end 06.03.2014 */
					
					log.info("Saving posted records... "+postedRecreated.get(i));
					this.sqlMapClient.update("postDistGIUWS005", postedRecreated.get(i));
					this.getSqlMapClient().executeBatch();
					/* added by shan 05.27.2014 */
					/*Integer distNo = Integer.parseInt(postedRecreated.get(i).get("distNo").toString());
					Map<String, Object> p = new HashMap<String, Object>();
					p.put("distNo", distNo);
					p.put("autoDist", "Y");
					this.updateAutoDistGIUWS005(p);*/
										
					List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
					for (GIUWPolDist dist : polDist){
						if (!dist.getDistFlag().equals("2")){
							log.info("Updating giuw_pol_dist auto_dist after posting...");
							dist.setAutoDist("Y"); // added so auto_dist will not be reverted back to N if dist has no facul share : shan 05.29.2014
						}
					}
					/* end 05.27.2014 */
				}
			}
		}
		
		List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
		for (GIUWPolDist dist : polDist){
			log.info("Saving giuw_pol_dist records..."+ dist.getAutoDist());
			this.getSqlMapClient().insert("setGIUWPolDist", dist);

			// shan 07.04.2014
			Map<String, Object> p = new HashMap<String, Object>();
			p.put("distNo", dist.getDistNo());
			log.info("Deleting working binders of dist no "+ dist.getDistNo());
			this.sqlMapClient.update("deleteWorkingBinders", p);
			// end 07.04.2014
		}
		
		List<GIUWWpolicyds> wpolicyds = (List<GIUWWpolicyds>) params.get("giuwWpolicydsRows");
		for (GIUWWpolicyds dist : wpolicyds){
			log.info("Saving giuw_wpolicyds records...");
			this.getSqlMapClient().insert("setGIUWWpolicyds", dist);
		}
		
		List<GIUWWpolicydsDtl> wpolicydsDtlDel = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlDelRows");
		for (GIUWWpolicydsDtl dist : wpolicydsDtlDel){
			log.info("Deleting giuw_wpolicyds_dtl records...");
			this.getSqlMapClient().delete("delGIUWWpolicydsDtl", dist);
		}
		
		List<GIUWWpolicydsDtl> wpolicydsDtl = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlSetRows");
		for (GIUWWpolicydsDtl dist : wpolicydsDtl){
			log.info("Saving giuw_wpolicyds_dtl records...");
			Debug.print("DETAILS: DistSpct1: " + dist.getDistSpct1() + " DistSpct: " + dist.getDistSpct());
			this.getSqlMapClient().insert("setGIUWWpolicydsDtl", dist);
		}
		
		this.getSqlMapClient().executeBatch();
	}
	
	@Override
	public Map<String, Object> createItemsGiuws005(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.sqlMapClient.delete("delDistWorkingTables", params);
			this.sqlMapClient.delete("delDistMasterTables", params);
			this.getSqlMapClient().executeBatch();
			
			this.sqlMapClient.update("createItemsGIUWS005", params);
			this.getSqlMapClient().executeBatch();
			
			// added by shan 06.19.2014
			this.updateDistSpct1(Integer.parseInt(params.get("distNo").toString()));
			// end 06.19.2014
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo", params);
			System.out.println("DISTSPC1: " + newItems.getGiuwWpolicyds().get(0).getGiuwWpolicydsDtl().get(0).getDistSpct1() + " DISTSPC: " +  newItems.getGiuwWpolicyds().get(0).getGiuwWpolicydsDtl().get(0).getDistSpct());
			params.put("newItems", newItems);
			
			//this.getSqlMapClient().getCurrentConnection().rollback(); // replaced by code below : shan 06.19.2014
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@Override
	public Map<String, Object> postDistGiuws006(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.updateDistSpct1(Integer.parseInt(params.get("distNo").toString()));
			this.saveDistGiuws006(params);
			
			this.sqlMapClient.update("postDistGIUWS006", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo3", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	
	@Override
	public Map<String, Object> postDistGiuws005(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDist(params);
			
			this.sqlMapClient.update("postDistGIUWS005", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ // added condition : shan 06.03.2014
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = "SQL Exception occured while creating items...";
			}
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@Override
	public String checkIfPosted(Integer distno) throws SQLException {
		// TODO Auto-generated method stub
		return (String) this.getSqlMapClient().queryForObject("checkIfPosted", distno);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#getPackGIUWPolDist1(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getPackGIUWPolDist1(Integer packParId)
			throws SQLException {
		log.info("Getting GIUW_POL_DIST records ...");
		return this.sqlMapClient.queryForList("getPackGIUWPolDists1", packParId);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#getPackGIUWPolDist(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getPackGIUWPolDist(Integer packParId)
			throws SQLException {
		return this.sqlMapClient.queryForList("getPackGIUWPolDists", packParId);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDistGiuws013(Map<String, Object> params) throws SQLException {
		Debug.print("PARAMS: " + params);
		return this.sqlMapClient.queryForList("getGIUWPolDistGiuws013", params);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDistGiuws016(Map<String, Object> params) throws SQLException {
		Debug.print("PARAMS: " + params);
		return this.sqlMapClient.queryForList("getGIUWPolDistGiuws016", params);
	}
	
	public Map<String, Object> postDistGiuws013(Map<String, Object> params) throws SQLException, PostingParException {
		String message = "";
		 
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Debug.print("DAO PARAMS BEFORE" + params);
			this.sqlMapClient.queryForObject("prePostGiuws013", params);
			Debug.print("DAO PARAMS AFTER" + params);
			this.getSqlMapClient().executeBatch();
			
			this.checkErrorMessage(params.get("message").toString());
			this.policyNegatedCheck(params);
			this.getSqlMapClient().executeBatch();
			
			this.sqlMapClient.insert("postDistGiuws013", params);
			Debug.print("PARAMS AFTER POST: " + params);
			this.getSqlMapClient().executeBatch();
			
			this.updateSpecialDistSwGIUWS005((Integer) params.get("distNo"));
			this.getSqlMapClient().executeBatch();
			
			if(params.get("faculSw").equals("N")){
				Debug.print("Deleting GIUWS013 working tables since there is no facultative share type." + params);
				this.sqlMapClient.delete("delDistWorkingTables", params);
				this.sqlMapClient.delete("delDistWPolicyWItemDs", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (PostingParException e) {	
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().commit();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
		}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#getGIUWPolDistForPerilDistribution(java.lang.Integer, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDistForPerilDistribution(Integer parId,
			Integer distNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("distNo", distNo);
		
		/*if ("2".equals((String) params.get("polFlag")) || "E".equals((String) params.get("parType"))){
			log.info("Creating items for GIUWS017...");
			this.sqlMapClient.delete("delDistWorkingTablesGIUWS017", params);
			this.sqlMapClient.delete("delDistMasterTables", params);
			this.getSqlMapClient().executeBatch();
			this.sqlMapClient.update("createItemsGIUWS017", params);
			this.getSqlMapClient().executeBatch();
		}*/
		return this.getSqlMapClient().queryForList("getGIUWPolDistPerDistNo3", params);
	}
	
	public void checkErrorMessage(String msg) throws PostingParException{
		log.info("Exception message param: " + msg);
		if (!msg.equals("SUCCESS")){
			throw new PostingParException(msg);
		}
	}
	
	@SuppressWarnings("unchecked")
	public void policyNegatedCheck(Map<String, Object> params) throws SQLException{
		Integer vCount = Integer.parseInt(params.get("count").toString());
		String vExist = params.get("exist").toString();
		String vFaculSw = params.get("faculSw").toString();
		Integer vRgSeqNo;
		String vFrpsExist = "FALSE";
		
		log.info("Facul sw: "+ vFaculSw + " vExist: "+vExist);
		
		if (vFaculSw.equals("Y") && vExist.equals("Y")) {
			List<Map<String, Object>> faculList = (List<Map<String, Object>>) params.get("faculList");
			List<Map<String, Object>> faculList2 = (List<Map<String, Object>>) params.get("faculList2");
			for (int i=0; i<faculList2.size(); i++){
				if (faculList2.get(i).get("userId") != null){
					if (vCount > 0) {
						vRgSeqNo = Integer.parseInt(faculList.get(vCount - 1).get("distSeqNo").toString());
						System.out.println("v_dist_seq_no: " + vRgSeqNo);
						while (vRgSeqNo > Integer.parseInt(faculList2.get(i).get("distSeqNo").toString())){
							Map<String, Object> faculParams = new HashMap<String, Object>();
							faculParams.put("tsiAmt",  new BigDecimal(faculList.get(vCount - 1).get("tsiAmt").toString()));				
							faculParams.put("premAmt", new BigDecimal(faculList.get(vCount - 1).get("premAmt").toString()));		
							faculParams.put("distTsi", new BigDecimal(faculList.get(vCount - 1).get("distTsi").toString()));			
							faculParams.put("distPrem", new BigDecimal(faculList.get(vCount - 1).get("distPrem").toString()));			
							faculParams.put("distSpct", new BigDecimal(faculList.get(vCount - 1).get("distSpct").toString()));		
							faculParams.put("lineCd", faculList.get(vCount - 1).get("lineCd").toString()); 			
							faculParams.put("currencyCd", faculList.get(vCount - 1).get("currencyCd").toString());			
							faculParams.put("currencyRt", new BigDecimal(faculList.get(vCount - 1).get("currencyRt"/*"distSeqNo"*/).toString())); //edgar 11/20/2014 : changed distSeqNo to currencyRt to retrieve correct currency rate.		
							faculParams.put("userId", faculList.get(vCount - 1).get("userId").toString());	
							faculParams.put("distSeqNo", vRgSeqNo);
							faculParams.put("distNo", params.get("distNo"));
							faculList.remove(vCount-1);
							vCount = vCount - 1;
							
							Map<String, Object> frpsParam = new HashMap<String, Object>();
							frpsParam.put("distSeqNo", vRgSeqNo);
							frpsParam.put("distNo", params.get("distNo"));
						    vFrpsExist = this.sqlMapClient.queryForObject("checkExistingFrps", frpsParam).toString();
						   
						    if (vFrpsExist.equals("FALSE")){
						    	this.sqlMapClient.insert("createNewWDistfrpsGiuws013",faculParams); 
						    }else{
						    	this.sqlMapClient.update("updateWDistFrpsGiuws013",faculParams); 
						    }
						    if (vCount == 0) {
				               break;
						    } 
						    vRgSeqNo = Integer.parseInt(faculList.get(vCount - 1).get("distSeqNo").toString());
						}
						Map<String, Object> reverseDateParams = new HashMap<String, Object>();
						reverseDateParams.put("distNo", params.get("oldDistNo").toString());
						reverseDateParams.put("distSeqNo", faculList2.get(i).get("distSeqNo").toString());
						
						if (vRgSeqNo < Integer.parseInt(faculList2.get(i).get("distSeqNo").toString())){
							this.sqlMapClient.update("updateReverseDateGiuws013", reverseDateParams); 
						}else if (vRgSeqNo == Integer.parseInt(faculList2.get(i).get("distSeqNo").toString())){
							Map<String, Object> faculParams = new HashMap<String, Object>();
							faculParams.put("tsiAmt",  new BigDecimal(faculList.get(vCount - 1).get("tsiAmt").toString()));				
							faculParams.put("premAmt", new BigDecimal(faculList.get(vCount - 1).get("premAmt").toString()));		
							faculParams.put("distTsi", new BigDecimal(faculList.get(vCount - 1).get("distTsi").toString()));			
							faculParams.put("distPrem", new BigDecimal(faculList.get(vCount - 1).get("distPrem").toString()));			
							faculParams.put("distSpct", new BigDecimal(faculList.get(vCount - 1).get("distSpct").toString()));		
							faculParams.put("lineCd", faculList.get(vCount - 1).get("lineCd").toString()); 			
							faculParams.put("currencyCd", faculList.get(vCount - 1).get("currencyCd").toString());			
							faculParams.put("currencyRt", new BigDecimal(faculList.get(vCount - 1).get("currencyRt"/*"distSeqNo"*/).toString())); //edgar 11/20/2014 : changed distSeqNo to currencyRt to retrieve correct currency rate.			
							faculParams.put("userId", faculList.get(vCount - 1).get("userId").toString());	
							faculParams.put("distSeqNo", vRgSeqNo);
							faculParams.put("distNo", params.get("distNo"));
							if(params.get("oldDistNo") != null){
								faculParams.put("oldDistNo", params.get("oldDistNo")); // added by: Nica 07.25.2012
							}
							
							faculList.remove(vCount-1);
							//if (vCount > 1){
							if (vCount > 0){ // modified by andrew - 11.27.2012 
								vCount = vCount-1;
							}
							
							if (new BigDecimal(faculParams.get("tsiAmt").toString()) !=  new BigDecimal(faculList2.get(i).get("tsiAmt").toString()) ||
								new BigDecimal(faculParams.get("premAmt").toString()) !=  new BigDecimal(faculList2.get(i).get("premAmt").toString()) ||	
								new BigDecimal(faculParams.get("distTsi").toString()) !=  new BigDecimal(faculList2.get(i).get("distTsi").toString()) ||
								new BigDecimal(faculParams.get("distPrem").toString()) !=  new BigDecimal(faculList2.get(i).get("distPrem").toString()) ||
								new BigDecimal(faculParams.get("distSpct").toString()) !=  new BigDecimal(faculList2.get(i).get("distSpct").toString()) ||
								new BigDecimal(faculParams.get("currencyCd").toString()) !=  new BigDecimal(faculList2.get(i).get("currencyCd").toString()) ||
								new BigDecimal(faculParams.get("currencyRt").toString()) !=  new BigDecimal(faculList2.get(i).get("currencyRt").toString()) ||
								new BigDecimal(faculParams.get("userId").toString()) !=  new BigDecimal(faculList2.get(i).get("userId").toString())){
								
								this.sqlMapClient.update("updateReverseDateGiuws013", reverseDateParams);
								Map<String, Object> frpsParam = new HashMap<String, Object>();
								frpsParam.put("distSeqNo", Integer.parseInt(faculList2.get(i).get("distSeqNo").toString()));
								frpsParam.put("distNo", params.get("distNo").toString());
							    vFrpsExist = this.sqlMapClient.queryForObject("checkExistingFrps", frpsParam).toString();
							   
							    if (vFrpsExist.equals("FALSE")){
							    	//this.sqlMapClient.insert("createWDistFrpsGiuws013",faculParams); // replaced by: Nica 07.25.2012
							    	this.sqlMapClient.insert("createNewWDistfrpsGiuws013",faculParams);
							    }else{
							    	this.sqlMapClient.update("updateWDistFrpsGiuws013",faculParams); 
							    }
							    
							}
						}
						
					}else{
						Map<String, Object> reverseDateParams = new HashMap<String, Object>();
						reverseDateParams.put("distNo", params.get("oldDistNo").toString());
						reverseDateParams.put("distSeqNo", faculList2.get(i).get("distSeqNo").toString());
						this.sqlMapClient.update("updateReverseDateGiuws013", reverseDateParams); 
						this.sqlMapClient.update("updateBinderFlagSw", reverseDateParams); 
					}
			
				}
			}	
			//processRemainingRecords(params);
		}else{
			processRemainingRecords(params);
		}
		
	}
	
	@SuppressWarnings("unchecked")
	public void processRemainingRecords(Map<String, Object> params) throws SQLException{
		List<Map<String, Object>> faculList = (List<Map<String, Object>>) params.get("faculList");
		List<Map<String, Object>> faculList2 = (List<Map<String, Object>>) params.get("faculList2");
		String vFrpsExist = "FALSE";
		
		for(int i=0; i<faculList2.size(); i++){
			if (faculList2.get(i).get("userId") != null){
				Map<String, Object> faculParams = new HashMap<String, Object>();
				faculParams.put("tsiAmt",  new BigDecimal(faculList.get(i).get("tsiAmt").toString()));				
				faculParams.put("premAmt", new BigDecimal(faculList.get(i).get("premAmt").toString()));		
				faculParams.put("distTsi", new BigDecimal(faculList.get(i).get("distTsi").toString()));			
				faculParams.put("distPrem", new BigDecimal(faculList.get(i).get("distPrem").toString()));			
				faculParams.put("distSpct", new BigDecimal(faculList.get(i).get("distSpct").toString()));		
				faculParams.put("lineCd", faculList.get(i).get("lineCd").toString()); 			
				faculParams.put("currencyCd", faculList.get(i).get("currencyCd").toString());			
				faculParams.put("currencyRt", new BigDecimal(faculList.get(i).get("currencyRt").toString()));			
				faculParams.put("userId", faculList.get(i).get("userId").toString());	
				faculParams.put("distSeqNo", faculList.get(i).get("distSeqNo").toString());
				faculParams.put("distNo", params.get("distNo"));
				
				Map<String, Object> frpsParam = new HashMap<String, Object>();
				frpsParam.put("distSeqNo", faculList.get(i).get("distSeqNo").toString());
				frpsParam.put("distNo", params.get("distNo"));
				log.info("Frps Params: "+frpsParam);
			    vFrpsExist = this.sqlMapClient.queryForObject("checkExistingFrps", frpsParam).toString();
			   
			    if (vFrpsExist.equals("FALSE")){
			    	this.sqlMapClient.insert("createNewWDistfrpsGiuws013",faculParams); 
			    }else{
			    	this.sqlMapClient.update("updateWDistFrpsGiuws013",faculParams); 
			    }
			}
		}

	}
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveOneRiskDistGiuws013(Map<String, Object> params) 
			throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDistGiuws013(params);
			Integer distNo = null;
			List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for (GIUWPolDist dist : polDist){
				log.info("Post form commit...");
				List<GIUWWpolicyds> ds = dist.getGiuwWpolicyds();
				System.out.println("Size: " + ds.size());
				for (GIUWWpolicyds polds : ds){
					distNo = polds.getDistNo();
					HashMap<String, Object> param = new HashMap<String, Object>();
					param.put("distNo", polds.getDistNo());
					param.put("distSeqNo", polds.getDistSeqNo());
					param.put("userId", (String) params.get("userId"));
					param.put("policyId", (String) params.get("policyId"));
					param.put("batchId", "null".equals(params.get("batchId")) ? null:  params.get("batchId"));
					param.put("batchDistSw", params.get("batchDistSw"));
					Debug.print("SAVE DAO PARAMS: " + param);
					this.getSqlMapClient().update("postFormCommitGIUWS013", param);
					System.out.println("postFORMS IN:");
					
					if (params.get("batchDistSw").equals("Y")){	// shan 08.11.2014
						log.info("Deleting records in final dist tables of dist_no: "+param.toString());
						this.getSqlMapClient().delete("delDistMasterTables", param);
					}
				}
				this.getSqlMapClient().executeBatch();
				
				this.updateSpecialDistSwGIUWS005(distNo);
			}
			
			Debug.print("Getting giuwPolDist details:::::::::::: par_id : " + params.get("parId"));
			params.put("giuwPolDist", this.getGIUWPolDist((Integer) params.get("parId")));
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	private void saveDistGiuws013(Map<String, Object> params) throws SQLException {
			
		List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
		for (GIUWPolDist dist : polDist){
			log.info("Saving giuw_pol_dist records...");
			this.getSqlMapClient().insert("setGIUWPolDist", dist);
		}
		
		List<GIUWWpolicyds> wpolicyds = (List<GIUWWpolicyds>) params.get("giuwWpolicydsRows");
		for (GIUWWpolicyds dist : wpolicyds){
			log.info("Saving giuw_wpolicyds records...");
			this.getSqlMapClient().insert("setGIUWWpolicyds", dist);
		}
		
		List<GIUWWpolicydsDtl> wpolicydsDtlDel = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlDelRows");
		for (GIUWWpolicydsDtl dist : wpolicydsDtlDel){
			log.info("Deleting giuw_wpolicyds_dtl records...");
			this.getSqlMapClient().delete("delGIUWWpolicydsDtl", dist);
		}
		
		List<GIUWWpolicydsDtl> wpolicydsDtl = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlSetRows");
		for (GIUWWpolicydsDtl dist : wpolicydsDtl){
			log.info("Saving giuw_wpolicyds_dtl records...");
			this.getSqlMapClient().insert("setGIUWWpolicydsDtl", dist);
			
			this.getSqlMapClient().update("deleteWorkingBinderTables2", dist);
		}
		
		this.getSqlMapClient().executeBatch();
	}


	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#saveDistributionByPeril(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveDistributionByPeril(
			Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			params.put("moduleId", "GIUWS012");
			this.savePerilDistribution(params);
			this.getSqlMapClient().executeBatch(); //added by robert 11.11.15 GENQA 5053
			
			/*	removed by robert 10.13.15 GENQA 5053		
				List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
				for (GIUWPolDist dist : polDist){
					log.info("Post form commit...");
					List<GIUWWPerilds> ds = dist.getGiuwWPerilds();
					for (GIUWWPerilds perilds : ds){
						HashMap<String, Object> param = new HashMap<String, Object>();
						param.put("policyId", (Integer) params.get("policyId"));
						param.put("distNo", perilds.getDistNo());
						param.put("distSeqNo", perilds.getDistSeqNo());
						param.put("lineCd", perilds.getLineCd());
						param.put("perilCd", perilds.getPerilCd());
						param.put("batchId", dist.getBatchId());
						param.put("postSw", (String) params.get("postSw"));
						param.put("userId", (String) params.get("userId"));
						
						log.info("policyId: " + param.get("policyId"));
						log.info("distNo: " + param.get("distNo"));
						log.info("distSeqNo: " + param.get("distSeqNo"));
						log.info("lineCd: " + param.get("lineCd"));
						log.info("perilCd: " + param.get("perilCd"));
						log.info("batchId: " + param.get("batchId"));
						log.info("postSw: " + param.get("postSw"));
						log.info("userId: " + param.get("userId"));
						this.getSqlMapClient().update("postFormCommitGIUWS012", param);
						this.getSqlMapClient().executeBatch();
					}
				}
				this.getSqlMapClient().executeBatch();
				
				this.getSqlMapClient().update("updateSpecialDistSwGIUWS005", params.get("distNo"));
				this.getSqlMapClient().executeBatch();
			*/
			
			// added by robert 11.11.15 GENQA 5053
			List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			List<GIUWWPerildsDtl> wperildsDtlDel = (List<GIUWWPerildsDtl>) params.get("giuwWPerildsDtlDelRows");
			List<GIUWWPerildsDtl> wperildsDtlSet = (List<GIUWWPerildsDtl>) params.get("giuwWPerildsDtlSetRows");
			wperildsDtlDel.addAll(wperildsDtlSet);
			for (GIUWPolDist dist : polDist){
				for (GIUWWPerildsDtl peril : wperildsDtlDel){
					Map<String, Object> postForm = new HashMap<String, Object>();
					postForm = params;
					postForm.put("distNo", peril.getDistNo());
					postForm.put("distSeqNo", peril.getDistSeqNo());
					postForm.put("perilCd", peril.getPerilCd());
					postForm.put("batchId", dist.getBatchId());
					log.info("POST-FORM-COMMIT GIUWS017 OF BATCH ID: "+postForm);
					this.sqlMapClient.update("postFormCommitGIUWS017Batch", postForm);
					this.getSqlMapClient().executeBatch();
					dist.setBatchId((String) postForm.get("batchId"));
				}
			}
			log.info("POST-FORM-COMMIT GIUWS017: "+params);
			this.sqlMapClient.update("postFormCommitGIUWS017", params);
			 this.getSqlMapClient().executeBatch();                           
			
			Map<String, Object> valMap = new HashMap<String, Object>();
			valMap.put("distNo", params.get("distNo"));
			valMap.put("msgAlert", "");
			this.sqlMapClient.update("validateDistWperildtl", valMap);
			if (valMap.get("msgAlert") != null) {
				this.checkErrorMessage(valMap.get("msgAlert").toString());
			}
			Map<String, Object> valMap2 = new HashMap<String, Object>();
			valMap2.put("distNo", params.get("distNo"));
			valMap2.put("msgAlert", "");
			this.sqlMapClient.update("validateWrkingTablsAmts", valMap2);
			if (valMap2.get("msgAlert") != null) {
				this.checkErrorMessage(valMap2.get("msgAlert").toString());
			}
			//end robert 11.11.15 GENQA 5053
			params.put("giuwPolDist", this.getGIUWPolDistForPerilDistribution((Integer) params.get("parId"), (Integer) params.get("distNo")));
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (PostingParException e) { // added by robert 11.11.15 GENQA 5053
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDistGiuts002(Map<String, Object> params)
			throws SQLException {
		Debug.print("PARAMS: " + params);
		return this.sqlMapClient.queryForList("getGIUWPolDistGiuts002", params);
	}
	
	public Map<String, Object> negDistGiuts002(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("negDistGiuts002", params);
		Debug.print(params);
		return params ;
	}
	
	public Map<String, Object> checkExistingClaimGiuts002(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkExistingClaimGiuts002", params);
		Debug.print(params);
		return params ;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getDistByTsiPremPeril(Map<String, Object> params) throws SQLException {
		List<GIUWPolDist> polDist = new ArrayList<GIUWPolDist>();
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Getting Dist by TSI/Prem (Peril)...");
			log.info("PARAMETERS : "+params);
			
			/*if (("2".equals((String) params.get("polFlag")) || "E".equals((String) params.get("parType")))){
				log.info("Creating items for GIUWS017...");
				this.sqlMapClient.delete("delDistWorkingTablesGIUWS017", params);
				this.sqlMapClient.delete("delDistMasterTables", params);
				this.getSqlMapClient().executeBatch();
				this.sqlMapClient.update("createItemsGIUWS017", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().executeBatch(); */ //remove by steven 06.24.2014 for confirmation
			polDist = this.getSqlMapClient().queryForList("getDistByTsiPremPeril", params);

			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}	
		
		return polDist;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#postDistGiuws012(java.util.Map)
	 */
	@Override
	public Map<String, Object> postDistGiuws012(Map<String, Object> params)
			throws SQLException, PostingParException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			//added byrobert 11.11.15 GENQA 5053
			this.sqlMapClient.update("validateDistWperildtl", params);
			if (params.get("msgAlert") != null) {
				this.checkErrorMessage(params.get("msgAlert").toString());
			}
			
			this.sqlMapClient.update("validateWrkingTablsAmts", params);
			if (params.get("msgAlert") != null) {
				this.checkErrorMessage(params.get("msgAlert").toString());
			}
			//end robert 11.11.15 GENQA 5053
			Map<String, Object> takeupMap = new HashMap<String, Object>();
			takeupMap.put("policyId", params.get("policyId"));
			takeupMap.put("takeUpTerm", "");
			this.getSqlMapClient().update("getPolicyTakeUp", takeupMap);
			this.getSqlMapClient().executeBatch();
			
			if(takeupMap.get("takeUpTerm").toString().equals("ST")){
				takeupMap.put("distNo", params.get("distNo"));
				takeupMap.put("vMsgAlert", "");
				this.getSqlMapClient().update("recomputeAfterCompare", takeupMap);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().update("prePostDistGIUWS012", params);
			
			/*	removed by robert 10.13.15 GENQA 5053
			Debug.print("DAO PARAMS BEFORE" + params);
			this.sqlMapClient.update("postDistGIUWS012", params);
			this.getSqlMapClient().executeBatch();
			Debug.print("DAO PARAMS AFTER" + params);
			
			if (params.get("msgAlert") != null) {
				this.checkErrorMessage(params.get("msgAlert").toString());
			}
			
			List<GIUWPolDist> polDist = this.getGIUWPolDistForPerilDistribution((Integer) params.get("parId"), (Integer) params.get("distNo"));
			for (GIUWPolDist dist : polDist){
				log.info("Post form commit...");
				List<GIUWWPerilds> ds = dist.getGiuwWPerilds();
				for (GIUWWPerilds perilds : ds){
					HashMap<String, Object> param = new HashMap<String, Object>();
					param.put("policyId", (Integer) params.get("policyId"));
					param.put("distNo", perilds.getDistNo());
					param.put("distSeqNo", perilds.getDistSeqNo());
					param.put("lineCd", perilds.getLineCd());
					param.put("perilCd", perilds.getPerilCd());
					param.put("batchId", dist.getBatchId());
					param.put("postSw", "Y");
					param.put("userId", (String) params.get("userId"));
					
					log.info("policyId: " + param.get("policyId"));
					log.info("distNo: " + param.get("distNo"));
					log.info("distSeqNo: " + param.get("distSeqNo"));
					log.info("lineCd: " + param.get("lineCd"));
					log.info("perilCd: " + param.get("perilCd"));
					log.info("batchId: " + param.get("batchId"));
					log.info("postSw: " + param.get("postSw"));
					log.info("userId: " + param.get("userId"));
					this.getSqlMapClient().update("postFormCommitGIUWS012", param);
				}
			}
			this.getSqlMapClient().executeBatch();*/
			
			//added by robert 10.13.15 GENQA 5053
			List<GIUWPolDist> polDist = this.getGIUWPolDistForPerilDistribution((Integer) params.get("parId"), (Integer) params.get("distNo"));
			for (GIUWPolDist dist : polDist){
				List<GIUWWPerilds> wperilds = dist.getGiuwWPerilds();
				for (GIUWWPerilds peril : wperilds){
					Map<String, Object> postParams = new HashMap<String, Object>();
					postParams = params;
					postParams.put("distNo", peril.getDistNo());
					postParams.put("distSeqNo", peril.getDistSeqNo());
					postParams.put("perilCd", peril.getPerilCd());
					postParams.put("batchId", dist.getBatchId());
					postParams.put("policyId", params.get("policyId").toString());
					postParams.put("issueYy", params.get("issueYy").toString());
					postParams.put("polSeqNo", params.get("polSeqNo").toString());
					postParams.put("renewNo", params.get("renewNo").toString());
					if (peril.getDistNo() == params.get("distNo")){
						log.info("POSTING DISTRIBUTION GIUWS017 : "+postParams);
						this.sqlMapClient.update("postDistGIUWS017", postParams);
						this.getSqlMapClient().executeBatch();
						dist.setBatchId((String) postParams.get("batchId"));
					}
					break;
				}
			}
			this.getSqlMapClient().executeBatch();
			//end robert SR 5053 11.11.15
			
			this.getSqlMapClient().update("updateSpecialDistSwGIUWS005", params.get("distNo"));
			this.getSqlMapClient().executeBatch();
			
			//this.getSqlMapClient().update("setDistSpct1ToNull", params.get("distNo")); //removed by robert 10.13.15 GENQA 5053
			//this.getSqlMapClient().executeBatch(); //removed by robert 10.13.15 GENQA 5053
			
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("giuwPolDist", this.getGIUWPolDistForPerilDistribution((Integer) params.get("parId"), (Integer) params.get("distNo")));
		} catch (PostingParException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();			
		}
		
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveDistrByTSIPremGroup( 
			Map<String, Object> params) throws SQLException, Exception {
		
		try {
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Integer distNo = null;	// shan 06.26.2014
			
			List<GIUWWpolicydsDtl> wpolicydsDtlDel = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlDelRows");
			for (GIUWWpolicydsDtl dist : wpolicydsDtlDel){
				log.info("Deleting giuw_wpolicyds_dtl records...");
				this.getSqlMapClient().delete("delGIUWWpolicydsDtl", dist);
				this.getSqlMapClient().executeBatch();
				distNo = dist.getDistNo();	// shan 06.26.2014
			}
			
			List<GIUWWpolicydsDtl> wpolicydsDtl = (List<GIUWWpolicydsDtl>) params.get("giuwWpolicydsDtlSetRows");
			for (GIUWWpolicydsDtl dist : wpolicydsDtl){
				log.info("Saving giuw_wpolicyds_dtl records...");
				this.getSqlMapClient().insert("setGIUWWpolicydsDtl", dist);
				this.getSqlMapClient().executeBatch();
				distNo = dist.getDistNo();	// shan 06.26.2014
			}
			
			// POST-FORMS-COMMIT
			
			List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
			for(GIUWPolDist dist : polDist){
				List<GIUWWpolicyds> polDsList = dist.getGiuwWpolicyds();
				Map<String, Object> postCommitParams = new HashMap<String, Object>();
				
				/*for(GIUWWpolicyds polDs : polDsList){ // as per sir edgar, adjusting of amounts should not be done on saving because validation will be done before posting
					postCommitParams.clear();
					postCommitParams.put("distSeqNo", polDs.getDistSeqNo());
					postCommitParams.put("distNo", dist.getDistNo());
					postCommitParams.put("userId", params.get("userId"));
					this.getSqlMapClient().update("adjustWpolicydsDtlGIUWS016", postCommitParams);
					Debug.print("adjustWpolicydsDtl : " + postCommitParams);
					this.getSqlMapClient().executeBatch();
					
				}*/
				
				for (GIUWWpolicyds polds : polDsList){
					postCommitParams.put("distNo", polds.getDistNo());
					postCommitParams.put("distSeqNo", polds.getDistSeqNo());
					postCommitParams.put("policyId", params.get("policyId"));
					postCommitParams.put("batchId", "null".equals(params.get("batchId")) ? null:  params.get("batchId"));
					postCommitParams.put("userId", params.get("userId"));
					this.getSqlMapClient().update("postFormsCommitGIUWS016", postCommitParams);
					Debug.print("postFormsCommit: " + postCommitParams);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			// shan 06.26.2014
			Map<String, Object> p = new HashMap<String, Object>();
			p.put("distNo", distNo);
			this.sqlMapClient.update("deleteWorkingBinders", p);
			// end 06.20.2014
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> saveDistByTsiPremPeril(Map<String, Object> params)
			throws SQLException, DistributionException{
		String message = "SUCCESS";
		Integer distNo = null;
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if("Y".equals((String) params.get("postSw"))){
				/* POSTING DISTRIBUTION */
				List<GIUWPolDist> polDist2 = this.getSqlMapClient().queryForList("getDistByTsiPremPeril", params);
				for (GIUWPolDist dist : polDist2){
					List<GIUWWPerilds> wperilds = dist.getGiuwWPerilds();
					for (GIUWWPerilds peril : wperilds){
						Map<String, Object> postParams = new HashMap<String, Object>();
						postParams = params;
						postParams.put("distNo", peril.getDistNo());
						postParams.put("distSeqNo", peril.getDistSeqNo());
						postParams.put("perilCd", peril.getPerilCd());
						postParams.put("batchId", dist.getBatchId());
						
						if (peril.getDistNo() == params.get("distNo")){
							log.info("POSTING DISTRIBUTION GIUWS017 : "+postParams);
							this.sqlMapClient.update("postDistGIUWS017", postParams);
							this.getSqlMapClient().executeBatch();
							dist.setBatchId((String) postParams.get("batchId"));
							if (postParams.get("msgAlert") != null){
								message = (String) postParams.get("msgAlert");
								throw new DistributionException((String) postParams.get("msgAlert"));
							}
						}
						break; //added by steven dapat one time lang siyang papasok.
					}
				}
			}else{
				/* SAVING DISTRIBUTION */
				this.savePerilDistribution(params);
				this.getSqlMapClient().executeBatch();
				
				/* POST-FORM-COMMIT */
				List<GIUWPolDist> polDist = (List<GIUWPolDist>) params.get("giuwPoldistRows");
				List<GIUWWPerildsDtl> wperildsDtlDel = (List<GIUWWPerildsDtl>) params.get("giuwWPerildsDtlDelRows");
				List<GIUWWPerildsDtl> wperildsDtlSet = (List<GIUWWPerildsDtl>) params.get("giuwWPerildsDtlSetRows");
				wperildsDtlDel.addAll(wperildsDtlSet);
				for (GIUWPolDist dist : polDist){
					for (GIUWWPerildsDtl peril : wperildsDtlDel){
						Map<String, Object> postForm = new HashMap<String, Object>();
						postForm = params;
						postForm.put("distNo", peril.getDistNo());
						postForm.put("distSeqNo", peril.getDistSeqNo());
						postForm.put("perilCd", peril.getPerilCd());
						postForm.put("batchId", dist.getBatchId());
						log.info("POST-FORM-COMMIT GIUWS017 OF BATCH ID: "+postForm);
						this.sqlMapClient.update("postFormCommitGIUWS017Batch", postForm);
						this.getSqlMapClient().executeBatch();
						dist.setBatchId((String) postForm.get("batchId"));
					}
					distNo = dist.getDistNo();
				}
				log.info("POST-FORM-COMMIT GIUWS017: "+params);
				this.sqlMapClient.update("postFormCommitGIUWS017", params);
				this.getSqlMapClient().executeBatch();
				
				log.info("CHECKING PERIL DISTRIBUTION ERROR IN GIUWS017: DIST NO = "+distNo);
				message = checkPerilDistributionError(distNo);
				this.getSqlMapClient().executeBatch();
			}
			
			/* Refreshing GIUW_POL_DIST to be display */
			this.getSqlMapClient().executeBatch();
			params.put("giuwPolDist", this.getSqlMapClient().queryForList("getDistByTsiPremPeril", params));
			params.put("gipiPolbasicPolDistV1", this.getSqlMapClient().queryForList("getV1ListDistByTsiPremPeril2", params));
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while saving...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("Done saving/posting GIUWS017");
			this.getSqlMapClient().endTransaction();
			params.put("message", message);
		}	
		return params;
	}

	@Override
	public Map<String, Object> postDistGiuws016(Map<String, Object> params)
			throws SQLException, PostingParException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Debug.print("DAO PARAMS BEFORE" + params);
			this.sqlMapClient.update("postDistGIUWS016", params);
			this.getSqlMapClient().executeBatch();
			Debug.print("DAO PARAMS AFTER" + params);
			
			if (params.get("msgAlert") != null) {
				this.checkErrorMessage(params.get("msgAlert").toString());
			}
			
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			params.put("giuwPolDist", this.getGIUWPolDistGiuws016(params));
		} catch (PostingParException e) {
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (NullPointerException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();			
		}
		
		return params;
	}

	private String checkPerilDistributionError(Integer distNo) throws DistributionException, SQLException{
		log.info("Checking peril distribution error : "+distNo);
		String message = "SUCCESS";
		Map<String, Object> perilError = new HashMap<String, Object>();
		perilError.put("distNo", distNo);
		this.sqlMapClient.update("checkPerilDistributionError", perilError);
		if (perilError.get("msgAlert") != null){
			message = (String) perilError.get("msgAlert");
			throw new DistributionException((String) perilError.get("msgAlert"));
		}
		return message;
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#getDistFlagAndBatchId(java.lang.Integer, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public Map<String, Object> getDistFlagAndBatchId(Integer policyId,
			Integer distNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("distNo", distNo);
		return (Map<String, Object>)this.getSqlMapClient().queryForObject("getDistFlagAndBatchId", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#getGIUWPolDistForRedistribution(java.lang.Integer, java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIUWPolDist> getGIUWPolDistForRedistribution(Integer parId,
			Integer distNo) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("distNo", distNo);
		return this.getSqlMapClient().queryForList("getGIUWPolDistForRedistribution", params);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#negateDistributionGiuts021(java.util.Map)
	 */
	@Override
	public void negateDistributionGiuts021(Map<String, Object> params)
			throws SQLException, NegateDistributionException {
		try {
			GIPIPolbasic polBasic = null;
			List<GIUWPolDist> polDistList = null;
			Integer oldDistNo = (Integer)params.get("distNo");
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("negateDistributionGIUTS021", params);
			
			this.getSqlMapClient().executeBatch();
			
			if (params.get("msgAlert") != null) {
				if (!"SUCCESS".equals(params.get("msgAlert").toString())) {
					throw new NegateDistributionException(params.get("msgAlert").toString());
				}
			}
			
			polBasic = (GIPIPolbasic) this.getSqlMapClient().queryForObject("getRedistributionPolicy", params.get("policyId"));
			
			if (polBasic != null) {
				//polDistList = (List<GIUWPolDist>) this.getGIUWPolDistForRedistribution(polBasic.getParId(), (Integer)params.get("distNo"));
				polDistList = (List<GIUWPolDist>) this.getGIUWPolDistForRedistribution(polBasic.getParId(), oldDistNo);
			}
			
			params.put("polBasic", polBasic);
			params.put("polDistList", polDistList);
			
			if (params.get("forSaving") != null) {
				if ("Y".equals(params.get("forSaving").toString())) {
					this.getSqlMapClient().getCurrentConnection().commit();
				} else {
					this.getSqlMapClient().getCurrentConnection().rollback();
				}
			} else {
				this.getSqlMapClient().getCurrentConnection().rollback();
			}
		} catch (SQLException e) {
			//e.printStackTrace(); edgar 09/26/2014
			this.getSqlMapClient().getCurrentConnection().rollback();
			//this.getSqlMapClient().endTransaction(); edgar 09/26/2014
			throw e;//new SQLException(); changed to 'e' edgar 09/26/2014
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
			throw new NegateDistributionException(e.getMessage());
		} finally {
			this.getSqlMapClient().endTransaction(); // removed. to be executed after saving
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#saveRedistribution(java.util.Map)
	 */
	@Override
	public void saveRedistribution(Map<String, Object> params)
			throws SQLException {
		// basically, this method just commits the changes we made in Negate Distribution
		try {
			GIPIPolbasic polBasic = null;
			List<GIUWPolDist> polDistList = null;
			
			//System.out.println("Saving...");
			if (this.getSqlMapClient().getCurrentConnection() != null) {
				//System.out.println("Saved!");
				this.getSqlMapClient().getCurrentConnection().commit();
			}
			
			polBasic = (GIPIPolbasic) this.getSqlMapClient().queryForObject("getRedistributionPolicy", params.get("policyId"));
			
			if (polBasic != null) {
				polDistList = (List<GIUWPolDist>) this.getGIUWPolDistForRedistribution(polBasic.getParId(), (Integer)params.get("distNo"));
			}
			
			params.put("polBasic", polBasic);
			params.put("polDistList", polDistList);
		} catch (SQLException e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.giuw.dao.GIUWPolDistDAO#endRedistributionTransaction()
	 */
	@Override
	public void endRedistributionTransaction() throws SQLException {
		// TODO Auto-generated method stub
		try {
			//System.out.println("Ending transaction...");
			if (this.getSqlMapClient().getCurrentConnection() != null) {
				//System.out.println("OK");
				this.getSqlMapClient().endTransaction();
			}
		} catch (SQLException e) {
			e.printStackTrace();
			throw new SQLException();
		}
	}

	@Override
	public Map<String, Object> validateExistingDist(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateExistingDist", params);
		return params;
	}

	/**
	 * Adjust distribution tables upon creating item, saving and posting of Distribution edgar 03/05/2014
	 */
	@Override
	public Map<String, Object> adjustPerilDistTables(Map<String, Object> params)
			throws SQLException {
		log.info("adjustPerilDistTables of dist_no: "+params);
		this.getSqlMapClient().update("adjustPerilDistTables", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 * Recomputes distribution premium amounts upon saving/posting edgar 04/29/2014
	 */
	@Override
	public Map<String, Object> recomputePerilDistPrem(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("recomputePerilDistPrem", params);
		this.getSqlMapClient().executeBatch();
		String isPack = (params.get("isPack") == null) ? "N" : params.get("isPack").toString();
		
		if ("Y".equals(isPack)) {
			params.put("giuwPolDist", this.getPackGIUWPolDist1((Integer) params.get("parId")));
		} else {
			params.put("giuwPolDist", this.getGIUWPolDist1((Integer) params.get("parId")));
		}
		
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 * Compare distribution tables and itemperil table edgar 05/05/2014
	 */
	@Override
	public Map<String, Object> compareWitemPerilToDs(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("compareWitemPerilToDs", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 * Gets the peril type for checking of endorsement edgar 05/05/2014
	 */
	@Override
	public Map<String, Object> getPerilType(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("getPerilType", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 * Gets the expiry date for comparison to effectivity date of policy edgar 05/06/2014
	 */
	@Override
	public Map<String, Object> getTreatyExpiry(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("getTreatyExpiry", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 * Execute deletion of distribution master tables during unposting edgar 05/07/2014
	 */
	@Override
	public Map<String, Object> unpostDist(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("unpostDist", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 * Recompute and adjust distribution tables with discrepancies edgar 05/07/2014
	 */
	@Override
	public Map<String, Object> recomputeAfterCompare(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("recomputeAfterCompare", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 * get takeup term edgar 05/08/2014
	 */
	@Override
	public Map<String, Object> getTakeUpTerm(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("getTakeUpTerm", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}
	
	/**
	 * updates dist_spct1 when distribution is saved in GIUWS003 then navigate to GIUWS006 shan 05.06.2014
	 */	
	public void updateDistSpct1(Integer distNo) throws SQLException{
		log.info("Updating dist_spct1 of dist_no " + distNo);
		this.getSqlMapClient().update("updateDistSpct1", distNo);
		this.getSqlMapClient().executeBatch();		
	}

	@Override
	public void updateGIUWS017DistSpct1(String distNo) throws SQLException {
		this.getSqlMapClient().update("updateGIUWS017DistSpct1", distNo);
	}

	@Override
	public Map<String, Object> getPolicyTakeUp(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("getPolicyTakeUp", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	@Override
	public Map<String, Object> comparePolItmperilToDs(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("comparePolItmperilToDs", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 *  Compare distribution tables and itemperil table for One Risk edgar 05/12/2014
	 */
	@Override
	public Map<String, Object> compareWitemPerilToDsGIUWS004(
			Map<String, Object> params) throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("compareWitemPerilToDsGIUWS004", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 *  Recomputes dist prem amounts when dist_spct1 has value for GIUWS004, GIUWS013 edgar 05/12/2014
	 */
	@Override
	public Map<String, Object> adjustDistPremGIUWS004(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("adjustDistPremGIUWS004", params);
		this.getSqlMapClient().executeBatch();
		params.put("giuwPolDist", this.getGIUWPolDist((Integer) params.get("parId")));
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 *  Adjust all working distribution tables for GIUWS004, GIUWS013 edgar 05/12/2014
	 */
	@Override
	public Map<String, Object> adjustAllWTablesGIUWS004(
			Map<String, Object> params) throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("adjustAllWTablesGIUWS004", params);
		this.getSqlMapClient().executeBatch();
		params.put("giuwPolDist", this.getGIUWPolDist((Integer) params.get("parId")));
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 *  check if non-null distSpct1 exists edgar 05/13/2014
	 */
	@Override
	public Map<String, Object> getDistScpt1Val(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("getDistScpt1Val", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 *  Updates dist_spct1 to null when it has value but same with dist_spct for GIUWS004, GIUWS013 edgar 05/13/2014
	 */
	@Override
	public Map<String, Object> updateDistSpct1ToNull(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("updateDistSpct1ToNull", params);
		this.getSqlMapClient().executeBatch();
		params.put("giuwPolDist", this.getGIUWPolDist((Integer) params.get("parId")));
		this.getSqlMapClient().executeBatch();
		return params;
	}

	/**
	 *  Delete and Reinsert when posting in GIUWS004 which was saved from Peril modules edgar 05/14/2014
	 */
	@Override
	public Map<String, Object> deleteReinsertGIUWS004(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("deleteReinsertGIUWS004", params);
		this.getSqlMapClient().executeBatch();
		params.put("giuwPolDist", this.getGIUWPolDist((Integer) params.get("parId")));
		this.getSqlMapClient().executeBatch();
		return params;
	}
	
	public void compareDelRinsrtWdistTable(Integer distNo) throws SQLException{
		log.info("compareDelRinsrtWdistTable of distNo: "+distNo);
		this.getSqlMapClient().update("compareDelRinsrtWdistTable", distNo);
		this.getSqlMapClient().executeBatch();	
	}
	
	public void updateSpecialDistSwGIUWS005(Integer distNo) throws SQLException{
		log.info("Updating special_dist_sw of distNo: "+distNo);
		this.getSqlMapClient().update("updateSpecialDistSwGIUWS005", distNo);
		this.getSqlMapClient().executeBatch();
	}
	
	public void updateAutoDistGIUWS005(Map<String, Object> params) throws SQLException{
		log.info("Updating auto_dist...: "+params.toString());
		this.getSqlMapClient().update("updateAutoDistGIUWS005", params);
		this.getSqlMapClient().executeBatch();
	}
	
	public String compareWdistTable(Map<String, Object> params) throws SQLException{
		String message = "SUCCESS";
		try{
			log.info("Comparing Wdist tables: "+params.toString());
			this.getSqlMapClient().update("compareWdistTable", params);
			this.getSqlMapClient().executeBatch();
		}catch (SQLException e) {
			message = ExceptionHandler.extractSqlExceptionMessage(e);
			ExceptionHandler.logException(e);
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	
	@SuppressWarnings("unchecked")
	public Map<String, Object> getWpolbasGIUWS005(Integer parId) throws SQLException{
		return (Map<String, Object>) this.getSqlMapClient().queryForObject("getWpolbasGIUWS005", parId);
	}

	// Gzelle 06112014
	public void compareDelRinsrtWdistTableGIUWS004(Integer distNo) throws SQLException{
		log.info("compareDelRinsrtWdistTableGIUWS004 of distNo: "+distNo);
		this.getSqlMapClient().update("compareDelRinsrtWdistTableGIUWS004", distNo);
		this.getSqlMapClient().executeBatch();	
	}
	
	public void cmpareDelRinsrtWdistTbl1GIUWS004(Integer distNo) throws SQLException{
		log.info("cmpareDelRinsrtWdistTbl1GIUWS004 of distNo: "+distNo);
		this.getSqlMapClient().update("cmpareDelRinsrtWdistTbl1GIUWS004", distNo);
		this.getSqlMapClient().executeBatch();	
	}
	
	@Override
	public Map<String, Object> postDistGiuws004Final(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDist(params);
			
			this.sqlMapClient.update("postDistGIUWS004Final", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = "SQL Exception occured while creating items...";
			}
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	//end
	
	@Override
	public String checkBinderExist(Integer policyId, Integer distNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("policyId", policyId);
		params.put("distNo", distNo);
		return (String) this.sqlMapClient.queryForObject("checkBinderExist", params);
	}
	
	public void populateWitemPerilDtl(Integer distNo) throws SQLException{
		log.info("Populate_witem_peril_dtl of dist_no: "+distNo);
		this.sqlMapClient.update("populateWitemPerilDtl", distNo);
		this.sqlMapClient.executeBatch();
	}
	
	public Map<String, Object> checkNullDistPremGIUWS006(Map<String, Object> params) throws SQLException{	
		String message = "SUCCESS";
		if (params.get("btnSw").equals("S")){
			this.updateDistSpct1(Integer.parseInt(params.get("distNo").toString()));
		}
		log.info("check_null_dist_prem_GIUWS006: "+params.toString());
		this.sqlMapClient.update("checkNullDistPremGIUWS006", params);
		this.getSqlMapClient().executeBatch();
		/*try{
			log.info("check_null_dist_prem_GIUWS006: "+params.toString());
			this.sqlMapClient.update("checkNullDistPremGIUWS006", params);
			this.getSqlMapClient().executeBatch();
		}catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
			}else{
				message = "SQL Exception occured while saving...";
			}
			ExceptionHandler.logException(e);
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (Exception e) {
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		params.put("message", message);*/
		return params;
	}
	
	public String checkSumInsuredPrem(Integer distNo) throws SQLException{
		log.info("check_sum_insrd_prem_GIUWS006: "+distNo);
		return (String) this.sqlMapClient.queryForObject("checkSumInsrdPremGIUWS006", distNo);
	}
	
	public String validateB4PostGIUWS006(Map<String, Object> params) throws SQLException{
		String message = "SUCCESS";
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();

			// added by shan 08.26.2014
			message = this.checkPerilDistributionError(Integer.parseInt(params.get("distNo").toString()));
			// end 08.26.2014
			
			this.getSqlMapClient().update("adjustShareWdistfrps", Integer.parseInt(params.get("distNo").toString()));
			this.getSqlMapClient().executeBatch();
			
			log.info("validateB4PostGIUWS006 - params : " + params);
			this.getSqlMapClient().update("validateB4PostGIUWS006", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (DistributionException e) {
			e.printStackTrace();
			message = e.getMessage();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (SQLException e) {
			message = ExceptionHandler.extractSqlExceptionMessage(e);
			ExceptionHandler.logException(e);
			e.printStackTrace();
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	//edgar
	@Override
	public Map<String, Object> postDistGiuws003Final(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			//added by robert 11.11.15 GENQA 5053
			this.updateDistSpct1(Integer.parseInt(params.get("distNo").toString()));
			this.getSqlMapClient().executeBatch();
			
			log.info("Adjusting Distribution..."+Integer.parseInt(params.get("distNo").toString()));
			HashMap<String, Object> param = new HashMap<String, Object>();
			param.put("distNo", Integer.parseInt(params.get("distNo").toString()));
			this.adjustPerilDistTables(param);
			this.getSqlMapClient().executeBatch();
			//end robert 11.11.15 GENQA 5053
			HashMap<String, Object> param4 = new HashMap<String, Object>();
			param4.put("distNo", params.get("distNo"));
			this.getSqlMapClient().update("deleteWorkingBinders", param4);
			this.getSqlMapClient().executeBatch();
			
			//this.sqlMapClient.update("postDistGIUWS003Final", params); removed by robert 10.13.15 GENQA 5053
			this.sqlMapClient.update("postDistGIUWS006Final", params); //added by robert 10.13.15 GENQA 5053
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo3", params);
			params.put("newItems", newItems);
			
			//this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){
				message = ExceptionHandler.extractSqlExceptionMessage(e);
			}else{
				message = "SQL Exception occured while saving...";
			}
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	
	public Map<String, Object> postDistGiuws006Final(Map<String, Object> params) throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.updateDistSpct1(Integer.parseInt(params.get("distNo").toString()));
			//this.saveDistGiuws006(params);
			
			// shan 07.25.2014
			log.info("Adjusting Distribution..."+Integer.parseInt(params.get("distNo").toString()));
			HashMap<String, Object> param3 = new HashMap<String, Object>();
			param3.put("distNo", Integer.parseInt(params.get("distNo").toString()));
			this.adjustPerilDistTables(param3);
			// end 07.25.2014
			log.info("Posting Dist GIUWS006 Final :"+params.toString());
			this.sqlMapClient.update("postDistGIUWS006Final", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo3", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}

	@Override
	public void validateRenumItemNos(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateRenumItemNos", params);
	}
	
	public Map<String, Object> postDistGiuws005Final(Map<String, Object> params)
			throws SQLException {
		String message = "";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.saveDistGiuws005(params);
			
			/*this.compareDelRinsrtWdistTable(Integer.parseInt(params.get("distNo").toString()));	// already included inside the pkg
			Map<String, Object> p = new HashMap<String, Object>();
			p.put("distNo", params.get("distNo"));
			this.adjustAllWTablesGIUWS004(p);	*/	
			this.sqlMapClient.update("postDistGIUWS005Final", params);
			this.getSqlMapClient().executeBatch();
			
			GIUWPolDist newItems = (GIUWPolDist) this.sqlMapClient.queryForObject("getGIUWPolDistPerDistNo", params);
			params.put("newItems", newItems);
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (SQLException e) {
			if(e.getErrorCode() > 20000){ // added condition : shan 06.03.2014
				message = ExceptionHandler.extractSqlExceptionMessage(e);
				ExceptionHandler.logException(e);
			} else {
				message = "SQL Exception occured while creating items...";
			}
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (NullPointerException e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} catch (Exception e) {
			message = "SQL Exception occured while creating items...";
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			this.getSqlMapClient().getCurrentConnection().rollback();
			this.getSqlMapClient().endTransaction();
		}	
		params.put("message", message);
		return params;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void preSaveOuterDist(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().update("preSaveOuterDist", params);
			
			/*if(params.get("parType").toString().equals("E")){
				List<Map<String, Object>> wperilDsList = (List<Map<String, Object>>) params.get("giuwWPerildsRows");
				for(Map<String, Object> rec : wperilDsList){
					this.getSqlMapClient().update("checkZeroPremAllied", rec);
				}
			}*/
			
			List<Map<String, Object>> wperilDsDtlList = (List<Map<String, Object>>) params.get("giuwWPerildsDtlRows");
			for(Map<String, Object> dtl : wperilDsDtlList){
				this.getSqlMapClient().update("checkExpiredTreaty", dtl);
			}
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		}
	}

	@Override
	public Map<String, Object> checkPostedBinder(Map<String, Object> params)
			throws SQLException {
		log.info(params);
		this.getSqlMapClient().update("checkPostedBinder", params);
		this.getSqlMapClient().executeBatch();
		return params;
	}

	@Override
	public void checkItemPerilAmountAndShare(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("checkItemPerilAmountAndShare",params);		
	}

	@Override
	public String checkIfDiffPerilGroupShare(Integer distNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("distNo", distNo);
		return (String) this.sqlMapClient.queryForObject("checkIfDiffPerilGroupShare", params);
	}

	@Override
	public Map<String, Object> validateFaculPremPaytGIUTS002(
			Map<String, Object> params) throws SQLException {
		this.getSqlMapClient().update("validateFaculPremPaytGIUTS002", params);
		return params ;
	}

	@Override
	public void preValidationNegDist(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("preValidationNegDist", params);
	}
	//edgar 09/26/2014
	@Override
	public void validateTakeupGiuts021(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateTakeupGiuts021", params);
	}
}