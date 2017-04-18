<div id="roadMapLegendDiv" name="roadMapLegendDiv" style="float: left; width: 30%; margin: 20px; text-align: center;" align="center">
	<label class="roadMapInfo">You are currently in the :</label>
	<label class="roadMapInfo" id="rmCurrModule" style="font-weight: bolder;"></label>
	<label class="roadMapInfo">screen, with PAR Number:</label>
	<label class="roadMapInfo" style="margin-bottom: 20px;"><b>${parNo}</b></label>
	<fieldset style="width: 190px;">
		<table>
			<tr>
				<th>Legend</th>
			</tr>
			<tr>
				<td>
					<img src="${pageContext.request.contextPath}/css/roadMap/images/curr_loc.icon">
				</td>
				<td class="leftAligned">Current Location</td>
			</tr>
			<tr>
				<td>
					<img src="${pageContext.request.contextPath}/css/roadMap/images/avail.icon">
				</td>
				<td class="leftAligned">Accessible transaction screen</td>
			</tr>
			<tr>
				<td>
					<img src="${pageContext.request.contextPath}/css/roadMap/images/unavail.icon">
				</td>
				<td class="leftAligned">Inaccessible transaction screen</td>
			</tr>
			<tr>
				<td>
					<img src="${pageContext.request.contextPath}/css/roadMap/images/no_access.icon">
				</td>
				<td class="leftAligned">PAR may be processed, but user has no right to access the screen</td>
			</tr>
			<tr>
				<td class="leftAligned">
					<img src="${pageContext.request.contextPath}/css/roadMap/images/black_bar.png" style="width: 28px; height: 3px;">
				</td>
				<td class="leftAligned">Accessible transaction path</td>
			</tr>
			<tr>
				<td class="leftAligned">
					<img src="${pageContext.request.contextPath}/css/roadMap/images/gray_bar.png" style="width: 28px; height: 3px;">
				</td>
				<td class="leftAligned">Inaccessible transaction path</td>
			</tr>
		</table>
	</fieldset>
	<div align="center" style="margin: 25px;">
		<input type="button" class="button hover" value="Cancel" id="cancelRoadMap" name="cancelRoadMap" style="width: 160px;">
	</div>
</div>