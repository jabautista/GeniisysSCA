package com.geniisys.common.entity;

import com.geniisys.giis.entity.BaseEntity;

public class GIISEventsDisplay extends BaseEntity{

	private Integer eventColCd;
	private Integer dspColId;
	/**
	 * @return the eventColCd
	 */
	public Integer getEventColCd() {
		return eventColCd;
	}
	/**
	 * @param eventColCd the eventColCd to set
	 */
	public void setEventColCd(Integer eventColCd) {
		this.eventColCd = eventColCd;
	}
	/**
	 * @return the dspColId
	 */
	public Integer getDspColId() {
		return dspColId;
	}
	/**
	 * @param dspColId the dspColId to set
	 */
	public void setDspColId(Integer dspColId) {
		this.dspColId = dspColId;
	}
}
