<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="catastrophicEventReportMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="clmCatastrophicEventReportExit">Exit</a></li>
			</ul>
		</div>
	</div>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Outstanding and Paid Claims per Catastrophic Event</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	
	<div id="moduleDiv" class="sectionDiv">
		<div id="moduleSubDiv" class="sectionDiv" style="width:600px; margin: 50px 100px 50px 160px;">
			
			<div id="outstandingFieldsetDiv" style="float: left; margin: 10px 5px 5px 10px; width:290px;" >
				<fieldset>
					<legend style="margin-left: 5px;"><b>Outstanding</b></legend>
					<table style="height: 80px; margin: 10px 10px 10px 70px;" cellpadding="2" cellspacing="2">
						<tr>
							<td>
								<input type="radio" id="rdoLossDate" name="rdoGrpOutstanding" style="float: left; margin: 0 5px 2px 5px;" tabindex="101">
								<label id="lblRdoLossDate" for="rdoLossDate" style="float: left;">Loss Date</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoClmFileDate" name="rdoGrpOutstanding" style="float: left; margin: 0 5px 2px 5px;" tabindex="102">
								<label id="lblRdoClmFileDate" for="rdoClmFileDate" style="float: left;">Claim File Date</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoBookingMonth" name="rdoGrpOutstanding" style="float: left; margin: 0 5px 2px 5px;"  tabindex="103">
								<label id="lblRdoBookingMonth" for="rdoBookingMonth" style="float: left;">Booking Month</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			
			<div id="paidFieldsetDiv" style="float: left; margin: 10px 10px 5px 0; width:285px;" >
				<fieldset>
					<legend style="margin-left: 5px;"><b>Paid</b></legend>
					<table style="height: 80px; margin: 15px 10px 5px 70px;">
						<tr>
							<td>
								<input type="radio" id="rdoTranDate" name="rdoGrpPaid" style="float: left; margin: 0 5px 2px 5px;" tabindex="201">
								<label id="lblRdoTranDate" for="rdoTranDate" style="float: left;">Tran Date</label>
							</td>
						</tr>
						<tr>
							<td>
								<input type="radio" id="rdoPostingDate" name="rdoGrpPaid" style="float: left; margin: 0 5px 2px 5px;"  tabindex="202">
								<label id="lblRdoPostingDate" for="rdoPostingDate" style="float: left;">Posting Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
			
			<div id="lovFieldsDiv" class="sectionDiv" style="margin: 0 12px 5px 12px; width: 575px;">
				<table style="margin: 10px 10px 10px 10px;">
					<tr>
						<td class="rightAligned" style="width:120px;">As of</td>
						<td>
							<div id="asOfDateDiv" style="float: left; margin-left: 5px; width: 150px;" class="withIconDiv required">
								<input type="text" id="txtAsOfDate" name="txtAsOfDate" class="withIcon required" readonly="readonly" style="width: 125px;" tabindex="301" /> 
								<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As Of Date" />
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Catastrophic Event</td>
						<td>
							<div  style="border: 1px solid gray; float: left; width:80px; height: 21px; margin: 2px 5px 2px 5px;">
								<input type="text" id="txtCatCd" name="txtCatCd" removeStyle="true" lastValidValue="" style=" height: 12px; border: none; width: 55px; float:left; margin: 1px 0 4px 0; text-align:right;" class="upper" maxlength="5" tabindex="302" />							  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osCatCd" name="osCatCd" style="float:left; margin-top:2px; cursor: pointer;"/>
							</div>
							<input type="text" id="txtCatDesc" style="width:310px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Line</td>
						<td>
							<div  style="border: 1px solid gray; float: left; width:80px; height: 21px; margin: 2px 5px 2px 5px;">
								<input type="text" id="txtLineCd" name="txtLineCd" lastValidValue="" removeStyle="true" style=" height: 12px; border: none; width: 55px; float:left; margin: 1px 0 4px 0;" class="upper" maxlength="2" tabindex="303" />							  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osLineCd" name="osLineCd" style="float:left; margin-top:2px; cursor: pointer;"/>
							</div>
							<input type="text" id="txtLineName" style="width:310px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Branch</td>
						<td>
							<div  style="border: 1px solid gray; float: left; width:80px; height: 21px; margin: 2px 5px 2px 5px;">
								<input type="text" id="txtBranchCd" name="txtBranchCd" lastValidValue="" removeStyle="true" style=" height: 12px; border: none; width: 55px; float:left; margin: 1px 0 4px 0;" class="upper" maxlength="2" tabindex="304" />							  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osBranchCd" name="osBranchCd" style="float:left; margin-top:2px; cursor: pointer;"/>
							</div>
							<input type="text" id="txtBranchName" style="width:310px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Location</td>
						<td>
							<input type="hidden" id="txtLocationCd" name="txtLocationCd" />
							<!-- <input type="text" id="txtLocation" name="txtLocation" class="upper" style="width:397px; margin-left: 5px;" tabindex="305" /> -->
							
							<div  style="border: 1px solid gray; float: left; width:403px; height: 21px; margin: 2px 5px 2px 5px;">
								<input type="text" id="txtLocation" name="txtLocation" lastValidValue="" removeStyle="true" maxlength="150" style=" height: 12px; border: none; width: 378px; float:left; margin: 1px 0 4px 0;" class="upper" tabindex="305" />							  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osLocation" name="osLocation" style="float:left; margin-top:2px; cursor: pointer;"/>
							</div>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Nature of Loss</td>
						<td>
							<div  style="border: 1px solid gray; float: left; width:80px; height: 21px; margin: 2px 5px 2px 5px;">
								<input type="text" id="txtLossCatCd" name="txtLossCatCd" lastValidValue="" removeStyle="true" style=" height: 12px; border: none; width: 55px; float:left; margin: 1px 0 4px 0;" class="upper" maxlength="2" tabindex="306" />							  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osLossCatCd" name="osLossCatCd" style="float:left; margin-top:2px; cursor: pointer;"/>
							</div>
							<input type="text" id="txtLossCatDesc" style="width:310px;" readonly="readonly" />
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Reinsurer</td>
						<td>
							<div  style="border: 1px solid gray; float: left; width:80px; height: 21px; margin: 2px 5px 2px 5px;">
								<input type="text" id="txtRiCd" name="txtRiCd" lastValidValue="" removeStyle="true" style=" height: 12px; border: none; width: 55px; float:left; margin: 1px 0 4px 0; text-align:right;" class="upper" maxlength="5" tabindex="307" />							  
								<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="osRiCd" name="osRiCd" style="float:left; margin-top:2px; cursor: pointer;"/>
							</div>
							<input type="text" id="txtRiName" style="width:310px;" readonly="readonly" />
						</td>
					</tr>
				</table>
			</div> <!-- end: lovFieldsDiv -->
			
			<div id="printDiv" class="sectionDiv" style="width: 575px; height: 160px; margin: 0 10px 0 12px;">
				<table id="printDialogMainTab" name="printDialogMainTab" align="center" style="margin-top: 15px; margin-bottom: 10px;" border="0">
					<tr>
						<td class="rightAligned">Destination</td>
						<td class="leftAligned"><select id="selDestination" style="width: 200px;" tabindex="109">
								<option value="screen">Screen</option>
								<option value="printer">Printer</option>
								<option value="file">File</option>
								<option value="local">Local Printer</option>
						</select></td>
					</tr>
					<tr>
						<td></td>
						<td>
							<input value="PDF" title="PDF" type="radio" id="rdoPdf" name="fileType" style="margin: 2px 5px 4px 5px; float: left;" checked="checked" disabled="disabled" tabindex="110"/>
							<label for="rdoPdf" style="margin: 2px 0 4px 0">PDF</label> 
							<!-- <input value="EXCEL" title="Excel" type="radio" id="rdoExcel" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="111" />
							<label for="rdoExcel" style="margin: 2px 0 4px 0">Excel</label> -->
							<input value="CSV" title="Csv" type="radio" id="rdoCsv" name="fileType" style="margin: 2px 4px 4px 25px; float: left;" disabled="disabled" tabindex="111" />
							<label for="rdoCsv" style="margin: 2px 0 4px 0">CSV</label>
						</td>
					</tr>
					<tr>
						<td class="rightAligned">Printer</td>
						<td class="leftAligned"><select id="selPrinter" style="width: 200px;" class="required" tabindex="112">
								<option></option>
								<c:forEach var="p" items="${printers}">
									<option value="${p.name}">${p.name}</option>
								</c:forEach>
						</select></td>
					</tr>
					<tr>
						<td class="rightAligned">No. of Copies</td>
						<td class="leftAligned"><input type="text" id="txtNoOfCopies" maxlength="30" style="float: left; text-align: right; width: 175px;" class="required integerNoNegativeUnformattedNoComma" tabindex="113">
							<div style="float: left; width: 15px;">
								<img id="imgSpinUp" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; cursor: pointer;" />
								<img id="imgSpinUpDisabled" alt="Up" src="${pageContext.request.contextPath}/images/misc/spinup.gif" style="margin-left: 1px; margin-bottom: 2px; margin-top: 2px; display: none;"/>
								<img id="imgSpinDown" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; cursor: pointer;"/> 
								<img id="imgSpinDownDisabled" alt="Down" src="${pageContext.request.contextPath}/images/misc/spindown.gif" style="margin-left: 1px; display: none;"/>
							</div>
						</td>
					</tr>
					<tr style="height:25px;">
						<td colspan="2">
							<input type="checkbox" id="chkXOLTreaty" name="xhkXOLTreaty" style="margin: 2px 5px 2px 5px; float:left;" />
							<label id="lblChkXOLTreaty" name="lblChkXOLTreaty" for="chkXOLTreaty" style="float:left;">Print summary of losses paid and outstanding to XOL treaty only</label>
						</td>
					</tr>
				</table>				
			</div><!-- end: printDiv -->
			
			<div class="buttonsDiv" style="margin: 20px 10px 20px 10px;">
				<input type="button" class="button" id="btnExtract" name="btnExtract" value="Extract" style="width: 90px;" />
				<input type="button" class="button" id="btnPrint" name="btnPrint" value="Print" style="width: 90px;" />
			</div>
		</div> <!-- end: moduleSubDiv -->	
	</div> <!-- end: moduleDiv -->

