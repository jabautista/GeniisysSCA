<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>
<style>
.required {
	backgroundColor: '#FFFACD'
}
</style>
<div id="mainNavClaimHist">
	<div id="clmHistMainDiv" name="clmHistMainDiv">
		<jsp:include page="/pages/toolbar.jsp"></jsp:include>
		<div id="outerDiv" name="outerDiv">
			<div id="innerDiv" name="innerDiv">
				<label>Claim History</label> <span class="refreshers"
					style="margin-top: 0;"> <label id="btnReloadForm" name="gro"
					style="margin-left: 5px;">Reload Form</label>
				</span>
			</div>
		</div>

		<div class="sectionDiv" id="claimHistoryDiv">
			<table align="center" style="margin: 10px auto;">
				<tr>
					<td style="padding-right: 5px;"><label for="txtLineCd"
						style="float: right;">Claim Number</label></td>
					<td>
						<div style="width: 47px; float: left; margin-top: 0;" class="withIconDiv required">
							<input type="text" id="txtLineCd" ignoreDelKey="true" style="width: 22px;" class="withIcon allCaps required" maxlength="2" tabindex="101" lastValidValue="">
							<img id="imgLineCd" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" />
						</div>
						<div style="width: 75px; float: left; margin-top: 0;" class="withIconDiv">
							<input type="text" id="txtSublineCd" ignoreDelKey="true" style="width: 50px;" class="withIcon allCaps" maxlength="7" tabindex="102" lastValidValue="">
							<img id="imgSublineCd" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" />
						</div>
						<div style="width: 47px; float: left; margin-top: 0;" class="withIconDiv">
							<input type="text" id="txtIssCd" ignoreDelKey="true" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="103" lastValidValue="">
							<img id="imgIssCd" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" />
						</div>
						<input type="text" id="txtClmYy" class="integerNoNegativeUnformattedNoComma" style="height: 14px; width: 40px; margin: 0px; text-align: right;" tabindex="104" />
						<input type="text" id="txtClmSeqNo" class="integerNoNegativeUnformattedNoComma" style="height: 14px; width: 122px; margin: 0px; text-align: right; margin-right: 7px;" tabindex="105"/>
						<input type="hidden" />
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgClaimNo" alt="Go" style="float: right;" />
					</td>
					<td style="padding-right: 5px;"><label for="txtLossCat" style="float: right; margin-left: 20px;" >Loss Category</label></td>
					<td><input type="text" id="txtLossCat" style="margin: 0; width: 200px;" tabindex="106"/></td>
				</tr>
				<tr>
					<td style="padding-right: 5px;"><label for="txtLineCd2"
						style="float: right;">Policy Number</label></td>
					<td>
						<div style="width: 47px; float: left; margin-top: 0;" class="withIconDiv">
							<input type="text" id="txtLineCd2" ignoreDelKey="true" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="107" readonly="readonly" lastValidValue="">
							<img id="imgLineCd2" style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" />
						</div>
						<div style="width: 75px; float: left; margin-top: 0;" class="withIconDiv">
							<input type="text" id="txtSublineCd2" ignoreDelKey="true" style="width: 50px;" class="withIcon allCaps" maxlength="7" tabindex="108" readonly="readonly" lastValidValue="">
							<img id="imgSublineCd2" style="float: right; display: none;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" />
						</div>
						<div style="width: 47px; float: left; margin-top: 0;" class="withIconDiv">
							<input type="text" id="txtPolIssCd" ignoreDelKey="true" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="109" lastValidValue="">
							<img id="imgPolIssCd" style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" alt="Go" />
						</div>
						<input type="text" id="txtIssueYy" class="integerNoNegativeUnformattedNoComma" style="height: 14px; width: 40px; margin: 0px; text-align: right;" tabindex="110"/>
						<input type="text" id="txtPolSeqNo" class="integerNoNegativeUnformattedNoComma" style="height: 14px; width: 70px; margin: 0px; text-align: right;" tabindex="111" />
						<input type="text" id="txtRenewNo" class="integerNoNegativeUnformattedNoComma" style="height: 14px; width: 40px; margin: 0px; text-align: right; margin-right: 7px;" tabindex="112"/>
					</td>
					<td style="padding-right: 5px;"><label for="txtLossDate" style="float: right;">Loss Date</label></td>
					<td><input type="text" id="txtLossDate" style="margin: 0; width: 200px;" tabindex="113"/></td>
				</tr>
				<tr>
					<td style="padding-right: 5px;"><label for="txtAssuredName" style="float: right;">Assured</label></td>
					<td><input type="text" id="txtAssuredName" class="allCaps" style="height: 14px; width: 361px; margin: 0px;" tabindex="114"/></td>
					<td colspan="2"><label id="lblClmStatDesc" style="font-weight: bold; float: right;"></label></td>
				</tr>
			</table>
		</div>


		<%-- <div id="clmHistDiv" align="center" class="sectionDiv" style="display: none;">
		<div style="margin: 5px; margin-left: 10px; float: left;">
			<table border="0" align="center">
				<tr>
					<td class="rightAligned" style="width: 75px;">Claim No.</td>
					<td class="rightAligned">
						<div id="clmLineCdDiv" style="width: 47px; float: left;" class="withIconDiv required">
							<input type="text" id="txtNbtClmLineCd" name="txtNbtClmLineCd" value="" style="width: 22px;" class="withIcon allCaps required" maxlength="2" tabindex="101">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmLineCdIcon" name="txtNbtClmLineCdIcon" alt="Go" />
						</div>
						<div id="clmsSblineCdDiv" style="width: 89px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtClmSublineCd" name="txtNbtClmSublineCd" value="" style="width: 64px;" class="withIcon allCaps" maxlength="7" tabindex="102">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmSublineCdIcon" name="txtNbtClmSublineCdIcon" alt="Go" />
						</div>

						<div style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtClmIssCd" name="txtNbtClmIssCd" value="" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="103">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtClmIssCdIcon" name="txtNbtClmIssCdIcon" alt="Go" />
						</div>
						<input type="text" id="txtNbtClmYy" name="txtNbtClmYy" value="" style="width: 20px; float: left;" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="104">
						<input type="text" id="txtNbtClmSeqNo" name="txtNbtClmSeqNo" value="" style="width: 115px; float: left;  margin-left: 4px;" class="integerNoNegativeUnformattedNoComma" maxlength="7" tabindex="105">
						<div class="withIconDiv" style="border: 0px; float: right;">
							<img style="margin-left: 3px; float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="nbtSearchClmByClmIcon" name="nbtSearchClmByClmIcon" alt="Go" />
						</div>
					</td>
				</tr>			
				<tr>
					<td class="rightAligned" style="width: 75px;">Policy No.</td>
					<td class="rightAligned">
						<div id="lineCdDiv" style="width: 47px; float: left;" class="withIconDiv required">
							<input type="text" id="txtNbtLineCd" name="txtNbtLineCd" value="" style="width: 22px;" class="withIcon allCaps required" maxlength="2" tabindex="201">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtLineCdIcon" name="txtNbtLineCdIcon" alt="Go" />
						</div>
						<div id="sublineCdDiv" style="width: 89px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtSublineCd" name="txtNbtSublineCd" value="" style="width: 64px;" class="withIcon allCaps" maxlength="7" tabindex="202">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtSublineCdIcon" name="txtNbtSublineCdIcon" alt="Go" />
						</div>

						<div style="width: 47px; float: left;" class="withIconDiv">
							<input type="text" id="txtNbtPolIssCd" name="txtNbtPolIssCd" value="" style="width: 22px;" class="withIcon allCaps" maxlength="2" tabindex="203">
							<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="txtNbtPolIssCdIcon" name="txtNbtPolIssCdIcon" alt="Go" />
						</div>
						<input type="text" id="txtNbtIssueYy" name="txtNbtIssueYy" value="" style="width: 20px; float: left;" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="204">
						<input type="text" id="txtNbtPolSeqNo" name="txtNbtPolSeqNo" value="" style="width: 71px; float: left;  margin-left: 4px;" class="integerNoNegativeUnformattedNoComma" maxlength="7" tabindex="205">
						<input type="text" id="txtNbtRenewNo" name="txtNbtRenewNo" value="" style="width: 33px; float: left; margin-left: 4px;" class="integerNoNegativeUnformattedNoComma" maxlength="2" tabindex="206">
						<div class="withIconDiv" style="border: 0px; float: right;">
							<img style="margin-left: 3px; float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="nbtSearchClmByPolIcon" name="nbtSearchClmByPolIcon" alt="Go" />
						</div>
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="rightAligned">
						<input style="float: left; width: 370px;" type="text" id="txtNbtAssuredName" name="txtNbtAssuredName" readonly="readonly" tabindex="307">
					</td>
				</tr>
			</table>
		</div>
		<div style="float: right; width: 350px; margin-right:30px">
			<table border="0" align="center" style="margin: 8px;">
				<tr>
					<td class="rightAligned" style="width: 120px;">Loss Category</td>
					<td class="leftAligned" style="width: 230px;">
						<input id="txtLossCategory" style="width: 230px;" type="text" value="" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 120px;">Loss Date</td>
					<td class="leftAligned" style="width: 230px;">
						<input id="txtLossDate" style="width: 230px;" type="text" value="" readonly="readonly" />
					</td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 120px;">Claim Status</td>
					<td class="leftAligned" style="width: 230px;">
						<input id="txtClmStatus" style="width: 230px;" type="text" value="" readonly="readonly" />
					</td>
				</tr>				
			</table>
		</div>
	</div> --%>

		<div id="outerDiv" name="outerDiv"
			style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>Item Information</label>
				<!-- <span class="refreshers" style="margin-top: 0;">
					<label id="gro" name="gro" style="margin-left: 5px;">Hide</label>
				</span> -->
			</div>
		</div>
		<div class="sectionDiv" id="clmHistItemListDiv">
			<div id="claimItemResTableGridDiv" style="padding: 10px 0 0 10px;">
				<div id="claimItemResListing"
					style="height: 232px; margin-left: auto;"></div>
			</div>
		</div>

		<div id="outerDiv" name="outerDiv"
			style="width: 100%; margin-bottom: 1px;">
			<div id="innerDiv" name="innerDiv">
				<label>History Details</label> <span class="refreshers"
					style="margin-top: 0;"> <label id="gro" name="gro"
					style="margin-left: 5px;"></label>
				</span>
			</div>
		</div>
		<div class="sectionDiv" id="clmHistDetailListDiv"
			style="margin-bottom: 50px;">
			<div id="claimItemHistTableGridDiv" style="padding: 10px 0 0 10px;">
				<div id="claimItemHistListing"
					style="height: 232px; margin-left: auto;"></div>
			</div>
		</div>
	</div>
