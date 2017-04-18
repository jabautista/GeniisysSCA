<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>

<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="perPolicyWEnrolleesMainDiv" name="perPolicyWEnrolleesMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Claim Listing per Policy with Enrollees</label>
		</div>
	</div>
	
	<div id="perPolicyWEnrolleesDiv" align="center" class="sectionDiv">
		<div id="policyNoDiv" style="margin: 5px; margin-left: 10px; width: 530px; float: left;">
			<table border="0" align="center">
				<tr>
					<td class="rightAligned" style="width: 75px;">Policy No.</td>
					<td class="rightAligned">
						<div id="lineCdDiv" style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="lineCd" name="policyNoField" value="" style="width: 22px; height: 13px;" class="required withIcon allCaps" maxlength="2" column="line code" tabindex="101" ignoreDelKey="true" lastValidValue="">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go"/>
						</div>
						<div id="sublineCdDiv" style="width: 89px; float: left;" class="withIconDiv">
							<input type="text" id="sublineCd" name="policyNoField" value="" style="width: 64px; height: 13px;" class="withIcon allCaps" maxlength="7" column="subline code" tabindex="102" ignoreDelKey="true" lastValidValue="">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchSublineCd" name="searchSublineCd" alt="Go" />
						</div>
						<div style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="polIssCd" name="policyNoField" value="" style="width: 22px; height: 13px;" class="withIcon allCaps" maxlength="2" column="issue code" tabindex="103" ignoreDelKey="true" lastValidValue="">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolIssCd" alt="Go" />
						</div>
						<div style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="issueYy" name="policyNoField" value="" style="width: 22px; height: 13px;" class="withIcon integerNoNegativeUnformattedNoComma" column="issue year" maxlength="2" tabindex="104" ignoreDelKey="true" lastValidValue="">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIssueYy" name="searchIssueYy" alt="Go" />
						</div>
						<input type="text" id="polSeqNo" name="policyNoField" value="" style="width: 71px; float: left; height: 13px;" class="integerNoNegativeUnformattedNoComma" maxlength="7" tabindex="105">
						<input type="text" id="renewNo" name="policyNoField" value="" style="width: 33px; float: left; margin-left: 4px; height: 13px;" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="106">
						<div class="withIconDiv" style="border: 0px; float: right;">
							<img style="margin-left: 3px; float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchPolicy" name="searchPolicy" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="rightAligned">
						<input id="assdNo" name="assdNo" type="hidden"/>
						<input style="float: left; width: 370px;" type="text" id="assuredName" name="assuredName" readonly="readonly" tabindex="107">
					</td>
				</tr>
				<tr>
					<td></td>
					<td>
						<fieldset style="margin-left: 0; width: 361px;">
							<legend>Search by</legend>
							<table border="0" align="center">
								<tr>
									<td>
										<input style="float: left; margin: 4px 5px 0 0;" type="radio" id="claimFileDate" name="searchByRG" value="claimFileDate" checked="checked" tabindex="108">
									</td>
									<td>
										<label for="claimFileDate">Claim File Date</label>
									</td>
									<td>
										<input style="float: left; margin: 4px 5px 0 30px;" type="radio" id="lossDate" name="searchByRG" value="lossDate" tabindex="109">
									</td>
									<td><label for="lossDate">Loss Date</label></td>
								</tr>
							</table>
						</fieldset>
					</td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table border="0" align="center" style="margin: 8px;">
				<tr>
					<td class="rightAligned">
						<input type="radio" id="asOf" name="dateRG" value="asOf" checked="checked" tabindex="110">
					</td>
					<td class="rightAligned">
						<label for="asOf">As of </label>
					</td>
					<td class="rightAligned">
						<div id="divAsOfDate" style="padding: 1px 2px 0 0; float: left; margin-left: 3px; width: 165px;" class="required withIconDiv">
							<input style="width: 142px; height: 13px;" class="required withIcon" id="asOfDate" name="asOfDate" type="text" readOnly="readonly" tabindex="111" ignoreDelKey="true"/>
							<img id="hrefAsOfDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" onClick="scwShow($('asOfDate'),this, null);"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">
						<input type="radio" id="fromTo" name="dateRG" value="fromTo" tabindex="112">
					</td>
					<td class="rightAligned">
						<label for="fromTo">From </label>
					</td>
					<td class="rightAligned">
						<div id="divFromDate" style="padding: 1px 2px 0 0; float: left; margin-left: 3px; width: 165px;" class="withIconDiv">
							<input style="width: 142px; height: 13px;" class="withIcon" id="fromDate" name="fromToDate" type="text" readOnly="readonly" tabindex="113" ignoreDelKey="true"/>
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" onClick="scwShow($('fromDate'),this, null);"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"></td>
					<td class="rightAligned">
						<label for="fromTo" style="float: right;">To</label>
					</td>
					<td class="rightAligned">
						<div id="divToDate" style="padding: 1px 2px 0 0; float: left; margin-left: 3px; width: 165px;" class="withIconDiv">
							<input style="width: 142px; height: 13px;" class="withIcon" id="toDate" name="toDate" type="text" readOnly="readonly" tabindex="114" ignoreDelKey="true"/>
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" onClick="scwShow($('toDate'),this, null);"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div id="perPolicyWEnrolleesDetailsDiv" class="sectionDiv" style="height: 455px; margin-bottom: 35px;">
		<div id="perPolicyWEnrolleesDivTGDiv" style="padding: 10px 0 0 10px; height: 290px;"></div>
		
		<div id="perPolicyWEnrolleesDiv" style="float: left; margin-left: 10px;">
			<table cellpadding="0" align="center" style="width: 900px; margin-bottom: 2px;">
				<tr id="trOne">
					<td style="width: 140px;"><input type="button" class="disabledButton" id="btnRecoveryDtls" name="btnRecoveryDtls" value="Recovery Details" style="width: 140px; margin-left: 20px;" tabindex="200"/></td>
					<td class="rightAligned" style="width: 133px;"> Totals&nbsp;</td>
					<td style="width: 115px;"><input style="width: 137px;" id="totLossResAmt" name="txtTotLossResAmt" type="text" readOnly="readonly" class="money" tabindex="201" /></td>
					<td style="width: 135px;"><input style="width: 137px;" id="totExpResAmt" name="txtTotExpResAmt" type="text" readOnly="readonly" class="money" tabindex="202" /></td>
					<td style="width: 135px;"><input style="width: 137px;" id="totLossPdAmt" name="txtTotLossPdAmt" type="text" readOnly="readonly" class="money" tabindex="203" /></td>
					<td><input style="width: 137px;" id="totExpPdAmt" name="totExpPdAmt" type="text" readOnly="readonly" class="money" tabindex="204" /></td>
				</tr>
				<tr>
					<td colspan="6">
						<div id="clmPerPolicyDetails" class="sectionDiv" style="margin-top: 10px;">
							<table align="center" style="margin: 5px auto 5px auto;">
								<tr>
									<td class="rightAligned" style="width: 105px;">Entry Date</td>
									<td class="rightAligned"><input style="width: 180px;" id="entryDate" name="entryDate" type="text" readOnly="readonly" tabindex="301"/></td>
									<td style="width: 100px;"></td>
									<td class="rightAligned" style="width: 105px;">Loss Date</td>
									<td class="rightAligned"><input style="width: 180px;" id="clmLossDate" name="clmLossDate" type="text" readOnly="readonly" tabindex="302"/></td>
								</tr>
								<tr>
									<td class="rightAligned">Claim Status</td>
									<td class="rightAligned"><input style="width: 180px;" id="claimStatus" name="claimStatus" type="text" readOnly="readonly" tabindex="303"/></td>
									<td></td>
									<td class="rightAligned">Claim File Date</td>
									<td class="rightAligned"><input style="width: 180px;" id="fileDate" name="fileDate" type="text" readOnly="readonly" tabindex="304"/></td>
								</tr>
							</table>
						</div>
						<div style="float: left; width: 100%; margin: 8px 0 6px 0;" align="center">
							<input type="button" class="disabledButton" id="btnPrintClmPerPolicy" value="Print Report" tabindex="401"/>
						</div>
					</td>
				</tr>	
			</table>
		</div>
	</div>
