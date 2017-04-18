<div id="dvInfoDiv" style="width: 818px;">
	<div class="sectionDiv" id="dvInfoDiv1" changeTagAttr="true">
		<table style="margin-top: 10px; margin-bottom: 10px; width: 800px;"  align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned"  style="width: 100px;">Company</td>
				<td class="leftAligned" style="width: 330PX;;">
					<input type="text" id="company" name="company" value="" style="width: 285px; margin-left: 7px;" readonly="readonly" >
				</td>
				
				<td class="rightAligned"  style="width: 120px;">Branch</td>
				<td class="leftAligned">
					<input type="text" id="branch" name="branch" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" >
				</td>
			</tr>
		</table>
	</div>
	
	<div class="sectionDiv" id="dvInfoDiv2">
		<table style="margin-top: 10px; margin-bottom: 10px; width: 800px;" align="center" cellspacing="1" border="0" >
			<tr>
				<td class="rightAligned"  style="width: 100px;">Request No.</td>
				<td class="leftAligned" style="width: 330px; ">
					<input style="width: 61px; margin-left: 7px;" id="txtDocumentCd" name="txtDocumentCd" type="text" value="" readOnly="readonly"  />
					<input style="width: 30px;" type="text" id="txtDspBranchCd" name="txtDspBranchCd" readonly="readonly"/>
					<input style="width: 30px;" id="txtLineCd" name="txtLineCd" type="text" value="" readOnly="readonly"/>
					<input style="width: 55PX;; text-align: right;" type="text" id="txtDocYear" name="txtDocYear"  readonly="readonly"/>
					<input style="width: 60px; text-align: right;" type="text" id="txtDocSeqNo" name="txtDocSeqNo" readonly="readonly" />
				</td>
				
				<td class="rightAligned"  style="width: 45px; margin-left: 10px;">Date</td>
				<td class="leftAligned">
					<input type="text" id="txtRequestDate" name="txtRequestDate" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" class="money">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Department</td>
				<td class="leftAligned">
					<input style="float: left; width: 45px; text-align: right; margin-right: 4px; margin-left: 6px;" type="text" id="txtDspDeptCd" name="txtDspDeptCd" readonly="readonly"/>
					<input style="width: 228px;" id="txtDspOucName" name="txtDspOucName" type="text" value="" readOnly="readonly"  />
				</td>
				
				<td class="rightAligned" style="width: 120px;">Status</td>
				<td class="leftAligned">
					<input style="width: 45px; margin-left: 10px;" type="text" id="txtPaytReqFlag" name="txtPaytReqFlag" readonly="readonly"/>
					<input style="width: 133px;" type="text" id="txtMeanPaytReqFlag" name="txtMeanPaytReqFlag" readonly="readonly"/>
				</td>
			</tr>			
		</table>
	</div>
	<div class="sectionDiv" id="dvInfoDiv">
		<table style="margin-top: 10px; margin-bottom: 10px; width: 800px;"  align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned"  style="width: 100px;">DV Number</td>
				<td class="leftAligned" style="width: 330px;">
					<input style="width: 45px; margin-left: 7px;" type="text" id="txtDvPref" name="txtDvPref" readonly="readonly"/>
					<input style="width: 228px; text-align: right;" type="text" id="txtDvNo" name="txtDvNo" readonly="readonly"/>
				</td>
				
				<td class="rightAligned"  style="width: 120px;">DV Status</td>
				<td class="leftAligned">
					<input style="width: 45px; margin-left: 10px;" type="text" id="txtDvFlag" name="txtDvPref" readonly="readonly"/>
					<input style="width: 133px;" type="text" id="txtDvFlagMean" name="txtDvFlagMean" readonly="readonly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >DV Print Date</td>
				<td class="leftAligned" >
					<input type="text" id="txtDvPrintDate" name="txtDvPrintDate" value="" style="width: 284px; margin-left: 7px;" readonly="readonly" class="money">
				</td>
				
				<td class="rightAligned" >DV Created By</td>
				<td class="leftAligned">
					<input type="text" id="txtDvCreatedBy" name="txtDvCreatedBy" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" class="money">
				</td>
			</tr>
			<tr>
				<td class="rightAligned"  >DV Approved By</td>
				<td class="leftAligned" >
					<input type="text" id="txtDvApprovedBy" name="txtDvApprovedBy" value="" style="width: 284px; margin-left: 7px;" readonly="readonly" class="money">
				</td>
				
				<td class="rightAligned"  >DV Created Date</td>
				<td class="leftAligned">
					<input type="text" id="txtDvCreateDate" name="txtDvCreateDate" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" class="money">
				</td>
			</tr>
		</table>
		
		<table style="margin-top: 30px; margin-bottom: 10px; width: 800px;"  align="center" cellspacing="1" border="0">
			<tr>
				<td class="rightAligned"  style="width: 100px;">Check Status</td>
					<td class="leftAligned" style="width: 330px;">
					<input type="text" id="txtCheckStat" name="txtCheckStat" value="" style="width: 284px; margin-left: 7px;" readonly="readonly" class="money">
				</td>
				
				<td class="rightAligned"  style="width: 120px;">Check Release Date</td>
				<td class="leftAligned">
					<input type="text" id="txtCheckReleaseDate" name="txtCheckReleaseDate" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" class="money">
				</td>
			</tr>
			<tr>
				<td class="rightAligned"  >Check Date</td>
				<td class="leftAligned" >
					<input type="text" id="txtCheckDate" name="txtCheckDate" value="" style="width: 284px; margin-left: 7px;" readonly="readonly" class="money">
				</td>
				
				<td class="rightAligned"  >Released By</td>
				<td class="leftAligned">
					<input type="text" id="txtReleasedBy" name="txtReleasedBy" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" class="money">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Check No.</td>
				<td class="leftAligned" >
					<input style="width: 45px; margin-left: 7px;" type="text" id="txtCheckPrefSuf" name="txtCheckPrefSuf" readonly="readonly"/>
					<input style="width: 228px;" type="text" id="txtCheckNo" name="txtCheckNo" readonly="readonly"/>
				</td>
				
				<td class="rightAligned"  style="width: 120px;">O.R. Number</td>
				<td class="leftAligned">
					<input type="text" id="txtOrNo" name="txtOrNo" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" class="money">
				</td>
			</tr>
			<tr>
				<td></td>
				<td></td>
				<td class="rightAligned"  style="width: 120px;">O.R. Date</td>
				<td class="leftAligned">
					<input type="text" id="txtOrDate" name="txtOrDate" value="" style="width: 190px;; margin-left: 10px;" readonly="readonly" class="money">
				</td>
			</tr>
		
		</table>
	</div>

	<div class="sectionDiv"  style="padding-top: 5px; padding-bottom:5px; margin-top: 10px; margin-bottom:10px; " >
		<div style="text-align:center">
			<input type="button" class="button" id="btnReturn" value="Return" style="width:100px;" title="back to main"/>
		</div>
	</div>
