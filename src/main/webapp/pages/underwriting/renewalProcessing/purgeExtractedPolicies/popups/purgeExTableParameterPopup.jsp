<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="dateDiv" name="dateDiv" class="sectionDiv" style="margin-top: 5px; margin-bottom: 3px; width: 585px; padding: 10px;">
	<table style="float: left;">
		<tr>
			<td style="text-align: right;" colspan="4">
				<input title="By Month/Year" type="radio" id="byMonthYear" name="sortBy" value="byMonth" style="margin: 0 5px 0 5px; float: left;"><label for="byMonthYear">By Month/Year</label>
			</td>
		</tr>
		<tr style="margin: none;">
			<td style="width: 30px;"><td>
			<td style="text-align: right;">From</td>
			<td>
				<select id="fromMonth" name="byMY" style="width: 100px;">
					<option value=""></option>
					<option value="JAN">January</option>
					<option value="FEB">February</option>
					<option value="MAR">March</option>
					<option value="APR">April</option>
					<option value="MAY">May</option>
					<option value="JUN">June</option>
					<option value="JUL">July</option>
					<option value="AUG">August</option>
					<option value="SEP">September</option>
					<option value="OCT">October</option>
					<option value="NOV">November</option>
					<option value="DEC">December</option>
				</select>
			</td>
			<td>
				<input id="fromYear" name="byMY" type="text" style="width: 30px; margin-bottom: 4px;" value="${fromYear}">
			</td>
		</tr>
		<tr style="margin: none;">
			<td style="width: 30px;"><td>
			<td style="text-align: right;">To</td>
			<td>
				<select id="toMonth" name="byMY" style="width: 100px;">
					<option value=""></option>
					<option value="JAN">January</option>
					<option value="FEB">February</option>
					<option value="MAR">March</option>
					<option value="APR">April</option>
					<option value="MAY">May</option>
					<option value="JUN">June</option>
					<option value="JUL">July</option>
					<option value="AUG">August</option>
					<option value="SEP">September</option>
					<option value="OCT">October</option>
					<option value="NOV">November</option>
					<option value="DEC">December</option>
				</select>
			</td>
			<td>
				<input id="toYear" name="byMY" type="text" style="width: 30px; margin-bottom: 4px;" value="${toYear}">
			</td>
		</tr>
	</table>
	<table style="float: left; margin-left: 10px; margin-right: 20px;">
		<tr>
			<td style="text-align: right;" colspan="3">
				<input title="By Date" type="radio" id="byDate" name="sortBy" value="byDate" style="margin: 0 5px 0 5px; float: left;"><label for="byDate">By Date</label>
			</td>
		</tr>
		<tr>
			<td style="width: 30px;"></td>
			<td style="text-align: right; padding-left: 5px;">From</td>
			<td>
				<div style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px;">
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none;" name="fromDate" id="fromDate" readonly="readonly" disabled="disabled" value="${fromDate}"/>
					<img id="imgFmDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('fromDate'),this, null);"/>						
				</div>
			</td>
		</tr>
		<tr>
			<td style="width: 30px;"></td>
			<td style="text-align: right; padding-left: 5px;">To</td>
			<td>
				<div style="float: left; border: solid 1px gray; width: 140px; height: 20px; margin-right: 3px; margin-top: 5px;">
					<input type="text" style="float: left; margin-top: 0px; margin-right: 3px; width: 74%; border: none;" name="toDate" id="toDate" readonly="readonly" disabled="disabled" value="${toDate}"/>
					<img id="imgToDate" alt="goPolicyNo" style="margin-top: 1px; margin-left: 1px;" class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif"  onClick="scwShow($('toDate'),this, null);"/>						
				</div>
			</td>
		</tr>
	</table>
	<div id="rangeDiv" name="rangeDiv" class="sectionDiv" style="width: 115px; height: 70px; float: left;">
		<table>
			<tr>
				<td style="padding-top: 10px;">
					<input title="On or Before" type="radio" id="onOrBefore" name="data" value="onBefore" style="margin: 0 5px 5px 5px; float: left;" ><label for="onOrBefore">On or Before</label>
				</td>
			</tr>
			<tr>
				<td style="padding-top: 10px;">
					<input title="Exact Range" type="radio" id="exactRange" name="data" value="exact" style="margin: 0 5px 0 5px; float: left;" checked="checked"><label for="exactRange">Exact Range</label>
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="bottomDiv" name="bottomDiv" class="sectionDiv" style="width: 605px;">
	<div id="parametersDiv" name="parametersDiv" style="width: 100%; padding: 10px 0 10px 0" align="center">
		<table>
			<tr>
				<td class="rightAligned">Line Code</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 53px; margin-right: 2px;">
						<input id="lineCd" name="lineCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 25px; height: 13px; margin: 0px;" value="" tabindex="201">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lineCdLOV" name="lineCdLOV" alt="Go" style="float: right;"/>
					</span>
					<input id="lineName" name="lineName" type="text" style="width: 272px; height: 14px; float: left; margin: 0px;" readonly="readonly" value="${lineName}" onfocus="this.blur()">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Subline Code </td>
				<td>
					<span class="lovSpan" style="width: 78px; margin-right: 2px;">
						<input id="sublineCd" name="sublineCd" class="leftAligned upper" type="text" style="border: none; float: left; width: 50px; height: 13px; margin: 0px;" value="" tabindex="202">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="sublineCdLOV" name="sublineCdLOV" alt="Go" style="float: right;"/>
					</span>
					<input id="sublineName" name="sublineName" type="text" style="width: 247px; height: 14px; float: left; margin: 0px;" readonly="readonly" value="${sublineName}" onfocus="this.blur()">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Branch Code </td>
				<td>
					<span class="lovSpan" style="width: 53px; margin-right: 2px;">
						<input id="issCd" name="issCd" type="text" class="leftAligned upper" style="border: none; float: left; width: 25px; height: 13px; margin: 0px;" value="" tabindex="203">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="issCdLOV" name="issCdLOV" alt="Go" style="float: right;"/>
					</span>
					<input id="issName" name="issName" type="text" style="width: 272px; height: 14px; float: left; margin: 0px;" readonly="readonly" value="${issName}" onfocus="this.blur()">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Intermediary </td>
				<td>
					<span class="lovSpan" style="width: 100px; margin-right: 2px;">
						<input id="intmNo" name="intmNo" type="text" style="border: none; float: left; width: 70px; height: 13px; margin: 0px;" value="${intmNo}" class="integerNoNegativeUnformatted" tabindex="204">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="intmNoLOV" name="intmNoLOV" alt="Go" style="float: right;"/>
					</span>
					<input id="intmName" name="intmName" type="text" style="width: 225px; height: 14px; float: left; margin: 0px;" readonly="readonly" value="${intmName}" onfocus="this.blur()">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Policy No </td>
				<td>
					<input id="polLineCd" name="polLineCd" class="leftAligned upper" type="text" style="width: 40px; height: 14px; float: left; margin: 0px; margin-right: 2px;" maxlength="2" value="" tabindex="205">
					<input id="polSublineCd" name="polSublineCd" class="leftAligned upper" type="text" style="width: 60px; height: 14px; float: left; margin: 0px; margin-right: 2px;" maxlength="7" value="" tabindex="206">
					<input id="polIssCd" name="polIssCd" class="leftAligned upper" type="text" style="width: 40px; height: 14px; float: left; margin: 0px; margin-right: 2px;" maxlength="2" value="" tabindex="207">
					<input id="polIssueYy" name="polIssueYy" type="text" style="width: 40px; height: 14px; float: left; margin: 0px; margin-right: 2px;" maxlength="2" value="" class="integerNoNegativeUnformatted" tabindex="208">
					<input id="polSeqNo" name="polSeqNo" type="text" style="width: 60px; height: 14px; float: left; margin: 0px; margin-right: 2px;" maxlength="7" value="" class="integerNoNegativeUnformatted" tabindex="209">
					<input id="polRenewNo" name="polRenewNo" type="text" style="width: 39px; height: 14px; float: left; margin: 0px;" maxlength="2" value="" class="integerNoNegativeUnformatted" tabindex="210">
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" name="buttonsDiv" style="margin: 5px 0 10px 0" align="center">
		<input type="button" class="button" id="btnOk" name="btnOk" value="Ok" style="width: 120px;" tabindex="301">
		<input type="button" class="button" id="btnCancel" name="btnCancel" value="Cancel" style="width: 120px;" tabindex="302">
		<input type="button" class="button" id="btnClear" name="btnClear" value="Clear" style="width: 120px;" tabindex="303">
	</div>
