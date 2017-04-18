/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */

package com.geniisys.gipi.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.gipi.dao.GIPIWPolicyWarrantyAndClauseDAO;
import com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause;
import com.geniisys.gipi.pack.entity.GIPIPackWarrantyAndClauses;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIPIWPolicyWarrantyAndClauseDAOImpl.
 */
public class GIPIWPolicyWarrantyAndClauseDAOImpl implements GIPIWPolicyWarrantyAndClauseDAO {

	/** The sql map client. */
	private SqlMapClient sqlMapClient;
	
	/** The log. */
	private static Logger log = Logger.getLogger(GIPIWPolicyWarrantyAndClauseDAOImpl.class);
	
	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolicyWarrantyAndClauseDAO#getGIPIWPolicyWarrantyAndClauses(java.lang.String, int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolicyWarrantyAndClause> getGIPIWPolicyWarrantyAndClauses(
			String lineCd, int parId) throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("lineCd", lineCd);
		param.put("parId", parId);

		log.info("DAO - Retrieving WPolicy - Warranty and Clause...");
		List<GIPIWPolicyWarrantyAndClause> list = getSqlMapClient().queryForList("getWPolWC", param);
		log.info("DAO - WPolicy - Warranty and Clause Size(): " + list.size());
		
		return list;
	}

	/**
	 * Sets the sql map client.
	 * 
	 * @param sqlMapClient the new sql map client
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	/**
	 * Gets the sql map client.
	 * 
	 * @return the sql map client
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolicyWarrantyAndClauseDAO#deleteWPolWC(java.lang.String, int, java.lang.String)
	 */
	@Override
	public boolean deleteWPolWC(String lineCd, int parId, String wcCd)
			throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("lineCd", lineCd);
		param.put("parId", parId);
		param.put("wcCd", wcCd);
		
		log.info("DAO - Deleting WPolicy - Warranty and Clause...");
		this.getSqlMapClient().delete("deleteWPolWC", param);
		log.info("DAO - WPolicy - Warranty and Clause deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolicyWarrantyAndClauseDAO#saveWPolWC(com.geniisys.gipi.entity.GIPIWPolicyWarrantyAndClause)
	 */
	@Override
	public boolean saveWPolWC(GIPIWPolicyWarrantyAndClause wc) 
			throws SQLException {
	
		log.info("DAO - Inserting WPolicy - Warranty and Clause...");
		this.getSqlMapClient().insert("saveWPolWC", wc);
		log.info("DAO - WPolicy - Warranty and Clause inserted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolicyWarrantyAndClauseDAO#deleteAllWPolWC(java.lang.String, int)
	 */
	@Override
	public boolean deleteAllWPolWC(String lineCd, int parId)
			throws SQLException {
		Map<String, Object> param = new HashMap<String, Object>();
		
		param.put("lineCd", lineCd);
		param.put("parId", parId);
		
		log.info("DAO - Deleting all WPolicy - Warranty and Clause... " + parId + " " + lineCd);
		this.sqlMapClient.delete("deleteAllWPolWC", param);
		log.info("DAO - All WPolicy - Warranty and Clause deleted.");
		
		return true;
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIWPolicyWarrantyAndClauseDAO#saveWPolWC(java.util.Map)
	 */
	@Override
	public boolean saveWPolWC(Map<String, Object> parameters)
			throws Exception {
		String[] wcCds 		 	= (String[]) parameters.get("wcCds");
		String[] printSeqNos 	= (String[]) parameters.get("printSeqNos");
		String[] wcTitles 		= (String[]) parameters.get("wcTitles");
		String[] wcText1 		= (String[]) parameters.get("wcText1");
		String[] wcText2 		= (String[]) parameters.get("wcText2");
		String[] wcText3 		= (String[]) parameters.get("wcText3");
		String[] wcText4 		= (String[]) parameters.get("wcText4");
		String[] wcText5 		= (String[]) parameters.get("wcText5");
		String[] wcText6 		= (String[]) parameters.get("wcText6");
		String[] wcText7 		= (String[]) parameters.get("wcText7");
		String[] wcText8 		= (String[]) parameters.get("wcText8");
		String[] wcText9 		= (String[]) parameters.get("wcText9");
		String[] printSws 		= (String[]) parameters.get("printSws");
		String[] changeTags 	= (String[]) parameters.get("changeTags");
		String[] wcTitles2 		= (String[]) parameters.get("wcTitles2");
		Integer parId 			= (Integer) parameters.get("parId");
		String lineCd 			= (String) parameters.get("lineCd");
		String userId			= (String) parameters.get("userId");
		
		Map<String, Object> deleteParams = new HashMap<String, Object>();
		
		deleteParams.put("lineCd", lineCd);
		deleteParams.put("parId", parId);
		
		try {
			getSqlMapClient().startTransaction();
			getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			getSqlMapClient().startBatch();
			
			getSqlMapClient().delete("deleteAllWPolWC", deleteParams);
			
			log.info("DAO - Inserting WPolicy - Warranties and Clauses in batch...");
			
			GIPIWPolicyWarrantyAndClause wc = null;
			
			if(wcCds != null){
				for (int i=0; i < wcCds.length; i++)	{
					wc = new GIPIWPolicyWarrantyAndClause();
					
					wc.setWcCd(wcCds[i]); 
					wc.setParId(parId);
					wc.setLineCd(lineCd);
					wc.setUserId(userId);
					wc.setWcTitle(wcTitles[i]); 
					wc.setWcTitle2(wcTitles2[i]/*.replaceAll("\"", "&quot;")*/); 
					if(changeTags[i].equals("Y")) {
					/*	wc.setWcText1(wcText1[i].replaceAll("\"", "&quot;"));
						wc.setWcText2(wcText2[i].replaceAll("\"", "&quot;"));
						wc.setWcText3(wcText3[i].replaceAll("\"", "&quot;"));
						wc.setWcText4(wcText4[i].replaceAll("\"", "&quot;"));
						wc.setWcText5(wcText5[i].replaceAll("\"", "&quot;"));
						wc.setWcText6(wcText6[i].replaceAll("\"", "&quot;"));
						wc.setWcText7(wcText7[i].replaceAll("\"", "&quot;"));
						wc.setWcText8(wcText8[i].replaceAll("\"", "&quot;"));
						wc.setWcText9(wcText9[i].replaceAll("\"", "&quot;"));*/
						System.out.println(wcText1[i]);
						wc.setWcText1(wcText1[i]);
						wc.setWcText2(wcText2[i]);
						wc.setWcText3(wcText3 == null ? "" : wcText3[i]);
						wc.setWcText4(wcText4 == null ? "" : wcText4[i]);
						wc.setWcText5(wcText5 == null ? "" : wcText5[i]);
						wc.setWcText6(wcText6 == null ? "" : wcText6[i]);
						wc.setWcText7(wcText7 == null ? "" : wcText7[i]);
						wc.setWcText8(wcText8 == null ? "" : wcText8[i]);
						wc.setWcText9(wcText9 == null ? "" : wcText9[i]);
					} else {
						wc.setWcText1(null);
						wc.setWcText2(null);
						wc.setWcText3(null);
						wc.setWcText4(null);
						wc.setWcText5(null);
						wc.setWcText6(null);
						wc.setWcText7(null);
						wc.setWcText8(null);
						wc.setWcText9(null);
					}					
					wc.setChangeTag(changeTags[i]);  
					wc.setPrintSw(printSws[i]); 
					wc.setPrintSeqNo(printSeqNos[i] == null ? 0 : Integer.parseInt(printSeqNos[i]));
					wc.setSwcSeqNo(0);
					
					getSqlMapClient().insert("saveWPolWC", wc);
				}			
			}
			
			getSqlMapClient().executeBatch();
			getSqlMapClient().getCurrentConnection().commit();
			
			log.info("DAO - WPolicy - Warranties and Clauses inserted in batch.");
		} catch (SQLException e) {
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
			getSqlMapClient().endTransaction();
		}
		 
		return true;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIWPolicyWarrantyAndClause> getAllWPolicyWCs(
			Map<String, Object> params) throws Exception {
		log.info("Getting all WC's for parId - "+params.get("parId"));
		return this.getSqlMapClient().queryForList("getWPolWC1", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackWarrantyAndClauses> getPolicyListWC(Integer packParId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getPackPolicyListWC", packParId);
	}

	@Override
	public void saveGIPIWPolWC(List<GIPIWPolicyWarrantyAndClause> setRows,
			List<GIPIWPolicyWarrantyAndClause> delRows) throws SQLException,
			Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			
			this.getSqlMapClient().startBatch();
			
			if(delRows != null){
				log.info("Deleting gipi_wpolwc: " + delRows.size());
				for(GIPIWPolicyWarrantyAndClause wc : delRows){
					Map<String, Object> wcParam = new HashMap<String, Object>();
					
					wcParam.put("lineCd", wc.getLineCd());
					wcParam.put("parId", wc.getParId());
					wcParam.put("wcCd", wc.getWcCd());
					
					this.getSqlMapClient().delete("deleteWPolWC", wcParam);
					this.getSqlMapClient().executeBatch();
				}
			}
			
			
			if(setRows != null){
				log.info("Saving gipi_wpolwc: " + setRows.size());
				for(GIPIWPolicyWarrantyAndClause wc : setRows){
					this.getSqlMapClient().insert("saveWPolWC", wc);
					this.getSqlMapClient().executeBatch();
				}
			}
						
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("GIPI_WPolWC entry successfully saved.");
		
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}catch(Exception e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public void deleteGIPIWPolWCTableGrid(Map<String, Object> parameters) //added by steven 4.30.2012
			throws SQLException {
			log.info("DAO: Deleting Policy Warranty Clause/s...");
			this.getSqlMapClient().delete("deleteWPolWC", parameters);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveGIPIWPolWCTableGrid(Map<String, Object> parameters) //added by steven 4.30.2012
			throws SQLException {
		List<GIPIWPolicyWarrantyAndClause> delParams =  (List<GIPIWPolicyWarrantyAndClause>) parameters.get("delParams");
		List<GIPIWPolicyWarrantyAndClause> insParams =  (List<GIPIWPolicyWarrantyAndClause>) parameters.get("insParams");
		String userId = (String) parameters.get("userId");
		
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			if(delParams != null){
				Map<String, Object> params =new HashMap<String, Object>();
				for(GIPIWPolicyWarrantyAndClause polWC: delParams){
					params.put("lineCd", polWC.getLineCd());
					params.put("parId", polWC.getParId());
					params.put("wcCd", polWC.getWcCd());
					params.put("userId", userId);
					this.deleteGIPIWPolWCTableGrid(params);
				}
			}
			
			if(insParams != null){
				for(GIPIWPolicyWarrantyAndClause polWC: insParams){
					if("N".equals(polWC.getChangeTag()) || "".equals(polWC.getChangeTag())){
						polWC.setWcText1(""); // added by: Nica 06.29.2012 - to set warranty text to null if changeTag = N
					    polWC.setWcText2("");
						polWC.setWcText3("");
						polWC.setWcText4("");
						polWC.setWcText5("");
						polWC.setWcText6("");
						polWC.setWcText7("");
						polWC.setWcText8("");
						polWC.setWcText9("");
						polWC.setWcText10("");
						polWC.setWcText11("");
						polWC.setWcText12("");
						polWC.setWcText13("");
						polWC.setWcText14("");
						polWC.setWcText15("");
						polWC.setWcText16("");
						polWC.setWcText17("");
					}
					polWC.setUserId(userId); // added by: Nica 07.05.2012
					//this.getSqlMapClient().insert("saveWPolWC", polWC);
					//SR-14717
					this.getSqlMapClient().insert("saveWPolWC2", polWC);
				}
					log.info("DAO - Policy Warranty Clause/s inserted");
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Updating Policy Warranty Clause/s successful.");
		} catch (SQLException e){
			this.getSqlMapClient().getCurrentConnection().rollback();
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			throw e;
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public String validatePrintSeqNo(Map<String, Object> parameters)
			throws SQLException {
		System.out.println("Validating Print Seq. No.: " + parameters.get("printSeqNo"));
		return (String) this.sqlMapClient.queryForObject("validatePrintSeqNo",parameters);
	}

	@Override
	public String checkExistingRecord(Map<String, Object> parameters)
			throws SQLException {
		return (String) this.sqlMapClient.queryForObject("checkExistingRecord",parameters);
	}
}
