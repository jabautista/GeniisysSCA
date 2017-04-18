/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.common.report;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;


/**
 * The Class ReportDAOHelper.
 */
public class ReportDAOHelper extends ReportDAOImpl{

	/** The logger. */
	private Logger logger = Logger.getLogger(ReportDAOHelper.class);
	
	/**
	 * Gets the quote ids.
	 * 
	 * @param conn the conn
	 * @return the quote ids
	 * @throws SQLException the sQL exception
	 */
	public List<Integer> getQuoteIds(Connection conn) throws SQLException {
		List<Integer> quoteIds = new ArrayList<Integer>();
		PreparedStatement ps = null;
		ResultSet rs = null;
		try {
			String sql = "select quote_id from GIPI_QUOTE";
			ps = conn.prepareStatement(sql);
			rs = ps.executeQuery();
			while (rs.next()){
				quoteIds.add(rs.getInt(1));
			}
		} catch (SQLException e){
			logger.error("Error in getting unit list... "+e.getMessage());
			logger.debug(Arrays.toString(e.getStackTrace()));
			throw e;
		} finally {
			close(rs);
			close(ps);
			close(conn);
		}
		return quoteIds;
	}
	
	
}
