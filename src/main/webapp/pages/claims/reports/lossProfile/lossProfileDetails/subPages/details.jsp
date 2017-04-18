<div id="detailsMainDiv" style="float: left;">
	<div id="rangeDetailsTGDiv" style="height: 190px; float: left; margin: 10px; margin-left: 245px; ">
	
	</div>
	<div id="detailsTGDiv" style="height: 280px; clear: both; float: left; margin: 0px 0px 0px 10px; ">
	
	</div>
	<div id="totalDiv" style="margin: 0px 0px 10px 10px; float: left;">
		<table width="95%" style="margin-left: 10px;" >
			<tr>
				<td>
					<td class="rightAligned" width="120px">Gross Loss</td>
					<td>
						<input type="text" id="txtSumNbtGrossLossDtl" style="width: 130px; text-align: right;"/>
					</td>
					<td class="rightAligned" width="120px">Net Retention</td>
					<td>
						<input type="text" id="txtSumNbtNetRetDtl" style="width: 130px; text-align: right;"/>
					</td>
					<td class="rightAligned" width="100px">Treaty</td>
					<td>
						<input type="text" id="txtSumTreatyDtl" style="width: 130px; text-align: right;"/>
					</td>
					<td class="rightAligned" width="100px">Facultative</td>
					<td>
						<input type="text" id="txtSumFaculDtl" style="width: 130px; text-align: right;"/>
					</td>
				</td>
			</tr>
		</table>
	</div>
	<div id="buttonDiv" style="float: left;">
		<input type="button" class="button" id="btnRecovery" value="Recovery" style="width: 150px; margin: 15px 0px 40px 400px; "/>
	</div>
	<div id="hiddenDiv">
		<input type="hidden" id="hidClaimId" />
		<input type="hidden" id="hidExtr" />
	</div>
