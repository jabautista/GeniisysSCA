<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="createIntreatyMainDiv" name="createIntreatyMainDiv">
	<div id="mainNav" name="mainNav">
		<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
			<ul>
				<li><a id="createIntreatyExit">Exit</a></li>
			</ul>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" name="innerDiv">
			<label>Proportional Treaty / Panel</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
 		   		<label id="reloadForm" name="reloadForm">Reload Form</label>
	   		</span>   		
	   	</div>
	</div>
	<div class="sectionDiv" id="treatyPanelDiv" name="treatyPanelDiv" align="center">
	    <input type="hidden" id="intreatyId" name="intreatyId" value="${intreatyId}">
		<input type="hidden" id="allowApprove" name="allowApprove" value="${allowApprove}">
		<input type="hidden" id="allowCancel" name="allowCancel" value="${allowCancel}">
		<table align="center" cellspacing="1" border="0" style="margin: 10px 10px 10px 10px;">
			<tr>
				<td class="rightAligned">Inward Treaty No.</td>
				<td class="leftAligned" colspan="3">
					<input type="hidden" id="intrtySeqNo" name="intrtySeqNo" value="">
	    			<input type="hidden" id="intrtyFlag" name="intrtyFlag" value="">
					<input type="text" style="width: 500px;" id="intrtyNo" name="intrtyNo" readonly="readonly" value=""/>
				</td>
			</tr>
 			<tr>
				<td class="rightAligned">Line</td>
				<td class="leftAligned" colspan="3">
					<input type="hidden" id="lineCd" name="lineCd" value="${lineCd}">
					<input type="text" style="width: 500px;" id="lineName" name="lineName" readonly="readonly" value=""/>
				</td>
			</tr>
 			<tr>
				<td class="rightAligned">Treaty Year</td>
				<td class="leftAligned" colspan="3">
					<input type="hidden" id="trtyYy" name="trtyYy" value="${trtyYy}">
					<input type="text" style="width: 500px;" id="dspTrtyYy" name="dspTrtyYy" readonly="readonly" value=""/>
				</td>
			</tr>
 			<tr>
				<td class="rightAligned">Treaty Name</td>
				<td class="leftAligned" colspan="3">
					<input type="hidden" id="shareCd" name="shareCd" value="${shareCd}">
					<input type="text" style="width: 500px;" id="trtyName" name="trtyName" readonly="readonly" value=""/>
				</td>
			</tr>			
 			<tr>
				<td class="rightAligned">Treaty Term</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 500px;" id="trtyTerm" name="trtyTerm" readonly="readonly" value=""/>
				</td>
			</tr>			
 			<tr>
				<td class="rightAligned">Reinsurer</td>
				<td class="leftAligned" colspan="3">
					<span class="lovSpan required" style="width: 506px;">
						<input type="hidden" id="riCd" name="riCd" lastValidValue="" value=""/>
						<input type="text" style="width: 476px; float: left; border: none; height: 13px; margin: 0;" id="riName" name="riName" class="required" lastValidValue="" readonly="readonly" ignoreDelKey="1" value=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchRi" name="searchRi" alt="Go" style="float: right;"/>
					</span>						
				</td>
			</tr>			
 			<tr>
				<td class="rightAligned">Share %</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 500px;" id="trtyShrPct" name="trtyShrPct" lastValidValue="" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Approved By</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px; margin-right: 15px;" id="approveBy" name="approveBy" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned">Date Approved</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px;" id="approveDate" name="approveDate" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cancelled By</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px; margin-right: 15px;" id="cancelUser" name="cancelUser" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned">Date Cancelled</td>
				<td class="leftAligned">
					<input type="text" style="width: 190px;" id="cancelDate" name="cancelDate" readonly="readonly" value=""/>
				</td>
			</tr>
		</table>
		<div align="right" style="margin: 0px 152px 10px 0px;">
			<input type="button" id="btnApproveIntreaty" name="btnApproveIntreaty" value="Approve" class="button" style="width: 94px;"/>
			<input type="button" id="btnCancelIntreaty" name="btnCancelIntreaty" value="Cancel" class="button" style="margin-left: 5px; width: 94px;"/>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" >
			<label>Inward Treaty Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		</span>   		
	   	</div>
	</div>
	<div class="sectionDiv" id="intreatyInfoDiv" name="intreatyInfoDiv" align="center" changeTagAttr="true">
		<table align="center" cellspacing="1" border="0" style="margin: 10px 10px 10px 40px;">
			<tr>
				<td class="rightAligned">Accept Date</td>
				<td class="leftAligned" colspan="4">
				    <div id="acceptDateDiv" name="acceptDateDiv" style="width: 506px;" class="required withIconDiv">
				    	<input style="width: 482px;" id="acceptDate" name="acceptDate" type="text" value="${dfltAcceptDate}" readonly="readonly" class="required withIcon"/>
				    	<img id="hrefAcceptDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('acceptDate'),this, null);" alt="Accept Date" />
					</div>
				</td>
			</tr>
  			<tr>
				<td class="rightAligned">Period</td>
				<td class="leftAligned">
					<select id="tranType" name="tranType" style="width: 60px;" class="required">
						<option></option>
						<c:forEach var="x" items="${tranTypeListing}">
							<option value="${x.tranType}">${x.tranType}</option>
						</c:forEach>
					</select>
				</td>
				<td class="leftAligned">
					<select id="tranNo" name="tranNo" style="margin-right: 100px; width: 50px;" class="required">
						<option value=""></option>
						<option value="01">01</option>
						<option value="02">02</option>
						<option value="03">03</option>
						<option value="04">04</option>
						<option value="05">05</option>
						<option value="06">06</option>
						<option value="07">07</option>
						<option value="08">08</option>
						<option value="09">09</option>
						<option value="10">10</option>
						<option value="11">11</option>
						<option value="12">12</option>
					</select>
				</td>
				<td class="rightAligned">Booking Date</td>
				<td class="leftAligned">
					<input type="hidden" id="bookingYy" name="bookingYy" value="${dfltBookingYear}"/>
					<input type="hidden" id="bookingMth" name="bookingMth" value="${dfltBookingMth}"/>
					<select id="bookingMonth" name="bookingMonth" style="width: 200px;" class="required">
						<option></option>
						<c:forEach var="x" items="${bookingMonthListing}">
							<option bookingYear="${x.bookingYear}" bookingMth="${x.bookingMonth}" value="${x.bookingYear} - ${x.bookingMonth}"
							<c:if test="${dfltBookingYear == x.bookingYear and dfltBookingMth == x.bookingMonth}">
									selected="selected"
							</c:if>
							>${x.bookingYear} - ${x.bookingMonth}</option>
						</c:forEach>
					</select>
				</td>
			</tr>
		</table>
        <table align="center" cellspacing="1" border="0" style="margin: 20px 10px 10px 40px;">
            <tr>
				<td class="rightAligned">Currency</td>
				<td class="leftAligned">
					<select id="currency" name="currency" style="width: 65px;" class="required">
						<option></option>			
						<c:forEach var="x" items="${currency}">
							<option shortName="${x.shortName }" currRate="${x.valueFloat}" value="${x.code}"
								<c:if test="${dfltCurrency eq x.code}">
									selected="selected"
								</c:if>
							>${x.shortName}</option>				
						</c:forEach>
					</select>
				</td>
				<td class="leftAligned">
					<input type="text" style="width: 224px;" id="currRate" name="currRate" class="applyDecimalRegExp required" regExpPatt="pDeci0309" maxlength="13" value="" min="0.000000001" max="999.999999999" />
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Premium</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="riPremAmt" name="riPremAmt" class="applyDecimalRegExp2" regExpPatt="nDeci0902" maxlength="19" min="-999999999.99" max="999999999.99" value="0.00"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Commission</td>
				<td class="rightAligned" colspan="2">
					<input type="hidden" id="riCommRt" name="riCommRt" lastValidValue="" value=""/>
					<input type="text" style="width: 75px;" id="dspRiCommRt" name="dspRiCommRt" class="rightAligned" lastValidValue="" readonly="readonly" value=""/>
					<input type="text" style="width: 209px;" id="riCommAmt" name="riCommAmt" class="rightAligned" readonly="readonly" value="0.00"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Vat</td>
				<td class="rightAligned" colspan="2">
					<input type="hidden" id="riVatRt" name="riVatRt" lastValidValue="" value=""/>
					<input type="text" style="width: 75px;" id="dspRiVatRt" name="dspRiVatRt" class="rightAligned" lastValidValue="" readonly="readonly" value=""/>
					<input type="text" style="width: 209px;" id="riCommVat" name="riCommVat" class="rightAligned" readonly="readonly" value="0.00"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Losses Paid</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="clmLossPdAmt" name="clmLossPdAmt" class="applyDecimalRegExp2" regExpPatt="nDeci0902" maxlength="19" min="-999999999.99" max="999999999.99" value="0.00"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Losses Expense</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="clmLossExpAmt" name="clmLossExpAmt" class="applyDecimalRegExp2" regExpPatt="nDeci0902" maxlength="19" min="-999999999.99" max="999999999.99" value="0.00"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cash Call Refund</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="clmRecoverableAmt" name="clmRecoverableAmt" class="applyDecimalRegExp2" regExpPatt="nDeci0902" maxlength="19" min="-999999999.99" max="999999999.99" value="0.00"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Charges</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="chargeAmount" name="chargeAmount" class="applyDecimalRegExp2" regExpPatt="nDeci0902" readonly="readonly" value="0.00"/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Total</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="totalAmt" name="totalAmt" class="applyDecimalRegExp2" regExpPatt="nDeci1302" readonly="readonly" value="0.00"/>
				</td>
			</tr>
		</table>	
	</div>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" name="innerDiv">
			<label>Charges Information</label>
	   		<span class="refreshers" style="margin-top: 0;">
	   			<label name="gro" style="margin-left: 5px;">Hide</label>
	   		</span>   		
	   	</div>
	</div>
	<div class="sectionDiv" id="chargesInfoDiv" name="chargesInfoDiv">
		<div id="chargesInfoTableGridDiv" style="padding: 10px 0 10px 10px;">
			<div id="chargesInfoTableGrid" style="height: 250px"></div>
		</div>
		<div id="chargesContainerDiv" changeTagAttr="true" style="margin-bottom: 10px;">
			<table align="center" cellspacing="1" border="0">
				<tr>
					<td class="rightAligned">Charges Description</td>
					<td class="leftAligned">
						<span class="lovSpan required" style="width: 306px;">
							<input type="hidden" id="taxCd" name="taxCd" lastValidValue="" value=""/>
							<input type="hidden" id="wTax" name="wTax" lastValidValue="" value=""/>
							<input type="text" style="width: 281px; float: left; border: none; height: 13px; margin: 0;" id="taxName" name="taxName" class="required" lastValidValue="" readonly="readonly" ignoreDelKey="1" value=""/>
							<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchCharge" name="searchCharge" alt="Go" style="float: right;"/>
						</span>						
					</td>
				</tr>
				<tr>
					<td class="rightAligned">Amount</td>
					<td class="leftAligned">
						<input type="hidden" id="amount" name="amount" lastValidValue="" value=""/>
						<input type="text" style="width: 300px;" id="dspAmount" name="dspAmount" class="required applyDecimalRegExp2" regExpPatt="nDeci0902" maxlength="19" min="-999999999.99" max="999999999.99" value=""/>
					</td>
				</tr>
				<tr>
					<td colspan="3" align="center">
					<input style="width: 120px;" id="btnAddCharges" name="btnAddCharges" class="button" type="button" value="Add" /> 
					<input style="width: 120px;" id="btnDeleteCharges" name="btnDeleteCharges" class="disabledButton" type="button" value="Delete" />
					<input style="width: 120px;" id="btnTax" name="btnTax" class="disabledButton" type="button" value="Tax" /></td>
				</tr>
			</table>
		</div>
	</div>
	<div class="sectionDiv" align="center">
		<table align="center" cellspacing="1" border="0">
			<tr>
				<input style="width: 120px; margin: 20px 5px 30px 0px;" id="btnCancel" name="btnCancel" class="button" type="button" value="Cancel" /> 
				<input style="width: 120px;" id="btnSave" name="btnSave" class="button" type="button" value="Save" />
			</tr>
		</table>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIRIS056A");
	setDocumentTitle("Create Inward Treaty Record");
	initializeAll();
	initializeAccordion();
	initializeChangeTagBehavior(saveIntreaty);
	initializeChangeAttribute();
	observeChangeTagOnDate("hrefAcceptDate", "acceptDate");
	manageTranNoList();
	changeTag = 0;
	
	var objIntreaty = JSON.parse('${giriIntreaty}');
	var objDistShare = JSON.parse('${distShare}');
	var objIntreatyCharges = JSON.parse('${giriIntreatyCharges}');
	var objIntreatyChargesTG = JSON.parse('${giriIntreatyChargesTG}');
	var chargesTableModel = {
		url : contextPath+"/GIRIIntreatyController?action=getIntreatyChargesTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId")),
		options: {
			width: '900px',
			masterDetail : true,
			masterDetailRequireSaving : true,
			pager: {},
			onCellFocus : function(element, value, x, y, id) {
				var objSelected = tbgCharges.geniisysRows[y];
				tbgCharges.keys.releaseKeys();
				setChargesForm(objSelected);
			},			
			onRemoveRowFocus : function(element, value, x, y, id){
				setChargesForm(null);
			},
			beforeSort: function(){
				if(getAddedAndModifiedJSONObjects(objIntreatyCharges).length > 0 || getDeletedJSONObjects(objIntreatyCharges).length > 0){						
					showMessageBox(objCommonMessage.SAVE_CHANGES, "I");
					return false;
				}
			},
			masterDetailValidation : function(){
				if(getAddedAndModifiedJSONObjects(objIntreatyCharges).length > 0 || getDeletedJSONObjects(objIntreatyCharges).length > 0){						
					return true;
				}else{
					return false;
				}
			},
			masterDetailSaveFunc : function(){
				$("btnSave").click();
			},
			masterDetailNoFunc : function(){
				
			},
			toolbar:{
				elements: [MyTableGrid.REFRESH_BTN]
			}
		},									
		columnModel: [
			{	id: 'recordStatus',
			    title: '',
			    width: '0',
			    visible: false
			},
			{	id: 'divCtrId',
				width: '0',
				visible: false 
			},
			{	id: 'intreatyId',
				width: '0',
				visible: false 
			},
			{	id: 'chargeCd',
				width: '140',
				title: '&nbsp;&nbsp;&nbsp;Charges Code',
				titleAlign : 'center',
				align: 'center',
				editable: false,
				renderer : function(value){
					return lpad(value.toString(), 2, "0");
           		}
			},
			{	id: 'taxName',
				width: '462',
				title: 'Charges Description',
				editable: false,
				renderer : function(value){
					return unescapeHTML2(value);
           		}
			},
			{	id: 'amount',
				width: '0',
				visible: false 
			},
			{	id: 'dspAmount',
				width: '200',
				title: 'Amount',
				titleAlign : 'right',
				align: 'right',
				editable: false,
				type : 'number',
				geniisysClass : 'money'
			},
			{	id: 'wTax',
				width: '70',
				title: '&nbsp;&nbsp;&nbsp;&nbsp;T',
				titleAlign : 'center',
				altTitle: 'With Tax',
			    align: 'center',
				sortable: true,
				editable: false,
				hideSelectAllBox: false,
			    editor: new MyTableGrid.CellCheckbox({
			    	getValueOf: function(value){
	            		if (value){
							return "Y";
	            		}else{
							return "N";
	            		}	
	            	}
			    })
			}
		],
		rows: objIntreatyChargesTG.rows || []
	};
	tbgCharges = new MyTableGrid(chargesTableModel);
	tbgCharges.pager = objIntreatyChargesTG;
	tbgCharges.render('chargesInfoTableGrid');
	tbgCharges.afterRender = function(){
		computeTotal();
		setChargesForm(null);
	};
	
	function populateIntreaty(obj){
		if(nvl(obj.intreatyId, 0) > 0){
			$("intreatyId").value 		 = obj == null? "" : obj.intreatyId;
			$("lineCd").value 			 = obj == null? "" : obj.lineCd;
			$("trtyYy").value 			 = obj == null? "" : obj.trtyYy;
			$("intrtySeqNo").value 		 = obj == null? "" : obj.intrtySeqNo;
			$("riCd").value 			 = obj == null? "" : obj.riCd;
			$("acceptDate").value 		 = obj == null? "" : obj.strAcceptDate;
			$("approveBy").value 		 = obj == null? "" : obj.approveBy;
			$("approveDate").value 		 = obj == null? "" : obj.strApproveDate;
			$("cancelUser").value 		 = obj == null? "" : obj.cancelUser;
			$("cancelDate").value 		 = obj == null? "" : obj.strCancelDate;
			$("bookingYy").value 		 = obj == null? "" : obj.bookingYy;
			$("bookingMth").value 		 = obj == null? "" : obj.bookingMth;
			$("bookingMonth").value 	 = obj == null? "" : obj.bookingYy+" - "+obj.bookingMth;
			$("tranType").value 		 = obj == null? "" : obj.tranType;
			manageTranNoList();
			$("tranNo").value 			 = obj == null? "" : lpad(obj.tranNo, 2, "0");
			$("currency").value 		 = obj == null? "" : obj.currencyCd;
			$("currRate").value 		 = obj == null? "" : obj.currencyRt;
			$("riPremAmt").value 		 = obj == null? "" : formatCurrency(obj.riPremAmt);
			$("riCommRt").value 		 = obj == null? "" : obj.riCommRt;
			$("riCommAmt").value 		 = obj == null? "" : formatCurrency(obj.riCommAmt);
			$("riVatRt").value 			 = obj == null? "" : obj.riVatRt;
			$("riCommVat").value 		 = obj == null? "" : obj.riCommVat;
			$("clmLossPdAmt").value 	 = obj == null? "" : formatCurrency(obj.clmLossPdAmt);
			$("clmLossExpAmt").value	 = obj == null? "" : formatCurrency(obj.clmLossExpAmt);
			$("clmRecoverableAmt").value = obj == null? "" : formatCurrency(obj.clmRecoverableAmt);
			$("chargeAmount").value		 = obj == null? "" : formatCurrency(obj.chargeAmount);
			$("intrtyFlag").value		 = obj == null? "" : obj.intrtyFlag;
			$("shareCd").value 			 = obj == null? "" : obj.shareCd;
			$("intrtyNo").value 		 = obj.lineCd + "-" + obj.trtyYy + "-" + lpad(obj.intrtySeqNo, 5, "0");
			showRiLov($F("riCd"));
		}
		
		if(nvl($F("allowApprove"), "FALSE") == "TRUE" && nvl($F("intreatyId"), "0") != "0" && nvl($F("intrtyFlag"), "1") == "1"){
			enableButton("btnApproveIntreaty");
		}else{
			disableButton("btnApproveIntreaty");
		}
		
		if(nvl($F("allowCancel"), "FALSE") == "TRUE" && nvl($F("intreatyId"), "0") != "0" && nvl($F("intrtyFlag"), "1") != "3"){
			enableButton("btnCancelIntreaty");
		}else{
			disableButton("btnCancelIntreaty");
		}
	}
	
	function populateDistShare(obj){
		$("lineName").value  = obj == null? "" : unescapeHTML2(obj.lineName);
		$("dspTrtyYy").value = obj == null? "" : unescapeHTML2(obj.dspTrtyYy);
		$("trtyName").value  = obj == null? "" : unescapeHTML2(obj.trtyName);
		$("trtyTerm").value  = obj == null? "" : unescapeHTML2(obj.trtyTerm);
	}
	
	function showRiLov(riCd){
		LOV.show({
			controller : "UWReinsuranceLOVController",
			urlParameters : {
				action : "getGIRIS056RiLOV",
				lineCd : $F("lineCd"),
				trtyYy : $F("trtyYy"),
				shareCd : $F("shareCd"),
				riCd: riCd,
				filterText: "%",
				page : 1
			},
			title : "List of Reinsurers",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "riName",
				title : "RI Name",
				width : '437px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,			
			onSelect : function(row) {
				if (row != null || row != undefined) {
					if($("riCd").value != row.riCd){
						changeTag = 1;
					}
					$("riCd").value = row.riCd;
					$("riName").value = unescapeHTML2(row.riName);
					$("trtyShrPct").value = row.trtyShrPct;
					$("riCommRt").value = row.riCommRt;
					$("dspRiCommRt").value = row.dspRiCommRt;
					$("riVatRt").value = row.riVatRt;
					$("dspRiVatRt").value = row.dspRiVatRt;
					if($F("riCd") != $("riCd").getAttribute("lastValidValue")){
						$("riCd").setAttribute("lastValidValue", $F("riCd"));
						$("riName").setAttribute("lastValidValue", $F("riName"));
						$("trtyShrPct").setAttribute("lastValidValue", $F("trtyShrPct"));
						$("riCommRt").setAttribute("lastValidValue", $F("riCommRt"));
						$("dspRiCommRt").setAttribute("lastValidValue", $F("dspRiCommRt"));
						$("riVatRt").setAttribute("lastValidValue", $F("riVatRt"));
						$("dspRiVatRt").setAttribute("lastValidValue", $F("dspRiVatRt"));
					}
					computeTotal();
				}
			},
			onCancel: function(){
				$("riCd").value = $("riCd").readAttribute("lastValidValue");
				$("riName").value = $("riName").readAttribute("lastValidValue");
				$("trtyShrPct").value = $("trtyShrPct").readAttribute("lastValidValue");
				$("riCommRt").value = $("riCommRt").readAttribute("lastValidValue");
				$("dspRiCommRt").value = $("dspRiCommRt").readAttribute("lastValidValue");
				$("riVatRt").value = $("riVatRt").readAttribute("lastValidValue");
				$("dspRiVatRt").value = $("dspRiVatRt").readAttribute("lastValidValue");
				$("riName").focus();
			},
			onUndefinedRow:	function(){
				$("riCd").value = $("riCd").readAttribute("lastValidValue");
				$("riName").value = $("riName").readAttribute("lastValidValue");
				$("trtyShrPct").value = $("trtyShrPct").readAttribute("lastValidValue");
				$("riCommRt").value = $("riCommRt").readAttribute("lastValidValue");
				$("dspRiCommRt").value = $("dspRiCommRt").readAttribute("lastValidValue");
				$("riVatRt").value = $("riVatRt").readAttribute("lastValidValue");
				$("dspRiVatRt").value = $("dspRiVatRt").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "riName");
			}
		});
	}
	
	function manageTranNoList(){
		$("tranNo").childElements().each(function (o) {
			o.show();
			o.disabled = false;
			if($F("tranType").blank()){
				o.hide();
				o.disabled = true;
			}else if($F("tranType")=="QTR"){
				if (o.value == "05" || o.value == "06" || o.value == "07" || o.value == "08" || 
					o.value == "09" || o.value == "10" || o.value == "11" || o.value == "12"){
					o.hide();
					o.disabled = true;
				}
			}
		});
	}
	
	function computeTotal(){
		$("riCommAmt").value = formatCurrency(unformatNumber($F("riPremAmt")) * $F("riCommRt") / 100);
		$("riCommVat").value = formatCurrency(unformatNumber($F("riCommAmt")) * $F("riVatRt") / 100);
		
		var objArrFiltered = objIntreatyCharges.filter(function(obj){return nvl(obj.recordStatus, 0) != -1;});
		var totalChargeAmount = 0;
		for(var i=0; i<objArrFiltered.length; i++){
			totalChargeAmount = totalChargeAmount + parseFloat(objArrFiltered[i].dspAmount);
		}
		$("chargeAmount").value = formatCurrency(totalChargeAmount); 
		
		var premAmt = nvl($F("riPremAmt"), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("riPremAmt")));
		var commAmt = nvl($F("riCommAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("riCommAmt")));
		var commVat = nvl($F("riCommVat").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("riCommVat")));
		var lossPd = nvl($F("clmLossPdAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("clmLossPdAmt")));
		var lossExp = nvl($F("clmLossExpAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("clmLossExpAmt")));
		var recovAmt = nvl($F("clmRecoverableAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("clmRecoverableAmt")));
		var charges = nvl($F("chargeAmount").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("chargeAmount")));
		
		$("totalAmt").value = formatCurrency(premAmt - (commAmt + commVat) - (lossPd + lossExp) + recovAmt + charges);
	}
	
	function setReadOnly(){
		if(nvl($F("intrtyFlag"), "1") != "1"){
			$("searchRi").hide();
			$("acceptDate").readOnly = true;
			disableDate("hrefAcceptDate");
			$("tranType").disabled = true;
			$("tranNo").disabled = true;
			$("bookingMonth").disabled = true;
			$("currency").disabled = true;
			$("currRate").readOnly = true;
			$("riPremAmt").readOnly = true;
			$("clmLossPdAmt").readOnly = true;
			$("clmLossExpAmt").readOnly = true;
			$("clmRecoverableAmt").readOnly = true;
			$("searchCharge").hide();
			$("dspAmount").readOnly = true;
			disableButton("btnAddCharges");
			disableButton("btnDeleteCharges");
			disableButton("btnSave");
		}
	}
	
	function setChargesForm(obj){
		$("taxCd").value 		 = obj == null ? "" : obj.chargeCd;	
		$("taxName").value		 = obj == null ? "" : unescapeHTML2(obj.taxName);
		$("amount").value		 = obj == null ? "" : formatCurrency(obj.amount);
		$("dspAmount").value     = obj == null ? "" : formatCurrency(obj.dspAmount);
		$("wTax").value 		 = obj == null ? "" : obj.wTax;
		$("btnAddCharges").value = obj == null ? "Add" : "Update";
		
		if(obj == null){
			$("searchCharge").show();
			disableButton("btnDeleteCharges");
			disableButton("btnTax");
		}else{
			$("searchCharge").hide();
			enableButton("btnDeleteCharges");
			enableButton("btnTax");
		}
		
		if(nvl($F("wTax"), "N") == "Y"){
			$("dspAmount").readOnly = true;
		}else{
			$("dspAmount").readOnly = false;
		}
		
		clearChangeAttribute("chargesContainerDiv");
		setReadOnly();
	}
	
	function validateSaveIntreaty(){
		if(changeTag == 0){
			showMessageBox(objCommonMessage.NO_CHANGES ,imgMessage.INFO);
			return false;
		}else{
			if($F("riName").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "riName");
				return false;
			}else if ($F("acceptDate").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "acceptDate");
				return false;
			}else if ($F("tranType").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "tranType");
				return false;
			}else if ($F("tranNo").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "tranNo");
				return false;
			}else if ($F("bookingMonth").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "bookingMonth");
				return false;
			}else if ($F("currency").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "currency");
				return false;
			}else if ($F("currRate").blank()){
				customShowMessageBox(objCommonMessage.REQUIRED, imgMessage.ERROR, "currRate");
				return false;
			}
		}
		return true;
	}
	
	function saveIntreaty(){
		if(validateSaveIntreaty()){
			var objParameters = new Object();
			objParameters.giriIntreaty = prepareGIRIIntreatyObjParameter();
			objParameters.delIntreatyCharges = getDeletedJSONObjects(objIntreatyCharges);
			objParameters.addIntreatyCharges = getAddedAndModifiedJSONObjects(objIntreatyCharges);
				
			new Ajax.Request(contextPath + "/GIRIIntreatyController?action=saveIntreaty", {
				method : "POST",
				parameters : {parameters : JSON.stringify(objParameters)},
				asynchronous: false,
				evalScripts: true,
				onComplete : 
					function(response){
						if(checkErrorOnResponse(response)){
							var res = JSON.parse(response.responseText);
							if(res.message == "SUCCESS"){
								$("intreatyId").value = res.intreatyId;
								showWaitingMessageBox(objCommonMessage.SUCCESS, "S", showCreateIntreaty($F("intreatyId"), $F("lineCd"), $F("trtyYy"), $F("shareCd")));
							}else{
								showMessageBox(res.message, "E");
							}
						}else{
							showMessageBox(response.responseText, "E");
						}
					}
			});
		}
	}
	
	function prepareGIRIIntreatyObjParameter(){
		var param = new Object();
		param.intreatyId 		= $F("intreatyId");
		param.lineCd 	 		= $F("lineCd");
		param.trtyYy   	 		= $F("trtyYy");
		param.intrtySeqNo 		= $F("intrtySeqNo");
		param.riCd	      		= $F("riCd");
		param.acceptDate  		= $F("acceptDate");
		param.bookingMth 	  	= $F("bookingMth");
		param.bookingYy	 		= $F("bookingYy");
		param.tranType	 		= $F("tranType");
		param.tranNo	 		= $F("tranNo");
		param.currencyCd   	 	= $F("currency");
		param.currencyRt   		= $F("currRate");
		param.riPremAmt   		= parseFloat(unformatNumber($F("riPremAmt")));
		param.riCommRt   		= $F("riCommRt");
		param.riCommAmt   		= parseFloat(unformatNumber($F("riCommAmt")));
		param.riVatRt   		= $F("riVatRt");
		param.riCommVat   		= parseFloat(unformatNumber($F("riCommVat")));
		param.clmLossPdAmt   	= parseFloat(unformatNumber($F("clmLossPdAmt")));
		param.clmLossExpAmt     = parseFloat(unformatNumber($F("clmLossExpAmt")));
		param.clmRecoverableAmt = parseFloat(unformatNumber($F("clmRecoverableAmt")));
		param.chargeAmount  	= parseFloat(unformatNumber($F("chargeAmount")));
		param.intrtyFlag   		= nvl($F("intrtyFlag"), 1);
		param.shareCd   		= $F("shareCd");
		return param;
	}
	
	function approveIntreaty(){
		new Ajax.Request(contextPath+"/GIRIIntreatyController?action=approveIntreaty", {
			method: "POST",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				intreatyId: $F("intreatyId")
			},
			onCreate: function() {
				showNotice("Approving Inward Treaty, please wait...");
			},
			onComplete: function (response) {
				if(checkErrorOnResponse(response)){
					hideNotice("");
					showWaitingMessageBox("Record successfully approved.", imgMessage.SUCCESS, showCreateIntreaty($F("intreatyId"), $F("lineCd"), $F("trtyYy"), $F("shareCd")));
				}
			}
		});
	}
	
	function cancelIntreaty(){
		new Ajax.Request(contextPath+"/GIRIIntreatyController?action=cancelIntreaty", {
			method: "POST",
			asynchronous: true,
			evalScripts: true,
			parameters: {
				intreatyId: $F("intreatyId")
			},
			onCreate: function() {
				showNotice("Cancelling Inward Treaty, please wait...");
			},
			onComplete: function (response) {
				if(checkErrorOnResponse(response)){
					hideNotice("");
					showWaitingMessageBox("Record successfully cancelled.", imgMessage.SUCCESS, showCreateIntreaty($F("intreatyId"), $F("lineCd"), $F("trtyYy"), $F("shareCd")));
				}
			}
		});
	}
	
	$("createIntreatyExit").observe("click", function(){
		if(nvl($F("intrtyFlag"), "1") != "1"){
			changeTag = 0;
		}
		
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveIntreaty();
					},
					function(){
						changeTag = 0;
						showIntreatyListing($F("lineCd"), $F("trtyYy"), $F("shareCd"));
					},
					"");
		} else {
			showIntreatyListing($F("lineCd"), $F("trtyYy"), $F("shareCd"));
		}
	});
	
	$("reloadForm").observe("click", function(){
		if(nvl($F("intrtyFlag"), "1") != "1"){
			changeTag = 0;
		}
		
		if(changeTag == 1) {
			showConfirmBox("Confirmation", objCommonMessage.RELOAD_WCHANGES, "Yes", "No",
					function(){
						showCreateIntreaty($F("intreatyId"), $F("lineCd"), $F("trtyYy"), $F("shareCd"));
					},
					"");
		} else {
			showCreateIntreaty($F("intreatyId"), $F("lineCd"), $F("trtyYy"), $F("shareCd"));
		}
	});
	
	$("searchRi").observe("click", function() {
		showRiLov("");
	});
	
	$("btnApproveIntreaty").observe("click", function() {
		showConfirmBox("Confirmation", "Approve Inward Treaty Record " + $F("intrtyNo") + "?", "Yes", "No",
				function(){
					approveIntreaty();
				},
				"");
	});
	
	$("btnCancelIntreaty").observe("click", function() {
		showConfirmBox("Confirmation", "Cancel Inward Treaty Record " + $F("intrtyNo") + "?", "Yes", "No",
				function(){
					cancelIntreaty();
				},
				"");
	});
	
	$("acceptDate").observe("blur", function(){
		if (makeDate($F("acceptDate")) > makeDate('${dfltAcceptDate}')){
			$("acceptDate").value = '${dfltAcceptDate}';
			customShowMessageBox("Accept date must not be later than " + dateFormat('${dfltAcceptDate}', 'mmmm dd, yyyy') + ".", imgMessage.ERROR, "acceptDate");
			return;
		}
	});
	
	$("tranType").observe("change", function(){
		$("tranNo").value = "";
		manageTranNoList();
	});
	
	$("bookingMonth").observe("change", function() {
		$("bookingYy").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingYear");
		$("bookingMth").value = $("bookingMonth").options[$("bookingMonth").selectedIndex].getAttribute("bookingMth");
	});
	
	$("currency").observe("change", function () {
		$("currRate").value = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
	});
	
	$("riPremAmt").observe("change", function(){
		if($F("riPremAmt").blank()){
			$("riPremAmt").value = "0.00";
		}
		computeTotal();
	});
	
	$("clmLossPdAmt").observe("change", function(){
		if($F("clmLossPdAmt").blank()){
			$("clmLossPdAmt").value = "0.00";
		}
		computeTotal();
	});
	
	$("clmLossExpAmt").observe("change", function(){
		if($F("clmLossExpAmt").blank()){
			$("clmLossExpAmt").value = "0.00";
		}
		computeTotal();
	});
	
	$("clmRecoverableAmt").observe("change", function(){
		if($F("clmRecoverableAmt").blank()){
			$("clmRecoverableAmt").value = "0.00";
		}
		computeTotal();
	});
	
	$("searchCharge").observe("click", function(){
		var notIn = "";
		notIn = createNotInParamInObj(objIntreatyCharges, function(obj){return nvl(obj.recordStatus, 0) != -1;}, "chargeCd");
		
		LOV.show({
			controller: "UWReinsuranceLOVController",
			urlParameters: {action : "getGIRIS056ChargesLOV",
							notIn : notIn,
							page : 1},
			title: "Charges",
			width: 435,
			height: 320,
			columnModel : [	{	id : "taxCd",
								title: "Charges Code",
								width: '100px',
								renderer : function(value){
									return lpad(value.toString(), 2, "0");
				           		}
							},
							{	id : "taxName",
								title: "Charges Description",
								width: '300px'
							}
						],
			draggable: true,
			onSelect: function(row){
				if(row != null || row != undefined){
					$("taxCd").value   = row.taxCd;
					$("taxName").value = unescapeHTML2(row.taxName);
					$("wTax").value    = "N";
					changeTag = 1;
				}			   
			},
			onCancel: function(){
				$("taxName").focus();
			},
			onUndefinedRow:	function(){
				customShowMessageBox("No record selected.", imgMessage.INFO, "taxName");
			}
		});
	});
	
	$("dspAmount").observe("focus", function(){
		if($F("taxName").blank()){
			customShowMessageBox("Please select charges description first.", imgMessage.ERROR, "taxName");
			return false;
		}
	});
	
	$("btnAddCharges").observe("click", function(){
		if(nvl($F("wTax"), "N") == "Y"){
			showMessageBox("Updating/Deleting of record which has Tax/es is not allowed. Delete first Tax/es.", imgMessage.INFO);
			return false;
		}else if($F("taxName").blank()){
			customShowMessageBox("Charge Description is required.", imgMessage.INFO, "taxName");
			return false;
		}else if($F("dspAmount").blank()){
			customShowMessageBox("Amount is required.", imgMessage.INFO, "dspAmount");
			return false;
		}else{
			var newObj = new Object();
			newObj.intreatyId = $F("intreatyId");
			newObj.chargeCd   = $F("taxCd");
			newObj.taxName    = unescapeHTML2($F("taxName"));
			newObj.amount 	  = parseFloat(unformatNumber($F("dspAmount")));
 			newObj.dspAmount  = parseFloat(unformatNumber($F("dspAmount")));
			newObj.wTax       = nvl($F("wTax"), "N");
			
			if($F("btnAddCharges") == "Update"){
				newObj.recordStatus = 1;
				for (var i=0; i<objIntreatyCharges.length; i++) {
					if((objIntreatyCharges[i].intreatyId == newObj.intreatyId) && (objIntreatyCharges[i].chargeCd == newObj.chargeCd)){
						objIntreatyCharges.splice(i, 1);
						objIntreatyCharges.push(newObj);
					}
				}
				tbgCharges.updateVisibleRowOnly(newObj, tbgCharges.getCurrentPosition()[1]);
			}else{
				newObj.recordStatus = 0;
				tbgCharges.addBottomRow(newObj);
				addNewJSONObject(objIntreatyCharges, newObj);
				newObj = null;												
			}
			computeTotal();
			setChargesForm(null);
			updateTGPager(tbgCharges);
		}
	});
	
	$("btnDeleteCharges").observe("click", function (){
		if(nvl($F("wTax"), "N") == "Y"){
			showMessageBox("Updating/Deleting of record which has Tax/es is not allowed. Delete first Tax/es.", imgMessage.INFO);
			return false;
		}else{
			var deletedObj = new Object();
			deletedObj.intreatyId = $F("intreatyId");
			deletedObj.chargeCd   = $F("taxCd");
			deletedObj.taxName    = unescapeHTML2($F("taxName"));
			deletedObj.amount 	  = parseFloat(unformatNumber($F("amount")));
			deletedObj.dspAmount  = parseFloat(unformatNumber($F("dspAmount")));
			deletedObj.wTax       = nvl($F("wTax"), "N");
			
			addDelObjByAttr(objIntreatyCharges, deletedObj, "intreatyId chargeCd");
			tbgCharges.deleteVisibleRowOnly(tbgCharges.getCurrentPosition()[1]);
			computeTotal();
			setChargesForm(null);
			updateTGPager(tbgCharges);
		}
	});
	
	$("btnTax").observe("click", function(){
		if(nvl($F("intreatyId"), "0") == "0"){
			customShowMessageBox("Please save changes first.", imgMessage.INFO, "btnSave");
			return false;
		}else if(getAddedAndModifiedJSONObjects(objIntreatyCharges).length > 0 || getDeletedJSONObjects(objIntreatyCharges).length > 0){
			customShowMessageBox("Please save changes first.", imgMessage.INFO, "btnSave");
			return false;
		}else if($F("taxName").blank()){
			customShowMessageBox("Please select charges description first.", imgMessage.INFO, "taxName");
			return false;
		}else if($F("dspAmount").blank()){
			customShowMessageBox("Please enter amount first.", imgMessage.INFO, "dspAmount");
			return false;
		}else{
			var contentDiv = new Element("div", {id : "modal_content_tax"});
		    var contentHTML = '<div id="modal_content_tax"></div>';
		    
		    inchargesTaxWin = Overlay.show(contentHTML, {
								id: 'modal_dialog_tax',
								title: "Taxes",
								width: 1100,
								height: 460,
								draggable: true
							});
		    
		    new Ajax.Updater("modal_content_tax", contextPath+"/GIRIIntreatyController", {
				evalScripts: true,
				asynchronous: false,
				parameters:{
					action: "showInchargesTax",
					intreatyId: $F("intreatyId"),
					charge: $F("taxName"),
					chargeCd: $F("taxCd"),
					chargeAmount: $F("amount")
				},
				onCreate: function(){
					showNotice("Processing, please wait...");
				},
				onComplete: function(response){
					hideNotice();
					if (!checkErrorOnResponse(response)){
						showMessageBox(response.responseText, imgMessage.ERROR);
					}
				}
			});
		}
	});
	
	$("btnCancel").observe("click", function(){
		if(nvl($F("intrtyFlag"), "1") != "1"){
			changeTag = 0;
		}
		
		if(changeTag == 1) {
			showConfirmBox4("Confirmation", objCommonMessage.WITH_CHANGES, "Yes", "No", "Cancel", 
					function(){
						saveIntreaty();
					},
					function(){
						changeTag = 0;
						showIntreatyListing($F("lineCd"), $F("trtyYy"), $F("shareCd"));
					},
					"");
		} else {
			showIntreatyListing($F("lineCd"), $F("trtyYy"), $F("shareCd"));
		}
	});
	
	$("btnSave").observe("click", function(){
		saveIntreaty();
	});
	
	populateIntreaty(objIntreaty);
	populateDistShare(objDistShare);
	computeTotal();
	$("currRate").value = formatToNineDecimal($("currency").options[$("currency").selectedIndex].getAttribute("currRate"));
	
</script>