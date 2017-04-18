package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACOthFundOffCollnsDAO;
import com.geniisys.giac.entity.GIACOthFundOffCollns;
import com.geniisys.giac.exceptions.InvalidAegParametersException;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;

public class GIACOthFundOffCollnsDAOImpl implements GIACOthFundOffCollnsDAO {
	
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIACOthFundOffCollnsDAOImpl.class);
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<GIACOthFundOffCollns> getGIACOthFundOffCollns(Integer gaccTranId)
			throws SQLException {
		
		List<GIACOthFundOffCollns> giacothFundOffCollns = this.getSqlMapClient().queryForList("getGIACOthFundOffCollns", gaccTranId);
		log.info("Collections from Other Offices retrieved with gaccTranId = " + gaccTranId);
		return giacothFundOffCollns;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getTransactionNoListing(String keyword)throws SQLException {
		List<Map<String, Object>> tranNoList = this.getSqlMapClient().queryForList("getTransactionNoListing", keyword);
		return tranNoList;
	}

	@Override
	public Map<String, Object> checkOldItem(Map<String, Object> params) throws SQLException {
		Debug.print("Before: " + params);
		this.getSqlMapClient().queryForObject("checkOldItemNo", params);
		Debug.print("After: " + params);
		return params;
	}
	
	@Override
	public Map<String, Object> getDefaultAmount(Map<String, Object> params)
			throws SQLException {
		Debug.print("Before: " + params);
		this.getSqlMapClient().queryForObject("getDefaultAmount", params);
		Debug.print("After: " + params);
		return params;
	}
	
	@Override
	public Map<String, Object> chkGiacOthFundOffCol(Map<String, Object> params)
			throws SQLException {
		Debug.print("Check Giac_oth_fund_off Before: " + params);
		this.getSqlMapClient().queryForObject("chkGiacOthFundOffCol", params);
		Debug.print("Check Giac_oth_fund_off After: " + params);
		return params;
	}

	@Override
	public String saveGIACOthFundOffCollns(List<GIACOthFundOffCollns> setRows,
			List<GIACOthFundOffCollns> delRows, Map<String, Object> params) throws SQLException {
		String message = new String("");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
						
			/** delete record */
			this.getSqlMapClient().startBatch();
			this.delGIACOTHFundOffCollns(delRows);
			this.getSqlMapClient().executeBatch();
			
			/**insert record */
			this.getSqlMapClient().startBatch();
			this.setGIACOTHFundOffCollns(setRows);
			this.getSqlMapClient().executeBatch();
			
			/**GIACS012 Post-Forms-Commit*/
			System.out.println("post form params: " + params);
			if(setRows != null || delRows != null){
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().update("postFormsCommitGIACS012", params);
				this.getSqlMapClient().executeBatch();
			}
			System.out.println("post form params2: " + params);
			/**aeg_parameters*/
			this.getSqlMapClient().startBatch();
			Map<String,Object> aegParams = new HashMap<String, Object>();
			aegParams.put("gaccTranId", params.get("gaccTranId"));
			aegParams.put("moduleName", "GIACS012");
			aegParams.put("message", "");
			aegParams.put("globalBranchCd", params.get("globalBranchCd"));
			aegParams.put("globalFundCd", params.get("globalFundCd"));
			Debug.print("Before params: " + aegParams);
			this.getSqlMapClient().update("giacs012AegParameters",aegParams);
			Debug.print("After params: " + aegParams);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			message = "SUCCESS";
			
		}catch(SQLException e){
			log.info(e.getMessage());
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch(InvalidAegParametersException e){
			log.info(e.getMessage());
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
		}catch (Exception e) {
			log.info(e.getMessage());
			message = e.getMessage();
			this.getSqlMapClient().getCurrentConnection().rollback();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	
	private void setGIACOTHFundOffCollns(List<GIACOthFundOffCollns> setRows) throws SQLException{
		log.info("Saving GIAC_OTH_FUND_OFF_COLLNS record/s...");
		log.info("gacc_tran_id\tgibr_gfun_fund_cd\tgibr_branch\titem_no");
		log.info("============================================================================");
		
		if(setRows != null){
			for(GIACOthFundOffCollns othOffCollns : setRows){
				log.info(othOffCollns.getGaccTranId() + "\t\t" + othOffCollns.getGibrGfunFundCd() + "\t\t\t" +
						 othOffCollns.getGibrBranchCd()+ "\t\t" + othOffCollns.getItemNo());
				this.getSqlMapClient().insert("setGiacOthFundOffCollns", othOffCollns);
			}
		}
	}
	
	private void delGIACOTHFundOffCollns(List<GIACOthFundOffCollns> delRows) throws SQLException{
		log.info("Deleting GIAC_OTH_FUND_OFF_COLLNS record/s...");
		log.info("gacc_tran_id\tgibr_gfun_fund_cd\tgibr_branch\titem_no");
		log.info("============================================================================");
		
		if(delRows != null){
			for(GIACOthFundOffCollns othOffCollns : delRows){
				log.info(othOffCollns.getGaccTranId() + "\t\t" + othOffCollns.getGibrGfunFundCd() + "\t\t\t" +
						 othOffCollns.getGibrBranchCd()+ "\t\t" + othOffCollns.getItemNo());
				this.getSqlMapClient().delete("deleteGiacOthFundOffCollns", othOffCollns);
			}
			
		}
		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Integer> getItemNoList(int tranId) throws SQLException {
		return this.sqlMapClient.queryForList("getItemNoList", tranId);
	}
	
}
