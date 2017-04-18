/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.geniisys.framework.util;

import java.util.Collection;

import com.ibatis.common.util.PaginatedArrayList;


/**
 * The Class PaginatedList.
 */
@SuppressWarnings("deprecation")
public class PaginatedList extends PaginatedArrayList {
	
	/** The no of pages. */
	private static int noOfPages;

	/**
	 * Gets the no of pages.
	 * 
	 * @return the no of pages
	 */
	public int getNoOfPages() {
		return noOfPages;
	}

	/**
	 * Sets the no of pages.
	 * 
	 * @param noOfPages the new no of pages
	 */
	public void setNoOfPages(int noOfPages) {
		PaginatedList.noOfPages = noOfPages;
	}

	/**
	 * Instantiates a new paginated list.
	 * 
	 * @param c the c
	 * @param pageSize the page size
	 */
	@SuppressWarnings({ "static-access", "rawtypes" })
	public PaginatedList(Collection c, int pageSize) {
		super(c, pageSize);
		
		//compute number of pages
		double size = c.size();
		double page = pageSize;
		this.noOfPages = c.size()/pageSize;
		if(noOfPages<size/page){
			noOfPages++;
		}
	}
	
}
