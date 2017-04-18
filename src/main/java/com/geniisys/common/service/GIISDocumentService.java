package com.geniisys.common.service;

import java.sql.SQLException;

public interface GIISDocumentService {

	String checkDisplayGiexs006(String title) throws SQLException;
	String checkPrintPremiumDetails(String lineCd) throws SQLException;
}
