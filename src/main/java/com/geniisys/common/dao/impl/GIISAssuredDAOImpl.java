/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.dao.impl;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.common.dao.GIISAssuredDAO;
import com.geniisys.common.entity.GIISAssured;
import com.geniisys.common.entity.GIISAssuredIndividualInformation;
import com.geniisys.common.entity.GIISGroup;
import com.geniisys.common.entity.GIISIntermediary;
import com.geniisys.framework.util.Debug;
import com.ibatis.sqlmap.client.SqlMapClient;


/**
 * The Class GIISAssuredDAOImpl.
 */
public class GIISAssuredDAOImpl implements GIISAssuredDAO {
	private static Logger log = Logger.getLogger(GIISAssuredDAOImpl.class);
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
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getGIISAssuredByAssdNo(java.lang.Integer)
	 */
	@Override
	public GIISAssured getGIISAssuredByAssdNo(Integer assdNo)
			throws SQLException {
		return (GIISAssured) sqlMapClient.queryForObject("getGIISAssuredByAssdNo", assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getAssuredList(java.lang.String)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISAssured> getAssuredList(String keyword) throws SQLException {		
		return getSqlMapClient().queryForList("getAssuredList", keyword);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#deleteAssured(com.geniisys.common.entity.GIISAssured)
	 */
	@Override
	public void deleteAssured(GIISAssured assured) throws SQLException {
		this.getSqlMapClient().delete("deleteAssured", assured);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#saveAssured(com.geniisys.common.entity.GIISAssured)
	 */
	@Override
	public void saveAssured(GIISAssured assured) throws SQLException {
		
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			System.out.println(assured.getAssdName());
			System.out.println(assured.getAssdName().length());
			this.getSqlMapClient().insert("saveAssured", assured);
			this.getSqlMapClient().executeBatch();
			
			if(assured.getCorporateTag().equals("I")){
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assdNo", assured.getAssdNo());
				params.put("emailAddr", assured.getEmailAddress());
				params.put("birthDate", assured.getBirthDate());
				params.put("birthMonth", assured.getBirthMonth());
				params.put("birthYear", assured.getBirthYear());
				this.getSqlMapClient().insert("copyIndividualInfo", params);
			}
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
		}catch(Exception e){
			
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getAssuredLovList()
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISAssured> getAssuredLovList() throws SQLException {
		return this.getSqlMapClient().queryForList("getAssuredLovList");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getAssuredNoSequence()
	 */
	@Override
	public Integer getAssuredNoSequence() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getAssuredNoSequence");
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getGiisAssuredDetails(java.lang.Integer)
	 */
	@Override
	public GIISAssured getGiisAssuredDetails(Integer assdNo)
			throws SQLException {
		return (GIISAssured) getSqlMapClient().queryForObject("getGiisAssuredDetails", assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#saveGIISAssuredIntm(java.util.Map)
	 */
	@Override
	public void saveGIISAssuredIntm(Map<String, Object> assdIntmParams)
			throws SQLException {
		this.getSqlMapClient().insert("saveGIISAssuredIntm", assdIntmParams);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#deleteGIISAssdIntm(java.lang.Integer)
	 */
	@Override
	public void deleteGIISAssdIntm(Integer assdNo) throws SQLException {
		this.getSqlMapClient().delete("deleteGIISAssdIntm", assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getGIISAssuredIntm(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISIntermediary> getGIISAssuredIntm(Integer assdNo)
			throws SQLException {
		return getSqlMapClient().queryForList("getGIISAssuredIntm", assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#saveGIISAssuredGroup(java.util.Map)
	 */
	@Override
	public void saveGIISAssuredGroup(Map<String, Object> assdGroupParams)
			throws SQLException {
		getSqlMapClient().insert("saveGIISAssuredGroup", assdGroupParams);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getGIISAssuredGroup(java.lang.Integer)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISGroup> getGIISAssuredGroup(Integer assdNo) throws SQLException {
		return this.getSqlMapClient().queryForList("getGIISAssuredGroup", assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#deleteGIISAssdGroup(java.lang.Integer)
	 */
	@Override
	public void deleteGIISAssdGroup(Integer assdNo) throws SQLException {
		this.getSqlMapClient().delete("deleteGIISAssdGroup", assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#saveGIISAssuredIndInfo(com.geniisys.common.entity.GIISAssuredIndividualInformation)
	 */
	@Override
	public void saveGIISAssuredIndInfo(
			GIISAssuredIndividualInformation assuredIndividualInformation)
			throws SQLException {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			this.getSqlMapClient().insert("saveGIISAssuredIndInfo", assuredIndividualInformation);
			this.getSqlMapClient().executeBatch();
			
			if(assuredIndividualInformation.getBirthdate() != null){
				log.info("UPDATING ASSURED INFORMATION...");
				Map<String, Object> params = new HashMap<String, Object>();
				params.put("assdNo", assuredIndividualInformation.getAssdNo());
				params.put("emailAddr", assuredIndividualInformation.getEmailAddress());
				params.put("birthday", assuredIndividualInformation.getBirthdate());
				
				this.getSqlMapClient().insert("copyGIISAssured", params);
				this.getSqlMapClient().executeBatch();
			}
			
			this.getSqlMapClient().getCurrentConnection().commit();
		}catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException();
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
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getGIISAssuredIndividualInfo(java.lang.Integer)
	 */
	@Override
	public GIISAssuredIndividualInformation getGIISAssuredIndividualInfo(
			Integer assdNo) throws SQLException {
		return (GIISAssuredIndividualInformation) this.getSqlMapClient().queryForObject("getGIISAssuredIndividualInfo", assdNo);
	}

	/* (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getAcctOfList(java.util.Map)
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<GIISAssured> getAcctOfList(Map<String, Object> params) throws SQLException {
		return getSqlMapClient().queryForList("getAcctOfList", params);
	}

	@Override
	public String checkAssuredDependencies(Integer assdNo) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkAssuredDependencies", assdNo);
	}

	@Override
	public void deleteAssured(Integer assdNo) throws SQLException {
		this.getSqlMapClient().delete("deleteAssured", assdNo);
	}

	/*
	 * (non-Javadoc)
	 * @see com.geniisys.common.dao.GIISAssuredDAO#getAssdMailingAddress(java.util.Map)
	 */
	@Override
	public Map<String, Object> getAssdMailingAddress(Map<String, Object> params)
			throws SQLException {
		System.out.println("Assd No : " + params.get("assdNo"));
		this.getSqlMapClient().update("getAssdMailingAddress", params);
		System.out.println("Address 1 : " + params.get("address1"));
		System.out.println("Address 2 : " + params.get("address2"));
		System.out.println("Address 3 : " + params.get("address3"));
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISAssured> getExistingAssured(String assdName)
			throws SQLException {
		return this.getSqlMapClient().queryForList("getSameAssuredNameList", assdName);
	}

	@Override
	public Map<String, Object> checkAssdMobileNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("checkAssdMobileNo", params);
		Debug.print(params);
		return params ;
	}

	@Override
	public String checkRefCd(String refCd) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkRefCd", refCd);
	}

	@Override
	public String checkRefCd2(Map<String, Object> params) throws SQLException {
		return (String) this.getSqlMapClient().queryForObject("checkRefCd2", params);
	}
	
	@Override
	public Integer getFirstRecord() throws SQLException {
		return (Integer) this.getSqlMapClient().queryForObject("getFirstRecord");
	}

	@Override
	public Map<String, Object> validateAssdNo(Map<String, Object> params)
			throws SQLException {
		this.getSqlMapClient().update("validateAssdNo", params);
		return params;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIISAssured> validateAssdNoGiexs006(Map<String, Object> params)
			throws SQLException {
		return this.sqlMapClient.queryForList("validateAssdNoGiexs006", params);
	}

	@Override
	public String checkAssuredExistGiiss006b(Map<String, Object> params)
			throws SQLException {
		log.info("checking if assured is existing params:"+params);
		return (String) getSqlMapClient().queryForObject("checkAssuredExistGiiss006b", params);
	}

	@Override
	public String checkAssuredExistGiiss006b2(Map<String, Object> params)
			throws SQLException {
		log.info("checking if assured is existing params:"+params);
		return (String) getSqlMapClient().queryForObject("checkAssuredExistGiiss006b2", params);
	}

	@Override
	public String getPostQueryGiiss006b(Integer assdNo) throws SQLException {
		log.info("getPostQueryGiiss006b: "+assdNo);
		return (String) getSqlMapClient().queryForObject("getPostQueryGiiss006b",assdNo);
	}

	@Override
	public void deleteGiisAssured(Map<String, Object> params) throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			
			log.info("Start deleting assured and details: "+params);
			
			this.getSqlMapClient().delete("deleteGiisAssuredIntm", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().delete("deleteGiisAssdIndInfo", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().delete("deleteGiisAssured", params);
			this.getSqlMapClient().executeBatch();
			
			this.getSqlMapClient().getCurrentConnection().commit();
			log.info("Successfully deleted: "+params);
			
		}catch(SQLException e){
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw e;
		}finally{
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void valDeleteGroupInfo(Map<String, Object> params) throws SQLException {
		System.out.println("valDeleteGroupInfo PARAMS : " + params);
		this.getSqlMapClient().update("valDeleteGroupInfo", params);
	}
	
	//benjo 09.07.2016 SR-5604
	@Override
	public String checkDfltIntm(Map<String, Object> params) throws SQLException {
		log.info("Checking default intermediary...");
		return (String) getSqlMapClient().queryForObject("checkDfltIntm", params);
	}
}
