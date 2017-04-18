<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>


<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
   		<label>Copy Payment Request</label>
   	</div>
</div>
<div class="sectionDiv" style="text-align: center;">
	<div class="sectionDiv" id="copyPaymentRequestMainDiv" style="width: 700px; height: 200px; margin: 100px; margin-bottom: 40px;">
		<table align="center" border="0" style="margin-top: 50px;" >
			<tr>
				<td class="rightAligned">
					Copy From
				</td>
				<td style="text-align: left;">
					<span class="lovSpan required" style="width: 86px; margin-bottom: 0;">
						<input type="text" id="txtDocumentCdFrom" style="width: 61px; float: left;" class="withIcon allCaps required"  maxlength="5"  tabindex="101"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDocumentCdFrom" alt="Go" style="float: right;" />
					</span>
				</td>
				<td style="text-align: left;">
					<span class="lovSpan required" style="width: 51px; margin-bottom: 0;">
						<input type="text" id="txtBranchCdFrom" style="width: 26px; float: left;" class="withIcon allCaps required"  maxlength="2"  tabindex="102"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdFrom" alt="Go" style="float: right;" />
					</span>
				</td>
				<td style="text-align: left;">
					<span id="lineCdFromSpan" class="lovSpan" style="width: 51px; margin-bottom: 0;">
						<input type="text" id="txtLineCdFrom" style="width: 26px; float: left;" class="withIcon allCaps"  maxlength="2"  tabindex="103"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgLineCdFrom" alt="Go" style="float: right;" />
					</span>
				</td>
				<td style="text-align: left;">
					<span class="lovSpan required" style="width: 56px; margin-bottom: 0;">
						<input type="text" id="txtDocYearFrom" style="width: 31px; float: left; " class="withIcon required integerNoNegativeUnformattedNoComma"  maxlength="4"  tabindex="104"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDocYearFrom" alt="Go" style="float: right;" />
					</span>
				</td>
				<td>
					<input type="text" id="txtDocMmFrom" class="required integerNoNegativeUnformattedNoComma" style="width: 45px; margin: 0; text-align: right; height: 14px;" maxlength="2" tabindex="105"/>
				</td>
				<td style="text-align: left;">
					<span class="lovSpan required" style="width: 96px; margin-bottom: 0;">
						<input type="text" id="txtDocSeqNoFrom" style="width: 71px; float: left; text-align: right;" class="withIcon integerNoNegativeUnformattedNoComma required"  maxlength="6"  tabindex="106"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgDocSeqNoFrom" alt="Go" style="float: right;" />
					</span>
				</td>
			</tr>
			
			
			<tr>
				<td class="rightAligned">
					Copy To
				</td>
				<td>
					<input type="text" id="txtDocumentCdTo" style="width: 80px; margin: 0; height: 14px;" readonly="readonly" tabindex="107"/>
				</td>
				<td style="text-align: left;">
					<span class="lovSpan required" style="width: 51px; margin-bottom: 0;">
						<input type="text" id="txtBranchCdTo" style="width: 26px; float: left;" class="withIcon allCaps required"  maxlength="2"  tabindex="108" readonly="readonly"/>  
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="imgBranchCdTo" alt="Go" style="float: right;" />
					</span>
				</td>	
				<td>
					<input type="text" id="txtLineCdTo" style="width: 45px; margin: 0; height: 14px;" readonly="readonly" tabindex="109"/>
				</td>	
				<td>
					<input type="text" id="txtDocYearTo" style="width: 50px; margin: 0; height: 14px;" readonly="readonly" tabindex="110"/>
				</td>
				<td>
					<input type="text" id="txtDocMmTo" style="width: 45px; margin: 0; text-align: right; height: 14px;" readonly="readonly" tabindex="111"/>
				</td>
				<td>
					<input type="text" id="txtDocSeqNoTo" style="width: 90px; margin: 0; height: 14px;" readonly="readonly" tabindex="112"/>
				</td>	
			</tr>
			<tr>
				<td class="rightAligned">
					Tran Date
				</td>
				<td colspan="3">
					<div style="float: left; width: 143px; height: 20px; margin: 0;" class="withIconDiv">
						<input type="text" removeStyle="true" id="txtTranDateFrom" class="withIcon" readonly="readonly" style="width: 119px;" tabindex="113"/>
						<img id="imgTranDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" style="margin : 1px 1px 0 0; cursor: pointer"/>
					</div>
				</td>
			</tr>
			<tr>
				<td></td>
				<td colspan="3">
					<div style="margin: 10px 0 0 0;">
						<input type="checkbox" id="chkAcctgEntries" checked="checked" style="float: left;"/>
						<label for="chkAcctgEntries">Include Acctg Entries</label>
					</div>
				</td>
			</tr>
		</table>
	</div>
	<div style="margin-bottom: 50px;">
		<input type="button" class="disabledButton" value="Copy" id="btnCopy" style="width: 120px;" />
	</div>
