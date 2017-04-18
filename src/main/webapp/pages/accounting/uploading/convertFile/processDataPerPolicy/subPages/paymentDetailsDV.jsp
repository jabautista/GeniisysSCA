<div id="paymentDetailsDVDiv" style="width: 99%; margin-top: 5px;">
	<div class="sectionDiv">
		<table align="center" style="margin-top: 20px; margin-bottom: 20px;">
			<tr>
				<td>
					<label for="txtDocCd">Request No.</label>
				</td>
				<td>
					<span class="lovSpan required" style="width: 80px; margin-bottom: 0;">
						<input type="text" id="txtDocCd" ignoreDelKey="true" name="txtDocCd" style="width: 50px; float: left;" class="withIcon allCaps required"  maxlength="5"  tabindex="1001"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnDocCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<span class="lovSpan required" style="width: 80px; margin-bottom: 0;">
						<input type="text" id="txtBranchCd" ignoreDelKey="true" name="txtBranchCd" style="width: 50px; float: left;" class="withIcon allCaps required"  maxlength="2"  tabindex="1002"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnBranchCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<span class="lovSpan " style="width: 80px; margin-bottom: 0;" id="lineCdSpan">
						<input type="text" id="txtLineCd" ignoreDelKey="true" name="txtLineCd" style="width: 50px; float: left;" class="withIcon allCaps "  maxlength="2"  tabindex="1003"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnLineCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtDocYear" ignoreDelKey="true" name="txtDocYear" style="width: 50px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="4"  tabindex="1004" readonly="readonly"/>  
				</td>
				<td>
					<input type="text" id="txtDocMm" ignoreDelKey="true" name="txtDocMm" style="width: 50px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="2"  tabindex="1005" readonly="readonly"/>  
				</td>
				<td>
					<input type="text" id="txtDocSeqNo" ignoreDelKey="true" name="txtDocSeqNo" style="width: 50px; float: left; height: 14px;" class="integerNoNegativeUnformattedNoComma rightAligned"  maxlength="7"  tabindex="1006" readonly="readonly"/>  
				</td>
				<td>
					<label for="txtRequestDate" style="width: 100px;" class= "rightAligned">Date</label>
				</td>
				<td class="leftAligned">
					<div style="float: left; width: 165px;" class="withIconDiv required">
						<input type="text" id="txtRequestDate" name="txtRequestDate" class="withIcon date required" readonly="readonly" style="width: 140px;" tabindex="1007"/>
						<img id="btnRequestDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Request Date" tabindex="107"/>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<label for="txtDeptCd">Department</label>
				</td>
				<td>
					<span class="lovSpan required" style="width: 80px; margin-bottom: 0;">
						<input type="text" id="txtDeptCd" ignoreDelKey="true" name="txtDeptCd" style="width: 50px; float: left;" class="withIcon allCaps required rightAligned"  maxlength="4"  tabindex="1008"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnDeptCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td colspan="6">
					<input type="text" id="txtDeptName" ignoreDelKey="true" name="txtDeptName" style="width: 340px; float: left; height: 14px;" readonly="readonly" tabindex="1009"/>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<table align="center" style="margin-top: 20px;">
			<tr>
				<td>
					<label for="txtPayeeClassCd" style="float: right;">Payee</label>
				</td>
				<td>
					<span class="lovSpan required" style="width: 50px; margin-bottom: 0;">
						<input type="text" id="txtPayeeClassCd" ignoreDelKey="true" name="txtPayeeClassCd" style="width: 25px; float: left;" class="withIcon allCaps required rightAligned"  maxlength="2"  tabindex="1011"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnPayeeClassCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<span class="lovSpan required" style="width: 110px; margin-bottom: 0;">
						<input type="text" id="txtPayeeCd" ignoreDelKey="true" name="txtPayeeCd" style="width: 85px; float: left;" class="withIcon allCaps required rightAligned"  maxlength="12"  tabindex="1012"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnPayeeCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td colspan="3">
					<input type="text" id="txtPayee" ignoreDelKey="true" name="txtPayee" style="width: 365px; float: left; height: 14px;" readonly="readonly" tabindex="1013"/>
				</td>
			</tr>
			<tr>
				<td>
					<label for="txtParticulars">Particulars</label>
				</td>
				<td colspan="5">
					<div id="particularsDiv" name="particularsDiv" style="float: left; width: 539px; border: 1px solid gray; height: 66px;" class="required">
						<textarea class="required" style="float: left; height: 60px; width: 513px; margin-top: 0; border: none;" id="txtParticulars" name="txtParticulars" maxlength="2000"  onkeyup="limitText(this,2000);" tabindex="1014"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars"/>
					</div>
				</td>
			</tr>
		</table>
		<table style="margin-left:84px;">
			<tr>
				<td>
					<label for="txtFCurrencyCd" style="float: right;">Amount</label>
				</td>
				<td>
					<span class="lovSpan required" style="width: 60px; margin-bottom: 0;">
						<input type="text" id="txtFCurrencyCd" ignoreDelKey="true" name="txtFCurrencyCd" style="width: 30px; float: left;" class="withIcon allCaps required"  maxlength="5"  tabindex="1015"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="btnFCurrencyCd" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtFCurrencyAmt" ignoreDelKey="true" name="txtFCurrencyAmt" style="width: 150px; float: left; height: 14px;" tabindex="1016" class="rightAligned applyDecimalRegExp2" maxlength="" regExpPatt="nDeci1602" min="-99999999999999.99" max="99999999999999.99" customLabel="Amount" readonly="readonly"/>
				</td>
				<td width="96px">
					<label for="txtLocalAmtCd" style="float: right;">Local Amount</label>
				</td>
				<td>
					<input type="text" id="txtLocalAmtCd" ignoreDelKey="true" name="txtLocalAmtCd" style="width: 50px; float: left; height: 14px;" readonly="readonly" tabindex="1017"/>
				</td>
				<td>
					<input type="text" id="txtLocalAmt" ignoreDelKey="true" name="txtLocalAmt" style="width: 150px; float: left; height: 14px;" readonly="readonly" tabindex="1018" class="rightAligned"/>
				</td>
			</tr>
			<tr>
				<td>
					<label for="txtConversionRate" style="float: right;">Conversion Rate</label>
				</td>
				<td colspan="2">
					<input type="text" id="txtConversionRate" ignoreDelKey="true" name="txtConversionRate" style="width: 214px; float: right; height: 14px;" readonly="readonly" tabindex="1019" class="rightAligned"/>
				</td>
			</tr>
		</table>
	</div>