</div>
<script type="text/javascript">
	try {
		objGICLS254 = new Object();

		function initializeGICLS254() {
			$("txtLineCd").focus();
			objCLMGlobal.moduleId = 'GICLS254';
			setModuleId(objCLMGlobal.moduleId);
			setDocumentTitle("Claim History");
			hideToolbarButton("btnToolbarPrint");
			objCLMGlobal.claimId = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			//initializeAccordion();
			initializeAll();
			//showClaimItemInfoGICLS254();
			
			$("txtLossCat").readOnly = true;
			$("txtLossDate").readOnly = true;
			$("txtAssuredName").readOnly = true;
		}

		function showClaimItemInfoGICLS254() {
			try {
				new Ajax.Updater("clmHistItemListGrid", contextPath
						+ "/GICLClaimsController", {
					parameters : {
						action : "getClaimItemResDtls",
						claimId : objCLMGlobal.claimId
					},
					asynchronous : false,
					evalScripts : true,
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							null;
						}
					}
				});
			} catch (e) {
				showErrorMessage("showClaimItemInfoGICLS254", e);
			}
		}

		function clearHistDtlDiv() {
			$("clmHistDetailListGrid").innerHTML = "";
			//returnMainInfoDivAttribute();
		}

		function resetForm() {
			
			objCLMGlobal.claimId = "";
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			
			itemResTableGrid.url = contextPath + "/GICLClaimsController?action=getClaimItemResDtls&refresh=1";
			itemResTableGrid._refreshList();
		
			$$("div#claimHistoryDiv input[type='text']").each(function(obj) {
				if(obj.id != "txtLossCat" && obj.id != "txtLossDate" && obj.id != "txtAssuredName" && obj.id != "txtLineCd2" && obj.id != "txtSublineCd2")
					obj.readOnly = false;
				
				obj.clear();
				
				if(obj.id == "txtLineCd" || obj.id == "txtLineCd2" || obj.id == "txtSublineCd" || obj.id == "txtSublineCd2" || obj.id == "txtIssCd" || obj.id == "txtPolIssCd")
					obj.setAttribute("lastValidValue", "");
			});
			
			enableSearch("imgLineCd");
			enableSearch("imgSublineCd");
			enableSearch("imgIssCd");
			//enableSearch("imgLineCd2");
			//enableSearch("imgSublineCd2");
			enableSearch("imgPolIssCd");
			enableSearch("imgClaimNo");
			objGICLS254 = new Object();
			
			$("txtLineCd").focus();
		}

		//Observe Enter QueryBUTTON
		$("btnToolbarEnterQuery").observe("click", resetForm);

		/* $("btnToolbarExecuteQuery").observe("click", function(){
			disableToolbarButton("btnToolbarExecuteQuery");
			showClaimItemInfoGICLS254();
		});	 */

		$("btnToolbarExit").observe(
				"click",
				function() {
					goToModule("/GIISUserController?action=goToClaims",
							"Claims Main", "");
				});
		
		$("btnReloadForm").observe("click", function(){
			$("btnToolbarEnterQuery").click();
		});

		/* $("btnReloadForm").observe("click", function() {
			try {
				new Ajax.Updater("dynamicDiv", contextPath
						+ "/GICLClaimsController", {
					parameters : {
						action : "showClmHistory",
						module : "GICLS254"
					},
					asynchronous : false,
					evalScripts : true,
					//onCreate: showNotice("Loading, please wait..."),
					onComplete : function(response) {
						if (checkErrorOnResponse(response)) {
							null;
						}
					}
				});
			} catch (e) {
				showErrorMessage("showClmHistory", e);
			}
		}); */

		function getGICLS254LineLOV(id) {
			var filterText = ($F("txtLineCd") == $("txtLineCd").readAttribute("lastValidValue") ? "" : $F("txtLineCd"));
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS254LineLOV",
					lineCd : filterText,
					page : 1
				},
				title : "Valid Values for Line Code",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "lineCd",
					title : "Line Code",
					width : '120px',
				}, {
					id : "lineName",
					title : "Line Name",
					width : '345px',
					renderer : function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : filterText,

				onSelect : function(row) {
					$("txtLineCd").value = row.lineCd;
					$("txtLineCd2").value = row.lineCd;
					
					if($F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue")){
						disableToolbarButton("btnToolbarExecuteQuery");
						$("txtLossCat").clear();
						$("txtLossDate").clear();
						$("txtAssuredName").clear();
						$("txtSublineCd").clear();
						$("txtSublineCd2").clear();
						$("txtIssCd").clear();
						$("txtPolIssCd").clear();
						$("txtClmYy").clear();
						$("txtIssueYy").clear();
						$("txtClmSeqNo").clear();
						$("txtPolSeqNo").clear();
						$("txtRenewNo").clear();
						
						$("txtSublineCd").setAttribute("lastValidValue", "");
						$("txtSublineCd2").setAttribute("lastValidValue", "");
						$("txtIssCd").setAttribute("lastValidValue", "");
						$("txtPolIssCd").setAttribute("lastValidValue", "");
					}
					
					$("txtLineCd2").setAttribute("lastValidValue", $F("txtLineCd2"));
					$("txtLineCd").setAttribute("lastValidValue", $F("txtLineCd"));
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel : function() {
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineCd2").value = $("txtLineCd2").readAttribute("lastValidValue");
					$("txtLineCd").focus();
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, id);
					$("txtLineCd").value = $("txtLineCd").readAttribute("lastValidValue");
					$("txtLineCd2").value = $("txtLineCd2").readAttribute("lastValidValue");
					$("txtLineCd").focus();
				}
			});
		}

		$("imgLineCd").observe("click", function() {
			getGICLS254LineLOV("txtLineCd");
		});
		
		$("txtLineCd").observe("change", function() {
			if(this.value.trim() == ""){
				this.clear();
				$("txtLineCd").setAttribute("lastValidValue", "");
				$("txtLineCd2").setAttribute("lastValidValue", "");
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineCd2").setAttribute("lastValidValue", "");
				$("txtIssCd").setAttribute("lastValidValue", "");
				$("txtPolIssCd").setAttribute("lastValidValue", "");
				$("txtLossCat").clear();
				$("txtLossDate").clear();
				$("txtAssuredName").clear();
				$("txtLineCd2").clear();
				$("txtSublineCd").clear();
				$("txtSublineCd2").clear();
				$("txtIssCd").clear();
				$("txtPolIssCd").clear();
				$("txtClmYy").clear();
				$("txtIssueYy").clear();
				$("txtClmSeqNo").clear();
				$("txtPolSeqNo").clear();
				$("txtRenewNo").clear();
				return;
			}
			
			if($F("txtLineCd") != $("txtLineCd").readAttribute("lastValidValue"))
				getGICLS254LineLOV("txtLineCd");
		});

		/* $("imgLineCd2").observe("click", function() {
			getGICLS254LineLOV("txtLineCd2");
		});
		
		$("txtLineCd2").observe("change", function() {
			if(this.value.trim() == ""){
				this.clear();
				return;
			}
			
			if(objGICLS254.lineCd != this.value)
				getGICLS254LineLOV("txtLineCd2");
		}); */

		function getGICLS254SublineLOV(id) {
			var filterText = ($F("txtSublineCd") == $("txtSublineCd").readAttribute("lastValidValue") ? "" : $F("txtSublineCd"));
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS254SublineLOV",
					lineCd : $F("txtLineCd"),
					sublineCd : filterText,
					page : 1
				},
				title : "Valid Values for Subline Code",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "sublineCd",
					title : "Subline Code",
					width : '120px',
				}, {
					id : "sublineName",
					title : "Subline Name",
					width : '345px',
					renderer : function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : filterText,

				onSelect : function(row) {
					$("txtSublineCd").value = row.sublineCd;
					$("txtSublineCd2").value = row.sublineCd;
					
					if($F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue")){
						disableToolbarButton("btnToolbarExecuteQuery");
						$("txtLossCat").clear();
						$("txtLossDate").clear();
						$("txtAssuredName").clear();
						$("txtIssCd").clear();
						$("txtPolIssCd").clear();
						$("txtClmYy").clear();
						$("txtIssueYy").clear();
						$("txtClmSeqNo").clear();
						$("txtPolSeqNo").clear();
						$("txtRenewNo").clear();
						
						$("txtIssCd").setAttribute("lastValidValue", "");
						$("txtPolIssCd").setAttribute("lastValidValue", "");
					}
					
					$("txtSublineCd").setAttribute("lastValidValue", $F("txtSublineCd"));
					$("txtSublineCd2").setAttribute("lastValidValue", $F("txtSublineCd2"));
					enableToolbarButton("btnToolbarEnterQuery");

				},
				onCancel : function() {
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineCd2").value = $("txtSublineCd2").readAttribute("lastValidValue");
					$("txtSublineCd").focus();
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, id);
					$("txtSublineCd").value = $("txtSublineCd").readAttribute("lastValidValue");
					$("txtSublineCd2").value = $("txtSublineCd2").readAttribute("lastValidValue");
					$("txtSublineCd").focus();
				}
			});
		}

		$("imgSublineCd").observe("click", function() {
			getGICLS254SublineLOV("txtSublineCd");
		});
		
		$("txtSublineCd").observe("change", function() {
			if(this.value.trim() == ""){
				this.clear();
				$("txtSublineCd").setAttribute("lastValidValue", "");
				$("txtSublineCd2").setAttribute("lastValidValue", "");
				
				$("txtSublineCd2").clear();
				$("txtLossCat").clear();
				$("txtLossDate").clear();
				$("txtAssuredName").clear();
				$("txtIssCd").clear();
				$("txtPolIssCd").clear();
				$("txtClmYy").clear();
				$("txtIssueYy").clear();
				$("txtClmSeqNo").clear();
				$("txtPolSeqNo").clear();
				$("txtRenewNo").clear();
				
				$("txtIssCd").setAttribute("lastValidValue", "");
				$("txtPolIssCd").setAttribute("lastValidValue", "");
				return;
			}
			
			if($F("txtSublineCd") != $("txtSublineCd").readAttribute("lastValidValue"))
				getGICLS254SublineLOV("txtSublineCd");
		});

		/* $("imgSublineCd2").observe("click", function() {
			getGICLS254SublineLOV("txtSublineCd2");
		});
		
		$("txtSublineCd2").observe("change", function() {
			if(this.value.trim() == ""){
				this.clear();
				return;
			}
			
			if(objGICLS254.sublineCd != this.value)
				getGICLS254SublineLOV("txtSublineCd2");
		}); */

		function getGICLS254IssLOV(id) {
			var filterText = ($F(id) == $(id).readAttribute("lastValidValue") ? "" : $F(id));
			LOV.show({
				controller : "ClaimsLOVController",
				urlParameters : {
					action : "getGICLS254IssLOV",
					lineCd : $F("txtLineCd"),
					issCd : filterText,
					page : 1
				},
				title : "Valid Values for Issuing Source",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "issCd",
					title : "Issuing Source Code",
					width : '140px',
				}, {
					id : "issName",
					title : "Issuing Source Name",
					width : '325px',
					renderer : function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord : true,
				filterText : filterText,

				onSelect : function(row) {
					$(id).value = row.issCd;

					/* if (id == "txtIssCd") {
						if(objGICLS254.issCd != row.issCd){
							disableToolbarButton("btnToolbarExecuteQuery");
							$("txtLossCat").clear();
							$("txtLossDate").clear();
							$("txtAssuredName").clear();
						}
						
						objGICLS254.issCd = row.issCd;
						$("txtClmYy").focus();
					} else {
						if(objGICLS254.polIssCd != row.issCd){
							disableToolbarButton("btnToolbarExecuteQuery");
							$("txtLossCat").clear();
							$("txtLossDate").clear();
							$("txtAssuredName").clear();
						}
						
						objGICLS254.polIssCd = row.issCd;
						$("txtIssueYy").focus();
					} */
					
					//////
					
					if($F(id) != $(id).readAttribute("lastValidValue")){
						disableToolbarButton("btnToolbarExecuteQuery");
						$("txtLossCat").clear();
						$("txtLossDate").clear();
						$("txtAssuredName").clear();
						$("txtClmYy").clear();
						$("txtIssueYy").clear();
						$("txtClmSeqNo").clear();
						$("txtPolSeqNo").clear();
						$("txtRenewNo").clear();
					}
					
					$(id).setAttribute("lastValidValue", $F(id));
					enableToolbarButton("btnToolbarEnterQuery");
					
					id == "txtIssCd" ? $("txtClmYy").focus() : $("txtIssueYy").focus();

				},
				onCancel : function() {
					$(id).value = $(id).readAttribute("lastValidValue");
					$(id).focus();
				},
				onUndefinedRow : function() {
					customShowMessageBox("No record selected.", imgMessage.INFO, id);
					$(id).value = $(id).readAttribute("lastValidValue");
					$(id).focus();
				}
			});
		}

		$("imgIssCd").observe("click", function() {
			getGICLS254IssLOV("txtIssCd");
		});
		
		$("txtIssCd").observe("change", function() {
			if(this.value.trim() == ""){
				this.clear();
				$("txtLossCat").clear();
				$("txtLossDate").clear();
				$("txtAssuredName").clear();
				$("txtClmYy").clear();
				$("txtIssueYy").clear();
				$("txtClmSeqNo").clear();
				$("txtPolSeqNo").clear();
				$("txtRenewNo").clear();
				return;
			}
			
			if($("txtIssCd").readAttribute("lastValidValue") != this.value)
				getGICLS254IssLOV("txtIssCd");
		});

		$("imgPolIssCd").observe("click", function() {
			getGICLS254IssLOV("txtPolIssCd");
		});
		
		$("txtPolIssCd").observe("change", function() {
			if(this.value.trim() == ""){
				this.clear();
				$("txtLossCat").clear();
				$("txtLossDate").clear();
				$("txtAssuredName").clear();
				$("txtClmYy").clear();
				$("txtIssueYy").clear();
				$("txtClmSeqNo").clear();
				$("txtPolSeqNo").clear();
				$("txtRenewNo").clear();
				return;
			}
			
			if($("txtPolIssCd").readAttribute("lastValidValue") != this.value)
				getGICLS254IssLOV("txtPolIssCd");
		});

		function showGICLS254ClaimLOV() {
			try {
				LOV
					.show({
						controller : "ClaimsLOVController",
						urlParameters : {
							action : "getClaimListLOV",
							moduleId : "GICLS254",
							clmLineCode : $F("txtLineCd"),
							clmSublineCode : $F("txtSublineCd"),
							lineCode : $F("txtLineCd2"),
							sublineCode : $F("txtSublineCd2"),
							issCode : $F("txtIssCd"),
							polIssCode : $F("txtPolIssCd"),
							clmYr : $F("txtClmYy"),
							issueYr : $F("txtIssueYy"),
							clmSeqNum : $F("txtClmSeqNo"),
							polSeqNum : $F("txtPolSeqNo"),
							renewNum : $F("txtRenewNo")
						},
						title : "Claim Listing",
						width : 750,
						height : 390,
						autoSelectOneRecord : true,
						hideColumnChildTitle : true,
						filterVersion : "2",
						columnModel : [ {
							id : 'recordStatus',
							title : '',
							width : '0',
							visible : false,
							editor : 'checkbox'
						}, {
							id : 'divCtrId',
							width : '0',
							visible : false
						}, {
							id : 'claimNo',
							title : 'Claim No.',
							titleAlign : 'center',
							width : 200,
							sortable : true,
							children : [ {
								id : 'clmLineCd',
								title : 'Claim Line Code',
								width : 30
							}, {
								id : 'clmSublineCd',
								title : 'Claim Subline Code',
								width : 50,
								filterOption : true
							}, {
								id : 'issCd',
								title : 'Claim Issue Code',
								width : 30,
								filterOption : true
							}, {
								id : 'clmYy',
								title : 'Claim Year',
								type : 'number',
								align : 'right',
								width : 30,
								filterOption : true,
								filterOptionType : 'number',
								renderer : function(value) {
									return formatNumberDigits(value, 2);
								}
							}, {
								id : 'clmSeqNo',
								title : 'Claim Sequence No.',
								type : 'number',
								align : 'right',
								width : 60,
								filterOption : true,
								filterOptionType : 'number',
								renderer : function(value) {
									return formatNumberDigits(value, 7);
								}
							} ]
						}, {
							id : 'policyNo',
							title : 'Policy No.',
							titleAlign : 'center',
							width : 220,
							sortable : true,
							children : [ {
								id : 'lineCd',
								title : 'Line Code',
								width : 30
							}, {
								id : 'sublineCd',
								title : 'Subline Code',
								width : 50,
								filterOption : true
							}, {
								id : 'polIssCd',
								title : 'Policy Issue Code',
								width : 30,
								filterOption : true
							}, {
								id : 'issueYy',
								title : 'Issue Year',
								type : 'number',
								align : 'right',
								width : 30,
								filterOption : true,
								filterOptionType : 'number',
								renderer : function(value) {
									return formatNumberDigits(value, 2);
								}
							}, {
								id : 'polSeqNo',
								title : 'Policy Sequence No.',
								type : 'number',
								align : 'right',
								width : 50,
								filterOption : true,
								filterOptionType : 'number',
								renderer : function(value) {
									return formatNumberDigits(value, 7);
								}
							}, {
								id : 'renewNo',
								title : 'Renew No.',
								type : 'number',
								align : 'right',
								width : 30,
								filterOption : true,
								filterOptionType : 'number',
								renderer : function(value) {
									return formatNumberDigits(value, 2);
								}
							} ]
						}, {
							id : 'assuredName',
							title : 'Assured Name',
							titleAlign : 'left',
							width : 300,
							filterOption : true
						} ],
						draggable : true,
						onSelect : function(row) {
							$("txtLineCd").value = row.clmLineCd;
							$("txtSublineCd").value = row.clmSublineCd;
							$("txtIssCd").value = row.issCd;
							$("txtClmYy").value = lpad(nvl(row.clmYy, ""),
									2, 0);
							$("txtClmSeqNo").value = lpad(nvl(row.clmSeqNo,
									""), 7, 0);
							$("txtLineCd2").value = row.lineCd;
							$("txtSublineCd2").value = row.sublineCd;
							$("txtPolIssCd").value = row.polIssCd;
							$("txtIssueYy").value = lpad(nvl(row.issueYy,
									""), 2, 0);
							$("txtPolSeqNo").value = lpad(nvl(row.polSeqNo,
									""), 7, 0);
							$("txtRenewNo").value = lpad(nvl(row.renewNo,
									""), 2, 0);
							$("txtAssuredName").value = unescapeHTML2(row.assuredName);
							$("txtLossCat").value = unescapeHTML2(row.lossCategory);
							$("txtLossDate").value = dateFormat(
									row.lossDate, "mm-dd-yyyy");
							$("lblClmStatDesc").innerHTML = row.claimStatus;
							objCLMGlobal.claimId = row.claimId;
							objCLMGlobal.lineCd = row.lineCd;
							
							objGICLS254.lineCd = row.lineCd;
							objGICLS254.lineCd2 = row.lineCd;
							objGICLS254.sublineCd = row.clmSublineCd;
							objGICLS254.sublineCd2 = row.sublineCd;
							objGICLS254.issCd = row.issCd;
							objGICLS254.polIssCd = row.polIssCd;
							
							$("txtLineCd").setAttribute("lastValidValue", row.lineCd);
							$("txtLineCd2").setAttribute("lastValidValue", row.lineCd);
							$("txtSublineCd").setAttribute("lastValidValue", row.clmSublineCd);
							$("txtSublineCd2").setAttribute("lastValidValue", row.sublineCd);
							$("txtIssCd").setAttribute("lastValidValue", row.issCd);
							$("txtPolIssCd").setAttribute("lastValidValue", row.polIssCd);
							
							enableToolbarButton("btnToolbarExecuteQuery");
							enableToolbarButton("btnToolbarEnterQuery"); //added by robert 01.03.2014
						},
						onCancel : function() {
						},
						onUndefinedRow : function() {
							customShowMessageBox("No record selected", "I",
									"txtLineCd");
						}
					});

		} catch (e) {
			showErrorMessage("showGICLS254ClaimLOV", e);
		}

	}

		function populateItemHist(row) {
			if (row != null) {
				itemHistTableGrid.url = contextPath
						+ "/GICLClaimsController?action=getClmItemHistDtls&refresh=1&claimId="
						+ objCLMGlobal.claimId + "&itemNo=" + row.itemNo
						+ "&perilCd=" + row.perilCd + "&groupedItemNo="
						+ row.groupedItemNo;
			} else {
				itemHistTableGrid.url = contextPath
						+ "/GICLClaimsController?action=getClmItemHistDtls&refresh=1";
			}
			itemHistTableGrid._refreshList();
		}

		var itemHistTableModel = {
			url : contextPath
					+ "/GICLClaimsController?action=getClmItemHistDtls&refresh=1",
			id : "itemHistTableGrid",
			options : {
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN,
							MyTableGrid.REFRESH_BTN ]
				},
				title : '',
				width : '900px',
				height : '200px',
				hideColumnChildTitle : true
			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'histSeqNo',
				title : 'History No.',
				width : 80,
				filterOption: true,
				filterOptionType : "integerNoNegative",
				align: "right",
				titleAlign: "right"
			}, {
				id : 'itemStatCd',
				title : 'Status',
				width : 50,
				filterOption: true
			}, {
				id : 'distSw',
				title : 'D',
				altTitle: 'Dist. Sw',
				width : 30,
				filterOption : true,
				filterOptionType : 'checkbox',
			}, {
				id : 'paidAmt',
				title : 'Paid Amount',
				align:  'right',
				titleAlign : 'right',
				width : 100,
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			}, {
				id : 'netAmt',
				title : 'Net Amount',
				align:  'right',
				titleAlign : 'right',
				width : 100,
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			}, {
				id : 'adviseAmt',
				title : 'Advise Amount',
				align:  'right',
				titleAlign : 'right',
				width : 100,
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			}, {
				id : 'payeeType',
				title : 'P',
				altTitle: 'Payee Type',
				width :30,
				filterOption : true
				
			}, {
				id : 'payeeClassCd',
				title : 'Class Cd',
				width : 100,
				filterOption: true,
				filterOptionType: "integerNoNegative",
				align: "right",
				titleAlign: "right"
			}, {
				id : 'payeeCd',
				title : 'Payee Code',
				width : 100,
				filterOption: true,
				filterOptionType: "integerNoNegative",
				align: "right",
				titleAlign: "right",
				renderer: function(val) {
					return formatNumberDigits(val, 6);
				}
			}, {
				id : 'payeeName',
				title : 'Payee Name',
				width : 300,
				filterOption : true
			} ],
			rows : []
		};

		itemHistTableGrid = new MyTableGrid(itemHistTableModel);
		itemHistTableGrid.pager = [];
		itemHistTableGrid.render('claimItemHistListing');

		var itemResTableModel = {
			url : contextPath
					+ "/GICLClaimsController?action=getClaimItemResDtls&refresh=1",
			id : "itemsTableGrid",
			options : {
				toolbar : {
					elements : [ MyTableGrid.FILTER_BTN,
							MyTableGrid.REFRESH_BTN ]
				},
				width : '900px',
				height : '200px',
				hideColumnChildTitle : true,
				onCellFocus : function(element, value, x, y, id) {
					itemResTableGrid.keys.removeFocus(
							itemResTableGrid.keys._nCurrentFocus, true);
					itemResTableGrid.keys.releaseKeys();
					populateItemHist(itemResTableGrid.geniisysRows[y]);
				},
				onRemoveRowFocus : function(element, value, x, y, id) {
					itemResTableGrid.keys.removeFocus(
							itemResTableGrid.keys._nCurrentFocus, true);
					itemResTableGrid.keys.releaseKeys();
					populateItemHist(null);
				}

			},
			columnModel : [ {
				id : 'recordStatus',
				title : '',
				width : '0',
				visible : false,
				editor : 'checkbox'
			}, {
				id : 'divCtrId',
				width : '0',
				visible : false
			}, {
				id : 'itemNo itemTitle',
				title : 'Item',
				children : [ {
					id : 'itemNo',
					title: 'Item No.',
					width : 50,
					align : 'right',
					filterOption: true,
					filterOptionType: "integerNoNegative"
					
				}, {
					id : 'itemTitle',
					title: "Item Title",
					width : 180,
					filterOption: true
				} ]
			}, {
				id : 'perilCd perilName',
				title : 'Peril',
				children : [ {
					id : 'perilCd',
					title: "Peril Code",
					width : 50,
					align : 'right',
					filterOption: true,
					filterOptionType: "integerNoNegative"
				}, {
					id : 'perilName',
					title: "Peril Name",
					width : 200,
					filterOption: true,
				} ]
			}, {
				id : 'lossReserve',
				title : 'Loss Reserve',
				titleAlign : 'center',
				type : 'number',
				width : 190,
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			}, {
				id : 'expenseReserve',
				title : 'Expense Reserve',
				titleAlign : 'center',
				type : 'number',
				width : 190,
				geniisysClass : 'money',
				filterOption : true,
				filterOptionType : 'number'
			} ],
			rows : []
		};

		itemResTableGrid = new MyTableGrid(itemResTableModel);
		itemResTableGrid.pager = [];
		itemResTableGrid.render('claimItemResListing');
		itemResTableGrid.afterRender = function() {
			populateItemHist(null);
		};

		$("imgClaimNo").observe("click", function() {
			if ($F("txtLineCd").trim() == "") {
				customShowMessageBox("Please enter Line Code first.", "I", "txtLineCd");
				$("txtLineCd").clear();
				return;
			}
			showGICLS254ClaimLOV();
		});

		function executeQuery() {
			itemResTableGrid.url = contextPath
					+ "/GICLClaimsController?action=getClaimItemResDtls&refresh=1&claimId="
					+ objCLMGlobal.claimId;
			itemResTableGrid._refreshList();

			$$("div#claimHistoryDiv input[type='text']").each(function(obj) {
				obj.readOnly = true;
			});
			
			disableSearch("imgLineCd");
			disableSearch("imgSublineCd");
			disableSearch("imgIssCd");
			//disableSearch("imgLineCd2");
			//disableSearch("imgSublineCd2");
			disableSearch("imgPolIssCd");
			disableSearch("imgClaimNo");
			
			disableToolbarButton("btnToolbarExecuteQuery");
		}

		$("btnToolbarExecuteQuery").observe("click", executeQuery);
		
		$$("div#claimHistoryDiv input[type='text']").each(function(obj) {
			obj.observe("keypress", function(event){
				if(this.readOnly)
					return;
				
				if(event.keyCode == 0 || event.keyCode == 8 || event.keyCode == 46){
					enableToolbarButton("btnToolbarEnterQuery");
					disableToolbarButton("btnToolbarExecuteQuery");
				}
			});
		});

		initializeGICLS254();

	} catch (e) {
		showErrorMessage("Claim History page.", e);
	}
</script>