</div>
<script type="text/javascript" >
	try {
		
		var onLOV = false;
		var checkDocumentCd = '';
		var checkBranchCd = '';
		var checkLineCd = '';
		var checkDocYear = '';
		var checkDocSeqNo = '';
		var checkBranchCd2 = '';
		var validateTag = false;
		
		$("imgBranchCdTo").hide(); //as per ma'am roset for sr 1242 (UCPB Phase 3)
		
		function initGIACS045() {
			onLOV = false;
			checkDocumentCd = '';
			setModuleId("GIACS045");
			setDocumentTitle("Facility to Copy Payment Request");
			$("acExit").show();
			objGIACS045 = new Object();
			$("txtDocumentCdFrom").focus();
			$('txtBranchCdFrom').readOnly = true;
			$('txtLineCdFrom').readOnly = true;
			$('txtDocYearFrom').readOnly = true;
			$('txtDocMmFrom').readOnly = true;
			$('txtDocSeqNoFrom').readOnly = true;
			disableSearch('imgBranchCdFrom');
			disableSearch('imgLineCdFrom');
			disableSearch('imgDocYearFrom');
			disableSearch('imgDocSeqNoFrom');
			disableDate('imgTranDate');
		}
		
		function showDocumentCdLov(){
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS045DocumentCdLov",
					searchString : checkDocumentCd == '' ? $("txtDocumentCdFrom").value : '',
					page : 1
				},
				title : "Document Cd",
				width : 380,
				height : 386,
				columnModel : [ {
					id : "documentCd",
					title : "Document Code",
					width : '367px',
				}],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: checkDocumentCd == '' ? $("txtDocumentCdFrom").value : '',
				onSelect : function(row) {
					
					if($("txtDocumentCdFrom").value != row.documentCd){
						$('txtLineCdFrom').enable();
						$('lineCdFromSpan').setStyle({background : 'white'});
						$('txtDocumentCdTo').clear();
						$('txtBranchCdFrom').clear();
						$('txtLineCdFrom').clear();
						$('txtDocYearFrom').clear();
						$('txtDocMmFrom').clear();
						$('txtDocSeqNoFrom').clear();
						$('txtLineCdFrom').readOnly = true;
						$('txtDocYearFrom').readOnly = true;
						$('txtDocMmFrom').readOnly = true;
						$('txtDocSeqNoFrom').readOnly = true;
						checkBranchCd = '';
						checkLineCd = '';
						checkDocYear = '';
						checkDocSeqNo = '';
						disableButton('btnCopy');
						disableSearch('imgBranchCdFrom');
						disableSearch('imgLineCdFrom');
						disableSearch('imgDocYearFrom');
						disableSearch('imgDocSeqNoFrom');
						disableButton('btnCopy');
						$('txtLineCdTo').clear();
						$("txtBranchCdTo").clear();
						$('txtDocYearTo').clear();
						$('txtDocMmTo').clear();
						$('txtDocSeqNoTo').clear();
						$('txtTranDateFrom').clear();
						disableDate('imgTranDate');
					}
					
					
					onLOV = false;
					$('txtDocumentCdFrom').value = row.documentCd;
					$('txtDocumentCdTo').value = row.documentCd;
					checkDocumentCd = row.documentCd;
					$('txtBranchCdFrom').readOnly = false;
					enableSearch('imgBranchCdFrom');
					$('txtBranchCdFrom').focus();
					
					
				},
				onCancel : function () {
					$("txtDocumentCdFrom").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDocumentCdFrom");
					onLOV = false;
				}
			});
		}
		
		function showBranchCdLov(){
			if($('txtBranchCdFrom').readOnly)
				return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS045BranchCdLov",
					documentCd : $("txtDocumentCdFrom").value,
					searchString : checkBranchCd == '' ? $("txtBranchCdFrom").value : '',
					page : 1
				},
				title : "",
				width : 380,
				height : 386,
				columnModel : [ 
				    {
				    	id : "branchCd",
						title : "Branch Code",
						width : '165px',
					},
					{
				    	id : "branchName",
						title : "Branch Name",
						width : '200px',
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: checkBranchCd == '' ? $("txtBranchCdFrom").value : '',
				onSelect : function(row) {
					
					if($("txtBranchCdFrom").value != row.branchCd){
						$('txtLineCdFrom').enable();
						$('lineCdFromSpan').setStyle({background : 'white'});
						$('txtLineCdFrom').clear();
						$('txtDocYearFrom').clear();
						$('txtDocMmFrom').clear();
						$('txtDocSeqNoFrom').clear();
						$('txtLineCdFrom').readOnly = true;
						$('txtDocYearFrom').readOnly = true;
						$('txtDocMmFrom').readOnly = true;
						$('txtDocSeqNoFrom').readOnly = true;
						checkBranchCd = '';
						checkLineCd = '';
						checkDocYear = '';
						checkDocSeqNo = '';
						disableSearch('imgLineCdFrom');
						disableSearch('imgDocYearFrom');
						disableSearch('imgDocSeqNoFrom');
						disableButton('btnCopy');
						$('txtLineCdTo').clear();
						$('txtDocYearTo').clear();
						$('txtDocMmTo').clear();
						$('txtDocSeqNoTo').clear();
						$('txtTranDateFrom').clear();
						disableDate('imgTranDate');
					}
					
					onLOV = false;
					$('txtBranchCdFrom').value = row.branchCd;
					checkBranchCd = row.branchCd;
					checkBranchCd2 = row.branchCd;
					$('txtBranchCdTo').value = row.branchCd;
						
						
					if(row.lineCdTag != 'Y'){
						$('txtLineCdFrom').disable();
						$('lineCdFromSpan').setStyle({background : '#f0f0f0'});
						disableSearch('imgLineCdFrom');
						$('txtDocYearFrom').focus();
						$('txtDocYearFrom').readOnly = false;
						enableSearch('imgDocYearFrom');
					} else {
						$('txtLineCdFrom').enable();
						$('lineCdFromSpan').setStyle({background : 'white'});
						enableSearch('imgLineCdFrom');
						$('txtLineCdFrom').focus();
						$('txtLineCdFrom').readOnly = false;
					}
				},
				onCancel : function () {
					$("txtBranchCdFrom").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdFrom");
					onLOV = false;
				}
			});
		}
		
		function showBranchCdLov2(){
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS045BranchCdLov2",
					searchString : checkBranchCd2 == '' ? $("txtBranchCdTo").value : '',
					page : 1
				},
				title : "",
				width : 380,
				height : 386,
				columnModel : [ 
				    {
				    	id : "branchCd",
						title : "Branch Code",
						width : '165px',
					},
					{
				    	id : "branchName",
						title : "Branch Name",
						width : '200px',
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: checkBranchCd2 == '' ? $("txtBranchCdTo").value : '',
				onSelect : function(row) {
					onLOV = false;
					checkBranchCd2 = row.branchCd;
					$("txtBranchCdTo").value = row.branchCd;
					$("txtBranchCdTo").focus();
				},
				onCancel : function () {
					$("txtBranchCdTo").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtBranchCdTo");
					onLOV = false;
				}
			});
		}
		
		function showLineLov(){
			if($('txtLineCdFrom').readOnly)
				return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS045LineLov",
					documentCd : $("txtDocumentCdFrom").value,
					branchCd : $("txtBranchCdFrom").value,
					searchString : $("txtLineCdFrom").value,
					page : 1
				},
				title : "",
				width : 380,
				height : 386,
				columnModel : [ 
	                {
						id : "lineCd",
						title : "Line Code",
						width : '100px',
					},
					{
						id : "lineName",
						title : "Line Name",
						width : '265px',
					}
	            ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: $("txtLineCdFrom").value,
				onSelect : function(row) {
					
					if($("txtLineCdFrom").value != row.lineCd){
						$('txtDocYearFrom').clear();
						$('txtDocMmFrom').clear();
						$('txtDocSeqNoFrom').clear();
						$('txtDocYearFrom').readOnly = true;
						$('txtDocMmFrom').readOnly = true;
						$('txtDocSeqNoFrom').readOnly = true;
						checkLineCd = '';
						checkDocYear = '';
						checkDocSeqNo = '';
						disableSearch('imgDocYearFrom');
						disableSearch('imgDocSeqNoFrom');
						disableButton('btnCopy');
						$('txtDocYearTo').clear();
						$('txtDocMmTo').clear();
						$('txtDocSeqNoTo').clear();
						$('txtTranDateFrom').clear();
						disableDate('imgTranDate');
					}
					onLOV = false;
					$("txtLineCdFrom").value = row.lineCd;
					$("txtLineCdTo").value = row.lineCd;
					$("txtDocYearFrom").focus();
					checkLineCd = row.lineCd;
				},
				onCancel : function () {
					$("txtLineCdFrom").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtLineCdFrom");
					onLOV = false;
				}
			});
		}
		
		function showDocYearLov(){
			if($('txtDocYearFrom').readOnly)
				return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS045DocYearLov",
					documentCd : $("txtDocumentCdFrom").value,
					branchCd : $("txtBranchCdFrom").value,
					lineCd : $("txtLineCdFrom").value,
					searchString : $("txtDocYearFrom").value,
					page : 1
				},
				title : "Valid values for Document Year and Month",
				width : 380,
				height : 386,
				columnModel : [ 
				                {
									id : "docYear",
									title : "Year",
									width : '180px',
								},
								{
									id : "docMm",
									title : "Month",
									width : '185px',
								}
				            ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: $("txtDocYearFrom").value,
				onSelect : function(row) {
					
					if($("txtDocYearFrom").value != row.docYear || removeLeadingZero($('txtDocMmFrom').value) != row.docMm){
						$('txtDocMmFrom').clear();
						$('txtDocSeqNoFrom').clear();
						$('txtDocMmFrom').readOnly = true;
						$('txtDocSeqNoFrom').readOnly = true;
						checkDocYear = '';
						checkDocSeqNo = '';
						disableSearch('imgDocSeqNoFrom');
						disableButton('btnCopy');
						$('txtDocYearTo').clear();
						$('txtDocMmTo').clear();
						$('txtDocSeqNoTo').clear();
						$('txtTranDateFrom').clear();
						disableDate('imgTranDate');
					}
					
					onLOV = false;
					$("txtDocYearFrom").value = row.docYear;
					$("txtDocMmFrom").value = formatNumberDigits(row.docMm, 2);
					if($("txtDocYearTo").value == "" || $("txtDocMmTo").value == ""){
						$("txtDocYearTo").value = row.docYear;
						$("txtDocMmTo").value = formatNumberDigits(row.docMm, 2);
					}
					enableSearch('imgDocSeqNoFrom');
					$('txtDocSeqNoFrom').readOnly = false;
					$("txtDocSeqNoFrom").focus();
					
				},
				onCancel : function () {
					$("txtDocYearFrom").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDocYearFrom");
					onLOV = false;
				}
			});
		}
		
		function showDocSeqNoLov(){
			if($('txtDocSeqNoFrom').readOnly)
				return;
			onLOV = true;
			LOV.show({
				controller : "AccountingLOVController",
				urlParameters : {
					action : "getGIACS045DocSeqNoLov",
					documentCd : $("txtDocumentCdFrom").value,
					branchCd : $("txtBranchCdFrom").value,
					lineCd : $("txtLineCdFrom").value,
					docYear : $("txtDocYearFrom").value,
					docMm : $("txtDocMmFrom").value,
					docSeqNo : $("txtDocSeqNoFrom").value,
					searchString : $("txtDocSeqNoFrom").value,
					page : 1
				},
				title : "Valid values for Document Sequence No.",
				width : 660,
				height : 386,
				columnModel : [ 
				                {
									id : "docSeqNo",
									title : "Doc Seq No",
									width : '50px',
								},
								{
									id : "particulars",
									title : "Particulars",
									width : '595px' ,
									renderer : function(val){
										return escapeHTML2(val);
									}
								}
				            ],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: $("txtDocSeqNoFrom").value,
				onSelect : function(row) {
					
					if($("txtDocSeqNoFrom").value != row.docSeqNo){
						checkDocSeqNo = '';
						disableButton('btnCopy');
						$('txtTranDateFrom').clear();
						disableDate('imgTranDate');
					}
					
					onLOV = false;
					$("txtDocSeqNoFrom").value = row.docSeqNo;
					validateRequestNumber();
				},
				onCancel : function () {
					$("txtDocSeqNoFrom").focus();
					onLOV = false;
				},
				onUndefinedRow : function(){
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDocSeqNoFrom");
					onLOV = false;
				}
			});
		}
		
		function validateRequestNumber(){
			var ajaxResponse = "";
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "validateRequestNumber",
						     documentCdFrom : $("txtDocumentCdFrom").value,
						     branchCdFrom : $("txtBranchCdFrom").value,
						     lineCdFrom : $("txtLineCdFrom").value,
						     docYearFrom : $("txtDocYearFrom").value,
						     docMmFrom : $("txtDocMmFrom").value,
						     docSeqNoFrom : $("txtDocSeqNoFrom").value
				},
				evalScripts: false,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						ajaxResponse = obj.check;
						if(trim(ajaxResponse || 'hohoho') != 'no data'){
							objGIACS045.tranDate = dateFormat(obj.tranDateFrom, 'mm-dd-yyyy');
							objGIACS045.refIdFrom = obj.refIdFrom;
							objGIACS045.fundCdFrom = obj.fundCdFrom;
							objGIACS045.tranIdFrom = obj.tranIdFrom;
							$("txtTranDateFrom").value = objGIACS045.tranDate;
							$("txtDocSeqNoFrom").value = formatNumberDigits($("txtDocSeqNoFrom").value, 6);
						}
					}
				}
			});
			
			if(trim(ajaxResponse || 'hohoho') == 'no data'){
				disableButton("btnCopy");
				customShowMessageBox("Please enter valid request number.", imgMessage.ERROR, "txtDocSeqNoFrom");
				return false;
			} else {
				//$("txtDocSeqNoFrom").readOnly = true;
				//disableSearch("imgDocSeqNoFrom");
				enableDate('imgTranDate');
				enableButton("btnCopy");
				return true;
			}
		}
		
		function copyPaymentRequest() {
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "copyPaymentRequest",
						     includeAcctgEntries : getAcctgEntriesSw(),
						     documentCdFrom : $("txtDocumentCdFrom").value,
						     branchCdFrom : $("txtBranchCdFrom").value,
						     lineCdFrom : $("txtLineCdFrom").value,
						     docYearFrom : $("txtDocYearFrom").value,
						     docMmFrom : $("txtDocMmFrom").value,
						     docSeqNoFrom : $("txtDocSeqNoFrom").value,
						     documentCdTo : $("txtDocumentCdTo").value,
						     branchCdTo : $("txtBranchCdTo").value,
						     lineCdTo : $("txtLineCdTo").value,
						     docYearTo : $("txtDocYearTo").value,
						     docMmTo : $("txtDocMmTo").value,
						     refIdFrom : objGIACS045.refIdFrom,
						     fundCdFrom : objGIACS045.fundCdFrom,
						     tranDateFrom : $("txtTranDateFrom").value,
						     tranIdFrom : objGIACS045.tranIdFrom
				},
				evalScripts: false,
				asynchronous: true,
				onComplete : function(response){
					if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
						var obj = JSON.parse(response.responseText);
						objGIACS045.docSeqNoTo = obj.docSeqNoTo;
						showNewPaymentRequest();
					}
				}
			});
		}
		
		function showNewPaymentRequest() {
			try {
				objGIACS045.documentCdFrom = $("txtDocumentCdFrom").value;
				objGIACS045.branchCdFrom = $("txtBranchCdFrom").value;
				objGIACS045.lineCdFrom = $("txtLineCdFrom").value;
				objGIACS045.docYearFrom = $("txtDocYearFrom").value;
				objGIACS045.docMmFrom = $("txtDocMmFrom").value;
				objGIACS045.docSeqNoFrom = $("txtDocSeqNoFrom").value;
				objGIACS045.documentCdTo = $("txtDocumentCdTo").value;
				objGIACS045.branchCdTo = $("txtBranchCdTo").value;
				objGIACS045.lineCdTo = $("txtLineCdTo").value;
				objGIACS045.docYearTo = $("txtDocYearTo").value;
				objGIACS045.docMmTo = $("txtDocMmTo").value;
				
				overlayNewPmaymentRequest = 
					Overlay.show(contextPath+"/GIACDisbursementUtilitiesController", {
						urlContent: true,
						urlParameters: {action : "showNewPaymentRequest",																
										ajax : "1"
						},
					    title: "",
					    height: 143,
					    width: 303,
					    draggable: true
					});
			} catch (e) {
				showErrorMessage("overlay error: " , e);
			}
		}
		
		function validateDocumentCd () {
			if($('txtDocumentCdFrom').value == '')
				return;
			
			var ajaxResponse = "";
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "giacs045ValidateDocumentCd",
						     documentCd : $("txtDocumentCdFrom").value
				},
				evalScripts: false,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = response.responseText;
					}
				}
			});
			
			if(trim(ajaxResponse) == "no data"){
				customShowMessageBox("Please enter valid document code.", imgMessage.ERROR, "txtDocumentCdFrom");
				return false;
			} else {
				$("txtDocumentCdTo").value = $("txtDocumentCdFrom").value;
				checkDocumentCd = $("txtDocumentCdTo").value;
				enableSearch('imgBranchCdFrom');
				$('txtBranchCdFrom').readOnly = false;
				return true;
			}
		}
		
		function validateBranchCdFrom() {
			if($('txtBranchCdFrom').value == '')
				return;
			
			var ajaxResponse = "";
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "giacs045ValidateBranchCdFrom",
						     documentCd : $("txtDocumentCdFrom").value,
						     branchCdFrom : $("txtBranchCdFrom").value
				},
				evalScripts: false,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = response.responseText;
					}
				}
			});
			
			
			
			if(trim(ajaxResponse) == "no data"){
				customShowMessageBox("Please enter valid branch code.", imgMessage.ERROR, "txtBranchCdFrom");
				return false;
			} else {
				if($("txtBranchCdTo").value == "")
					$("txtBranchCdTo").value = $("txtBranchCdFrom").value;
				
				
				if(trim(ajaxResponse) == 'N'){
					$('lineCdFromSpan').setStyle({background : '#f0f0f0'});
					$('txtLineCdFrom').disable();
					disableSearch('imgLineCdFrom');
					$('txtDocYearFrom').readOnly = false;
					$('txtDocYearFrom').focus();
					enableSearch('imgDocYearFrom');
				} else {
					$('lineCdFromSpan').setStyle({background : 'white'});
					$('txtLineCdFrom').enable();
					enableSearch('imgLineCdFrom');
					$('txtLineCdFrom').readOnly = false;
					$('txtLineCdFrom').focus();
				}
				
				return true;
			}
		}
		
		function validateLineCd() {
			if($('txtLineCdFrom').value == '')
				return;
			
			var ajaxResponse = "";
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "giacs045ValidateLineCd",
						     documentCd : $("txtDocumentCdFrom").value,
						     branchCdFrom : $("txtBranchCdFrom").value,
						     lineCd : $("txtLineCdFrom").value
				},
				evalScripts: false,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = response.responseText;
					}
				}
			});
			
			if(trim(ajaxResponse) == "no data"){
				customShowMessageBox("Please enter valid line code.", imgMessage.ERROR, "txtLineCdFrom");
				return false;
			} else {
				$("txtLineCdTo").value = $("txtLineCdFrom").value;
				enableSearch('imgDocYearFrom');
				$('txtDocYearFrom').readOnly = false;
				$('txtDocYearFrom').focus();
				return true;
			}
		}
		
		function validateDocYear() {
			if($('txtDocYearFrom').value == '')
				return;
			
			var ajaxResponse = "";
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "giacs045ValidateDocYear",
						     documentCd : $("txtDocumentCdFrom").value,
						     branchCdFrom : $("txtBranchCdFrom").value,
						     lineCd : $("txtLineCdFrom").value,
						     docYear : $("txtDocYearFrom").value
				},
				evalScripts: false,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = response.responseText;
					}
				}
			});
			
			if(trim(ajaxResponse) == "no data"){
				customShowMessageBox("Please enter valid document year.", imgMessage.ERROR, "txtDocYearFrom");
				return false;
			} else {
				$("txtDocYearTo").value = $("txtDocYearFrom").value;
				$('txtDocMmFrom').readOnly = false;
				$('txtDocMmFrom').focus();
				return true;
			}
		}
		
		function validateDocMm() {
			if($('txtDocMmFrom').value == '')
				return;
			
			var ajaxResponse = "";
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "giacs045ValidateDocMm",
						     documentCd : $("txtDocumentCdFrom").value,
						     branchCdFrom : $("txtBranchCdFrom").value,
						     lineCd : $("txtLineCdFrom").value,
						     docYear : $("txtDocYearFrom").value,
						     docMm : $("txtDocMmFrom").value
				},
				evalScripts: false,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = response.responseText;
					}
				}
			});
			
			if(trim(ajaxResponse) == "no data"){
				customShowMessageBox("Please enter valid document month.", imgMessage.ERROR, "txtDocMmFrom");
				return false;
			} else {
				$("txtDocMmTo").value = $("txtDocMmFrom").value;
				$('txtDocSeqNoFrom').readOnly = false;
				enableSearch('imgDocSeqNoFrom');
				$('txtDocSeqNoFrom').focus();
				return true;
			}
		}
		
		function validateBranchCdTo() {
			if($('txtBranchCdTo').value == '')
				return;
			var ajaxResponse = "";
			new Ajax.Request(contextPath+"/GIACDisbursementUtilitiesController",{
				method: "POST",
				parameters: {
						     action : "giacs045ValidateBranchCdTo",
						     branchCdTo : $("txtBranchCdTo").value
				},
				evalScripts: true,
				asynchronous: false,
				onComplete : function(response){
					if(checkErrorOnResponse(response)){
						ajaxResponse = response.responseText;
					}
				}
			});
			
			if(trim(ajaxResponse) == "no data"){
				customShowMessageBox("Please enter valid branch code.", imgMessage.ERROR, "txtBranchCdTo");
				return false;
			} else {
				/* $("txtBranchCdTo").readOnly = true;
				disableSearch("imgBranchCdTo"); */
				return true;
			}
		}
		
		$('txtBranchCdFrom').observe('focus', function(){
			validateDocumentCd();
		});
		
		$('txtLineCdFrom').observe('focus', function(){
			validateBranchCdFrom();
		});
		
		$('txtDocYearFrom').observe('focus', function(){
			if($('txtLineCdFrom').readOnly == false)
				validateLineCd();
			else
				validateBranchCdFrom();
				
		});
		
		$('txtDocSeqNoFrom').observe('focus', function(){
			validateDocMm();
		});
		
		$('txtDocMmFrom').observe('focus', function(){
			validateDocYear();
		});
		
		$('txtDocSeqNoFrom').observe('change', function(){
			if(this.value == '')
				return;	
			validateRequestNumber();
		});
		
		$('txtDocMmFrom').observe('keypress', function(event){
			if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0){
				$('txtDocSeqNoFrom').clear();
				$('txtDocSeqNoFrom').readOnly = true;
				checkDocSeqNo = '';
				disableSearch('imgDocSeqNoFrom');
				disableButton('btnCopy');
				$('txtDocMmTo').clear();
				$('txtDocSeqNoTo').clear();
				$('txtTranDateFrom').clear();
				disableDate('imgTranDate');
			}
		});
		
		$('imgDocumentCdFrom').observe('click', function(){
			if(!onLOV)
				showDocumentCdLov();
		});
		
		$('txtDocumentCdFrom').observe('keypress', function(event){
			if(event.keyCode == 13) {
				if(!onLOV)
					showDocumentCdLov();
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) { 
				$('txtLineCdFrom').enable();
				$('lineCdFromSpan').setStyle({background : 'white'});
				$('txtDocumentCdTo').clear();
				$('txtBranchCdFrom').clear();
				$('txtLineCdFrom').clear();
				$('txtDocYearFrom').clear();
				$('txtDocMmFrom').clear();
				$('txtDocSeqNoFrom').clear();
				$('txtBranchCdFrom').readOnly = true;
				$('txtLineCdFrom').readOnly = true;
				$('txtDocYearFrom').readOnly = true;
				$('txtDocMmFrom').readOnly = true;
				$('txtDocSeqNoFrom').readOnly = true;
				checkDocumentCd = '';
				checkBranchCd = '';
				checkLineCd = '';
				checkDocYear = '';
				checkDocSeqNo = '';
				disableSearch('imgBranchCdFrom');
				disableSearch('imgLineCdFrom');
				disableSearch('imgDocYearFrom');
				disableSearch('imgDocSeqNoFrom');
				disableButton('btnCopy');
				$('txtLineCdTo').clear();
				$("txtBranchCdTo").clear();
				$('txtDocYearTo').clear();
				$('txtDocMmTo').clear();
				$('txtDocSeqNoTo').clear();
				$('txtTranDateFrom').clear();
				disableDate('imgTranDate');
				
			}
		}); 
		
		$('imgBranchCdFrom').observe('click', function(){
			if(!onLOV)
				showBranchCdLov();
		});
		
		$('txtBranchCdFrom').observe('keypress', function(event){
			if(event.keyCode == 13) { 
				if(!onLOV)
					showBranchCdLov();
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) { 
				$('txtLineCdFrom').enable();
				$('lineCdFromSpan').setStyle({background : 'white'});
				$('txtLineCdFrom').clear();
				$('txtDocYearFrom').clear();
				$('txtDocMmFrom').clear();
				$('txtDocSeqNoFrom').clear();
				$('txtLineCdFrom').readOnly = true;
				$('txtDocYearFrom').readOnly = true;
				$('txtDocMmFrom').readOnly = true;
				$('txtDocSeqNoFrom').readOnly = true;
				checkBranchCd = '';
				checkLineCd = '';
				checkDocYear = '';
				checkDocSeqNo = '';
				disableSearch('imgLineCdFrom');
				disableSearch('imgDocYearFrom');
				disableSearch('imgDocSeqNoFrom');
				disableButton('btnCopy');
				$('txtLineCdTo').clear();
				$("txtBranchCdTo").clear();
				$('txtDocYearTo').clear();
				$('txtDocMmTo').clear();
				$('txtDocSeqNoTo').clear();
				$('txtTranDateFrom').clear();
				disableDate('imgTranDate');
			}
		}); 
		
		$('imgLineCdFrom').observe('click', function(){
			if(!onLOV)
				showLineLov();
		});
		
		$('txtLineCdFrom').observe('keypress', function(event){
			if(event.keyCode == 13) { 
				if(!onLOV)
					showLineLov();
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$('txtDocYearFrom').clear();
				$('txtDocMmFrom').clear();
				$('txtDocSeqNoFrom').clear();
				$('txtDocYearFrom').readOnly = true;
				$('txtDocMmFrom').readOnly = true;
				$('txtDocSeqNoFrom').readOnly = true;
				checkLineCd = '';
				checkDocYear = '';
				checkDocSeqNo = '';
				disableSearch('imgDocYearFrom');
				disableSearch('imgDocSeqNoFrom');
				disableButton('btnCopy');
				$('txtLineCdTo').clear();
				$('txtDocYearTo').clear();
				$('txtDocMmTo').clear();
				$('txtDocSeqNoTo').clear();
				$('txtTranDateFrom').clear();
				disableDate('imgTranDate');
			}
		}); 
		
		$('imgDocYearFrom').observe('click', function(){
			if(!onLOV)
				showDocYearLov();
		});
		
		$('txtDocYearFrom').observe('keypress', function(event){
			if(event.keyCode == 13) { 
				if(!onLOV)
					showDocYearLov();
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) {
				$('txtDocMmFrom').clear();
				$('txtDocSeqNoFrom').clear();
				$('txtDocMmFrom').readOnly = true;
				$('txtDocSeqNoFrom').readOnly = true;
				checkDocYear = '';
				checkDocSeqNo = '';
				disableSearch('imgDocSeqNoFrom');
				disableButton('btnCopy');
				$('txtDocYearTo').clear();
				$('txtDocMmTo').clear();
				$('txtDocSeqNoTo').clear();
				$('txtTranDateFrom').clear();
				disableDate('imgTranDate');
			}
		});
		
		$('imgDocSeqNoFrom').observe('click', function(){
			if(!onLOV)
				showDocSeqNoLov();
		});
		
		$('txtDocSeqNoFrom').observe('keypress', function(event){
			if(event.keyCode == 13) {
				if(onLOV)
					return;
				if(this.value == '')
					showDocSeqNoLov();
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) { 
				checkDocSeqNo = '';
				disableButton('btnCopy');
				$('txtTranDateFrom').clear();
				disableDate('imgTranDate');
			}
		});
		
		$('imgBranchCdTo').observe('click', function(){
			if(!onLOV)
				showBranchCdLov2();
		});
		
		/* $('txtBranchCdTo').observe('keypress', function(event){
			if(event.keyCode == 13) { 
				if(!onLOV)
					showBranchCdLov2();
			} else if(event.keyCode == 8 || event.keyCode == 46 || event.keyCode == 0) { 
				checkBranchCd2 = '';
			}
		}); */
		
		$('imgTranDate').observe('click', function(){
			scwShow($('txtTranDateFrom'), this, null);	
		});
		
		$('txtTranDateFrom').observe('focus', function(){
				var date = $("txtTranDateFrom").value.split("-");
				$("txtDocYearTo").value = date[2] == null ? "" : date[2];
				$("txtDocMmTo").value = date[0] == null ? "" : date[0];
		});
		
		$('btnCopy').observe('click', function(){
			if(!validateBranchCdTo()){ //changed by steven 09.26.2014
				return;
			}
			if(checkAllRequiredFieldsInDiv('copyPaymentRequestMainDiv'));
				copyPaymentRequest();
		});
		
		function getAcctgEntriesSw() {
			if($("chkAcctgEntries").checked)
				return 'Y';
			else 
				return 'N';
		}
		
		$("txtBranchCdTo").observe("blur", function(){
			if(this.value == "")
				$("txtBranchCdTo").value = $F("txtBranchCdFrom");
		});
			
		initGIACS045();
		initializeAll();
		
	} catch(e) {
		showErrorMessage("Error : " , e);
	}
</script>