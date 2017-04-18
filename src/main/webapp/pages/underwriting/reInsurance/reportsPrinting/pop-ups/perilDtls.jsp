<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<%@ taglib prefix="json" uri="http://www.atg.com/taglibs/json" %>
<%@ taglib prefix="ajax" uri="http://ajaxtags.org/tags/ajax" %>

<%
	response.setHeader("Cache-control", "No-Cache");
	response.setHeader("Pragma", "No-Cache");
%>

<div id="perilDtlsMainDiv" name="perilDtlsMainDiv">
	<div id="perilDtlsTableGridDiv" name="perilDtlsTableGridDiv">
		<div id="perilDtlsTGDiv" name="perilDtlsTGDiv" style="padding: 15px 25px 10px 0px; height: 265px; width: 100%;"></div>
	
		<div id="perilDtlsBtnDiv" name="perilDtlsBtnDiv" class="buttonsDiv" style="margin-bottom: 10px; width: 100%;">
			<input id="btnOk" name="btnOk" class="button" type="button" value="Ok"/>
		</div>
	</div>
</div>

<script type="text/javascript">
	var cnt = 0;		// holds number of modified records
	var selectedIndex = -1;
	var selectedRow = "";
	
	var objRiPerilDtls = new Object();
	objRiPerilDtls.perilDtlsTG = JSON.parse('${perilDtlsTG}'.replace(/\\/g, '\\\\'));
	objRiPerilDtls.perilDtlsList = [];
	objRiPerilDtls.perilDtlsObjRows = objRiPerilDtls.perilDtlsTG.rows || [];
	
	try{
		var perilDtlsTableModel = {
			url: contextPath+"/GIRIGenerateRIReportsController?action=getGIRIBinderPerilDtls",
			options: {
				width: '1180px',
				height: '250px',
				toolbar: {
					elements: [MyTableGrid.SAVE_BTN],
					onSave: function(){
						checkChangesInPeril();
						if (cnt > 0){
							addBinderPerilPrintHist();
						}
					}
				}
			},
			columnModel: [
							{
								id: 'recordStatus',
								width: '0px',
								visible: false,
								editor: 'checkbox'
							},
							{
								id: 'divCtrId',
								width: '0px',
								visible: false
							},
							{
								id: 'fnlBinderId',
								width: '0px',
								visible: false
							},
							{
								id: 'perilSeqNo',
								width: '0px',
								visible: false
							},
							{
								id: 'perilSName',
								title: 'Peril',
								width: '120px',
								titleAlign: 'center',
								editable: false,
								sortable: false
							},
							{
								id: 'nbtRiSharePct',
								width: '0px',
								visible: false
							},
							{
								id: 'riSharePct',
								title: 'RI Share %',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								sortable: false,
								geniisysClass: 'rate',
								geniisysErrorMsg: 'Field must be in the form 990.9999999.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riSharePct')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiTsiAmt',
								width: '0px',
								visible: false
							},
							{
								id: 'riTsiAmt',
								title: 'RI TSI Amount',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riTsiAmt')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiPremAmt',
								width: '0px',
								visible: false
							},
							{
								id: 'riPremAmt',
								title: 'RI Prem. Amt.',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riPremAmt')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiCommRt',
								width: '0px',
								visible: false
							},
							{
								id: 'riCommRt',
								title: 'RI Comm. Rt.',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'rate',
								sortable: false,
								geniisysErrorMsg: 'Field must be in the form 990.9999999.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riCommRt')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiCommAmt',
								width: '0px',
								visible: false
							},
							{
								id: 'riCommAmt',
								title: 'RI Comm. Amt.',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riCommAmt')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiCommVat',
								width: '0px',
								visible: false
							},
							{
								id: 'riCommVat',
								title: 'RI Comm. VAT',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riCommVat')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiWholdingVat',
								width: '0px',
								visible: false
							},
							{
								id: 'riWholdingVat',
								title: 'RI Wholding VAT',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riWholdingVat')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiPremVat',
								width: '0px',
								visible: false
							},
							{
								id: 'riPremVat',
								title: 'RI Prem. VAT',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riPremVat')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtRiPremTax',
								width: '0px',
								visible: false
							},
							{
								id: 'riPremTax',
								title: 'RI Prem. Tax',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('riPremTax')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'nbtGrossPrem',
								width: '0px',
								visible: false
							},
							{
								id: 'grossPrem',
								title: 'Gross Premium',
								width: '100px',
								titleAlign: 'center',
								align: 'right',
								maxlength: 12,
								geniisysClass: 'money',
								sortable: false,
								geniisysErrorMsg: 'Money format is [+-]9999999.99.',
								editable: true,
								editor: new MyTableGrid.CellInput({
									validate: function(value, input){
										var val = parseFloat((value*1));
										
										if(value != "" || value!= null){
											if (isNaN(val)){
												showMessageBox(perilDtlsTableGrid.columnModel[perilDtlsTableGrid.getColumnIndex('grossPrem')].geniisysErrorMsg ,imgMessage.ERROR);
											}else {
											}	
										}
										
										return input;
									}
								})
							},
							{
								id: 'changeFlg',
								width: '0px',
								visible: false
							}
				],
				rows: objRiPerilDtls.perilDtlsObjRows
		};
		
		perilDtlsTableGrid = new MyTableGrid(perilDtlsTableModel);
		perilDtlsTableGrid.pager = objRiPerilDtls.perilDtlsTG;
		perilDtlsTableGrid.render('perilDtlsTGDiv');
		perilDtlsTableGrid.afterRender = function(){
			objRiPerilDtls.perilDtlsList = perilDtlsTableGrid.geniisysRows;
		};
	}catch (e) {
		showMessageBox("Error in Peril Details TableGrid: " + e, imgMessage.ERROR);
	}
	
	$("btnOk").observe("click", function(){	
		checkChangesInPeril();
		if (cnt > 0){
			showMessageBox("Please save changes first.", imgMessage.ERROR);
		}else {
			genericObjOverlay.close();
		}
	});
	
	function checkChangesInPeril(){
		cnt = 0;
		for (var i = 0; i < objRiPerilDtls.perilDtlsList.length; i++){
			if ((perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riSharePct'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiSharePct'), i)) || 
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riTsiAmt'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiTsiAmt'), i)) || 
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riPremAmt'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiPremAmt'), i)) || 
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riCommRt'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiCommRt'), i)) || 
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riCommAmt'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiCommAmt'), i)) || 
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riCommVat'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiCommVat'), i)) ||
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riWholdingVat'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiWholdingVat'), i)) ||
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riPremVat'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiPremVat'), i)) ||
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riPremTax'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtRiPremTax'), i)) ||
				(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('grossPrem'), i) != perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('nbtGrossPrem'), i))){
				
				perilDtlsTableGrid.setValueAt('Y', perilDtlsTableGrid.getColumnIndex('changeFlg'), i);
				cnt++;
			}
		}		
	}
	
	
	function addBinderPerilPrintHist(){
		try{
			var objPerils = perilDtlsTableGrid.getModifiedRows();
			var strParams = prepareJsonAsParameter(objPerils);
			new Ajax.Request(contextPath+"/GIRIGenerateRIReportsController",{
				method: "GET",
				parameters: {
					action: "addBinderPerilPrintHist",
					perils: strParams
				},
				evalScripts: true,
				asynchronous: true,
				onComplete: function (response){
					setNbtColumnValues();
				}
			});
		}catch(e){
			showErrorMessage("addBinderPerilPrintHist", e);
		}
	}
	
	function setNbtColumnValues(){
		for (var i = 0; i < objRiPerilDtls.perilDtlsList.length; i++){
			if (perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('changeFlg'), i) == 'Y' ){
				// set new values to nbt columns	
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riSharePct'), i), perilDtlsTableGrid.getColumnIndex('nbtRiSharePct'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riTsiAmt'), i), perilDtlsTableGrid.getColumnIndex('nbtRiTsiAmt'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riPremAmt'), i), perilDtlsTableGrid.getColumnIndex('nbtRiPremAmt'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riCommRt'), i), perilDtlsTableGrid.getColumnIndex('nbtRiCommRt'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riCommAmt'), i), perilDtlsTableGrid.getColumnIndex('nbtRiCommAmt'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riCommVat'), i), perilDtlsTableGrid.getColumnIndex('nbtRiCommVat'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riWholdingVat'), i), perilDtlsTableGrid.getColumnIndex('nbtRiWholdingVat'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riPremVat'), i), perilDtlsTableGrid.getColumnIndex('nbtRiPremVat'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('riPremTax'), i), perilDtlsTableGrid.getColumnIndex('nbtRiPremTax'), i); 
				perilDtlsTableGrid.setValueAt(perilDtlsTableGrid.getValueAt(perilDtlsTableGrid.getColumnIndex('grossPrem'), i), perilDtlsTableGrid.getColumnIndex('nbtGrossPrem'), i); 
				
				perilDtlsTableGrid.setValueAt('N', perilDtlsTableGrid.getColumnIndex('changeFlg'), i);
				cnt--;
			}
		}
	}
	
	
</script>