<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<div id="claimDetailsDiv" name="claimDetailsDiv" changeTagAttr="true" style="width: 98%;">
	<span class="notice" id="noticePopup" name="noticePopup" style="display: none;">Saving, please wait...</span>
	<form id="claimDetailsForm" name="claimDetailsForm" style="margin-left: 0px; margin-top: 10px;">
		<div class="sectionDiv">
			<table align="center" style="margin: 10px 0 10px 10px;">
				<tr>
					<td class="rightAligned" style="width: 80px;">Claim No.</td>
					<td class="leftAligned">
						<input id="txtClmLineCd" class="upper" name="txtClmLineCd" type="text" style="width: 42px;" value="" tabindex="301" maxlength="2" title="Line Code"/>
						<input id="txtClmSublineCd" class="upper" name="txtClmSublineCd" type="text" style="width: 92px;" value="" tabindex="302" maxlength="7" title="Subline Code"/> 
						<input id="txtClmIssCd" class="upper" name="txtClmIssCd" type="text" style="width: 42px;" value="" tabindex="303" maxlength="2" title="Claim Issue Code"/>
						<input id="txtClmYy" class="" name="txtClmYy" type="text" style="width: 30px; text-align: right;" value="" tabindex="304" maxlength="2" title="Claim Year"/>
						<input id="txtClmSeqNo" class="" name="txtClmSeqNo" type="text" style="width: 80px; text-align: right;" value="" tabindex="305" maxlength="7" title="Claim Sequence No."/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 80px;">Policy No.</td>
					<td class="leftAligned">
						<input id="basicLineCd" class="leftAligned upper" type="text" name="basicLineCd" style="width: 42px;" value="" title="Line Code" maxlength="2" tabindex="306"/>
						<input id="basicSublineCd" class="leftAligned upper" type="text" name="basicSublineCd" style="width: 80px;" value="" title="Subline Code"maxlength="7" tabindex="307"/>
						<input id="basicIssCd" class="leftAligned upper" type="text" name="basicIssCd" style="width: 30px;" value="" title="Issource Code"maxlength="2" tabindex="308"/>
						<input id="basicIssueYy" class="leftAligned" type="text" name="basicIssueYy" style="width: 30px; text-align: right;" value="" title="Year" maxlength="2" tabindex="309"/>
						<input id="basicPolSeqNo" class="leftAligned" type="text" name="basicPolSeqNo" style="width: 62px; text-align: right;" value="" title="Policy Sequence Number" maxlength="6" tabindex="310"/>
						<input id="basicRenewNo" class="leftAligned" type="text" name="basicRenewNo" style="width: 30px; text-align: right;" value="" title="Renew Number" maxlength="2" tabindex="311"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td>
						<span style="border: 1px solid gray; width: 340px; margin-top: 1px; margin-bottom: 2px; height: 21px; float: left;">
							<input type="hidden" id="hidAssdNo"> 
							<input type="text" class="upper" id="txtAssured" name="txtAssured" style="margin: 0; margin-top: 1px; border: none; height: 13px; float: left; width: 315px;" maxlength="500" tabindex="312"/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnSearchAssuredName" name="btnSearchAssuredName" alt="Go" tabindex="313"/>
						</span>
					</td>
				</tr>
				<tr> <!-- benjo 08.05.2015 UCPBGEN-SR-19632 added Remarks -->
					<td class="rightAligned">Remarks</td>
					<td>
						<span style="border: 1px solid gray; width: 340px; margin-top: 1px; margin-bottom: 2px; height: 21px; float: left;"> 
							<input type="text" class="upper" id="txtRemarks" name="txtRemarks" style="margin: 0; margin-top: 1px; border: none; height: 13px; float: left; width: 315px;" maxlength="500" tabindex="314"/>
						</span>
					</td>
				</tr>
			</table>
		</div>
		<div style="float: left;">
			<fieldset style="height: 92px; width: 444px; margin-top: 5px;">
				<legend>Search By</legend>
				<table style="width: 120px; float: left; margin-left: 20px;">
					<tr>
						<td class="rightAligned">
							<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 3px;" tabindex="314"/>
							<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">
							<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 3px;" tabindex="315"/>
							<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">
							<input type="radio" checked="checked" name="searchBy" id="rdoNone" style="float: left; margin: 3px 2px 3px 3px;" tabindex="316"/>
							<label for="rdoNone" style="float: left; height: 20px; padding-top: 3px;" title="None">None</label>
						</td>
					</tr>
				</table>
				<input type="hidden" id="hidSearchBy" value="">
				<table style="width: 250px; float: right;">
					<tr>
						<td class="rightAligned">
							<input type="radio" checked="checked" name="byDate" id="rdoAsOf" title="As of" style="float: left;" tabindex="316"/>
							<label for="rdoAsOf" title="As of" style="float: left; height: 20px; padding-top: 3px;">As of</label>
						</td>
						<td class="leftAligned">
							<div style="float: left; width: 150px;" class="withIconDiv">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon" readonly="readonly" style="width: 126px;" tabindex="317"/>
								<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="318"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="319"/>
						<label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
						<td class="leftAligned">
						<div style="float: left; width: 150px;" class="withIconDiv">
							<input type="text" id="txtFromDate" name="txtFromDate" class="withIcon" readonly="readonly" style="width: 126px;" tabindex="320"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="321"/>
						</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned"><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px; margin-left: 35px;">To</label></td>
						<td class="leftAligned">
						<div style="float: left; width: 150px;" class="withIconDiv">
							<input type="text" id="txtToDate" name="txtToDate" class="withIcon" readonly="readonly" style="width: 126px;" tabindex="322"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="323"/>
						</div>
						</td>
					</tr>
				</table>
			</fieldset>
		</div>
	</form>
