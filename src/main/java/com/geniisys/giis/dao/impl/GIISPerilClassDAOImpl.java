package com.geniisys.giis.dao.impl;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import com.geniisys.giis.dao.GIISPerilClassDAO;
import com.geniisys.giis.entity.GIISPerilClass;
import com.ibatis.sqlmap.client.SqlMapClient;

public class GIISPerilClassDAOImpl implements GIISPerilClassDAO {

	private static Logger log = Logger.getLogger(GIISPerilClassDAOImpl.class);

	private SqlMapClient sqlMapClient;

	public SqlMapClient getSqlMapClient() {
		return sqlMapClient;
	}

	public void setSqlMapClient(SqlMapClient sqlMapClient) {
		this.sqlMapClient = sqlMapClient;
	}


	@Override
	@SuppressWarnings("unchecked")
	public void savePerilClass(Map<String, Object> params) throws SQLException,Exception {
		try {
			
			List<GIISPerilClass> setPerilClass = (List<GIISPerilClass>) params.get("setPerilClass");
			List<GIISPerilClass> delPerilClass = (List<GIISPerilClass>) params.get("delPerilClass");

			this.sqlMapClient.startTransaction();
			this.sqlMapClient.getCurrentConnection().setAutoCommit(false);
			this.sqlMapClient.startBatch();

			log.info("Saving GIIS Peril Class...");
			for (GIISPerilClass perilClass : delPerilClass) {
				getSqlMapClient().delete("delGIISPerilClass", perilClass);
			}
			log.info(delPerilClass.size() + " GIIS Peril Class/s deleted.");
			this.sqlMapClient.executeBatch();

			for (GIISPerilClass perilClass : setPerilClass) {
				getSqlMapClient().insert("setGIISPerilClass", perilClass);
			}
			log.info(setPerilClass.size() + " GIIS Peril Class/s inserted.");

			this.sqlMapClient.executeBatch();
			this.sqlMapClient.getCurrentConnection().commit();
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

	@SuppressWarnings("unchecked")
	@Override
	public List<Map<String, Object>> getAllPerilsPerClassDetails(Map<String, Object> params) throws SQLException, Exception {
		return getSqlMapClient().queryForList("getAllPerilsPerClassDetails", params);
	}

}
