/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.report;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.log4j.Logger;


/**
 * The Class ReportDAOImpl.
 */
public class ReportDAOImpl {
	
	/** The logger. */
	private Logger logger = Logger.getLogger(ReportDAOImpl.class);
	
	/**
	 * Close.
	 * 
	 * @param ps the ps
	 * @throws SQLException the sQL exception
	 */
	protected void close(PreparedStatement ps) throws SQLException{
		logger.info("Closing prepared statement...");
		if (null!=ps){
			ps.close();
		}
	}
	
	/**
	 * Close.
	 * 
	 * @param cs the cs
	 * @throws SQLException the sQL exception
	 */
	protected void close(CallableStatement cs) throws SQLException{
		logger.info("Closing callable statement...");
		if (null!=cs){
			cs.close();
		}
	}

	/**
	 * Close.
	 * 
	 * @param rs the rs
	 * @throws SQLException the sQL exception
	 */
	protected void close(ResultSet rs) throws SQLException{
		logger.info("Closing result set...");
		if (null!=rs){
			rs.close();
		}
	}
	
	/**
	 * Close.
	 * 
	 * @param conn the conn
	 * @throws SQLException the sQL exception
	 */
	protected void close(Connection conn) throws SQLException{
		logger.info("Closing connection...");
		if (null!=conn){
			conn.close();
		}
	}
	
}
