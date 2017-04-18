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
					<input type="hidden" id="varDocumentName" name="varDocumentName" readOnly="readOnly"/>
					<input type="hidden" id="varLineCdTag" name="varLineCdTag" readOnly="readOnly"/>
					<input type="hidden" id="varYyTag" name="varYyTag" readOnly="readOnly"/>
					<input type="hidden" id="varMmTag" name="varMmTag" readOnly="readOnly"/>
					<div style="width: 61px; float: left; height: 21px;" class="withIconDiv required">
						<input style="width: 35px;" id="txtDVDocumentCd" name="txtDVDocumentCd" type="text" value=""  class="withIcon required" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovDocumentCd" name="dvPaytLov" alt="Go"/>
					</div>
					<div id="lovBranchCdDiv" style="width: 51px; height: 21px; float: left; margin-left: 0px;" class="required withIconDiv">
						<input style="width: 25px;" id="txtDVBranchCd" name="txtDVBranchCd" type="text" value="" class="required withIcon" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovBranchCd" name="dvPaytLov" alt="Go" />
					</div>
					<div id="lovLineCdDiv" style="width: 51px; height: 21px; float: left; margin-left: 0px;" class="withIconDiv">
						<input style="width: 25px;" id="txtDVLineCd" name="txtDVLineCd" type="text" value="" class="withIcon" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovLineCd" name="dvPaytLov" alt="Go" />
					</div>
					<input style="width: 50px; text-align: right;" type="text" id="txtDVDocYear" name="txtDVDocYear"  class="required" maxlength="4" readOnly="readOnly"/>
					<input style="width: 35px; text-align: right;" type="text" id="txtDVDocMm" name="txtDVDocMm"  class="required" maxlength="2" readOnly="readOnly"/>
					<input style="width: 55px; text-align: right;" type="text" id="txtDVDocSeqNo" name="txtDVDocSeqNo" readOnly="readOnly" />
				</td>
				
				<td class="rightAligned" style="width: 80px; padding-right: 4px;">Date</td>
				<td class="leftAligned">
					<div style="width: 220px; height: 21px;" class="required withIconDiv">
			    		<input style="width: 195px;" type="text" id="txtDVRequestDate" name="txtDVRequestDate" readOnly="readOnly" maxlength="10" class="required withIcon" triggerChange = "Y"/>
			    		<img class="disabled" id="hrefRequestDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" alt="Request Date" onClick="scwShow($('txtRequestDate'),this, null);" />
			    	</div>	
				</td>
			</tr>	
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Department</td>
				<td class="leftAligned">
					<input type="hidden" id="txtDVOucId" name="txtDVOucId" readOnly="readOnly"/>
					<div style="width: 71px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 45px; text-align: right;" id="txtDVOucCd" name="txtDVOucCd" type="text" value="" class="withIcon required" ignoreDelKey="1"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovOucCd" name="dvPaytLov" alt="Go" class=""/>
					</div>
					<input style="width: 268px;" id="txtDVOucName" name="txtDVOucName" type="text" value="" readOnly="readOnly" class="required" />
				</td>
			</tr>	
		</table>
	</div>	
	<div class="sectionDiv" id="disbursementRequestsDiv3" changeTagAttr="true" style="width: 800px;">
		<table border="0" align="center" style="margin: 10px;">
			<tr>
				<td class="rightAligned" style="padding-right: 4px;" >Payee</td>
				<td class="leftAligned" colspan="3">
					<div style="width: 81px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 56px; text-align: right;" id="txtDVPayeeClassCd" name="txtDVPayeeClassCd" type="text" value="" class="withIcon required" ignoreDelKey="1"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeClassCd" name="dvPaytLov" alt="Go" />
					</div>
					<div style="width: 161px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 135px; text-align: right;" id="txtDVPayeeCd" name="txtDVPayeeCd" type="text" value="" class="withIcon required" ignoreDelKey="1"/>
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovPayeeCd" name="dvPaytLov" alt="Go" />
					</div>
					<input style="width: 403px;" type="text" id="txtDVPayee" name="txtDVPayee" readOnly="readOnly"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Particulars</td>
				<td class="leftAligned" colspan="3">
					<div style="float: left; width: 663px;" class="withIconDiv required">
						<textarea onKeyDown="limitText(this,2000);" onKeyUp="limitText(this,2000);" id="txtDVParticulars" name="txtDVParticulars" style="width: 633px; resize:none;" class="withIcon required"> </textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editParticulars" />
					</div>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Amount</td>
				<td class="leftAligned" style="width: 310px;">
					<input type="hidden" id="txtDVCurrencyCd" name="txtDVCurrencyCd" value="" readOnly="readOnly" />
					<div style="width: 51px; height: 21px; float: left;" class="withIconDiv required">
						<input style="width: 25px;" id="txtDVNbtFshortName" name="txtDVNbtFshortName" type="text" value="" class="withIcon required" />
						<img style="float: right;" src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="lovNbtFshortName" name="dvPaytLov" alt="Go" />
					</div>
					<input style="width: 155px;" type="text" id="txtDVDvFcurrencyAmt" name="txtDVDvFcurrencyAmt" class="money required" maxlength="18" errorMsg="Invalid Amount. Valid value should be from 0.01 to 99999999999999.99" min="0.01" max="99999999999999.99"/>
				</td>
				<td class="rightAligned" style="width: 127px; padding-right: 4px;">Local Amount</td>
				<td class="leftAligned">
					<input style="width: 45px;" type="text" id="txtDVNbtShortName" name="txtDVNbtShortName" readOnly="readOnly"/>
					<input style="width: 155px;" type="text" id="txtDVPaytAmt" name="txtDVPaytAmt" readOnly="readOnly" class="money"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned" style="padding-right: 4px;">Conversion Rate</td>
				<td class="leftAligned"><input style="width: 212px; text-align: right;" type="text" id="txtDVCurrencyRt" name="txtDVCurrencyRt" readOnly="readOnly" class="nthDecimal required" maxlength="13" errorMsg="Field must be of form 99,999,999,999,990.99" min="-999,999,999,999.999999999" max="999,999,999,999.999999999" nthDecimal="9"/></td>
			</tr>
		</table>
	</div>		
		
	<div class="buttonsDiv" style="margin: 10px 0 0 0;">
		<input type="button" id="btnDelete" class="button" value="Delete" style="width: 90px;"/>
	</div>	
		
	<div class="buttonsDiv" style="margin: 10px 0 0 0;">
		<input type="button" id="btnSave" class="button" value="Save" style="width: 90px;"/>
		<input type="button" id="btnReturn" class="button" value="Return" style="width: 90px;"/>
	</div>
