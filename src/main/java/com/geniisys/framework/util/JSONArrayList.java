package com.geniisys.framework.util;

import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

public class JSONArrayList extends JSONObject {

	private int noOfPages;
	private int pageNo;
	private JSONArray jsonArray;
	
	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public int getNoOfPages() {
		return noOfPages;
	}

	public void setNoOfPages(int noOfPages) {
		this.noOfPages = noOfPages;
	}
	
	public JSONArrayList() {
		/* empty constructor */
	}
	
	/**
	 * 
	 * @param list
	 * @param pageNo
	 */
	@SuppressWarnings("rawtypes")
	public JSONArrayList(List list, int pageNo) {
		this.pageNo = pageNo+1;
		int sIndex = pageNo*ApplicationWideParameters.PAGE_SIZE;
		this.noOfPages = list.size()/ApplicationWideParameters.PAGE_SIZE;
		
		/*if (noOfPages < list.size()/ApplicationWideParameters.PAGE_SIZE) {
			this.noOfPages++;
		} else if (list.size() < ApplicationWideParameters.PAGE_SIZE) {
			this.noOfPages++;
		}
		if (!(ApplicationWideParameters.PAGE_SIZE > list.size())) {
			list = list.subList(sIndex, sIndex+ApplicationWideParameters.PAGE_SIZE);
		}*/ 
		
		// modified by nica 12.03.2010 - added some conditions

		if (noOfPages < list.size()/ApplicationWideParameters.PAGE_SIZE) {
			this.noOfPages++;
		} else if (list.size() < ApplicationWideParameters.PAGE_SIZE) {
			this.noOfPages++;
		}else if((list.size()%ApplicationWideParameters.PAGE_SIZE) != 0){
			this.noOfPages++;
		}
		
		if (!(ApplicationWideParameters.PAGE_SIZE > list.size())) {
			if(sIndex+ApplicationWideParameters.PAGE_SIZE <= list.size()){
				list = list.subList(sIndex, sIndex+ApplicationWideParameters.PAGE_SIZE);
			}else if((sIndex+ApplicationWideParameters.PAGE_SIZE) > list.size()){
				list = list.subList(sIndex, sIndex+(list.size()% ApplicationWideParameters.PAGE_SIZE));
			}
		}
		
		
		this.jsonArray = new JSONArray(list);
	}
	
	public JSONArray getJsonArray() {
		return jsonArray;
	}
}
