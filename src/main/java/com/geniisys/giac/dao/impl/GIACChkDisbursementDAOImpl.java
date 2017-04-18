/**************************************************/
/**
	Project: GeniisysDevt
	Package: com.geniisys.giac.dao.impl
	File Name: GIACChkDisbursementDAOImpl.java
	Author: Computer Professional Inc
	Created By: Irwin
	Created Date: Jun 19, 2012
	Description: 
*/


package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.framework.util.FormInputUtil;
import com.geniisys.giac.dao.GIACChkDisbursementDAO;
import com.geniisys.giac.entity.GIACChkDisbursement;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIACChkDisbursementDAOImpl implements GIACChkDisbursementDAO {
	private static Logger log = Logger.getLogger(GIACChkDisbursementDAOImpl.class);
	@Override
	public GIACChkDisbursement getGiacs016ChkDisbursement(Integer gaccTranId)
			throws SQLException {
		log.info("RETRIEVING GIAC_CHK_DISBURSEMENT INFO");
		return (GIACChkDisbursement) getSqlMapClient().queryForObject("getGiacs016ChkDisbursement", gaccTranId);
	}
	@Override
	public GIACChkDisbursement getGiacs002ChkDisbursement(Map<String, Object> params) throws SQLException {
		log.info("Retrieving Check Disbursement information...");
		return (GIACChkDisbursement) this.getSqlMapClient().queryForObject("getGIACS002ChkDisbursementInfo", params);
	}
	
	private SqlMapClient sqlMapClient;
	
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}
	@SuppressWarnings("unchecked")
	@Override
	public String saveCheckDisbursement(Map<String, Object> allParams) throws SQLException, Exception {
		String message = "SUCCESS";
				
		List<GIACChkDisbursement> setRows = (List<GIACChkDisbursement>) allParams.get("setRows");
		List<GIACChkDisbursement> delRows = (List<GIACChkDisbursement>) allParams.get("delRows");
		
		//SimpleDateFormat sdf = new SimpleDateFormat("MM-dd-yyyy");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DAO - Start of saving check disbursements...");			
			
			
			for(GIACChkDisbursement del : delRows){
				log.info("DELETING: " + del);
				/*Map<String, Object> delParams = new HashMap<String, Object>();
				delParams.put("gaccTranId", del.getGaccTranId());
				delParams.put("itemNo", del.getItemNo());*/
				
				if(allParams.get("dvTag") == "M"){
					Map<String, Object> delParams = new HashMap<String, Object>();
					delParams.put("fundCd", allParams.get("gibrGfunFundCd"));
					delParams.put("branchCd", allParams.get("gibrBranchCd"));
					delParams.put("bankCd", del.getBankCd());
					delParams.put("bankAcctCd", del.getBankAcctCd());
					delParams.put("checkPrefSuf", del.getCheckPrefSuf());
					
					log.info("Updating giac_check_no...");
					this.getSqlMapClient().update("valBeforeDelManualCheck", delParams);
					log.info("Updating giac_check_no done.");
				}
				
				this.getSqlMapClient().delete("deleteCheckDisb", del);
			}
			this.getSqlMapClient().executeBatch();
			
			for(GIACChkDisbursement set : setRows) {
				System.out.println("gaccTranId: "+set.getGaccTranId());
				Map<String, Object> paramee = new HashMap<String, Object>();
				paramee.putAll(FormInputUtil.formMapFromEntity(set));
				System.out.println("paramee: " + paramee);
				//System.out.println("checkdate: " + set.getCheckDate());
				
				//sdf.parse(str);
				
				//System.out.println("new checkdate: " + set.getCheckDate());
				log.info("INSERTING: " + set);
				this.getSqlMapClient().insert("setCheckDisb", set);

				if(allParams.get("dvTag").equals("M") && !(set.getCheckNo().equals(null) || set.getCheckNo().equals(""))){
					log.info("Updating giac_check_no (If Manual)...");
					Map<String, Object> updateParams = new HashMap<String, Object>();
					updateParams.put("fundCd", allParams.get("gibrGfunFundCd"));
					updateParams.put("branchCd", allParams.get("gibrBranchCd"));
					updateParams.put("checkNo", set.getCheckNo());
					updateParams.put("bankCd", set.getBankCd());
					updateParams.put("bankAcctCd", set.getBankAcctCd());
					updateParams.put("checkPrefSuf", set.getCheckPrefSuf());
					
					System.out.println("updateParams: "+updateParams);
					this.getSqlMapClient().queryForObject("updateGIACCheckNo", updateParams);
					log.info("Updating giac_check_no done.");
				}
			}
			this.getSqlMapClient().executeBatch();
			
			System.out.println("gaccTranID: "+allParams.get("gaccTranId")+"\tmoduleId: "+allParams.get("moduleId") +"\tfundCd: "+allParams.get("gibrGfunFundCd") +"\tbranchCD: "+allParams.get("gibrBranchCd"));
			// 4. do post-forms commit
			log.info("Executing Post-Forms-Commit...");
			this.getSqlMapClient().update("doPostFormsCommitGIACS002", allParams);
			log.info("Post-Forms-Commit done.");
			
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("DAO - End of saving check disbursements.");
			this.getSqlMapClient().endTransaction();
		}
		
		return message;
	}
	@Override
	public Map<String, Object> spoilCheck(Map<String, Object> params) throws SQLException, Exception {
		Map<String, Object> params1 = new HashMap<String, Object>(params);
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("params to spoil: " + params1);
			log.info("DAO - Start of spoiling check...");
			this.getSqlMapClient().queryForObject("giacs002SpoilCheck", params1);
			
			System.out.println("params1 returned: " + params1);
			
			//test lang 5.25.2013
			System.out.println("params for post-forms-coomit: "+params);
			// 4. do post-forms commit
			log.info("Executing Post-Forms-Commit...");
			this.getSqlMapClient().update("doPostFormsCommitGIACS002", params);
			log.info("Post-Forms-Commit done.");
			
			
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("DAO - End of spoiling check.");
			this.getSqlMapClient().endTransaction();
		}
		return params1;
	}
	
	@Override
	public Integer getCheckCount(Integer gaccTranId) throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getCheckCount", gaccTranId);
	}
	
	@Override
	public String validateCheckNo(Map<String, Object> params) throws SQLException, Exception {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("params to validate check no: " + params);
			log.info("DAO - Start of validating check number...");
			this.getSqlMapClient().queryForObject("validateCheckNo", params);
			
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("DAO - End of validating check number.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	@Override
	public String validateBankCd(Map<String, Object> params) throws SQLException, Exception {
		String message = "SUCCESS";
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			System.out.println("params to validate bank code: " + params);
			log.info("DAO - Start of validating bank code...");
			this.getSqlMapClient().queryForObject("validateBankCd", params);
			
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		} finally {
			log.info("DAO - End of validating bank code.");
			this.getSqlMapClient().endTransaction();
		}
		return message;
	}
	@Override
	public void giacs052NewFormInstance(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("giacs052NewFormInstance", params);
	}
	@Override
	public void getGiacs052DefaultCheck(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("getGiacs052DefaultCheck", params);
	}
	@Override
	public void giacs052ProcessAfterPrinting(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			log.info("DAO - Proccess after printing...");
			this.getSqlMapClient().update("giacs052ProcessAfterPrinting", params);
						
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public void giacs052UpdateGiac(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().update("giacs052UpdateGiac", params);
						
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public void giacs052SpoilCheck(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().update("giacs052SpoilCheck", params);
						
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public void giacs052RestoreCheck(Map<String, Object> params)
			throws SQLException {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().update("giacs052RestoreCheck", params);
						
			this.getSqlMapClient().getCurrentConnection().commit();			
		} catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public List<String> getDBItemNoList(Map<String, Object> params) throws SQLException {
		List<String> itemNoList = null;
		
		log.info("Retrieving current list of itemNo...");
		System.out.println("params: "+params);
		itemNoList = this.getSqlMapClient().queryForList("getDBItemNoList", params);
		log.info("Retrieving current list of itemNo done.");
		
		System.out.println("itemNoList retrieved: "+itemNoList);
		return itemNoList;		
	}
	@Override
	public void giacs052CheckDupOr(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("giacs052CheckDupOr", params);
	}
	@Override
	public Map<String, Object> setCmDmPrintBtn(Map<String, Object> params)
			throws SQLException, Exception {
		this.getSqlMapClient().update("giacs052SetCmDmPrintBtn", params);
		return params;
	}
	@Override
	public Map<String, Object> generateCheck(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("generateCheck", params);
			this.getSqlMapClient().executeBatch();
			return params;
		}catch(SQLException e){
			e.printStackTrace();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public void validateSpoilCheck(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().update("validateSpoilCheck", params);
			this.getSqlMapClient().executeBatch();
		}catch(SQLException e){
			e.printStackTrace();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@SuppressWarnings("unchecked")
	@Override
	public void spoilCheckGIACS054(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> row = (Map<String, Object>) params.get("row");
			row.put("userId", params.get("userId"));
			row.put("checkDvPrint", params.get("checkDvPrint"));
			
			this.getSqlMapClient().update("spoilCheckGIACS054", row);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public Integer getCheckSeqNo(Map<String, Object> params)
			throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getCheckSeqNo", params);
	}
	@SuppressWarnings("unchecked")
	@Override
	public void processPrintedChecks(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			Integer maxCheckSeqNo = 1;
			
			for(Map<String, Object> row : rows){
				if(maxCheckSeqNo < Integer.parseInt(row.get("checkNo").toString())){
					maxCheckSeqNo = Integer.parseInt(row.get("checkNo").toString());
				}
				
				row.put("fundCd", params.get("fundCd"));
				row.put("branchCd", params.get("branchCd"));
				row.put("userId", params.get("userId"));
				row.put("checkDvPrint", params.get("checkDvPrint"));
				this.getSqlMapClient().update("processPrintedChecks", row);
				this.getSqlMapClient().executeBatch();
			}
			
			params.put("maxCheckSeqNo", maxCheckSeqNo);
			this.getSqlMapClient().update("updateCheckSeqNo", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@SuppressWarnings("unchecked")
	@Override
	public void updatePrintedChecks(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			List<Map<String, Object>> rows = (List<Map<String, Object>>) params.get("rows");
			Integer maxCheckSeqNo = 1;
			
			for(Map<String, Object> row : rows){
				if(Integer.parseInt(row.get("checkNo").toString()) <= Integer.parseInt(params.get("lastCheckNo").toString())){
					if(maxCheckSeqNo < Integer.parseInt(row.get("checkNo").toString())){
						maxCheckSeqNo = Integer.parseInt(row.get("checkNo").toString());
					}
					
					row.put("userId", params.get("userId"));
					row.put("checkDvPrint", params.get("checkDvPrint"));
					this.getSqlMapClient().update("updatePrintedChecks", row);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			params.put("maxCheckSeqNo", params.get("lastCheckNo"));
			this.getSqlMapClient().update("updateCheckSeqNo", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
	@Override
	public void validateCheckSeqNo(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().update("validateCheckSeqNo", params);
		}catch(SQLException e){
			throw e;
		}
	}
	@Override
	public String checkDVPrintColumn(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkDVPrintColumn",params);
	}
	
	@SuppressWarnings("unchecked")
	public List<Map<String, Object>> getCheckBatchListByParam(Map<String, Object> params) throws SQLException{
		return this.getSqlMapClient().queryForList("getCheckBatchListByParam", params);
	}
	/*added by MarkS 5.24.2016 SR-5484 */
	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>>  getCmDmTranIdMemoStat(Integer gaccTranId) throws SQLException, Exception {
		return this.getSqlMapClient().queryForList("giacs052GetCmDmTranIdMemoStat", gaccTranId);
	}
	 /*END  SR-5484 */
}
