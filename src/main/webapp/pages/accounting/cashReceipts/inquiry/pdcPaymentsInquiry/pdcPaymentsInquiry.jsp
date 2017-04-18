<div id="pdcPaymentsInquiryDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv">
		<div id="innerDiv">
	   		<label>View PDC Payments</label>
	   	</div>
	</div>
	<div class="sectionDiv">
		<table style="margin: 10px auto;" >
			<tr>
				<td class="rightAligned">Company</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 470px; margin-right: 20px;">
						<input type="text" id="txtFundDesc" style="width: 445px; float: left; border: none; height: 14px; margin: 0;" tabindex="101"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchFund" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td></td>
				<td class="rightAligned">Branch</td>
				<td class="leftAligned">
					<span class="lovSpan" style="width: 240px;">
						<input type="text" id="txtBranchName" style="width: 215px; float: left; border: none; height: 14px; margin: 0;" tabindex="102"/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgSearchBranch" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<div style="padding-top: 10px; padding-left: 10px; float: left; ">
			<div id="pdcPaymentsTable" style="height: 295px;"></div>
		</div>	
		<div class="sectionDiv" style="width: 132px; float: right; text-align: center; margin: 10px 10px 0 0; padding-top: 15px;">
			<strong>Status</strong>
			<div class="sectionDiv" style="width: 120px; margin: 15px 0px 5px 5px;">
				<table cellspacing="5px" style="margin: 5px 0">
					<tr>
						<td><input type="radio" name="rdoFilter" id="rdoAll" tabindex="201" /></td>
						<td><label for="rdoAll">All PDCs</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoFilter" id="rdoNew" tabindex="202" /></td>
						<td><label for="rdoNew">New</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoFilter" id="rdoWithDetails" tabindex="203" /></td>
						<td><label for="rdoWithDetails">With Details</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoFilter" id="rdoReplaced" tabindex="204" /></td>
						<td><label for="rdoReplaced">Replaced</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoFilter" id="rdoCancelled" tabindex="205"/></td>
						<td><label for="rdoCancelled">Cancelled</label></td>
					</tr>
					<tr>
						<td><input type="radio" name="rdoFilter" id="rdoApplied" tabindex="206"/></td>
						<td><label for="rdoApplied">Applied</label></td>
					</tr>
				</table>
			</div>
		</div>
		<div style="clear: both; text-align: center; margin-bottom: 20px;" >
			<input type="button" id="btnORParticulars" value="OR Particulars" class="disabledButton" style="width: 150px; margin: 0 2px;"  tabindex="301"/>
			<input type="button" id="btnMiscAmount" value="Misc Amount" class="disabledButton" style="width: 150px;  margin: 0 2px;" tabindex="302"/>
			<input type="button" id="btnForeignCurrency" value="Foreign Currency" class="disabledButton" style="width: 150px;  margin: 0 2px;" tabindex="303"/>
			<input type="button" id="btnDetails" value="Details" class="disabledButton" style="width: 150px;  margin: 0 2px;" tabindex="304"/>
			<input type="button" id="btnReplacement" value="Replacement" class="disabledButton" style="width: 150px;  margin: 0 2px;" tabindex="305"/>
		</div>
	</div>
