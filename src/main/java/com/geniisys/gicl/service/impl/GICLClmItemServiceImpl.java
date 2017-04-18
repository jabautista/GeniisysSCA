package com.geniisys.gicl.service.impl;

import com.geniisys.gicl.dao.GICLClmItemDAO;
import com.geniisys.gicl.service.GICLClmItemService;

public class GICLClmItemServiceImpl implements GICLClmItemService{

	private GICLClmItemDAO giclClmItemDAO;
	
	public void setGiclClmItemDAO(GICLClmItemDAO giclClmItemDAO){
		this.giclClmItemDAO = giclClmItemDAO;
	}
	
	public GICLClmItemDAO getGiclClmItemDAO(){
		return this.giclClmItemDAO;
	}
	
}
