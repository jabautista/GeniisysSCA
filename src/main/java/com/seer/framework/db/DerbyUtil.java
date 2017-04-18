/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;



/**
 * The Class DerbyUtil.
 */
public class DerbyUtil {
	
	/**
	 * Sequence next value.
	 * 
	 * @param sequenceName the sequence name
	 * 
	 * @return the long
	 */
	public static long sequenceNextValue(String sequenceName) {
		long result = 0;
		try {
			Connection conn = DriverManager
					.getConnection("jdbc:default:connection");
			PreparedStatement ps = conn.prepareStatement("select value from sequences where name = ?");
			ps.setString(1, sequenceName);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				result = rs.getLong(1)+1;
			}
			rs.close();
			ps.close();
		} catch (SQLException e) {
		}
		return result;
	}

}