</div> <!-- end: catastrophicEventReportMainDiv -->

<script type="text/javascript">

	var userParams = JSON.parse('${userParams}');
	var currentUserSessionId = null;
	var onLOV = false;
	
	function toggleRequiredFields(dest) {
		if (dest == "printer") {
			$("selPrinter").disabled = false;
			$("txtNoOfCopies").disabled = false;
			$("selPrinter").addClassName("required");
			$("txtNoOfCopies").addClassName("required");
			$("imgSpinUp").show();
			$("imgSpinDown").show();
			$("imgSpinUpDisabled").hide();
			$("imgSpinDownDisabled").hide();
			$("txtNoOfCopies").value = 1;
			$("rdoPdf").disable();
			$("rdoCsv").disable();
		} else {
			if (dest == "file") {
				$("rdoPdf").enable();
				$("rdoCsv").enable();
			} else {
				$("rdoPdf").disable();
				$("rdoCsv").disable();
			}
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
	
	function initializeDefaultValues(isOnLoad){
		if(isOnLoad){ // function is called on the first loading of the page
			if(userParams.osDateOpt == "3"){
				$("rdoBookingMonth").checked = true;
			} else if(userParams.osDateOpt == "2"){
				$("rdoClmFileDate").checked = true;
			} else {
				$("rdoLossDate").checked = true;
			}
			
			if(userParams.osDateOpt == "2"){
				$("rdoPostingDate").checked = true;
			} else {
				$("rdoTranDate").checked = true;
			}
			
			if(userParams.asOfDate != "" && userParams.asOfDate != null){
				$("txtAsOfDate").value = userParams.asOfDate;
			} else {
				$("txtAsOfDate").value = dateFormat(new Date(), 'mm-dd-yyyy');
			}
		}
		
		$("txtCatCd").value 		= isOnLoad ? nvl(userParams.catCd, "") : "";
		$("txtCatDesc").value 		= isOnLoad ? unescapeHTML2(nvl(userParams.catDesc, "")) : "";
		
		$("txtLineCd").value 		= isOnLoad ? nvl(userParams.lineCd, "") : "";
		$("txtLineName").value 		= isOnLoad ? unescapeHTML2(nvl(userParams.lineName, "")) : "";
		$("txtBranchCd").value 		= isOnLoad ? nvl(userParams.issCd, "") : "";
		$("txtBranchName").value 	= isOnLoad ? unescapeHTML2(nvl(userParams.issName, "")) : "";
		$("txtLocationCd").value 	= isOnLoad ? unescapeHTML2(nvl(userParams.locationCd, "")) : "";
		$("txtLocation").value 		= isOnLoad ? unescapeHTML2(nvl(userParams.locationDesc, "")) : "";
		$("txtLossCatCd").value 	= isOnLoad ? nvl(userParams.lossCatCd, "") : "";
		$("txtLossCatDesc").value 	= isOnLoad ? unescapeHTML2(nvl(userParams.lossCatDesc, "")) : "";
		$("txtRiCd").value 			= isOnLoad ? nvl(userParams.riCd, "") : "";
		$("txtRiName").value 		= isOnLoad ? unescapeHTML2(nvl(userParams.riName, "")) : "";
	}
	
	function disableItems(flag){
		$("rdoLossDate").disabled = flag;
		$("rdoClmFileDate").disabled = flag;
		$("rdoBookingMonth").disabled = flag;
		
		$("rdoTranDate").disabled = flag;
		$("rdoPostingDate").disabled = flag;
		
		flag ? disableDate("hrefAsOfDate") : enableDate("hrefAsOfDate");
		flag ? disableInputField("txtAsOfDate") : enableInputField("txtAsOfDate");
		
		flag ? disableSearch("osCatCd") : enableSearch("osCatCd");
		flag ? disableInputField("txtCatCd") : enableInputField("txtCatCd");
		
		flag ? disableSearch("osLineCd") : enableSearch("osLineCd");
		flag ? disableInputField("txtLineCd") : enableInputField("txtLineCd");
		
		flag ? disableSearch("osBranchCd") : enableSearch("osBranchCd");
		flag ? disableInputField("txtBranchCd") : enableInputField("txtBranchCd");
		
		flag ? disableSearch("osLocation") : enableSearch("osLocation");
		flag ? disableInputField("txtLocation") : enableInputField("txtLocation");
		
		flag ? disableSearch("osLossCatCd") : enableSearch("osLossCatCd");
		flag ? disableInputField("txtLossCatCd") : enableInputField("txtLossCatCd");
		
// 		$("txtRiCd").value = flag ? "" : $F("txtRiCd");
// 		$("txtRiName").value = flag ? "" : $F("txtRiName");
		flag ? disableSearch("osRiCd") : enableSearch("osRiCd");
		flag ? disableInputField("txtRiCd") : enableInputField("txtRiCd");
	}
	
	// Catastrophic Event LOV
	function showCatastrophicLOV2(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGiclCatDtlLOV2",
							filterText : ($("txtCatCd").readAttribute("lastValidValue").trim() != $F("txtCatCd").trim() ? $F("txtCatCd").trim() : "%"),
							moduleId: "GICLS200",
							page : 1},
			title: "List of Catastrophic Events",
			width: 405,
			height: 388,
			columnModel : [
							{
			                	id: "catCd",
			                	title: "Catastrophic Code",
			                	titleAlign: 'right',
			                	align: 'right',
			                	width: '130px'
			                },
			                {
								id : "catDesc",
								title : "Catastrophic Desc",
								width : '260px'
							}],
				autoSelectOneRecord: true,
				filterText : ($("txtCatCd").readAttribute("lastValidValue").trim() != $F("txtCatCd").trim() ? $F("txtCatCd").trim() : "%"),
				onSelect: function(row) {
					$("txtCatCd").value = row.catCd;
					$("txtCatCd").setAttribute("lastValidValue", row.catCd);
					$("txtCatDesc").value = unescapeHTML2(row.catDesc);
				},
				onCancel: function (){
					$("txtCatCd").value = $("txtCatCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtCatCd").value = $("txtCatCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	// LINE CD LOV
	function showLineCdLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls200LineLOV",
							filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
							moduleId: "GICLS200",
							polIssCd: $F("txtBranchCd"),
							page : 1},
			title: "List of Lines",
			width: 500,
			height: 400,
			columnModel : [
							{
								id : "lineCd",
								title: "Line Code",
								width: '100px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							},
							{
								id : "lineName",
								title: "Line Name",
								width: '370px',
								renderer: function(value) {
									return unescapeHTML2(value);
								}
							}
						],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
					$("txtLineName").value = unescapeHTML2(row.lineName);					
				},
				onCancel: function (){
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	// BRANCH LOV
	function showIssCdLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls200IssSourceLOV",
							filterText : ($("txtBranchCd").readAttribute("lastValidValue").trim() != $F("txtBranchCd").trim() ? $F("txtBranchCd").trim() : ""),
							moduleId: "GICLS200",
							lineCd: $F("txtLineCd").trim(),
							page : 1},
			title: "List of Braches",
			width: 500,
			height: 400,
			columnModel : [
							{
			                	id: "issCd",
			                	title: "Branch Code",
			                	width: '80px'
			                },
			                {
								id : "issName",
								title : "Branch Name",
								width : '310px'
							} ],
				autoSelectOneRecord: true,
				filterText : ($("txtLineCd").readAttribute("lastValidValue").trim() != $F("txtLineCd").trim() ? $F("txtLineCd").trim() : ""),
				onSelect: function(row) {
					$("txtBranchCd").value = row.issCd;
					$("txtBranchCd").setAttribute("lastValidValue", row.issCd);
					$("txtBranchName").value = unescapeHTML2(row.issName);
				},
				onCancel: function (){
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtBranchCd").value = $("txtBranchCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	// Location LOV
	function showLocationLOV2(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getLocationLOV",
							searchString : ($("txtLocation").readAttribute("lastValidValue").trim() != $F("txtLocation").trim() ? $F("txtLocation").trim() : ""),
							moduleId: "GICLS200",
							page : 1},
			title: "List of Locations",
			width: 500,
			height: 400,
			columnModel : [
							{
			                	id: "locationCd",
			                	title: "Location Code",
			                	width: '90px'
			                },
			                {
								id : "locationDesc",
								title : "Locations",
								width : '300px'
							} ],
				autoSelectOneRecord: true,
				searchString : ($("txtLocation").readAttribute("lastValidValue").trim() != $F("txtLocation").trim() ? $F("txtLocation").trim() : ""),
				onSelect: function(row) {
					$("txtLocation").value = unescapeHTML2(row.locationDesc);
					$("txtLocation").setAttribute("lastValidValue", unescapeHTML2(row.locationDesc));
					$("txtLocationCd").value = unescapeHTML2(row.locationCd);
				},
				onCancel: function (){
					$("txtLocation").value = $("txtLocation").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLocation").value = $("txtLocation").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	// LOSS CAT LOV
	function showLossCatCdLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getLossCatLOV",
							lineCd: $F("txtLineCd"),
							searchString : ($("txtLossCatCd").readAttribute("lastValidValue").trim() != $F("txtLossCatCd").trim() ? $F("txtLossCatCd").trim() : ""),
							moduleId: "GICLS200",
							page : 1},
			title: "List of Locations",
			width: 500,
			height: 400,
			columnModel : [
							{
								id: "id",
								title: "Loss Cat Code",
								width: '100px'
							},
							{
								id : "desc",
								title : "Loss Description",
								width : '290px'
							}  ],
				autoSelectOneRecord: true,
				searchString : ($("txtLossCatCd").readAttribute("lastValidValue").trim() != $F("txtLossCatCd").trim() ? $F("txtLossCatCd").trim() : ""),
				onSelect: function(row) {
					$("txtLossCatCd").value = unescapeHTML2(row.id);
					$("txtLossCatCd").setAttribute("lastValidValue", unescapeHTML2(row.id));
					$("txtLossCatDesc").value = unescapeHTML2(row.desc);
				},
				onCancel: function (){
					$("txtLossCatCd").value = $("txtLossCatCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtLossCatCd").value = $("txtLossCatCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	
	
	// REINSURER LOV
	function showRiCdLOV(){
		LOV.show({
			controller: "ClaimsLOVController",
			urlParameters: {action : "getGicls200RiLov",
							searchString : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : ""),
							moduleId: "GICLS200",
							page : 1},
			//title: "List of Branches", modified by gab 12.22.2016
			title: "List of Reinsurer", 
			width: 500,
			height: 400,
			columnModel : [
							{
			                	id: "riCd",
			                	title: "RI Code",
			                	width: '80px'
			                },
			                {
								id : "riName",
								title : "RI Name",
								width : '310px'
							}  ],
				autoSelectOneRecord: true,
				searchString : ($("txtRiCd").readAttribute("lastValidValue").trim() != $F("txtRiCd").trim() ? $F("txtRiCd").trim() : ""),
				onSelect: function(row) {
					$("txtRiCd").value = unescapeHTML2(row.riCd);
					$("txtRiCd").setAttribute("lastValidValue", unescapeHTML2(row.riCd));
					$("txtRiName").value = unescapeHTML2(row.riName);
				},
				onCancel: function (){
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					showMessageBox("No record selected.", "I");
					$("txtRiCd").value = $("txtRiCd").readAttribute("lastValidValue");
				},
				onShow : function(){$(this.id+"_txtLOVFindText").focus();}
		  });
	}
	//
	
	function extractOsPdPerCat(){
		try {
			var osDateOption = ( $("rdoLossDate").checked ? "1" : ($("rdoClmFileDate").checked ? "2" : "3") );
			var pdDateOption = ( $("rdoTranDate").checked ? "1" : "2" );
			
			new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
				method : "POST",
				parameters : {
					action 		: "extractOsPdPerCat",
					catCd		: $F("txtCatCd"),
					lineCd		: $F("txtLineCd"),
					branchCd	: $F("txtBranchCd"),
					locationCd	: $F("txtLocationCd"),
					lossCatCd	: $F("txtLossCatCd"),
					riCd		: $F("txtRiCd"),
					asOfDate	: $F("txtAsOfDate"),
					osDateOption: osDateOption,
					pdDateOption: pdDateOption
				},
		        onCreate   : showNotice("Extracting data, please wait..."),
		        onComplete : function(response){
		        	hideNotice();
		        	try {
						if(checkErrorOnResponse(response)){
							var recordCount = parseInt(response.responseText);
							var message = "";
							if(recordCount > 0){
								message = "Extraction finished.";
								disableItems(true);
								$("btnPrint").focus();
							} else {
								message = "No records extracted.";
							}
							showMessageBox(message, "I");
						}
					} catch (e) {
						showErrorMessage("showCatastrophicEventReport - onComplete: ", e);
					}
		        }
			});
		} catch(e){
			showErrorMessage("extractOsPdPerCat: ", e);
		}
	}
	
	function validateOsFields(btnId){
		if(checkAllRequiredFieldsInDiv("lovFieldsDiv")){
			$("txtCatDesc").value 		= $F("txtCatCd") 	== "" ? "ALL CATASTROPHIC EVENTS" 	: $F("txtCatDesc");
			$("txtLineName").value 		= $F("txtLineCd") 	== "" ? "ALL LINES" 				: $F("txtLineName");
			$("txtBranchName").value 	= $F("txtBranchCd") == "" ? "ALL BRANCHES" 				: $F("txtBranchName");
			$("txtLocation").value 		= $F("txtLocation") == "" ? "ALL LOCATIONS" 			: $F("txtLocation");
			$("txtLossCatDesc").value 	= $F("txtLossCatCd")== "" ? "ALL LOSS CATEGORIES" 		: $F("txtLossCatDesc");
			$("txtRiName").value 		= $F("txtRiCd") 	== "" ? "ALL REINSURERS" 			: $F("txtRiName");
			
			if(btnId == "btnExtract"){
				extractOsPdPerCat();
			} else if(btnId == "btnPrint"){
				validateRecordsBeforePrint();	
			}
		}
	}
	
	function validateRecordsBeforePrint(){
		try {
			new Ajax.Request(contextPath+"/GICLCatastrophicEventController",{
				method : "POST",
				parameters : {action : "valExtOsPdClmRecBefPrint"},
		        onCreate   : showNotice("Validating records before printing, please wait..."),
		        onComplete : function(response){
		        	hideNotice();
		        	if(checkErrorOnResponse(response)){
						var objRet = JSON.parse(response.responseText);
						currentUserSessionId = nvl(objRet.sessionId, "");
						
						if(objRet.sessionId != "0" && nvl(objRet.extDate, "") != ""){
							//showWaitingMessageBox("Last extraction was made " + objRet.extDate + ". Print records from last extraction?", "I", validateReportsToPrint);
							showConfirmBox("Printing", "Last extraction was made " + objRet.extDate + ". Print records from last extraction?", "Ok", "Cancel", validateReportsToPrint, "", "");
						} else if(objRet.sessionId != "0" && nvl(objRet.extDate, "") == ""){
							validateReportsToPrint();
						} else {
							showMessageBox("User has not run extraction yet, please perform extraction before printing.", "I");
						}						
					}
		        }
			});
		} catch(e){
			showErrorMessage("validateRecordsBeforePrint: ", e);
		}
	}
	
	function validateReportsToPrint(){
		var reportsToPrint = [];
		if($("chkXOLTreaty").checked){
			if($("rdoCsv").checked){
				reportsToPrint.push({reportId :"GICLR200B", reportTitle: "Outstanding and Paid Claims to XOL Treaty"});	
			}else{
				reportsToPrint.push({reportId :"GICLR200B", reportTitle: "Outstanding and Paid Claims to XOL Treaty"});
			}
		} else {
			reportsToPrint.push({reportId :"GICLR200B", reportTitle: "Outstanding and Paid Claims to XOL Treaty"});
			reportsToPrint.push({reportId :"GICLR200", reportTitle: "Outstanding Losses"});
		}
		printReport(reportsToPrint);
		/*if($("chkXOLTreaty").checked){s
			validateReportId("GICLR200B", "Outstanding and Paid Claims to XOL Treaty");
		} else {
			validateReportId("GICLR200", "Outstanding Losses");
		}*/		
	}
	
	function validateReportId(reportId, reportTitle) {
		try {
			new Ajax.Request(
					contextPath + "/GIACGeneralDisbursementReportsController",
					{
						parameters : {
							action : "validateReportId",
							reportId : reportId
						},
						ashynchronous : false,
						evalScripts : true,
						onComplete : function(response) {
							if (checkErrorOnResponse(response)) {
								if (response.responseText == "Y") {
									printReport(reportId, reportTitle);
								} else {
									showMessageBox("No existing records found in GIIS_REPORTS.", "E");
								}
							}
						}
					});
		} catch (e) {
			showErrorMessage("validateReportId", e);
		}
	}

	//function printReport(reportId, reportTitle) {
	function printReport(obj) {
		try {
			
			if (checkAllRequiredFieldsInDiv("printDiv")) {
				var noOfCopies = parseInt($F("txtNoOfCopies"));
				
				if(noOfCopies < 1){
					noOfCopies = 1;
					$("txtNoOfCopies").value = "1";
				}
				var fileType = "";

				if ($("rdoPdf").disabled == false
						&& $("rdoCsv").disabled == false) {
					fileType = $("rdoPdf").checked ? "PDF" : "CSV"; //jm
				}

				var reports = [];
				for(var i=0; i<obj.length; i++){
					var content = contextPath
								+ "/PrintCatastrophicEventReportController?action=printReport"
								+ "&noOfCopies=" 	+ noOfCopies
								+ "&printerName=" 	+ $F("selPrinter") 
								+ "&destination="   + $F("selDestination") 
								+ "&reportId=" 		+ obj[i].reportId
								+ "&reportTitle=" 	+ obj[i].reportTitle 
								+ "&fileType="		+ fileType
								+ "&sessionId="		+ nvl(currentUserSessionId, "")
								+ "&asOfDate="		+ $F("txtAsOfDate")
								+ "&riCd="			+ $F("txtRiCd");
					
					reports.push({reportUrl : content, reportTitle : obj[i].reportTitle});
					printGenericReport2(content);
					
					if (i == obj.length-1){
						if ("screen" == $F("selDestination")){
							showMultiPdfReport(reports); 
						}
					}
				}
			}
			disableItems(false);
			initializeDefaultValues(false);
		} catch (e) {
			showErrorMessage("printReport", e);
		}
	}
	
	observeReloadForm("reloadForm", showCatastrophicEventReport);
	
	$("hrefAsOfDate").observe("click", function() {
		scwShow($('txtAsOfDate'), this, null);
	});
	
	// CATASTROPHIC EVENT
	$("osCatCd").observe("click", showCatastrophicLOV2);	
	$("txtCatCd").observe("change", function() {		
		if($F("txtCatCd").trim() == "") {
			$("txtCatCd").value = "";
			$("txtCatCd").setAttribute("lastValidValue", "");
			$("txtCatDesc").value = "ALL CATASTROPHIC EVENTS";
		} else {
			if($F("txtCatCd").trim() != "" && $F("txtCatCd") != $("txtCatCd").readAttribute("lastValidValue")) {
				showCatastrophicLOV2();
			}
		}
	});
		
	// LINE CODE
	$("osLineCd").observe("click", showLineCdLOV);	
	$("txtLineCd").observe("keyup", function() {	
		$("txtLineCd").value = $F("txtLineCd").toUpperCase();
	});
	$("txtLineCd").observe("change", function() {		
		if($F("txtLineCd").trim() == "") {
			$("txtLineCd").value = "";
			$("txtLineCd").setAttribute("lastValidValue", "");
			$("txtLineName").value = "ALL LINES";
			$("txtLossCatCd").value = "";
			$("txtLossCatCd").setAttribute("lastValidValue", "");
			$("txtLossCatDesc").value = "ALL LOSS CATEGORIES";
		} else {
			if($F("txtLineCd").trim() != "" && $F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")) {
				showLineCdLOV();
			}
		}
	});
	
	// ISSUE CODE
	$("osBranchCd").observe("click", showIssCdLOV);
	$("txtBranchCd").observe("keyup", function() {	
		$("txtBranchCd").value = $F("txtBranchCd").toUpperCase();
	});
	$("txtBranchCd").observe("change", function() {		
		if($F("txtBranchCd").trim() == "") {
			$("txtBranchCd").value = "";
			$("txtBranchCd").setAttribute("lastValidValue", "");
			$("txtBranchName").value = "ALL BRANCHES";
		} else {
			if($F("txtBranchCd").trim() != "" && $F("txtBranchCd") != $("txtBranchCd").readAttribute("lastValidValue")) {
				showIssCdLOV();
			}
		}
	});
	
	// LOCATION
	$("osLocation").observe("click", showLocationLOV2);	
	$("txtLocation").observe("keyup", function(){
		$("txtLocation").value = $F("txtLocation").toUpperCase();
	});
	$("txtLocation").observe("change", function(event){
		if($F("txtLocation").trim() == "") {
			$("txtLocation").value = "ALL LOCATIONS";
			$("txtLocation").setAttribute("lastValidValue", "");
			$("txtLocationCd").value = "";
		} else {
			if($F("txtLocation").trim() != "" && $F("txtLocation") != $("txtLocation").readAttribute("lastValidValue")) {
				showLocationLOV2();
			}
		}
	});
	
	// LOSS CAT CODE
	$("osLossCatCd").observe("click", function(){
		if($F("txtLineCd").trim() != ""){
			showLossCatCdLOV();	
		} else {
			showMessageBox("Option not allowed for ALL LINES.", "I");
		}
	});
	$("txtLossCatCd").observe("keyup", function(event){
		$("txtLossCatCd").value = $F("txtLossCatCd").toUpperCase();
	});	
	$("txtLossCatCd").observe("change", function(){
		if($F("txtLossCatCd").trim() != ""){
			if($F("txtLineCd").trim() != ""){
				if($F("txtLossCatCd").trim() != "" && $F("txtLossCatCd") != $("txtLossCatCd").readAttribute("lastValidValue")) {
					showLossCatCdLOV();
				}
			} else {
				$("txtLossCatCd").value = "";
				$("txtLossCatDesc").value = "ALL LOSS CATEGORIES";
				$("txtLossCatCd").setAttribute("lastValidValue", "");
				showMessageBox("Option not allowed for ALL LINES.", "I");
			}			
		} else {
			$("txtLossCatCd").value = "";
			$("txtLossCatCd").setAttribute("lastValidValue", "");
			$("txtLossCatDesc").value = "ALL LOSS CATEGORIES";
		}
	});
	

	// RI CODE
	$("osRiCd").observe("click", showRiCdLOV);
	$("txtRiCd").observe("keyup", function(event){
		$("txtRiCd").value = $F("txtRiCd").toUpperCase();
	});
	$("txtRiCd").observe("change", function(){
		if($F("txtRiCd").trim() == "") {
			$("txtRiCd").value = "";
			$("txtRiCd").setAttribute("lastValidValue", "");
			$("txtRiName").value = "ALL REINSURERS";
		} else {
			if($F("txtRiCd").trim() != "" && $F("txtRiCd") != $("txtRiCd").readAttribute("lastValidValue")) {
				showRiCdLOV();
			}
		}
	});
		
	$("btnExtract").observe("click", function(){
		validateOsFields("btnExtract");
	});
	
	$("btnPrint").observe("click", function(){
		validateOsFields("btnPrint");
	});
	
	$("clmCatastrophicEventReportExit").observe("click", function(){
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	//PRINTDIV
	$("imgSpinUp").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		$("txtNoOfCopies").value = no + 1;
	});

	$("imgSpinDown").observe("click", function() {
		var no = parseInt(nvl($F("txtNoOfCopies"), 0));
		if (no > 1) {
			$("txtNoOfCopies").value = no - 1;
		}
	});

	$("imgSpinUp").observe("mouseover", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinupfocus.gif";
	});

	$("imgSpinDown").observe("mouseover", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindownfocus.gif";
	});

	$("imgSpinUp").observe("mouseout", function() {
		$("imgSpinUp").src = contextPath + "/images/misc/spinup.gif";
	});

	$("imgSpinDown").observe("mouseout", function() {
		$("imgSpinDown").src = contextPath + "/images/misc/spindown.gif";
	});

	$("selDestination").observe("change", function() {
		var dest = $F("selDestination");
		toggleRequiredFields(dest);
	});
	
	setModuleId("GICLS200");
	setDocumentTitle("Outstanding and Paid Claims per Catastrophic Event");
	initializeAll();
	makeInputFieldUpperCase();
	toggleRequiredFields("screen");
	initializeDefaultValues(true);
</script>