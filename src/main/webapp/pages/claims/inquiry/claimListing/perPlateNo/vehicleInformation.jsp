<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %> <!-- edited by MarkS 9.27.2016 SR5656 to handle data with double quotes and escape them -->
<div id="vehicleInfoDiv">
<!-- edited by MarkS 9.27.2016 SR5656 to handle data with double quotes and escape them in all input fields -->
	<table align="center" style="margin: 10px auto;">
		<tr>
			<td width="90px">Owner</td>
			<td> : </td>
			<td><input type="text" id="txtOwner" value="${fn:escapeXml(owner)}" readonly="readonly" style="width: 200px;" tabindex="501"/></td>
			<td width="20px"></td>
			<td>Basic Color</td>
			<td> : </td>
			<td><input type="text" id="txtBasicColor" value="${fn:escapeXml(vehicleInfo.basicColor)}" readonly="readonly" style="width: 200px;" tabindex="506"/></td>
		</tr>
		
		<tr>
			<td>Model Year</td>
			<td> : </td>
			<td><input type="text" id="txtModelYear" value="${fn:escapeXml(vehicleInfo.modelYear)}" readonly="readonly" style="width: 200px;" tabindex="502"/></td>
			<td width="20px"></td>
			<td>Color</td>
			<td> : </td>
			<td><input type="text" id="txtColor" value="${fn:escapeXml(vehicleInfo.color)}" readonly="readonly" style="width: 200px;" tabindex="507"/></td> 
		</tr>
		
		<tr>
			<td>Motor Number</td>
			<td> : </td>
			<td><input type="text" id="txtMotorNumber" value="${fn:escapeXml(vehicleInfo.motorNo)}" readonly="readonly" style="width: 200px;" tabindex="503"/></td>
			<td width="20px"></td>
			<td>Car Company</td>
			<td> : </td>
			<td><input type="text" id="txtCarCompany" value="${fn:escapeXml(vehicleInfo.carCompany)}" readonly="readonly" style="width: 200px;" tabindex="508"/></td>
		</tr>
		
		<tr>
			<td>Serial Number</td>
			<td> : </td>
			<td><input type="text" id="txtSerialNumber" value="${fn:escapeXml(vehicleInfo.serialNo)}" readonly="readonly" style="width: 200px;" tabindex="504"/></td>
			<td width="20px"></td>
			<td>Make</td>
			<td> : </td>
			<td><input type="text" id="txtMake" value="${fn:escapeXml(vehicleInfo.make)}" readonly="readonly" style="width: 200px;" tabindex="509"/></td>
		</tr>
		
		<tr>
			<td>Motor Type</td>
			<td> : </td>
			<td><input type="text" id="txtMotorType" value="${fn:escapeXml(vehicleInfo.motorTypeDesc)}" readonly="readonly" style="width: 200px;" tabindex="505"/></td>
			<td width="20px"></td>
			<td>Engine Series</td>
			<td> : </td>
			<td><input type="text" id="txtEngineSeries" value="${fn:escapeXml(vehicleInfo.engineSeries)}" readonly="readonly" style="width: 200px;" tabindex="510"/></td>
		</tr>
		
		<tr>
			<td>Other Info</td>
			<td> : </td>
			<td colspan="5" ><input type="text" id="txtOtherInfo" value="${fn:escapeXml(vehicleInfo.otherValue)}" readonly="readonly" style="width: 98.5%;" tabindex="511"/></td>
		</tr>
		<tr height="10px">
			<td colspan="7" style="border-bottom: 2px solid black;"></td>
		</tr>
	</table>
	<table align="center">
		<tr>
			<td width="90px">Driver Name</td>
			<td> : </td>
			<td colspan="4">
				<input type="text" id="txtDriverName" value="${fn:escapeXml(vehicleInfo.driverName)}" readonly="readonly" style="width: 350px;" tabindex="601"/>
			</td>
			<td width="20px"></td>
			<td>Age</td>
			<td>:</td>
			<td>
				<input type="text" id="txtDriverAge" value="${fn:escapeXml(vehicleInfo.driverAge)}" readonly="readonly" style="width: 110px;" tabindex="603"/>	
			</td>
		</tr>
		
		<tr>
			<td width="90px">Occupation</td>
			<td> : </td>
			<td colspan="4">
				<input type="text" id="txtDriverOccupation" value="${fn:escapeXml(vehicleInfo.driverOccupation)}" readonly="readonly" style="width: 350px;" tabindex="602"/>
			</td>
			<td width="20px"></td>
			<td>Gender</td>
			<td>:</td>
			<td>
				<input type="text" id="txtDriverGender" value="${fn:escapeXml(vehicleInfo.driverGender)}" readonly="readonly" style="width: 110px;" tabindex="604"/>	
			</td>
		</tr>
	</table>
	<center><input type="button" class="button" id="btnReturn" value="Return" style="margin-top: 10px;" tabindex="701" /></center>
</div>
<script>
	try {
		$("btnReturn").observe("click", function(){
			overlayVehicleInfo.close();
			delete overlayVehicleInfo;
		});
	} catch(e) {
		showErrorMessage("Error in vehicle information : ", e);
	}
</script>