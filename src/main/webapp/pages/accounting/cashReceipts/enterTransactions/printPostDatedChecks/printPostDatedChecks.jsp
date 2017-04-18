<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="printDialogMainDiv" style="width: 99.5%; padding-top: 5px; float: left;" align="center">
	<div class="sectionDiv" style="float: left; width: 99.7%;" id="printDialogFormDiv">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned" colspan="1">Status</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan " style="width: 70px; height: 21px; margin: 2px 0 0 0; float: left;">
						<input type="text" id="txtStatus" name="txtStatus" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps " maxlength="3" tabindex="101" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchStatus" name="searchStatus" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtStatusDesc" name="txtStatusDesc" ignoreDelKey="1" style="width: 242px; float: left; height: 15px;" class="allCaps " maxlength="50" readonly="readonly" tabindex="102" value="ALL"/>
					</span>
				</td>
			</tr>
			<tr id="fromToDate">
				<td class="rightAligned">From</td>
				<td class="leftAligned">
					<div id="startDateDiv" class="required" style="float: left; border: 1px solid gray; width: 149px; height: 20px;">
						<input id="txtFromDate" name="From Date." readonly="readonly" type="text" class=" required date" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="103"/>
						<img id="imgFromDate" alt="imgFromDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtFromDate'),this, null);" />
					</div>
				</td>
				<td class="leftAligned">To</td>
				<td class="leftAligned">
					<div id="endDateDiv" class="" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
						<input id="txtToDate" name="To Date." readonly="readonly" type="text" class="required date" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="104"/>
						<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
					</div>
				</td>
			</tr>
			<tr id="cutOffDate">
				<td class="rightAligned">Cut-Off Date</td>
				<td class="leftAligned">
					<div id="endDateDiv" class="" style="float: left; border: 1px solid gray; width: 150px; height: 20px;">
						<input id="txtToDate" name="To Date." readonly="readonly" type="text" class="required date" maxlength="10" style="border: none; float: left; width: 125px; height: 13px; margin: 0px;" value="" tabindex="105"/>
						<img id="imgToDate" alt="imgToDate" style="margin-top: 1px; margin-left: 1px; class="hover" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('txtToDate'),this, null);" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" colspan="1">Branch</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan " style="width: 70px; height: 21px; margin: 2px 0 0 0; float: left;">
						<input type="text" id="txtBranchCdPrint" name="txtBranchCdPrint" ignoreDelKey="1" style="width: 43px; float: left; border: none; height: 13px;" class="disableDelKey allCaps " maxlength="3" tabindex="106" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBranchPrint" name="searchBranchPrint" alt="Go" style="float: right;">
					</span> 
					<span class="lovSpan " style="border: none; height: 21px; margin: 0 2px 0 2px; float: left;">
						<input type="text" id="txtBranchDescPrint" name="txtBranchDescPrint" ignoreDelKey="1" style="width: 242px; float: left; height: 15px;" class="allCaps " maxlength="50" readonly="readonly" tabindex="107" value="ALL BRANCHES" />
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" id="printDialogFormDiv" style="width: 39%; float: left;">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 23.5px;">
			<tr>
				<td></td>
				<td class="rightAligned">
					<input type="radio" name="searchBy" id="rdoCheckDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="201" checked="checked"/>
					<label for="rdoCheckDate" style="float: left; height: 20px; padding-top: 3px;" title="Check Date">Check Date</label>
				</td>
				<td></td>
			</tr>
			<tr>
				<td></td>
				<td class="rightAligned">
					<input type="radio" name="searchBy" id="rdoOrDate" style="float: left; margin: 3px 2px 3px 30px;" tabindex="202"/>
					<label for="rdoOrDate" style="float: left; height: 20px; padding-top: 3px;" title="OR Date">OR Date</label>
				</td>
				<td></td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" id="printDialogFormDiv" style="width: 60%; float: left; margin-left: 1px;">
		<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="padding: 10px;">
			<tr>
				<td class="rightAligned">Destination</td>
				<td class="leftAligned">
					<select id="selDestination" style="width: 173px;">
						<option value="screen">Screen</option>
						<option value="printer">Printer</option>
						<option value="file">File</option>
						<option value="local">Local Printer</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Printer</td>
				<td class="leftAligned">
					<select id="selPrinter" style="width: 173px;" class="required">
						<option></option>
						<c:forEach var="p" items="${printers}">
							<option value="${p.name}">${p.name}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">No. of Copies</td>
				<td class="leftAligned">
					<input type="text" id="txtNoOfCopies" maxlength="3" style="float: left; text-align: right; width: 149px;" class="required integerNoNegativeUnformattedNoComma" lastValidValue="">
					<div style="float: left; width: 15px;">
						<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;">
						<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;">
						<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;">
						<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;">
					</div>					
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonsDiv" style="float: left; width: 100%; margin-top: 10px; margin-bottom: 5px;">
		<input type="button" class="button" id="btnPrintGiacs283" name="btnPrintGiacs283" value="Print" style="width: 80px;">
		<input type="button" class="button" id="btnPrintCancel" name="btnPrintCancel" value="Cancel">		
	</div>	
