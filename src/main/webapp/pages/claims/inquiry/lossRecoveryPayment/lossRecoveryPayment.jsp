<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>
<%
	response.setHeader("Cache-control", "no-cache");
	response.setHeader("Pragma", "no-cache");
%>

<div id="perLossRecoveryPaymentMainDiv" >
	<div id="perLossRecoveryPaymentSubMenu">
	 	<div id="mainNav" name="mainNav">
			<div id="smoothmenu1" name="smoothmenu1" class="ddsmoothmenu">
				<ul>
					<li><a id="btnExit">Exit</a></li>
				</ul>
			</div>
		</div>
	</div>
	<div id="outerDiv" name="outerDiv">
		<div id="innerDiv" name="innerDiv">
	   		<label>Loss Recovery Payment</label>
	   	</div>
	</div>
	<div class="sectionDiv">
		<div id="lossRecoveryPaymentTableDiv" style="padding: 10px 0 0 10px;">
			<div id="lossRecoveryPaymentTable" style="height: 340px"></div>
		</div>
		<div class="sectionDiv" style="margin: 10px; float: left; width: 97.5%;">
			<table style="margin: 5px; float: left;">
				<tr>
					<td class="rightAligned">Policy Number</td>
					<td class="leftAligned"><input type="text" readonly="readonly" id="txtPolicyNumber" style="width: 420px;" tabindex="301"></td>
					<td class="rightAligned" style="width: 110px;">Loss Category</td>
					<td class="leftAligned"><input type="text" readonly="readonly" id="txtLossCategory" style="width: 230px;" tabindex="302"/></td>
				</tr>
				<tr>
					<td class="rightAligned">Assured</td>
					<td class="leftAligned"><input type="text" readonly="readonly" id="txtAssured" style="width: 420px;" tabindex="303"></td>
					<td class="rightAligned" style="width: 110px;">Loss Date</td>
					<td class="leftAligned"><input type="text" readonly="readonly" id="txtLossDate" style="width: 230px;" tabindex="304"/></td>
				</tr>
			</table>
		</div>
	</div>
	<div style="float: left; width: 100%; margin-bottom: 10px; margin-top: 10px;" align="center">
		<input type="button" class="button" id="btnRecoveryDtls" value="Payment Details" tabindex="401"/>
	</div>
</div>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/claims/claims.js">
	try {
		initializeAll();
		setModuleId("GICLS270");
		setDocumentTitle("Claim Listing Per Loss Recovery Payment");
		var jsonLossRecoveryPayment = JSON.parse('${jsonLossRecoveryPayment}');
		filterOn = false;
		
		lossRecoveryPaymentTableModel = {
				url: contextPath+"/GICLLossRecoveryPaymentController?action=showLossRecoveryPayment&refresh=1",
				options: {
					toolbar:{
					elements: [MyTableGrid.FILTER_BTN, MyTableGrid.REFRESH_BTN],
					onFilter : function(){
						setDetailsForm(null);
						tbgLossRecoveryPayment.keys.removeFocus(tbgLossRecoveryPayment.keys._nCurrentFocus, true);
						tbgLossRecoveryPayment.keys.releaseKeys();
						filterOn = true;
					}
				},
				width: '900px',
				pager: {
				},
				onCellFocus : function(element, value, x, y, id) {
					var rec = tbgLossRecoveryPayment.geniisysRows[y];
					setDetailsForm(rec);					
					tbgLossRecoveryPayment.keys.removeFocus(tbgLossRecoveryPayment.keys._nCurrentFocus, true);
					tbgLossRecoveryPayment.keys.releaseKeys();
				},
				prePager: function(){
					setDetailsForm(null);
					tbgLossRecoveryPayment.keys.removeFocus(tbgLossRecoveryPayment.keys._nCurrentFocus, true);
					tbgLossRecoveryPayment.keys.releaseKeys();
					
				},
				onRemoveRowFocus : function(element, value, x, y, id){					
					setDetailsForm(null);
					
				},
				onSort : function(){
					setDetailsForm(null);
					tbgLossRecoveryPayment.keys.removeFocus(tbgLossRecoveryPayment.keys._nCurrentFocus, true);
					tbgLossRecoveryPayment.keys.releaseKeys();	
					
				},
				onRefresh : function(){
					setDetailsForm(null);
					tbgLossRecoveryPayment.keys.removeFocus(tbgLossRecoveryPayment.keys._nCurrentFocus, true);
					tbgLossRecoveryPayment.keys.releaseKeys();
					
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
					id : "recoveryNumber",
					title: "Recovery Number",
					width: '250px',
					filterOption : true
				},				
				{
					id : "claimNumber",
					title: "Claim Number",
					width: '250px',
					filterOption : true
				},
				{
					id : "cancelDesc",
					title: "Status",
					width: '120px',
					filterOption : true
				},
				{
					id : "recoverableAmt",
					title: "Recoverable Amount",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				},
				{
					id : "recoveredAmt",
					title: "Recovered Amount",
					width: '130px',
					filterOption : true,
					align : 'right',
					titleAlign : 'right',
					filterOptionType: 'number',
					geniisysClass: 'money'
				}
			],
			rows: jsonLossRecoveryPayment.rows
		};
		tbgLossRecoveryPayment = new MyTableGrid(lossRecoveryPaymentTableModel);
		tbgLossRecoveryPayment.pager = jsonLossRecoveryPayment;
		tbgLossRecoveryPayment.render('lossRecoveryPaymentTable');
		tbgLossRecoveryPayment.afterRender = function(){
			if(tbgLossRecoveryPayment.geniisysRows.length > 0){
				var rec = tbgLossRecoveryPayment.geniisysRows[0];
				objLossRec.recoveryId = rec.recoveryId;
				tbgLossRecoveryPayment.selectRow('0');
				setDetailsForm(rec);	//Gzelle 12.9.2013
			}else{
				objLossRec.recoveryId = "";
			}
		};
		
		function setDetailsForm(rec){
			try{
				$("txtPolicyNumber").value 		= rec == null ? "" : unescapeHTML2(rec.policyNumber);
				$("txtAssured").value			= rec == null ? "" : unescapeHTML2(rec.assuredName);
				$("txtLossCategory").value		= rec == null ? "" : unescapeHTML2(rec.lossCatDesc);
				$("txtLossDate").value			= rec == null ? "" : dateFormat(rec.lossDate, "mm-dd-yyyy");
				
				if(rec != null){
					//if(!rec.vCheck == 0){	Gzelle 12.9.2013
					if(rec.vCheck != 0){
						enableButton("btnRecoveryDtls");
						objLossRec.recoveryId = rec.recoveryId;
					}else{
						disableButton("btnRecoveryDtls");
						objLossRec = new Object();
					}
				}else {	//Gzelle 12.9.2013
					disableButton("btnRecoveryDtls");
					objLossRec = new Object();
				}
				
			} catch(e){
				showErrorMessage("setDetailsForm", e);
			}
		}
		
		//Observe Exit BUTTON
		$("btnExit").observe("click", function(){
			document.stopObserving("keyup");
			goToModule("/GIISUserController?action=goToClaims", "Claims Main", "");
		});
		
		$("btnRecoveryDtls").observe("click", showGicls270PaymentDetails);
		
		function initGICLS270(){
			disableButton("btnRecoveryDtls");
			objLossRec = new Object();
		}
		
		initGICLS270();
		initializeAccordion();
		
	} catch (e) {
		showErrorMessage("Claim Listing Per Loss Recovery Payment.", e);
	}
</script>