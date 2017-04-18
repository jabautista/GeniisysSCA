/**
 * 
 * Project Name: Geniisys Web
 * Version: 	 
 * Author:		 Computer Professionals, Inc.
 * 
 */
package com.seer.framework.util;

import java.util.Arrays;
import java.util.List;

import org.acegisecurity.GrantedAuthority;
import org.acegisecurity.context.SecurityContextHolder;



/**
 * The Class SecurityUtils.
 */
public class SecurityUtils {
	
	/**
	 * Gets the current user details.
	 * 
	 * @return the current user details
	 */
	public static Object getCurrentUserDetails() {
		return SecurityContextHolder.getContext().getAuthentication().getPrincipal();
	}
	
	/**
	 * Gets the current user.
	 * 
	 * @return the current user
	 */
	public static String getCurrentUser() {
		return SecurityContextHolder.getContext().getAuthentication().getName();
	}
	
	/**
	 * Gets the granted authorities.
	 * 
	 * @return the granted authorities
	 */
	public static List<GrantedAuthority> getGrantedAuthorities() {
		return Arrays.asList(SecurityContextHolder.getContext().getAuthentication().getAuthorities());

	}
	
}
