/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.json.JSONObject;

import com.geniisys.gipi.dao.GIPIQuoteWarrantyAndClauseDAO;
import com.geniisys.gipi.entity.GIPIQuote;
import com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIQuoteWarrantyAndClauseDAOImpl.
 */
public class GIPIQuoteWarrantyAndClauseDAOImpl implements GIPIQuoteWarrantyAndClauseDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	private static Logger log = Logger.getLogger(GIPIQuoteWarrantyAndClauseDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteWarrantyAndClauseDAO#getGIPIQuoteWarrantyAndClauses(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteWarrantyAndClause> getGIPIQuoteWarrantyAndClauses(int quoteId) throws SQLException{
		//emsy 11.18.2011 return getSqlMapClient().queryForList("getQuoteWC", quoteId);
		return getSqlMapClient().queryForList("getQuoteWarrCla",quoteId);
	}

	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteWarrantyAndClauseDAO#saveWC(com.geniisys.gipi.entity.GIPIQuoteWarrantyAndClause)
	 */
	@Override
	public void saveWC(GIPIQuoteWarrantyAndClause wc) throws SQLException {
		try{
			/*
			 * added transaction - irwin 11.29.11
			 * */
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println("WC Text: " + wc.getWcText());
			log.info("Saving WC..");
			this.getSqlMapClient().insert("saveWC", wc);
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}	
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIQuoteWarrantyAndClauseDAO#deleteWC(int)
	 */
	@Override
	public void deleteWC(int quoteId) throws SQLException {
		try{
			/*
			 * added transaction - irwin 11.29.11
			 * */
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("quoteId", quoteId);
			//params.put("wcCd", wcCd);
			log.info("Deleting Warranties and clauses");
			this.getSqlMapClient().delete("deleteWC", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public void attachWarranty(int quoteId, String lineCd, int perilCd)
			throws SQLException {
		try {
			log.info("DAO - Attaching warranties of peril: " + quoteId + " - " + lineCd + " - " + perilCd);
			
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			Map<String, Object> quoteInfo = new HashMap<String, Object>();
			quoteInfo.put("quoteId", quoteId);
			quoteInfo.put("lineCd", lineCd);
			quoteInfo.put("perilCd", perilCd);
			this.getSqlMapClient().update("attachWarranty", quoteInfo);
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("DAO - Warranties Attached...");
		}catch(SQLException s){
			s.printStackTrace();
			log.error(s.getStackTrace());
		}catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
		}finally{
			this.getSqlMapClient().endTransaction();
		}		
		
	}

	@Override
	public String checkQuotePerilDefaultWarranty(Integer quoteId,
			String lineCd, Integer perilCd) throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("quoteId", quoteId);
		params.put("lineCd", lineCd);
		params.put("perilCd", perilCd);
		String wcSw = (String) this.getSqlMapClient().queryForObject("checkQuotePerilDefaultWarranty", params);
		return wcSw;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIQuoteWarrantyAndClause> getPackQuotationWarrantiesAndClauses(
			Integer packQuoteId) throws SQLException {
		List<GIPIQuote> packQuoteList = this.getSqlMapClient().queryForList("getGipiPackQuoteList", packQuoteId);
		List<GIPIQuoteWarrantyAndClause> packQuoteWCList = new ArrayList<GIPIQuoteWarrantyAndClause>();
		
		for(GIPIQuote quote : packQuoteList){
			List<GIPIQuoteWarrantyAndClause> quoteWCs = this.getSqlMapClient().queryForList("getQuoteWarrCla", quote.getQuoteId());
			for(GIPIQuoteWarrantyAndClause wc : quoteWCs){
				packQuoteWCList.add(wc);
			}
		}
		return packQuoteWCList;
	}

	@Override
	public void savePackQuotationWarrantiesAndClauses(List<GIPIQuoteWarrantyAndClause> setRows, 
			List<GIPIQuoteWarrantyAndClause> delRows, String userId) throws SQLException {
		
		Map<String, Object> params = new HashMap<String, Object>();
		if(delRows != null){
			for(GIPIQuoteWarrantyAndClause delWC : delRows){
				this.getSqlMapClient().startBatch();
				params.clear();
				params.put("quoteId", delWC.getQuoteId());
				params.put("wcCd", delWC.getWcCd());
				this.getSqlMapClient().delete("deleteQuoteWC", params);
				this.getSqlMapClient().executeBatch();
			}
		}
		
		if(setRows != null){
			for(GIPIQuoteWarrantyAndClause setWC : setRows){
				setWC.setUserId(userId);
				this.getSqlMapClient().startBatch();
				this.getSqlMapClient().insert("setQuoteWarrClause", setWC);
				this.getSqlMapClient().executeBatch();
			}
		}
		
	}

	@Override
	public void saveGIPIQuoteWc(Map<String, List<GIPIQuoteWarrantyAndClause>> params)
			throws SQLException { // Udel - 03262012 - Added new method for saving (compatible with JSON and tableGrid implementation)
		List<GIPIQuoteWarrantyAndClause> setQuoteWarrClaList = params.get("setQuoteWarrCla");
		List<GIPIQuoteWarrantyAndClause> delQuoteWarrClaList = params.get("delQuoteWarrCla");
		
		try {
			log.info("Starting transaction...");
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(!delQuoteWarrClaList.isEmpty()){
				log.info("Deleting Quotation Warranties and Clauses...");
				for (GIPIQuoteWarrantyAndClause wc : delQuoteWarrClaList){
					log.info("Deleting Record: "+(new JSONObject(wc)).toString());
					Map<String, Object> rec = new HashMap<String, Object>();
					rec.put("quoteId", wc.getQuoteId());
					rec.put("wcCd", wc.getWcCd());
					this.getSqlMapClient().delete("deleteQuoteWC", rec);
				}
				log.info("Finished deleting records.");
			}
			
			if (!setQuoteWarrClaList.isEmpty()){
				log.info("Saving Quotation Warranties and Clauses...");
				for (GIPIQuoteWarrantyAndClause wc : setQuoteWarrClaList){
					log.info("Saving Record: "+(new JSONObject(wc)).toString());
					if("N".equals(wc.getChangeTag()) || "".equals(wc.getChangeTag())){
						wc.setWcText(""); // added by: Nica 07.16.2012 - to set warranty text to null if changeTag = N
						wc.setWcText1("");
						wc.setWcText2("");
						wc.setWcText3("");
						wc.setWcText4("");
						wc.setWcText5("");
						wc.setWcText6("");
						wc.setWcText7("");
						wc.setWcText8("");
						wc.setWcText9("");
						wc.setWcText10("");
						wc.setWcText11("");
						wc.setWcText12("");
						wc.setWcText13("");
						wc.setWcText14("");
						wc.setWcText15("");
						wc.setWcText16("");
						wc.setWcText17("");
					}
					this.getSqlMapClient().insert("setQuoteWarrClause", wc);
				}
				log.info("Finished inserting/updating records.");
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Transaction commited, finished.");
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error(e.getStackTrace());
		} catch (Exception e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw new SQLException();
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String validatePrintSeqNo(Map<String, Object> parameters)
			throws SQLException {
		System.out.println("Validating Print Seq. No.: " + parameters.get("printSeqNo"));
		return (String) this.getSqlMapClient().queryForObject("validatePrintSeqNo2",parameters);
	}
}
