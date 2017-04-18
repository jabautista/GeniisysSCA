<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="viewIntreatyMainDiv" name="viewIntreatyMainDiv">
	<jsp:include page="/pages/toolbar.jsp"></jsp:include>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" name="innerDiv">
			<label>Proportional Treaty / Panel</label> 		
	   	</div>
	</div>
	<div class="sectionDiv" id="treatyPanelDiv" name="treatyPanelDiv" align="center">
		<input type="hidden" id="intreatyId" name="intreatyId">
		<table align="center" cellspacing="1" border="0" style="margin: 10px 10px 10px 10px;">
			<tr>
				<td class="rightAligned">Inward Treaty No.</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 75px;">
						<input type="text" style="width: 45px; float: left; border: none; height: 13px; margin: 0;" id="lineCd" name="lineCd" class="allCaps required" lastValidValue="" ignoreDelKey="1" maxlength="2" value=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchLineCd" name="searchLineCd" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 75px;">
						<input type="text" style="width: 45px; float: left; border: none; height: 13px; margin: 0;" id="trtyYy" name="trtyYy" class="integerNoNegativeUnformattedNoComma required" lastValidValue="" ignoreDelKey="1" maxlength="2" value=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchTrtyYy" name="searchTrtyYy" alt="Go" style="float: right;"/>
					</span>
				</td>
				<td class="leftAligned">
					<span class="lovSpan required" style="width: 200px;">
						<input type="text" style="width: 170px; float: left; border: none; height: 13px; margin: 0;" id="intrtySeqNo" name="intrtySeqNo" class="integerNoNegativeUnformattedNoComma required" lastValidValue="" ignoreDelKey="1" maxlength="5" value=""/>
						<img src="${pageContext.request.contextPath}/images/misc/searchIcon.png" id="searchIntrtySeqNo" name="searchIntrtySeqNo" alt="Go" style="float: right;"/>
					</span>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Line</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 362px;" id="lineName" name="lineName" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Treaty Year</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 362px;" id="dspTrtyYy" name="dspTrtyYy" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Treaty Name</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 362px;" id="trtyName" name="trtyName" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Treaty Term</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 362px;" id="trtyTerm" name="trtyTerm" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Reinsurer</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 362px;" id="riName" name="riName" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Share %</td>
				<td class="leftAligned" colspan="3">
					<input type="text" style="width: 362px;" id="trtyShrPct" name="trtyShrPct" readonly="readonly" value=""/>
				</td>
			</tr>
		</table>
	</div>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" name="innerDiv">
			<label>Inward Treaty Information</label> 		
	   	</div>
	</div>
	<div class="sectionDiv" id="intreatyInfoDiv" name="intreatyInfoDiv" align="center">
		<table align="center" cellspacing="1" border="0" style="margin: 10px 10px 10px 10px;">
			<tr>
				<td class="rightAligned">Accept Date</td>
				<td class="leftAligned">
					<input type="text" style="width: 213px; margin-right: 20px;" id="acceptDate" name="acceptDate" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned">Period</td>
				<td class="leftAligned">
					<input type="text" style="width: 100px; margin-right: 20px;" id="period" name="period" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned">Booking Date</td>
				<td class="leftAligned">
					<input type="text" style="width: 120px; margin-right: 20px;" id="bookingMonth" name="bookingMonth" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Approved</td>
				<td class="leftAligned">
					<input type="text" style="width: 100px;" id="approveBy" name="approveBy" readonly="readonly" value=""/>
					<input type="text" style="width: 100px; margin-right: 20px;" id="approveDate" name="approveDate" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned">Acct Ent Date</td>
				<td class="leftAligned">
					<input type="text" style="width: 100px; margin-right: 20px;" id="acctEntDate" name="acctEntDate" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cancelled</td>
				<td class="leftAligned">
					<input type="text" style="width: 100px;" id="cancelUser" name="cancelUser" readonly="readonly" value=""/>
					<input type="text" style="width: 100px; margin-right: 20px;" id="cancelDate" name="cancelDate" readonly="readonly" value=""/>
				</td>
				<td class="rightAligned">Acct Neg Date</td>
				<td class="leftAligned">
					<input type="text" style="width: 100px; margin-right: 20px;" id="acctNegDate" name="acctNegDate" readonly="readonly" value=""/>
				</td>
			</tr>
		</table>
		<table align="center" cellspacing="1" border="0" style="margin: 20px 10px 10px 40px;">
            <tr>
				<td class="rightAligned">Currency</td>
				<td class="leftAligned">
					<input type="text" style="width: 75px;" id="shortName" name="shortName" readonly="readonly" value=""/>
					<input type="text" style="width: 209px;" id="currencyRt" name="currencyRt" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Premium</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="riPremAmt" name="riPremAmt" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Commission</td>
				<td class="rightAligned" colspan="2">
					<input type="text" style="width: 75px;" id="riCommRt" name="riCommRt" class="rightAligned" readonly="readonly" value=""/>
					<input type="text" style="width: 209px;" id="riCommAmt" name="riCommAmt" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Vat</td>
				<td class="rightAligned" colspan="2">
					<input type="text" style="width: 75px;" id="riVatRt" name="riVatRt" class="rightAligned" readonly="readonly" value=""/>
					<input type="text" style="width: 209px;" id="riCommVat" name="riCommVat" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Losses Paid</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="clmLossPdAmt" name="clmLossPdAmt" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Losses Expense</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="clmLossExpAmt" name="clmLossExpAmt" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Cash Call Refund</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="clmRecoverableAmt" name="clmRecoverableAmt" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Charges</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="chargeAmount" name="chargeAmount" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Total</td>
				<td class="leftAligned" colspan="2">
					<input type="text" style="width: 296px;" id="totalAmt" name="totalAmt" class="rightAligned" readonly="readonly" value=""/>
				</td>
			</tr>
		</table>
	</div>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" name="innerDiv">
			<label>Charges Information</label> 		
	   	</div>
	</div>
	<div class="sectionDiv" id="chargesInfoDiv" name="chargesInfoDiv" align="center">
		<div id="chargesInfoTableGridDiv" style="padding: 10px 0 10px 10px;">
			<div id="chargesInfoTableGrid" style="height: 250px"></div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" name="innerDiv">
			<label>Taxes</label> 		
	   	</div>
	</div>
	<div class="sectionDiv" id="taxesInfoDiv" name="taxesInfoDiv" align="center">
		<div id="taxesInfoTableGridDiv" style="padding: 10px 0 10px 10px;">
			<div id="taxesInfoTableGrid" style="height: 250px"></div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv" style="float:left">
		<div id="innerDiv" name="innerDiv">
			<label>Payment Information</label> 		
	   	</div>
	</div>
	<div class="sectionDiv" id="paymentInfoDiv" name="paymentInfoDiv" align="center">
		<div id="paymentInfoTableGridDiv" style="padding: 10px 0 10px 10px;">
			<div id="paymentInfoTableGrid" style="height: 100px"></div>
		</div>
	</div>