</div>
<script type="text/javascript">
	initializeAll();
	$("cutOffDate").hide();
	
	function toggleRequiredFields(dest){
		if(dest == "printer"){			
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
		} else {
			$("selPrinter").value = "";
			$("txtNoOfCopies").value = "";
			$("selPrinter").disabled = true;
			$("txtNoOfCopies").disabled = true;
			$("selPrinter").removeClassName("required");
			$("txtNoOfCopies").removeClassName("required");
			$("imgSpinUp").hide();
			$("imgSpinDown").hide();
			$("imgSpinUpDisabled").show();
			$("imgSpinDownDisabled").show();			
		}
	}
	
	$("btnPrintCancel").observe("click", function(){
		overlayPrintPostDatedChecks.close();
		delete overlayPrintPostDatedChecks;
	});
	
	$("imgSpinUp").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no < 100){ 
			$("txtNoOfCopies").value = no + 1;
		}
	});
	
	$("imgSpinDown").observe("click", function(){
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if(no > 1){
			$("txtNoOfCopies").value = no - 1;
		}
	});
	
	$("imgSpinUp").observe("mouseover", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});
	
	$("imgSpinDown").observe("mouseover", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});
	
	$("imgSpinUp").observe("mouseout", function(){
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});
	
	$("imgSpinDown").observe("mouseout", function(){
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});
	
	$("txtNoOfCopies").observe("focus", function(){
		$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue"); 
			});			
		}
	});
	
	$("selDestination").observe("change", function(){
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});	
	
	$("txtNoOfCopies").observe("focus", function(){
		$("txtNoOfCopies").setAttribute("lastValidValue", $F("txtNoOfCopies"));
	});
	
	$("txtNoOfCopies").observe("change", function(){
		if($F("txtNoOfCopies").trim() != "" && (isNaN($F("txtNoOfCopies")) || parseInt($F("txtNoOfCopies")) <= 0 || parseInt($F("txtNoOfCopies")) > 100)){
			showWaitingMessageBox("Invalid No. of Copies. Valid value should be from 1 to 100.", "I", function(){
				$("txtNoOfCopies").value = $("txtNoOfCopies").readAttribute("lastValidValue");
			});			
		}
	});
	
	toggleRequiredFields("screen");
	
	$("txtToDate").observe("focus", function(){
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtToDate");
			$("txtToDate").clear();
			return false;
		}
	});
	
	$("txtFromDate").observe("focus", function(){
		var toDate = $F("txtToDate") != "" ? new Date($F("txtToDate").replace(/-/g,"/")) :"";
		var fromDate = $F("txtFromDate") != "" ? new Date($F("txtFromDate").replace(/-/g,"/")) :"";
		if (toDate < fromDate && toDate != ""){
			customShowMessageBox("From Date should not be later than To Date.", "I", "txtFromDate");
			$("txtFromDate").clear();
			return false;
		}
	});
	
	$("searchBranchPrint").observe("click",function(){
		showBranchLOV();
	});
	
	function showBranchLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs032BranchCdLOV",
					  fundCd : $F("txtFundCd"),
					  filterText: $F("txtBranchCdPrint") != $("txtBranchCdPrint").getAttribute("lastValidValue") ? nvl(($F("txtBranchCdPrint")), "%") : "%",  
						page : 1
				},
				title: "List of Branches",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'branchCd',
						title: 'Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'branchName',
						title: 'Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: $F("txtBranchCdPrint") != $("txtBranchCdPrint").getAttribute("lastValidValue") ? nvl(($F("txtBranchCdPrint")), "%") : "%",  
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBranchCdPrint").value = unescapeHTML2(row.branchCd);
						$("txtBranchDescPrint").value = unescapeHTML2(row.branchName);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
					}
				},
				onCancel: function(){
					$("txtBranchCdPrint").value = $("txtBranchCdPrint").getAttribute("lastValidValue");
					$("txtBranchDescPrint").value = $("txtBranchDescPrint").getAttribute("lastValidValue");
					$("txtBranchCdPrint").focus();
					if($F("txtBranchCdPrint") == ""){
						$("txtBranchDescPrint").value = "ALL BRANCHES";
					} 
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBranchCdPrint").value = $("txtBranchCdPrint").getAttribute("lastValidValue");
					$("txtBranchDescPrint").value = $("txtBranchDescPrint").getAttribute("lastValidValue");
					if($F("txtBranchCdPrint") == ""){
						$("txtBranchDescPrint").value = "ALL BRANCHES";
					} 
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdPrint");
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchLOV",e);
		}
	}
	
	$("txtBranchCdPrint").observe("change", function(){
		if($F("txtBranchCdPrint") != ""){
			showBranchLOV();
		}  else {
			$("txtBranchDescPrint").value = "ALL BRANCHES";
		}
	});
	
	$("searchStatus").observe("click",function(){
		showStatusLOV();
	});
	
	function showStatusLOV(){
		try{
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					  action : "getGiacs283StatusLOV",
					  filterText: $F("txtStatus") != $("txtStatus").getAttribute("lastValidValue") ? nvl(($F("txtStatus")), "%") : "%",  
						page : 1
				},
				title: "List of Check Status",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'statusCd',
						title: 'Code',
						width : '100px',
						align: 'left'
					},
					{
						id : 'statusDesc',
						title: 'Desc',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				filterText: $F("txtStatus") != $("txtStatus").getAttribute("lastValidValue") ? nvl($F("txtStatus"), "%") : "%",  
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtStatus").value = unescapeHTML2(row.statusCd);
						$("txtStatusDesc").value = unescapeHTML2(row.statusDesc);
						enableToolbarButton("btnToolbarEnterQuery");
						enableToolbarButton("btnToolbarExecuteQuery");
						$("cutOffDate").show();
						$("fromToDate").hide();
					}
				},
				onCancel: function(){
					$("txtStatus").value = $("txtStatus").getAttribute("lastValidValue");
					$("txtStatusDesc").value = $("txtStatusDesc").getAttribute("lastValidValue");
					$("txtStatus").focus();
					if($F("txtStatus") == ""){
						$("txtStatusDesc").value = "ALL";
						$("cutOffDate").hide();
						$("fromToDate").show();
					} 
		  		},
		  		onUndefinedRow: function(){
		  			$("txtStatus").value = $("txtStatus").getAttribute("lastValidValue");
					$("txtStatusDesc").value = $("txtStatusDesc").getAttribute("lastValidValue");
					if($F("txtStatus") == ""){
						$("txtStatusDesc").value = "ALL";
						$("cutOffDate").hide();
						$("fromToDate").show();
					} 
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtStatus");
		  		}
			});
		}catch(e){
			showErrorMessage("showStatusLOV",e);
		}
	}
	
	$("txtStatus").observe("change", function(){
		if($F("txtStatus") != ""){
			showStatusLOV();
		}  else {
			$("txtStatusDesc").value = "ALL";
		}
	});
	
	$("btnPrintGiacs283").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("printDialogFormDiv")){
			alert()
		}
	});
</script>