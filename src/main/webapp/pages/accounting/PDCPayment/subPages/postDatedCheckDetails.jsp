<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>
<div id="detailsDiv" name="detailsDiv">
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Details</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label id="showDetails" name="gro" style="margin-left: 5px;">Hide</label>
	   		</span>
	   	</div>
	</div>
	<div id="detailsContentsDiv" name="detailsContentsDiv" style="" class="sectionDiv">
		<div id="postDatedCheckDtlsDiv" name="postDatedCheckDtlsDiv" style="margin-bottom: 10px; height: 188px; width: 100%; float: left;">
			<div id="postDatedChecksDtlsTable" name="postDatedChecksDtlsTable" style="float: left; width: 98.5%; position: relative; margin: 6px; height: 160px;">
				<%-- <jsp:include page="/pages/accounting/PDCPayment/subPages/postDatedCheckDetails.jsp"></jsp:include> --%>
			</div>
		</div>
		<div style="margin-bottom: 15px; width: 100%; float: left;">
			<div style="width: 100%; float: left; vertical-align: bottom; height: 20px;">
				<input type="button" class="button" id="btnUpdate" name="btnUpdate" style="margin-left: 185px; height: 15px; width: 15px; -moz-border-radius: 3px; float: left;" tabindex="401"/><label style="float: left; margin-left: 5px;">Update</label>
				<label style="float: left; margin-left: 207px; height: 18px; padding-top: 4px;">Total Collection Amt</label>
				<input style="text-align: right; float: left; margin-left: 8px; width: 220px;" readonly="readonly" type="text" id="txtTotalCollectionAmt" name="txtTotalCollectionAmt"  tabindex="403"/>
			</div>
			<div style="width: 100%; float: left;"><input type="button" class="button" id="btnSpecUpdate" name="btnSpecUpdate" style="margin-left: 185px; margin-top: 5px; height: 15px; width: 15px; -moz-border-radius: 3px; float: left;"  tabindex="402"/><label style="float: left; margin-left: 5px; margin-top: 7px;">Specific Update</label></div>
			<!-- benjo 11.08.2016 SR-5802 -->
			<div id="updateFlagDiv" style="width: 100%; float: left; margin-left: 185px; margin-top: 10px; display: none;">
				<input title="Assured" type="radio" id="assdRB" name="updateFlag" value="A" style="margin: 0 3px 0 2px; float: left;" checked="true"><label for="assdRB">A</label>
				<input title="Intermediary" type="radio" id="intmRB" name="updateFlag" value="I" style="margin: 0 3px 0 15px; float: left;"><label for="intmRB">I</label>
			</div>
			<!-- end SR-5802 -->
		</div>
		<div id="premCollnFormDiv" style="width: 100%; float: left;" changeTagAttr="true">
			<table style="margin-left: 70px;">
				<tr>
					<td class="rightAligned">Transaction Type</td>
					<td class="leftAligned" colspan="2">
						<select id="selTranType" title="Transaction Type" name="selTranType" style="float: left; width: 228px;" class="required" tabindex="404">
							<option></option>
							<c:forEach var="tranType" items="${tranTypeLOV}">
								<c:if test="${tranType.rvLowValue eq 1 or tranType.rvLowValue eq 3}"> <!-- kenneth SR 20856 12.02.2015 -->
									<option value="${tranType.rvLowValue}">${tranType.rvLowValue} - ${tranType.rvMeaning}</option>
								</c:if>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned">Assured Name</td>
					<td class="leftAligned">
						<input readonly="readonly" title="Assured Name" type="text" id="txtAssdName" name="txtAssdName" style="float: left; width: 220px;" tabindex="411">
					</td>						
				</tr>
				<tr>
					<td class="rightAligned">Bill No</td>
					<td class="leftAligned">
						<input class="required" title="Issue Code" type="text" id="txtIssCd" name="txtIssCd" style="float: left; width: 60px;" tabindex="405">
					</td>
					<td class="leftAligned">
						<span class="required lovSpan" style="width: 149px; margin-right: 15px;">						
							<input type="text" title="Bill No" id="txtPremSeqNo" name="txtPremSeqNo" style="width: 123px; float: left; border: none; height: 14px; margin: 0; text-align: right;" class="required" tabindex="406"></input>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchBill" name="btnSearchBill" alt="Go" style="float: right;" />
						</span>
					</td>
					<td class="rightAligned">Policy/Endorsement No.</td>
					<td class="leftAligned">
						<input readonly="readonly" title="Policy/Endorsement No." type="text" id="txtPolicyEndtNo" name="txtPolicyEndtNo" style="float: left; width: 220px;" tabindex="412">
						<input type="hidden" id="hidPremCollnAddress1" />
						<input type="hidden" id="hidPremCollnAddress2" />
						<input type="hidden" id="hidPremCollnAddress3" />
						<input type="hidden" id="hidPremCollnIntmNo" />
						<input type="hidden" id="hidPremCollnIntmName" />
						<input type="hidden" id="txtPremAmt" /> <!-- bonok :: 3.21.2016 :: UCPB SR 21681 --> 
						<input type="hidden" id="txtTaxAmt" /> <!-- bonok :: 3.21.2016 :: UCPB SR 21681 -->
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Installment No.</td>
					<td class="leftAligned" colspan="2">
						<span class="required lovSpan" style="width: 225px; margin-right: 15px;">
							<input type="text" title="Installment No." id="txtInstNo" name="txtInstNo" style="width: 200px; float: left; border: none; height: 14px; margin: 0; text-align: right;" class="required" tabindex="407"></input>  
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchInst" name="btnSearchInst" alt="Go" style="float: right;"/>
						</span>
					</td>
					<!-- bonok :: 3.21.2016 :: UCPB SR 21681 -->
					<!-- <td class="rightAligned">Premium Amount</td> 
					<td class="leftAligned"><input type="text" title="Premium Amount" id="txtPremAmt" name="txtPremAmt" style="float: left; width: 220px; text-align: right;" readonly="readonly" tabindex="413"></td> -->
					<td class="rightAligned">Collection Amount</td> <!-- bonok :: 3.21.2016 :: UCPB SR 21681 -->
					<td class="leftAligned" colspan="2"><input type="text" title="Collection Amount" class="money required" id="txtCollectionAmt" name="txtCollectionAmt" style="float: left; width: 220px; text-align: right;" tabindex="408" maxlength="14"></td>
				</tr>
				<!-- bonok :: 3.21.2016 :: UCPB SR 21681 -->
				<!-- <tr> 
					<td class="rightAligned">Collection Amount</td>
					<td class="leftAligned" colspan="2"><input type="text" title="Collection Amount" class="money required" id="txtCollectionAmt" name="txtCollectionAmt" style="float: left; width: 220px; text-align: right;" tabindex="408" maxlength="14"></td>
					<td class="rightAligned">Tax Amount</td>
					<td class="leftAligned"><input type="text" id="txtTaxAmt" title="Tax Amount" name="txtTaxAmt" style="float: left; width: 220px; text-align: right;" readonly="readonly" tabindex="414"></td>						
				</tr> -->
				<tr>
					<td class="rightAligned">Currency</td>
					<td class="leftAligned" colspan="2">
						<select id="selDtlCurrency" name="selDtlCurrency" title="Currency" style="float: left; width: 228px;" class="required" tabindex="409" disabled="disabled">
							<option></option>
							<c:forEach var="curr" items="${currency}">
								<option value="${curr.code}" currencyRt="${curr.valueFloat}">${curr.desc}</option>
							</c:forEach>
						</select>
					</td>
					<td class="rightAligned">Foreign Currency Amt.</td>
					<td class="leftAligned"><input type="text" class="money" title="Foreign Currency Amount" id="txtDtlFCurrencyAmt" name="txtDtlFCurrencyAmt" style="float: left; width: 220px; text-align: right;" tabindex="415" readonly="readonly"></td>				
				</tr>
				<tr>
					<td class="rightAligned">Rate</td>
					<td class="leftAligned" colspan="2"><input type="text" title="Rate" class="rate" id="txtDtlCurrencyRt" name="txtDtlCurrencyRt" style="float: left; width: 220px; text-align: right;" tabindex="410"></td>				
					<td class="rightAligned"></td>
					<td class="leftAligned">
						<!-- benjo 11.08.2016 SR-5802 -->
						<div id="pdcDtlPolicyDiv" style="display: none;">
							<input type="button" class="button" id="btnPdcDtlPolicy" name="btnPdcDtlPolicy" value="Policy" enValue="Policy" style="width: 100px;"/>
						</div>
					</td>
				</tr>
			</table>		
		</div>		
		<div style="margin-top: 15px; margin-bottom: 15px; float: left; width: 100%;" align="center" changeTagAttr="true">
			<input type="button" class="button" id="btnPdcDtlAdd" name="btnPdcDtlAdd" value="Add" enValue="Add" tabindex="416"/>
			<input type="button" class="button" id="btnPdcDtlDelete" name="btnPdcDtlDelete" value="Delete" enValue="Delete" tabindex="417"/>
		</div>
	</div>
