package com.geniisys.quote.dao;

import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import com.geniisys.quote.entity.GIPIQuotePictures;

public interface GIPIQuotePicturesDAO {
	
	void saveQuotationAttachments(Map<String, Object> params) throws SQLException;
	List<GIPIQuotePictures> getAttachedMedia(Integer quoteId) throws SQLException;
	List<GIPIQuotePictures> getAttachmentList2(String quoteId, String itemNo) throws SQLException;
	void deleteItemAttachments(Map<String, Object> params) throws SQLException;
}