</div>
<div class="buttonsDivPopup">
	<input type="button" class="button" id="btnOk" name="btnOk" value="OK" style="width:120px;" tabindex="324"/>
	<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 120px;" tabindex="325"/>
</div>

<script>
	$("btnCancel").observe("click", function(){
		overlayQueryClaims.close();
	}); 
	
	makeInputFieldUpperCase();

	function populateVariables(){
		try {
			objGICLS039.clmLineCd = $F("txtClmLineCd");
			objGICLS039.clmSublineCd = $F("txtClmSublineCd");
			objGICLS039.clmIssCd = $F("txtClmIssCd");
			objGICLS039.clmYy = $F("txtClmYy");
			objGICLS039.clmSeqNo = $F("txtClmSeqNo");
			
			objGICLS039.polLineCd = $F("basicLineCd");
			objGICLS039.polSublineCd = $F("basicSublineCd");
			objGICLS039.polIssCd = $F("basicIssCd");
			objGICLS039.polIssueYy = $F("basicIssueYy");
			objGICLS039.polSeqNo = $F("basicPolSeqNo");
			objGICLS039.polRenewNo = $F("basicRenewNo");
			
			objGICLS039.assdNo = $F("hidAssdNo");
			objGICLS039.assuredName = $F("txtAssured");
			objGICLS039.remarks = $F("txtRemarks"); //benjo 08.05.2015 UCPBGEN-SR-19632
			
			objGICLS039.searchBy = $F("hidSearchBy");
			objGICLS039.asOfDate = $F("txtAsOfDate");
			objGICLS039.fromDate = $F("txtFromDate");
			objGICLS039.toDate = $F("txtToDate");
		} catch(e){
			showErrorMessage("populateVariables", e);
		}
	}
	
	function populateFields(){
		try {
			$("txtClmLineCd").value = nvl(objGICLS039.clmLineCd, "");
			$("txtClmSublineCd").value = nvl(objGICLS039.clmSublineCd, "");
			$("txtClmIssCd").value = nvl(objGICLS039.clmIssCd, "");
			$("txtClmYy").value = nvl(objGICLS039.clmYy, "");
			$("txtClmSeqNo").value = nvl(objGICLS039.clmSeqNo, "");
			
			$("basicLineCd").value = nvl(objGICLS039.polLineCd, "");
			$("basicSublineCd").value = nvl(objGICLS039.polSublineCd, "");
			$("basicIssCd").value = nvl(objGICLS039.polIssCd, "");
			$("basicIssueYy").value = nvl(objGICLS039.polIssueYy, "");
			$("basicPolSeqNo").value = nvl(objGICLS039.polSeqNo, "");
			$("basicRenewNo").value = nvl(objGICLS039.polRenewNo, "");
			
			$("hidAssdNo").value = nvl(objGICLS039.assdNo, "");
			$("txtAssured").value = nvl(objGICLS039.assuredName, "");
			$("txtRemarks").value = nvl(objGICLS039.remarks, ""); //benjo 08.05.2015 UCPBGEN-SR-19632
			
			$("hidSearchBy").value = nvl(objGICLS039.searchBy, "");
			$("txtAsOfDate").value = nvl(objGICLS039.asOfDate, "");
			$("txtFromDate").value = nvl(objGICLS039.fromDate, "");
			$("txtToDate").value = nvl(objGICLS039.toDate, "");
			
			if($F("hidSearchBy") == "0" || $F("hidSearchBy") == ""){
				$("rdoNone").checked = true;
				disableDateFields(true);
			} else {
				if($F("hidSearchBy") == "1"){			
					$("rdoClaimFileDate").checked = true;
				} else if($F("hidSearchBy") == "2"){
					$("rdoLossDate").checked = true;
				}
				
				if(objGICLS039.asOfDate != ""){
					$("rdoAsOf").checked = true;
					enableDate("hrefAsOfDate");
					$("txtAsOfDate").disabled = false;
					disableDate("hrefFromDate");
					$("txtFromDate").disabled = true;
					disableDate("hrefToDate");
					$("txtToDate").disabled = true;
				} else if(objGICLS039.fromDate != "" && objGICLS039.toDate != ""){
					$("rdoFrom").checked = true;
					enableDate("hrefFromDate");
					$("txtFromDate").disabled = false;
					enableDate("hrefToDate");
					$("txtToDate").disabled = false;
					disableDate("hrefAsOfDate");
					$("txtAsOfDate").disabled = true;
				}
			}			
		} catch(e){
			showErrorMessage("populateFields", e);
		}
	}
	
	function queryClaims(){
		try {
			overlayQueryClaims.close();
			
			batchClaimClosingTableGrid.url = contextPath+"/GICLClaimsController?action=refreshClaimClosingList&userId="+userId+"&statusControl="+$F("txtStatusControl")
					+"&clmLineCd="+objGICLS039.clmLineCd+"&clmSublineCd="+objGICLS039.clmSublineCd+"&clmIssCd="+objGICLS039.clmIssCd+"&clmYy="+objGICLS039.clmYy
					+"&clmSeqNo="+objGICLS039.clmSeqNo+"&polIssCd="+objGICLS039.polIssCd+"&polIssueYy="+objGICLS039.polIssueYy+"&polSeqNo="+objGICLS039.polSeqNo
					+"&polRenewNo="+objGICLS039.polRenewNo+"&assdNo="+objGICLS039.assdNo+"&searchBy="+objGICLS039.searchBy+"&asOfDate="+objGICLS039.asOfDate
					+"&fromDate="+objGICLS039.fromDate+"&toDate="+objGICLS039.toDate+"&remarks="+encodeURIComponent(objGICLS039.remarks); //benjo 08.05.2015 UCPBGEN-SR-19632 added remarks
			
			batchClaimClosingTableGrid._refreshList();
		} catch(e){
			showErrorMessage("queryClaims", e);
		}
	}
	
	function getGiacs039AssuredLOV(changed){		
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {
							action: "getGicls039AssuredLOV",
							filterText : escapeHTML2(($F("hidAssdNo") == "" || changed ? $F("txtAssured") : ""))
						    },
			title: "List of Assured",
			width: 600,
			height: 400,
			columnModel : [
			               {
			            	   id : "assdNo",
			            	   title: "Assured No.",
			            	   width: '100px'
			               },
			               {
			            	   id: "assuredName",
			            	   title: "Assured Name",
			            	   width: '450px'
			               }
			              ],
			draggable: true,
			filterText : ($F("hidAssdNo") == ""  || changed ? $F("txtAssured") : ""),
			autoSelectOneRecord: true,
			onSelect: function(row) {
				$("txtAssured").value = unescapeHTML2(row.assuredName);
				$("hidAssdNo").value = unescapeHTML2(row.assdNo);
			},
			onCancel: function (){
				$("txtAssured").value = "";
				$("hidAssdNo").value = "";
			},
			onUndefinedRow : function(){
				showMessageBox("No record selected.", "I");
				$("txtAssured").value = "";
				$("hidAssdNo").value = "";
			},
			onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		});
	}
	
	$("btnSearchAssuredName").observe("click", function(){
		getGiacs039AssuredLOV(false);
	});
	$("txtAssured").observe("change", function(){
		getGiacs039AssuredLOV(true);
	});
	
	$("btnCancel").observe("click", function(){
		overlayQueryClaims.close();
	}); 
	
	$("btnOk").observe("click", function () {
		if(!$("rdoNone").checked && $("rdoFrom").checked && ($F("txtFromDate") == "" || $F("txtToDate") == "")){
			showWaitingMessageBox("Please enter both From Date and To Date.", function(){
				$("txtFromDate").focus();
			});
			return;
		}
		if($F("txtClmLineCd") == "" && $F("txtClmSublineCd") == ""
				&& $F("txtClmIssCd") == "" && $F("txtClmYy") == ""
				&& $F("txtClmSeqNo") == "" && $F("basicIssCd") == ""
				&& $F("basicIssueYy") == "" && $F("basicPolSeqNo") == ""
				&& $F("basicRenewNo") == "" && $F("hidAssdNo") == ""
			    && $F("txtRemarks") == "" //benjo 08.05.2015 UCPBGEN-SR-19632
				&& $F("txtAsOfDate") == "" && $F("txtFromDate") == ""){
			showWaitingMessageBox("Please enter at least one parameter.", function(){
				$("txtClmLineCd").focus();
			});
		} else {
			populateVariables();
			objGICLS039.querySw = "Y";
			queryClaims();
		}
	});

	$("txtClmLineCd").observe("change", function(){
		$("basicLineCd").value = $F("txtClmLineCd");
	});
	
	$("basicLineCd").observe("change", function(){
		$("txtClmLineCd").value = $F("basicLineCd");
	});
	
	$("basicSublineCd").observe("change", function(){
		$("txtClmSublineCd").value = $F("basicSublineCd");
	});
	
	$("txtClmSublineCd").observe("change", function(){
		$("basicSublineCd").value = $F("txtClmSublineCd");
	});
	
	$("txtClmYy").observe("keyup", function(){
		if(isNaN($F("txtClmYy"))) {
			$("txtClmYy").value = "";
		}
	});
	
	$("txtClmSeqNo").observe("keyup", function(){
		if(isNaN($F("txtClmSeqNo"))) {
			$("txtClmSeqNo").value = "";
		}
	});
	
	$("txtClmSeqNo").observe("change", function(){
		if($F("txtClmSeqNo") != "" && !isNaN($F("txtClmSeqNo"))) {
			$("txtClmSeqNo").value = formatNumberDigits($F("txtClmSeqNo"), 7);
		}
	});
	
	$("basicIssueYy").observe("keyup", function(){
		if(isNaN($F("basicIssueYy"))) {
			$("basicIssueYy").value = "";
		}
	});
	
	$("basicPolSeqNo").observe("keyup", function(){
		if(isNaN($F("basicPolSeqNo"))) {
			$("basicPolSeqNo").value = "";
		}
	});
	
	$("basicPolSeqNo").observe("change", function(){
		if($F("basicPolSeqNo") != "" && !isNaN($F("basicPolSeqNo"))) {
			$("basicPolSeqNo").value = formatNumberDigits($F("basicPolSeqNo"), 6);
		}
	});
	
	$("basicRenewNo").observe("keyup", function(){
		if(isNaN($F("basicRenewNo"))) {
			$("basicRenewNo").value = "";
		}
	});
	
	$("basicRenewNo").observe("change", function(){
		if($F("basicRenewNo") != "" && !isNaN($F("basicRenewNo"))) {
			$("basicRenewNo").value = formatNumberDigits($F("basicRenewNo"), 2);
		}
	});
	
	function disableDateFields(disabled){
		if(disabled){
			$("txtAsOfDate").disabled = true;
			$("txtFromDate").disabled = true;
			$("txtToDate").disabled = true;
			$("rdoAsOf").disabled = true;
			$("rdoFrom").disabled = true;
					
			disableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");
		} else {
			$("rdoAsOf").disabled = false;
			$("rdoFrom").disabled = false;
			
			$("txtAsOfDate").disabled = $("rdoFrom").checked;
			$("txtFromDate").disabled = $("rdoAsOf").checked;
			$("txtToDate").disabled = $("rdoAsOf").checked;
					
			$("rdoAsOf").checked ? enableDate("hrefAsOfDate") : disableDate("hrefAsOfDate");
			$("rdoFrom").checked ? enableDate("hrefFromDate") : disableDate("hrefFromDate");
			$("rdoFrom").checked ? enableDate("hrefToDate") : disableDate("hrefToDate");
			
			if($("rdoAsOf").checked){
				$("txtAsOfDate").value = getCurrentDate();
			}
		}
	}
	
	$("rdoNone").observe("change", function(){
		if(this.checked){
			$("txtAsOfDate").clear();
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("hidSearchBy").value = 0;
			disableDateFields(true);			
		}
	});
	
	$("rdoClaimFileDate").observe("change", function(){
		if(this.checked){
			$("hidSearchBy").value = 1;
			disableDateFields(false);
		}
	});
	
	$("rdoLossDate").observe("change", function(){
		if(this.checked){
			$("hidSearchBy").value = 2;
			disableDateFields(false);
		}
	});
	
	$("rdoAsOf").observe("change", function(){
		if(this.checked){
			$("txtAsOfDate").clear();
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtAsOfDate").disabled = false;
			$("txtFromDate").disabled = true;
			$("txtToDate").disabled = true;
			enableDate("hrefAsOfDate");
			disableDate("hrefFromDate");
			disableDate("hrefToDate");			
			$("txtAsOfDate").value = getCurrentDate();
			$("txtAsOfDate").focus();
		}
	});
	
	$("rdoFrom").observe("change", function(){
		if(this.checked){
			$("txtAsOfDate").clear();
			$("txtFromDate").clear();
			$("txtToDate").clear();
			$("txtAsOfDate").disabled = true;
			$("txtFromDate").disabled = false;
			$("txtToDate").disabled = false;
			disableDate("hrefAsOfDate");
			enableDate("hrefFromDate");
			enableDate("hrefToDate");
			$("txtFromDate").focus();
		}
	});
	
	$("hrefFromDate").observe("click", function() {
		if ($("hrefFromDate").disabled == true) return;
		scwShow($('txtFromDate'),this, null);
	});
	$("hrefToDate").observe("click", function() {
		if($("hrefToDate").disabled == true) return;
		scwShow($('txtToDate'),this, null);
	});
	$("hrefAsOfDate").observe("click", function() {
		if ($("hrefAsOfDate").disabled == true) return;
		scwShow($('txtAsOfDate'),this, null);
	});
	
	$("txtFromDate").observe("focus", function(){
		if ($("hrefFromDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) : "";
		var sysdate = new Date();
		if (fromDate > sysdate && fromDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("To Date should not be less than the From Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	$("txtToDate").observe("focus", function(){
		if ($("hrefToDate").disabled == true) return;
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (toDate > sysdate && toDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("To Date should not be less than the From Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	$("txtAsOfDate").observe("focus", function(){
		if ($("hrefAsOfDate").disabled == true) return;
		var asOfDate = $F("txtAsOfDate") != "" ? new Date($F("txtAsOfDate").replace(/-/g,"/")) :"";
		var sysdate = new Date();
		if (asOfDate > sysdate && asOfDate != ""){
			customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOfDate");
			$("txtAsOfDate").clear();
			return false;
		}		
	});
	
	populateFields();	
	
	$("txtClmLineCd").focus();
</script>