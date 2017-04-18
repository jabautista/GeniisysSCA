<div id="docsOnFileDic" name="docsOnFileDiv"">
	<div id="tgDiv" name="tgDiv" style="float: left; height: 275px; width: 450px; margin-top: 5px;">
		<div id="reqdDocsTG" name="reqdDocsTG"></div>
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
	var objTGDocsInfoDetails = JSON.parse('${reqdDocsTableGrid}'.replace(/\\/g,'\\\\'));
	try{
		var docsInfoModel = {
			url: contextPath+"/GICLReserveSetupController?action=getDocsOnFile&refresh=1&claimId=${claimId}",
			options: {
				title: '',
	          	height: '250px',
	          	width: '450px',
	          	onCellFocus: function(element, value, x, y, id){
	          		var mtgId = docsInfoTableGrid._mtgId;
	            	selectedIndex = -1;
	            	if($('mtgRow'+mtgId+'_'+y).hasClassName("selectedRow")){
	            		selectedIndex = y;
	            	}
	            	docsInfoTableGrid.keys.removeFocus(docsInfoTableGrid.keys._nCurrentFocus, true);
	            	docsInfoTableGrid.keys.releaseKeys();
	            },
	            onRemoveRowFocus: function(){
	            	docsInfoTableGrid.keys.removeFocus(docsInfoTableGrid.keys._nCurrentFocus, true);
	            	docsInfoTableGrid.keys.releaseKeys();
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
							id:	'clmDocCd',
							width: '0px',
							visible: false
						},
						{
							id:	'lineCd',
							width: '0px',
							visible: false
						},
						{
							id:	'sublineCd',
							width: '0px',
							visible: false
						},
						{
							id:	'clmDocDesc',
							title: 'Document',
							width: '334px'
						},
						{
							id:	'docCmpltdDt',
							title: 'Date',
							align: 'center',
							width: '100px',
							type: 'date',
							format: 'mm-dd-yyyy'
						}
						],
					rows: objTGDocsInfoDetails.rows
		};
		docsInfoTableGrid = new MyTableGrid(docsInfoModel);
		docsInfoTableGrid.pager = objTGDocsInfoDetails;
		docsInfoTableGrid.render('reqdDocsTG');
	}catch(e){
		showMessageBox("Error in Documents on File: " + e, imgMessage.ERROR);		
	}

	$("btnReturn").observe("click", function(){
		docsInfoTableGrid.keys.removeFocus(docsInfoTableGrid.keys._nCurrentFocus, true);
    	docsInfoTableGrid.keys.releaseKeys();
		docsOnFile.close();
	});
</script>