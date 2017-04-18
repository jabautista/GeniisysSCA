<div id="24thMethodViewDetailMainDiv" name="24thMethodViewDetailMainDiv" style="margin-top: 10px; margin-bottom: 5px; margin-left: 5px; margin-right: 5px;">
	<div id="viewDetailDiv" name="view24thMethodDetailDiv" class="sectionDiv">
		<div id="viewParamsDiv" style="margin-top: 10px; margin-bottom: 10px;">
			<table style="margin-left: 20px;">
				<tr>
					<td class="rightAligned"> Branch</td>
					<td class="leftAligned">
						<input type="text" id="txtBranchCd" name="txtBranchCd" readonly="readonly" style="width: 50px;" tabindex="101"/>
					</td>
					<td style="width: 250px;">
						<input type="text" id="txtBranchName" name="txtBranchName" readonly="readonly" style="width: 180px;" tabindex="102"/>
					</td>
					<td class="rightAligned"> Line</td>
					<td class="leftAligned">
						<input type="text" id="txtLineCd" name="txtLineCd" readonly="readonly" style="width: 50px;" tabindex="103"/>
					</td>
					<td style="width: 130px;">
						<input type="text" id="txtLineName" name="txtLineName" readonly="readonly" style="width: 180px;" tabindex="104"/>
					</td>					
				</tr>
			</table>
		</div>
	</div>
	<div id="tableDiv" class="sectionDiv" style="height: 360px;">
		<div id="viewDetailTableGridDiv" name="viewDetailTableGridDiv" style="margin-top: 10px; margin-left: 10px;"></div>
		<div id="viewButtonsDiv">
			<table align="center" style="margin-bottom: 10px;">
				<tr>
					<td><input type="button" class="button" id="btnReturnViewDtl" name="btnReturnViewDtl" value="Return" style="width: 100px;" tabindex="201"/></td>
				</tr>
			</table>
		</div>
	</div>
</div>
<script type="text/javascript">

	function getTableGrid(table) {	 //updates view details overlay page
		try {
			new Ajax.Updater("viewDetailTableGridDiv", contextPath + "/GIACDeferredController", {
				method: "POST",
				parameters: {
					action: "getGdDetail",
					year: objGiacs044.year,
					mM: objGiacs044.mM,
					procedureId: objGiacs044.procedureId,
					issCd : objGiacs044.issCd,
				    lineCd : objGiacs044.lineCd,
				    shareType : objGiacs044.shrType,
				    table : table
					},
				asynchronous: true,
				evalScripts: true,
				onCreate: function() {
					showNotice("Processing data, Please Wait..." + contextPath);
				}, 
				onComplete: function() {
					hideNotice();
				}
			});
		} catch(e) {
			showErrorMessage(e);
		}
	}

	function showViewDetails() {	//get details per selected radio button
		if (objGiacs044.table == "gdGross") {
			getTableGrid(objGiacs044.table);
		}else if (objGiacs044.table == "gdRiCeded") {
			getTableGrid(objGiacs044.table);
		}else if (objGiacs044.table == "gdInc") {
			getTableGrid(objGiacs044.table);
		}else if (objGiacs044.table == "gdExp") {
			getTableGrid(objGiacs044.table);
		}else if (objGiacs044.table == "gdRetrocede") {
			getTableGrid(objGiacs044.table);
		}
	}
	
	showViewDetails();
	
	$("btnReturnViewDtl").observe("click", function() {
		overlayViewDetails.close();
	});
	
</script>