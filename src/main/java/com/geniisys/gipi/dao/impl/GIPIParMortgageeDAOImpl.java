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

import com.geniisys.gipi.dao.GIPIParMortgageeDAO;
import com.geniisys.gipi.entity.GIPIParMortgagee;
import com.geniisys.gipi.pack.entity.GIPIPackMortgagee;
import com.ibatis.sqlmap.client.SqlMapClient;
import com.seer.framework.util.StringFormatter;


/**
 * The Class GIPIParMortgageeDAOImpl.
 */
public class GIPIParMortgageeDAOImpl implements GIPIParMortgageeDAO{

	/** The log. */
	private Logger log = Logger.getLogger(GIPIParMortgageeDAOImpl.class);
	
	/** The sql map client. */
	private SqlMapClient sqlMapClient;	
	
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
	 * @see com.geniisys.gipi.dao.GIPIParMortgageeDAO#deleteGIPIParMortgagee(int, int)
	 */
	@Override
	public void deleteGIPIParMortgagee(int parId, int itemNo)
			throws SQLException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parId", parId);
		params.put("itemNo", itemNo);
		this.getSqlMapClient().delete("deleteGIPIParMortItem", params);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParMortgageeDAO#getGIPIParMortgagee(int)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIParMortgagee> getGIPIParMortgagee(int parId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getGIPIParMortgagee", parId);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParMortgageeDAO#saveGIPIParMortgagee(com.geniisys.gipi.entity.GIPIParMortgagee)
	 */
	@Override
	public void saveGIPIParMortgagee(GIPIParMortgagee gipiParMortgagee)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIPIParMortgagee", gipiParMortgagee);
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParMortgageeDAO#deleteGIPIParMortgagee(int)
	 */
	@Override
	public void deleteGIPIParMortgagee(int parId) throws SQLException {
		this.getSqlMapClient().delete("deleteGIPIParMort", parId);		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParMortgageeDAO#setGIPIParMortgagee(java.util.List)
	 */
	@Override
	public void setGIPIParMortgagee(List<GIPIParMortgagee> gipiParMortgagee)
			throws SQLException {
		log.info("DAO Calling setGIPIParMortgagee...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Saving Record/s: ");
			System.out.println("ParID\tItemNo\tIssCd\tMortgCd\tAmount\tRemarks\tUser");
			System.out.println("=======================================================================================");
			for(GIPIParMortgagee m : gipiParMortgagee){
				System.out.println(m.getParId() + "\t" + m.getItemNo() + "\t" +
									m.getIssCd() + "\t" + m.getMortgCd() + "\t" + m.getAmount() + "\t" +
									m.getRemarks() + "\t" + m.getUserId());
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are committed!");
		
	}

	/* (non-Javadoc)
	 * @see com.geniisys.gipi.dao.GIPIParMortgageeDAO#delGIPIParMortgagee(java.util.List)
	 */
	@Override
	public void delGIPIParMortgagee(List<GIPIParMortgagee> gipiParMortgagee)
			throws SQLException {
		log.info("DAO calling delGIPIParMortgagee...");
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().startBatch();
			
			System.out.println("Deleting Record/s: ");
			System.out.println("ParID\tItemNo\tIssCd\tMortgCd\tAmount\tRemarks\tUser");
			System.out.println("=======================================================================================");
			for(GIPIParMortgagee m : gipiParMortgagee){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("parId", m.getParId());
				params.put("itemNo", m.getItemNo());
				params.put("mortgCd", m.getMortgCd());
				
				System.out.println(m.getParId() + "\t" + m.getItemNo() + "\t" +
									m.getIssCd() + "\t" + m.getMortgCd() + "\t" + m.getAmount() + "\t" +
									m.getRemarks() + "\t" + m.getUserId());
				this.getSqlMapClient().delete("delGIPIParMortgagee", params);
			}
			System.out.println("=======================================================================================");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().commitTransaction();
		}finally{
			this.getSqlMapClient().endTransaction();
		}
		System.out.println("Record/s are successfully deleted and committed!");		
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIParMortgagee> getGIPIWMortgageeByItemNo(
			Map<String, Integer> params) throws SQLException {
		log.info("Getting mortgageees by item_no ...");
		return this.getSqlMapClient().queryForList("getGIPIWMortgageeByItemNo", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIPackMortgagee> getPackParMortgagees(Integer packParId)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getSubPoliciesMortgagees", packParId);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIPIParMortgagee> getGIPIWMortgagee(Integer parId)
			throws SQLException {
		log.info("Getting all mortgagees ...");	//changed to escapeHTMLInList4 Gzelle 02042015
		return (List<GIPIParMortgagee>) StringFormatter.escapeHTMLInList4(this.getSqlMapClient().queryForList("getGIPIWMortgagee", parId));
	}

	@SuppressWarnings("unchecked")
	@Override
	public void saveMortgagee(Map<String, Object> params) throws SQLException {
		log.info("Saving gipi_wmortgagee ...");
		
		// mortgagees
		List<GIPIParMortgagee> insMortgagees	= (List<GIPIParMortgagee>) params.get("setMortgagees");
		List<Map<String, Object>> delMortgagees	= (List<Map<String, Object>>) params.get("delMortgagees");
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			// GIPI_WMORTGAGEE (delete)
			for(Map<String, Object> delMap : delMortgagees){
				log.info("Deleting record on gipi_wmortgagee ...");
				this.getSqlMapClient().delete("delGIPIParMortgagee", delMap);
			}
			
			// GIPI_WMORTGAGEE (insert/update)
			for(GIPIParMortgagee m : insMortgagees){
				log.info("Inserting/Updating record on gipi_wmortgagee ...");
				this.getSqlMapClient().insert("setGIPIParMortgagee", m);
				System.out.println("Remarks : " + m.getRemarks());
			}
			
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}
}
