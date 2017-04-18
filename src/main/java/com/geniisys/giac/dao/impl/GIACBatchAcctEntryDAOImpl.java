/**
 * 
 */
package com.geniisys.giac.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giac.dao.GIACBatchAcctEntryDAO;
import com.geniisys.giac.entity.GIACBatchAcctEntry;
import com.ibatis.sqlmap.client.SqlMapClient;

/**
 * @author steven
 * @date 04.11.2013
 */
public class GIACBatchAcctEntryDAOImpl implements GIACBatchAcctEntryDAO{
	
	private static Logger log = Logger.getLogger(GIACBatchAcctEntryDAO.class);
	
	private SqlMapClient sqlMapClient;

	/**
	 * @return the sqlMapClient
	 */
	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	/**
	 * @param sqlMapClient the sqlMapClient to set
	 */
	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}

	@Override
	public String getGIACParamValue(String paramName) throws SQLException {
		return (String) getSqlMapClient().queryForObject("getGIACB000ParamValue",paramName);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> validateProdDate(String prodDate)
			throws SQLException {
		log.info("Validating Production Date: "+ prodDate);
		return (List<Map<String, Object>>) getSqlMapClient().queryForList("validateProdDate", prodDate);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<GIACBatchAcctEntry> generateDataCheck(
			Map<String, Object> params)throws SQLException, Exception {
		try {
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			List<GIACBatchAcctEntry> dateCheckParams = (List<GIACBatchAcctEntry>) params.get("dateCheckParams");
			boolean cond = false;
			if(dateCheckParams != null){
				for(GIACBatchAcctEntry dateCheck: dateCheckParams){
					cond =  dateCheck.isCond();
				}
			}
			if (cond) {
				log.info("Updating GIIS_PARAMETERS where PARAM_NAME: ALLOW_SPOILAGE...");
				this.getSqlMapClient().insert("updateAllowSpoilage");
			}else {
				log.info("Checking the data before generating acounting entry...");
				if(dateCheckParams != null){
					for(GIACBatchAcctEntry dateCheck: dateCheckParams){
						this.getSqlMapClient().insert("generateDataCheck", dateCheck);
						log.info(dateCheck.getLog());
					}
				}
			}
			this.getSqlMapClient().executeBatch();
			return dateCheckParams;
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public void validateWhenExit() throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			this.getSqlMapClient().insert("validateWhenExit");
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
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
			this.getSqlMapClient().endTransaction();
		}
		
	}

	@Override
	public void prodSumRepAndPerilExt(List<GIACBatchAcctEntry> dateCheckParams) throws SQLException,
			Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(dateCheckParams != null){
				for (GIACBatchAcctEntry dateCheck : dateCheckParams) {
					this.getSqlMapClient().insert("prodSumRepAndPerilExt",dateCheck);
					log.info(dateCheck.getLog());
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} catch (Exception e) {
			e.printStackTrace();
			log.error("ERROR MESSAGE: " + e.getMessage() + "\nCAUSE: " + e.getCause());
			this.getSqlMapClient().getCurrentConnection().rollback();
			throw new SQLException(e.getCause());
		} finally {
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public List<GIACBatchAcctEntry> giacb001Proc(List<GIACBatchAcctEntry> paramList)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(paramList != null){
				for (GIACBatchAcctEntry giacBatchAcctEntry : paramList) {
					log.info("Calling procedures for GIACB001...");
					
					log.info("Re-take-up of previously generated entries...");
					this.getSqlMapClient().insert("giacb001ReTakeUp",giacBatchAcctEntry);
					
					log.info("Take-up of policies...");
					this.getSqlMapClient().insert("giacb001ProdTakeUp",giacBatchAcctEntry);

					log.info("Running procedure PROD_TAKE_UP_PROC...");
					this.getSqlMapClient().insert("giacb001ProdTakeUpProc",giacBatchAcctEntry);
					
					log.info("Exiting GIACB001... back in GIACB000...");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return paramList;
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
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public List<GIACBatchAcctEntry> giacb002Proc(List<GIACBatchAcctEntry> paramList)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(paramList != null){
				for (GIACBatchAcctEntry giacBatchAcctEntry : paramList) {
					log.info("Calling procedures for GIACB002...");
					
					log.info("Re-take-up of previously generated entries...");
					this.getSqlMapClient().insert("giacb002ReTakeUp",giacBatchAcctEntry);
					
					log.info("Take-up of policies...");
					this.getSqlMapClient().insert("giacb002ProdTakeUp",giacBatchAcctEntry);
					
					log.info("Running procedure PROD_TAKE_UP_PROC...");
					this.getSqlMapClient().insert("giacb002ProdTakeUpProc",giacBatchAcctEntry);
					
					log.info("Exiting GIACB002... back in GIACB000...");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return paramList;
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
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public List<GIACBatchAcctEntry> giacb003Proc(List<GIACBatchAcctEntry> paramList)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(paramList != null){
				for (GIACBatchAcctEntry giacBatchAcctEntry : paramList) {
					log.info("Calling procedures for GIACB003...");
					
					log.info("Running the procedure RE_TAKE_UP...");
					this.getSqlMapClient().insert("giacb003ReTakeUp",giacBatchAcctEntry);
					
					log.info("Running the procedure PROD_TAKE_UP...");
					this.getSqlMapClient().insert("giacb003ProdTakeUp",giacBatchAcctEntry);
					
					log.info("Exiting GIACB003... back in GIACB000...");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return paramList;
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
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public List<GIACBatchAcctEntry> giacb004Proc(List<GIACBatchAcctEntry> paramList)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(paramList != null){
				for (GIACBatchAcctEntry giacBatchAcctEntry : paramList) {
					log.info("Calling procedures for GIACB004...");

					log.info("Running the procedure GET_RULS_ON_INCL...");
					this.getSqlMapClient().insert("giacb004GetRulsOnIncl",giacBatchAcctEntry);
					
					log.info("Exiting GIACB004... back in GIACB000...");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return paramList;
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
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public List<GIACBatchAcctEntry> giacb005Proc(List<GIACBatchAcctEntry> paramList)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(paramList != null){
				for (GIACBatchAcctEntry giacBatchAcctEntry : paramList) {
					log.info("Calling procedures for GIACB005...");
					
					log.info("Running the procedure RE_TAKE_UP...");
					this.getSqlMapClient().insert("giacb005ReTakeUp",giacBatchAcctEntry);
					
					log.info("Running the procedure PROD_TAKE_UP...");
					this.getSqlMapClient().insert("giacb005ProdTakeUp",giacBatchAcctEntry);
					
					log.info("Exiting GIACB005... back in GIACB000...");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return paramList;
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
			this.getSqlMapClient().endTransaction();
		}
	}

	@Override
	public List<GIACBatchAcctEntry> giacb006Proc(List<GIACBatchAcctEntry> paramList)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(paramList != null){
				for (GIACBatchAcctEntry giacBatchAcctEntry : paramList) {
					log.info("Calling procedures for GIACB006...");
					
					log.info("Running the procedure RE_TAKE_UP...");
					this.getSqlMapClient().insert("giacb006ReTakeUp",giacBatchAcctEntry);
					
					log.info("Running the procedure PROD_TAKE_UP...");
					this.getSqlMapClient().insert("giacb006ProdTakeUp",giacBatchAcctEntry);
					
					log.info("Exiting GIACB006... back in GIACB000...");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return paramList;
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
			this.getSqlMapClient().endTransaction();
		}
	}
	
	/* benjo 10.13.2016 SR-5512 */
	@Override
	public List<GIACBatchAcctEntry> giacb007Proc(List<GIACBatchAcctEntry> paramList)
			throws SQLException, Exception {
		try{
			this.getSqlMapClient().startTransaction();
			this.getSqlMapClient().getCurrentConnection().setAutoCommit(false);
			this.getSqlMapClient().startBatch();
			if(paramList != null){
				for (GIACBatchAcctEntry giacBatchAcctEntry : paramList) {
					log.info("Calling procedures for GIACB007...");
					
					log.info("Running the procedure PROD_TAKE_UP...");
					this.getSqlMapClient().insert("giacb007ProdTakeUp",giacBatchAcctEntry);
					
					log.info("Exiting GIACB007... back in GIACB000...");
				}
			}
			this.getSqlMapClient().executeBatch();
			this.getSqlMapClient().getCurrentConnection().commit();
			return paramList;
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
			this.getSqlMapClient().endTransaction();
		}
	}
}
