<div id="GIACS155MainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include> 
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
			<label>Commission Voucher</label>
			<span class="refreshers" style="margin-top: 0;">
				<label id="reloadForm" name="reloadForm">Reload Form</label>
			</span>
		</div>
	</div>
	<div class="sectionDiv" style="padding: 10px 0;">
		<table align="center">
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Intermediary</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 105px; margin: 0;">
						<input type="text" id="txtIntmNo" class="allCaps required" tabindex="101" ignoreDelKey="true" style="text-align: right; width: 80px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntm" alt="Go" style="float: right;"/>
					</span>
					<input id="txtIntmName" type="text" style="width: 350px; height: 14px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
				</td>
				<%-- <td><label for="txtIntmNo">Intermediary</label></td>
				<td>
					<span class="lovSpan required" style="width: 370px; margin-bottom: 0;">
						<input type="text" id="txtIntmNo" style="width: 340px; float: left;" class="withIcon allCaps required" tabindex="101"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgIntm" alt="Go" style="float: right;" />
					</span>
				</td> --%>
			</tr>
		</table>
	</div>
	<div class="sectionDiv" style="padding: 10px 0; margin-top: 1px; margin-bottom: 2px;">
		<table align="center">
			<tr>
				<td class="rightAligned" style="padding-right: 5px;">Fund</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 105px; margin: 0;">
						<input type="text" id="txtFundCd" class="allCaps required" tabindex="101" ignoreDelKey="true" style="width: 80px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFund" alt="Go" style="float: right;"/>
					</span>
					<input id="txtFundDesc" type="text" style="width: 230px; height: 14px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
				</td>
				
				<td class="rightAligned" style="padding-right: 5px; padding-left: 30px;">Branch</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 105px; margin: 0;">
						<input type="text" id="txtBranchCd" class="allCaps required" tabindex="101" ignoreDelKey="true" style="width: 80px; float: left; border: none; height: 14px; margin: 0;" lastValidValue=""/> 
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranch" alt="Go" style="float: right;"/>
					</span>
					<input id="txtBranchName" type="text" style="width: 230px; height: 14px; margin: 0; margin-left: 4px;" readonly="readonly" lastValidValue="">
				</td>
			</tr>
		</table>
		<%-- <div style="float: left; margin-left: 50px;">
			<label for="txtFundCd" style="float: left; margin: 4px 4px 0 0;">Fund</label>
			<span class="lovSpan required" style="width: 350px; margin-bottom: 0;">
				<input type="text" id="txtFundCd" style="width: 320px; float: left;" class="withIcon allCaps required"  tabindex="101"/>  
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgFund" alt="Go" style="float: right;" />
			</span>
		</div>
		<div style="float: right; margin-right: 50px;">
			<label for="txtBranchCd" style="float: left; margin: 4px 4px 0 0;">Branch</label>
			<span class="lovSpan required" style="width: 350px; margin-bottom: 0;">
				<input type="text" id="txtBranchCd" style="width: 320px; float: left;" class="withIcon allCaps required" tabindex="101"/>  
				<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranch" alt="Go" style="float: right;" />
			</span>
		</div> --%>
	</div>
	<div class="sectionDiv">
		<div style="margin: 0px; padding: 10px 10px 5px 10px;">
			<div id="commVoucherTable" style="height: 253px;"></div>
		</div>
		<div style="float: right; margin-right: 15px; width: 100%;">
			<table align="right">
				<tr>
					<td class="rightAligned"><label style="float: none; margin: 0 5px;">Tagged Totals</label></td>
					<td><input type="text" id="txtTaggedActualComm" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
					<td><input type="text" id="txtTaggedCommPayable" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
					<td><input type="text" id="txtTaggedCommPaid" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
					<td><input type="text" id="txtTaggedNetDue" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
				</tr>
				<tr>
					<td class="rightAligned"><label style="float: none; margin: 0 5px;">Grand Totals</label></td>
					<td><input type="text" id="txtTotActualComm" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
					<td><input type="text" id="txtTotCommPayable" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
					<td><input type="text" id="txtTotCommPaid" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
					<td><input type="text" id="txtTotNetDue" readonly="readonly" style="height: 14px; width: 120px; margin: 0; text-align: right;"/></td>
				</tr>
			</table>
		</div>
		<div>
			<input type="button" id="btnCommVoucher" class="button" value="Commission Voucher" style="margin: 20px auto 10px; width: 170px;"/>
			<input type="button" id="btnCommPayables" class="button" value="Commission Payable" style="margin: 20px auto 10px; width: 170px;"/>
			<input type="button" id="btnCommPayments" class="button" value="Commission Payments" style="margin: 20px auto 10px; width: 170px;"/>
		</div>
	</div>
	<div style="margin-bottom: 50px;">
		<input type="button" id="btnPrint" class="button" value="Print CV" style="margin: 10px auto; width: 120px;"/>
	</div>
