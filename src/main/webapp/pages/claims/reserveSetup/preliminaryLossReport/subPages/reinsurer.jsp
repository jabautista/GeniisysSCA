<div id="reinsurerDiv" name="reinsurerDiv"">
	<div id="tgDiv" name="tgDiv" style="float: left; height: 275px; width: 500px; margin-top: 5px;">
		<div id="reinsurerTG" name="reinsurerTG"></div>
	</div>
	<div id="buttonsDiv" name="buttonsDiv" class="buttonsDiv" style="width: 99%; margin-bottom: 0px;">
		<table align="center">
			<tr>
				<td><input type="button" class="button" style="width: 120px;" id="btnReturn" name="btnReturn" value="Close"></td>
			</tr>
		</table>
	</div>
</div>

<script type="text/javascript">
	var selectedIndex = -1;
	var arrGICLS029Buttons = [MyTableGrid.REFRESH_BTN];
	var objTGReinsurerInfoDetails = JSON.parse('${reinsuranceTG}'.replace(/\\/g,'\\\\'));
	try{
		var reinsurerModel = {
				url: contextPath+"/GICLReserveSetupController?action=getReinsurance&refresh=1&claimId=${claimId}&shareCd=${shareCd}&perilCd=${perilCd}", // Lara - 10-01-2013 - added perilCd 
			options: {
				title: '',
	          	height: '250px',
	          	width: '492px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = riTableGrid._mtgId;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		selectedIndex = y;
	            	}
	            	riTableGrid.keys.removeFocus(riTableGrid.keys._nCurrentFocus, true);
	            	riTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	riTableGrid.keys.removeFocus(riTableGrid.keys._nCurrentFocus, true);
	            	riTableGrid.keys.releaseKeys();
	            }/* ,
	            toolbar: {
	            	elements: (arrGICLS029Buttons) // andrew - 09.18.2012
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
							id:	'riName',
							title: 'Reinsurer',
							width: '250px'
						},
						{
							id:	'shrRiTsiPct',
							title: 'Share Pct.',
							titleAlign: 'right',
							align: 'right',
							width: '90px',
							geniisysClass: 'rate'
						},
						{
							id:	'shrRiTsiAmt',
							title: 'TSI Amt.',
							titleAlign: 'right',
							align: 'right',
							width: '140px',
							geniisysClass: 'money'
						}
						],
					rows: objTGReinsurerInfoDetails.rows
		};
		riTableGrid = new MyTableGrid(reinsurerModel);
		riTableGrid.pager = objTGReinsurerInfoDetails;
		riTableGrid.render('reinsurerTG');
	}catch(e){
		showMessageBox("Error in Reinsurer: " + e, imgMessage.ERROR);		
	}

	$("btnReturn").observe("click", function(){
		riTableGrid.keys.removeFocus(riTableGrid.keys._nCurrentFocus, true);
		riTableGrid.keys.releaseKeys();
		reinsurance.close();
	});
</script>