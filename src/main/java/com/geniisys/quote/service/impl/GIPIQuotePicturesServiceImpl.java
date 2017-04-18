package com.geniisys.quote.service.impl;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.geniisys.framework.util.JSONUtil;
import com.geniisys.framework.util.TableGridUtil;
import com.geniisys.gipi.util.FileUtil;
import com.geniisys.quote.dao.GIPIQuotePicturesDAO;
import com.geniisys.quote.entity.GIPIQuoteItem;
import com.geniisys.quote.entity.GIPIQuotePictures;
import com.geniisys.quote.service.GIPIQuotePicturesService;

public class GIPIQuotePicturesServiceImpl implements GIPIQuotePicturesService{
	
	private GIPIQuotePicturesDAO gipiQuotePicturesDAO2;

	public GIPIQuotePicturesDAO getGipiQuotePicturesDAO2() {
		return gipiQuotePicturesDAO2;
	}

	public void setGipiQuotePicturesDAO2(GIPIQuotePicturesDAO gipiQuotePicturesDAO2) {
		this.gipiQuotePicturesDAO2 = gipiQuotePicturesDAO2;
	}

	@Override
	public void saveQuotationAttachments(HttpServletRequest request,
			String userId) throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("setAttachRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("setAttachRows")), userId, GIPIQuotePictures.class));
		params.put("delAttachRows", JSONUtil.prepareObjectListFromJSON(new JSONArray(request.getParameter("delAttachRows")), userId, GIPIQuotePictures.class));
		this.getGipiQuotePicturesDAO2().saveQuotationAttachments(params);
	}
	
	@Override
	public List<GIPIQuotePictures> getMediaSizes(List<GIPIQuotePictures> mediaList) throws FileNotFoundException,
			IOException, JSONException {
		List<GIPIQuotePictures> updatedMediaList = new ArrayList<GIPIQuotePictures>();
		for(GIPIQuotePictures picture : mediaList){
			FileInputStream fis;
        	byte[] pdfByte = null;
        	/*Added by MarkS 02/15/2017 SR5918*/ 
        	try {
	        	fis = new FileInputStream(picture.getFilePath());
				pdfByte = new byte[fis.available()];
				fis.read(pdfByte);
				fis.close();
				picture.setFileSize(new Integer(pdfByte.length).toString());
			} catch (IOException e) {
				picture.setFileSize("0");
			}
        	/* end SR5918*/
			
			updatedMediaList.add(picture);
			
		}
		return updatedMediaList;
	}
	
	@Override
	public JSONObject getAttachments(HttpServletRequest request)
			throws SQLException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("ACTION", "getAttachedMediaTG");
		params.put("quoteId", request.getParameter("quoteId"));
		params.put("itemNo", request.getParameter("itemNo"));
		
		Map<String, Object> recList = TableGridUtil.getTableGrid(request, params);
		return new JSONObject(recList);
	}
	
	public void deleteItemAttachments(Map<String, Object> params) throws SQLException {
		this.getGipiQuotePicturesDAO2().deleteItemAttachments(params);
	}
	
	public void deleteItemAttachments2(List<GIPIQuoteItem> delItemRows) throws SQLException {
		List<String> files = new ArrayList<String>();
		
		for (GIPIQuoteItem item : delItemRows) {
			List<GIPIQuotePictures> attachmentList = this.gipiQuotePicturesDAO2.getAttachmentList2(item.getQuoteId().toString(), item.getItemNo().toString());
			
			// delete attachment record from database
			Map<String, Object> params = new HashMap<String, Object>();
			params.put("quoteId", item.getQuoteId());
			params.put("itemNo", item.getItemNo());
			this.deleteItemAttachments(params);
			
			for (GIPIQuotePictures attachment : attachmentList) {
				files.add(attachment.getFileName());
			}
		}
		
		// delete attachment physical files from server
		FileUtil.deleteFiles(files);
	}
}