</div>

<script type="text/javascript">
	makeInputFieldUpperCase();
	observeBackSpaceOnDate("fromDate"); //marco - 02.07.2013
	observeBackSpaceOnDate("toDate");	//

	$("lineCd").focus();
	$("fromMonth").value = '${fromMonth}';
	$("toMonth").value = '${toMonth}';
	
	$("toMonth").disable();
	$("toYear").disable();
	$("fromDate").disable();
	$("toDate").disable();
	$("imgFmDate").hide();
	$("imgToDate").hide();
	$("toDate").setStyle('width : 134px');
	$("fromDate").setStyle('width : 134px');
	
	if('${range}' == 'onBeforeMonth'){
		$("onOrBefore").checked = true;
		$("byMonthYear").checked = true;
	}else if('${range}' == 'onBeforeDate'){
		$("onOrBefore").checked = true;
		$("byDate").checked = true;
		$("fromMonth").disable();
		$("fromYear").disable();
		$("fromDate").enable();
		$("fromDate").setStyle('width : 111px');
 		$("imgFmDate").show();
	}else if('${range}' == 'exactMonth'){
		$("exactRange").checked = true;
		$("byMonthYear").checked = true;
		$("toMonth").enable();
		$("toYear").enable();
	}else if('${range}' == 'exactDate'){
		$("exactRange").checked = true;
		$("byDate").checked = true;
		$("fromMonth").disable();
		$("fromYear").disable();
		$("fromDate").enable();
		$("toDate").enable();
		$("fromDate").setStyle('width : 111px');
		$("imgFmDate").show();
		$("toDate").setStyle('width : 111px');
	 	$("imgToDate").show();
	}
	
	if($("individualParam").value == 'N'){
		$("lineCd").value = '${lineCd}';
		$("sublineCd").value = '${sublineCd}';
		$("issCd").value = '${issCd}';
		$("lineName").value = '${lineName}';
		$("sublineName").value = '${sublineName}';
		$("issName").value = '${issName}';
		disableIndividualParams();
	}else if($("individualParam").value == 'Y'){
		$("polLineCd").value = '${lineCd}';
		$("polSublineCd").value = '${sublineCd}';
		$("polIssCd").value = '${issCd}';
		$("polIssueYy").value = $("issueYyParam").value;
		$("polSeqNo").value = $("polSeqNoParam").value;
		$("polRenewNo").value = $("renewNoParam").value;
		disableGroupParams();
	}
	
	$("byDate").observe("click", function(){
		$("fromDate").enable();
 		$("fromMonth").disable();
 		$("fromYear").disable();
 		$("fromMonth").value = "";
 		$("fromYear").value = "";
 		$("fromDate").setStyle('width : 111px');
 		$("imgFmDate").show();
 		$("toMonth").disable();
 		$("toYear").disable();
 		$("toMonth").value = "";
 		$("toYear").value = "";
 		if($("exactRange").checked){
 	 		$("toDate").enable();
 	 		$("toDate").setStyle('width : 111px');
 	 		$("imgToDate").show();
 		}
	});
	
	$("byMonthYear").observe("click", function(){
		$("fromDate").disable();
		$("fromDate").value = "";
 		$("fromMonth").enable();
 		$("fromYear").enable();
 		$("toDate").setStyle('width : 134px');
 		$("fromDate").setStyle('width : 134px');
 		$("imgFmDate").hide();
 		$("imgToDate").hide();
 		$("toDate").disable();
 		$("toDate").value = "";
 		if($("exactRange").checked){
 			$("toMonth").enable();
 			$("toYear").enable();
 		}
	});
	
	$("onOrBefore").observe("click", function(){
		if($("byMonthYear").checked){
			$("toMonth").disable();
	 		$("toYear").disable();
	 		$("fromMonth").value = "";
	 		$("fromYear").value = "";
	 		$("toMonth").value = "";
	 		$("toYear").value = "";
		}else{
			$("fromDate").value = "";
			$("toDate").disable();
			$("toDate").value = "";
			$("toDate").setStyle('width : 134px');
			$("imgToDate").hide();
		}
	});
	
	$("fromMonth").observe("change", function(){
		if($F("fromYear") != "" && $F("toMonth") != "" && $F("toYear") != ""){
			if(Date.parse("01-"+$F("toMonth")+"-"+$F("toYear")) < Date.parse("01-"+$F("fromMonth")+"-"+$F("fromYear"))){
				clearFocusElementOnError("fromMonth", "To month and year cannot be earlier than from month and year.");
			}
		}
	});
	
	$("fromYear").observe("change", function(){
		if($F("fromYear") != "" && ($F("fromYear").length != 4 || isNaN($F("fromYear")) || $F("fromYear") <= 0)){
			clearFocusElementOnError("fromYear", "Invalid Year.");
		}else if($F("fromMonth") != "" && $F("toMonth") != "" && $F("toYear") != ""){
			if(Date.parse("01-"+$F("toMonth")+"-"+$F("toYear")) < Date.parse("01-"+$F("fromMonth")+"-"+$F("fromYear"))){
				clearFocusElementOnError("fromYear", "To month and year cannot be earlier than from month and year.");
			}
		}
	});
	
	$("toMonth").observe("change", function(){
		if($F("fromMonth") != "" && $F("fromYear") != "" && $F("toYear") != ""){
			if(Date.parse("01-"+$F("toMonth")+"-"+$F("toYear")) < Date.parse("01-"+$F("fromMonth")+"-"+$F("fromYear"))){
				clearFocusElementOnError("toMonth", "To month and year cannot be earlier than from month and year.");
			}
		}
	});
	
	$("toYear").observe("change", function(){
		if($F("toYear") != "" && ($F("toYear").length != 4 || isNaN($F("toYear")) || $F("toYear") <= 0)){
			clearFocusElementOnError("toYear", "Invalid Year.");
		}else if($F("fromMonth") != "" && $F("fromYear") != "" && $F("toMonth") != ""){
			if(Date.parse("01-"+$F("toMonth")+"-"+$F("toYear")) < Date.parse("01-"+$F("fromMonth")+"-"+$F("fromYear"))){
				clearFocusElementOnError("toYear", "To month and year cannot be earlier than from month and year.");
			}
		}
	});
	
	$("fromDate").observe("focus", function(){
		if($F("fromDate") != "" && $F("toDate") != "" && Date.parse($("fromDate").value) > Date.parse($("toDate").value)){
			clearFocusElementOnError("fromDate", "To date should not be earlier than from date.");
		}
	});
	
	$("toDate").observe("focus", function(){
		if($F("fromDate") != "" && $F("toDate") != "" && Date.parse($("fromDate").value) > Date.parse($("toDate").value)){
			clearFocusElementOnError("toDate", "To date should not be earlier than from date.");
		}
	});
	
	$("exactRange").observe("click", function(){
		if($("byMonthYear").checked){
			$("fromMonth").value = "";
			$("fromYear").value = "";
			$("toMonth").enable();
 			$("toYear").enable();
		}else{
			$("fromDate").value = "";
			$("toDate").enable();
 	 		$("toDate").setStyle('width : 111px');
 	 		$("imgToDate").show();
		}
	});
	
	$("btnOk").observe("click", filterByParameters);
	
	function filterByParameters(){
		var policyNo = "";
		var individual = "";
		var proceed = false;
		var isBasedOnParam = false;
		
		if($("fromMonth").value == "" && $("fromYear").value == "" &&
           $("toMonth").value == "" && $("toYear").value == "" &&
           $("fromDate").value == "" && $("toDate").value == "" &&
           $("lineCd").value == "" && $("sublineCd").value == "" &&
           $("issCd").value == "" && $("intmNo").value == "" &&
           $("polLineCd").value == "" && $("polSublineCd").value == "" &&
           $("polIssCd").value == "" && $("polIssueYy").value == "" &&
           $("polSeqNo").value == "" && $("polRenewNo").value == ""){
			isBasedOnParam = false;
			proceed = checkDateParams(false);
		}else{
			if($("polLineCd").value == "" && $("polSublineCd").value == "" &&
			   $("polIssCd").value == "" && $("polIssueYy").value == "" &&
			   $("polSeqNo").value == "" && $("polRenewNo").value == ""){
				isBasedOnParam = true;
				individual = "N";
				proceed = checkDateParams(true);
			}else{
				if($("polLineCd").value == "" || $("polSublineCd").value == "" ||
				   $("polIssCd").value == "" || $("polIssueYy").value == "" ||
				   $("polSeqNo").value == "" || $("polRenewNo").value == ""){
					showMessageBox("Please complete the policy no.", imgMessage.ERROR);
				}else{
					policyNo = $("polLineCd").value+"-"+$("polSublineCd").value+"-"+$("polIssCd").value+"-"+$("polIssueYy").value+
								"-"+$("polSeqNo").value+"-"+$("polRenewNo").value;
					isBasedOnParam = true;
					individual = "Y";
					proceed = checkDateParams(true);
				}
			}
		}
		
		if(proceed == true){
			var lineCd = $("lineCd").value == "" ? $("polLineCd").value : $("lineCd").value;
			var sublineCd = $("sublineCd").value == "" ? $("polSublineCd").value : $("sublineCd").value;
			var issCd = $("issCd").value == "" ? $("polIssCd").value : $("issCd").value;
			var range = "";
			
			if($("fromMonth").value == "" && $("fromYear").value == "" &&
	           $("toMonth").value == "" && $("toYear").value == "" &&
	           $("fromDate").value == "" && $("toDate").value == ""){
				$("notTime").value = "notTime";
			}else{
				$("notTime").value = "withTime";
			}
			
			if($("onOrBefore").checked){
				$("rangeType").value = "onOrBefore";
			}else{
				$("rangeType").value = "exactRange";
			}
			if($("byMonthYear").checked){
				$("range").value = "byMonthYear";
				$("fromMonthParam").value = $("fromMonth").value;
				$("fromYearParam").value = $("fromYear").value;
				$("toMonthParam").value = $("toMonth").value;
				$("toYearParam").value = $("toYear").value;
				if($("rangeType").value == "onOrBefore"){
					range = "onBeforeMonth";
				}else{
					range = "exactMonth";
				}
			}else{
				$("range").value = "byDate";
				$("fromDateParam").value = $("fromDate").value;
				$("toDateParam").value = $("toDate").value;
				if($("rangeType").value == "onOrBefore"){
					range = "onBeforeDate";
				}else{
					range = "exactDate";
				}
			}
			$("basedOnParam").checked = isBasedOnParam;
			$("lineCdParam").value = lineCd;
			$("sublineCdParam").value = sublineCd;
			$("issCdParam").value = issCd;
			$("issueYyParam").value = $("polIssueYy").value;
			$("polSeqNoParam").value = $("polSeqNo").value;
			$("renewNoParam").value = $("polRenewNo").value;
			$("intmNoParam").value = $("intmNo").value;
			$("lineNameParam").value = $("lineName").value;
			$("sublineNameParam").value = $("sublineName").value;
			$("issNameParam").value = $("issName").value;
			$("intmNameParam").value = $("intmName").value;
			$("fromMonthParam").value = $("fromMonth").value;
			$("fromYearParam").value = $("fromYear").value;
			$("fromDateParam").value = $("fromDate").value;
			$("toMonthParam").value = $("toMonth").value;
			$("toYearParam").value = $("toYear").value;
			$("toDateParam").value = $("toDate").value;
			$("rangeParam").value = range;
			$("individualParam").value = individual;
			
			purgeExtractTableGrid.url = contextPath + "/GIEXExpiriesVController?action=getPurgeExtractTable&refresh=1&intmNo="+$("intmNo").value+
														"&lineCd="+lineCd+"&sublineCd="+sublineCd+"&issCd="+issCd+"&policyNo="+policyNo+
														"&issueYy="+$("polIssueYy").value+"&polSeqNo="+$("polSeqNo").value+"&renewNo="+$("polRenewNo").value+
														"&fromMonth="+$("fromMonth").value+"&fromYear="+$("fromYear").value+"&toMonth="+$("toMonth").value+
														"&toYear="+$("toYear").value+"&fromDate="+$("fromDate").value+"&toDate="+$("toDate").value+"&range="+range;
			purgeExtractTableGrid._refreshList();
			purgeExTableParams.close();
		}
	}
	
	function checkDateParams(toCheck){
		var proceed = true;
		
		if(toCheck){
			if($("exactRange").checked){
				if($("byMonthYear").checked){
					/* if($("fromMonth").value == "" || $("fromYear").value == "" ||
					   $("toMonth").value == "" || $("toYear").value == ""){
						showMessageBox("Please complete the chosen date parameters.", imgMessage.ERROR);
						proceed = false;
					} */ //relaced by marco - 02.07.2013
					
					if(!checkMonthYearFields()){
						showMessageBox("Please complete the chosen date parameters.", imgMessage.ERROR);
						proceed = false;
					}
				}else if($("byDate").checked){
					/* if($("fromDate").value == "" || $("toDate").value == ""){
						showMessageBox("Please complete the chosen date parameters.", imgMessage.ERROR);
						proceed = false;
					} */ //replaced by marco - 02.07.2013
					
					if(($("fromDate").value != "" && $("toDate").value == "") ||
					   ($("fromDate").value == "" && $("toDate").value != "")){
						showMessageBox("Please complete the chosen date parameters.", imgMessage.ERROR);
						proceed = false;
					}
				}
			}else{
				if($("byMonthYear").checked){
					if(($("fromMonth").value == "" && $("fromYear").value != "") || ($("fromMonth").value != "" && $("fromYear").value == "")){
						showMessageBox("Please complete the chosen date parameters.", imgMessage.ERROR);
						proceed = false;
					}
				}
			}
		}
		return proceed;
	}
	
	//marco - 02.07.2013 - check date fields
	function checkMonthYearFields(){
		var count = 0;
		$$("input[name='byMY']").each(function(input) {
			if(input.value != ""){
				count++;
			}
		});
		$$("select[name='byMY']").each(function(select) {
			if(select.value != ""){
				count++;
			}
		});
		if(count == 0 || count == 4){
			return true;
		}
		return false;
	}
	
	function disableParams(){
		if($F("lineCd") != "" || $F("sublineCd") != "" ||
		   $F("issCd") != "" || $F("intmNo") != ""){
			disableIndividualParams();
		}else if($F("polLineCd") != "" || $F("polSublineCd") != ""||
				 $F("polIssCd") != "" || $F("polIssueYy") != ""||
				 $F("polSeqNo") != "" || $F("polRenewNo") != ""){
			disableGroupParams();
		}else{
			$("polLineCd").enable();
			$("polSublineCd").enable();
			$("polIssCd").enable();
			$("polIssueYy").enable();
			$("polSeqNo").enable();
			$("polRenewNo").enable();
			
			$("lineCd").enable();
			$("sublineCd").enable();
			$("issCd").enable();
			$("intmNo").enable();
			$("lineName").enable();
			$("sublineName").enable();
			$("issName").enable();
			$("intmName").enable();
			
			$("lineCdLOV").show();
			$("lineCd").setStyle('width : 25px');
			$("sublineCdLOV").show();
			$("sublineCd").setStyle('width : 50px');
			$("issCdLOV").show();
			$("issCd").setStyle('width : 25px');
			$("intmNoLOV").show();
			$("intmNo").setStyle('width : 70px');
		}
	}
	
	$("btnCancel").observe("click", function(){
		purgeExTableParams.close();
	});
	
	$("btnClear").observe("click", function(){
		$("onOrBefore").click();
		$("byMonthYear").click();
		$("onOrBefore").checked = true;
		$("fromMonth").value = "";
		$("fromYear").value = "";
		$("toMonth").value = "";
		$("toYear").value = "";
		$("fromDate").value = "";
		$("toDate").value = "";
		$("lineCd").value = "";
		$("lineName").value = "";
		$("sublineCd").value = "";
		$("sublineName").value = "";
		$("issCd").value = "";
		$("issName").value = "";
		$("intmNo").value = "";
		$("intmName").value = "";
		$("polLineCd").value = "";
		$("polSublineCd").value = "";
		$("polIssCd").value = "";
		$("polIssueYy").value = "";
		$("polSeqNo").value = "";
		$("polRenewNo").value = "";
		disableParams();
	});
	
	$("polLineCd").observe("change", function(){
		disableParams();
	});
	
	$("polSublineCd").observe("change", function(){
		disableParams();
	});
	
	$("polIssCd").observe("change", function(){
		disableParams();
	});
	
	$("polIssueYy").observe("change", function(){
		$("polIssueYy").value = $F("polIssueYy") != "" ? Number($F("polIssueYy")).toPaddedString(2) : "";
		if($F("polIssueYy") != "" && isNaN(parseInt($F("polIssueYy"))) || parseInt($F("polIssueYy")) < 0){
			clearFocusElementOnError("polIssueYy", "Invalid Number Format.");
		}
		disableParams();
	});	
	
	$("polSeqNo").observe("change", function(){
		$("polSeqNo").value = $F("polSeqNo") != "" ? Number($F("polSeqNo")).toPaddedString(7) : "";
		if($F("polSeqNo") != "" && isNaN(parseInt($F("polSeqNo"))) || parseInt($F("polSeqNo")) < 0){
			clearFocusElementOnError("polSeqNo", "Invalid Number Format.");
		}
		disableParams();
	});
	
	$("polRenewNo").observe("change", function(){
		$("polRenewNo").value = $F("polRenewNo") != "" ? Number($F("polRenewNo")).toPaddedString(2) : "";
		if($F("polRenewNo") != "" && isNaN(parseInt($F("polRenewNo"))) || parseInt($F("polRenewNo")) < 0){
			clearFocusElementOnError("polRenewNo", "Invalid Number Format.");
		}
		disableParams();
	});	
	
	$("lineCdLOV").observe("click", function(){
		showLineCdLOV();
	});
	
	$("sublineCdLOV").observe("click", function(){
		showSublineCdLOV();
	});
	
	$("issCdLOV").observe("click", function(){
		showIssCdLOV();
	});
	
	$("intmNoLOV").observe("click", function(){
		showIntmNoLOV();
	});
	
	function disableGroupParams(){
		$("lineCd").disable();
		$("sublineCd").disable();
		$("issCd").disable();
		$("intmNo").disable();
		$("lineName").disable();
		$("sublineName").disable();
		$("issName").disable();
		$("intmName").disable();
		
		$("lineCdLOV").hide();
		$("lineCd").setStyle('width : 47px');
		$("sublineCdLOV").hide();
		$("sublineCd").setStyle('width : 72px');
		$("issCdLOV").hide();
		$("issCd").setStyle('width : 47px');
		$("intmNoLOV").hide();
		$("intmNo").setStyle('width : 94px');
	}
	
	function disableIndividualParams(){
		$("polLineCd").disable();
		$("polSublineCd").disable();
		$("polIssCd").disable();
		$("polIssueYy").disable();
		$("polSeqNo").disable();
		$("polRenewNo").disable();
	}
	
	$("lineCd").observe("change", function(){
		if($("lineCd").value != ""){
			showLineCdLOV();	
		}else{
			$("lineName").value = "";
			$("lineCd").setAttribute("lastValidValue", "");
			disableParams();
		}
	});
	
	$("sublineCd").observe("change", function(){
		if($("sublineCd").value != ""){
			showSublineCdLOV();
		}else{
			$("sublineName").value = "";
			$("sublineCd").setAttribute("lastValidValue", "");
			disableParams();
		}
	});
	
	$("issCd").observe("change", function(){
		if($("issCd").value != ""){
			showIssCdLOV();
		}else{
			$("issName").value = "";
			$("issCd").setAttribute("lastValidValue", "");
			disableParams();
		}
	});
	
	$("intmNo").observe("change", function(){
		if($F("intmNo") != "" && isNaN(parseInt($F("intmNo"))) || parseInt($F("intmNo")) < 0){
			clearFocusElementOnError("intmNo", "Invalid Intermediary No. Format.");
		}else{
			if($("intmNo").value != ""){
				showIntmNoLOV();
			}else{
				$("intmName").value = "";
				$("intmNo").setAttribute("lastValidValue", "");
				disableParams();
			}
		}
	});
	
	function validatePurgeLineCd(){
		new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
			method: "GET",
			parameters: {action      : "validateLineCd",
						 lineCd	     : $("lineCd").value,
						 sublineCd   : $("sublineCd").value,
						 issCd	     : $("issCd").value,
						 sublineName : $("sublineName").value},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.found == "Y"){
						$("lineName").value = obj.lineName;
						$("sublineCd").value = obj.sublineCd;
						$("sublineName").value = obj.sublineName;
					}else{
						$("lineName").value = "";
						$("sublineCd").value = obj.sublineCd;
						showLineCdLOV();
					}
				}
			}
		});
	}
	
	function validatePurgeSublineCd(){
		new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
			method: "GET",
			parameters: {action    : "validateSublineCd",
						 lineCd	   : $F("lineCd"),
						 sublineCd : $F("sublineCd")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.sublineName == null){
						$("sublineName").value = "";
						clearFocusElementOnError("sublineCd", "Subline code does not exist in table GIIS_SUBLINE.");
					}else{
						$("sublineName").value = obj.sublineName;
					}
				}
			}
		});
	}
	
	function validatePurgeIssCd(){
		new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
			method: "GET",
			parameters: {action    : "validateIssCd",
						 issCd	   : $F("issCd"),
						 lineCd    : $F("lineCd")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.issRi == "N"){
						clearFocusElementOnError("issCd", "Inward Reinsurance cannot be processed for expiry.");
						$("issName").value = "";
					}else{
						if(obj.issName == null){
							$("issName").value = "";
							clearFocusElementOnError("issCd", "Issuing code does not exist in table GIIS_ISSOURCE.");
						}else{
							$("issName").value = obj.issName;
						}
					}
				}
			}
		});
	}
	
	function validatePurgeIntmNo(){
		new Ajax.Request(contextPath+"/GIEXExpiriesVController", {
			method: "GET",
			parameters: {action    : "validateIntmNo",
						 intmNo	   : $F("intmNo")},
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var obj = JSON.parse(response.responseText);
					if(obj.intmName == null){
						$("intmName").value = "";
						clearFocusElementOnError("intmNo", "Intermediary No. does not exist in the table GIIS_INTERMEDIARY.");
					}else{
						$("intmName").value = obj.intmName;
					}
				}
			}
		});
	}
	
	function showLineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getAllLineLOV",
								issCd: $("issCd").value,
								moduleId: "GIEXS003",
								filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%"
							   },
				title: "List of Lines",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "lineCd",
									title: "Line Cd",
									width: '80px'
								},
								{	id : "lineName",
									title: "Line Name",
									width: '308px'
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				noticeMessage: "Getting list, please wait...",
				filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
				onSelect : function(row){
					if(row != undefined) {
						$("lineCd").value = unescapeHTML2(row.lineCd);
						$("lineName").value = unescapeHTML2(row.lineName);
						$("sublineCd").value = "";
						$("sublineName").value = "";
						disableParams();
						$("lineCd").setAttribute("lastValidValue", $F("lineCd"));
						$("sublineCd").setAttribute("lastValidValue", "");
					}
				},
				onCancel: function(){
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					disableParams();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					disableParams();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showLineCdLOV",e);
		}
	}
	
	function showSublineCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getGiexs003SublineLOV",
								lineCd: $("lineCd").value,
								filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%"
							   },
				title: "List of Sublines",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "sublineCd",
									title: "Subline Cd",
									width: '80px'
								},
								{	id : "sublineName",
									title: "Subline Name",
									width: '308px'
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				noticeMessage: "Getting list, please wait...",
				filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%",
				onSelect : function(row){
					if(row != undefined) {
						$("sublineCd").value = unescapeHTML2(row.sublineCd);
						$("sublineName").value = unescapeHTML2(row.sublineName);
						disableParams();
						$("sublineCd").setAttribute("lastValidValue", $F("sublineCd"));
					}
				},
				onCancel: function(){
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					disableParams();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					disableParams();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showSublineCdLOV",e);
		}
	}
	
	function showIssCdLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getIssCdNameLOV",
								lineCd: $("lineCd").value,
								moduleId: "GIEXS003",
								filterText: $F("issCd") != $("issCd").getAttribute("lastValidValue") ? nvl($F("issCd"), "%") : "%"
							   },
				title: "List of Branches",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "issCd",
									title: "Iss Cd",
									width: '80px'
								},
								{	id : "issName",
									title: "Iss Name",
									width: '308px'
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				noticeMessage: "Getting list, please wait...",
				filterText: $F("issCd") != $("issCd").getAttribute("lastValidValue") ? nvl($F("issCd"), "%") : "%",
				onSelect : function(row){
					if(row != undefined) {
						$("issCd").value = unescapeHTML2(row.issCd);
						$("issName").value = unescapeHTML2(row.issName);
						disableParams();
						$("issCd").setAttribute("lastValidValue", $F("issCd"));
					}
				},
				onCancel: function(){
					$("issCd").value = $("issCd").getAttribute("lastValidValue");
					disableParams();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("issCd").value = $("issCd").getAttribute("lastValidValue");
					disableParams();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIssCdLOV",e);
		}
	}
	
	function showIntmNoLOV(){
		try{
			LOV.show({
				controller: "UnderwritingLOVController",
				urlParameters: {action: "getIntmCdNameLOV",
								filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%"
							   },
				title: "List of Intermediaries",
				width: 405,
				height: 386,
				columnModel:[
				             	{	id : "intmNo",
									title: "Intm. No.",
									width: '80px',
									type: 'number'
								},
								{	id : "intmName",
									title: "Name",
									width: '308px'
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				noticeMessage: "Getting list, please wait...",
				filterText: $F("intmNo") != $("intmNo").getAttribute("lastValidValue") ? nvl($F("intmNo"), "%") : "%",
				onSelect : function(row){
					if(row != undefined) {
						$("intmNo").value = row.intmNo;
						$("intmName").value = unescapeHTML2(row.intmName);
						disableParams();
						$("intmNo").setAttribute("lastValidValue", "");
					}
				},
				onCancel: function(){
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
					disableParams();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("intmNo").value = $("intmNo").getAttribute("lastValidValue");
					disableParams();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIntmNoLOV",e);
		}
	}

	// andrew - 12.10.2012 - set default
	/* $("exactRange").checked = true; 
	if($("byMonthYear").checked){
		$("fromMonth").value = "";
		$("fromYear").value = "";
		$("toMonth").enable();
		$("toYear").enable();
	}else{
		$("fromDate").value = "";
		$("toDate").enable();
 		$("toDate").setStyle('width : 111px');
 		$("imgToDate").show();
	}
	$("fromMonth").focus(); */
	// end andrew	
</script>