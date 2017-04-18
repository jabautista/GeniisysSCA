<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="/WEB-INF/tld/fmt.tld"%>
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="dvPaytDtlDiv" >
	<div class="sectionDiv" id="disbursementRequestsDiv" changeTagAttr="true" style="margin-top: 5px; width: 800px;">
		<table border="0" align="left" style="margin: 10px 0 10px 35px;">
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Request No.</td>
				<td class="leftAligned">
					<input type="hidden" id="hidLineCdTag" name="hidDocTag" readOnly="readOnly"/>
					<input type="hidden" id="hidYyTag" name="hidDocTag" readOnly="readOnly"/>
					<input type="hidden" id="hidMmTag" name="hidDocTag" readOnly="readOnly"/>
					<input type="hidden" id="hidTranId" name="hidTranId"/>
					<div style="width: 66px; float: left; height: 21px;" class="withIconDiv required">
						<input style="width: 40px; height: 15px;" id="txtDVDocumentCd" name="txtDVDocumentCd" type="text" value=""  class="withIcon required" maxLength="100" tabindex="301"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDocumentCd" name="dvPaytLov" alt="Go"/>
					</div>
					<div id="lovBranchCdDiv" style="width: 51px; height: 21px; float: left; margin-left: 0px;" class="required withIconDiv">
						<input style="width: 25px; height: 15px;" id="txtDVBranchCd" name="txtDVBranchCd" type="text" value="" class="required withIcon" maxLength="50" tabindex="302"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBranchCd" name="dvPaytLov" alt="Go" />
					</div>
					<div id="lovLineCdDiv" style="width: 51px; height: 21px; float: left; margin-left: 0px;" class="withIconDiv">
						<input style="width: 25px; height: 15px;" id="txtDVLineCd" name="txtDocTagField" type="text" value="" class="withIcon" maxLength="20" tabindex="303"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovLineCd" name="dvPaytLov" alt="Go" />
					</div>
					<input style="width: 40px; text-align: right;" type="text" id="txtDVDocYear" name="txtDocTagField"  class="required" maxlength="4" readOnly="readOnly" tabindex="304"/>
					<input style="width: 26px; text-align: right;" type="text" id="txtDVDocMm" name="txtDocTagField"  class="required" maxlength="2" readOnly="readOnly" tabindex="305"/>
					<div id="lovDocSeqNoDiv" style="width: 80px; height: 21px; float: right; margin-left: 4px;" class="withIconDiv">
						<input style="width: 55px; text-align: right; height: 15px;" type="text" id="txtDVDocSeqNo" name="txtDVDocSeqNo" readOnly="readOnly" class="withIcon" tabindex="306"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDocSeqNo" name="dvPaytLov" alt="Go" />
					</div>
					<!-- <input style="width: 55px; text-align: right;" type="text" id="txtDVDocSeqNo" name="txtDVDocSeqNo" readOnly="readOnly" tabindex="306"/> -->
				</td>
				
				<td class="rightAligned" style="width: 76px; padding-right: 2px;">Date</td>
				<td class="leftAligned">
					<div style="width: 220px; height: 21px;" class="required withIconDiv">
			    		<input style="width: 195px; height: 15px;" type="text" id="txtDVRequestDate" name="txtDVRequestDate" readOnly="readOnly" maxlength="10" class="required withIcon" triggerChange = "Y" tabindex="307"/>
			    		<img class="disabled" id="hrefRequestDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Request Date"/>
			    	</div>	
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Department</td>
				<td class="leftAligned">
					<input type="hidden" id="txtDVDeptId" name="txtDVDeptId" readOnly="readOnly"/>
					<div style="width: 66px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 40px; text-align: right; height: 15px;" id="txtDVDspDeptCd" name="txtDVDspDeptCd" type="text" value="" class="withIcon required" ignoreDelKey="1" maxLength="100" tabindex="309"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDspDeptCd" name="dvPaytLov" alt="Go" class=""/>
					</div>
					<input style="width: 278px;" id="txtDVDspDeptName" name="txtDVDspDeptName" type="text" value="" readOnly="readOnly" tabindex="310"/>
				</td>
			</tr>	
		</table>
	</div>	
	<div class="sectionDiv" id="disbursementRequestsDiv3" changeTagAttr="true" style="width: 800px;">
		<table border="0" align="center" style="margin: 10px;">
			<tr>
				<td class="rightAligned" style="padding-right: 4px;" >Payee</td>
				<td class="leftAligned" colspan="3">
					<div style="width: 66px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 40px; text-align: right; height: 15px;" id="txtDVPayeeClassCd" name="txtDVPayeeClassCd" type="text" value="" class="withIcon required" ignoreDelKey="1" maxLength="30" tabindex="311"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeClassCd" name="dvPaytLov" alt="Go" />
					</div>
					<div style="width: 146px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 120px; text-align: right; height: 15px;" id="txtDVPayeeCd" name="txtDVPayeeCd" type="text" value="" class="withIcon required" ignoreDelKey="1" maxLength="500" tabindex="312"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeCd" name="dvPaytLov" alt="Go" />
					</div>
					<input style="width: 433px;" type="text" id="txtDVPayee" name="txtDVPayee" readOnly="readOnly" tabindex="313"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px; padding-top: 5px;" valign="top">Particulars</td>
				<td class="leftAligned" colspan="3">
					<div style="float: left; width: 663px; height: 54px;" class="withIconDiv required">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtDVParticulars" name="txtDVParticulars" style="width: 633px; resize:none; height: 48px;" class="withIcon required" tabindex="314"> </textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Amount</td>
				<td class="leftAligned" style="width: 310px;">
					<input type="hidden" id="txtDVCurrencyCd" name="txtDVCurrencyCd" value="" readOnly="readOnly" />
					<div style="width: 51px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 25px; height: 15px;" id="txtDVDspFshortName" name="txtDVDspFshortName" type="text" value="" class="withIcon required" maxLength="20" tabindex="316"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDspFshortName" name="dvPaytLov" alt="Go" />
					</div>
					<input style="width: 155px;" type="text" id="txtDVDvFcurrencyAmt" name="txtDVDvFcurrencyAmt" class="money2 required" maxlength="17" errorMsg="Invalid Amount. Valid value should be from 0.01 to 99999999999999.99" min="0.01" max="99999999999999.99" tabindex="317"/>
				</td>
				<td class="rightAligned" style="width: 127px; padding-right: 4px;">Local Amount</td>
				<td class="leftAligned">
					<input style="width: 45px;" type="text" id="txtDVDspLshortName" name="txtDVDspLshortName" readOnly="readOnly" tabindex="318"/>
					<input style="width: 155px;" type="text" id="txtDVPaytAmt" name="txtDVPaytAmt" readOnly="readOnly" class="money2" tabindex="319"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Conversion Rate</td>
				<td class="leftAligned"><input style="width: 212px; text-align: right;" type="text" id="txtDVCurrencyRt" name="txtDVCurrencyRt" class="nthDecimal2 required" maxlength="13" errorMsg="Field must be of form 999.999999999" min="-999.999999999" max="999.999999999" nthDecimal2="9" tabindex="320"/></td>
			</tr>
		</table>
	</div>
		
	<div class="buttonsDiv" style="margin: 10px 0 0 0;">
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;" tabindex="321"/>
		<input type="button" id="btnSave" class="button" value="Save" style="width: 90px;" tabindex="322"/>
		<input type="button" id="btnDelete" class="button" value="Delete" style="width: 90px;" tabindex="323"/>
	</div>