</div>
<script>
	try{
		var gidv = JSON.parse('${giacDisbVouchers}'.replace(/\\/g, '\\\\'));
		var gcdb = JSON.parse('${giacChkDisbursement}'.replace(/\\/g, '\\\\'));
		var gcri = JSON.parse('${giacChkReleaseInfo}'); //marco - 04/21/2014 - removed .replace(/\\/g, '\\\\')
		
		// populate dv info
		$("txtDvPref").value = unescapeHTML2(gidv.dvPref);
		$("txtDvNo").value = formatNumberDigits(gidv.dvNo,10);
		$("txtDvFlag").value = gidv.dvFlag;
		$("txtDvFlagMean").value = unescapeHTML2(gidv.dspDvFlagMean);
		$("txtDvPrintDate").value = gidv.strDvPrintDate;
		$("txtDvCreatedBy").value = unescapeHTML2(gidv.dvCreatedBy);
		$("txtDvApprovedBy").value = unescapeHTML2(gidv.dvApprovedBy);
		$("txtDvCreateDate").value = gidv.strDvCreateDate;
		
		$("txtCheckStat").value	 = nvl(gcdb.dspCheckFlagMean, ""); //lara 12/13/2013
		$("txtCheckDate").value	 = nvl(gcdb.strCheckDate, "");
		$("txtCheckPrefSuf").value	 = unescapeHTML2(gcdb.checkPrefSuf);
		$("txtCheckNo").value	 = formatNumberDigits(gcdb.checkNo == null ? "" : gcdb.checkNo,12); //lara 12/04/2013
		
		$("txtCheckReleaseDate").value	 = nvl(gcri.strCheckReleaseDate,"");
		$("txtReleasedBy").value	 = unescapeHTML2(nvl(gcri.checkReleasedBy,"")); //marco - 04.15.2014 - changed from gcri.releasedBy
		$("txtOrNo").value	 = unescapeHTML2(nvl(gcri.orNo,""));
		$("txtOrDate").value	 = nvl(gcri.strOrDate,"");
		
		
	}catch (e) {
		showErrorMessage("populateDvInfo",e);
	}

	$("btnReturn").observe("click", function(){
		genericObjOverlay.close();
	});
	
</script>
