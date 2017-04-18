<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<div id="mainNavPerPackagePolicy">
 	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="btnExit">Exit</a></li>
			</ul>
		</div>
	</div>
</div>
<div id="clmListingPackagePerPolicyMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Claim Listing Per Package Policy</label>
	   </div>
	</div>	
	<div class="sectionDiv" style="padding: 0 0 10px 0;">
		<div id="packagePerPolicyDiv" style="float: left;">
			<table border="0" style="margin: 10px 10px 5px 60px;">
				<tr>
					<td class="rightAligned">Package Policy No.</td>
					<td style="text-align: left;">
						<span id="lineCdSpan" class="lovSpan required" style="width: 50px;">
							<input type="text" id="txtLineCd" style="width: 25px; float: left;" class="withIcon upper required disableDelKey" maxlength="2" tabindex="101"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchLineCd" alt="Go" style="float: right;" tabindex="102"/>
						</span>
					</td>
					<td style="text-align: left;">
						<span id="sublineCdSpan" class="lovSpan" style="width: 98px;">
							<input type="text" id="txtSublineCd" style="width: 65px; float: left;" class="withIcon upper disableDelKey" maxlength="7" tabindex="103"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchSublineCd" alt="Go" style="float: right;" tabindex="104"/>
						</span>
					</td>
					<td style="text-align: left;">
						<span class="lovSpan" style="width: 50px;">
							<input type="text" id="txtPolIssCd" style="width: 25px; float: left;" class="withIcon upper disableDelKey" maxlength="2" tabindex="105"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPolIssCd" alt="Go" style="float: right;" tabindex="106"/>
						</span>
					</td>
					<td style="text-align: left;">
						<span class="lovSpan" style="width: 50px;">
							<input type="text" id="txtIssueYy" style="width: 25px; float: left;" class="withIcon upper disableDelKey" maxlength="2" tabindex="107"/>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchIssueYy" alt="Go" style="float: right;" tabindex="108"/>
						</span>
					</td>
					<td style="text-align: left;">
						<input type="text" id="txtPolSeqNo" style="width: 60px; height: 14px; margin: 0 0 2px 0" class="integerUnformatted" lpad="7" maxlength="7" tabindex="109">
					</td>
					<td style="text-align: left;">
						<input type="text" id="txtRenewNo" style="width: 20px; height: 14px; margin: 0 0 2px 0" class="integerUnformatted" lpad="2" maxlength="2" tabindex="110">
					</td>
					<td style="text-align: left;">
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchPakPolicy" alt="Go" style="float: right; margin-bottom: 4px;" tabindex="111"/>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured Name&nbsp;</td>
					<td colspan="6">
						<input style="width: 98%; margin: 0;" type="text" id="txtAssuredName" readonly="readonly" tabindex="112" />			
					</td>
					<td></td>
				</tr>
			</table>
			<div style="float: left; margin-left: 173px; margin-bottom: 10px;">
				<fieldset style="width: 356px;">
					<legend>Search By</legend>
					<table>
						<tr>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoClaimFileDate" style="float: left; margin: 3px 2px 3px 75px;" tabindex="113"  />
								<label for="rdoClaimFileDate" style="float: left; height: 20px; padding-top: 3px;" title="Claim File Date">Claim File Date</label>
							</td>
							<td class="rightAligned">
								<input type="radio" name="searchBy" id="rdoLossDate" style="float: left; margin: 3px 2px 3px 45px;" tabindex="114" />
								<label for="rdoLossDate" style="float: left; height: 20px; padding-top: 3px;" title="Loss Date">Loss Date</label>
							</td>
						</tr>
					</table>
				</fieldset>
			</div>
		</div>
		<div class="sectionDiv" style="float: right; width: 255px; margin: 12px 60px 0 0;">
			<table style="margin: 8px;">	
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoAsOf" style="float: left;" tabindex="201"/><label for="rdoAsOf" style="float: left; height: 20px; padding-top: 3px;">As of</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divAsOf">
							<input type="text" removeStyle="true" id="txtAsOf" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="202"/>
							<img id="imgAsOf" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="As of Date" tabindex="203"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned"><input type="radio" name="byDate" id="rdoFrom" title="From" style="float: left;" tabindex="204"/><label for="rdoFrom" style="float: left; height: 20px; padding-top: 3px;">From</label></td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divFrom">
							<input type="text" removeStyle="true" id="txtFrom" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="205"/>
							<img id="imgFrom" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="From Date" tabindex="206"/>
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">To</td>
					<td class="leftAligned">
						<div style="float: left; width: 165px;" class="withIconDiv" id="divTo">
							<input type="text" removeStyle="true" id="txtTo" class="withIcon" readonly="readonly" style="width: 140px;" tabindex="207"/>
							<img id="imgTo" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="To Date" tabindex="208"/>
						</div>
					</td>
				</tr>
			</table>
		</div>
	</div>	
	<div class="sectionDiv" style="margin-bottom: 50px;">
		<div id="perPackagePolicyTableDiv" style="padding: 10px 0 0 10px;">
			<div id="perPackagePolicyTable" style="height: 300px; margin-left: auto;"></div>
		</div>
		<div style="margin: 5px; float: left; margin-left: 20px;">
			<table>
				<tr>
					<td>
						<input type="button" id="btnRecoveryDetails" class="disabledButton" value="Recovery Details" tabindex="301" />
					</td>
				</tr>		
			</table>	
		</div>
		<div style="margin: 5px; float: right; margin-right: 20px;">
			<table>
				<tr>
					<td class="rightAligned">Totals</td>
					<td class=""><input type="text" id="txtTotLossReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="302"/></td>
					<td class=""><input type="text" id="txtTotExpenseReserve" style="width: 120px; text-align: right;" readonly="readonly" tabindex="303"/></td>
					<td class=""><input type="text" id="txtTotLossesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="304"/></td>
					<td class=""><input type="text" id="txtTotExpensesPaid" style="width: 120px; text-align: right;" readonly="readonly" tabindex="305"/></td>
				</tr>
			</table>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Policy Number</td>
					<td class="leftAligned"><input type="text" id="txtPolicyNo" style="width: 370px;" readonly="readonly" tabindex="401"/></td>
					<td width="50px"></td>
					<td class="rightAligned">Loss Date</td>
					<td class="leftAligned"><input type="text" id="txtLossDate" style="width: 230px;" readonly="readonly" tabindex="403"/></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 110px;">Claim Status</td>
					<td class="leftAligned"><input type="text" id="txtClaimStatus" style="width: 370px;" readonly="readonly" tabindex="402"/></td>
					<td></td>
					<td class="rightAligned">File Date</td>
					<td class="leftAligned"><input type="text" id="txtFileDate" style="width: 230px;" readonly="readonly" tabindex="404"/></td>
				</tr>			
			</table>
		</div>
		<div style="float: left; width: 100%; margin-bottom: 10px;" align="center">
			<input type="button" class="disabledButton" id="btnPrintReport" value="Print Report" tabindex="501"/>
		</div>
	</div>		
