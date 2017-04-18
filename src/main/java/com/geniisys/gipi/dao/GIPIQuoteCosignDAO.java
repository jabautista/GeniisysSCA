package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.List;

import com.geniisys.gipi.entity.GIPIQuoteCosign;

public interface GIPIQuoteCosignDAO {

	List<GIPIQuoteCosign> getGIPIQuoteCosigns(Integer quoteId) throws SQLException;
}
