<div id="premPaymentDiv" name="premPaymentDiv"">
	<div id="tgDiv" name="tgDiv" style="float: left; height: 275px; width: 450px; margin-top: 5px;">
		<div id="premPaymentTG" name="premPaymentTG"></div>
	</div>
	<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="width: 99%; margin-bottom: 0px;">
		<table align="center">
			<tr>
				<td><input type="button" class="button" style="width: 120px;" id="btnReturn" name="btnReturn" value="Return"></td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	var selectedIndex = -1;
	var arrGICLS029Buttons = [MyTableGrid.REFRESH_BTN];
	var objTGPremPaymentDetails = JSON.parse('${premPaymentInfoTG}'.replace(/\\/g,'\\\\'));
	try{
		var premPaymentModel = {
			url: contextPath+"/GICLReserveSetupController?action=getPremPayment&refresh=1&claimId=${claimId}",
			options: {
				title: '',
	          	height: '250px',
	          	width: '450px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = premPaymentTableGrid._mtgId;
	            	selectedIndex = -1;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		selectedIndex = y;
	            	}
	            	premPaymentTableGrid.keys.removeFocus(premPaymentTableGrid.keys._nCurrentFocus, true);
	            	premPaymentTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	premPaymentTableGrid.keys.removeFocus(premPaymentTableGrid.keys._nCurrentFocus, true);
	            	premPaymentTableGrid.keys.releaseKeys();
	            }/* ,
	            toolbar: {
	            	elements: (arrGICLS029Buttons) // andrew - 09.18.2012 - comment out
	            } */
			},
			columnModel:[
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
							id:	'refNo',
							title: 'Payment No.',
							width: '173px'
						},
						{
							id:	'tranDate',
							title: 'Date',
							align: 'center',
							width: '100px',
							type: 'date',
							format: 'mm-dd-yyyy'
						},
						{
							id:	'premiumAmt',
							title: 'Premium Amt.',
							titleAlign: 'right',
							align: 'right',
							width: '165px',
							geniisysClass: 'money'
						}
						],
					rows: objTGPremPaymentDetails.rows
		};
		premPaymentTableGrid = new MyTableGrid(premPaymentModel);
		premPaymentTableGrid.pager = objTGPremPaymentDetails;
		premPaymentTableGrid.render('premPaymentTG');
	}catch(e){
		showMessageBox("Error in Premium Payment: " + e, imgMessage.ERROR);		
	}
	
	$("btnReturn").observe("click", function(){
		premPaymentTableGrid.keys.removeFocus(premPaymentTableGrid.keys._nCurrentFocus, true);
    	premPaymentTableGrid.keys.releaseKeys();
		premPayment.close();
	});
</script>