</div>
<script type="text/javascript">
	setModuleId("GIRIS057");
	setDocumentTitle("View Inward Treaty");
	initializeAll();
	initializeAccordion();
	
	function populateViewIntreaty(obj){
		hideToolbarButton("btnToolbarPrint");
		hideToolbarButton("btnToolbarExecuteQuery");
		disableToolbarButton("btnToolbarEnterQuery");
		disableSearch("searchTrtyYy");
		disableSearch("searchIntrtySeqNo");
		$("trtyYy").readOnly = true;
		$("intrtySeqNo").readOnly = true;
		
		if(nvl(obj.intreatyId, 0) > 0){
			enableToolbarButton("btnToolbarEnterQuery");
			disableSearch("searchLineCd");
			$("lineCd").readOnly = true;
			$("intreatyId").value 		 =  obj.intreatyId;
			$("lineCd").value 		 	 =  obj.lineCd;
			$("trtyYy").value 		 	 =  obj.trtyYy;
			$("intrtySeqNo").value 		 =  obj.intrtySeqNo;
			$("lineName").value 		 =  unescapeHTML2(obj.lineName);
			$("dspTrtyYy").value 		 =  obj.dspTrtyYy;
			$("trtyName").value 		 =  unescapeHTML2(obj.trtyName);
			$("trtyTerm").value 		 =  unescapeHTML2(obj.trtyTerm);
			$("riName").value 		 	 =  unescapeHTML2(obj.riName);
			$("trtyShrPct").value 		 =  obj.trtyShrPct;
			$("acceptDate").value 		 =  obj.acceptDate;
			$("period").value 		 	 =  obj.period;
			$("bookingMonth").value 	 =  unescapeHTML2(obj.bookingMonth);
			$("approveBy").value 		 =  unescapeHTML2(obj.approveBy);
			$("approveDate").value 		 =  obj.approveDate;
			$("acctEntDate").value 		 =  obj.acctEntDate;
			$("cancelUser").value 		 =  unescapeHTML2(obj.cancelUser);	
			$("cancelDate").value 		 =  obj.cancelDate;	
			$("acctNegDate").value 		 =  obj.acctNegDate;	
			$("shortName").value 		 =  unescapeHTML2(obj.shortName);
			$("currencyRt").value 		 =  obj.currencyRt;
			$("riPremAmt").value 		 =  formatCurrency(obj.riPremAmt);	
			$("riCommRt").value 		 =  obj.riCommRt;
			$("riCommAmt").value 		 =  formatCurrency(obj.riCommAmt);
			$("riVatRt").value 		 	 =  obj.riVatRt;
			$("riCommVat").value 		 =  formatCurrency(obj.riCommVat);
			$("clmLossPdAmt").value 	 =  formatCurrency(obj.clmLossPdAmt);
			$("clmLossExpAmt").value 	 =  formatCurrency(obj.clmLossExpAmt);
			$("clmRecoverableAmt").value =  formatCurrency(obj.clmRecoverableAmt);
			$("chargeAmount").value 	 =  formatCurrency(obj.chargeAmount);
			
			var premAmt = nvl($F("riPremAmt"), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("riPremAmt")));
			var commAmt = nvl($F("riCommAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("riCommAmt")));
			var commVat = nvl($F("riCommVat").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("riCommVat")));
			var lossPd = nvl($F("clmLossPdAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("clmLossPdAmt")));
			var lossExp = nvl($F("clmLossExpAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("clmLossExpAmt")));
			var recovAmt = nvl($F("clmRecoverableAmt").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("clmRecoverableAmt")));
			var charges = nvl($F("chargeAmount").replace(/,/g, ""), "0.00") == "0.00" ? 0 : parseFloat(unformatNumber($F("chargeAmount")));
			
			$("totalAmt").value = formatCurrency(premAmt - (commAmt + commVat) - (lossPd + lossExp) + recovAmt + charges);
		}
	}
	
	var objViewIntreaty = JSON.parse('${viewIntreaty}');
	var objIntreatyChargesTG = JSON.parse('${giriIntreatyChargesTG}');
	var chargesTableModel = {
		options: {
			width: '900px',
			pager: {},
			beforeSort : function(){
				tbgCharges.url = contextPath+"/GIRIIntreatyController?action=getIntreatyChargesTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId"));
			},
			onSort : function(){
				tbgCharges.keys.removeFocus(tbgCharges.keys._nCurrentFocus, true);
				tbgCharges.keys.releaseKeys();
				tbgTaxes.url = contextPath+"/GIRIIntreatyController?action=getInchargesTaxTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId"))+"&chargeCd=0";
				tbgTaxes._refreshList();
			},
			onRefresh : function(){
				tbgCharges.keys.removeFocus(tbgCharges.keys._nCurrentFocus, true);
				tbgCharges.keys.releaseKeys();
				tbgTaxes.url = contextPath+"/GIRIIntreatyController?action=getInchargesTaxTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId"))+"&chargeCd=0";
				tbgTaxes._refreshList();
			},
			onCellFocus : function(element, value, x, y, id) {
				tbgCharges.keys.removeFocus(tbgCharges.keys._nCurrentFocus, true);
				tbgCharges.keys.releaseKeys();
				tbgTaxes.url = contextPath+"/GIRIIntreatyController?action=getInchargesTaxTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId"))+"&chargeCd="+tbgCharges.geniisysRows[y].chargeCd;
				tbgTaxes._refreshList();
			},			
			onRemoveRowFocus : function(element, value, x, y, id){
				tbgCharges.keys.removeFocus(tbgCharges.keys._nCurrentFocus, true);
				tbgCharges.keys.releaseKeys();
				tbgTaxes.url = contextPath+"/GIRIIntreatyController?action=getInchargesTaxTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId"))+"&chargeCd=0";
				tbgTaxes._refreshList();
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
	
	var objInchargesTaxTG = JSON.parse('${giriInchargesTaxTG}');
	var taxesTableModel = {
		url : contextPath+"/GIRIIntreatyController?action=getInchargesTaxTG&refresh=1&intreatyId="+encodeURIComponent($F("intreatyId"))+"&chargeCd=0",
		options: {
			width: '900px',
			pager: {},
			onSort : function(){
				tbgTaxes.keys.removeFocus(tbgTaxes.keys._nCurrentFocus, true);
				tbgTaxes.keys.releaseKeys();
			},
			onRefresh : function(){
				tbgTaxes.keys.removeFocus(tbgTaxes.keys._nCurrentFocus, true);
				tbgTaxes.keys.releaseKeys();
			},
			onRemoveRowFocus : function(element, value, x, y, id){
				tbgTaxes.keys.releaseKeys();
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
  			{	id: 'taxType',
  				width: '45',
  				title: '&nbsp;&nbsp;Type',
  				titleAlign : 'center',
  				align: 'center',
  				editable: false
  			},
  			{	id: 'taxCd',
  				width: '75',
  				title: '&nbsp;&nbsp;Tax Code',
  				titleAlign : 'center',
  				align: 'center',
  				editable: false,
  				renderer : function(value){
  					return lpad(value.toString(), 5, "0");
  	       		}
  			},
  			{	id: 'taxName',
  				width: '175',
  				title: 'Tax Name',
  				editable: false,
  				renderer : function(value){
  					return unescapeHTML2(value);
  	       		}
  			},
  			{	id: 'slTypeCd',
  				width: '0',
  				visible: false 
  			},
  			{	id: 'slCd',
  				width: '100',
  				title: '&nbsp;&nbsp;&nbsp;SL Code',
  				titleAlign : 'center',
  				align: 'center',
  				editable: false,
  				renderer : function(value){
  					return lpad(value.toString(), 12, "0");
  	       		}
  			},
  			{	id: 'charge',
  				width: '175',
  				title: 'Charge',
  				editable: false,
  				renderer : function(value){
  					return unescapeHTML2(value);
  	       		}
  			},
  			{	id: 'chargeCd',
  				width: '0',
  				visible: false 
  			},
  			{	id: 'chargeAmt',
  				width: '100',
  				title: 'Charge Amount',
  				titleAlign : 'right',
  				align: 'right',
  				editable: false,
  				type : 'number',
  				geniisysClass : 'money'
  			},
  			{	id: 'taxPct',
  				width: '100',
  				title: 'Tax Pct.',
  				titleAlign : 'right',
  				align: 'right',
  				editable: false,
  				type : 'number',
  				geniisysClass : 'rate'
  			},
  			{	id: 'taxAmt',
  				width: '100',
  				title: 'Tax Amount',
  				titleAlign : 'right',
  				align: 'right',
  				editable: false,
  				type : 'number',
  				geniisysClass : 'money'
  			}
  		],
		rows: objInchargesTaxTG.rows || []
	};
	tbgTaxes = new MyTableGrid(taxesTableModel);
	tbgTaxes.pager = objInchargesTaxTG;
	tbgTaxes.render('taxesInfoTableGrid');
	
	function showLineCdLOV(){
		LOV.show({
			controller : "UWReinsuranceLOVController",
			urlParameters : {
				action : "getGIRIS057LineLOV",
				filterText: $F("lineCd") != $("lineCd").getAttribute("lastValidValue") ? $F("lineCd") + "%" : "%",
				page : 1
			},
			title : "List of Lines",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "lineCd",
				title : "Line Code",
				width : '120px'
			}, {
				id : "lineName",
				title : "Line Name",
				width : '315px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,			
			onSelect : function(row) {
				if (row != null || row != undefined) {
					$("lineCd").value = row.lineCd;
					if($F("lineCd") != $("lineCd").getAttribute("lastValidValue")){
						$("lineCd").setAttribute("lastValidValue", $F("lineCd"));
						$("trtyYy").value = "";
						$("trtyYy").setAttribute("lastValidValue", "");
						$("intrtySeqNo").value = "";
						$("intrtySeqNo").setAttribute("lastValidValue", "");
						enableSearch("searchTrtyYy");
						$("trtyYy").readOnly = false;
					}
					enableToolbarButton("btnToolbarEnterQuery");
				}
			},
			onCancel: function(){
				$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
				$("lineCd").focus();
			},
			onUndefinedRow:	function(){
				$("lineCd").value = $("lineCd").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "lineCd");
			}
		});
	}
	
	function showTrtyYyLOV(){
		LOV.show({
			controller : "UWReinsuranceLOVController",
			urlParameters : {
				action : "getGIRIS057TrtyYyLOV",
				lineCd : $F("lineCd"),
				filterText: $F("trtyYy") != $("trtyYy").getAttribute("lastValidValue") ? $F("trtyYy") + "%" : "%",
				page : 1
			},
			title : "List of Treaty Year",
			width : 450,
			height : 390,
			columnModel : [ {
				id : "dspTrtyYy",
				title : "Treaty Year",
				width : '150px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,			
			onSelect : function(row) {
				if (row != null || row != undefined) {
					$("trtyYy").value = row.trtyYy;
					if($F("trtyYy") != $("trtyYy").getAttribute("lastValidValue")){
						$("trtyYy").setAttribute("lastValidValue", $F("trtyYy"));
						$("intrtySeqNo").value = "";
						$("intrtySeqNo").setAttribute("lastValidValue", "");
						enableSearch("searchIntrtySeqNo");
						$("intrtySeqNo").readOnly = false;
					}
				}
			},
			onCancel: function(){
				$("trtyYy").value = $("trtyYy").readAttribute("lastValidValue");
				$("trtyYy").focus();
			},
			onUndefinedRow:	function(){
				$("trtyYy").value = $("trtyYy").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "trtyYy");
			}
		});
	}
	 
	function showIntrtySeqNoLOV(){
		LOV.show({
			controller : "UWReinsuranceLOVController",
			urlParameters : {
				action : "getGIRIS057IntrtySeqNoLOV",
				lineCd : $F("lineCd"),
				trtyYy : $F("trtyYy"),
				filterText: $F("intrtySeqNo") != $("intrtySeqNo").getAttribute("lastValidValue") ? lpad($F("intrtySeqNo"), 5, "0") + "%" : "%",
				page : 1
			},
			title : "List of Intreaty Sequence No",
			width : 650,
			height : 390,
			columnModel : [ {
				id : "intrtySeqNo",
				title : "InTreaty Seq. No.",
				width : '100px'
			}, {
				id : "riName",
				title : "Reinsurer",
				width : '315px'
			}, {
				id : "trtyName",
				title : "Treaty Name",
				width : '200px'
			} ],
			draggable : true,
			autoSelectOneRecord: true,			
			onSelect : function(row) {
				if (row != null || row != undefined) {
					$("intrtySeqNo").value = row.intrtySeqNo;
					if($F("intrtySeqNo") != $("intrtySeqNo").getAttribute("lastValidValue")){
						$("intrtySeqNo").setAttribute("lastValidValue", $F("intrtySeqNo"));
						showViewIntreaty($F("lineCd"), $F("trtyYy"), $F("intrtySeqNo"));
					}
				}
			},
			onCancel: function(){
				$("intrtySeqNo").value = $("intrtySeqNo").readAttribute("lastValidValue");
				$("intrtySeqNo").focus();
			},
			onUndefinedRow:	function(){
				$("intrtySeqNo").value = $("intrtySeqNo").readAttribute("lastValidValue");
				customShowMessageBox("No record selected.", imgMessage.INFO, "intrtySeqNo");
			}
		});
	}
	
	$("searchLineCd").observe("click", function() {
		showLineCdLOV();
	});
	
	$("searchTrtyYy").observe("click", function() {
		showTrtyYyLOV();
	});
	
	$("searchIntrtySeqNo").observe("click", function() {
		showIntrtySeqNoLOV();
	});
	
	$("lineCd").observe("change",function(){
		if($F("lineCd") == ""){
			$("lineCd").setAttribute("lastValidValue", "");
			$("trtyYy").value = "";
			$("trtyYy").setAttribute("lastValidValue", "");
			$("intrtySeqNo").value = "";
			$("intrtySeqNo").setAttribute("lastValidValue", "");
			disableToolbarButton("btnToolbarEnterQuery");
			disableSearch("searchTrtyYy");
			disableSearch("searchIntrtySeqNo");
		}else{
			showLineCdLOV();
		}
	});
	
	$("trtyYy").observe("change",function(){
		if($F("trtyYy") == ""){
			$("trtyYy").setAttribute("lastValidValue", "");
			$("intrtySeqNo").value = "";
			$("intrtySeqNo").setAttribute("lastValidValue", "");
			disableSearch("searchIntrtySeqNo");
		}else{
			showTrtyYyLOV();
		}
	});
	
	$("intrtySeqNo").observe("change",function(){
		if($F("intrtySeqNo") == ""){
			$("intrtySeqNo").setAttribute("lastValidValue", "");
		}else{
			showIntrtySeqNoLOV();
		}
	});
	
	$("btnToolbarEnterQuery").observe("click", function() {
		showViewIntreaty(null, null, null);
	});
	
	$("btnToolbarExit").observe("click", function() {
		goToModule("/GIISUserController?action=goToUnderwriting", "Underwriting Main", null);
	});
	
	populateViewIntreaty(objViewIntreaty);
</script>