</div>
<script type="text/javascript">
	try {
		
		var onLOV = false;
		objGIACS092 = new Object();
		
		function initGIACS092() {
			setModuleId("GIACS092");
			setDocumentTitle("View PDC Payments");
			$("acExit").hide();
			$("mainNav").hide();
			onLOV = false;
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarPrint");
			$("txtFundDesc").focus();
			$("rdoAll").checked = true;
		}
		
		pdcPaymentsTableModel = {
				url: contextPath+"/GIPIPolbasicController?action=showGIPIS132&refresh=1",	
				options: {
					hideColumnChildTitle: true,
					toolbar: {
						elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN]
					},
					width: '760px',
					height: '250px',
					onCellFocus : function(element, value, x, y, id) {
						tbgPdcPayments.keys.removeFocus(tbgPdcPayments.keys._nCurrentFocus, true);
						tbgPdcPayments.keys.releaseKeys();
						setDetails(tbgPdcPayments.geniisysRows[y]);
					},
					onRemoveRowFocus : function(element, value, x, y, id){
						tbgPdcPayments.keys.removeFocus(tbgPdcPayments.keys._nCurrentFocus, true);
						tbgPdcPayments.keys.releaseKeys();
						setDetails(null);
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
						id: 'apdcNo',
						title : 'APDC No.',
						width : "80px",
						filterOption : true,
					    filterOptionType : 'number',
					    align : 'right',
					    titleAlign : 'right',
					    renderer : function(value) {
					    	return value == 0 ? '' : formatNumberDigits(value,10);
					    }
					},
					{
						id: 'apdcDate',
						title: 'APDC Date',
						width: "90px",
						titleAlign : 'center',
						align : 'center',
						filterOption: true,
						filterOptionType : 'formattedDate',
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						}
						
					},
					{
						id: 'bankSname',
						title : 'Bank',
						width: "150px",
						filterOption: true
					},
					{
						id: 'checkNo',
						title : 'Check No',
						width: "140px",
						filterOption : true
					},
					{
						id: 'checkDate',
						title : 'Check Date',
						width: "90px",
						titleAlign : 'center',
						align : 'center',
						filterOption: true,
						filterOptionType : 'formattedDate',
						renderer: function(value){
							return dateFormat(value, "mm-dd-yyyy");
						}
					},
					{
						id: 'checkAmt',
						title : 'Amount',
						width: "110px",
						filterOption : true,
					    filterOptionType : 'number',
					    align : 'right',
					    titleAlign : 'right',
					    renderer : function(value) {
					    	return formatCurrency(value);
					    }
					},
					{
						id: 'shortName',
						title : 'Currency',
						width: "63px",
						filterOption: true
					}
				],
				rows: []
			};
		
		tbgPdcPayments = new MyTableGrid(pdcPaymentsTableModel);
		tbgPdcPayments.pager = [];
		tbgPdcPayments.render('pdcPaymentsTable');
		tbgPdcPayments.afterRender = function(){
			tbgPdcPayments.keys.removeFocus(tbgPdcPayments.keys._nCurrentFocus, true);
			tbgPdcPayments.keys.releaseKeys();
			setDetails(null);
			if(tbgPdcPayments.geniisysRows.length > 0){
				enableToolbarButton("btnToolbarPrint");
			} else {
				disableToolbarButton("btnToolbarPrint");
			}
				
		};
		
		function showFundLOV(){
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS092FundLOV",
					searchString : $("txtFundDesc").value,
					page : 1
				},
				title : "Valid Values for Company",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "fundCd",
					title : "Code",
					width : '120px',
				}, {
					id : "fundDesc",
					title : "Description",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  $("txtFundDesc").value,
				onSelect : function(row) {
					$("txtFundDesc").value = row.fundCd + " - " + unescapeHTML2(row.fundDesc);
					objGIACS092.fundCd = row.fundCd;
					$("txtBranchName").focus();
					onLOV = false;
					enableToolbarButton("btnToolbarEnterQuery");
					disableSearch("imgSearchFund");
				},
				onCancel : function () {
					$("txtFundDesc").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtFundDesc");
					onLOV = false;
				}
			});
		}
		
		function showBranchLOV(){
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS092BranchLOV",
					searchString : $("txtBranchName").value,
					fundCd : objGIACS092.fundCd,
					page : 1
				},
				title : "Valid Values for Branch",
				width : 480,
				height : 386,
				columnModel : [ {
					id : "branchCd",
					title : "Code",
					width : '120px',
				}, {
					id : "branchName",
					title : "Description",
					width : '345px',
					renderer: function(value) {
						return unescapeHTML2(value);
					}
				} ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText:  $("txtBranchName").value,
				onSelect : function(row) {
					$("txtBranchName").value = row.branchCd + " - " + unescapeHTML2(row.branchName);
					objGIACS092.branchCd = row.branchCd;
					onLOV = false;
					enableToolbarButton("btnToolbarExecuteQuery");
					disableSearch("imgSearchBranch");
				},
				onCancel : function () {
					$("txtBranchName").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchName");
					onLOV = false;
				}
			});
		}
		
		function showORParticulars() {
			try {
			overlayORParticulars = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action : "showORParticulars",																
									ajax : "1"
					},
				    title: "Particulars",
				    height: 202,
				    width: 610,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function showMiscAmount() {
			try {
			overlayMiscAmount = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action : "showMiscAmount",																
									ajax : "1"
					},
				    title: "Miscellaneous Amount",
				    height: 112,
				    width: 480,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function showForeignCurrency() {
			try {
			overlayForeignCurrency = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action : "showForeignCurrency",																
									ajax : "1"
					},
				    title: "Foreign Currency",
				    height: 144,
				    width: 400,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function showDetails() {
			try {
			overlayDetails = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action : "showGIACS092Details",																
									ajax : "1",
									pdcId : objGIACS092.pdcId
					},
				    title: "Detail",
				    height: 400,
				    width: 700,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function showReplacement() {
			try {
			overlayReplacement = 
				Overlay.show(contextPath+"/GIACInquiryController", {
					urlContent: true,
					urlParameters: {action : "showGIACS092Replacement",																
									ajax : "1",
									pdcId : objGIACS092.pdcId
					},
				    title: "Replace",
				    height: 278,
				    width: 700,
				    draggable: true
				});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function getCheckFlag() {
			var checkFlag = "&checkFlag=";
			
			if($("rdoNew").checked)
				checkFlag = checkFlag + "N";
			else if($("rdoWithDetails").checked)
				checkFlag = checkFlag + "W"
			else if($("rdoReplaced").checked)
				checkFlag = checkFlag + "R";
			else if($("rdoCancelled").checked)
				checkFlag = checkFlag + "C";
			else if($("rdoApplied").checked)
				checkFlag = checkFlag + "A";
			
			return checkFlag;
		}
		
		function setDetails(obj) {
			if(obj != null){
				objGIACS092.pdcId = obj.pdcId;
				objGIACS092.payor = obj.payor == null ? null : unescapeHTML2(obj.payor);
				objGIACS092.address1 = obj.address1 == null ? null : unescapeHTML2(obj.address1);
				objGIACS092.address2 = obj.address2 == null ? null : unescapeHTML2(obj.address2);
				objGIACS092.address3 = obj.address3 == null ? null : unescapeHTML2(obj.address3);
				objGIACS092.tin = obj.tin == null ? null : obj.tin;
				objGIACS092.orNo = obj.orNo == null ? null : obj.orNo;
				objGIACS092.orDate = obj.orDate == null ? null : dateFormat(obj.orDate, "mm-dd-yyyy");
				objGIACS092.particulars = obj.particulars == null ? null : unescapeHTML2(obj.particulars);
				objGIACS092.jsonViewPDCPayments = [{"grossAmt":obj.grossAmt, "commissionAmt":obj.commissionAmt, "vatAmt":obj.vatAmt}];
				objGIACS092.currencyDesc = obj.currencyDesc == null ? null : unescapeHTML2(obj.currencyDesc);
				objGIACS092.currencyRt = obj.currencyRt == null ? null : obj.currencyRt;
				objGIACS092.fcurrencyAmt = obj.fcurrencyAmt == null ? null : formatCurrency(obj.fcurrencyAmt);
				
				obj.payor == null ? disableButton("btnORParticulars") : enableButton("btnORParticulars");
				obj.replaceCount == 0 ? disableButton("btnReplacement") : enableButton("btnReplacement");
				obj.detailCount == 0 ? disableButton("btnDetails") : enableButton("btnDetails");
				obj.fcurrencyAmt == null ? disableButton("btnForeignCurrency") : enableButton("btnForeignCurrency");
				if(obj.grossAmt == null && obj.commissionAmt == null && obj.vatAmt == null)
					disableButton("btnMiscAmount");
				else
					enableButton("btnMiscAmount");
			} else {
				disableButton("btnORParticulars");
				disableButton("btnMiscAmount");
				disableButton("btnForeignCurrency");
				disableButton("btnDetails");
				disableButton("btnReplacement");
			}
		}
		
		
		$("btnORParticulars").observe("click", showORParticulars);
		$("btnMiscAmount").observe("click", showMiscAmount);
		$("btnForeignCurrency").observe("click", showForeignCurrency);
		$("btnDetails").observe("click", showDetails);
		$("btnReplacement").observe("click", showReplacement);
		
		$("imgSearchFund").observe("click", function(){
			if(onLOV || objGIACS092.fundCd != null || $("txtFundDesc").readOnly)
				return;
			showFundLOV();
		});
		
		$("imgSearchBranch").observe("click", function(){
			if(onLOV || objGIACS092.branchCd != null || $("txtBranchName").readOnly)
				return;
			showBranchLOV();
		});
		
		$("txtFundDesc").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN){
				if(onLOV || objGIACS092.fundCd != null || $("txtFundDesc").readOnly)
					return;
				showFundLOV();
			} else if(event.keyCode == 0 || event.keyCode == 8){
				objGIACS092.fundCd = null;
				objGIACS092.branchCd = null;
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				if(!$("txtFundDesc").readOnly)
					$("txtBranchName").clear();
				enableSearch("imgSearchFund");
				enableSearch("imgSearchBranch");
			}
		});
		
		$("txtBranchName").observe("keypress", function(event){
			if(event.keyCode == Event.KEY_RETURN){
				if(onLOV || objGIACS092.branchCd != null || $("txtBranchName").readOnly)
					return;
				showBranchLOV();
			} else if(event.keyCode == 0 || event.keyCode == 8){
				objGIACS092.branchCd = null;
				enableToolbarButton("btnToolbarEnterQuery");
				disableToolbarButton("btnToolbarExecuteQuery");
				enableSearch("imgSearchBranch");
			} 
		});
		
		/*$("acExit").observe("click", function() {
			delete objGIACS092;
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
		});*/
		
		$("btnToolbarExit").observe("click", function() {
			delete objGIACS092;
			goToModule("/GIISUserController?action=goToAccounting", "Accounting Main", "");
			
		});
		
		function executeQuery() {
			tbgPdcPayments.url = contextPath+"/GIACInquiryController?action=showGIACS092&refresh=1"
								            + "&fundCd=" + objGIACS092.fundCd
								            + "&branchCd=" + objGIACS092.branchCd
								            + getCheckFlag();
			tbgPdcPayments._refreshList();
		}
		
		function resetForm() {
			objGIACS092 = new Object();
			disableToolbarButton("btnToolbarEnterQuery");
			disableToolbarButton("btnToolbarExecuteQuery");
			disableToolbarButton("btnToolbarPrint");
			enableSearch("imgSearchFund");
			enableSearch("imgSearchBranch");
			$("txtFundDesc").clear();
			$("txtBranchName").clear();
			$("txtFundDesc").readOnly = false;
			$("txtBranchName").readOnly = false;
			onLOV = false;
			$("rdoAll").checked = true;
			disableButton("btnORParticulars");
			disableButton("btnMiscAmount");
			disableButton("btnForeignCurrency");
			disableButton("btnDetails");
			disableButton("btnReplacement");
			tbgPdcPayments.url = contextPath+"/GIACInquiryController?action=showGIACS092&refresh=1";
			tbgPdcPayments._refreshList();
		}
		
		$("btnToolbarExecuteQuery").observe("click", function(){
			executeQuery();
			disableFields();
		});
		
		$("btnToolbarEnterQuery").observe("click", resetForm);
		
		$("btnToolbarPrint").observe("click", function(){
			showGenericPrintDialog("Print PDC Payments", function(){
				showMessageBox("The report you are trying to access is not yet available.", "I");
			}, null, true);
		});
		
		function disableFields() {
			$("txtFundDesc").readOnly = true;
			disableSearch("imgSearchFund");
			$("txtBranchName").readOnly = true;
			disableSearch("imgSearchBranch");
			disableToolbarButton("btnToolbarExecuteQuery");
		}
		
		$("rdoAll").observe("click", function(){
			if($("txtFundDesc").readOnly)
				executeQuery();
		});
		
		$("rdoNew").observe("click", function(){
			if($("txtFundDesc").readOnly)
				executeQuery();
		});
		
		$("rdoWithDetails").observe("click", function(){
			if($("txtFundDesc").readOnly)
				executeQuery();
		});
		
		$("rdoReplaced").observe("click", function(){
			if($("txtFundDesc").readOnly)
				executeQuery();
		});
		
		$("rdoCancelled").observe("click", function(){
			if($("txtFundDesc").readOnly)
				executeQuery();
		});
		
		$("rdoApplied").observe("click", function(){
			if($("txtFundDesc").readOnly)
				executeQuery();
		});
		
		initGIACS092();
		initializeAll();
		
	} catch(e) {
		showErrorMessage("Error : " , e);
	}
</script>