</div>
<script type="text/javascript">
	try {
		
		$("mainNav").hide();
		
		setModuleId("GIACS155");
		setDocumentTitle("Commission Voucher");
		var checkIntm = "";
		var checkFund = "";
		var checkBranch = "";
		objGIACS155 = new Object();
		var recs = [];
		var withCv = false;	// shan 09.23.2014
		
		function initGIACS155(){
			$("txtIntmNo").focus();
			$("txtFundCd").readOnly = true;
			$("txtBranchCd").readOnly = true;
			disableSearch("imgFund");
			disableSearch("imgBranch");
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarPrint");
			disableButton("btnCommVoucher");
			disableButton("btnCommPayables");
			disableButton("btnCommPayments");
			disableButton("btnPrint");
		}
		
		function resetForm() {
			initGIACS155();
			objGIACS155 = new Object();
			enableSearch("imgIntm");
			disableSearch("imgFund");
			disableSearch("imgBranch");
			$("txtIntmNo").readOnly = false;
			tbgCommVoucher.url = contextPath+"/GIACCommissionVoucherController?action=populateCommVoucherTableGrid&refresh=1";
			tbgCommVoucher._refreshList();
			checkIntm = "";
			checkFund = "";
			checkBranch = "";
			$("txtIntmNo").clear();
			$("txtFundCd").clear();
			$("txtBranchCd").clear();
			$("txtIntmName").clear();
			$("txtFundDesc").clear();
			$("txtBranchName").clear();
			
			$("txtIntmNo").setAttribute("lastvalidValue", "");
			$("txtFundCd").setAttribute("lastvalidValue", "");
			$("txtBranchCd").setAttribute("lastvalidValue", "");
			recs = [];	// added to reset records to be printed : shan 09.23.2014
		}
		
		function getGIACS155IntmLov() {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS155IntmLov",
					filterText : ($F("txtIntmNo") == $("txtIntmNo").readAttribute("lastValidValue") ? "" : $F("txtIntmNo")),
					page : 1
				},
				title : "List of Intermediaries",
				width : 500,
				height : 386,
				columnModel : [ {
					id : "refIntmCd",
					title : "Ref Intm. Code",
					width : 100
				}, {
					id : "intmNo",
					title : "Intm. No.",
					width : 100,
					align: "right",
					titleAlign: "right",
					renderer: function(val){
						return formatNumberDigits(val, 5);
					}
				}, {
					id : "intmName",
					title : "Intermediary Name",
					width : 283,
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtIntmNo") == $("txtIntmNo").readAttribute("lastValidValue") ? "" : $F("txtIntmNo")),
				onSelect : function(row) {					
					objGIACS155.refIntmCd = row.refIntmCd;
					objGIACS155.intmNo = row.intmNo;
					objGIACS155.intmName = row.intmName;
					checkIntm = row.intmName;					
					$("txtIntmNo").value = row.intmNo;
					$("txtIntmNo").setAttribute("lastValidValue", $F("txtIntmNo"));
					$("txtIntmName").value = unescapeHTML2(row.intmName);
					$("txtIntmName").setAttribute("lastValidValue", $F("txtIntmName"));
					$("txtFundCd").readOnly = false;
					$("txtFundCd").focus();
					enableSearch("imgFund");
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel : function () {
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtIntmNo");
				}
			});
		}
		
		function getGIACS155FundLov() {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS155FundLov",
					intmNo : objGIACS155.intmNo,
					filterText : ($F("txtFundCd") == $("txtFundCd").readAttribute("lastValidValue") ? "" : $F("txtFundCd")),
					page : 1
				},
				title : "List of Funds",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "fundCd",
					title : "Fund Code",
					width : '120px',
				}, {
					id : "fundDesc",
					title : "Fund Description",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtFundCd") == $("txtFundCd").readAttribute("lastValidValue") ? "" : $F("txtFundCd")),
				onSelect : function(row) {
					$("txtFundCd").value = unescapeHTML2(row.fundCd);
					$("txtFundDesc").value = unescapeHTML2(row.fundDesc);
					$("txtFundCd").setAttribute("lastValidValue", $F("txtFundCd"));
					$("txtFundDesc").setAttribute("lastValidValue", $F("txtFundDesc"));					
					checkFund = $F("txtFundCd");
					objGIACS155.fundCd = $F("txtFundCd");
					$("txtBranchCd").readOnly = false;
					enableSearch("imgBranch");
					$("txtBranchCd").focus();
					enableToolbarButton("btnToolbarEnterQuery");
				},
				onCancel : function () {
					enableSearch("imgBranch");
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundCd");
				}
			});
		}
		
		function getGIACS155BranchLov() {
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS155BranchLov",
					intmNo : objGIACS155.intmNo,
					fundCd : objGIACS155.fundCd,
					filterText : ($F("txtBranchCd") == $("txtBranchCd").readAttribute("lastValidValue") ? "" : $F("txtBranchCd")),
					page : 1
				},
				title : "List of Branches",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "branchCd",
					title : "Branch Code",
					width : '120px',
				}, {
					id : "branchName",
					title : "Branch Name",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText : ($F("txtBranchCd") == $("txtBranchCd").readAttribute("lastValidValue") ? "" : $F("txtBranchCd")),
				onSelect : function(row) {
					checkBranch = row.branchCd;
					objGIACS155.branchCd = row.branchCd;
					$("txtBranchCd").value = row.branchCd;
					$("txtBranchName").value = unescapeHTML2(row.branchName);
					$("txtBranchCd").setAttribute("lastValidValue", $F("txtBranchCd"));
					$("txtBranchName").setAttribute("lastValidValue", $F("txtBranchName"));
					enableToolbarButton("btnToolbarEnterQuery");
					enableToolbarButton("btnToolbarExecuteQuery");
				},
				onCancel : function () {
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
				}
			});
		}
		
		function setTaggedTotals(checked, row, rowIndex) {
			if(checked) {
				var taggedActualComm = parseFloat($("txtTaggedActualComm").value.replace(/,/g,"")) + parseFloat(row.actualComm);
				var taggedCommPayable = parseFloat($("txtTaggedCommPayable").value.replace(/,/g,"")) + parseFloat(row.commPayable);
				var taggedCommPaid = parseFloat($("txtTaggedCommPaid").value.replace(/,/g,"")) + parseFloat(row.commPaid);
				var taggedNetDue = parseFloat($("txtTaggedNetDue").value.replace(/,/g,"")) + parseFloat(row.netDue);
				
				//edited by steven 11.13.2014 
				function showUserOverride(){
					if(row.overrideTag == 'Y' && row.actualComm != row.commPayable && !validateUserFunc2("OV", "GIACS155")) {
						showConfirmBox("", "User may print the partial commission voucher for partially-paid policies. Would you like to override?", "Yes", "No",
								function(){
						showGenericOverride( // this is the original function
								"GIACS155",
								"OV",
								function(ovr, userId, result){
									if(result == "FALSE"){
										showMessageBox("User " + userId + " is not allowed for override.", imgMessage.ERROR);
										$("txtOverrideUserName").clear();
										$("txtOverridePassword").clear();
										$("txtOverrideUserName").focus();
										return false;
									} else {
										if(result == "TRUE"){
											$("txtTaggedActualComm").value = formatCurrency(taggedActualComm);
											$("txtTaggedCommPayable").value = formatCurrency(taggedCommPayable);
											$("txtTaggedCommPaid").value = formatCurrency(taggedCommPaid);
											$("txtTaggedNetDue").value = formatCurrency(taggedNetDue);
											
											tbgCommVoucher.geniisysRows[rowIndex].overridingUser = $("txtOverrideUserName").value;
											objGIACS155.overrideTag = true;
											ovr.close();
											delete ovr;	
										}	
									}
								},
								function(){
									$("mtgInput1_2," + rowIndex).checked = false;
									removeRecord(row);
								}
						);	
						}, function(){
							$("mtgInput1_2," + rowIndex).checked = false;
							removeRecord(row);
						}, "");
					}else{
						$("txtTaggedActualComm").value = formatCurrency(taggedActualComm);
						$("txtTaggedCommPayable").value = formatCurrency(taggedCommPayable);
						$("txtTaggedCommPaid").value = formatCurrency(taggedCommPaid);
						$("txtTaggedNetDue").value = formatCurrency(taggedNetDue);
					}
				}
				
				function checkPolFlag(){
					if(row.polFlag == 4) {
						showConfirmBox("", "This is a cancelled policy. Would you still like to include this in the commission voucher?", "Yes", "No", 
							function(){ //function yes
								showUserOverride();	
							} , 
							function(){//function no
								$("mtgInput1_2," + rowIndex).checked = false;
								removeRecord(row);
							}, null);
					} else if (row.polFlag == 5) {
						showWaitingMessageBox("This is a spoiled policy.", "I", function(){
							$("mtgInput1_2," + rowIndex).checked = false;
							removeRecord(row);
						});
					} else {
						showUserOverride();	
					}
				}
				checkPolFlag();
				//end by steven 11.13.2014 
			} else {
				var taggedActualComm = parseFloat($("txtTaggedActualComm").value.replace(/,/g,"")) - parseFloat(row.actualComm);
				var taggedCommPayable = parseFloat($("txtTaggedCommPayable").value.replace(/,/g,"")) - parseFloat(row.commPayable);
				var taggedCommPaid = parseFloat($("txtTaggedCommPaid").value.replace(/,/g,"")) - parseFloat(row.commPaid);
				var taggedNetDue = parseFloat($("txtTaggedNetDue").value.replace(/,/g,"")) - parseFloat(row.netDue);
				
				$("txtTaggedActualComm").value = formatCurrency(taggedActualComm);
				$("txtTaggedCommPayable").value = formatCurrency(taggedCommPayable);
				$("txtTaggedCommPaid").value = formatCurrency(taggedCommPaid);
				$("txtTaggedNetDue").value = formatCurrency(taggedNetDue);
			}
		}
		
		/* function txtIntmNoKeypress(event) {
			if($("txtIntmNo").readOnly)
				return;
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0 || event == "clear") {
				objGIACS155.refIntmCd = "";
				objGIACS155.intmNo = "";
				objGIACS155.fundCd = "";
				objGIACS155.issCd = "";
				checkIntm = "";
				checkFund = "";
				checkBranch = "";
				disableSearch("imgFund");
				disableSearch("imgBranch");
				$("txtFundCd").readOnly = true;
				$("txtBranchCd").readOnly = true;
				$("txtFundCd").clear();
				$("txtBranchCd").clear();
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			} else if (event.keyCode == objKeyCode.ENTER) {
				$("imgIntm").click();
			}
		} */
		
		/* function txtFundCdKeypress(event) {
			if($("txtFundCd").readOnly)
				return;
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0 || event == "clear") {
				objGIACS155.fundCd = "";
				objGIACS155.issCd = "";
				checkFund = "";
				checkBranch = "";
				disableSearch("imgBranch");
				$("txtBranchCd").readOnly = true;
				$("txtBranchCd").clear();
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			} else if (event.keyCode == objKeyCode.ENTER) {
				$("imgFund").click();
			}
		} */
		
		/* function txtBranchCdKeypress(event) {
			if($("txtBranchCd").readOnly)
				return;
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0 || event == "clear") {
				objGIACS155.issCd = "";
				checkBranch = "";
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
			} else if (event.keyCode == objKeyCode.ENTER) {
				$("imgBranch").click();
			}
		} */
		
		$("imgIntm").observe("click", function(){
			getGIACS155IntmLov();
		});
		
		$("imgFund").observe("click", function(){
			getGIACS155FundLov();
		});
		
		$("imgBranch").observe("click", function(){
			getGIACS155BranchLov();
		});
		
		
		$("txtIntmNo").observe("change", function(){
			if(this.value.trim() == "") {
				this.clear();
				$("txtIntmName").clear();
				$("txtIntmNo").setAttribute("lastValidValue", "");
				$("txtIntmName").setAttribute("lastValidValue", "");
				
				objGIACS155.refIntmCd = "";
				objGIACS155.intmNo = "";
				objGIACS155.fundCd = "";
				objGIACS155.issCd = "";
				checkIntm = "";
				checkFund = "";
				checkBranch = "";
				disableSearch("imgFund");
				disableSearch("imgBranch");
				$("txtFundCd").readOnly = true;
				$("txtBranchCd").readOnly = true;
				$("txtFundCd").clear();
				$("txtBranchCd").clear();
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				
				
				return;
			}
			$("imgIntm").click();
		});
		
		$("txtFundCd").observe("change", function(){
			if(this.value.trim() == "") {
				this.clear();
				$("txtFundDesc").clear();
				$("txtFundCd").setAttribute("lastValidValue", "");
				$("txtFundDesc").setAttribute("lastValidValue", "");			
				
				objGIACS155.fundCd = "";
				objGIACS155.issCd = "";
				checkFund = "";
				checkBranch = "";
				disableSearch("imgBranch");
				$("txtBranchCd").readOnly = true;
				$("txtBranchCd").clear();
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				
				return;
			}
			$("imgFund").click();
		});
		
		$("txtBranchCd").observe("change", function(){
			if(this.value.trim() == "") {
				this.clear();
				$("txtBranchName").clear();
				$("txtBranchCd").setAttribute("lastValidValue", "");
				$("txtBranchName").setAttribute("lastValidValue", "");			
				
				objGIACS155.issCd = "";
				checkBranch = "";
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				
				return;
			}
			$("imgBranch").click();
		});
		
		
		//$("txtIntmNo").observe("keypress", txtIntmNoKeypress);
		//$("txtFundCd").observe("keypress", txtFundCdKeypress);
		//$("txtBranchCd").observe("keypress", txtBranchCdKeypress);
		
		function setDetails(obj) {
			if(obj != null) {
				objGIACS155.premSeqNo = obj.premSeqNo;
				objGIACS155.policyId = obj.policyId;
				objGIACS155.policyNo = obj.policyNo;
				enableButton("btnCommVoucher");
				enableButton("btnCommPayables");
				enableButton("btnCommPayments");
			} else {
				delete objGIACS155.premSeqNo;
				delete objGIACS155.policyId;
				delete objGIACS155.policyNo;
				disableButton("btnCommVoucher");
				disableButton("btnCommPayables");
				disableButton("btnCommPayments");
			}
		}
		
		function showCommInvoice() {
			showNotice("Loading, please wait...");
			try {
				overlayCommInvoice = 
					Overlay.show(contextPath+"/GIACCommissionVoucherController", {
						urlContent: true,
						urlParameters: {action : "showCommInvoice",																
										ajax : "1",
										intmNo : objGIACS155.intmNo,
										issCd : objGIACS155.branchCd,
										premSeqNo : objGIACS155.premSeqNo,
										policyId : objGIACS155.policyId
						},
					    title: "Commission Voucher",
					    height: 442,
					    width: 808,
					    draggable: true
					});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function showCommPayable() {
			showNotice("Loading, please wait...");
			try {
				overlayCommPayable = 
					Overlay.show(contextPath+"/GIACCommissionVoucherController", {
						urlContent: true,
						urlParameters: {action : "showCommPayables",																
										ajax : "1",
										intmNo : objGIACS155.intmNo,
										issCd : objGIACS155.branchCd,
										premSeqNo : objGIACS155.premSeqNo,
										policyId : objGIACS155.policyId
						},
					    title: "Commission Payables",
					    height: 307,
					    width: 692,
					    draggable: true
					});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function showCommPayments() {
			showNotice("Loading, please wait...");
			try {
				overlayCommPayments = 
					Overlay.show(contextPath+"/GIACCommissionVoucherController", {
						urlContent: true,
						urlParameters: {action : "showCommPayments",																
										ajax : "1",
										intmNo : objGIACS155.intmNo,
										issCd : objGIACS155.branchCd,
										premSeqNo : objGIACS155.premSeqNo
						},
					    title: "Commission Payments",
					    height: 387,
					    width: 708,
					    draggable: true
					});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
				
		var jsonItemInfoTableGrid = [];
		commVoucherTableModel = {
				url: contextPath+"/GIACCommissionVoucherController?action=populateCommVoucherTableGrid&refresh=1",
				options: {
					hideColumnChildTitle: true,
					validateChangesOnPrePager: false,
					validateChangesOnRefresh: false,
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					height: '230px',
					onCellFocus : function(element, value, x, y, id) {
						tbgCommVoucher.keys.removeFocus(tbgCommVoucher.keys._nCurrentFocus, true);
						tbgCommVoucher.keys.releaseKeys();
						setDetails(tbgCommVoucher.geniisysRows[y]);
						//observeChangeTagInTableGrid(tbgCommVoucher);
						//populateGroupedItemsInfoTableGrid(tbgCommVoucher.geniisysRows[y]);
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgCommVoucher.keys.removeFocus(tbgCommVoucher.keys._nCurrentFocus, true);
						tbgCommVoucher.keys.releaseKeys();
						setDetails(null);
						//populateGroupedItemsInfoTableGrid(null);
					},
					prePager : function(){
						
					},
					onSort: function(){
						recs = [];
						$("txtTaggedActualComm").value = formatCurrency(0);
						$("txtTaggedCommPayable").value = formatCurrency(0);
						$("txtTaggedCommPaid").value = formatCurrency(0);
						$("txtTaggedNetDue").value = formatCurrency(0);
						tbgCommVoucher.keys.removeFocus(tbgCommVoucher.keys._nCurrentFocus, true);
						tbgCommVoucher.keys.releaseKeys();
					},
					beforeSort: function(){
						recs = [];
						$("txtTaggedActualComm").value = formatCurrency(0);
						$("txtTaggedCommPayable").value = formatCurrency(0);
						$("txtTaggedCommPaid").value = formatCurrency(0);
						$("txtTaggedNetDue").value = formatCurrency(0);
						tbgCommVoucher.keys.removeFocus(tbgCommVoucher.keys._nCurrentFocus, true);
						tbgCommVoucher.keys.releaseKeys();
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
						id: 'includeTag',
						title: 'I',
						altTitle: "Include",
						width: '30px',
						align: 'center',
						titleAlign: 'center',
						editable: true,
						sortable: false,
						editor: "checkbox"
					},
					{
						id : "issCd premSeqNo",
						title : "Invoice No.",
						children : [
							{
								id : "issCd",
								width : 50
							},
							{
								id : "premSeqNo",
								title : "Prem Seq No",
								width : 75, /* width : 65 edited by MarkS SR5832 */
								filterOption : true,
								filterOptionType: "number",
								renderer : function(val) {
									return formatNumberDigits(val, 12); /*  formatNumberDigits(val, 10) edited by MarkS SR5832 */
								}
							}
			            ]
					},
					{
						id : "cvPref cvNo cvDate",
						title : "Comm Voucher No. / Date",
						children : [
		            		{
		            			id : "cvPref",
		            			title : "CV Pref",
		            			width : 50,
		            			filterOption : true
		            		},
		            		{
		            			id : "cvNo",
		            			title : "CV No.",
		            			width : 50,
		            			filterOption : true,
		            			filterOptionType : "number"
		            		},
		            		{
		            			id : "cvDate",
		            			title : "CV Date",
		            			width : 80,
		            			align : "center",
		            			filterOption : true,
		            			filterOptionType : "formattedDate",
		            			renderer : function(val) {
		            				if(val != "" && val != null)
		            					return dateFormat(val, "mm-dd-yyyy");
		            				else
		            					return "";
		            			}
		            		}
		            	]
					},
					{
						id : "policyNo",
						title : "Policy No.",
						width: 170,
						filterOption : true
					},
					{
						id : "actualComm",
						title : "Actual Comm",
						width : 90,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money",
						filterOption : true,
						filterOptionType : "number"
					},
					{
						id : "commPayable",
						title : "Comm Payable",
						width : 90,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money",
						filterOption : true,
						filterOptionType : "number"
					},
					{
						id : "commPaid",
						title : "Comm Paid",
						width : 90,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money",
						filterOption : true,
						filterOptionType : "number"
					},
					{
						id : "netDue",
						title : "Net Due",
						width : 90,
						align : "right",
						titleAlign : "right",
						geniisysClass : "money",
						filterOption : true,
						filterOptionType : "number"
					}
				],
				rows: []
			};
		
		tbgCommVoucher = new MyTableGrid(commVoucherTableModel);
		tbgCommVoucher.pager = [];
		tbgCommVoucher.render('commVoucherTable');
		tbgCommVoucher.afterRender = function(){
			setDetails(null);
			if(tbgCommVoucher.geniisysRows.length > 0) {
				tbgCommVoucher.keys.removeFocus(tbgCommVoucher.keys._nCurrentFocus, true);
				tbgCommVoucher.keys.releaseKeys();
				
				var rec = tbgCommVoucher.geniisysRows[0];
				objGIACS155.overrideTag = rec.overrideTag;
				
				$("txtTotActualComm").value = formatCurrency(rec.totActualComm);
				$("txtTotCommPayable").value = formatCurrency(rec.totCommPayable);
				$("txtTotCommPaid").value = formatCurrency(rec.totCommPaid);
				$("txtTotNetDue").value = formatCurrency(rec.totNetDue);
				
				$$("div#myTableGrid1 .mtgInputCheckbox").each(
					function(obj){
						obj.observe("click", function(){
							var rowIndex = this.id.substring(this.id.length - 1);
							var row = tbgCommVoucher.geniisysRows[rowIndex];
							var allRow = tbgCommVoucher.geniisysRows;
							
							if(this.checked){
								if(recs.length != 0){
									var exists = false;
									for(var x = 0; x < recs.length; x++){
										if((nvl(recs[x].cvNo, "") != "" && nvl(row.cvNo, "") == "") 
												|| (nvl(recs[x].cvNo, "") == "" && nvl(row.cvNo, "") != "")){
											showMessageBox("Cannot combine unprinted records with printed records.", "I");
											this.checked = false;
											return;
										} else if(recs[x].cvNo != row.cvNo){
											showMessageBox("Cannot combine records with different comm voucher numbers.", "I");
											this.checked = false;
											return;
										}
									}
								} 
							}
							
							if (row.cvPref != null && row.cvNo != null) {
								for ( var i = 0; i < allRow.length; i++) {
									if (row.cvPref == allRow[i].cvPref && row.cvNo == allRow[i].cvNo) {
										var taggedActualComm = parseFloat($("txtTaggedActualComm").value.replace(/,/g,"")) + parseFloat(allRow[i].actualComm);
										var taggedCommPayable = parseFloat($("txtTaggedCommPayable").value.replace(/,/g,"")) + parseFloat(allRow[i].commPayable);
										var taggedCommPaid = parseFloat($("txtTaggedCommPaid").value.replace(/,/g,"")) + parseFloat(allRow[i].commPaid);
										var taggedNetDue = parseFloat($("txtTaggedNetDue").value.replace(/,/g,"")) + parseFloat(allRow[i].netDue);
										
										var untaggedActualComm = parseFloat($("txtTaggedActualComm").value.replace(/,/g,"")) - parseFloat(allRow[i].actualComm);
										var untaggedCommPayable = parseFloat($("txtTaggedCommPayable").value.replace(/,/g,"")) - parseFloat(allRow[i].commPayable);
										var untaggedCommPaid = parseFloat($("txtTaggedCommPaid").value.replace(/,/g,"")) - parseFloat(allRow[i].commPaid);
										var untaggedNetDue = parseFloat($("txtTaggedNetDue").value.replace(/,/g,"")) - parseFloat(allRow[i].netDue);
										
										if($("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).id != this.id && $("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).checked){//untag second and above record
											$("txtTaggedActualComm").value = formatCurrency(untaggedActualComm);
											$("txtTaggedCommPayable").value = formatCurrency(untaggedCommPayable);
											$("txtTaggedCommPaid").value = formatCurrency(untaggedCommPaid);
											$("txtTaggedNetDue").value = formatCurrency(untaggedNetDue);
											$("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).checked = false;
										}else if($("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).id != this.id && !$("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).checked){//tag second and above record
											$("txtTaggedActualComm").value = formatCurrency(taggedActualComm);
											$("txtTaggedCommPayable").value = formatCurrency(taggedCommPayable);
											$("txtTaggedCommPaid").value = formatCurrency(taggedCommPaid);
											$("txtTaggedNetDue").value = formatCurrency(taggedNetDue);
											$("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).checked = true;
										}else if($("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).id == this.id && $("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).checked){ //tag first record
											$("txtTaggedActualComm").value = formatCurrency(taggedActualComm);
											$("txtTaggedCommPayable").value = formatCurrency(taggedCommPayable);
											$("txtTaggedCommPaid").value = formatCurrency(taggedCommPaid);
											$("txtTaggedNetDue").value = formatCurrency(taggedNetDue);
											
										}else if($("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).id == this.id && !$("mtgInput"+tbgCommVoucher._mtgId+"_2,"+i).checked){ //untag first record
											$("txtTaggedActualComm").value = formatCurrency(untaggedActualComm);
											$("txtTaggedCommPayable").value = formatCurrency(untaggedCommPayable);
											$("txtTaggedCommPaid").value = formatCurrency(untaggedCommPaid);
											$("txtTaggedNetDue").value = formatCurrency(untaggedNetDue);
										}
									}
								}
							 	
							 	// bonok :: 1.16.2017 :: RSIC SR 23713
							 	if(this.checked){
							 		getTotalForPrintedCV(row.cvPref, row.cvNo);
							 	}else{
									$("txtTaggedActualComm").value = formatCurrency(0);
									$("txtTaggedCommPayable").value = formatCurrency(0);
									$("txtTaggedCommPaid").value = formatCurrency(0);
									$("txtTaggedNetDue").value = formatCurrency(0);
							 	}
							}else{
								setTaggedTotals(this.checked, row, rowIndex);
							}
							//end steven 11.13.2014
							//add/removes record when checked/unchecked
							//to be used in setting checkbox after render
							if(this.checked){
								if(recs.length == 0){
									recs.push(row);
								} else {
									var exists = false;
									for(var x = 0; x < recs.length; x++){
										if(row == recs[x]){
											exists = true;
										}
									}
									
									if(!exists){
										recs.push(row);
									}
								} 
							} else {
								removeRecord(row);
							}
						});
					}
				);
				
				//sets checkbox after render
				for(var x = 0; x < tbgCommVoucher.geniisysRows.length; x++){
					for(var y = 0; y < recs.length; y++){						
						if(JSON.stringify(tbgCommVoucher.geniisysRows[x]) == JSON.stringify(recs[y])){
							$("mtgInput1_2," + x).checked = true;
							break;
						} else if (nvl(tbgCommVoucher.geniisysRows[x].cvNo, "") != "" 
								&& tbgCommVoucher.geniisysRows[x].cvNo == recs[y].cvNo 
								&& tbgCommVoucher.geniisysRows[x].cvPref == recs[y].cvPref) {
							$("mtgInput1_2," + x).checked = true;
							break;
						}
					}
				}
				
				enableButton("btnPrint");
				enableToolbarButton("btnToolbarPrint");
				
			} else {
				$("txtTaggedActualComm").clear();
				$("txtTaggedCommPayable").clear();
				$("txtTaggedCommPaid").clear();
				$("txtTaggedNetDue").clear();
				$("txtTotActualComm").clear();
				$("txtTotCommPayable").clear();
				$("txtTotCommPaid").clear();
				$("txtTotNetDue").clear();
				disableButton("btnPrint");
				disableToolbarButton("btnToolbarPrint");
			}
		};
		
		// bonok :: 1.16.2017 :: RSIC SR 23713
		function getTotalForPrintedCV(cvPref, cvNo){
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController",{
				method: "GET",
				parameters:{
					action : "getTotalForPrintedCV",
					cvPref : cvPref,
					cvNo : cvNo,
					intmNo : $F("txtIntmNo"),
					fundCd : $F("txtFundCd"),
					branchCd : $F("txtBranchCd")
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();					
					var res = JSON.parse(response.responseText);
					
					$("txtTaggedActualComm").value = formatCurrency(res.totActualComm);
					$("txtTaggedCommPayable").value = formatCurrency(res.totCommPayable);
					$("txtTaggedCommPaid").value = formatCurrency(res.totCommPaid);
					$("txtTaggedNetDue").value = formatCurrency(res.totNetDue);
				}
			});
		}
		
		function executeQuery(){
			tbgCommVoucher.url = contextPath+"/GIACCommissionVoucherController?action=populateCommVoucherTableGrid&refresh=1&intmNo=" + objGIACS155.intmNo + 
									"&fundCd=" + objGIACS155.fundCd + "&branchCd=" + objGIACS155.branchCd;
			tbgCommVoucher._refreshList();
			
			disableToolbarButton("btnToolbarExecuteQuery");
			disableSearch("imgIntm");
			disableSearch("imgFund");
			disableSearch("imgBranch");
			$("txtIntmNo").readOnly = true;
			$("txtFundCd").readOnly = true;
			$("txtBranchCd").readOnly = true;
			
			
			if(tbgCommVoucher.geniisysRows.length == 0)
				customShowMessageBox("Query caused no records to be retrieved. Re-enter.", imgMessage.INFO, "txtIntmNo");
			else{
				$("txtTaggedActualComm").value = "0.00";
				$("txtTaggedCommPayable").value = "0.00";
				$("txtTaggedCommPaid").value = "0.00";
				$("txtTaggedNetDue").value = "0.00";
			}

							
		}
		
		function getGrpIssCd(){
			var repId = "";
			var grpIssCd = "";
			if($("chkPrintDetail").checked)
				repId = "GIACR251A";
			else
				repId = "GIACR251";
			
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController",{
				method: "POST",
				parameters:{
					action     : "getGIACS155GrpIssCd",
					repId : repId
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();					
					if(checkErrorOnResponse(response)) {
						grpIssCd = response.responseText;
					}
				}
			});
			return grpIssCd;
		}
		
		function removeIncludeTag() {
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController",{
				method: "POST",
				parameters:{
					action     : "removeIncludeTag"
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();					
					if(checkErrorOnResponse(response)) {
						recs = [];
						$("txtTaggedActualComm").value = formatCurrency(0);
						$("txtTaggedCommPayable").value = formatCurrency(0);
						$("txtTaggedCommPaid").value = formatCurrency(0);
						$("txtTaggedNetDue").value = formatCurrency(0);
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		function removeIncludeTag2() {
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController",{
				method: "POST",
				parameters:{
					action     : "removeIncludeTag"
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();					
					if(checkErrorOnResponse(response)) {
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		function saveCVNo() {
			
			/* var recordsToBePrinted = new Array();
			for(var x = 0; x < tbgCommVoucher.geniisysRows.length; x ++) {
				if($("mtgInput1_2," + x).checked){
					recordsToBePrinted.push(tbgCommVoucher.geniisysRows[x]);
				}	
			} */
			var objRecordsToBePrinted = new Object();
			//objRecordsToBePrinted = recordsToBePrinted;
			objRecordsToBePrinted = recs;
			
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController",{
				method: "POST",
				parameters:{
					action     : "saveCVNo",
					parameters : prepareJsonAsParameter(objRecordsToBePrinted),
					intmNo : objGIACS155.intmNo,
					fundCd : objGIACS155.fundCd,
					cvPref : objGIACS155.cvPref,
					cvNo : objGIACS155.cvNo,
					cvDate : objGIACS155.cvDate
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();					
					if(checkErrorOnResponse(response)) {
						
					} else {
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
		
		var reports = [];
		function checkReport(){
			var grpIssCd = getGrpIssCd();
			/* for(var i = 0; i < tbgCommVoucher.geniisysRows.length; i++){
				if($("mtgInput1_2," + i).checked == true)
					onPrint();
			} */
			
			onPrint();
			
			if ("screen" == $F("selDestination")) {
				showGIACS155MultiPdfReport(reports);
				reports = [];
			}
			
			/* if($F("selDestination") != "file"){
				showConfirmBox("", "Was the Commission Voucher printed correctly?", "Yes", "No",
						function(){
							if(objGIACS155.updateSw == 'N') {
								saveCVNo();
							}
							removeIncludeTag();
							overlayGenericPrintDialog.close();
							tbgCommVoucher.url = contextPath+"/GIACCommissionVoucherController?action=populateCommVoucherTableGrid&refresh=1&intmNo=" + objGIACS155.intmNo + 
							"&fundCd=" + objGIACS155.fundCd + "&branchCd=" + objGIACS155.branchCd;
							tbgCommVoucher._refreshList();
							
						},
						function(){
							//removeIncludeTag();
							removeIncludeTag2();
							overlayGenericPrintDialog.close();
						});
			} */
		}
		
		function onPrint(){
			try {
				var content = contextPath + "/GeneralDisbursementPrintController?action=printGIACR251"
											+ "&noOfCopies=" + $F("txtNoOfCopies")
							                + "&printerName=" + $F("selPrinter")
							                + "&destination=" + $F("selDestination");
				var reptTitle = "";
				
				if($("chkPrintDetail").checked) {
					reptTitle = "Commission Voucher - Detail";
					content = contextPath + "/GeneralDisbursementPrintController?action=printGIACR251A" + 
											"&reportId=GIACR251A" +
											"&intmNo=" + objGIACS155.intmNo + 
											"&cvNo=" + objGIACS155.cvNo +
											"&cvPref=" + objGIACS155.cvPref + 
											"&cvDate=" + dateFormat(objGIACS155.cvDate, "mm-dd-yyyy") + 
											"&branchCd=" + objGIACS155.branchCd +
											"&noOfCopies=" + $F("txtNoOfCopies") +
							                "&printerName=" + $F("selPrinter") +
							                "&destination=" + $F("selDestination");
				} else {
					reptTitle = "Commission Voucher";
					content = contextPath + "/GeneralDisbursementPrintController?action=printGIACR251" + 
											"&reportId=GIACR251" +
											"&intmNo=" + objGIACS155.intmNo + 
											"&cvNo=" + objGIACS155.cvNo +
											"&cvPref=" + objGIACS155.cvPref + 
											"&cvDate=" + dateFormat(objGIACS155.cvDate, "mm-dd-yyyy") + // bonok :: 12.8.2015 :: UCPB SR19912
											"&branchCd=" + objGIACS155.branchCd +
											"&noOfCopies=" + $F("txtNoOfCopies") +
							                "&printerName=" + $F("selPrinter") +
							                "&destination=" + $F("selDestination");
				}
					
				
				if("screen" == $F("selDestination")){
					reports.push({reportUrl : content, reportTitle : reptTitle});
				}else if($F("selDestination") == "printer"){
					new Ajax.Request(content, {
						parameters : {noOfCopies : $F("txtNoOfCopies")},
						onCreate: showNotice("Processing, please wait..."),				
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								postPrint();
							}
						}
					});
				}else if("file" == $F("selDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "file",
									  fileType : "PDF"},
						onCreate: showNotice("Generating report, please wait..."),
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								copyFileToLocal(response, null, function(){
									postPrint();
								});
							}
						}
					});
				}else if("local" == $F("selDestination")){
					new Ajax.Request(content, {
						parameters : {destination : "local"},
						onComplete: function(response){
							hideNotice();
							if (checkErrorOnResponse(response)){
								var message = printToLocalPrinter(response.responseText);
								if(message != "SUCCESS"){
									showMessageBox(message, imgMessage.ERROR);
								} else
									postPrint();
							}
						}
					});
				}
			} catch (e){
				showErrorMessage("printReport", e);
			}
			/* if($("chkPrintDetail").checked){
				//GIACR251A
				showMessageBox("Report is not yet available.", "I");
			}else{
				//GIACR251
				showMessageBox("Report is not yet available.", "I");
			} */
		}
		
		function onLoad(cvPref, cvNo, cvDate){
			try{
				var content =
					"<table border='0' align='center' style='border-spacing: 0; border-collapse: collapse; margin: 10px 0 10px 0; position: relative; left : 5px; height: 14px;'>" + 
					"<tr><td class='rightAligned'>Voucher No.</td><td style='padding-left : 5px; padding-right: 2px; height: 14px;'><input type='text' id='txtPrintCvPrint' readonly='readonly' value='" + nvl(cvPref, "") + "' style='height: 14px; width: 50px;p' /></td>" + 
					"<td><input type='text' id='txtPrintCvNo' readonly='readonly' value='" + formatNumberDigits(cvNo, 10) + "' style='width: 80px; text-align: right; height: 14px'/></td>" +  /* formatNumberDigits(cvNo, 8) edited by MarkS SR5832 */
					"<td><input type='checkbox' id='chkPrintDetail' style='margin-left: 10px;'/></td><td><label for='chkPrintDetail'>Details</td></td>" +
					"</tr>" + 
					"<tr><td class='rightAligned'>Voucher Date</td><td colspan='2' style='padding-left : 5px;'><input type='text' id='txtPrintCvDate' value='" + dateFormat(cvDate, 'mm-dd-yyyy') + "' readonly='readonly' style='width: 140px; height: 14px;'/></td>" +
					"</tr>" +
					"</table>";
				$("printDialogFormDiv3").update(content); 
				$("printDialogFormDiv3").show();
				$("printDialogMainDiv").up("div",1).style.height = "225px";
				$($("printDialogMainDiv").up("div",1).id).up("div",0).style.height = "257px";
			}catch(e){
				showErrorMessage("onLoad", e);
			}
		}
		
		function printCV() {
			/* var recordsToBePrinted = new Array();
			for(var x = 0; x < tbgCommVoucher.geniisysRows.length; x ++) {
				if($("mtgInput1_2," + x).checked){
					recordsToBePrinted.push(tbgCommVoucher.geniisysRows[x]);
				}	
			} */
			var objRecordsToBePrinted = new Object();
			//objRecordsToBePrinted = recordsToBePrinted;
			objRecordsToBePrinted = recs;
			
			new Ajax.Request(contextPath+"/GIACCommissionVoucherController",{
				method: "POST",
				parameters:{
					action     : "updateGIACS155CommVoucherExt",
					parameters : prepareJsonAsParameter(objRecordsToBePrinted),
					intmNo : objGIACS155.intmNo,
					fundCd : objGIACS155.fundCd
				},
				asynchronous: false,
				onCreate: function(){
					showNotice("Loading, please wait...");
				},
				onComplete: function(response){
					hideNotice();					
					if(checkErrorOnResponse(response)) {
						try {
							var obj = JSON.parse(response.responseText);
							if(obj.message == "good" || obj.message == "no_update"){
								obj.message == "no_update" ? objGIACS155.updateSw = "Y" : objGIACS155.updateSw = "N";
								showGenericPrintDialog("Commission Payments", checkReport, function(){
									if(obj.cvNo == "" || obj.cvNo == null){ // bonok :: 12.21.2015 UCPB SR 19912 :: added condition to check first if there is a maintained sequence number for COMM_VCR
										showWaitingMessageBox("No Commission Voucher number maintained in Document Sequence Maintenance for this branch.", "I", function(){
											overlayGenericPrintDialog.close();	
										});
									}else{
										objGIACS155.cvPref = obj.cvPref;
										objGIACS155.cvNo = obj.cvNo;
										objGIACS155.cvDate = obj.cvDate;
										onLoad(obj.cvPref, obj.cvNo, obj.cvDate);	
									}
								}, false, removeIncludeTag2);
								
								withCv = false;	// shan 09.23.2014
								for (var i=0; i < obj.rows.length; i++){
									if (obj.rows[i].cvNo == null){
										withCv = true;
										break;
									}
								}
							} else {
								objGIACS155.updateSw = "N";
								showMessageBox(obj.message, imgMessage.ERROR);
							}
						} catch (e) {
							showErrorMessage("", e);
						}
					}else{
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
			
		}
		
		$("btnToolbarExecuteQuery").observe("click", executeQuery);
		$("btnToolbarEnterQuery").observe("click", resetForm);
		$("btnToolbarExit").observe("click", function(){
			$("acExit").click();
		});
		$("btnCommVoucher").observe("click", showCommInvoice);
		$("btnCommPayables").observe("click", showCommPayable);
		$("btnCommPayments").observe("click", showCommPayments);
		$("btnToolbarPrint").observe("click", function(){
			$("btnPrint").click();
		});
		$("btnPrint").observe("click", function(){
			/* var checker = false;
			for(var x = 0; x < tbgCommVoucher.geniisysRows.length; x ++) {
				if($("mtgInput1_2," + x).checked){
					checker = true;
				}	
			} */

			if(recs.length != 0){
				printCV();
			} else {
				showMessageBox("Please check record/s to print.", "I");
			}
		});
		
		
		$("acExit").stopObserving();
		
		$("acExit").observe("click", function(){
			delete objGIACS155;
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", null);
		});
		
		initializeAll();
		initGIACS155();	
		
		$("reloadForm").observe("click", showGIACS155);
		
		$("mtgRefreshBtn1").stopObserving();
		$("mtgRefreshBtn1").observe("click", function(){
			recs = [];
			$("txtTaggedActualComm").value = formatCurrency(0);
			$("txtTaggedCommPayable").value = formatCurrency(0);
			$("txtTaggedCommPaid").value = formatCurrency(0);
			$("txtTaggedNetDue").value = formatCurrency(0);
			tbgCommVoucher._refreshList();
		});
		
		function removeRecord(row){
			for(var x = 0; x < recs.length; x++){
				if(JSON.stringify(row) == JSON.stringify(recs[x])){
					recs.splice(x, 1);
					break;
				} else if(nvl(row.cvNo, "") != "" 
						&& row.cvNo == recs[x].cvNo 
						&& row.cvPref == recs[x].cvPref){
					recs.splice(x, 1);
					break;
				}  
			}
		}
		
		function showGIACS155MultiPdfReport(reports){
			var checkUrl = reports[0].reportUrl + "&checkIfReportExists=true";
			new Ajax.Request(checkUrl, {
				onComplete: function(r){
					if(r.responseText == "reportExists"){
						new Ajax.Request(contextPath + "/GIISUserController", {
							action: "POST",
							asynchronous : false,
							parameters : {action: "setReportListToSession",
									  	  reportList : prepareJsonAsParameter(reports)},
							onComplete: function(response){
								for(var x=0; x<reports.length; x++){
									window.open('pages/multiReport.jsp?index='+x, '', 'location=0, toolbar=0, menubar=0, fullscreen=1');
								}
								postPrint();
							}
						});
					} else {
						showMessageBox(r.responseText, "E");
					}
				}
			});	
		}
		
		function postPrint() {
			if (withCv){	// added condition to show message if selected records do not have cvNo : shan 09.23.2014
				showConfirmBox("", "Was the Commission Voucher printed correctly?", "Yes", "No",
						function(){
							if(objGIACS155.updateSw == 'N') {
								saveCVNo();
							}
							removeIncludeTag();
							overlayGenericPrintDialog.close();
							tbgCommVoucher.url = contextPath+"/GIACCommissionVoucherController?action=populateCommVoucherTableGrid&refresh=1&intmNo=" + objGIACS155.intmNo + 
							"&fundCd=" + objGIACS155.fundCd + "&branchCd=" + objGIACS155.branchCd;
							tbgCommVoucher._refreshList();
							
						},
						function(){
							removeIncludeTag2();
							overlayGenericPrintDialog.close();
						});
			}
		}
		
	} catch (e) {
		showErrorMessage("Commission Voucher Error", e);
	}
</script>