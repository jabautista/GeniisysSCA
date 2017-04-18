package com.geniisys.csv;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class ConnectorCloser {

	public void closeRSPSConn(ResultSet rs, PreparedStatement ps,
			CallableStatement cs, Connection conn) {
		if (rs != null) {
			try {
				rs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		this.closePSConn(ps, cs, conn);
	}

	public void closePSConn(PreparedStatement ps, CallableStatement cs,
			Connection conn) {
		if (ps != null) {
			try {
				ps.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		if (cs != null) {
			try {
				cs.close();
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
		//this.closeConn(conn);
	}

	public void closeConn(Connection conn) {
		if (conn != null) {
			try {
				conn.close();
				System.out.println("Connection closed.");
			} catch (SQLException e) {
				e.printStackTrace();
			}
		}
	}

}