</div>
<script type="text/javascript">
	try{
		var onLOV = false;
		var withRcvry = false;
		setModuleId("GICLS274");
		setDocumentTitle("Claim Listing Per Package Policy");
		
		function initGICLS274() {
			$("txtLineCd").focus();
			$("rdoAsOf").checked = true;
			$("rdoClaimFileDate").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableFromToFields();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			setPrintButtons(false);
// 			$("lineCdSpan").setStyle({backgroundColor: '#FFFACD'});
// 			$("txtLineCd").setStyle({backgroundColor: '#FFFACD'});
// 			$("sublineCdSpan").setStyle({backgroundColor: '#FFFACD'});
// 			$("txtSublineCd").setStyle({backgroundColor: '#FFFACD'});
	    	objPackagePolicy = new Object();
	    	objRecovery = new Object();
	    	makeInputFieldUpperCase();
	    	onLOV = false;
	    }
		
		function setPrintButtons(x){
			if(x){
				enableButton("btnPrintReport");
				enableToolbarButton("btnToolbarPrint");
			} else {
				disableButton("btnPrintReport");
				disableToolbarButton("btnToolbarPrint");
				
			}
		}
		
		function resetForm(){
			enableSearch("imgSearchLineCd");
			enableSearch("imgSearchSublineCd");
			enableSearch("imgSearchPolIssCd");
			enableSearch("imgSearchIssueYy");
			enableSearch("imgSearchPakPolicy");
			$("txtLineCd").readOnly = false;
			$("txtSublineCd").readOnly = false;
			$("txtPolIssCd").readOnly = false;
			$("txtIssueYy").readOnly = false;
			$("txtPolSeqNo").readOnly = false;
			$("txtRenewNo").readOnly = false;
			$("txtLineCd").clear();
			$("txtSublineCd").clear();
			$("txtPolIssCd").clear();
			$("txtIssueYy").clear();
			$("txtPolSeqNo").clear();
			$("txtRenewNo").clear();
			$("txtAssuredName").clear();
			$("rdoAsOf").enable();
			$("rdoClaimFileDate").checked = false;
			$("rdoLossDate").checked = false;
			$("rdoFrom").disabled = false;
			setDetails(null);
			$("txtTotLossReserve").clear();
			$("txtTotExpenseReserve").clear();
			$("txtTotLossesPaid").clear();
			$("txtTotExpensesPaid").clear();
			tbgClaimsPerPackagePolicy.url = contextPath+"/GICLClaimListingInquiryController?action=getClmListPerPackagePolicy&refresh=1";
			tbgClaimsPerPackagePolicy._refreshList();
			disableButton("btnRecoveryDetails");
			disableButton("btnPrintReport");
			initGICLS274();
			withRcvry = false;
		}
		
		function disableFromToFields() {
			$("txtAsOf").disabled = false;
			$("imgAsOf").disabled = false;
			$("txtFrom").disabled = true;
			$("txtTo").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			$("txtFrom").value = "";
			$("txtTo").value = "";
			$("rdoAsOf").checked = true;
			$("txtAsOf").value = getCurrentDate();
			disableDate("imgFrom");
			disableDate("imgTo");
			enableDate("imgAsOf");
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: 'white'});
			$("divAsOf").setStyle({backgroundColor: 'white'});
		}
		
		function disableAsOfFields() {
			$("txtFrom").disabled = false;
			$("imgFrom").disabled = false;
			$("imgTo").disabled = false;
			$("txtTo").disabled = false;
			$("txtAsOf").disabled = true;
			$("imgAsOf").disabled = true;
			$("txtAsOf").value = "";
			$("rdoFrom").checked = true;
			disableDate("imgAsOf");
			enableDate("imgFrom");
			enableDate("imgTo");
			$("txtFrom").setStyle({backgroundColor: '#FFFACD'});
			$("divFrom").setStyle({backgroundColor: '#FFFACD'});
			$("txtTo").setStyle({backgroundColor: '#FFFACD'});
			$("divTo").setStyle({backgroundColor: '#FFFACD'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
		}
		
		function disableFields() {
			$("rdoAsOf").disable();
			$("txtAsOf").disable();
			$("rdoFrom").disable();
			$("txtFrom").disable();
			$("txtTo").disable();
			$("imgAsOf").disabled = true;
			$("imgFrom").disabled = true;
			$("imgTo").disabled = true;
			disableSearch("imgSearchLineCd");
			disableSearch("imgSearchSublineCd");
			disableSearch("imgSearchPolIssCd");
			disableSearch("imgSearchIssueYy");
			disableSearch("imgSearchPakPolicy");
			disableDate("imgAsOf");
			disableDate("imgFrom");
			disableDate("imgTo");
			$("txtAssuredName").readOnly = true;
			$("txtFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("divFrom").setStyle({backgroundColor: '#F0F0F0'});
			$("txtTo").setStyle({backgroundColor: '#F0F0F0'});
			$("divTo").setStyle({backgroundColor: '#F0F0F0'});
			$("txtAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("divAsOf").setStyle({backgroundColor: '#F0F0F0'});
			$("txtLineCd").readOnly = true;
			$("txtSublineCd").readOnly = true;
			$("txtPolIssCd").readOnly = true;
			$("txtIssueYy").readOnly = true;
			$("txtPolSeqNo").readOnly = true;
			$("txtRenewNo").readOnly = true;
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		
		function executeQuery(){
			tbgClaimsPerPackagePolicy.url = contextPath+"/GICLClaimListingInquiryController?action=getClmListPerPackagePolicy&refresh=1&packPolicyId="+ objPackagePolicy.packagePolicyId + getParams();
			tbgClaimsPerPackagePolicy._refreshList();
			if(tbgClaimsPerPackagePolicy.geniisysRows.length == 0){
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtLineCd");
				setPrintButtons(false);
			} else {
				setPrintButtons(true);
			}
			disableFields();
		}
		
		function setDetails(obj){

			if(obj != null){
				if(obj.recoveryDetCount > 0){
					objRecovery.claimId = obj.claimId;
					enableButton("btnRecoveryDetails");
				} else {
					disableButton("btnRecoveryDetails");
				} 
			} else {
				disableButton("btnRecoveryDetails");
			}
			$("txtPolicyNo").value = obj == null ? "" : obj.polNo;
			$("txtLossDate").value = obj == null ? "" : dateFormat(obj.dspLossDate, "mm-dd-yyyy");
			$("txtClaimStatus").value = obj == null ? "" : obj.clmStatDesc;
			$("txtFileDate").value = obj == null ? "" : dateFormat(obj.clmFileDate, "mm-dd-yyyy");
		}

		function showClmPackLineCdLOV(){
			onLOV = true;
	 		LOV.show({
	 			controller: "ClaimsLOVController",
	 			urlParameters: {action : "getClmPackLineLOV",
	 							searchLineCd : $("txtLineCd").value,
	 							page : 1},
	 			title: "",
	 			width: 405,
	 			height: 386,
	 			columnModel : [	{	id : "code",
	 								title: "Line Code",
	 								width: '100px'
	 							},
	 							{	id : "codeDesc",
	 								title: "Line Name",
	 								width: '290px'
	 							}
	 						],
	 			draggable: true,
	 			autoSelectOneRecord: true,
				filterText:  $("txtLineCd").value,
	 			onSelect: function(row){
	 				$("txtLineCd").value = row.code;
	 				$("txtSublineCd").focus();
	 				onLOV = false;
	 				enableToolbarButton("btnToolbarEnterQuery");
	 			},
	 	  		onCancel: function(){
	 	  			$("txtLineCd").focus();
	 	  			onLOV = false;
	 	  		},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
					onLOV = false;
				}
	 		  });
	 	}
		
		function showClmPackSublineCdLOV(){
			onLOV = true;
	 		LOV.show({
	 			controller: "ClaimsLOVController",
	 			urlParameters: {action : "getClmPackSublineLOV", 
	 				            lineCd : $("txtLineCd").value,
	 				            searchSublineCd : $("txtSublineCd").value,
	 							page : 1},
	 			title: "",
	 			width: 405,
	 			height: 386,
	 			columnModel : [	{	id : "code",
	 								title: "Subline Code",
	 								width: '100px'
	 							},
	 							{	id : "codeDesc",
	 								title: "Subline Name",
	 								width: '290px'
	 							}
	 						],
	 			draggable: true,
	 			autoSelectOneRecord: true,
				filterText:  $("txtSublineCd").value,
	 			onSelect: function(row){
	 					$("txtSublineCd").value = row.code;
	 					$("txtPolIssCd").focus();
	 					onLOV = false;
	 					enableToolbarButton("btnToolbarEnterQuery");
	 			},
	 	  		onCancel: function(){
	 	  			$("txtSublineCd").focus();
	 	  			onLOV = false;
	 	  		},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtSublineCd");
					onLOV = false;
				}
	 		  });
	 	}
		
		function showClmPackIssCdLOV(){
			onLOV = true;
	 		LOV.show({
	 			controller: "ClaimsLOVController",
	 			urlParameters: {action : "getClmPackIssLOV",
	 							lineCd : $("txtLineCd").value,
	 							sublineCd : $("txtSublineCd").value,
	 							searchPolIssCd : $("txtPolIssCd").value,
	 							page : 1},
	 			title: "",
	 			width: 405,
	 			height: 386,
	 			columnModel : [	{	id : "code",
	 								title: "Issuing Code",
	 								width: '100px'
	 							},
	 							{	id : "codeDesc",
	 								title: "Issuing Name",
	 								width: '290px'
	 							}
	 						],
	 			draggable: true,
	 			autoSelectOneRecord: true,
				filterText:  $("txtPolIssCd").value,
	 			onSelect: function(row){
	 				onLOV = false;
 					$("txtPolIssCd").value = row.code;
 					$("txtIssueYy").focus();
 					enableToolbarButton("btnToolbarEnterQuery");
	 			},
	 	  		onCancel: function(){
	 	  			onLOV = false;
	 	  			$("txtPolIssCd").focus();
	 	  		},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPolIssCd");
					onLOV = false;
				}
	 		  });
	 	}
		
		function showClmPackIssueYyLOV(){
			onLOV = true;
	 		LOV.show({
	 			controller: "ClaimsLOVController",
	 			urlParameters: {action : "getClmPackIssueYyLOV", 
	 							lineCd : $("txtLineCd").value,
	 							sublineCd: $("txtSublineCd").value,
	 							polIssCd: $("txtPolIssCd").value,
	 							page : 1},
	 			title: "",
	 			width: 405,
	 			height: 386,
	 			columnModel : [	{	id : "code",
	 								title: "Issuing Year",
	 								width: '100px'
	 							} 
	 						],
	 			draggable: true,
	 			autoSelectOneRecord: true,
	 			filterText : $("txtIssueYy").value,
	 			onSelect: function(row){
	 				$("txtIssueYy").value = row.code;
	 				$("txtPolSeqNo").focus();
	 				onLOV = false;
	 				enableToolbarButton("btnToolbarEnterQuery");
	 			},
	 	  		onCancel: function(){
	 	  			$("txtIssueYy").focus();
	 	  			onLOV = false;
	 	  		},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIssueYy");
					onLOV = false;
				}
	 		  });
	 	}
		
		function showGICLS274PakPolicyLOV(){
	 		onLOV = true;
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getClmListPerPackagePolicyLov",
					lineCd : $F("txtLineCd"),
					sublineCd : $F("txtSublineCd"),
					issCd : $F("txtPolIssCd"),
					issueYy : $F("txtIssueYy"),
					polSeqNo : $F("txtPolSeqNo"),
					renewNo : $F("txtRenewNo"),
					page : 1
				},
				title : "List of Package Policy",
				width : 607,
				height : 405,
				columnModel : [ 
				{		
					id : "lineCd",
					title : "Line",
					width : '30px',
				}, {
					id : "sublineCd",
					title : "Subline",
					width : '50px',
				}, {
					id : "issCd",
					title : "Pol Iss",
					width : '50px',
				}, {
					id : "issueYy",
					title : "Issue YY",
					width : '60px',
				}, {
					id : "polSeqNo",
					title : "Pol Seq No",
					width : '75px',
				}, {
					id : "renewNo",
					title : "Renew No",
					width : '70px',
				},
				{
					id : "assdName",
					title : "Assured",
					width : '195px',
					
				},
				{
					id : "packPolicyId",
					title : "Pack Policy Id",
					width : '50px',
					visible : false
					
				}],
				draggable : true,
				autoSelectOneRecord: true,
				onSelect : function(row) {
					onLOV = false;
					objPackagePolicy.packagePolicyId = row.packPolicyId;
					$("txtLineCd").value = row.lineCd;
					$("txtSublineCd").value = row.sublineCd;
					$("txtPolIssCd").value = row.issCd;
					$("txtIssueYy").value = row.issueYy;
					$("txtPolSeqNo").value = lpad(row.polSeqNo,7,0); //added by steven 5/25/2013
					$("txtRenewNo").value = lpad(row.renewNo,2,0); //added by steven 5/25/2013
					$("txtAssuredName").value = unescapeHTML2(row.assdName);
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel : function(){
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "imgSearchPakPolicy");
					onLOV = false;
				}
			});
		}
		
		var jsonClmListPerPackagePolicy = JSON.parse('${jsonClmListPerPackagePolicy}');	
		perPackagePolicyTableModel = {
				options: {
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '900px',
					pager: {
					},  
					onCellFocus : function(element, value, x, y, id) {
						setDetails(tbgClaimsPerPackagePolicy.geniisysRows[y]);					
						tbgClaimsPerPackagePolicy.keys.removeFocus(tbgClaimsPerPackagePolicy.keys._nCurrentFocus, true);
						tbgClaimsPerPackagePolicy.keys.releaseKeys();
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						setDetails(null);
						tbgClaimsPerPackagePolicy.keys.removeFocus(tbgClaimsPerPackagePolicy.keys._nCurrentFocus, true);
						tbgClaimsPerPackagePolicy.keys.releaseKeys();
					}
				},									
				columnModel: [
					{
					    id: 'recordStatus',
					    title: '',
					    width: '0',
					    visible: false
					},
					{
						id: 'divCtrId',
						width: '0',
						visible: false 
					},				
					{
						id : "recoverySw",
						title: "R",
						altTitle : 'With Recovery',
						width: '30px',					
						align : "left",
						titleAlign : "left",
						editable: false,
						defaultValue: false,
						otherValue:false,
						filterOption : true,
						filterOptionType : 'checkbox',
						editor:new MyTableGrid.CellCheckbox({getValueOf : function(value) {
							if (value){
								return"Y";
							}else{
								return"N";
							}
						}})
					},				
					{
						id : "claimNo",
						title: "Claim Number",
						width: '270px',
						filterOption: true
					},
					{
						id : "lossReserve",
						title: "Loss Reserve",
						width: '140px',
						align : "right",
						titleAlign: "right",
						filterOption: true,
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "expenseReserve",
						title: "Expense Reserve",
						width: '140px',
						align : "right",
						titleAlign: "right",
						filterOption: true,
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "lossesPaid",
						title: "Losses Paid",
						width: '140px',
						align : "right",
						titleAlign: "right",
						filterOption: true,
						geniisysClass : 'money',
						filterOptionType : 'number'
					},
					{
						id : "expensesPaid",
						title: "Expenses Paid",
						width: '140px',
						align : "right",
						titleAlign: "right",
						filterOption: true,
						geniisysClass : 'money',
						filterOptionType : 'number'
					}
					
				],
				rows: jsonClmListPerPackagePolicy.rows
			};
		
		tbgClaimsPerPackagePolicy = new MyTableGrid(perPackagePolicyTableModel);
		tbgClaimsPerPackagePolicy.pager = jsonClmListPerPackagePolicy;
		tbgClaimsPerPackagePolicy.render('perPackagePolicyTable');
		tbgClaimsPerPackagePolicy.afterRender = function(){
			setDetails(null);
			if(tbgClaimsPerPackagePolicy.geniisysRows.length > 0){
				var rec = tbgClaimsPerPackagePolicy.geniisysRows[0];
				$("txtTotLossReserve").value = formatCurrency(rec.totLossResAmt);
				$("txtTotLossesPaid").value = formatCurrency(rec.totLossPdAmt);
				$("txtTotExpenseReserve").value = formatCurrency(rec.totExpResAmt);
				$("txtTotExpensesPaid").value = formatCurrency(rec.totExpPdAmt);
			} else {
				$("txtTotLossReserve").value = "";
				$("txtTotLossesPaid").value = "";
				$("txtTotExpenseReserve").value = "";
				$("txtTotExpensesPaid").value = "";
			}
			for(var i = 0; i < tbgClaimsPerPackagePolicy.geniisysRows.length; i++){
				if(tbgClaimsPerPackagePolicy.geniisysRows[i].recoveryDetCount == 1){
					withRcvry = true;
				}
			}
		};
		
		function getParams() {
			var params = "";
			if($("rdoClaimFileDate").checked)
				params = "&searchByOpt=fileDate";
			else
				params = "&searchByOpt=lossDate";
			params = params + "&dateAsOf=" + $("txtAsOf").value + "&dateFrom=" + $("txtFrom").value + "&dateTo=" + $("txtTo").value;
			return params;
		}
	 	
	 	function changeSearchByOption() {
	 		if($("txtLineCd").readOnly) {
		 		tbgClaimsPerPackagePolicy.url = contextPath+"/GICLClaimListingInquiryController?action=getClmListPerPackagePolicy&refresh=1&packPolicyId="+ objPackagePolicy.packagePolicyId + getParams();
				tbgClaimsPerPackagePolicy._refreshList();
				
				if(tbgClaimsPerPackagePolicy.geniisysRows.length == 0){
					setPrintButtons(false);
				} else {
					setPrintButtons(true);
				}
	 		}
	 	}
		
		function showSublineLov(){
			if(trim($("txtLineCd").value) == ""){
				$("txtLineCd").clear();
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtLineCd");
			} else
				/* added by steven 5/25/2013 to handle the issue on;When the LOV contains 1 record only. After 
				clicking the magnifying glass icon the LOV was displayed in a split second. It should not be displayed. */
				var findText = $F("txtSublineCd").trim() == "" ? "%" : $F("txtSublineCd");
				if(onLOV)
					return;
				var cond = validateTextFieldLOV("/ClaimsLOVController?action=getClmPackSublineLOV&searchSublineCd=''&lineCd="+encodeURIComponent($F("txtLineCd")),findText,null);
				if (cond == 2) {
					showClmPackSublineCdLOV();
				} else if(cond == 0) {
					showMessageBox("There's no record found.", imgMessage.INFO);
				}else{
					var row = cond.rows[0];
					$("txtSublineCd").value = row.code;
					$("txtPolIssCd").focus();
					onLOV = false;
					enableToolbarButton("btnToolbarEnterQuery");
				}
		}
		
		function showIssueYyLov(){
			if(trim($("txtLineCd").value) == ""){
				$("txtLineCd").clear();
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtLineCd");
			} else if(trim($("txtSublineCd").value) == "") {
				$("txtSublineCd").clear();
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtSublineCd");
			}else
				/* added by steven 5/25/2013 to handle the issue on;When the LOV contains 1 record only. After 
				clicking the magnifying glass icon the LOV was displayed in a split second. It should not be displayed. */
				var findText = $F("txtIssueYy").trim() == "" ? "%" : $F("txtIssueYy");
				if(onLOV)
					return;
				var cond = validateTextFieldLOV("/ClaimsLOVController?action=getClmPackIssueYyLOV&lineCd="+encodeURIComponent($F("txtLineCd"))+"&sublineCd="+encodeURIComponent($F("txtSublineCd"))+"&polIssCd="+encodeURIComponent($F("txtPolIssCd")),findText,null);
				if (cond == 2) {
					showClmPackIssueYyLOV();
				} else if(cond == 0) {
					showMessageBox("There's no record found.", imgMessage.INFO);
				}else{
					var row = cond.rows[0];
					$("txtIssueYy").value = row.code;
	 				$("txtPolSeqNo").focus();
	 				onLOV = false;
	 				enableToolbarButton("btnToolbarEnterQuery");
				}
		}
		
		function showPackagePolicyLov(){
 			if(trim($("txtLineCd").value) == ""){
 				$("txtLineCd").clear();
 				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtLineCd");
 			} /* else if(trim($("txtSublineCd").value) == "") {
 				$("txtSublineCd").clear();
 				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtSublineCd");	
 			} */ else {
 				showGICLS274PakPolicyLOV();
 			}

			/* added by steven 5/25/2013 to handle the issue on;When the LOV contains 1 record only. After 
			clicking the magnifying glass icon the LOV was displayed in a split second. It should not be displayed. */
			/* if (checkAllRequiredFieldsInDiv("packagePerPolicyDiv")) { //added by steven 5/25/2013
				var cond = validateTextFieldLOV("/ClaimsLOVController?action=getClmListPerPackagePolicyLov&lineCd="+encodeURIComponent($F("txtLineCd"))+
																										 "&sublineCd="+encodeURIComponent($F("txtSublineCd"))+
																										 "&issCd="+encodeURIComponent($F("txtPolIssCd"))+
																										 "&issueYy="+encodeURIComponent($F("txtIssueYy"))+
																										 "&polSeqNo="+encodeURIComponent($F("txtPolSeqNo"))+
																										 "&renewNo="+encodeURIComponent($F("txtRenewNo")),"%",null);
				if (cond == 2) {
					showGICLS274PakPolicyLOV();
				} else if(cond == 0) {
					showMessageBox("No record found.", imgMessage.INFO);
				}else{
					var row = cond.rows[0];
					onLOV = false;
					objPackagePolicy.packagePolicyId = row.packPolicyId;
					$("txtLineCd").value = row.lineCd;
					$("txtSublineCd").value = row.sublineCd;
					$("txtPolIssCd").value = row.issCd;
					$("txtIssueYy").value = row.issueYy;
					$("txtPolSeqNo").value = lpad(row.polSeqNo,7,0); 
					$("txtRenewNo").value = lpad(row.renewNo,2,0); 
					$("txtAssuredName").value = unescapeHTML2(row.assdName);
					enableToolbarButton("btnToolbarExecuteQuery");
				}
			} */
		}
		
		function validateRequiredDates(){
			if($("rdoFrom").checked){
				if($("txtFrom").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtFrom");
					return false;	
				}
				else if($("txtTo").value == ""){
					customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.INFO, "txtTo");
					return false;	
				}
			}
			return true;	
		}
		
		function showRecoveryDetails() {
			try {
				overlayRecoveryDetails = Overlay.show(contextPath
						+ "/GICLClaimListingInquiryController", {
					urlContent : true,
					urlParameters : {
						action : "showRecoveryDetails",
						ajax : "1",
						claimId : objRecovery.claimId},
					title : "Recovery Details",
					height: 500,
				    width: 820,
					draggable : true
				});
			} catch (e) {
				showErrorMessage("overlay error: ", e);
			}
		}
		
		//line LOV
		$("imgSearchLineCd").observe("click", function(){
			/* added by steven 5/25/2013 to handle the issue on;When the LOV contains 1 record only. After 
			clicking the magnifying glass icon the LOV was displayed in a split second. It should not be displayed. */
			var findText = $F("txtLineCd").trim() == "" ? "%" : $F("txtLineCd");
			if(onLOV)
				return;
			var cond = validateTextFieldLOV("/ClaimsLOVController?action=getClmPackLineLOV&searchLineCd=''",findText,null);
			if (cond == 2) {
				showClmPackLineCdLOV();
			} else if(cond == 0) {
				showMessageBox("There's no record found.", imgMessage.INFO);
			}else{
				var row = cond.rows[0];
				$("txtLineCd").value = row.code;
 				$("txtSublineCd").focus();
 				onLOV = false;
 				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
		
		$("txtLineCd").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showClmPackLineCdLOV();
		    }
			if(!$("txtLineCd").readOnly)
		    	$("txtAssuredName").clear(); 
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		});
		
		$("imgSearchLineCd").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showClmPackLineCdLOV();
		    }
		});
		
		$("btnToolbarExecuteQuery").observe("click", function(){
			if(validateRequiredDates())
				executeQuery();
		});
		
		//subline lov
		$("imgSearchSublineCd").observe("click", function(){
			if(onLOV)
				return;
			showSublineLov();
		});
		
		$("txtSublineCd").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showSublineLov();
		    }	
			if(!$("txtSublineCd").readOnly)
		    	$("txtAssuredName").clear(); 
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		});
		
		$("imgSearchSublineCd").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showSublineLov();
		    }
		});
		
		//polIssCd lov
		$("imgSearchPolIssCd").observe("click", function(){
			if(onLOV)
				return;
			/* added by steven 5/25/2013 to handle the issue on;When the LOV contains 1 record only. After 
			clicking the magnifying glass icon the LOV was displayed in a split second. It should not be displayed. */
			var findText = $F("txtPolIssCd").trim() == "" ? "%" : $F("txtPolIssCd");
			if(onLOV)
				return;
			var cond = validateTextFieldLOV("/ClaimsLOVController?action=getClmPackIssLOV&searchPolIssCd=''&lineCd="+encodeURIComponent($F("txtLineCd"))+"&sublineCd="+encodeURIComponent($F("txtSublineCd")),findText,null);
			if (cond == 2) {
				showClmPackIssCdLOV();
			} else if(cond == 0) {
				showMessageBox("There's no record found.", imgMessage.INFO);
			}else{
				var row = cond.rows[0];
				onLOV = false;
				$("txtPolIssCd").value = row.code;
				$("txtIssueYy").focus();
				enableToolbarButton("btnToolbarEnterQuery");
			}
		});
		
		$("txtPolIssCd").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showClmPackIssCdLOV();
		    }
			if(!$("txtPolIssCd").readOnly)
		    	$("txtAssuredName").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		});
		
		$("imgSearchPolIssCd").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showClmPackIssCdLOV();
		    }
		});
		
		
		//Issue year LOV
		$("imgSearchIssueYy").observe("click", function(){
			if(onLOV)
				return;
			showIssueYyLov();
		});
		
		$("txtIssueYy").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showIssueYyLov();
		    }
			if(!$("txtIssueYy").readOnly)
		    	$("txtAssuredName").clear();
			disableToolbarButton("btnToolbarExecuteQuery");
			enableToolbarButton("btnToolbarEnterQuery");
		});
		
		$("imgSearchIssueYy").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showIssueYyLov();
		    }
		});
		
		//Package Policy
	 	$("imgSearchPakPolicy").observe("click",  function(){
	 		if(onLOV)
	 			return;
	 		showPackagePolicyLov();
	 	});
		
		$("imgSearchPakPolicy").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showPackagePolicyLov();
			}
		});
		
		$("txtPolSeqNo").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showPackagePolicyLov();
			}
			if(!$("txtPolSeqNo").readOnly)
				$("txtAssuredName").clear();
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
		});
		
		$("txtRenewNo").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN) {
				if(onLOV)
					return;
				showPackagePolicyLov();
			}
			enableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			if(!$("txtRenewNo").readOnly)
				$("txtAssuredName").clear();
		});
		
		
		$("btnPrintReport").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing Per Package Policy", onOkPrintGicls274, onLoadPrintGicls274, true);	
		});
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print Claim Listing Per Package Policy", onOkPrintGicls274, onLoadPrintGicls274, true);
		});
		
		function onLoadPrintGicls274(){
			var content = "<table border='0' style='margin: auto; margin-top: 5px; margin-left: 102px; margin-bottom: 0px;'>"+
						  "<tr><td><input type='checkbox' id='chkClmListingPerPolicy' style='float: left;'><label for='chkClmListingPerPolicy' style='margin-left: 5px;'>Claim Listing Per Policy</label></td></tr>"+
						  "<tr><td><input type='checkbox' id='chkRcvryListingPerPolicy' style='float: left;'><label for='chkRcvryListingPerPolicy' style='margin-left: 5px;'>Recovery Listing Per Policy</label></td></tr>";
			$("printDialogFormDiv2").update(content); 
			$("printDialogFormDiv2").show();
			$("printDialogMainDiv").up("div",1).style.height = "212px";
			$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "244px";
			
			$("chkClmListingPerPolicy").checked = true;
			if(!withRcvry){
				$("chkRcvryListingPerPolicy").disabled = true;
				$("chkRcvryListingPerPolicy").checked = false;
			}else{
				$("chkRcvryListingPerPolicy").disabled = false;
				$("chkRcvryListingPerPolicy").checked = true;
			}
		}
		
		var reportsToPrint = [];
		function onOkPrintGicls274(){
			if($("chkClmListingPerPolicy").checked){
				reportsToPrint.push({reportId : "GICLR274A", reportTitle : "CLAIM LISTING PER PACKAGE POLICY"});
			}
			if($("chkRcvryListingPerPolicy").checked){
				reportsToPrint.push({reportId : "GICLR274B", reportTitle : "RECOVERY LISTING PER PACKAGE POLICY"});
			}
			for(var i = 0; i < reportsToPrint.length; i++){
				printReportGicls274(reportsToPrint[i].reportId, reportsToPrint[i].reportTitle);
			}
			if ("screen" == $F("selDestination")) {
				showMultiPdfReport(reports);
				reports = [];
			}
			reportsToPrint = [];
		}
		
		var reports = [];
		function printReportGicls274(reportId, reportTitle){
			var content;
			content = contextPath+"/PrintClaimListingInquiryController?action=printReport&reportId="+reportId+getPrintParams()+getParams()
						+ "&noOfCopies=" + $F("txtNoOfCopies")
			            + "&printerName=" + $F("selPrinter")
			            + "&destination=" + $F("selDestination");
			
			if($F("selDestination") == "screen"){
				reports.push({reportUrl : content, reportTitle : reportTitle});			
			}else if($F("selDestination") == "printer"){
				new Ajax.Request(content, {
					method: "GET",
					parameters : {noOfCopies : $F("txtNoOfCopies"),
							 	 printerName : $F("selPrinter")
							 	 },
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						if (checkErrorOnResponse(response)){
						
						}
					}
				});
			}else if($F("selDestination") == "file"){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "file",
								  fileType    : $("rdoPdf").checked ? "PDF" : "XLS"},
					evalScripts: true,
					asynchronous: true,
					onCreate: showNotice("Generating report, please wait..."),
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							copyFileToLocal(response);
						}
					}
				});
			}else if("local" == $F("selDestination")){
				new Ajax.Request(content, {
					method: "POST",
					parameters : {destination : "local"},
					evalScripts: true,
					asynchronous: true,
					onComplete: function(response){
						hideNotice();
						if (checkErrorOnResponse(response)){
							var message = printToLocalPrinter(response.responseText);
							if(message != "SUCCESS"){
								showMessageBox(message, imgMessage.ERROR);
							}
						}
					}
				});
			}
		}
		
		function getPrintParams(){
			var params = "";
			params = params + "&lineCd=" + $F("txtLineCd") + "&sublineCd=" + $F("txtSublineCd") + "&polIssCd=" + $F("txtPolIssCd")
					 + "&issueYy=" + $F("txtIssueYy") + "&polSeqNo=" + $F("txtPolSeqNo") + "&renewNo=" + $F("txtRenewNo");
			return params;
		}
		
		//other observe
		$("rdoAsOf").observe("click", disableFromToFields);
		$("rdoFrom").observe("click", disableAsOfFields);
		$("rdoClaimFileDate").observe("click", changeSearchByOption);
		$("rdoLossDate").observe("click", changeSearchByOption);
		$("btnRecoveryDetails").observe("click", showRecoveryDetails);
		$("btnToolbarEnterQuery").observe("click", resetForm);
		
		$$("div#packagePerPolicyDiv input[type='text'].disableDelKey").each(function (a) {//added by steven 5/25/2013
			$(a).observe("keydown",function(e){
				if($(a).readOnly && e.keyCode === 46){
					$(a).blur();
				}
			});
		});
		
		$("btnExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		$("btnToolbarExit").observe("click", function(){
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		$("imgAsOf").observe("click", function() {
			if ($("imgAsOf").disabled == true)
				return;
			scwShow($('txtAsOf'), this, null);
		});
		
		$("imgFrom").observe("click", function() {
			if ($("imgFrom").disabled == true)
				return;
			scwShow($('txtFrom'), this, null);
		});
		
		$("imgTo").observe("click", function() {
			if ($("imgTo").disabled == true)
				return;
			scwShow($('txtTo'), this, null);
		});
		
		$("txtAsOf").observe("focus", function(){
			if ($("imgAsOf").disabled == true) return;
			var asOfDate = $F("txtAsOf") != "" ? new Date($F("txtAsOf").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (asOfDate > sysdate && asOfDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtAsOf");
				$("txtAsOf").clear();
				return false;
			}
		});
		
	 	$("txtFrom").observe("focus", function(){
			if ($("imgFrom").disabled == true) return;
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			if (fromDate > sysdate && fromDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtFrom");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
				$("txtFrom").clear();
				$("txtTo").clear();
				return false;
			}
		});
	 	
	 	$("txtTo").observe("focus", function(){
			if ($("imgTo").disabled == true) return;
			var toDate = $F("txtTo") != "" ? new Date($F("txtTo").replace(/-/g,"/")) :"";
			var fromDate = $F("txtFrom") != "" ? new Date($F("txtFrom").replace(/-/g,"/")) :"";
			var sysdate = new Date();
			if (toDate > sysdate && toDate != ""){
				customShowMessageBox("Date should not be greater than the current date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if (toDate < fromDate && toDate != ""){
				customShowMessageBox("TO Date should not be less than the FROM date.", "I", "txtTo");
				$("txtTo").clear();
				return false;
			}
			if(fromDate=="" && toDate!=""){
				customShowMessageBox("Please enter FROM date first.", "I", "txtTo");
				$("txtTo").clear();
				$("txtFrom").clear();
				return false;
			}
		});
		
	 	initializeAll();
		initGICLS274();
		
	} catch(e){
		showErrorMessage("Error : ", e.message);
	}
</script>


