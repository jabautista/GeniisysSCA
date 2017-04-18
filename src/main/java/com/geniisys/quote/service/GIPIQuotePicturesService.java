package com.geniisys.quote.service;

import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.quote.entity.GIPIQuoteItem;
import com.geniisys.quote.entity.GIPIQuotePictures;

public interface GIPIQuotePicturesService {
	
	void saveQuotationAttachments(HttpServletRequest request, String userId) throws SQLException, JSONException;
	List<GIPIQuotePictures> getMediaSizes(List<GIPIQuotePictures> mediaList) throws FileNotFoundException, IOException, JSONException;
	JSONObject getAttachments(HttpServletRequest request) throws SQLException, JSONException;
	void deleteItemAttachments(Map<String, Object> params) throws SQLException;
	void deleteItemAttachments2(List<GIPIQuoteItem> delItemRows) throws SQLException;
}