</div>
<center>
	<input type="button" class="button" value="Return" id="btnReturn" style="margin-top: 5px; width: 100px;" />
	<input type="button" class="button" value="Save" id="btnSave" style="margin-top: 5px; width: 100px;" />
	<input type="button" class="button" value="Delete" id="btnDelete" style="margin-top: 5px; width: 100px;" />
</center>
<script type="text/javascript">
	initializeAll();
	initializeAccordion();
	objectDv = JSON.parse('${showGiacUploadDvPaytDtl}'); //nieko Accounting Uploading, replace object to objectDv, to avoid conflict on previous module
	
	changeTag = 0;
	deleteRows = 0;
	var objCheckTags = {};
	
	objCheckTags.fileNo = objectDv.fileNo == null ? "" : unescapeHTML2(objectDv.fileNo);
	objCheckTags.sourceCd = objectDv.sourceCd == null ? "" : unescapeHTML2(objectDv.sourceCd);
	objCheckTags.oucId = objectDv.goucOucId == null ? "" : objectDv.goucOucId;
	objCheckTags.mainCurrencyCd = objectDv.currencyCd == null ? "" : objectDv.currencyCd;
	$("txtDocCd").value = objectDv.documentCd == null ? "" : unescapeHTML2(objectDv.documentCd);
	$("txtBranchCd").value = objectDv.branchCd == null ? "" : unescapeHTML2(objectDv.branchCd);
	$("txtLineCd").value = objectDv.lineCd == null ? "" : unescapeHTML2(objectDv.lineCd);
	$("txtDocYear").value = objectDv.docYear == null ? "" : objectDv.docYear;
	$("txtDocMm").value = objectDv.docMm == null ? "" : lpad(objectDv.docMm,2,0);
	$("txtDocSeqNo").value = objectDv.docSeqNo == null ? "" : lpad(objectDv.docSeqNo,2,0);
	$("txtRequestDate").value = objectDv.requestDate == null ? "" : dateFormat(objectDv.requestDate, "mm-dd-yyyy");
	$("txtDeptCd").value = objectDv.dspDeptCd == null ? "" : objectDv.dspDeptCd;
	$("txtDeptName").value = objectDv.dspOucName == null ? "" : unescapeHTML2(objectDv.dspOucName);
	$("txtPayeeClassCd").value = objectDv.payeeClassCd == null ? "" : objectDv.payeeClassCd;
	$("txtPayeeCd").value = objectDv.payeeCd == null ? "" : lpad(objectDv.payeeCd,12,0);
	$("txtPayee").value = objectDv.payee == null ? "" : unescapeHTML2(objectDv.payee);
	$("txtParticulars").value = objectDv.particulars == null ? "" : unescapeHTML2(objectDv.particulars);
	$("txtFCurrencyCd").value = objectDv.dspFshortName == null ? "" : unescapeHTML2(objectDv.dspFshortName);
	$("txtFCurrencyAmt").value = objectDv.dvFcurrencyAmt == null ? "" : formatCurrency(objectDv.dvFcurrencyAmt);
	$("txtLocalAmtCd").value = objectDv.dspShortName == null ? "" : unescapeHTML2(objectDv.dspShortName);
	$("txtLocalAmt").value = objectDv.paytAmt == null ? "" : formatCurrency(objectDv.paytAmt);
	$("txtConversionRate").value = objectDv.currencyRt == null ? "" : formatToNthDecimal(objectDv.currencyRt,9);
	
	if(objectDv.lineCdTag == "Y"){
		$("txtLineCd").readOnly = false;
		$("lineCdSpan").addClassName("required");
		$("txtLineCd").addClassName("required");
		enableSearch("btnLineCd");
	} else {
		$("txtLineCd").readOnly = true;
		$("txtLineCd").removeClassName("required");
		$("lineCdSpan").removeClassName("required");
		disableSearch("btnLineCd");
		$("txtLineCd").value = "";
	}
	
	if(nvl(objectDv.vExists, "Y") == "Y"){
		$("txtDocCd").readOnly = true;
		disableSearch("btnDocCd");
		$("txtBranchCd").readOnly = true;
		disableSearch("btnBranchCd");
		$("txtDeptCd").readOnly = true;
		disableSearch("btnDeptCd");
		disableDate("btnRequestDate");
		
		//nieko Accounting Uploading
		 $("txtPayeeClassCd").readOnly = true;
		 disableSearch("btnPayeeClassCd");
		 $("txtPayeeCd").readOnly = true;
		 disableSearch("btnPayeeCd");
		 $("txtParticulars").readOnly = true;
		 $("txtFCurrencyCd").readOnly = true;
		 disableSearch("btnFCurrencyCd");
	} else {
		$("txtDocCd").readOnly = false;
		enableSearch("btnDocCd");
		$("txtBranchCd").readOnly = false;
		enableSearch("btnBranchCd");
		$("txtDeptCd").readOnly = false;
		enableSearch("btnDeptCd");
		enableDate("btnRequestDate");
		
		//nieko Accounting Uploading
		 $("txtPayeeClassCd").readOnly = false;
		 enableSearch("btnPayeeClassCd");
		 $("txtPayeeCd").readOnly = false;
		 enableSearch("btnPayeeCd");
		 $("txtParticulars").readOnly = false;
		 $("txtFCurrencyCd").readOnly = false;
		 enableSearch("btnFCurrencyCd");
		
		if(nvl(objectDv.yyTag,"Y") != "Y"){
			$("txtDocYear").readOnly = true;
			$("txtDocYear").value = "";
		}
		
		if(nvl(objectDv.mmTag,"Y") != "Y"){
			$("txtDocMm").readOnly = true;
			$("txtDocMm").value = "";
		}
	}
	
	//nieko Accounting Uploading
	if (objGIACS603.fileStatus == "C" || objGIACS603.fileStatus != 1){
		disableButton("btnSave");
		disableButton("btnDelete");
	}else{
		enableButton("btnSave");
		enableButton("btnDelete");
	}
	
	$("btnReturn").observe("click", function(){
		if (changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES,
					"Yes", "No", "Cancel", function() {
						fireEvent($("btnSave"), "click");
					}, function() {
						closeOverlay();
					}, "");
		} else {
			closeOverlay();
		}
	});
	
	function showDocumentCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetDocCd",
					  branchCd: $F("txtBranchCd"),
					  filterText: nvl($F("txtDocCd"), "%"),  
						page : 1
				},
				title: "List of Document Cd",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'documentCd',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'dspDocumentName',
						title: 'Document Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtDocCd").value = unescapeHTML2(row.documentCd);
						objCheckTags.dspYyTag = row.dspYyTag;
						objCheckTags.dspMmTag = row.dspMmTag;
						objCheckTags.dspLineCdTag = row.dspLineCdTag;
						
						changeTag = unescapeHTML2(objectDv.documentCd) == $F("txtDocCd") ? 0 : 1;
						
						if(row.dspLineCdTag == "Y"){
							$("txtLineCd").readOnly = false;
							$("lineCdSpan").addClassName("required");
							$("txtLineCd").addClassName("required");
							enableSearch("btnLineCd");
						} else {
							$("txtLineCd").readOnly = true;
							$("txtLineCd").removeClassName("required");
							$("lineCdSpan").removeClassName("required");
							disableSearch("btnLineCd");
							$("txtLineCd").value = "";
						}
						
						if($F("txtRequestDate") != ""){
							if(row.dspYyTag == "Y"){
								$("txtDocYear").value = dateFormat($F("txtRequestDate"), "yyyy");
							} else {
								$("txtDocYear").readOnly = true;
								$("txtDocYear").value = "";
							}
							
							if(row.dspMmTag == "Y"){
								$("txtDocMm").value = dateFormat($F("txtRequestDate"), "mm");
							} else {
								$("txtDocMm").readOnly = true;
								$("txtDocMm").value = "";
							}
						}
					}
				},
				filterText: nvl(escapeHTML2($("txtDocCd").value), "%"), 
				onCancel: function(){
					$("txtDocCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtDocCd").value = "";
		  			objCheckTags.dspYyTag = "";
					objCheckTags.dspMmTag = "";
					objCheckTags.dspLineCdTag = "";
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDocCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showDocumentCdLOV",e);
		}
	}
	
	function showBranchCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetBranchCdLOV",
					  moduleId : "GIACS016",
					  filterText: nvl($F("txtBranchCd"), "%"),  
						page : 1
				},
				title: "List of Branch Cd",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'branchCd',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'branchName',
						title: 'Branch Name',
					    width: '335px',
					    align: 'left'
					}
				],
				filterText: nvl($F("txtBranchCd"), "%"),  
				autoSelectOneRecord : true,
				draggable: true,
				onSelect: function(row) {
					if(row != undefined){
						$("txtBranchCd").value = unescapeHTML2(row.branchCd);
						
						changeTag = unescapeHTML2(objectDv.branchCd) == $F("txtBranchCd") ? 0 : 1;
					}
				},
				onCancel: function(){
					$("txtBranchCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtBranchCd").value = "";
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showBranchCdLOV",e);
		}
	}
	
	function showLineCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetLineCdLOV",
					  filterText: nvl($F("txtLineCd"), "%"),  
						page : 1
				},
				title: "List of Line",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'lineCd',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'lineName',
						title: 'Line Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				filterText: nvl($F("txtLineCd"), "%"),  
				onSelect: function(row) {
					if(row != undefined){
						$("txtLineCd").value = unescapeHTML2(row.lineCd);
						changeTag = unescapeHTML2(objectDv.lineCd) == $F("txtLineCd") ? 0 : 1;
					}
				},
				onCancel: function(){
					$("txtLineCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtLineCd").value = "";
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showLineCdLOV",e);
		}
	}
	
	function showDeptCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetDeptCdLOV",
					  branchCd: $F("txtBranchCd"),
					  filterText: nvl($F("txtDeptCd"), "%"),  
						page : 1
				},
				title: "List of Dept",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'oucCd',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'oucName',
						title: 'Line Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				filterText: nvl($F("txtDeptCd"), "%"),  
				onSelect: function(row) {
					if(row != undefined){
						$("txtDeptCd").value = unescapeHTML2(row.oucCd);
						$("txtDeptName").value = unescapeHTML2(row.oucName);
						objCheckTags.oucId = row.oucId;
						
						changeTag = unescapeHTML2(objectDv.oucCd) == $F("txtDeptCd") ? 0 : 1;
						
						if($F("txtDeptCd") != "" && $F("txtRequestDate") == ""){
							$("txtRequestDate").value = dateFormat(new Date(), "mm-dd-yyyy");
						}
						
						if($F("txtRequestDate") != ""){
							if(objCheckTags.dspYyTag == "Y"){
								$("txtDocYear").value = dateFormat($F("txtRequestDate"), "yyyy");
							} else {
								$("txtDocYear").readOnly = true;
								$("txtDocYear").value = "";
							}
							
							if(objCheckTags.dspMmTag == "Y"){
								$("txtDocMm").value = dateFormat($F("txtRequestDate"), "mm");
							} else {
								$("txtDocMm").readOnly = true;
								$("txtDocMm").value = "";
							}
						}
					}
				},
				onCancel: function(){
					$("txtDeptCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtDeptCd").value = "";
		  			$("txtDeptName").value = "";
		  			objCheckTags.oucId = "";
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDeptCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showDeptCdLOV",e);
		}
	}
	
	function showPayeeClassCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetPayeeClassCdLOV",
					  filterText: nvl($F("txtPayeeClassCd"), "%"),  
						page : 1
				},
				title: "List of Payee Class",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'payeeClassCd',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'classDesc',
						title: 'Line Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				filterText: nvl($F("txtPayeeClassCd"), "%"),  
				onSelect: function(row) {
					if(row != undefined){
						$("txtPayeeClassCd").value = unescapeHTML2(row.payeeClassCd);
						changeTag = unescapeHTML2(objectDv.payeeClassCd) == $F("txtPayeeClassCd") ? 0 : 1;
					}
				},
				onCancel: function(){
					$("txtPayeeClassCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtPayeeClassCd").value = "";
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPayeeClassCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showPayeeClassCdLOV",e);
		}
	}
	
	function showPayeeCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetPayeeCdLOV",
					  payeeClassCd: $F("txtPayeeClassCd"),
					  filterText: nvl($F("txtPayeeCd"), "%"),  
						page : 1
				},
				title: "List of Payee",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'payeeNo',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'payeeLastName',
						title: 'Last Name',
					    width: '100px',
					    align: 'left'
					},
					{
						id : 'payeeFirstName',
						title: 'First Name',
					    width: '100px',
					    align: 'left'
					},
					{
						id : 'payeeMiddleName',
						title: 'Middle Name',
					    width: '100px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				filterText: nvl($F("txtPayeeCd"), "%"),  
				onSelect: function(row) {
					if(row != undefined){
						$("txtPayeeCd").value = lpad(row.payeeNo,12,0);
						changeTag = lpad(objectDv.payeeClassCd,12,0) == $F("txtPayeeCd") ? 0 : 1;
						if(row.payeeFirstName == ""){
							$("txtPayee").value = unescapeHTML2(row.payeeLastName);
						} else {
							$("txtPayee").value = rtrim(unescapeHTML2(row.payeeFirstName)) + " " + rtrim(unescapeHTML2(row.payeeMiddleName)) + " " + rtrim(unescapeHTML2(row.payeeLastName));
						}						
					}
				},
				onCancel: function(){
					$("txtPayeeCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtPayeeCd").value = "";
		  			$("txtPayee").value = "";
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPayeeCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showPayeeCdLOV",e);
		}
	}
	
	function showCurrencyCdLOV(){
		try{
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					  action : "uploadingGetCurrencyCdLOV",
					  filterText: nvl($F("txtFCurrencyCd"), "%"),  
						page : 1
				},
				title: "List of Currency",
				width: 470,
				height: 400,
				columnModel: [
		 			{
						id : 'shortName',
						title: 'Code',
						width : '100px',
						align: 'right',
						titleAlign : 'right'
					},
					{
						id : 'currencyDesc',
						title: 'Line Name',
					    width: '335px',
					    align: 'left'
					}
				],
				autoSelectOneRecord : true,
				draggable: true,
				filterText: nvl($F("txtFCurrencyCd"), "%"),  
				onSelect: function(row) {
					if(row != undefined){
						$("txtFCurrencyCd").value = unescapeHTML2(row.shortName);
						$("txtConversionRate").value = formatToNthDecimal(row.currencyRt,9);
						objCheckTags.mainCurrencyCd = row.mainCurrencyCd;
						
						changeTag = objectDv.currencyCd == row.mainCurrencyCd ? 0 : 1;
						if($F("txtFCurrencyCd") == ""){
							$("txtFCurrencyAmt").readOnly = true;
						} else {
							$("txtFCurrencyAmt").readOnly = false;
							computeLocalAmt();
						}
					}
				},
				onCancel: function(){
					$("txtFCurrencyCd").focus();
		  		},
		  		onUndefinedRow: function(){
		  			$("txtFCurrencyCd").value = "";
		  			objCheckTags.mainCurrencyCd = "";
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtPayeeClassCd");
		  		}
			});
		}catch(e){
			showErrorMessage("showPayeeClassCdLOV",e);
		}
	}
	
	$("btnDocCd").observe("click", showDocumentCdLOV);
	$("btnBranchCd").observe("click", showBranchCdLOV);
	$("btnLineCd").observe("click", showLineCdLOV);
	$("btnDeptCd").observe("click", showDeptCdLOV);
	$("btnPayeeClassCd").observe("click", showPayeeClassCdLOV);
	$("btnPayeeCd").observe("click", showPayeeCdLOV);
	$("btnFCurrencyCd").observe("click", showCurrencyCdLOV);
	
	$("btnRequestDate").observe("click", function() { 
		scwNextAction = validateRequestDate.runsAfterSCW(this, null); 

		scwShow($("txtRequestDate"),this, null); 
	});
	
	function validateRequestDate(){
		if($F("txtRequestDate") != ""){
			if (compareDatesIgnoreTime(Date.parse($F("txtRequestDate"), 'mm-dd-yyyy'), new Date()) == -1){
				showMessageBox("Please note that this is a future date.", imgMessage.INFO);
			} else if (compareDatesIgnoreTime(Date.parse($F("txtRequestDate"), 'mm-dd-yyyy'), new Date()) == 1){
				showMessageBox("Please note that this is a previous date.", imgMessage.INFO);
			}
			
			if(objCheckTags.dspYyTag == "Y"){
				$("txtDocYear").value = dateFormat($F("txtRequestDate"), "yyyy");
			} else {
				$("txtDocYear").readOnly = true;
				$("txtDocYear").value = "";
			}
			
			if(objCheckTags.dspMmTag == "Y"){
				$("txtDocMm").value = dateFormat($F("txtRequestDate"), "mm");
			} else {
				$("txtDocMm").readOnly = true;
				$("txtDocMm").value = "";
			}
		} else {
			$("txtDocYear").value = "";
			$("txtDocMm").value = "";
		}
	}
	
	$("txtRequestDate").observe("keyup", function(event){
		if(event.keyCode == 46){
			$("txtDocYear").value = "";
			$("txtDocMm").value = "";
		}
	});
	
	function computeLocalAmt(){
		$("txtLocalAmt").value = formatCurrency($F("txtFCurrencyAmt") * $F("txtConversionRate"));
	}
	
	function saveGiacs603DV(){
		var setRows = setRecordToSave();
		new Ajax.Request(contextPath+"/GIACUploadingController", {
			method: "POST",
			parameters : {action : "saveGiacs603DVPaytDtl",
					 	  setRows : prepareJsonAsParameter(setRows),
					 	  },
			onCreate : showNotice("Processing, please wait..."),
			onComplete: function(response){
				hideNotice();
				if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
					changeTagFunc = "";
					showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
						closeOverlay();
					});
					changeTag = 0;
				}
			}
		});
	}
	
	function setRecordToSave(){
		try {
			var tempObjArray = new Array();
			var obj = (objectDv == null ? {} : objectDv);
			obj.sourceCd		= objCheckTags.sourceCd;
			obj.fileNo			= objCheckTags.fileNo;
			obj.documentCd 		= escapeHTML2($F("txtDocCd"));
			obj.branchCd		= escapeHTML2($F("txtBranchCd"));
			obj.lineCd   	   	= escapeHTML2($F("txtLineCd"));
			obj.docYear        	= $F("txtDocYear");
			obj.docMm          	= $F("txtDocMm");
			obj.docSeqNo     	= $F("txtDocSeqNo");
			obj.goucOucId     	= $F("txtDeptCd") == "" ? "" : objCheckTags.oucId;
			obj.requestDate    	= $F("txtRequestDate");
			obj.payeeClassCd  	= $F("txtPayeeClassCd");
			obj.payeeCd        	= $F("txtPayeeCd");
			obj.payee           = escapeHTML2($F("txtPayee"));
			obj.particulars     = escapeHTML2($F("txtParticulars"));
			obj.dvFcurrencyAmt	= $F("txtFCurrencyAmt").replace(/,/g, "");
			obj.currencyRt     	= $F("txtConversionRate");
			obj.paytAmt        	= $F("txtLocalAmt").replace(/,/g, "");
			obj.currencyCd     	= $F("txtFCurrencyCd") == "" ? "" : objCheckTags.mainCurrencyCd;
			
			tempObjArray.push(obj);
			
			return tempObjArray;
		} catch(e){
			showErrorMessage("setRecordToSave", e);
		}
	}
	
	
	$("btnSave").observe("click", function(){
		if(changeTag == 0) {
			showMessageBox(objCommonMessage.NO_CHANGES, "I");
			return;
		}
		
		if (deleteRows == 1){
			new Ajax.Request(contextPath+"/GIACUploadingController", {
				method: "POST",
				parameters : {action : "delGiacs603DVPaytDtl",
							 sourceCd : objCheckTags.sourceCd,
							 fileNo : objCheckTags.fileNo
						 	  },
				asynchronous: true,
				onCreate : showNotice("Processing, please wait..."),
				onComplete: function(response){
					hideNotice();
					if(checkCustomErrorOnResponse(response) && checkErrorOnResponse(response)){
						changeTagFunc = "";
						var isComplete = true;
						$$("div#paymentDetailsDVDiv input[type='text'].required, div#paymentDetailsDVDiv textarea.required, div#paymentDetailsDVDiv select.required, div#paymentDetailsDVDiv input[type='file'].required").each(function (o) {
							if (o.value.blank()){
								isComplete = false;
							}
						});
						
						if (isComplete){
							saveGiacs603DV();
						} else {
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								overlayPaymentDetails.close();
								delete overlayPaymentDetails;
							});
						}
					} 
				}
			});
		} else {
			if(checkAllRequiredFieldsInDiv("paymentDetailsDVDiv")){
				saveGiacs603DV();
			}
		}
	});
	
	//observe fields for changeTag
	$("txtDocCd").observe("change", function(){
		if($F("txtDocCd") != ""){
			showDocumentCdLOV();
		}
		changeTag = unescapeHTML2(objectDv.documentCd) == $F("txtDocCd") ? 0 : 1;
	});
	
	$("txtBranchCd").observe("change", function(){
		if($F("txtBranchCd") != ""){
			showBranchCdLOV();
		} else {
			
		}
		changeTag = unescapeHTML2(objectDv.branchCd) == $F("txtBranchCd") ? 0 : 1;
		$("txtDocCd").value = "";
	});
	
	$("txtLineCd").observe("change", function(){
		if($F("txtLineCd") != ""){
			showLineCdLOV();
		}
		changeTag = unescapeHTML2(objectDv.lineCd) == $F("txtLineCd") ? 0 : 1;
	});
	
	$("txtParticulars").observe("change", function(){
		changeTag = unescapeHTML2(objectDv.particulars) == $F("txtParticulars") ? 0 : 1;
	});
	
	$("txtDeptCd").observe("change", function(event){
		if($F("txtDeptCd") == ""){
			$("txtDeptName").value = "";
		} else {
			showDeptCdLOV();
		}
		
		changeTag = objectDv.goucOucId == objCheckTags.oucId ? 0 : 1;
	});
	
	$("txtPayeeClassCd").observe("change", function(event){
		if($F("txtPayeeClassCd") == ""){
			$("txtPayeeCd").value = "";
			$("txtPayee").value = "";
		} else {
			showPayeeClassCdLOV();
		}
		
		changeTag = objectDv.payeeClassCd == $F("txtPayeeClassCd") ? 0 : 1;
	});
	
	$("txtPayeeCd").observe("change", function(event){
		if($F("txtPayeeCd") == ""){
			$("txtPayee").value = "";
		} else {
			showPayeeCdLOV();
		}
		
		changeTag = objectDv.payeeCd == $F("txtPayeeCd") ? 0 : 1;
	});
	
	$("txtFCurrencyCd").observe("change", function(event){
		if($F("txtFCurrencyCd") == ""){
			$("txtFCurrencyAmt").readOnly = true;
			$("txtLocalAmt").value = "";
			$("txtConversionRate").value = "";
		} else {
			$("txtFCurrencyAmt").readOnly = false;
			showCurrencyCdLOV();
		}
		
		changeTag = unescapeHTML2(objectDv.currencyCd) == $F("txtFCurrencyCd") ? 0 : 1;
	});
	
	$("txtFCurrencyAmt").observe("change", function(event){
		if($F("txtFCurrencyAmt") == ""){
			$("txtLocalAmt").value = "";
			$("txtConversionRate").value = "";
		} else {
			computeLocalAmt();
		}
		
		changeTag = formatCurrency(objectDv.dvFcurrencyAmt) == $F("txtFCurrencyCd") ? 0 : 1;
	});
	
	$("btnDelete").observe("click", function(){
		$$("div#paymentDetailsDVDiv input[type='text'], div#paymentDetailsDVDiv textarea").each(function(a) {
			if(a.id != "txtBranchCd" && a.id != "txtLocalAmtCd"){
				a.value = "";
			}
		}); 
		
		deleteRows = 1;
		changeTag = 1;
		enableInsert();
	});
	
	function enableInsert(){
		$("txtDocCd").readOnly = false;
		enableSearch("btnDocCd");
		$("txtBranchCd").readOnly = false;
		enableSearch("btnBranchCd");
		$("txtDeptCd").readOnly = false;
		enableSearch("btnDeptCd");
		enableDate("btnRequestDate");
	}
	
	function closeOverlay(){
		overlayPaymentDetails.close();
		delete overlayPaymentDetails;
	}
	
	$("editParticulars").observe("click", function(){
		showOverlayEditor("txtParticulars", 2000, $("txtParticulars").hasAttribute("readonly"), function(){
			changeTag = 1;
		});
	});
	
</script>