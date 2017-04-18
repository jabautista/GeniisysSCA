<div id="policyDtlsMainDiv" name="policyDtlsMainDiv">
	<div id="policyNoDiv" name="policyNoDiv" class="sectionDiv" style="float: left; width: 99%; height: 37px; margin-top: 3px; padding-top: 10px;" align="center">
		Policy No
		<input id="policyNo" name="policyNo" type="text" style="width: 250px;" readonly="readonly" tabindex="201">
	</div>
	
	<div id="outerDiv" name="outerDiv" style="width: 99%; margin-bottom: 1px;">
		<div id="innerDiv" name="innerDiv">
			<label>Unsettled Accounts</label>
			<span class="refreshers" style="margin-top: 0;">
				<label name="gro" style="margin-left: 5px;">Hide</label>
			</span>
		</div>
	</div>
	
	<div id="groDiv" name="groDiv">
		<div id="policyDtlsMainDiv" name="policyDtlsMainDiv" class="sectionDiv" style="height: 170px; width: 99%;">
			<div id="policyDtlsTGDiv" name="policyDtlsTGDiv" style="height: 170px; padding: 10px 0 0 85px;">
				
			</div>
		</div>
	</div>
	
	<div id="claimDetailsDiv" name="claimDetailsDiv"></div>
	
	<div id="buttonsDiv" align="center" style="margin-top: 10px; width: 99%; float: left;">
		<input id="btnClosePolicyDtls" name="btnClosePolicyDtls" type="button" class="button" value="Close" style="width: 100px;" tabindex="202">
	</div>
</div>

<script type="text/javascript">
	objSMSRenewal.policyDtlsTableGrid = JSON.parse('${policyDtlsTableGrid}');
	objSMSRenewal.policyDtlsRows = objSMSRenewal.policyDtlsTableGrid.rows || [];
	
	try {
		var policyDtlsTableGridModel = {
			url: contextPath+"/GIEXSmsDtlController?action=showPolicyDtlsOverlay&refresh=1"+
					"&lineCd="+objSMSRenewal.selectedRow.lineCd+"&sublineCd="+objSMSRenewal.selectedRow.sublineCd+
					"&issCd="+objSMSRenewal.selectedRow.issCd+"&issueYy="+objSMSRenewal.selectedRow.issueYy+
					"&polSeqNo="+objSMSRenewal.selectedRow.polSeqNo+"&renewNo="+objSMSRenewal.selectedRow.renewNo,
			options: {
				width: '400px',
				height: '125px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id) {
					policyDtlsTableGrid.keys.removeFocus(policyDtlsTableGrid.keys._nCurrentFocus, true);
					policyDtlsTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus : function(){
					policyDtlsTableGrid.keys.removeFocus(policyDtlsTableGrid.keys._nCurrentFocus, true);
					policyDtlsTableGrid.keys.releaseKeys();	
			  	},
			},
			columnModel: [
				{   
					id: 'recordStatus',
				    width: '0',
				    visible: false,
				    editor: 'checkbox' 	
				},
				{	
					id: 'divCtrId',
					width: '0',
					visible: false
				},
				{
					id: 'issCd premSeqNo',
					title: 'Invoice No.',
					children:
					[
						{
							id: 'issCd',
							width: 40
						} ,
						{
							id: 'premSeqNo',
							width: 75
						}
					]
				},
				{
					id: 'balanceDue',
					title: 'Balance Amount Due',
					width: '150px',
					align: 'right',
					geniisysClass: 'money'
				},
				{
					id: 'dueDate',
					title: 'Due Date',
					width: '100px',
					align: 'center'
				}
			],
			rows: objSMSRenewal.policyDtlsRows
		};
		policyDtlsTableGrid = new MyTableGrid(policyDtlsTableGridModel);
		policyDtlsTableGrid.pager = objSMSRenewal.policyDtlsTableGrid;
		policyDtlsTableGrid.render('policyDtlsTGDiv');
	}catch(e) {
		showErrorMessage("policyDtlsTableGrid", e);
	}
	
	function showClaimDtls(){
		new Ajax.Updater("claimDetailsDiv", contextPath+"/GIEXSmsDtlController",{
			parameters:	{
				action	  : "showClaimDtls",
				lineCd	  : objSMSRenewal.selectedRow.lineCd,
				sublineCd : objSMSRenewal.selectedRow.sublineCd,
				issCd	  : objSMSRenewal.selectedRow.issCd,
				issueYy	  : objSMSRenewal.selectedRow.issueYy,
				polSeqNo  : objSMSRenewal.selectedRow.polSeqNo,
				renewNo   : objSMSRenewal.selectedRow.renewNo
			},
			
	    	evalScripts: true,
			asynchronous: false,
			onComplete: function (response) {			
				if (checkErrorOnResponse(response)) {
				
				}
			}
		});
	}
	
	$("btnClosePolicyDtls").observe("click", function(){
		policyDtlsOverlay.close();
	});
	
	$("policyNo").focus();
	showClaimDtls();
	initializeAccordion();
	objSMSRenewal.populatePolicyNo();
</script>