package com.geniisys.gipi.pack.dao.impl;

import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.pack.dao.GIPIPackQuoteDAO;
import com.geniisys.gipi.pack.entity.GIPIPackQuote;
import com.geniisys.gipi.util.FileUtil;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.Debug;

public class GIPIPackQuoteDAOImpl implements GIPIPackQuoteDAO {

	private Logger log = Logger.getLogger(GIPIPackQuoteDAOImpl.class);
	private SqlMapClient sqlMapClient;
	
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackQuote> getQuoteListFromIssCd(String lineCd,String issCd, String keyWord, String userId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("lineCd", lineCd);
		param.put("issCd", issCd);
		param.put("keyWord", keyWord);
		param.put("userId", userId);
		return this.getSqlMapClient().queryForList("getPackQuoteListFromIssCd", param);
	}

	@Override
	public void updateGipiPackQuote(int quoteId) throws SQLException {
		log.info("Update pack quote status of quotation id " + quoteId);
		this.getSqlMapClient().update("updateGipiPackQuote", quoteId);
	}

	@Override
	public void returnPackParToQuotation(Map<String, Object>params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("RETURING PACK PAR TO QUOTATION. . .PACK QUOTE ID"+params.get("packParId"));
			this.getSqlMapClient().update("returnPackParToquotation",params);
			
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

	@SuppressWarnings("unchecked")
	public List<GIPIPackQuote> getPackQuotationListing(
			Map<String, Object> params) throws SQLException {
		Debug.print(params);
		log.info("GETTING GIPI PACK QUOTATION LISTING...");
		return this.getSqlMapClient().queryForList("getPackQuotationListing", params);
	}

	@Override
	public GIPIPackQuote getGIPIPacKQuoteDetails(Integer packQuoteId)
			throws SQLException {
		log.info("GETTING DETAILS FOR PACK QUOTE ID: "+packQuoteId);
		return (GIPIPackQuote) this.getSqlMapClient().queryForObject("getGIPIPacKQuoteDetails", packQuoteId);
	}

	@Override
	public Integer getNewPackQuoteId() throws SQLException {
		log.info("GENERATING NEW PACK QUOTE ID..");
		return (Integer) this.getSqlMapClient().queryForObject("getNewPackQuoteId");
	}

	@Override
	public GIPIPackQuote saveGipiPackQuote(GIPIPackQuote gipiPackQuote)
			throws SQLException {
		try{
			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();
		
			BigDecimal alteredShortRate = gipiPackQuote.getShortRatePercent();
//	README: **********DO NOT ERASE*********************************************************		
//			 THE ADDITIONAL "1" SOLVES THE #E-9 INCONSISTENCY DURING IBATIS CONVERSION 
//			 it prevents ibatis from translating 0.000000000 to decimal notation (0E-9)
//			 ex:	------------ CASE 1 -----------------
//					-start--> 	value = 0.000000000   
//					-ibatis-> 	value = 0E-9   
//			      -sql----> 	ERROR
//					------------ CASE 2 -----------------
//			      -start--> 	value = 1.000000000	  
//					-ibatis->  	value = 1 			(did not convert to decimal notation)
//					-sql----> 	value = #1# -1 		(before executing SELECT)
//					-sql---->   value = 0 			(while executing SELECT)
//					-sql---->   SUCCESS

			alteredShortRate = alteredShortRate.add(new BigDecimal("1.0000")).setScale(9, BigDecimal.ROUND_HALF_UP);
			gipiPackQuote.setShortRatePercent(alteredShortRate);			
			log.info("SAVING PACK QUOTATION FOR: "+gipiPackQuote.getPackQuoteId());
			this.getSqlMapClient().insert("saveGIPIPackQuote", gipiPackQuote);
			// after the saving, get the full details.
			gipiPackQuote = this.getGIPIPacKQuoteDetails(gipiPackQuote.getPackQuoteId());
			
			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.sqlMapClient.getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.sqlMapClient.getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.sqlMapClient.endTransaction();
			System.out.println("Quotation Pack has been successfuly save");
		}
		return gipiPackQuote;
	}

	@Override
	public void deletePackQuotation(Map<String, Object> params) throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			// get pack quote attachments
			List<String> files = this.getSqlMapClient().queryForList("getPackQuoteAttachments", params);
			
			log.info("DELETING PACK QUOTATION: "+params.get("packQuoteId"));
			this.getSqlMapClient().delete("deletePackQuotation",params);
			
			// delete files
			FileUtil.deleteFiles(files);
			
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
	public void denyPackQuotation(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DENYING PACK QUOTATION: "+params.get("packQuoteId"));
			log.info("REASON CODE: "+params.get("reasonCd"));
			this.getSqlMapClient().delete("denyPackQuotation",params);
			
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
	public String copyPackQuotation(Map<String, Object> params)
			throws SQLException {
		String quoteNo = null;
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("COPYING PACK QUOTATION: "+params.get("packQuoteId"));
			
			params.put("quoteNo", quoteNo);
			this.getSqlMapClient().update("copyPackQuotation",params);
			quoteNo = (String) params.get("quoteNo");
			log.info("NEW QUOTATION NO:"+quoteNo);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return quoteNo;
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
	public String duplicatePackQuotation(Map<String, Object> params)
			throws SQLException {
		String quoteNo = null;
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("DUPLICATING PACK QUOTATION: "+params.get("packQuoteId"));
			
			params.put("quoteNo", quoteNo);
			this.getSqlMapClient().update("duplicatePackQuotation",params);
			quoteNo = (String) params.get("quoteNo");
			log.info("NEW QUOTATION NO:"+quoteNo);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return quoteNo;
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
	public Map<String, Object> generatePackBankRefNo(Map<String, Object> params)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			log.info("GENERATING BANK REF NO FOR PACK QUOTE ID: "+params.get("packQuoteId"));
			
			this.getSqlMapClient().update("generatePackBankRefNo",params);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return params;
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
	public String getExistMessagePack(Map<String, Object> params)
			throws SQLException {
		log.info("CHECKING IF ASSURED ALREADY EXISINT: "+params);
		return (String) getSqlMapClient().queryForObject("getExistMessagePack",params);
	}

	@Override
	public String checkOra2010Sw() throws SQLException {
		log.info("Checking ORA2010_SW...");
		return (String) this.getSqlMapClient().queryForObject("checkOra2010Sw");
	}

}