</div>

<script type="text/javascript">
try{
	var objGUDV = JSON.parse('${jsonGUDV}');
	var defaultCurrency = '${defaultCurrency}';
	var defaultCurrencyCd = '${defaultCurrencyCd}';
	var defaultCurrencyRt = '${defaultCurrencyRt}';
	
	var deleteSw = false;
	var editSw = false;
	
	function initAll(){
		if (objGUDV.sourceCd == undefined && objGUDV.fileNo == undefined){
			$("txtDVBranchCd").value = unescapeHTML2(parameters.branchCd);
			$("txtDVBranchCd").setAttribute("lastValidValue", unescapeHTML2(parameters.branchCd));
			disableSearch("lovLineCd");
			$("txtDVLineCd").readOnly = true;
			disableSearch("lovPayeeCd");
			$("txtDVPayeeCd").readOnly = true;
			
			$("txtDVDocumentCd").focus();
			disableButton("btnDelete");
		}else{
			$("txtDVDocumentCd").value = unescapeHTML2(objGUDV.documentCd);
			$("txtDVDocumentCd").setAttribute("lastValidValue", unescapeHTML2(objGUDV.documentCd));
			$("txtDVBranchCd").value = unescapeHTML2(objGUDV.branchCd);
			$("txtDVBranchCd").setAttribute("lastValidValue", unescapeHTML2(objGUDV.branchCd));
			$("txtDVLineCd").value = unescapeHTML2(objGUDV.lineCd);
			$("txtDVLineCd").setAttribute("lastValidValue", unescapeHTML2(objGUDV.lineCd));
			$("txtDVDocYear").value = objGUDV.docYear;
			$("txtDVDocMm").value = objGUDV.docMm;
			$("txtDVDocSeqNo").value = objGUDV.docSeqNo;
			$("txtDVRequestDate").value = dateFormat(objGUDV.requestDate, "mm-dd-yyyy");
			$("txtDVOucId").value = objGUDV.goucOucId;
			$("txtDVOucCd").value = objGUDV.nbtOucCd;
			$("txtDVOucCd").setAttribute("lastValidValue", unescapeHTML2(objGUDV.nbtOucCd));
			$("txtDVOucName").value = unescapeHTML2(objGUDV.nbtOucName);
			$("txtDVPayeeClassCd").value = objGUDV.payeeClassCd;
			$("txtDVPayeeClassCd").setAttribute("lastValidValue", unescapeHTML2(objGUDV.payeeClassCd));
			$("txtDVPayeeCd").value = objGUDV.payeeCd;
			$("txtDVPayeeCd").setAttribute("lastValidValue", unescapeHTML2(objGUDV.payeeCd));
			$("txtDVPayee").value = unescapeHTML2(objGUDV.payee);
			$("txtDVParticulars").value = unescapeHTML2(objGUDV.particulars);
			$("txtDVCurrencyCd").value = objGUDV.currencyCd;
			$("txtDVNbtFshortName").value = unescapeHTML2(objGUDV.nbtFshortName);
			$("txtDVNbtFshortName").setAttribute("lastValidValue", unescapeHTML2(objGUDV.nbtFshortName));
			$("txtDVDvFcurrencyAmt").value = formatCurrency(objGUDV.dvFcurrencyAmt);
			$("txtDVCurrencyRt").value = formatToNineDecimal(objGUDV.currencyRt);
			$("txtDVNbtShortName").value = unescapeHTML2(objGUDV.nbtShortName);
			$("txtDVPaytAmt").value = formatCurrency(objGUDV.paytAmt);
			
			$F("txtDVDocYear") == "" ? $("txtDVDocYear").removeClassName("required") : $("txtDVDocYear").addClassName("required");
			$F("txtDVDocMm") == "" ? $("txtDVDocMm").removeClassName("required") : $("txtDVDocMm").addClassName("required");

			enableButton("btnDelete");
			toggleDVMainFields(false);
		}
		
		$("txtDVNbtShortName").value = unescapeHTML2(defaultCurrency);
		
		if (guf.tranClass == "" || guf.tranClass == null){
			initializeChangeTagBehavior(saveGiacs607DVPaytDtl);
			initializeAllMoneyFields();
		}else{
			$$("div#dvPaytDtlDiv input[type='text'], div#dvPaytDtlDiv textarea").each(function (o) {
				$(o).readOnly = true;
			});
			
			$$("div#dvPaytDtlDiv img[name='dvPaytLov']").each(function (o) {
				disableSearch($(o).id);
			});
			
			disableDate("hrefRequestDate");
			
			disableButton("btnDelete");
			disableButton("btnSave");
		}
	}
	
	function toggleDVMainFields(enable){
		var itemFields = ["DocumentCd", "BranchCd", "LineCd", "OucCd"];

		for (var i = 0; i < itemFields.length; i++) {
			$("txtDV"+itemFields[i]).readOnly = (enable ? false : true);
			
			enable ? enableSearch("lov"+itemFields[i]) : disableSearch("lov"+itemFields[i]);
		}
		
		enable ? enableDate("hrefRequestDate") : disableDate("hrefRequestDate");
	}
	
	function showDocumentCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtDVDocumentCd").trim() == "" ? "%" : $F("txtDVDocumentCd"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607DocumentCdLOV",
					fundCd:	parameters.fundCd,
					branchCd: $F("txtDVBranchCd"),
					searchString: searchString,
					page : 1
				},
				title : "List of Document Codes",
				width : 400,
				height : 400,
				columnModel : [ 
					{
						id : "documentCd",
						title : "Document Cd",
						width : '100px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "documentName",
						title : "Document Name",
						width : '280px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDVDocumentCd").value = unescapeHTML2(row.documentCd);
						$("txtDVDocumentCd").setAttribute("lastValidValue", unescapeHTML2(row.documentCd));
						$("varLineCdTag").value = unescapeHTML2(row.lineCdTag);
						$("varYyTag").value = unescapeHTML2(row.yyTag);
						$("varMmTag").value = unescapeHTML2(row.mmTag);
						
						if ($F("varLineCdTag") == "Y") {
							enableSearch("lovLineCd"); 
							$("txtDVLineCd").addClassName("required");
							$("lovLineCdDiv").addClassName("required");
							$("txtDVLineCd").readOnly = false;
						}else{
							disableSearch("lovLineCd");
							$("txtDVLineCd").removeClassName("required");
							$("lovLineCdDiv").removeClassName("required");
							$("txtDVLineCd").readOnly = true;
							$("txtDVLineCd").clear();
						}
						
						if ($F("varYyTag") == "Y") {
							$("txtDVDocYear").addClassName("required");
							if ($F("txtDVRequestDate") != ""){
								$("txtDVDocYear").value = dateFormat($F("txtDVRequestDate"), "yyyy");
							} 
						}else{
							$("txtDVDocYear").removeClassName("required");
							$("txtDVDocYear").clear();
						}
						
						if ($F("varMmTag") == "Y") {
							$("txtDVDocMm").addClassName("required");
							if ($F("txtDVRequestDate") != ""){
								$("txtDVDocMm").value = dateFormat($F("txtDVRequestDate"), "mm");
							} 
						}else{
							$("txtDVDocMm").removeClassName("required");
							$("txtDVDocMm").clear();
						}
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607DVPaytDtl;
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
		}catch(e){
			showErrorMessage("showDocumentCdLOV", e);
		}
	}
	
	function showBranchCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtDVBranchCd").trim() == "" ? "%" : $F("txtDVBranchCd"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607DVBranchCdLOV",
					fundCd:	parameters.fundCd,
					docCd: $F("txtDVDocumentCd"),
					oucId:	$F("txtDVOucId"),
					searchString: searchString,
					page : 1
				},
				title : "List of Branch Codes",
				width : 380,
				height : 400,
				columnModel : [ 
					{
						id : "branchCd",
						title : "Branch Cd",
						width : '80px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "branchName",
						title : "Branch Name",
						width : '280px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDVBranchCd").value = unescapeHTML2(row.branchCd);
						$("txtDVBranchCd").setAttribute("lastValidValue", unescapeHTML2(row.branchCd));
						
						if (row.docCdExists == "N"){
							$("txtDVDocumentCd").clear();
							$("txtDVDocumentCd").setAttribute("lastValidValue", "");
						}
						
						if (row.oucIdExists == "N"){
							$("txtDVOucId").clear();
							$("txtDVOucCd").setAttribute("lastValidValue", "");
							$("txtDVOucCd").clear();
							$("txtDVOucName").clear();
						}
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607DVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtDVBranchCd").focus();
					$("txtDVBranchCd").value = $("txtDVBranchCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtDVBranchCd").value = $("txtDVBranchCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVBranchCd");
				} 
			});
		}catch(e){
			showErrorMessage("showBranchCdLOV", e);
		}
	}
	
	function showLineCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtDVLineCd").trim() == "" ? "%" : $F("txtDVLineCd"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607LineCdLOV",
					searchString: searchString,
					page : 1
				},
				title : "List of Line Codes",
				width : 380,
				height : 400,
				columnModel : [ 
					{
						id : "lineCd",
						title : "Line Cd",
						width : '80px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "lineName",
						title : "Line Name",
						width : '280px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDVLineCd").value = unescapeHTML2(row.lineCd);
						$("txtDVLineCd").setAttribute("lastValidValue", unescapeHTML2(row.lineCd));
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607DVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtDVLineCd").focus();
					$("txtDVLineCd").value = $("txtDVLineCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtDVLineCd").value = $("txtDVLineCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVLineCd");
				} 
			});
		}catch(e){
			showErrorMessage("showLineCdLOV", e);
		}
	}
	
	function showOucCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtDVOucCd").trim() == "" ? "%" : $F("txtDVOucCd"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607OucCdLOV",
					fundCd:	parameters.fundCd,
					branchCd:	$F("txtDVBranchCd"),
					searchString: searchString,
					page : 1
				},
				title : "List of Department Codes",
				width : 380,
				height : 400,
				columnModel : [ 
					{
						id : "oucCd",
						title : "Code",
						titleAlign: 'right',
						align: 'right',
						width : '80px'
					}, 
					{
						id : "oucName",
						title : "Department Name",
						width : '280px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDVOucId").value = row.oucId;
						$("txtDVOucCd").value = row.oucCd;
						$("txtDVOucCd").setAttribute("lastValidValue", unescapeHTML2(row.oucCd));
						$("txtDVOucName").value = unescapeHTML2(row.oucName);
						
						if ($F("txtDVRequestDate") == ""){
							$("txtDVRequestDate").value = dateFormat(new Date(), "mm-dd-yyyy");
							validateRequestDate(false);
						}
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607DVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtDVOucCd").focus();
					$("txtDVOucCd").value = $("txtDVOucCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtDVOucCd").value = $("txtDVOucCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVOucCd");
				} 
			});
		}catch(e){
			showErrorMessage("showOucCdLOV", e);
		}
	}

	function showPayeeClassCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtDVPayeeClassCd").trim() == "" ? "%" : $F("txtDVPayeeClassCd"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607PayeeClassCdLOV",
					searchString: searchString,
					page : 1
				},
				title : "List of Payee Class Codes",
				width : 380,
				height : 400,
				columnModel : [ 
					{
						id : "payeeClassCd",
						title : "Code",
						titleAlign: 'right',
						align: 'right',
						width : '80px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "classDesc",
						title : "Description",
						width : '280px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDVPayeeClassCd").value = unescapeHTML2(row.payeeClassCd);
						$("txtDVPayeeClassCd").setAttribute("lastValidValue", unescapeHTML2(row.payeeClassCd));

						enableSearch("lovPayeeCd");
						$("txtDVPayeeCd").readOnly = false;
						$("txtDVPayeeCd").clear();
						$("txtDVPayeeCd").setAttribute("lastValidValue", "");
						$("txtDVPayee").clear();
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607DVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtDVPayeeClassCd").focus();
					$("txtDVPayeeClassCd").value = $("txtDVPayeeClassCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtDVPayeeClassCd").value = $("txtDVPayeeClassCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVPayeeClassCd");
				} 
			});
		}catch(e){
			showErrorMessage("showPayeeClassCdLOV", e);
		}
	}

	function showPayeeCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtDVPayeeCd").trim() == "" ? "%" : $F("txtDVPayeeCd"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607PayeeCdLOV",
					payeeClassCd: $F("txtDVPayeeClassCd"),
					searchString: searchString,
					page : 1
				},
				title : "List of Payee Codes",
				width : 650,
				height : 386,
				columnModel : [ 
					{
						id : "payeeNo",
						title : "Payee Cd",
						titleAlign: 'right',
						align: 'right',
						width : '80px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "payeeLastName",
						title : "Last Name",
						width : '180px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "payeeFirstName",
						title : "First Name",
						width : '180px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "payeeMiddleName",
						title : "Middle Name",
						width : '180px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDVPayeeCd").value = unescapeHTML2(row.payeeNo);
						$("txtDVPayeeCd").setAttribute("lastValidValue", unescapeHTML2(row.payeeCd));
						$("txtDVPayee").value = unescapeHTML2(row.nbtDerivePayee);
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607DVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtDVPayeeCd").focus();
					$("txtDVPayeeCd").value = $("txtDVPayeeCd").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtDVPayeeCd").value = $("txtDVPayeeCd").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVPayeeCd");
				} 
			});
		}catch(e){
			showErrorMessage("showPayeeCdLOV", e);
		}
	}
	
	function showCurrencyCdLOV(isIconClicked){
		try{
			var searchString = isIconClicked? "%" : ($F("txtDVNbtFshortName").trim() == "" ? "%" : $F("txtDVNbtFshortName"));	
			
			LOV.show({
				controller : "ACUploadingLOVController",
				urlParameters : {
					action : "getGIACS607CurrencyCdLOV",
					searchString: searchString,
					page : 1
				},
				title : "List of Currency Codes",
				width : 400,
				height : 386,
				columnModel : [ 
					{
						id : "shortName",
						title : "Name",
						width : '70px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "currencyDesc",
						title : "Description",
						width : '200px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}, 
					{
						id : "mainCurrencyCd",
						title : "Currency Code",
						titleAlign: 'right',
						align: 'right',
						width : '100px',
						renderer: function(value){
							return unescapeHTML2(value);
						}
					}
				],
				draggable : true,
				autoSelectOneRecord: true,
				filterText: escapeHTML2(searchString),
				onSelect : function(row) {
					if(row != null || row != undefined){
						$("txtDVCurrencyCd").value = row.mainCurrencyCd;
						$("txtDVNbtFshortName").value = unescapeHTML2(row.shortName);
						$("txtDVNbtFshortName").setAttribute("lastValidValue", unescapeHTML2(row.shortName));
						$("txtDVCurrencyRt").value = formatToNineDecimal(row.currencyRt);

						if ($F("txtDVDvFcurrencyAmt") != ""){
							getLocalAmt();
						}
						
						changeTag = 1;
						editSw = true;
						changeTagFunc = saveGiacs607DVPaytDtl;
					}
				},
				onCancel: function(){
					$("txtDVNbtFshortName").focus();
					$("txtDVNbtFshortName").value = $("txtDVNbtFshortName").readAttribute("lastValidValue");
				},
				onUndefinedRow : function(){
					$("txtDVNbtFshortName").value = $("txtDVNbtFshortName").readAttribute("lastValidValue");
					customShowMessageBox("No record selected.", imgMessage.INFO, "txtDVNbtFshortName");
				} 
			});
		}catch(e){
			showErrorMessage("showCurrencyCdLOV", e);
		}
	}
	
	function getLocalAmt(){
		if ($F("txtDVCurrencyRt") == "" || $F("txtDVDvFcurrencyAmt") == "") return;
		
		var localAmt = (parseFloat($F("txtDVCurrencyRt")) * parseFloat($F("txtDVDvFcurrencyAmt")));
		localAmt = Number(Math.round(localAmt + 'e2') + 'e-2'); // 2 in e2/e-2 represents number of decimal
		
		$("txtDVPaytAmt").value = formatCurrency(localAmt);
	}
		
	function validateRequestDate(compareDates){
		if (compareDates == false || (compareDatesIgnoreTime(Date.parse($F("txtDVRequestDate")), new Date()) == 0)){
			if ($F("varYyTag") == "Y"){
				$("txtDVDocYear").value = dateFormat(new Date(), "yyyy");
			}
			if ($F("varMmTag") == "Y"){
				$("txtDVDocMm").value = dateFormat(new Date(), "mm");
			}
		}else{
			var type = (compareDatesIgnoreTime(Date.parse($F("txtDVRequestDate")), new Date()) == -1) ? "future" : "previous";
			
			showWaitingMessageBox("Please note that this is a " + type + " date.", "I", function(){
				if ($F("varYyTag") == "Y"){
					$("txtDVDocYear").value = dateFormat($F("txtDVRequestDate"), "yyyy");
				}
				if ($F("varMmTag") == "Y"){
					$("txtDVDocMm").value = dateFormat($F("txtDVRequestDate"), "mm");
				}
			});
		}
		
		changeTag = 1;
		editSw = true;
		changeTagFunc = saveGiacs607DVPaytDtl;
	}
	
	function setObj(){	
		var obj = new Object();
		
		obj.sourceCd = guf.sourceCd;
		obj.fileNo = guf.fileNo;
		obj.documentCd = escapeHTML2($F("txtDVDocumentCd"));
		obj.branchCd =  escapeHTML2($F("txtDVBranchCd"));
		obj.lineCd =  escapeHTML2($F("txtDVLineCd"));
		obj.docYear = $F("txtDVDocYear");
		obj.docMm = $F("txtDVDocMm");
		obj.docSeqNo = $F("txtDVDocSeqNo");
		obj.requestDate = dateFormat($F("txtDVRequestDate"), "mm-dd-yyyy");
		obj.goucOucId = $F("txtDVOucId");
		obj.oucCd = $F("txtDVOucCd");
		obj.oucName =  escapeHTML2($F("txtDVOucName"));
		obj.payeeClassCd = $F("txtDVPayeeClassCd");
		obj.payeeCd = $F("txtDVPayeeCd");
		obj.payee =  escapeHTML2($F("txtDVPayee"));
		obj.particulars =  escapeHTML2($F("txtDVParticulars"));
		obj.currencyCd = $F("txtDVCurrencyCd");
		obj.nbtFshortName =  escapeHTML2($F("txtDVNbtFshortName"));
		obj.dvFcurrencyAmt = unformatCurrencyValue($F("txtDVDvFcurrencyAmt"));
		obj.currencyRt = $F("txtDVCurrencyRt");
		obj.nbtShortName =  escapeHTML2($F("txtDVNbtShortName"));
		obj.paytAmt = unformatCurrencyValue($F("txtDVPaytAmt"));
		
		return obj;
	}
	
	function saveGiacs607DVPaytDtl(closeOverlay){
		try{
			if ((changeTag == 1 && editSw && checkAllRequiredFieldsInDiv('dvPaytDtlDiv')) ||
					(changeTag == 1 && !editSw)){
				var setRec = new Array();
				var delRec = new Array();
				
				if (deleteSw){
					var obj = new Object();
					obj.sourceCd = guf.sourceCd;
					obj.fileNo = guf.fileNo;
					delRec.push(obj);
				}
				
				if (editSw){
					var obj = setObj();
					setRec.push(obj);
				}
				
				new Ajax.Request(contextPath + "/GIACUploadingController",{
					method: "POST",
					parameters:{
						action:		"saveGIACS607DVPaytDtl",
						delRec:		prepareJsonAsParameter(delRec),
						setRec:		prepareJsonAsParameter(setRec),
						sourceCd:	guf.sourceCd,
						fileNo:		guf.fileNo
					},
					onCreate: showNotice("Saving DV Payment Details, please wait..."),
					onComplete: function(response){
						hideNotice();
						
						if (checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
							changeTagFunc = "";
							changeTag = 0;
							deleteSw = false;
							editSw = false;
							objGUDV = JSON.parse(response.responseText);
							showWaitingMessageBox(objCommonMessage.SUCCESS, imgMessage.SUCCESS, function(){
								if (closeOverlay){
									overlayDVPaytDtl.close();
								}else{
									initAll();
								}
							});
						}
					}
				});
			}
		}catch(e){
			showErrorMessage("saveGiacs607DVPaytDtl", e);
		}
	}
	
	$("lovDocumentCd").observe("click", function(){
		showDocumentCdLOV(true);
	});
	
	$("txtDVDocumentCd").observe("change", function(){
		if (this.value != ""){
			showDocumentCdLOV(false);
		}else{
			$("txtDVDocumentCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("lovBranchCd").observe("click", function(){
		showBranchCdLOV(true);
	});
	
	$("txtDVBranchCd").observe("change", function(){
		if (this.value != ""){
			showBranchCdLOV(false);
		}else{
			$("txtDVBranchCd").setAttribute("lastValidValue", "");
			$("txtDVDocumentCd").clear();
			$("txtDVDocumentCd").setAttribute("lastValidValue", "");
		}
	});

	$("lovLineCd").observe("click", function(){
		showLineCdLOV(true);
	});
	
	$("txtDVLineCd").observe("change", function(){
		if (this.value != ""){
			showLineCdLOV(false);
		}else{
			$("txtDVLineCd").setAttribute("lastValidValue", "");
		}
	});
	
	$("txtDVDocYear").observe("focus", function(){
		if ($F("varYyTag") == "Y" && this.value == ""){
			this.value = dateFormat(new Date(), "yyyy");
		}
	});
	
	$("txtDVDocMm").observe("focus", function(){
		if ($F("varMmTag") == "Y" && this.value == ""){
			this.value = dateFormat(new Date(), "mm");
		}
	});
	
	$("lovOucCd").observe("click", function(){
		showOucCdLOV(true);
	});
	
	$("txtDVOucCd").observe("change", function(){
		if (this.value != ""){
			showOucCdLOV(false);
		}else{
			$("txtDVOucCd").setAttribute("lastValidValue", "");
			$("txtDVOucId").clear();
			$("txtDVOucName").clear();			
		}
	});
	
	$("hrefRequestDate").observe("click", function() {
		scwNextAction = validateRequestDate.runsAfterSCW(this, null);
		
		scwShow($("txtDVRequestDate"),this, null);
	});
	
	$("txtDVOucCd").observe("blur", function(){
		if ($F("txtDVRequestDate") == ""){
			$("txtDVRequestDate").value = dateFormat(new Date(), "mm-dd-yyyy");
		}
	});
	
	$("lovPayeeClassCd").observe("click", function(){
		showPayeeClassCdLOV(true);
	});
	
	$("txtDVPayeeClassCd").observe("change", function(){
		if (this.value != ""){
			showPayeeClassCdLOV(false);
		}else{
			$("txtDVPayeeClassCd").setAttribute("lastValidValue", "");
			disableSearch("lovPayeeCd");
			$("txtDVPayeeCd").readOnly = true;
			$("txtDVPayeeCd").clear();
			$("txtDVPayeeCd").setAttribute("lastValidValue", "");
			
		}
	});
	
	$("lovPayeeCd").observe("click", function(){
		showPayeeCdLOV(true);
	});
	
	$("txtDVPayeeCd").observe("change", function(){
		if (this.value != ""){
			showPayeeCdLOV(false);
		}else{
			$("txtDVPayeeCd").setAttribute("lastValidValue", "");
			$("txtDVPayee").clear();
		}
	});
	
	$("editParticulars").observe("click", function(){
		showOverlayEditor("txtDVParticulars", 2000, $("txtDVParticulars").hasAttribute("readonly"), function(){
			changeTag = 1;
			editSw = true;
		});
	});
	
	$("txtDVNbtFshortName").observe("focus", function(){
		if ($F("txtDVNbtFshortName") == ""){
			$("txtDVNbtFshortName").value = unescapeHTML2(defaultCurrency);
			$("txtDVNbtFshortName").setAttribute("lastValidValue", $F("txtDVNbtFshortName"));
			$("txtDVCurrencyCd").value = defaultCurrencyCd;
			$("txtDVCurrencyRt").value = formatToNineDecimal(defaultCurrencyRt);
			changeTag = 1;
			editSw = true;
		}
	});
		
	$("lovNbtFshortName").observe("click", function(){
		showCurrencyCdLOV(true);
	});
	
	$("txtDVNbtFshortName").observe("change", function(){
		if (this.value != ""){
			showCurrencyCdLOV(false);
		}else{
			$("txtDVNbtFshortName").setAttribute("lastValidValue", "");
			$("txtDVCurrencyRt").clear();
		}
	});
	
	$("txtDVDvFcurrencyAmt").observe("change", function(){
		getLocalAmt();
	});
	
	$("btnDelete").observe("click", function(){
		deleteSw = true;
		editSw = false;
		changeTag = 1;
		changeTagFunc = saveGiacs607DVPaytDtl;
		
		var divId = "dvPaytDtlDiv";		
		$$("div#"+divId+" input[type='text'], div#"+divId+" textarea").each(function (o) {
			$(o).clear();
		});
		
		$("txtDVBranchCd").value = unescapeHTML2(parameters.branchCd);
		$("txtDVNbtShortName").value = unescapeHTML2(defaultCurrency);
		$("txtDVDocumentCd").focus();
		
		toggleDVMainFields(true);
	});
	
	$("btnReturn").observe("click", function(){
		if(changeTag == 1){
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveGiacs607DVPaytDtl(true);
					}, 
					function(){
						overlayDVPaytDtl.close();
						changeTag = 0;
					}, "");
		} else {
			overlayDVPaytDtl.close();
		}
		
	});
	
	observeSaveForm("btnSave", saveGiacs607DVPaytDtl);
		
	$$("div#dvPaytDtlDiv input[type='text'], div#dvPaytDtlDiv textarea").each(function (o) {
		$(o).observe("change", function(){
			editSw = true;
			changeTag = 1;
			changeTagFunc = saveGiacs607DVPaytDtl;
		});
	});
	
	initAll();
	
}catch(e){
	showErrorMessage("Page Error", e);
}
</script>