</div>
<script type="text/javascript">	
	var selectedDtlRowIndex;
	objCurrGIACPdcPremColln = null;
	giacPdcPremCollns = new Object();
	
	var postDatedChecksObj = new Object();
	postDatedChecksObj.pdcDtlsTableGrid = {};
	postDatedChecksObj.pdcDtls = postDatedChecksObj.pdcDtlsTableGrid.rows || [];
	var pdcId = postDatedChecksObj.pdcDtlsTableGrid.pdcId;
		
/* 	if(giacPdcPremCollns.rows != undefined){
		for (var i = 0; i < giacPdcPremCollns.rows.length; i++){
			if (giacPdcPremCollns.rows[i].pdcId == pdcId){
				postDatedChecksObj.pdcDtls.push(giacPdcPremCollns.rows[i]);
			}	
		}
	} */ 
		
	var postDatedCheckDetailsTableModel = {
		url: contextPath+"/GIACAcknowledgmentReceiptsController?action=refreshPostDatedChecksDetailsTable&pdcId="+pdcId,
		options: {
			querySort: false,
			onCellFocus:  function (element, value, x, y, id){
				var mtgId = postDatedCheckDetailsTableGrid._mtgId;					
				if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
					selectedDtlRowIndex = y;
					if(y < 0){
						var length = postDatedCheckDetailsTableGrid.geniisysRows.length;
						y = ((length - 1) + Math.abs(y)) - postDatedCheckDetailsTableGrid.newRowsAdded.length;						
					}
					objCurrGIACPdcPremColln = postDatedCheckDetailsTableGrid.geniisysRows[y];					
					setPdcDtlForm(objCurrGIACPdcPremColln);
					postDatedCheckDetailsTableGrid.keys.removeFocus(postDatedCheckDetailsTableGrid.keys._nCurrentFocus, true);
					postDatedCheckDetailsTableGrid.keys.releaseKeys();
				}
			},

			onCellBlur: function (element, value, x, y, id){
				
			},

			onRemoveRowFocus: function (){
				objCurrGIACPdcPremColln = null;
				setPdcDtlForm(null);
				postDatedCheckDetailsTableGrid.keys.removeFocus(postDatedCheckDetailsTableGrid.keys._nCurrentFocus, true);
				postDatedCheckDetailsTableGrid.keys.releaseKeys();
			},

			onDelete: function(){
				
			}
		},
		columnModel: [
            {
            	id: 'recordStatus', 	
            	visible: false,
 			    width: '0'			     	
            },
			{
				id: 'divCtrId',
				width: '0',
				visible: false
			},
			{
				id: 'tranType',		
				width: '0',
				visible: false				
			},
			{
				id: 'tranTypeDesc',		
				width: '150px',
				title: 'Transaction Type'				
			},
			{
				id: 'issCd',
				width: '80px',
				title: 'Issue Code'
			},
			{
				id: 'premSeqNo',
			    //width: '100px',
			    width : '105px',
				align: 'right',
				titleAlign : 'right',
				renderer: function (value){
					return formatNumberDigits(nvl(value, 0),12);
				},
				title: 'Bill/CM No.'
			},
			{
				id: 'instNo',
				width: '80px',
				align: 'right',
				renderer: function (value){
					return formatNumberDigits(nvl(value, 0),2);
				},
				title: 'Inst No.'
			},
			{
				id: 'collnAmt',
				width: '120px',
				visible: true,
				title: 'Collection Amt',
				align: 'right',
		        renderer: function (value){
					return formatCurrency(value);
				}
			},
			{
				id: 'assdNo',
				width: "0",
				visible: false
			},
			{
				id: 'assdName',
				width: "170px",
				title: "Assured Name"
			},
			{
				id: 'policyId',
				width: "0",
				visible: false
			},
			{
				id: 'policyNo',
				width: "150px",
				title: "Policy/Endt No"
			},
			{
				id: 'premAmt',
				width: "0",
				visible: false
			},
			{
				id: 'taxAmt',
				width: "0",
				visible: false
			},
			{
				id: 'currCd',
				width: "0",
				visible: false
			},
			{
				id: 'currRt',
				width: "0",
				visible: false
			},
			{
				id: 'fCurrAmt',
				width: "0",
				visible: false
			},
			{
				id: 'pdcId',
				width: '0',
				visible: false
			}
		],
		rows: []
	};

	postDatedCheckDetailsTableGrid = new MyTableGrid(postDatedCheckDetailsTableModel);
	postDatedCheckDetailsTableGrid.pager = postDatedChecksObj.pdcDtlsTableGrid;
	postDatedCheckDetailsTableGrid.render('postDatedChecksDtlsTable');

	function computeTotalCollnAmt(){	
		var total = 0;
		
		for (var i=0; i<postDatedCheckDetailsTableGrid.geniisysRows.length; i++){
			if(postDatedCheckDetailsTableGrid.geniisysRows[i].recordStatus != -1){
				var val = postDatedCheckDetailsTableGrid.geniisysRows[i].collnAmt;
				total += parseFloat(val.replace(/,/g, ''));
			}			
		}
		$("txtTotalCollectionAmt").value = formatCurrency(total);
	}
	
	function setPdcDtlForm(row){
		try {
			$("hidPdcId").value = row == null ? "" : row.pdcId;
			$("selTranType").value = row == null ? "" : row.tranType;
			$("txtIssCd").value = row == null ? "" : row.issCd;
			$("txtPremSeqNo").value = row == null ? "" : formatNumberDigits(row.premSeqNo, 12);
			$("txtInstNo").value = row == null ? "" : formatNumberDigits(row.instNo, 2);
			$("txtCollectionAmt").value = row == null ? "" : formatCurrency(row.collnAmt);
			$("txtCollectionAmt").writeAttribute("oldCollnAmt", row == null ? 0 : row.collnAmt);
			$("selDtlCurrency").value = row == null ? "${defaultCurrency}" : row.currCd;
			$("txtDtlCurrencyRt").value = row == null ? formatToNineDecimal($("selDtlCurrency").options[$("selDtlCurrency").selectedIndex].getAttribute("currencyRt")) : formatToNineDecimal(row.currRt);
			$("txtDtlFCurrencyAmt").value = row == null ? "" : formatCurrency(row.fCurrAmt);
			$("txtPremAmt").value = row == null ? "" : formatCurrency(row.premAmt);
			$("txtTaxAmt").value = row == null ? "" : formatCurrency(row.taxAmt);
			
			$("txtAssdName").value = row == null ? "" : unescapeHTML2(row.assdName);
			$("txtPolicyEndtNo").value = row == null ? "" : row.policyNo;
			$("hidPremCollnAddress1").value  = row == null ? "" : unescapeHTML2(row.address1);
			$("hidPremCollnAddress2").value  = row == null ? "" : unescapeHTML2(row.address2);
			$("hidPremCollnAddress3").value  = row == null ? "" : unescapeHTML2(row.address3);
			$("hidPremCollnIntmNo").value  = row == null ? "" : row.intmNo;
			$("hidPremCollnIntmName").value  = row == null ? "" : unescapeHTML2(row.intmName);			
			
			$("btnPdcDtlAdd").setAttribute("enValue", row == null ? "Add" : "Update");
			$("btnPdcDtlAdd").value = row == null ? "Add" : "Update";
			if(row == null){
				if(!($F("statusCd") == "P" && $("txtCheckFlag").readAttribute("checkFlag") == "A")){
					$("txtIssCd").removeAttribute("readonly");
					$("txtPremSeqNo").removeAttribute("readonly");
					//$("txtInstNo").removeAttribute("readonly");
					enableSearch("searchBill");
					//enableSearch("searchInst");
					$("txtPremAmt").removeAttribute("readonly"); // bonok :: 01.10.2013 :: UCPBGEN-QA SR: 11836
				}
			} else {
				$("txtIssCd").writeAttribute("readonly");
				$("txtPremSeqNo").writeAttribute("readonly");
				//$("txtInstNo").writeAttribute("readonly");
				disableSearch("searchBill");
				//disableSearch("searchInst");
				if(row.recordStatus == "0" || row.recordStatus == "1"){ // bonok :: 01.10.2013 :: UCPBGEN-QA SR: 11836
					$("txtPremAmt").removeAttribute("readonly"); 
				}else{
					$("txtPremAmt").setAttribute("readonly", "readonly");
				}
			}
		} catch(e){
			showErrorMessage("setPdcDtlForm", e);
		}
	
	}

	function createPdcDtl(obj){
		try {
			var prem = (obj == null ? new Object() : obj);			
			prem.recordStatus = (obj == null ? 0 : 1);
			prem.pdcId = objCurrGIACApdcPaytDtl.pdcId == "" || objCurrGIACApdcPaytDtl.pdcId == null ? null : objCurrGIACApdcPaytDtl.pdcId;
			prem.tranType = $F("selTranType");
			prem.tranTypeDesc = $("selTranType").options[$("selTranType").selectedIndex].text;
			prem.issCd = $F("txtIssCd");
			prem.premSeqNo = $F("txtPremSeqNo");
			prem.instNo = $F("txtInstNo");
			prem.collnAmt = $F("txtCollectionAmt");
			prem.currCd = $F("selDtlCurrency");
			prem.currRt = $F("txtDtlCurrencyRt");
			prem.fCurrAmt = $F("txtDtlFCurrencyAmt");
			prem.premAmt = $F("txtPremAmt");
			prem.taxAmt = $F("txtTaxAmt");
			
			prem.currDesc = $("selDtlCurrency").options[$("selCurrency").selectedIndex].text;
			prem.assdName = $F("txtAssdName");
			prem.policyNo = $F("txtPolicyEndtNo");
			prem.address1 = $F("hidPremCollnAddress1");
			prem.address2 = $F("hidPremCollnAddress2");
			prem.address3 = $F("hidPremCollnAddress3");
			prem.intmNo = $F("hidPremCollnIntmNo");
			prem.intmName = $F("hidPremCollnIntmName");	
			return prem;
		} catch (e){
			showErrorMessage("createPdcDtl", e);
		}			
	}
	
	function addPdcDtl(){
		try {
			if(objCurrGIACApdcPaytDtl == null){
				showMessageBox("Please select a post-dated check record first.", imgMessage.INFO);
			} else if(checkAllRequiredFieldsInDiv("detailsContentsDiv")){
				var pdcDtl = createPdcDtl();				
				if($("btnPdcDtlAdd").getAttribute("enValue") == "Add"){				
					if(giacPdcPremCollns.rows == undefined){
						giacPdcPremCollns.rows = [];
					} 

					/* for(var i=0; i<giacPdcPremCollns.rows.length; i++){
						if(giacPdcPremCollns.rows[i].issCd == $F("txtIssCd") && giacPdcPremCollns.rows[i].premSeqNo == $F("txtPremSeqNo") && giacPdcPremCollns.rows[i].instNo == $F("txtInstNo") && giacPdcPremCollns.rows[i].recordStatus != -1){
							showWaitingMessageBox("Row already exists with the same Transaction Type, Issuing Source, Bill No., and Installment No.", "I", function(){});
							return false;
						}
					} */					
					
					giacPdcPremCollns.rows.push(pdcDtl);
					postDatedCheckDetailsTableGrid.addBottomRow(pdcDtl);
				} else {					
					if(giacPdcPremCollns.rows == undefined){
						giacPdcPremCollns.rows = [];
					}
					
					postDatedCheckDetailsTableGrid.updateRowAt(pdcDtl, selectedDtlRowIndex);
				}
				
				setPdcDtlForm(null);
				computeTotalCollnAmt();
				objGIACApdcPayt.pdcPremChangeTag = 1;
				objGIACApdcPayt.enableDisablePostDatedCheckForm();
			}						
		} catch (e){
			showErrorMessage("addPdcDtl", e);
		}
	}
	
	function deletePdcDtl(){
		if(selectedDtlRowIndex != null) {
			objCurrGIACPdcPremColln.recordStatus = -1;
			if(giacPdcPremCollns.rows == undefined){
				giacPdcPremCollns.rows = [];
			}
			//giacPdcPremCollns.deletedRows.push(objCurrGIACPdcPremColln);			
			postDatedCheckDetailsTableGrid.deleteRow(selectedDtlRowIndex);
			postDatedCheckDetailsTableGrid.keys.removeFocus(postDatedCheckDetailsTableGrid.keys._nCurrentFocus, true);
			postDatedCheckDetailsTableGrid.keys.releaseKeys();			
			setPdcDtlForm(null);
			computeTotalCollnAmt();
			objGIACApdcPayt.pdcPremChangeTag = 1;
			objGIACApdcPayt.enableDisablePostDatedCheckForm();
		}
	}
	
	function recomputeBreakDown(){
		if($F("selTranType") != "" && $F("txtIssCd") != "" && $F("txtPremSeqNo") != "" && $F("txtInstNo") != ""){
			new Ajax.Request(contextPath + "/GIACAcknowledgmentReceiptsController", {
					method : "GET",
					parameters : {action 			: "getBreakdownAmounts",
								  transactionType 	: $F("selTranType"),
								  issCd 			: $F("txtIssCd"),
								  premSeqNo 		: $F("txtPremSeqNo"),
								  instNo 			: $F("txtInstNo"),
								  collectionAmt 	: $F("txtCollectionAmt")},
					onComplete: function(response){
						if(checkErrorOnResponse(response)){
							var result = JSON.parse(response.responseText);
							$("txtPremAmt").value = formatCurrency(result.premiumAmt);
							$("txtTaxAmt").value = formatCurrency(result.taxAmt);
						}
					}
				});
		}
	}
	
	function updateDtlForeignCurrency(){
		if($F("txtCollectionAmt") != "" && $F("txtDtlCurrencyRt") != ""){
			$("txtDtlFCurrencyAmt").value = formatCurrency(parseFloat(nvl($F("txtCollectionAmt"), "0").replace(/,/g, "")) / parseFloat($F("txtDtlCurrencyRt")));
		}
	}
	
	function onDtlCurrencyChange(){
		$("txtDtlCurrencyRt").value = formatToNineDecimal($("selDtlCurrency").options[$("selDtlCurrency").selectedIndex].getAttribute("currencyRt"));
		updateDtlForeignCurrency();
	}
	
	function onSelectBill(row){
		if(row.totalBalAmtDue == 0){
			showWaitingMessageBox("Bill No. " + $F("txtIssCd")+"-"+$F("txtPremSeqNo")+" is already settled.", imgMessage.INFO, 
					function(){								
						$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("origPremSeqNo") == null ? "" : formatNumberDigits($("txtPremSeqNo").readAttribute("origPremSeqNo"), 12);
						$("txtPremSeqNo").focus();
					});
		} else {
			$("txtPremSeqNo").writeAttribute("origPremSeqNo", $F("txtPremSeqNo"));
			$("txtPremSeqNo").value = formatNumberDigits(row.premSeqNo, 12);
			$("txtAssdName").value = unescapeHTML2(row.assdName);
			$("txtPolicyEndtNo").value = row.policyNo;

			if($F("txtInstNo") != ""){
				getInstInfo();
			} else if(row.instCount == 1 && row.dfltInstNo != null){
				$("txtInstNo").value = row.dfltInstNo;
				getInstInfo();
			} else if(row.instCount > 1){
				onSearchInstClick();
			}
		}
	}
	
	giacPdcPremCollns.onSelectBill = onSelectBill;
	giacPdcPremCollns.setPdcDtlForm = setPdcDtlForm;
	giacPdcPremCollns.computeTotalCollnAmt = computeTotalCollnAmt;
	function getBillInfo(){
		new Ajax.Request(contextPath+"/GIACAgingSoaDetailController", {
			method: "GET",
			parameters: {action : "getBillInfo",
					     issCd : $F("txtIssCd"),
					     premSeqNo : $F("txtPremSeqNo"),
					     tranType : $("selTranType").value},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					if(response.responseText == "{}"){
						showWaitingMessageBox("Bill No. does not exist.", imgMessage.INFO, 
							function(){								
								$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("origPremSeqNo") == null ? "" : formatNumberDigits($("txtPremSeqNo").readAttribute("origPremSeqNo"), 12);
								$("txtPremSeqNo").focus();
							});					
					} else {
						var row = JSON.parse(response.responseText);
						onSelectBill(row);
					}
				} else {
					showMessageBox("Query failed.", imgMessage.ERROR);
				}
			}
		});
	}
	
	function getInstInfo(){
		new Ajax.Request(contextPath+"/GIACAgingSoaDetailController", {
			method: "GET",
			parameters: {action : "getInstInfo",
					     issCd : $F("txtIssCd"),
					     premSeqNo : $F("txtPremSeqNo"),
					     instNo : $F("txtInstNo")},
			onComplete : function(response){
				if(checkErrorOnResponse(response)){
					//if(response.responseText == "{}"){ //marco - 04.15.2013 - replaced condition
					var row = JSON.parse(response.responseText);
					if(nvl(row.instNo, "") == ""){
						//showWaitingMessageBox("Installment No. does not exist.", imgMessage.INFO, //marco - 04.15.2013 - replaced message
						showWaitingMessageBox("This Installment No. does not exist in GIPI_INSTALLMENT.", imgMessage.INFO,
							function(){
								$("txtInstNo").value = $("txtInstNo").readAttribute("origInstNo") == null ? "" : formatNumberDigits($("txtInstNo").readAttribute("origInstNo"), 2);
								$("txtInstNo").focus();
							});
					} else {						
						$("txtInstNo").writeAttribute("origInstNo", $F("txtInstNo"));
						$("txtInstNo").value = formatNumberDigits(row.instNo, 2);
						$("txtCollectionAmt").writeAttribute("origCollectionAmt", row.balAmtDue);
						$("txtCollectionAmt").writeAttribute("balancAmtDue", row.balAmtDue);
						$("txtCollectionAmt").value = formatCurrency(row.balAmtDue);
						$("txtPremAmt").value = formatCurrency(row.premBalDue);
						$("txtTaxAmt").value = formatCurrency(row.taxBalDue);
						//marco - UCPB SR 20856 - 11.26.2015
						$("selDtlCurrency").value = row.currencyCd;
						$("txtDtlCurrencyRt").value = formatToNineDecimal(row.currencyRt);
						if($F("txtCollectionAmt") != "" && $F("txtDtlCurrencyRt") != ""){
							$("txtDtlFCurrencyAmt").value = formatCurrency(parseFloat(nvl($F("txtCollectionAmt"), "0").replace(/,/g, "")) / parseFloat($F("txtDtlCurrencyRt")));
						}
					}
				} else {
					showMessageBox("Query failed.", imgMessage.ERROR);
				}
			}
		});
	}
	
	function onSearchInstClick(){
		if($F("txtIssCd") != "" && $F("txtPremSeqNo") != ""){
			var notIn = "";
			var withPrevious = false;
			var rows = postDatedCheckDetailsTableGrid.geniisysRows;
			for(var i=0; i<rows.length; i++){
				if(rows[i].issCd == $F("txtIssCd") && formatNumberDigits(rows[i].premSeqNo, 12) == $F("txtPremSeqNo") && nvl(rows[i].recordStatus, 0) != -1){ //marco - 04.17.2013 - added recordStatus condition
					if(withPrevious) notIn += ",";
					notIn += rows[i].instNo;
					withPrevious = true;	
				}
			}

			notIn = (notIn != "" ? "("+notIn+")" : "");
			showInstNoLOV($F("txtIssCd"), $F("txtPremSeqNo"), notIn);
		}
	}
	
	function updateParticulars(obj){
		try {
			// header portion
			if((update.mode == 0 || update.specific.payor) && ($F("hdrDtlsPayor") == "" || $F("hdrDtlsPayor") == "-")){ //benjo 11.08.2016 SR-5802
				$("hdrDtlsPayor").value = obj.payor;
			}			
			if(update.mode == 0 || update.specific.address){
				$("txtApdcAddress1").value = obj.address1;
				$("txtApdcAddress2").value = obj.address2;
				$("txtApdcAddress3").value = obj.address3;
			}
			if(update.mode == 0 || update.specific.particulars){
				$("payorParticulars").value = obj.apdcParticulars;
			}
			
			// particulars portion
			if((update.mode == 0 || update.specific.payor) && ($F("txtParticularsPayor") == "" || $F("txtParticularsPayor") == "-")){ //benjo 11.08.2016 SR-5802
				$("txtParticularsPayor").value = obj.payor;
				objCurrGIACApdcPaytDtl.payor = obj.payor;
			}			
			if(update.mode == 0 || update.specific.address){
				$("txtAddress1").value = obj.address1;
				$("txtAddress2").value = obj.address2;
				$("txtAddress3").value = obj.address3;
				objCurrGIACApdcPaytDtl.address1 = obj.address1;
				objCurrGIACApdcPaytDtl.address2 = obj.address2;
				objCurrGIACApdcPaytDtl.address3 = obj.address3;
			}
			if(update.mode == 0 || update.specific.intermediary){
				$("txtIntermediary").value = obj.intmName;
				objCurrGIACApdcPaytDtl.intmNo 	= obj.intmNo;
				objCurrGIACApdcPaytDtl.intermediary = obj.intmName;
			}
			if(update.mode == 0 || update.specific.particulars){
				$("txtParticularsDtl").value = obj.pdcParticulars;
				objCurrGIACApdcPaytDtl.particulars = obj.pdcParticulars;
			}
			$("txtCheckFlag").value = "With Details";
			$("txtCheckFlag").setAttribute("checkFlag", "W");
			
			objCurrGIACApdcPaytDtl.checkStatus = "With Details";
			objCurrGIACApdcPaytDtl.checkFlag = "W";		
			
			postDatedChecksTableGrid.updateRowAt(objCurrGIACApdcPaytDtl, objCurrGIACApdcPaytDtl.rowIndex);
			$('mtgRow'+postDatedChecksTableGrid._mtgId+'_'+objCurrGIACApdcPaytDtl.rowIndex).addClassName('selectedRow');
			showMessageBox("Policy No. " + objCurrGIACPdcPremColln.policyNo + " was updated to " + nvl(obj.address1, "") + " " + nvl(obj.address2, "") + " " + nvl(obj.address3, "") + ", " + nvl(obj.intmName, ""));
			changeTag = 1;
		} catch (e){
			showErrorMessage("updateParticulars", e);
		}
	}
	
	function getPdcPremUpdateValues(mode){ //benjo 11.08.2016 SR-5802
		new Ajax.Request(contextPath + "/GIACPdcPremCollnController", {
			method: "GET",
			parameters : {action : "getPremCollnUpdateValues",
						  apdcId : objGIACApdcPayt.apdcId,
						  pdcId : objCurrGIACApdcPaytDtl.pdcId,
						  issCd : objCurrGIACPdcPremColln.issCd,
						  premSeqNo : objCurrGIACPdcPremColln.premSeqNo,
						  updateFlag : mode == 0 ? update.flag : update.specific.flag}, //benjo 11.08.2016 SR-5802
			onComplete: function(response){
				if(checkErrorOnResponse(response)){
					var objPremCollnUpdateValues = JSON.parse(response.responseText);
					updateParticulars(objPremCollnUpdateValues);
				}
			}
		});
	}
	
	update = new Object();
	update.func = getPdcPremUpdateValues;
	
	// mode : 0 - update; 1 - specific update	
	function updateApdc(mode){
		if(changeTag == 1){
			showMessageBox("Please save your changes first.", imgMessage.INFO);
		} else {
			if (objCurrGIACApdcPaytDtl == null){
				showMessageBox('Please select a check to be updated.', imgMessage.ERROR);
				return false;
			} else if (objCurrGIACPdcPremColln == null){
				showMessageBox('Please select a bill.', imgMessage.ERROR);
				return false;
			} else {
				update.mode = mode;
				if(mode == 0){
					getPdcPremUpdateValues(0); //benjo 11.08.2016 SR-5802
				} else {
					showOverlayContent2(contextPath+"/GIACAcknowledgmentReceiptsController?action=showSpecificUpdate", 
							'Update Only', 200, "", 90002);
				}
			}
		}
	}
	
	//marco - 04.17.2013 - added
	function isInstExisting(){
		var rows = postDatedCheckDetailsTableGrid.geniisysRows;
		for(var i=0; i<rows.length; i++){
			if(rows[i].issCd == $F("txtIssCd") && formatNumberDigits(rows[i].premSeqNo, 12) == $F("txtPremSeqNo")
				&& formatNumberDigits(rows[i].instNo, 2) == formatNumberDigits($F("txtInstNo"), 2) && nvl(rows[i].recordStatus, 0) != -1){
				return true;
			}
		}
		return false;
	}
	
	$("selDtlCurrency").observe("change", onDtlCurrencyChange);
	$("txtCollectionAmt").observe("change", function(){
		var collnAmt = parseFloat($F("txtCollectionAmt").replace(/,/g, ""));
		var balanceAmtDue = parseFloat($("txtCollectionAmt").readAttribute("balancAmtDue"));
		if(collnAmt == 0){
			showWaitingMessageBox("Collection amount cannot be zero.", imgMessage.INFO, 
				function(){
					$("txtCollectionAmt").value = formatCurrency($("txtCollectionAmt").readAttribute("origCollectionAmt"));
				});
		} else if(collnAmt > balanceAmtDue){
			showWaitingMessageBox("Collection amount should not exceed " + formatCurrency(balanceAmtDue) + ".", imgMessage.INFO, 
					function(){
						$("txtCollectionAmt").value = formatCurrency($("txtCollectionAmt").readAttribute("origCollectionAmt"));
					});
		} else if($F("txtCollectionAmt") != "" && isNaN($F("txtCollectionAmt"))){
			showWaitingMessageBox("Field must be of form 999,999,999,999.90.", imgMessage.INFO, 
				function(){
					$("txtCollectionAmt").value = formatCurrency($("txtCollectionAmt").readAttribute("origCollectionAmt"));
				});
		} else {
			recomputeBreakDown();
			updateDtlForeignCurrency();
		}
	});
	$("searchBill").observe("click", function(){
		if($F("txtIssCd") != ""){
			showBillNoLOV($F("txtIssCd"), $("selTranType").value);
		} else {
			showMessageBox("Please enter issue code of bill number.", "I"); // added by jdiago | 03.24.2014
		}
	});
	$("searchInst").observe("click",onSearchInstClick);	
	
	$("txtIssCd").observe("keyup", function(){
		$("txtIssCd").value = $F("txtIssCd").toUpperCase();
	});
	
	$("txtIssCd").observe("change", function(){
		if($F("txtIssCd") != "" && $F("txtPremSeqNo") != ""){
			getBillInfo();
		}
	});
	
	$("txtPremSeqNo").observe("change", function(){
		if($F("txtPremSeqNo").trim() != ""){
			if(isNaN($F("txtPremSeqNo"))){
				showWaitingMessageBox("Field must be of form 0000000000000.", imgMessage.ERROR, 
						function(){
							$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("origPremSeqNo") == null ? "" : formatNumberDigits($("txtPremSeqNo").readAttribute("origPremSeqNo"),12);
							$("txtPremSeqNo").focus();
						}
				);
			} else {
				$("txtPremSeqNo").value = formatNumberDigits($F("txtPremSeqNo"),12);
				if($F("txtIssCd") != "" && $F("txtPremSeqNo") != ""){
					getBillInfo();
				}				
			}
		}
	});
	
	$("txtInstNo").observe("change", function(){
		if($F("txtInstNo").trim() != ""){
			if(isNaN($F("txtInstNo"))){
				showWaitingMessageBox("Field must be of form 0.", imgMessage.ERROR, 
						function(){
							$("txtInstNo").value = $("txtInstNo").readAttribute("origInstNo") == null ? "" : formatNumberDigits($("txtInstNo").readAttribute("origInstNo"),2);
							$("txtInstNo").focus();
						}
				);
			} else {
				$("txtInstNo").value = formatNumberDigits($F("txtInstNo"),2);				
				if($F("txtIssCd") != "" && $F("txtInstNo") != "" && $F("txtPremSeqNo") != ""){
					//marco - 04.17.2013 - added conditions
					if(!isInstExisting()){ 
						getInstInfo();
					}else{
						showMessageBox("Record already exists.", "I");
						$("txtInstNo").value = $("txtInstNo").readAttribute("origInstNo") == null ? "" : formatNumberDigits($("txtInstNo").readAttribute("origInstNo"), 2);
						$("txtInstNo").focus();
					}
				}
			}
		}
	});
	
	$("btnPdcDtlAdd").observe("click", function(){
		if(checkAllRequiredFieldsInDiv("premCollnFormDiv")){
			//marco - 04.19.2013 - call validations before calling addPdcDtl
			if($F("txtInstNo").trim() != "" && isNaN($F("txtInstNo"))){
				showWaitingMessageBox("Field must be of form 0.", imgMessage.ERROR, 
					function(){
						$("txtInstNo").value = $("txtInstNo").readAttribute("origInstNo") == null ? "" : formatNumberDigits($("txtInstNo").readAttribute("origInstNo"),2);
						$("txtInstNo").focus();
					}
				);
			}else if($F("txtPremSeqNo").trim() != "" && isNaN($F("txtPremSeqNo"))){
				showWaitingMessageBox("Field must be of form 0000000000000.", imgMessage.ERROR, 
					function(){
						$("txtPremSeqNo").value = $("txtPremSeqNo").readAttribute("origPremSeqNo") == null ? "" : formatNumberDigits($("txtPremSeqNo").readAttribute("origPremSeqNo"),12);
						$("txtPremSeqNo").focus();
					}
				);
			}else{
				new Ajax.Request(contextPath+"/GIACAgingSoaDetailController", {
					method: "GET",
					parameters: {action : "getInstInfo",
							     issCd : $F("txtIssCd"),
							     premSeqNo : $F("txtPremSeqNo"),
							     instNo : $F("txtInstNo")},
					onComplete : function(response){
						if(checkErrorOnResponse(response)){
							var row = JSON.parse(response.responseText);
							if(nvl(row.instNo, "") == ""){
								showWaitingMessageBox("This Installment No. does not exist in GIPI_INSTALLMENT.", imgMessage.INFO,
									function(){
										$("txtInstNo").value = $("txtInstNo").readAttribute("origInstNo") == null ? "" : formatNumberDigits($("txtInstNo").readAttribute("origInstNo"), 2);
										$("txtInstNo").focus();
									});
							}else{
								addPdcDtl();
							}
						}
					}
				});
			}
		}
	});
	
	$("btnPdcDtlDelete").observe("click", deletePdcDtl);
	$("btnUpdate").observe("click", function(){
		updateApdc(0);
	});
	$("btnSpecUpdate").observe("click", function(){
		updateApdc(1);
	});
	setPdcDtlForm(null);
	
	// bonok :: 01.10.2013 :: UCPBGEN-QA SR: 11836
	$("txtDtlCurrencyRt").observe("change", function(){
		if(isNaN($("txtDtlCurrencyRt").value)){
			customShowMessageBox("Legal characters are 0-9.", "E", "txtDtlCurrencyRt");
			$("txtDtlCurrencyRt").clear();
		}else{
			$("txtDtlCurrencyRt").value = formatToNineDecimal($F("txtDtlCurrencyRt"));
		}
	});
	
	// bonok :: 01.10.2013 :: UCPBGEN-QA SR: 11836
	$("txtDtlFCurrencyAmt").observe("change", function(){
		if(isNaN($("txtDtlFCurrencyAmt").value)){
			customShowMessageBox("Field must be of form 999,999,999,999.90.", "E", "txtDtlFCurrencyAmt");
			$("txtDtlFCurrencyAmt").clear();
		}else{
			$("txtDtlFCurrencyAmt").value = formatCurrency($F("txtDtlFCurrencyAmt"));
		}
	});
	
	// bonok :: 01.10.2013 :: UCPBGEN-QA SR: 11836
	$("txtPremAmt").observe("change", function(){
		if(isNaN(parseFloat($("txtPremAmt").value))){
			customShowMessageBox("Field must be of form 999,999,999.90.", "E", "txtPremAmt");
			$("txtPremAmt").clear();
		}else{
			$("txtPremAmt").value = formatCurrency($F("txtPremAmt"));
		}
	});
	
	// bonok :: 01.10.2013 :: UCPBGEN-QA SR: 11836
	$("txtDtlCurrencyRt").setAttribute("readonly", "readonly"); 
	$("txtAssdName").setAttribute("readonly", "readonly");
	$("txtPolicyEndtNo").setAttribute("readonly", "readonly");
	//$("txtPremAmt").setAttribute("readonly", "readonly");
	$("txtTaxAmt").setAttribute("readonly", "readonly");
	$("txtDtlFCurrencyAmt").setAttribute("readonly", "readonly");
	
	$("selTranType").observe("change", function(){//kenneth SR 20856 12.02.2015
		$("txtIssCd").value = "";
		$("txtPremSeqNo").value = "";
		$("txtInstNo").value = "";
		$("txtCollectionAmt").value = "";
		$("txtAssdName").value = "";
		$("txtPolicyEndtNo").value = ""; 
		$("txtPremAmt").value = "";
		$("txtTaxAmt").value = "";
		$("txtDtlFCurrencyAmt").value = "";	
	});
	
	/* benjo 11.08.2016 SR-5802 */
	if (nvl('${apdcSW}', "N") == "Y"){
		$("updateFlagDiv").style.display = 'block';
		$("pdcDtlPolicyDiv").style.display = 'block';
	}
	
	update.flag = "A";
	
	$$("input[name='updateFlag']").each(function(r){
		$(r).observe("click", function(){
			update.flag = r.value;
		});
	});
	
	if (objGIACApdcPayt != null && (objGIACApdcPayt.apdcFlag == 'P' || objGIACApdcPayt.apdcFlag == 'C')){
		disableButton("btnPdcDtlPolicy");
	}
	
	$("btnPdcDtlPolicy").observe("click", function() {
		if(objCurrGIACApdcPaytDtl == null){
			showMessageBox("Please select a post-dated check record first.", imgMessage.INFO);
		}else{
			setPdcDtlForm(null);
			giacs090PolicyOverlay = Overlay.show(contextPath+"/GIACAcknowledgmentReceiptsController", {
				urlParameters: {
					action: "showPolicyEntry"
				},
				urlContent : true,
				draggable: true,
			    title: "Policy Entry",
			    height: 150,
			    width: 525
			});
		}
	});
	/* end SR-5802 */
</script>