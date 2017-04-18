<div id="perilTG" name="perilTG" class="sectionDiv" style="width:750px;height:150px;margin:10px auto 65px auto; float:left; border:none;">
	<div id="perilListing" style="height:150px;width:600px;float:left;margin:35px 15px 15px 25px;align:center;"></div>
	
	<div id="withInvoiceDiv" class="sectionDiv" style="width:80px;margin:35px 10px 10px auto;align:center;">
		<table align="center" border="0">
			<tr><td align="center"><input type="checkbox" id="chkWithInvoice" name="chkWithInvoice" disabled="disabled" /></td></tr>
			<tr><td align="center">With<br/>Invoice</td></tr>
		</table>
		<!-- <label for="chkWithInvoice" id="lblChkWithInvoice">With Invoice</label> -->
	</div>
</div>

<script type="text/javascript">
	var objOpenPeril = new Object();
	objOpenPeril.objOpenPerilListTableGrid = JSON.parse('${openPerilList}'.replace(/\\/g, '\\\\'));
	objOpenPeril.objOpenPerilList = objOpenPeril.objOpenPerilListTableGrid.rows || [];
	
	var moduleId = '${moduleId}';	
	var url;
	
	if(moduleId == "GIPIS100"){
		url = contextPath + "/GIPIOpenPolicyController?action=getOpenCargos&policyId=" + $F("hidPolicyId")
		+ "&geogCd=" + $F("hidGeogCd");
	} else {
		url = contextPath + "/GIXXOpenPerilController?action=getGIXXOpenPerilList" + "&refresh=1" +
		"&extractId=" + $F("hidExtractId") + "&geogCd=" + $F("hidGeogCd");
	}
	
	try {
		var perilTableModel = {
				url : url,
				options: {
					title: '',
					width: '600px',
					height: '140px',
					onCellFocus: function(element, value, x, y, id){
						openPerilTableGrid.keys.removeFocus(openPerilTableGrid.keys._nCurrentFocus, true);
						openPerilTableGrid.keys.releaseKeys();	
						//toggleChkWithInvoice(openPerilTableGrid.geniisysRows[y]);
					},
					onRowDoubleClick: function (param){
						
					}
				},
				columnModel: [
				           { 	
				        	    id: 'recordStatus',
								title: '',
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
								id: 'extractId',
								title: 'extractId',
								width: '0px',
								visible: false
							},
							{
								id: 'geogCd',
								title: 'geogCd',
								width: '0px',
								visible: false
							},
							{
								id: 'withInvoiceTag',
								title: 'withInvoiceTag',
								width: '0px',
								visible: false
							},
							{
								id: 'perilName',
								title: 'Peril',
								titleAlign: 'center',
								width: '225px',
								visible: true
							},
							{
								id: 'premRate',
								title: 'Premium Rate',
								titleAlign: 'center',
								width: '140px',
								align: 'right',
								geniisysClass: 'rate',
								visible: true
							},
							{
								id: 'remarks',
								title: 'Remarks',
								titleAlign: 'center',
								width: '217px',
								visible: true
							}],									
				rows: objOpenPeril.objOpenPerilList					
		} ;
		openPerilTableGrid = new MyTableGrid(perilTableModel);
		openPerilTableGrid.pager = objOpenPeril.objOpenPerilListTableGrid;
		openPerilTableGrid.render("perilListing");
		openPerilTableGrid.afterRender = hideNotice();
		
	} catch (e) {
		showErrorMessage("initializePerilTG", e);
	}

	/* function toggleChkWithInvoice(obj){
		$("chkWithInvoice").checked = obj.withInvoiceTag == "Y" ? true : false;
	} */
	
	//$("chkWithInvoice").checked = openPerilTableGrid.getValueAt(4,0) == "Y" ? true : false;
	$("chkWithInvoice").checked = '${withInvoiceTag}' == "Y" ? true : false;
	
</script>
