package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACLossRecoveriesDAO;
import com.geniisys.giac.entity.GIACLossRecoveries;
import com.geniisys.giac.exceptions.InvalidAegParametersException;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACLossRecoveriesDAOImpl implements GIACLossRecoveriesDAO{
	
	private Logger log = Logger.getLogger(GIACLossRecoveriesDAOImpl.class);
	
	private SqlMapClient sqlMapClient;

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACLossRecoveries> getGIACLossRecoveries(Integer gaccTranId)
			throws SQLException {
		log.info("Getting giac_loss_recoveries records.");
		return this.getSqlMapClient().queryForList("getGIACLossRecoveries", gaccTranId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getRecoveryNoList(
			HashMap<String, Object> params) throws SQLException {
		List<Map<String, Object>> list = null;
		if (params.get("transactionType").equals("1")){
			list = this.sqlMapClient.queryForList("getRecoveryNoListing", params);
		}else if (params.get("transactionType").equals("2")){
			list = this.sqlMapClient.queryForList("getRecoveryNoListing2", params);
		}	
		return list;
	}

	@Override
	public Map<String, Object> getSumCollnAmtLossRec(
			Map<String, Object> params) throws SQLException {
		this.sqlMapClient.update("getSumCollnAmtLossRec", params);
		return params;
	}

	@Override
	public Map<String, Object> getCurrency(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("getCurrencyLossRec", params);
		return params;
	}

	@Override
	public Map<String, Object> validateCurrencyCode(Map<String, Object> params)
			throws SQLException {
		this.sqlMapClient.update("validateCurrencyCodeLossRec", params);
		return params;
	}

	@Override
	public String validateDeleteLossRec(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("validateDeleteLossRec", params);
	}

	@Override
	public String getTranFlag(Integer gaccTranId) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("getTranFlagLossRec", gaccTranId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public String saveLossRec(Map<String, Object> params) throws SQLException {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("Start of saving direct trans loss recoveries.");
			List<GIACLossRecoveries> setRows = (List<GIACLossRecoveries>) params.get("setRows");
			List<GIACLossRecoveries> delRows = (List<GIACLossRecoveries>) params.get("delRows");
			Integer gaccTranId = (Integer) params.get("gaccTranId"); 
			
			for(GIACLossRecoveries del:delRows){
				log.info("calling del_upd_recovery.");
				this.getSqlMapClient().delete("delUpdRecovery", del);
				log.info("deleting loss recoveries: "+ del.getGaccTranId()+","+del.getClaimId()+","+del.getRecoveryId()+","+del.getPayorClassCd()+","+del.getPayorCd());
				this.getSqlMapClient().delete("delGIACLossRecoveries", del);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIACLossRecoveries ins:setRows){
				ins.setUserId((String)params.get("userId"));
				ins.setAppUser((String)params.get("userId"));
				log.info("inserting loss recoveries: "+ ins.getGaccTranId()+","+ins.getClaimId()+","+ins.getRecoveryId()+","+ins.getPayorClassCd()+","+ins.getPayorCd());
				this.getSqlMapClient().insert("setGIACLossRecoveries", ins);
				log.info("Post insert loss recoveries.");
				this.sqlMapClient.update("postInsertLossRec", ins);
			}
			this.getSqlMapClient().executeBatch();
			
			//start of post-form-commit
			for (GIACLossRecoveries aeg:delRows){
				Map<String, Object> paramsAeg = new HashMap<String, Object>();
				paramsAeg.put("moduleName", "GIACS010");
				paramsAeg.put("gaccBranchCd", (String) params.get("gaccBranchCd"));
				paramsAeg.put("gaccFundCd", (String) params.get("gaccFundCd"));
				paramsAeg.put("gaccTranId", gaccTranId);
				paramsAeg.put("userId", (String) params.get("userId"));
				paramsAeg.put("claimId", aeg.getClaimId());
				this.sqlMapClient.update("aegParametersGIACS010", paramsAeg);
				if (paramsAeg.get("vMsgAlert") != null){
					message = "Error occured. "+(String) paramsAeg.get("vMsgAlert");
					throw new InvalidAegParametersException(message);
				}
				log.info("aeg_parameters : "+paramsAeg);
			}
			this.getSqlMapClient().executeBatch();
			
			for (GIACLossRecoveries aeg:setRows){
				Map<String, Object> paramsAeg = new HashMap<String, Object>();
				paramsAeg.put("moduleName", "GIACS010");
				paramsAeg.put("gaccBranchCd", (String) params.get("gaccBranchCd"));
				paramsAeg.put("gaccFundCd", (String) params.get("gaccFundCd"));
				paramsAeg.put("gaccTranId", gaccTranId);
				paramsAeg.put("userId", (String) params.get("userId"));
				paramsAeg.put("claimId", aeg.getClaimId());
				this.sqlMapClient.update("aegParametersGIACS010", paramsAeg);
				if (paramsAeg.get("vMsgAlert") != null){
					message = "Error occured. "+(String) paramsAeg.get("vMsgAlert");
					throw new InvalidAegParametersException(message);
				}
				log.info("aeg_parameters : "+paramsAeg);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		} catch (InvalidAegParametersException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
		} catch (SQLException e) { //marco - 04.20.2013 - added for raise_application_error message
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			log.info("End of saving direct trans loss recoveries.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}

	@SuppressWarnings("unchecked")
	@Override
	//public List<GIACLossRecoveries> getManualRecoveryList(
	public List<String> getManualRecoveryList(
			Map<String, Object> params) throws SQLException {
		// TODO Auto-generated method stub
		List<String> list = null;
		if (params.get("transactionType").equals("1")){
			list = (List<String>) this.getSqlMapClient().queryForList("getManualRecoveryList", params);
		}else if (params.get("transactionType").equals("2")){
			list = (List<String>) this.sqlMapClient.queryForList("getManualRecoveryList2", params);
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<String> checkPayorNameExist(Map<String, Object> params) throws SQLException{
		// TODO Auto-generated method stub
		List<String> list = null;
		if (params.get("transactionType").equals("1")){
			//list = (List<String>) this.getSqlMapClient().queryForList("getPayorNameLOV3", params);
			list = (List<String>) this.getSqlMapClient().queryForList("getPayorNameTranType1", params); //marco - 09.30.2014
		}else if (params.get("transactionType").equals("2")){
			list = (List<String>) this.sqlMapClient.queryForList("getPayorNameLOV4", params);
		}
		return list;
	}

	@Override
	public String checkCollectionAmt(Map<String, Object> params)
			throws SQLException {
		return (String)this.getSqlMapClient().queryForObject("checkCollectionAmt", params);
	}
}
