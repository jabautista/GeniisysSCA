<div id="reserveWordMainDiv" name="reserveWordMainDiv" style="height:400px;">
	<div id="reserveWordSectionDiv" class="sectionDiv" style="height: 350px; width: 500px; margin-top: 10px;">
		<div id="tableGridDiv" name="tableGridDiv" style="margin-top: 10px; margin-left: 10px; height: 290px;">
			<div id="reserveWordTable" style="height: 190px;"></div>
		</div>
		<table style="margin-top: 10px; margin-left: 10px;">
			<tr>
				<td width="" class="rightAligned">Remarks</td>
				<td class="leftAligned" colspan="3">
					<div id="remarksDiv" name="remarksDiv" style="float: left; width: 420px; border: 1px solid gray; height: 22px;">
						<textarea style="float: left; height: 16px; width: 390px; margin-top: 0; border: none; resize: none;" id="txtRemarks" name="txtRemarks" maxlength="4000"  onkeyup="limitText(this,4000);" tabindex="301"></textarea>
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" style="width: 14px; height: 14px; margin: 3px; float: right;" alt="Edit" id="editRemarks"  tabindex="302"/>
					</div>
				</td>
			</tr>	
		</table>
	</div>	
	<div class="buttonsDiv" style="width: 510px; margin-bottom: 10px;">
		<input type="button" class="button" id="btnReturn" name="btnReturn" value="Return" style="width:150px;" tabindex="303"/>
	</div>
	
</div>

<script type="text/javascript">	
	try{
		var objReserveWord = new Object();
		objReserveWord.objReserveWordListing = JSON.parse('${jsonReserveWord}');
		var tbgReserveWord = {
				url: contextPath+"/GISMMessageTemplateController?action=showReserveWord&refresh=1",
			options: {
				width: '480px',
				height: '270px',
				hideColumnChildTitle: true,
				onCellFocus: function(element, value, x, y, id){
					row = y;
					reserveWordTableGrid.keys.removeFocus(reserveWordTableGrid.keys._nCurrentFocus, true);
					reserveWordTableGrid.keys.releaseKeys();
				},
				onRemoveRowFocus: function(){
					reserveWordTableGrid.keys.removeFocus(reserveWordTableGrid.keys._nCurrentFocus, true);
					reserveWordTableGrid.keys.releaseKeys();
	            },
                onSort: function(){
                	reserveWordTableGrid.keys.removeFocus(reserveWordTableGrid.keys._nCurrentFocus, true);
            		reserveWordTableGrid.keys.releaseKeys();
                },
                prePager: function(){
                	reserveWordTableGrid.keys.removeFocus(reserveWordTableGrid.keys._nCurrentFocus, true);
            		reserveWordTableGrid.keys.releaseKeys();
                },
				onRefresh: function(){
					reserveWordTableGrid.keys.removeFocus(reserveWordTableGrid.keys._nCurrentFocus, true);
					reserveWordTableGrid.keys.releaseKeys();
				},
				toolbar: {
					elements: [MyTableGrid.REFRESH_BTN, MyTableGrid.FILTER_BTN],
					onFilter: function(){
						reserveWordTableGrid.keys.removeFocus(reserveWordTableGrid.keys._nCurrentFocus, true);
						reserveWordTableGrid.keys.releaseKeys();
					}
				}
			},
			columnModel: [
				{
					id : 'recordStatus',
					width : '0',
					visible : false
				},
				{	id: 'divCtrId',
					width: '0',
					visible: false
				},
				{	
					id: 'reserveWord',
					title: 'Reserve Word',
					width: '150px',
					filterOption: true
				},
				{	
					id: 'reserveDesc',
					title: 'Description',
					width: '330px',
					filterOption: true
				}
				],
			rows: objReserveWord.objReserveWordListing.rows
		};
		
		reserveWordTableGrid = new MyTableGrid(tbgReserveWord);
		reserveWordTableGrid.pager = objReserveWord.objReserveWordListing;
		reserveWordTableGrid.render('reserveWordTable');
		reserveWordTableGrid.afterRender = function(y) {
			$("txtRemarks").value = reserveWordTableGrid.geniisysRows[row].remarks;
		};
		
	}catch (e) {
		showErrorMessage("reserveWordTableGrid", e);
	}
	
	$("editRemarks").observe("click", function(){
		showOverlayEditor("txtRemarks", 4000, $("txtRemarks").hasAttribute("readonly"));
	});
	
	$("btnReturn").observe("click", function() {
		overlayReserveWord.close();
	});
	
</script>