</div>

<script type="text/javascript">
	try {
		/* variables */
		var objGUDV = JSON.parse('${jsonGUDV}');
		var deleteSw = false;
		var editSw = false;
		var compared = true;
		
		/* observe elements */
		$("lovDocumentCd").observe("click", function() {
			showDocumentCdLOV(true);
		});
		
		$("txtDVDocumentCd").observe("change", function() {
			if (this.value != ""){
				showDocumentCdLOV(false);
			}else{
				$("txtDVDocumentCd").setAttribute("lastValidValue", "");
			}
		});

		$("lovBranchCd").observe("click", function() {
			showBranchLOV(true);
		});

		$("txtDVBranchCd").observe("change", function() {
			if (this.value != "") {
				showBranchLOV(false);
			} else {
				$("txtDVBranchCd").setAttribute("lastValidValue", "");
				$("txtDVDocumentCd").clear();
				$("txtDVDocumentCd").setAttribute("lastValidValue", "");
				
			}
		});

		$("lovLineCd").observe("click", function() {
			showLineLOV(true);
		});

		$("txtDVLineCd").observe("change", function() {
			if (this.value != "") {
				showLineLOV(false);
			} else {
				$("txtDVLineCd").setAttribute("lastValidValue", "");
			}
		});

		$("txtDVDocYear").observe("focus", function() {
			if ($F("hidYyTag") == "Y" && this.value == "") {
				this.value = dateFormat(new Date(), "yyyy");
			}
		});

		$("txtDVDocMm").observe("focus", function(event) {
			if ($F("hidMmTag") == "Y" && this.value == "") {
				this.value = dateFormat(new Date(), "mm");
			}
		});
		
		$("lovDocSeqNo").observe("click", function() {
			showPaytRqstLOV();
		});
		
		$$("div#dvPaytDtlDiv input[name='txtDocTagField']").each(function(o) {
			$(o).observe("mousedown", function(event) {
				if ($(o).readAttribute("tabIndex") == "-1") {
					event.preventDefault();
				}
			});
		});

		$("lovDspDeptCd").observe("click", function() {
			showDeptLOV(true);
		});

		$("txtDVDspDeptCd").observe("change", function() {
			if (this.value != "") {
				showDeptLOV(false);
			} else {
				$("txtDVDspDeptCd").setAttribute("lastValidValue", "");
				$("txtDVDeptId").clear();
				$("txtDVDspDeptName").clear();
			}
		});

		$("hrefRequestDate").observe("click", function() {
			scwNextAction = validateRequestDate.runsAfterSCW(this, null);
			scwShow($("txtDVRequestDate"), this, null);
		});
		
		$("txtDVRequestDate").observe("keyup", function(event){
			if (event.keyCode == 46 && !$("txtDVDocumentCd").readOnly) {
				$("txtDVDocYear").clear();
				$("txtDVDocMm").clear();
			}
		});

		$("txtDVDspDeptCd").observe("blur", function() {
			if ($F("txtDVRequestDate") == "") {
				$("txtDVRequestDate").value = dateFormat(new Date(), "mm-dd-yyyy");
				var reqDateArray = $("txtTranDate").value.split("-");
				if ($("txtDVDocYear").hasClassName('required')) {
					$("txtDVDocYear").value = reqDateArray[2];
				}
				if ($("txtDVDocMm").hasClassName('required')) {
					$("txtDVDocMm").value = reqDateArray[0];
				}
			}
		});

		$("lovPayeeClassCd").observe("click", function() {
			showPayeeClassLOV(true);
		});

		$("txtDVPayeeClassCd").observe("change", function() {
			if (this.value != "") {
				showPayeeClassLOV(false);
			} else {
				$("txtDVPayeeClassCd").setAttribute("lastValidValue", "");
				disableSearch("lovPayeeCd");
				$("txtDVPayeeCd").readOnly = true;
				$("txtDVPayeeCd").clear();
				$("txtDVPayeeCd").setAttribute("lastValidValue", "");
				$("txtDVPayee").clear();

			}
		});

		$("lovPayeeCd").observe("click", function() {
			showPayeeLOV(true);
		});

		$("txtDVPayeeCd").observe("change", function() {
			if (this.value != "") {
				showPayeeLOV(false);
			} else {
				$("txtDVPayeeCd").setAttribute("lastValidValue", "");
				$("txtDVPayee").clear();
			}
		});

		$("editParticulars").observe("click", function() {
			showOverlayEditor("txtDVParticulars", 2000, $("txtDVParticulars").hasAttribute("readonly"),
				function() {
					changeTag = 1;
					editSw = true;
				});
		});

		$("txtDVDspFshortName").observe("focus", function() {
			if ($F("txtDVDspFshortName") == "") {
				$("txtDVDspFshortName").value = unescapeHTML2(parameters.dfltCurrencySname);
				$("txtDVDspFshortName").setAttribute("lastValidValue", $F("txtDVDspFshortName"));
				$("txtDVCurrencyCd").value = parameters.dfltCurrencyCd;
				$("txtDVCurrencyRt").value = formatToNineDecimal(parameters.dfltCurrencyRt);
				changeTag = 1;
				editSw = true;
			}
			$("txtDVDspLshortName").value = unescapeHTML2(parameters.dfltCurrencySname);
		});

		$("lovDspFshortName").observe("click", function() {
			showCurrencyLOV(true);
		});

		$("txtDVDspFshortName").observe("change", function() {
			if (this.value != "") {
				showCurrencyLOV(false);
			} else {
				$("txtDVDspFshortName").setAttribute("lastValidValue", "");
				$("txtDVCurrencyRt").clear();
			}
		});

		$("txtDVDvFcurrencyAmt").observe("change", function() {
			getLocalAmt();
		});
		
		$("txtDVCurrencyRt").observe("change", function() {
			getLocalAmt();
		});

		$("btnDelete").observe("click", function() {
			deleteSw = true;
			editSw = false;
			changeTag = 1;
			compared = false;
			changeTagFunc = saveGiacs609DVPaytDtl;

			$$("div#dvPaytDtlDiv input[type='text'], div#dvPaytDtlDiv textarea").each(function(o) {
				$(o).clear();
			});
			
			initAll();
			$("txtDVDocumentCd").focus();
		});

		$("btnReturn").observe("click", function() {
			if (changeTag == 1) {
				showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No",
					"Cancel", function() {
						saveGiacs609DVPaytDtl(true);
					}, function() {
						overlayDVPaytDtl.close();
						changeTag = 0;
					}, "");
			} else {
				overlayDVPaytDtl.close();
			}
		});

		observeSaveForm("btnSave", saveGiacs609DVPaytDtl);

		$$("div#dvPaytDtlDiv input[type='text'], div#dvPaytDtlDiv textarea").each(function(o) {
			$(o).observe("change", function() {
				editSw = true;
				changeTag = 1;
				changeTagFunc = saveGiacs609DVPaytDtl;
			});
		});
		
		$("dvPaytDtlDiv").observe("keydown", function(event){
			var curEle = document.activeElement.id;
			if (event.keyCode == 9 && !event.shiftKey) {
				if (curEle == "btnReturn" && $("btnSave").disabled == true) {
					if ($("txtDVLineCd").disabled == true) {
						$("txtDVDocSeqNo").focus();
					} else {
						$("txtDVLineCd").focus();
					}
					event.preventDefault();
				} else if (curEle == "btnDelete") {
					$("txtDVDocumentCd").focus();
					event.preventDefault();
				} else if (curEle == "btnSave" && $("btnDelete").disabled == true) {
					$("txtDVDocumentCd").focus();
					event.preventDefault();
				}
			} else if (event.keyCode == 9 && event.shiftKey) {
				if (curEle == "txtDVLineCd" && $("txtDVBranchCd").disabled == true) {
					$("btnReturn").focus();
					event.preventDefault();
				} else if (curEle == "txtDVDocSeqNo" && $("txtDVDocMm").disabled == true) {
					if ($("txtDVLineCd").disabled == true) {
						$("btnReturn").focus();
					} else {
						$("txtDVLineCd").focus();
					}
					event.preventDefault();
				} else if (curEle == "txtDVDocumentCd") {
					if ($("btnDelete").disabled == true) {
						if ($("btnSave").disabled == true) {
							$("btnReturn").focus();
						} else {
							$("btnSave").focus();
						}
					} else {
						$("btnDelete").focus();
					}
					event.preventDefault();
				}
			}
		});
		
		/* functions: LOV */
		function showDocumentCdLOV(isIconClicked){
			try{
				var searchString = isIconClicked ? "%" : ($F("txtDVDocumentCd").trim() == "" ? "%" : $F("txtDVDocumentCd"));
				
				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609DocumentLOV",
						branchCd: $F("txtDVBranchCd"),
						searchString: searchString,
						page : 1
					},
					title : "List of Document Codes",
					width : 400,
					height : 400,
					columnModel : [ {
						id : 'documentCd',
						title : 'Document Code',
						width : '105px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'documentName',
						title : 'Document Name',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined){
							$("txtDVDocumentCd").value = unescapeHTML2(row.documentCd);
							$("txtDVDocumentCd").setAttribute("lastValidValue", unescapeHTML2(row.documentCd));
							$("hidLineCdTag").value = unescapeHTML2(row.lineCdTag);
							$("hidYyTag").value = unescapeHTML2(row.yyTag);
							$("hidMmTag").value = unescapeHTML2(row.mmTag);
							
							if ($F("hidLineCdTag") == "N") {
								$("txtDVLineCd").clear();
							}
							if ($F("hidYyTag") == "N") {
								$("txtDVDocYear").clear();
							}
							if ($F("hidMmTag") == "N") {
								$("txtDVDocMm").clear();
							}
							
							toggleDocTag();
							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609DVPaytDtl;
							
							if (isIconClicked) {
								$("txtDVDocumentCd").focus();
							}
						}
					},
					onCancel: function(){
						$("txtDVDocumentCd").focus();
						$("txtDVDocumentCd").value = $("txtDVDocumentCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function(){
						$("txtDVDocumentCd").value = $("txtDVDocumentCd").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVDocumentCd");
					} 
				});
			} catch(e){
				showErrorMessage("showDocumentCdLOV", e);
			}
		}
		
		function showPaytRqstLOV() {
			try {
				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609PaytRqstLOV",
						documentCd : $F("txtDVDocumentCd"),
						page : 1
					},
					title : "Payment Requests",
					width : 600,
					height : 402,
					columnModel : [ {
						id : 'documentCd',
						title : 'Document Cd',
						altTitle : 'Document Code',
						width : '91px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'branchCd',
						title : 'Branch Cd',
						altTitle : 'Branch Code',
						width : '73px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'lineCd',
						title : 'Line Cd',
						altTitle : 'Line Code',
						width : '58px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'docYear',
						title : 'Doc Year',
						altTitle : 'Document Year',
						width : '65px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return value;
						}
					}, {
						id : 'docMm',
						title : 'Doc Mth',
						altTitle : 'Document Month',
						width : '60px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return (value == "" ? "" : lpad(value, 2, 0));
						}
					}, {
						id : 'docSeqNo',
						title : 'Doc Seq No',
						altTitle : 'Document Sequence No',
						width : '78px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return (value == "" ? "" : lpad(value, 6, 0));
						}
					}, {
						id : 'requestDate',
						title : 'Request Date',
						width : '91px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'dspDeptCd',
						title : 'Dept Cd',
						altTitle : 'Department Code',
						width : '60px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return (value == "" ? "" : lpad(value, 2, 0));
						}
					}, {
						id : 'dspDeptName',
						title : 'Department Name',
						width : '200px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'payeeClassCd',
						title : 'Payee Class Cd',
						altTitle : 'Payee Class Code',
						width : '101px',
						align : 'right',
						titleAlign : 'right',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'payeeCd',
						title : 'Payee Cd',
						altTitle : 'Payee Code',
						width : '70px',
						align : 'right',
						titleAlign : 'right',
						renderer : function(value) {
							return value;
						}
					}, {
						id : 'payee',
						title : 'Payee',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'particulars',
						title : 'Particulars',
						width : '450px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'dspFshortName',
						title : 'Currency',
						width : '68px',
						align : 'center',
						titleAlign : 'center',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'currencyRt',
						title : 'Currency Rt',
						altTitle : 'Currency Rate',
						width : '90px',
						align : 'right',
						titleAlign : 'right',
						renderer : function(value) {
							return formatToNineDecimal(value);
						}
					}, {
						id : 'dvFcurrencyAmt',
						title : 'Amount',
						width : '110px',
						align : 'right',
						titleAlign : 'right',
						renderer : function(value) {
							return formatCurrency(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : false,
					onSelect : function(row) {
						showConfirmBox("Confirmation", "The document details provided will be changed to the payment "
								+ "request details of the chosen document code. Do you wish to proceed?",
								"Yes", "No", function() {
									populateDtls(row);
									compared = false;
									changeTag = 1;
									editSw = true;
									changeTagFunc = saveGiacs609DVPaytDtl;
									toggleDVMainFields(false);
									enableButton("btnDelete");
									$("txtDVDocumentCd").focus();
								}, function() {
									$("txtDVDocumentCd").focus();
								}, null);
					},
					onCancel : function() {
						$("txtDVDocumentCd").focus();
					},
					onUndefinedRow : function() {
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVDocumentCd");
					}
				});
			} catch (e) {
				showErrorMessage("showPaytRqstLOV", e);
			}
		}

		function showBranchLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtDVBranchCd").trim() == "" ? "%" : $F("txtDVBranchCd"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609BranchLOV",
						moduleId : "GIACS008", //whats this?
						docCd : $F("txtDVDocumentCd"),
						deptId : $F("txtDVDeptId"),
						searchString : searchString,
						page : 1
					},
					title : "List of Branch Codes",
					width : 380,
					height : 400,
					columnModel : [ {
						id : 'branchCd',
						title : 'Branch Cd',
						altTitle : 'Branch Code',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'branchName',
						title : 'Branch Name',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtDVBranchCd").value = unescapeHTML2(row.branchCd);
							$("txtDVBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));

							if (row.docCdExists == "N") {
								$("txtDVDocumentCd").clear();
								$("txtDVDocumentCd").setAttribute("lastValidValue", "");
								$("hidLineCdTag").value = "";
								$("hidYyTag").value = "";
								$("hidMmTag").value = "";
							} else {
								$("hidLineCdTag").value = unescapeHTML2(row.lineCdTag);
								$("hidYyTag").value = unescapeHTML2(row.yyTag);
								$("hidMmTag").value = unescapeHTML2(row.mmTag);
							}

							if (row.deptIdExists == "N") {
								$("txtDVDeptId").clear();
								$("txtDVDspDeptCd").setAttribute("lastValidValue", "");
								$("txtDVDspDeptCd").clear();
								$("txtDVDspDeptName").clear();
							}
							
							if ($F("hidLineCdTag") == "N") {
								$("txtDVLineCd").clear();
							}
							if ($F("hidYyTag") == "N") {
								$("txtDVDocYear").clear();
							}
							if ($F("hidMmTag") == "N") {
								$("txtDVDocMm").clear();
							}

							toggleDocTag();
							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609DVPaytDtl;
							
							if (isIconClicked) {
								$("txtDVBranchCd").focus();
							}
						}
					},
					onCancel : function() {
						$("txtDVBranchCd").focus();
						$("txtDVBranchCd").value = $("txtDVBranchCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtDVBranchCd").value = $("txtDVBranchCd").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVBranchCd");
					}
				});
			} catch (e) {
				showErrorMessage("showBranchLOV", e);
			}
		}

		function showLineLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtDVLineCd").trim() == "" ? "%" : $F("txtDVLineCd"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609LineLOV",
						searchString : searchString,
						page : 1
					},
					title : "List of Line Codes",
					width : 380,
					height : 400,
					columnModel : [ {
						id : 'lineCd',
						title : 'Line Code',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'lineName',
						title : 'Line Name',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtDVLineCd").value = unescapeHTML2(row.lineCd);
							$("txtDVLineCd").setAttribute("lastValidValue",unescapeHTML2(row.lineCd));

							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609DVPaytDtl;
							
							if (isIconClicked) {
								$("txtDVLineCd").focus();
							}
						}
					},
					onCancel : function() {
						$("txtDVLineCd").focus();
						$("txtDVLineCd").value = $("txtDVLineCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtDVLineCd").value = $("txtDVLineCd").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVLineCd");
					}
				});
			} catch (e) {
				showErrorMessage("showLineLOV", e);
			}
		}

		function showDeptLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtDVDspDeptCd").trim() == "" ? "%" : $F("txtDVDspDeptCd"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609DeptLOV",
						branchCd : $F("txtDVBranchCd"),
						searchString : searchString,
						page : 1
					},
					title : "List of Department Codes",
					width : 380,
					height : 386,
					columnModel : [ {
						id : 'deptCd',
						title : 'Dept Code',
						altTitle : 'Department Code',
						titleAlign : 'right',
						align : 'right',
						width : '85px'
					}, {
						id : 'deptName',
						title : 'Department Name',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtDVDeptId").value = row.deptId;
							$("txtDVDspDeptCd").value = row.deptCd;
							$("txtDVDspDeptCd").setAttribute("lastValidValue", row.deptCd);
							$("txtDVDspDeptName").value = unescapeHTML2(row.deptName);

							if ($F("txtDVRequestDate") == "") {
								$("txtDVRequestDate").value = dateFormat(new Date(), "mm-dd-yyyy");
								validateRequestDate();
							}

							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609DVPaytDtl;
							
							if (isIconClicked) {
								$("txtDVDspDeptCd").focus();
							}
						}
					},
					onCancel : function() {
						$("txtDVDspDeptCd").focus();
						$("txtDVDspDeptCd").value = $("txtDVDspDeptCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtDVDspDeptCd").value = $("txtDVDspDeptCd").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.",imgMessage.INFO, "txtDVDspDeptCd");
					}
				});
			} catch (e) {
				showErrorMessage("showDeptLOV", e);
			}
		}

		function showPayeeClassLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtDVPayeeClassCd").trim() == "" ? "%" : $F("txtDVPayeeClassCd"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "geGiacs609PayeeClassLOV",
						searchString : searchString,
						page : 1
					},
					title : "List of Payee Class Codes",
					width : 380,
					height : 400,
					columnModel : [ {
						id : 'payeeClassCd',
						title : 'Class Code',
						titleAlign : 'right',
						align : 'right',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'classDesc',
						title : 'Description',
						width : '280px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtDVPayeeClassCd").value = unescapeHTML2(row.payeeClassCd);
							$("txtDVPayeeClassCd").setAttribute("lastValidValue", unescapeHTML2(row.payeeClassCd));

							enableSearch("lovPayeeCd");
							$("txtDVPayeeCd").readOnly = false;
							$("txtDVPayeeCd").clear();
							$("txtDVPayeeCd").setAttribute("lastValidValue", "");
							$("txtDVPayee").clear();

							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609DVPaytDtl;
							
							if (isIconClicked) {
								$("txtDVPayeeClassCd").focus();
							}
						}
					},
					onCancel : function() {
						$("txtDVPayeeClassCd").focus();
						$("txtDVPayeeClassCd").value = $("txtDVPayeeClassCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtDVPayeeClassCd").value = $("txtDVPayeeClassCd").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVPayeeClassCd");
					}
				});
			} catch (e) {
				showErrorMessage("showPayeeClassLOV", e);
			}
		}

		function showPayeeLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtDVPayeeCd").trim() == "" ? "%" : $F("txtDVPayeeCd"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609PayeeLOV",
						payeeClassCd : $F("txtDVPayeeClassCd"),
						searchString : searchString,
						page : 1
					},
					title : "List of Payee Codes",
					width : 639,
					height : 386,
					columnModel : [ {
						id : 'payeeNo',
						title : 'Payee Cd',
						altTitle : 'Payee Code',
						titleAlign : 'right',
						align : 'right',
						width : '80px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'payeeLastName',
						title : 'Last Name',
						width : '180px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'payeeFirstName',
						title : 'First Name',
						width : '180px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'payeeMiddleName',
						title : 'Middle Name',
						width : '180px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtDVPayeeCd").value = lpad(row.payeeNo, 12, 0);
							$("txtDVPayeeCd").setAttribute("lastValidValue", lpad(row.payeeNo, 12, 0));
							$("txtDVPayee").value = unescapeHTML2(row.dspPayee);

							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609DVPaytDtl;
							
							if (isIconClicked) {
								$("txtDVPayeeCd").focus();
							}
						}
					},
					onCancel : function() {
						$("txtDVPayeeCd").focus();
						$("txtDVPayeeCd").value = $("txtDVPayeeCd").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtDVPayeeCd").value = $("txtDVPayeeCd").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVPayeeCd");
					}
				});
			} catch (e) {
				showErrorMessage("showPayeeLOV", e);
			}
		}

		function showCurrencyLOV(isIconClicked) {
			try {
				var searchString = isIconClicked ? "%" : ($F("txtDVDspFshortName").trim() == "" ? "%" : $F("txtDVDspFshortName"));

				LOV.show({
					controller : "ACUploadingLOVController",
					urlParameters : {
						action : "getGiacs609CurrencyLOV",
						searchString : searchString,
						page : 1
					},
					title : "List of Currency Codes",
					width : 449,
					height : 386,
					columnModel : [ {
						id : 'shortName',
						title : 'Short Name',
						width : '85px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'currencyDesc',
						title : 'Description',
						width : '150px',
						renderer : function(value) {
							return unescapeHTML2(value);
						}
					}, {
						id : 'mainCurrencyCd',
						title : 'Currency Code',
						titleAlign : 'right',
						align : 'right',
						width : '100px',
						renderer : function(value) {
							return value;
						}
					}, {
						id : 'currencyRt',
						title : 'Rate',
						titleAlign : 'right',
						align : 'right',
						width : '95px',
						renderer : function(value) {
							return formatToNineDecimal(value);
						}
					} ],
					draggable : true,
					autoSelectOneRecord : true,
					filterText : escapeHTML2(searchString),
					onSelect : function(row) {
						if (row != null || row != undefined) {
							$("txtDVCurrencyCd").value = row.mainCurrencyCd;
							$("txtDVDspFshortName").value = unescapeHTML2(row.shortName);
							$("txtDVDspFshortName").setAttribute("lastValidValue", unescapeHTML2(row.shortName));
							$("txtDVCurrencyRt").value = formatToNineDecimal(row.currencyRt);

							if ($F("txtDVDvFcurrencyAmt") != "") {
								getLocalAmt();
							}

							changeTag = 1;
							editSw = true;
							changeTagFunc = saveGiacs609DVPaytDtl;
							
							if (isIconClicked) {
								$("txtDVDspFshortName").focus();
							}
						}
					},
					onCancel : function() {
						$("txtDVDspFshortName").focus();
						$("txtDVDspFshortName").value = $("txtDVDspFshortName").readAttribute("lastValidValue");
					},
					onUndefinedRow : function() {
						$("txtDVDspFshortName").value = $("txtDVDspFshortName").readAttribute("lastValidValue");
						customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVDspFshortName");
					}
				});
			} catch (e) {
				showErrorMessage("showCurrencyLOV", e);
			}
		}

		function getLocalAmt() {
			if ($F("txtDVDvFcurrencyAmt") == "") {
				$("txtDVPaytAmt").value = "";
				return;
			}
			
			if ($F("txtDVCurrencyRt") == "") {
				$("txtDVPaytAmt").value = $F("txtDVDvFcurrencyAmt");
				return;
			}
			
			var localAmt = (parseFloat($F("txtDVCurrencyRt")) * unformatCurrencyValue($F("txtDVDvFcurrencyAmt")));
			localAmt = Number(Math.round(localAmt + 'e2') + 'e-2'); // 2 in e2/e-2 represents number of decimal

			$("txtDVPaytAmt").value = formatCurrency(localAmt);
		}

		function validateRequestDate() {
			if ($F("txtDVRequestDate") != "") {
				if (compareDatesIgnoreTime(Date.parse($F("txtDVRequestDate")), new Date()) == 0) {
					if ($F("hidYyTag") == "Y") {
						$("txtDVDocYear").value = dateFormat(new Date(), "yyyy");
					}
					if ($F("hidMmTag") == "Y") {
						$("txtDVDocMm").value = dateFormat(new Date(), "mm");
					}
				} else {
					var type = (compareDatesIgnoreTime(Date.parse($F("txtDVRequestDate")), new Date()) == -1) ? "future" : "previous";
					var reqDateArray = $("txtDVRequestDate").value.split("-");
					showWaitingMessageBox("Please note that this is a " + type + " date.", imgMessage.INFO, function() {
						compared = true;
						if ($F("hidYyTag") == "Y") {
							$("txtDVDocYear").value = reqDateArray[2];
						}
						if ($F("hidMmTag") == "Y") {
							$("txtDVDocMm").value = reqDateArray[0];
						}
						$("txtDVRequestDate").focus();
					});
				}
	
				changeTag = 1;
				editSw = true;
				changeTagFunc = saveGiacs609DVPaytDtl;
			}
		}
		
		/* functions: button */
		function saveGiacs609DVPaytDtl(closeOverlay) {
			try {
				if ((changeTag == 1 && editSw && checkAllRequiredFieldsInDiv('dvPaytDtlDiv'))
						|| (changeTag == 1 && !editSw)) {
					var setRec = new Array();
					var delRec = new Array();

					if (deleteSw) {
						var obj = new Object();
						obj.sourceCd = guf.sourceCd;
						obj.fileNo = guf.fileNo;
						delRec.push(obj);
					}

					if (editSw) {
						var obj = setObj();
						setRec.push(obj);
					}

					new Ajax.Request(
						contextPath + "/GIACUploadingController",
						{
							method : "POST",
							parameters : {
								action : "saveGiacs609DVPaytDtl",
								delRec : prepareJsonAsParameter(delRec),
								setRec : prepareJsonAsParameter(setRec),
								sourceCd : guf.sourceCd,
								fileNo : guf.fileNo
							},
							onCreate : showNotice("Saving DV Payment Details, please wait..."),
							onComplete : function(response) {
								hideNotice();

								if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)) {
									changeTagFunc = "";
									changeTag = 0;
									deleteSw = false;
									editSw = false;
									objGUDV = JSON.parse(response.responseText);
									if (!compared && compareDatesIgnoreTime(Date.parse($F("txtDVRequestDate")), new Date()) != 0) {
										compared = true;
										var type = (compareDatesIgnoreTime(Date.parse($F("txtDVRequestDate")), new Date()) == -1) ? "future" : "previous";
										showWaitingMessageBox("Please note that this is a " + type + " date.", imgMessage.INFO, function() {
											showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
												if (closeOverlay) {
													overlayDVPaytDtl.close();
												} else {
													initAll();
												}
											});
										});
									} else {
										showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function() {
											if (closeOverlay) {
												overlayDVPaytDtl.close();
											} else {
												initAll();
											}
										});
									}
								}
							}
						});
				}
			} catch (e) {
				showErrorMessage("saveGiacs609DVPaytDtl", e);
			}
		}
		
		/* functions: populate */
		function initAll() {
			if (deleteSw || objGUDV.requestDate == undefined) {
				if (guf.fileStatus == "1") {
					$("txtDVDocumentCd").value = unescapeHTML2(parameters.documentCd);
					$("txtDVDocumentCd").setAttribute("lastValidValue", unescapeHTML2(parameters.documentCd));
					$("txtDVBranchCd").value = unescapeHTML2(parameters.branchCd);
					$("txtDVBranchCd").setAttribute("lastValidValue", unescapeHTML2(parameters.branchCd));
					$("hidLineCdTag").value = unescapeHTML2(parameters.lineCdTag);
					$("hidYyTag").value = unescapeHTML2(parameters.yyTag);
					$("hidMmTag").value = unescapeHTML2(parameters.mmTag);
				}
				
				$("txtDVLineCd").setAttribute("lastValidValue", "");
				$("txtDVDspDeptCd").setAttribute("lastValidValue", "");
				$("txtDVPayeeClassCd").setAttribute("lastValidValue", "");
				$("txtDVPayeeCd").setAttribute("lastValidValue", "");
				$("txtDVDspFshortName").setAttribute("lastValidValue", "");
				$("txtDVPayeeCd").readOnly = true;
				$("txtDVParticulars").clear();
				disableSearch("lovPayeeCd");
				disableButton("btnDelete");
				toggleDVMainFields(true);
				toggleDocTag();
			} else {
				populateDtls(objGUDV);
				toggleDVMainFields(false);
				enableButton("btnDelete");
			}
			
			if (guf.fileStatus == "1") {
				$("txtDVDocumentCd").focus();
				initializeChangeTagBehavior(saveGiacs609DVPaytDtl);
				initializeAllMoneyFields();
			} else {
				$("btnReturn").focus();
				$$("div#dvPaytDtlDiv input[type='text'], div#dvPaytDtlDiv textarea, div#dvPaytDtlDiv div").each(function(o) {
					$(o).readOnly = true;
					
					if ($(o).hasClassName('required')) {
						$(o).removeClassName("required");
						$(o).disabled = true;
						if ($(o).nodeName == "DIV") {
							$(o).style.backgroundColor = "#d4d0c8";
						}
					}
				});

				$$("div#dvPaytDtlDiv img[name='dvPaytLov']").each(function(o) {
					disableSearch($(o).id);
				});

				disableDate("hrefRequestDate");
				disableButton("btnDelete");
				disableButton("btnSave");
			}
		}

		function toggleDVMainFields(enable) {
			var itemFields = [ "DocumentCd", "BranchCd", "LineCd", "DspDeptCd" ];
			
			for (var i = 0; i < itemFields.length; i++) {
				$("txtDV" + itemFields[i]).readOnly = (enable ? false : true);
				enable ? enableSearch("lov" + itemFields[i]) : disableSearch("lov" + itemFields[i]);
				enable ? $("txtDV" + itemFields[i]).removeAttribute ("ignoreDelKey")
					   : $("txtDV" + itemFields[i]).setAttribute ("ignoreDelKey", "1");
			}
			
			enable ? enableSearch("lovDocSeqNo") : disableSearch("lovDocSeqNo");
			enable ? enableDate("hrefRequestDate") : disableDate("hrefRequestDate");
			enable ? $("txtDVRequestDate").removeAttribute ("ignoreDelKey")
					   : $("txtDVRequestDate").setAttribute ("ignoreDelKey", "1");
		}
		
		function toggleDocTag() {
			var reqDateArray = $("txtDVRequestDate").value.split("-");
			if ($F("hidLineCdTag") == "Y") {
				enableSearch("lovLineCd");
				$("txtDVLineCd").addClassName("required");
				$("lovLineCdDiv").addClassName("required");
				$("txtDVLineCd").readOnly = false;
				$("txtDVLineCd").setAttribute("tabIndex", "303");
			} else {
				disableSearch("lovLineCd");
				$("txtDVLineCd").removeClassName("required");
				$("lovLineCdDiv").removeClassName("required");
				$("txtDVLineCd").readOnly = true;
				$("txtDVLineCd").setAttribute("tabIndex", "-1");
			}

			if ($F("hidYyTag") == "Y") {
				$("txtDVDocYear").addClassName("required");
				if ($F("txtDVRequestDate") != "") {
					$("txtDVDocYear").value = reqDateArray[2];
				}
				$("txtDVDocYear").setAttribute("tabIndex", "304");
			} else {
				$("txtDVDocYear").removeClassName("required");
				$("txtDVDocYear").setAttribute("tabIndex", "-1");
			}

			if ($F("hidMmTag") == "Y") {
				$("txtDVDocMm").addClassName("required");
				if ($F("txtDVRequestDate") != "") {
					$("txtDVDocMm").value = reqDateArray[0];
				}
				$("txtDVDocMm").setAttribute("tabIndex", "305");
			} else {
				$("txtDVDocMm").removeClassName("required");
				$("txtDVDocMm").setAttribute("tabIndex", "-1");
			}
		}
		
		function setObj() {
			var obj = new Object();

			obj.sourceCd = escapeHTML2(guf.sourceCd);
			obj.fileNo = guf.fileNo;
			obj.documentCd = escapeHTML2($F("txtDVDocumentCd"));
			obj.branchCd = escapeHTML2($F("txtDVBranchCd"));
			obj.lineCd = escapeHTML2($F("txtDVLineCd"));
			obj.docYear = $F("txtDVDocYear");
			obj.docMm = $F("txtDVDocMm");
			obj.docSeqNo = $F("txtDVDocSeqNo");
			obj.goucOucId = $F("txtDVDeptId");
			obj.requestDate = escapeHTML2($F("txtDVRequestDate"));
			obj.payeeClassCd = $F("txtDVPayeeClassCd");
			obj.payeeCd = $F("txtDVPayeeCd");
			obj.payee = escapeHTML2($F("txtDVPayee"));
			obj.particulars = escapeHTML2($F("txtDVParticulars"));
			obj.dvFcurrencyAmt = unformatCurrencyValue($F("txtDVDvFcurrencyAmt"));
			obj.currencyRt = $F("txtDVCurrencyRt");
			obj.paytAmt = unformatCurrencyValue($F("txtDVPaytAmt"));
			obj.currencyCd = $F("txtDVCurrencyCd");
			obj.tranId = $F("hidTranId") == undefined ? "" : $F("hidTranId");

			return obj;
		}
		
		function populateDtls(row) {
			if (row != null || row != undefined) {			
				$("txtDVDocumentCd").value = unescapeHTML2(row.documentCd);
				$("txtDVDocumentCd").setAttribute("lastValidValue", unescapeHTML2(row.documentCd));
				$("txtDVBranchCd").value = unescapeHTML2(row.branchCd);
				$("txtDVBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
				$("txtDVLineCd").value = unescapeHTML2(row.lineCd);
				$("txtDVLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
				$("txtDVDocYear").value = row.docYear;
				$("txtDVDocMm").value = lpad(row.docMm, 2, 0);
				$("txtDVDocSeqNo").value = lpad(row.docSeqNo, 6, 0);
				$("txtDVRequestDate").value = unescapeHTML2(row.requestDate);
				$("txtDVDeptId").value = row.deptId;
				$("txtDVDspDeptCd").value = row.dspDeptCd;
				$("txtDVDspDeptCd").setAttribute("lastValidValue", unescapeHTML2(row.dspDeptCd));
				$("txtDVDspDeptName").value = unescapeHTML2(row.dspDeptName);
				$("txtDVPayeeClassCd").value = row.payeeClassCd;
				$("txtDVPayeeClassCd").setAttribute("lastValidValue", unescapeHTML2(row.payeeClassCd));
				$("txtDVPayeeCd").value = lpad(row.payeeCd, 12, 0);
				$("txtDVPayeeCd").setAttribute("lastValidValue", lpad(row.payeeCd, 12, 0));
				$("txtDVPayee").value = unescapeHTML2(row.payee);
				$("txtDVParticulars").value = unescapeHTML2(row.particulars);
				$("txtDVCurrencyCd").value = row.currencyCd;
				$("txtDVDspFshortName").value = unescapeHTML2(row.dspFshortName);
				$("txtDVDspFshortName").setAttribute("lastValidValue", unescapeHTML2(row.dspFshortName));
				$("txtDVDvFcurrencyAmt").value = formatCurrency(row.dvFcurrencyAmt);
				$("txtDVCurrencyRt").value = formatToNineDecimal(row.currencyRt);
				$("txtDVPaytAmt").value = formatCurrency(row.paytAmt);
				$("hidTranId").value = row.tranId == undefined ? "" : row.tranId;
				$("hidLineCdTag").value = unescapeHTML2(row.lineCdTag);
				$("hidYyTag").value = unescapeHTML2(row.yyTag);
				$("hidMmTag").value = unescapeHTML2(row.mmTag);
				$("txtDVDspLshortName").value = unescapeHTML2(parameters.dfltCurrencySname);
				enableSearch("lovPayeeCd");
				toggleDocTag();
			}
		}
		
		/* populate */
		initAll();
		initializeAll();
	} catch (e) {
		showErrorMessage("Page Error", e);
	}
</script>