<div id="moreFilterDiv" name="moreFilterDiv" style="display: none; padding: 0; width: 30%;">
	<!-- <span style="float: left; z-index: 6; width: 100%; background-color: #c0c0c0;">
		<label style="margin: 5px;">More Filters</label>
		<label id="lblCloseMoreDiv" name="closer">Close</label>
	</span> -->
	<div style="z-index: 5; float: left; width: 100%;">	
		<div style="padding: 5px; margin-bottom: 5px; border-bottom: 1px solid #fff;">
			<table>
				<tr>
					<td class="rightAligned">Keyword </td>
					<td class="leftAligned"><input type="text" id="keyword" name="keyword" style="width: 198px;" /></td>
				</tr>
				<tr>
					<td class="rightAligned" style="width: 100px;">Accept Date Range </td>
					<td class="leftAligned">
						<span style="float: left;">
							<input style="border: none;" id="from" name="from" type="text" value="" readonly="readonly" />
							<img id="hrefFromDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('from'),this, null);" style="margin: 0;" />
						</span>
						<span style="float: left; margin: 0 3px;"> - </span>
						<span style="float: left;">
							<input style="border: none;" id="to" name="to" type="text" value="" readonly="readonly" />
							<img id="hrefToDate" src="${pageContext.request.contextPath}/images/misc/but_calendar.gif" onClick="scwShow($('to'),this, null);" style="margin: 0;" />
						</span>
					</td>
				</tr>
			</table>
		</div>
	</div>
	
	<div style="z-index: 5; float: left; width: 100%;">
		<div style="padding: 5px; margin-bottom: 5px;">
			<table>
				<tr>
					<td class="rightAligned" style="width: 100px;">Status </td>
					<td class="leftAligned">
						<select id="status" name="status" style="width: 205px; float: left;">
							<option value="">All</option>
							<option value="N">New</option>
							<option value="W">With PAR</option>
							<option value="P">Posted Policy</option>
							<option value="D">Denied</option>
							<option value="X">Not Selected</option>
						</select></td>
				</tr>
				<tr>
					<td colspan="2" style="text-align: right;">
						<input type="button" id="btnFilters" name="btnFilters" value="Ok" class="button" style="width: 50px;" />
						<input type="button" id="btnFiltersCancel" name="btnFiltersCancel" value="Cancel" class="button" style="width: 50px;" />
					</td>	
				</tr>
			</table>
		</div>
	</div>
</div>