package com.geniisys.gipi.dao;

import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;

import com.geniisys.gipi.entity.GIPIOrigCommInvoice;

public interface GIPIOrigCommInvoiceDAO {
	List<GIPIOrigCommInvoice> getGipiOrigCommInvoice(HashMap<String, Object> params) throws SQLException;
	
	List<HashMap<String , Object>> getInvoiceCommissions(HashMap<String, Object> params) throws SQLException;
}
