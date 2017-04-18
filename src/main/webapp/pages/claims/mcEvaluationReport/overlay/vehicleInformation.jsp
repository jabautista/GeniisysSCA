<div id="vehicleInfoDiv" style="width: 810px;">	
	<div class="sectionDiv">
		<table border="0" style="margin-top: 10px; margin-bottom: 10px;" align="center" >
			<tr>
				<td class="rightAligned">Plate No.:</td>
				<td class="leftAligned" style="width: 330px;">
					<input type="text" id="vehPlateNo" value="" style="width: 270px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Basic Color:</td>
				<td class="leftAligned">
					<input type="text" id="vehBasicColor" value="" style="width: 200px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Model Year:</td>
				<td class="leftAligned">
					<input type="text" id="vehModelYear" value="" style="width: 270px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Color:</td>
				<td class="leftAligned">
					<input type="text" id="vehColor" value="" style="width: 200px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Motor No.:</td>
				<td class="leftAligned">
					<input type="text" id="vehMotorNo" value="" style="width: 270px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Car Company:</td>
				<td class="leftAligned">
					<input type="text" id="vehCarCompany" value="" style="width: 200px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Serial No.:</td>
				<td class="leftAligned">
					<input type="text" id="vehSerialNo" value="" style="width: 270px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Make:</td>
				<td class="leftAligned">
					<input type="text" id="vehMake" value="" style="width: 200px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Motor Type:</td>
				<td class="leftAligned">
					<input type="text" id="vehMotorType" value="" style="width: 270px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Engine Series:</td>
				<td class="leftAligned">
					<input type="text" id="vehEngineSeries" value="" style="width: 200px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned" >Other Info:</td>
				<td class="leftAligned" colspan="3">
					<span id="vehOtherInfoSpan" style="border: 1px solid gray; width: 627px; height: 21px; float: left;"> 
						<input type="text" id="vehOtherInfo" style="border: none; float: left; width: 95%; background: transparent;" onKeyDown="limitText(this, 2000);" onKeyUp="limitText(this, 2000);"readonly="readonly"/> 
						<img src="${pageContext.request.contextPath}/images/misc/edit.png" id="btnVehOtherInfo" alt="Go" style="background: transparent;" />
					</span>
				</td>
			</tr>
		</table>
	</div>
	<div class="sectionDiv">
		<table border="0" style="margin-top: 10px; margin-bottom: 10px;" align="center" >
			<tr>
				<td class="rightAligned">Driver Name:</td>
				<td class="leftAligned" style="width: 330px;">
					<input type="text" id="vehDriverName" value="" style="width: 270px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Age:</td>
				<td class="leftAligned">
					<input type="text" id="vehAge" value="" style="width: 100px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Occupation:</td>
				<td class="leftAligned" >
					<input type="text" id="vehOccupation" value="" style="width: 270px;" readonly="readonly">
				</td>
				<td class="rightAligned" >Sex:</td>
				<td class="leftAligned">
					<input type="text" id="vehSex" value="" style="width: 100px;" readonly="readonly">
				</td>
			</tr>
			<tr>
				<td class="rightAligned">Address:</td>
				<td class="leftAligned" colspan="3">
					<input type="text" id="vehAddress" value="" style="width: 270px;" readonly="readonly">
				</td>
			</tr>
		</table>
	</div>
</div>
<div id="buttonsDiv" style="text-align: center; margin-bottom: 10px;">
	<div style="margin-top:10px;text-align:center">
		<input type="button" class="button" id="btnCloseVehicleInfo" value="Close" style="width:170px; margin-top: 10px;"/>
	</div>
</div>
<script type="text/javascript">
	
	var vehicleInfoObj = JSON.parse('${vehicleInfoObj}'.replace(/\\/g, '\\\\'));
	
	populateMCEvalVehicleInfo(vehicleInfoObj);
	
	
	$("btnVehOtherInfo").observe("click", function(){
		showEditor("vehOtherInfo", 2000, "true");
	});
	$("btnCloseVehicleInfo").observe("click",function(){
		genericObjOverlay.close();
	});
</script>