</div>

<script type="text/javascript">
	var selectedRow = "";
	var viewMode = false;
	var sysdate = dateFormat(new Date(), "mm-dd-yyyy");
	
	try{
		polWithEnrolleesTGModel = {
			url: contextPath+"/GICLClaimsController?action=showClaimListingPerPolicyWithEnrollees&refresh=1&moduleId=GICLS278",
			options: {
	          	height: '285px',
	          	width: '900px',
	          	onCellFocus: function(element, value, x, y, id){
	          		selectedRow = polWithEnrolleesTG.geniisysRows[y];
	          		populateClaimInfo(true);
	            },
	            onRemoveRowFocus: function(){
	            	selectedRow = "";
	            	populateClaimInfo(false);
	            },
	            onSort: function(){
	            	polWithEnrolleesTG.onRemoveRowFocus();
	            },
	            toolbar: {
	            	elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
	            	onRefresh: function(){
	            		polWithEnrolleesTG.onRemoveRowFocus();
	            		if(polWithEnrolleesTG.geniisysRows.length > 0){
	        				getTotals();
	        			}else{
	        				clearTotals();
	        			}
	            	},
	            	onFilter: function(){
	            		polWithEnrolleesTG.onRemoveRowFocus();
	            		if(polWithEnrolleesTG.geniisysRows.length > 0){
	        				getTotals();
	        			}else{
	        				clearTotals();
	        			}
	            	}
	            }
			},
			columnModel:[
						{   id: 'recordStatus',
						    width: '0px',
						    visible: false,
						    editor: 'checkbox'
						},
						{	id: 'divCtrId',
							width: '0px',
							visible: false
						},
						{
							id: 'clmRecovery',
		              		title : '&nbsp;R',
		              		altTitle: 'With Recovery',
			              	width: '25',
			              	editable: false,
			              	sortable: false,
							editor: new MyTableGrid.CellCheckbox({
					            getValueOf: function(value){
				            		if (value){
										return "Y";
				            		}else{
										return "N";	
				            		}	
				            	} 
				            })
		              	},
						{	id: 'claimNo',
							title: 'Claim Number',
							width: '144px',
							filterOption: true
						},
						{	id: 'enrollee',
							title: 'Enrollee',
							width: '250px',
							filterOption: true
						},
						{	id: 'lossResAmt',
							title: 'Loss Reserve',
							width: '115px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true
						},
						{	id: 'expResAmt',
							title: 'Expense Reserve',
							width: '115px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true
						},
						{	id: 'lossPdAmt',
							title: 'Losses Paid',
							width: '115px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true
						},
						{	id: 'expPdAmt',
							title: 'Expenses Paid',
							width: '115px',
							align: 'right',
							geniisysClass: 'money',
							filterOption: true
						}
						],
			rows: []
		};
		polWithEnrolleesTG = new MyTableGrid(polWithEnrolleesTGModel);
		polWithEnrolleesTG.render('perPolicyWEnrolleesDivTGDiv');
		polWithEnrolleesTG.afterRender = function(){
			polWithEnrolleesTG.onRemoveRowFocus();
			if(polWithEnrolleesTG.geniisysRows.length > 0){
				getTotals();
			}else{
				clearTotals();
			}
		};
	}catch(e){
		showMessageBox("Error in Per Policy With Enrollees TableGrid: " + e, imgMessage.ERROR);
	}
	
	function populatePolicyFields(row){
		$("lineCd").value = row.lineCd;
		$("sublineCd").value = row.sublineCd;
		$("polIssCd").value = row.polIssCd;
		$("issueYy").value = row.issueYy;
		$("polSeqNo").value = Number(row.polSeqNo).toPaddedString(7);
		$("renewNo").value = Number(row.renewNo).toPaddedString(2);
		$("assdNo").value = row.assdNo;
		$("assuredName").value = unescapeHTML2(row.assdName);
		enableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function populateClaimInfo(populate){
		$("entryDate").value = populate ? selectedRow.entryDate : "";
		$("claimStatus").value = populate ? selectedRow.claimStatus : "";
		$("clmLossDate").value = populate ? selectedRow.lossDate : "";
		$("fileDate").value = populate ? selectedRow.fileDate : "";
		
		if(selectedRow.clmRecovery == "Y"){
			enableButton("btnRecoveryDtls");
		}else{
			disableButton("btnRecoveryDtls");
		}
		
		polWithEnrolleesTG.keys.removeFocus(polWithEnrolleesTG.keys._nCurrentFocus, true);
		polWithEnrolleesTG.keys.releaseKeys();
	}
	
	function getTotals(){
		$("totLossResAmt").value = formatCurrency(polWithEnrolleesTG.geniisysRows[0].totLossResAmt);
		$("totLossPdAmt").value = formatCurrency(polWithEnrolleesTG.geniisysRows[0].totLossPdAmt);
		$("totExpResAmt").value = formatCurrency(polWithEnrolleesTG.geniisysRows[0].totExpResAmt);
		$("totExpPdAmt").value = formatCurrency(polWithEnrolleesTG.geniisysRows[0].totExpPdAmt);
	}
	
	function clearTotals(){
		$("totLossResAmt").value = "";
		$("totLossPdAmt").value = "";
		$("totExpResAmt").value = "";
		$("totExpPdAmt").value = "";
	}
	
	function validateField(id){
		new Ajax.Request(contextPath+"/GICLClaimListingInquiryController", {
			method: "GET",
			parameters: {
				action: "validateGICLS278Field",
				field: id,
				value: $(id).value
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					if(response.responseText == "N"){
						showWaitingMessageBox("No record of this " + $(id).getAttribute("column") + " in GICL_CLAIMS.", "I", function(){
							$(id).focus();
							$(id).value = "";
							toggleToolbars();
						});
					}else{
						toggleToolbars();
					}
				}
			}
		});
	}
	
	function validateEntries(){
		new Ajax.Request(contextPath+"/GICLClaimListingInquiryController", {
			method: "GET",
			parameters: {
				action: "validateGICLS278Entries",
				lineCd: $F("lineCd"),
				sublineCd: $F("sublineCd"),
				polIssCd: $F("polIssCd"),
				polSeqNo: $F("polSeqNo"),
				issueYy: $F("issueYy"),
				renewNo: $F("renewNo"),
				moduleId: "GICLS278"
			},
			onCreate: showNotice("Please wait..."),
			onComplete: function(response){
				hideNotice("");
				if(checkErrorOnResponse(response)){
					if(response.responseText == "N"){
						showMessageBox("Record does not exist.", "I");
					}else{
						showSearchPolicyLOV();
					}
				}
			}
		});
	}
	
	function showLineLOV(){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {
					action: "getGICLS278LineLOV",
					moduleId: "GICLS278",
					filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%"
				},
				title: "List of Lines",
				width: 415,
				height: 386,
				columnModel:[
								{	id: "lineCd",
									title: "Line Code",
									width: "75px",
								},
				             	{	id: "lineName",
									title: "Line Name",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
			    noticeMessage: "Getting list, please wait...",
			    filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? nvl($F("lineCd"), "%") : "%",
	    		onSelect : function(row){
	    			if(row != undefined) {
						$("lineCd").value = row.lineCd;
						$("lineCd").setAttribute("lastValidValue", $F("lineCd"));
					}
					toggleToolbars();
				},
				onCancel: function(){
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("lineCd").value = $("lineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showLineLOV", e);
		}
	}
	
	function showSublineLOV(){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {
					action: "getGICLS278SublineLOV",
					lineCd: $F("lineCd"),
					moduleId: "GICLS278",
					filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%"
				},
				title: "List of Sublines",
				width: 430,
				height: 386,
				columnModel:[
								{	id: "sublineCd",
									title: "Subline Code",
									width: "90px",
								},
				             	{	id: "sublineName",
									title: "Subline Name",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
			    noticeMessage: "Getting list, please wait...",
			    filterText: $F("sublineCd") != $("sublineCd").getAttribute("lastValidValue") ? nvl($F("sublineCd"), "%") : "%",
			    onSelect : function(row){
	    			if(row != undefined) {
						$("sublineCd").value = row.sublineCd;
						$("sublineCd").setAttribute("lastValidValue", $F("sublineCd"));
					}
					toggleToolbars();
				},
				onCancel: function(){
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("sublineCd").value = $("sublineCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showSublineLOV", e);
		}
	}
	
	function showIssourceLOV(){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {
					action: "getGICLS278IssourceLOV",
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					moduleId: "GICLS278",
					filterText: $F("polIssCd") != $("polIssCd").getAttribute("lastValidValue") ? nvl($F("polIssCd"), "%") : "%"
				},
				title: "List of Issuing Sources",
				width: 415,
				height: 386,
				columnModel:[
								{	id: "issCd",
									title: "Issuing Code",
									width: "75px",
								},
				             	{	id: "issName",
									title: "Issuing Name",
									width: "325px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("polIssCd") != $("polIssCd").getAttribute("lastValidValue") ? nvl($F("polIssCd"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
	    			if(row != undefined) {
						$("polIssCd").value = row.issCd;
						$("polIssCd").setAttribute("lastValidValue", $F("polIssCd"));
					}
					toggleToolbars();
				},
				onCancel: function(){
					$("polIssCd").value = $("polIssCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("polIssCd").value = $("polIssCd").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIssourceLOV", e);
		}
	}
	
	function showIssueYyLOV(){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {
					action: "getGICLS278IssueYyLOV",
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					filterText: $F("issueYy") != $("issueYy").getAttribute("lastValidValue") ? nvl($F("issueYy"), "%") : "%"
				},
				title: "List of Issue Years",
				width: 370,
				height: 386,
				columnModel:[
								{	id: "issueYy",
									title: "Issue Year",
									width: "355px",
									align: 'right',
									titleAlign: 'right'
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
				filterText: $F("issueYy") != $("issueYy").getAttribute("lastValidValue") ? nvl($F("issueYy"), "%") : "%",
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
	    			if(row != undefined) {
						$("issueYy").value = row.issueYy;
						$("issueYy").setAttribute("lastValidValue", $F("issueYy"));
					}
					toggleToolbars();
				},
				onCancel: function(){
					$("issueYy").value = $("issueYy").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onUndefinedRow: function(){
					showMessageBox("No record selected.", "I");
					$("issueYy").value = $("issueYy").getAttribute("lastValidValue");
					toggleToolbars();
				},
				onShow: function(){
					$(this.id+"_txtLOVFindText").focus();
				}
			});
		}catch(e){
			showErrorMessage("showIssueYyLOV", e);
		}
	}
	
	function showSearchPolicyLOV(){
		try{
			LOV.show({
				controller: "ClaimsLOVController",
				urlParameters: {
					action: "getGICLS278PolicyLOV",
					lineCd: $F("lineCd"),
					sublineCd: $F("sublineCd"),
					polIssCd: $F("polIssCd"),
					polSeqNo: $F("polSeqNo"),
					issueYy: $F("issueYy"),
					renewNo: $F("renewNo"),
					moduleId: "GICLS278"
				},
				title: "List of Policies",
				width: 525,
				height: 386,
				columnModel:[
								{	id: "policyNo",
									title: "Policy Number",
									width: "160px",
								},
				             	{	id: "assdName",
									title: "Assured",
									width: "350px"
								}
							],
				draggable: true,
				showNotice: true,
				autoSelectOneRecord : true,
			    noticeMessage: "Getting list, please wait...",
				onSelect : function(row){
					if(row != undefined) {
						populatePolicyFields(row);
					}
				}
			});
		}catch(e){
			showErrorMessage("showSearchPolicyLOV", e);
		}
	}
	
	function showRecoveryDtls(){
		try{
			overlayRecoveryDetails = 
				Overlay.show(contextPath+"/GICLClaimListingInquiryController", {
					urlContent: true,
					urlParameters: {action: "showRecoveryDetails",																
									ajax: "1",
									claimId: selectedRow.claimId
					},
				    title: "Recovery Details",
				    height: 500,
				    width: 820,
				    draggable: true
				});
		}catch(e){
			showErrorMessage("showRecoveryDtls: ", e);
		}
	}
	
	function disableForm(){
		$$("input[name='policyNoField']").each(function(i){
			i.setAttribute("readonly", "readonly");
		});
		
		$$("input[name='dateRG']").each(function(i){
			i.disable();
		});
		
		disableSearch("searchLineCd");
		disableSearch("searchSublineCd");
		disableSearch("searchPolIssCd");
		disableSearch("searchIssueYy");
		disableSearch("searchPolicy");
		
		disableDate("hrefToDate");
		disableDate("hrefFromDate");
		disableDate("hrefAsOfDate");
		
		disableToolbarButton("btnToolbarExecuteQuery");
	}
	
	function executeQuery(){
		var dateType = $("claimFileDate").checked ? "1" : "2";
		
		polWithEnrolleesTG.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerPolicyWithEnrollees&refresh=1"+
									"&lineCd="+$F("lineCd")+"&sublineCd="+$F("sublineCd")+"&polIssCd="+$F("polIssCd")+"&issueYy="+$F("issueYy")+
									"&polSeqNo="+$F("polSeqNo")+"&renewNo="+$F("renewNo")+"&dateType="+dateType+
									"&fromDate="+$F("fromDate")+"&toDate="+$F("toDate")+"&asOfDate="+$F("asOfDate")+"&moduleId=GICLS278";
		polWithEnrolleesTG._refreshList();
		polWithEnrolleesTG.onRemoveRowFocus();
		
		disableForm();
		enableToolbarButton("btnToolbarPrint");
		enableButton("btnPrintClmPerPolicy");
		viewMode = true;
		
		if(polWithEnrolleesTG.geniisysRows.length > 0){
			getTotals();
		}else{
			clearTotals();
		}
	}
	
	function toggleToolbars(){
		if($F("lineCd") != "" && $F("sublineCd") != "" && $F("polIssCd") != "" && $F("issueYy") != "" && $F("polSeqNo") != "" && $F("renewNo") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			enableToolbarButton("btnToolbarExecuteQuery");
		}else if($F("lineCd") != "" || $F("sublineCd") != "" || $F("polIssCd") != "" || $F("issueYy") != "" || $F("polSeqNo") != "" || $F("renewNo") != ""){
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}else{
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
	}
	
	function printReport(){
		var fileType = $("rdoPdf").checked ? "PDF" : "CSV";//jm
		var dateType = $("claimFileDate").checked ? "1" : "2";
		
		var withCSV = null; //carloR 07.19.2016 SR 22767 start
		
		if($("rdoPdf").checked){
			withCSV = null;
		} else if($("rdoCsv").checked){
			withCSV = "Y";
		}//end
		
		var content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId=GICLR278"+
						"&lineCd="+$F("lineCd")+"&sublineCd="+$F("sublineCd")+"&polIssCd="+$F("polIssCd")+"&issueYy="+$F("issueYy")+
						"&polSeqNo="+$F("polSeqNo")+"&renewNo="+$F("renewNo")+"&dateType="+dateType+
						"&fromDate="+$F("fromDate")+"&toDate="+$F("toDate")+"&asOfDate="+$F("asOfDate")+"&fileType="+fileType;

		printGenericReport(content, "CLAIM LISTING PER POLICY WITH ENROLLEES", null, withCSV);
	}
	
	function resetForm(){
		$$("input[type='text']").each(function(i){
			i.value = "";
		});
		
		$("lineCd").focus();
		$("fromDate").disable();
		$("toDate").disable();
		disableDate("hrefToDate");
		disableDate("hrefFromDate");
		disableButton("btnPrintClmPerPolicy");
		disableButton("btnRecoveryDtls");
		disableToolbarButton("btnToolbarPrint");
		disableToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		
		$$("input[name='policyNoField']").each(function(i){
			i.removeAttribute("readonly");
			i.setAttribute("lastValidValue", "");
		});
		
		$$("input[name='dateRG']").each(function(i){
			i.enable();
		});
		
		enableSearch("searchLineCd");
		enableSearch("searchSublineCd");
		enableSearch("searchPolIssCd");
		enableSearch("searchIssueYy");
		enableSearch("searchPolicy");
		
		enableDate("hrefAsOfDate");
		$("claimFileDate").checked = true;
		$("asOf").checked = true;
		$("asOfDate").enable();
		$("asOfDate").value = sysdate;
		viewMode = false;
		
		$("asOfDate").addClassName("required");
		$("divAsOfDate").addClassName("required");
		
		$("fromDate").removeClassName("required");
		$("divFromDate").removeClassName("required");
		$("toDate").removeClassName("required");
		$("divToDate").removeClassName("required");
	}
	
	$("asOfDate").observe("focus", function(){
		var asOfDate = $F("asOfDate");
		
		if(asOfDate != ""){
			if(Date.parse(asOfDate) > Date.parse(sysdate)){
				showWaitingMessageBox("Date should not be greater than the current date.", "I", function(){
					$("asOfDate").value = sysdate;
					$("asOfDate").focus();
				});
			}
		}
	});
	
	$("fromDate").observe("focus", function(){
		if(Date.parse($F("fromDate")) > Date.parse(sysdate)){
			showWaitingMessageBox("Date should not be greater than the current date.", "I", function(){
				$("fromDate").value = "";
				$("fromDate").focus();
			});
		}else if($F("fromDate") != "" && $F("toDate") != ""){
			if(Date.parse($F("fromDate")) > Date.parse($F("toDate"))){
				showWaitingMessageBox("To Date must be greater than From Date.", "I", function(){
					$("fromDate").value = "";
					$("fromDate").focus();
				});
			}
		}
	});
	
	$("toDate").observe("focus", function(){
		if(Date.parse($F("toDate")) > Date.parse(sysdate)){
			showWaitingMessageBox("Date should not be greater than the current date.", "I", function(){
				$("toDate").value = "";
				$("toDate").focus();
			});
		}else if($F("fromDate") != "" && $F("toDate") != ""){
			if(Date.parse($F("fromDate")) > Date.parse($F("toDate"))){
				showWaitingMessageBox("To Date must be greater than From Date.", "I", function(){
					$("toDate").value = "";
					$("toDate").focus();
				});
			}
		}
	});
	
	$$("input[name='searchByRG']").each(function(r){
		r.observe("click", function(){
			if(viewMode){
				executeQuery();
			}
		});
	});
	
	$$("input[name='dateRG']").each(function(r){
		r.observe("click", function(){
			if(r.id == "asOf"){
				$("asOfDate").value = sysdate;
				$("asOfDate").enable();
				enableDate("hrefAsOfDate");
				
				$("fromDate").value = "";
				$("toDate").value = "";
				$("fromDate").disable();
				$("toDate").disable();
				disableDate("hrefToDate");
				disableDate("hrefFromDate");
				
				$("asOfDate").addClassName("required");
				$("divAsOfDate").addClassName("required");
				
				$("fromDate").removeClassName("required");
				$("divFromDate").removeClassName("required");
				$("toDate").removeClassName("required");
				$("divToDate").removeClassName("required");
			}else{
				$("asOfDate").value = "";
				$("asOfDate").disable();
				disableDate("hrefAsOfDate");
				
				$("fromDate").enable();
				$("toDate").enable();
				enableDate("hrefToDate");
				enableDate("hrefFromDate");
				
				$("asOfDate").removeClassName("required");
				$("divAsOfDate").removeClassName("required");
				
				$("fromDate").addClassName("required");
				$("divFromDate").addClassName("required");
				$("toDate").addClassName("required");
				$("divToDate").addClassName("required");
			}
		});
	});
	
	$("lineCd").observe("change", function(){
		if($F("lineCd") == ""){
			$("lineCd").setAttribute("lastValidValue", "");
		}else{
			showLineLOV();
		}
	});
	
	$("sublineCd").observe("change", function(){
		if($F("sublineCd") == ""){
			$("sublineCd").setAttribute("lastValidValue", "");
		}else{
			showSublineLOV();
		}
	});
	
	$("polIssCd").observe("change", function(){
		if($F("polIssCd") == ""){
			$("polIssCd").setAttribute("lastValidValue", "");
		}else{
			showIssourceLOV();
		}
	});
	
	$("issueYy").observe("change", function(){
		if($F("issueYy") == ""){
			$("issueYy").setAttribute("lastValidValue", "");
		}else{
			showIssueYyLOV();
		}
	});
	
	$("polSeqNo").observe("change", function(){
		if($F("polSeqNo") != ""){
			$("polSeqNo").value = $F("polSeqNo") != "" ? Number($F("polSeqNo")).toPaddedString(7) : "";
		}
		toggleToolbars();
	});
	
	$("renewNo").observe("change", function(){
		if($F("renewNo") != ""){
			$("renewNo").value = $F("renewNo") != "" ? Number($F("renewNo")).toPaddedString(2) : "";
		}
		toggleToolbars();
	});
	
	$("searchLineCd").observe("click", function(){
		showLineLOV();
	});
	
	$("searchSublineCd").observe("click", function(){
		showSublineLOV();
	});
	
	$("searchPolIssCd").observe("click", function(){
		showIssourceLOV();
	});
	
	$("searchIssueYy").observe("click", function(){
		showIssueYyLOV();
	});
	
	$("searchPolicy").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("policyNoDiv")){
			validateEntries();
		}
	});
	
	$("btnRecoveryDtls").observe("click", function(){
		objRecovery = new Object();
		objRecovery.claimId = selectedRow.claimId;
		showRecoveryDtls();
	});
	
	$("btnPrintClmPerPolicy").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Policy with Enrollees", printReport, null, "true");
		$("csvOptionDiv").show(); //carlo
	});
	
	$("btnToolbarPrint").observe("click", function(){
		showGenericPrintDialog("Print Claim Listing per Policy with Enrollees", printReport, null, "true");
		$("csvOptionDiv").show(); //SR-5414
	});
	
	$("btnToolbarEnterQuery").observe("click", function(){
		resetForm();
		polWithEnrolleesTG.url = contextPath +"/GICLClaimListingInquiryController?action=showClaimListingPerPolicyWithEnrollees&refresh=1";
		polWithEnrolleesTG._refreshList();
	});
	
	$("btnToolbarExecuteQuery").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("perPolicyWEnrolleesDiv")){
			executeQuery();
		}
	});
	
	$("btnToolbarExit").observe("click", function(){
		delete objRecovery;
		goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
	});
	
	observeBackSpaceOnDate("asOfDate");
	observeBackSpaceOnDate("fromDate");
	observeBackSpaceOnDate("toDate");
	initializeAll();
	resetForm();
</script>