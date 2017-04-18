<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div id="batchDetailHeaderDiv" name="batchDetailHeaderDiv"" style="margin: 10px 0px;" align="center">
	<table>
		<tr>
			<td class="rightAligned" style="width: 100px;">Paid Amount</td>
			<td class="leftAligned">
				<input type="text" id="paidAmount" name="paidAmount" readonly="readonly" style="width: 245px;" class="money"/>
			</td>
			<td class="rightAligned" style="width: 100px;">Currency</td>
			<td class="leftAligned">
				<input type="text" id="currency" name="currency" readonly="readonly" style="width: 245px;"/>
			</td>
		</tr>
		<tr>
			<c:choose>
				<c:when test="${isSpecial eq 'Y'}">
					<td class="rightAligned" style="width: 100px;">Local Amount</td>
					<td class="leftAligned">
						<input type="text" id="localAmount" name=""localAmount"" readonly="readonly" style="width: 245px;" class="money"/>
					</td>
				</c:when>
				<c:otherwise>
					<td class="rightAligned" style="width: 100px;">Net Amount</td>
					<td class="leftAligned">
						<input type="text" id="netAmount" name="netAmount" readonly="readonly" style="width: 245px;" class="money"/>
					</td>
				</c:otherwise>
			</c:choose>
			
			<td class="rightAligned" style="width: 100px;">Convert Rate</td>
			<td class="leftAligned">
				<input type="text" id="convertRate" name="convertRate" readonly="readonly" style="width: 245px;"/>
			</td>
		</tr>
		<tr>
			<c:if test="${isSpecial ne 'Y' }">
				<td class="rightAligned" style="width: 100px;">Advice Amount</td>
				<td class="leftAligned">
					<input type="text" id="adviceAmount" name="adviceAmount" readonly="readonly" style="width: 245px;" class="money"/>
				</td>
				<td class="rightAligned" style="width: 100px;"></td>
				<td class="leftAligned">
					<input type="button" class="button" id="btnForeignCurr" name="btnForeignCurr" value="Foreign Currency">
				</td>
			</c:if>
			
		</tr>
	</table>
</div>