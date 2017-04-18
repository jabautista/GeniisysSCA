package com.geniisys.giuw.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.giuw.entity.GIUWDistBatch;
import com.geniisys.giuw.entity.GIUWPolDistPolbasicV;

public interface GIUWDistBatchDAO {
	GIUWDistBatch getGIUWDistBatch(Map<String, Object> params) throws SQLException;
	String saveBatchDistribution(Map<String, Object> params) throws SQLException, Exception;
	void saveBatchDistributionShare(Map<String, Object> params) throws SQLException, Exception;
	List<GIUWPolDistPolbasicV> getPoliciesByBatchId(Map<String, Object> params) throws SQLException;
	List<GIUWPolDistPolbasicV> getPoliciesByParam(Map<String, Object> params) throws SQLException;
}