</div>
<script type="text/JavaScript">
try{
	try{
		var objLPDtlRange = new Object();
		objLPDtlRange.objLossProfileDtlRangeTableGrid = JSON.parse('${jsonRangeDtl}');
		objLPDtlRange.objLossProfileDtlRange = objLPDtlRange.objLossProfileDtlRangeTableGrid.rows || []; 
		
		var lossProfileDtlRangeModel = {
			url:contextPath+"/GICLLossProfileController?action=showDtlRange&refresh=1&lineCd="+nvl($F("txtDtlLineCd"), $F("txtLineCd"))+"&sublineCd="+nvl($F("txtDtlSublineCd"), $F("txtSublineCd")),
			options:{
				id: 4,
				width: '430px',
				height: '157px',
				onCellFocus: function(element, value, x, y, id){
					objLPDtlRange.rangeFrom = unformatCurrencyValue(lossProfileDtlRangeTableGrid.geniisysRows[y].rangeFrom);
					objLPDtlRange.rangeTo = unformatCurrencyValue(lossProfileDtlRangeTableGrid.geniisysRows[y].rangeTo);
					objLPDtlRange.extr = $("rdoTsi").checked ? "1" : "2";
					$("hidExtr").value = $("rdoTsi").checked ? "1" : "2";
					
					queryDetail(objLPDtlRange.rangeFrom, objLPDtlRange.rangeTo, objLPDtlRange.extr);
					
					lossProfileDtlRangeTableGrid.keys.removeFocus(lossProfileDtlRangeTableGrid.keys._nCurrentFocus, true);
					lossProfileDtlRangeTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus:function(element, value, x, y, id){
					queryDetail(-1, -1, 0);
					
					$("txtSumNbtGrossLossDtl").value = "0.00";
					$("txtSumNbtNetRetDtl").value = "0.00";
					$("txtSumTreatyDtl").value = "0.00";
					$("txtSumFaculDtl").value = "0.00";
					
					lossProfileDtlRangeTableGrid.keys.removeFocus(lossProfileDtlRangeTableGrid.keys._nCurrentFocus, true);
					lossProfileDtlRangeTableGrid.keys.releaseKeys();
				},
			},
			columnModel:[
		 		{   id: 'recordStatus',
				    title: '',
				    width: '0px',
				    visible: false,
				    editor: 'checkbox' 			
				},
				{	id: 'divCtrId',
					width: '0px',
					visible: false
				},
				{	id: 'rangeFrom',
					title: 'From',
					width: '195px',
					align: 'right',
					geniisysClass: 'money',
					sortable: false,
					visible: true
				},
				{	id: 'rangeTo',
					title: 'To',
					width: '195px',
					align: 'right',
					geniisysClass: 'money',
					sortable: false,
					visible: true
				},
			],
			rows: objLPDtlRange.objLossProfileDtlRange
		};
		lossProfileDtlRangeTableGrid = new MyTableGrid(lossProfileDtlRangeModel);
		lossProfileDtlRangeTableGrid.pager = objLPDtlRange.objLossProfileDtlRangeTableGrid;
		lossProfileDtlRangeTableGrid.render('rangeDetailsTGDiv');
		lossProfileDtlRangeTableGrid.afterRender = function(){
			
		};
	}catch(e){
		showErrorMessage("range tablegrid",e);
	}
	
	objLPDtlRange.rangeFrom = 0;
	objLPDtlRange.rangeTo = 0;
	
	function queryDetail(rangeFrom, rangeTo, extr){
		try{
			lossProfileDetailTableGrid.url = contextPath+"/GICLLossProfileController?action=showDetail&refresh=1&lineCd="+nvl($F("txtDtlLineCd"), $F("txtLineCd"))+"&sublineCd="+nvl($F("txtDtlSublineCd"), $F("txtSublineCd"))
			   +"&rangeFrom="+rangeFrom+"&rangeTo="+rangeTo+"&globalExtr="+extr;
			
			lossProfileDetailTableGrid._refreshList();
		}catch(e){
			showErrorMessage("queryDetail", e);
		}
	}
	
	var objLPdtl = new Object();
	objLPdtl.objLossProfileDetailTableGrid = {}; //JSON.parse('${jsonDetailList}');
	objLPdtl.objLossProfileDetail = objLPdtl.objLossProfileDetailTableGrid.rows || []; 
	
	function initializeLossProfileDetailTsi(){
		try{
			var lossProfileDetailModel = {
				url:contextPath+"/GICLLossProfileController?action=showDetail&refresh=1&lineCd="+nvl($F("txtDtlLineCd"), $F("txtLineCd"))+"&sublineCd="+nvl($F("txtDtlSublineCd"), $F("txtSublineCd"))
							   +"&rangeFrom="+objLPDtlRange.rangeFrom+"&rangeTo="+objLPDtlRange.rangeTo
							   +"&globalExtr=1",
				options:{
					id: 5,
					width: '900px',
					height: '248px',
					onCellFocus: function(element, value, x, y, id){
						checkRecovery(lossProfileDetailTableGrid.geniisysRows[y].claimId);
						objLPdtl.claimId = lossProfileDetailTableGrid.geniisysRows[y].claimId; 
						$("hidClaimId").value = lossProfileDetailTableGrid.geniisysRows[y].claimId;
						
						lossProfileDetailTableGrid.keys.removeFocus(lossProfileDetailTableGrid.keys._nCurrentFocus, true);
						lossProfileDetailTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						disableButton("btnRecovery");
						lossProfileDetailTableGrid.keys.removeFocus(lossProfileDetailTableGrid.keys._nCurrentFocus, true);
						lossProfileDetailTableGrid.keys.releaseKeys();
					},
					toolbar:{
						elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
						onRefresh: function() {
							lossProfileDetailTableGrid.keys.removeFocus(lossProfileDetailTableGrid.keys._nCurrentFocus, true);
							lossProfileDetailTableGrid.keys.releaseKeys();
						}
					},
				},
				columnModel:[
			 		{   id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{	id: 'nbtPol',
						title: 'Policy No.',
						width: '195px',
						align: 'left',
						visible: true,
						filterOption : true
					},
					{	id: 'tsiAmt',
						title: 'TSI Amt',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtClaimNo',
						title: 'Claim no.',
						width: '125px',
						align: 'left',
						visible: true,
						filterOption : true
					},
					{	id: 'assuredName',
						title: 'Assured',
						width: '225px',
						align: 'left',
						visible: true,
						filterOption : true
					},
					{	id: 'nbtGrossLoss',
						title: 'Gross Loss',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtNetRet',
						title: 'Net Retention',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtTreaty',
						title: 'Treaty',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtFacul',
						title: 'Facultative',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: [] //objLPdtl.objLossProfileDetail
			};
			lossProfileDetailTableGrid = new MyTableGrid(lossProfileDetailModel);
			lossProfileDetailTableGrid.pager = objLPdtl.objLossProfileDetailTableGrid;
			lossProfileDetailTableGrid.render('detailsTGDiv');
			lossProfileDetailTableGrid.afterRender = function(){
				try{
					if(lossProfileDetailTableGrid.geniisysRows.length > 0){
						$("txtSumNbtGrossLossDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtGrossLoss);
						$("txtSumNbtNetRetDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtNetRet);
						$("txtSumTreatyDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtTreaty);
						$("txtSumFaculDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtFacul);	
					}else{
						$("txtSumNbtGrossLossDtl").value = "0.00";
						$("txtSumNbtNetRetDtl").value = "0.00";
						$("txtSumTreatyDtl").value = "0.00";
						$("txtSumFaculDtl").value = "0.00";
					}
				}catch(e){
					showErrorMessage("tsi lossProfileDetailTableGrid.afterRender", e);
				}
			};
		}catch(e){
			showErrorMessage("initializeLossProfileDetailTsi",e);
		}
	}
	
	function initializeLossProfileDetailLoss(){
		try{
			var lossProfileDetailModel = {
				url:contextPath+"/GICLLossProfileController?action=showDetail&refresh=1&lineCd="+nvl($F("txtDtlLineCd"), $F("txtLineCd"))+"&sublineCd="+nvl($F("txtDtlSublineCd"), $F("txtSublineCd"))
							   +"&rangeFrom="+objLPDtlRange.rangeFrom+"&rangeTo="+objLPDtlRange.rangeTo
							   +"&globalExtr=2",
				options:{
					id: 6,
					width: '900px',
					height: '248px',
					onCellFocus: function(element, value, x, y, id){
						checkRecovery(lossProfileDetailTableGrid.geniisysRows[y].claimId);
						objLPdtl.claimId = lossProfileDetailTableGrid.geniisysRows[y].claimId;
						$("hidClaimId").value = lossProfileDetailTableGrid.geniisysRows[y].claimId;
						
						lossProfileDetailTableGrid.keys.removeFocus(lossProfileDetailTableGrid.keys._nCurrentFocus, true);
						lossProfileDetailTableGrid.keys.releaseKeys();
					},
					onRemoveRowFocus:function(element, value, x, y, id){
						disableButton("btnRecovery");
						lossProfileDetailTableGrid.keys.removeFocus(lossProfileDetailTableGrid.keys._nCurrentFocus, true);
						lossProfileDetailTableGrid.keys.releaseKeys();
					}					
				},
				columnModel:[
			 		{   id: 'recordStatus',
					    title: '',
					    width: '0px',
					    visible: false,
					    editor: 'checkbox' 			
					},
					{	id: 'divCtrId',
						width: '0px',
						visible: false
					},
					{	id: 'nbtPol',
						title: 'Policy No.',
						width: '195px',
						align: 'left',
						visible: true
					},
					{	id: 'lossAmt',
						title: 'Loss Amt',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtClaimNo',
						title: 'Claim no.',
						width: '125px',
						align: 'left',
						visible: true
					},
					{	id: 'assuredName',
						title: 'Assured',
						width: '225px',
						align: 'left',
						visible: true
					},
					{	id: 'nbtGrossLoss',
						title: 'Gross Loss',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtNetRet',
						title: 'Net Retention',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtTreaty',
						title: 'Treaty',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
					{	id: 'nbtFacul',
						title: 'Facultative',
						width: '155px',
						align: 'right',
						geniisysClass: 'money',
						visible: true
					},
				],
				rows: objLPdtl.objLossProfileDetail
			};
			lossProfileDetailTableGrid = new MyTableGrid(lossProfileDetailModel);
			lossProfileDetailTableGrid.pager = objLPdtl.objLossProfileDetailTableGrid;
			lossProfileDetailTableGrid.render('detailsTGDiv');
			lossProfileDetailTableGrid.afterRender = function(){
				try{
					if(lossProfileDetailTableGrid.geniisysRows.length > 0){
						$("txtSumNbtGrossLossDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtGrossLoss);
						$("txtSumNbtNetRetDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtNetRet);
						$("txtSumTreatyDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtTreaty);
						$("txtSumFaculDtl").value = formatCurrency(lossProfileDetailTableGrid.geniisysRows[0].sumNbtFacul);	
					}else{
						$("txtSumNbtGrossLossDtl").value = "0.00";
						$("txtSumNbtNetRetDtl").value = "0.00";
						$("txtSumTreatyDtl").value = "0.00";
						$("txtSumFaculDtl").value = "0.00";
					}
				}catch(e){
					showErrorMessage("loss lossProfileDetailTableGrid.afterRender", e);
				}
			};
		}catch(e){
			showErrorMessage("initializeLossProfileDetailLoss",e);
		}
	}
	
	if($("rdoTsi").checked){
		initializeLossProfileDetailTsi();
	}else{
		initializeLossProfileDetailLoss();
	}
	
	disableButton("btnRecovery");
	
	function checkRecovery(claimId){
		new Ajax.Request(contextPath+"/GICLLossProfileController?action=checkRecovery",{
			parameters : {
				claimId : claimId
			},
			onComplete : function(response){
				if(checkErrorOnResponse(response) && checkCustomErrorOnResponse(response)){
					if(response.responseText == "Y"){
						enableButton("btnRecovery");
					}else{
						disableButton("btnRecovery");
					}
				}
			}
		});
	}
	
	function showRecoveryListing(){
		try{
			lossProfileRecoveryOverlay = Overlay.show(contextPath+"/GICLLossProfileController",{
				urlContent: true,
				urlParameters: {
					action : "showRecoveryListing",
					claimId : $F("hidClaimId"),
					globalExtr : $F("hidExtr")
				},
				title: "Recovery",
				height: 350,
				width: 802,
				draggable: true
			});
		}catch(e){
			showErrorMessage("showRecoveryListing", e);
		}
	}
	
	$("btnRecovery").observe("click", showRecoveryListing);
}catch(e){
	showErrorMessage("details page",e);
}
</script>