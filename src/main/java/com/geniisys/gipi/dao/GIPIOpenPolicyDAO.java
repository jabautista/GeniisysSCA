package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.Map;


import com.geniisys.gipi.entity.GIPIOpenPolicy;

public interface GIPIOpenPolicyDAO {

	GIPIOpenPolicy getEndtseq0OpenPolicy(Integer policyEndSeq0) throws SQLException;
	Map<String, Object> getOpenLiabFiMn(String policyId) throws SQLException;
}
