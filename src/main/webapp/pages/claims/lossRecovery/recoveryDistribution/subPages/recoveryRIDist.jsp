<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<div id="outerDiv" name="outerDiv">
	<div id="innerDiv" name="innerDiv">
  		<label>Recovery RI Distribution</label>
  		<span class="refreshers" style="margin-top: 0;">
  			<label name="gro" style="margin-left: 5px;">Hide</label>
   		</span>
	</div>
	</div>
	<div id="recoveryRIDistSectionDiv" class="sectionDiv">
		<div id="recoveryRIDistGrid" style="height: 140px; margin: 10px; margin-bottom: 35px;"></div>
	</div>
</div>
<script type="text/javascript">
	try{
		addStyleToInputs();
		initializeAll();
		initializeAllMoneyFields();
		 
		var tableModel = {
			url : contextPath+"/GICLClmRecoveryDistController?action=getClmRecoveryRIDistGrid",
			options:{
				hideColumnChildTitle: true
			},
			columnModel: [
				{	id: 'recordStatus',
				    title : '',
				    width: '0',
				    visible: false,
				    editor: "checkbox"
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	id: 'recoveryId',
					width: '0',
					visible: false
				},
				{	id: 'recoveryPaytId',
					width: '0',
					visible: false
				},
				{	id: 'recDistNo',
					width: '0',
					visible: false
				},
				{	id: 'grpSeqNo',
					width: '0',
					visible: false
				},
				{	id: 'riCd',
					width: '100',
					title: 'Reinsurer Code',
					titleAlign: 'right',
					align: 'right'
				},
				{	id: 'dspRiName',
					width: '350',
					title: 'Reinsurer'
				},
				{	id: 'shareRiPct',
					width: '160',
					title: 'Share Percentage',
					titleAlign: 'right',
					geniisysClass: 'money',
					align: 'right'	
				},
				
				{	id: 'shrRiRecoveryAmt',
					title: 'Share Recovery Amount',
					titleAlign: 'right',
					width: '230',
					geniisysClass: 'money',
					align: 'right'				
				}
			],
			rows: [],
			id: 30
		};
			recRIDistTB = new MyTableGrid(tableModel);
			recRIDistTB.pager = {};
			recRIDistTB.render('recoveryRIDistGrid');
			recRIDistTB.afterRender = function(){
				try {
					if(recRIDistTB.geniisysRows.length > 0) {
						objGICLS054RiDist = recRIDistTB.geniisysRows;

						if(changeTag == 1){
							if(objCLM.recoveryDistCurrRow.shareType != 1) {					
								for(var count = 0; count < objGICLS054RiDist.length; count ++){
									var row = objGICLS054RiDist[count];
									row.shareRiPct = parseFloat(objCLM.recoveryDistCurrRow.sharePct) * parseFloat(row.shareRiPctReal) / 100;
									row.shrRiRecoveryAmt = parseFloat(objCLM.recoveryDistCurrRow.shrRecoveryAmt) * parseFloat(row.shareRiPctReal) / 100;
									recRIDistTB.updateVisibleRowOnly(row, count);
								}
							}
						}
						
					}
				} catch (e) {
					showErrorMessage("recRIDistTB", e);
				}
			};
			
	}catch(e){
		showErrorMessage("Recovery RI Dist", e);
	}
</script>