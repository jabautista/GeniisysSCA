<%@ taglib prefix="c" uri="/WEB-INF/tld/c.tld" %>

<div class="pager" id="pager">
	<c:if test="${noOfPages gt 1}">
		<div align="right">
		Page:
			<select id="page" name="page">
				<c:forEach var="i" begin="1" end="${noOfPages}" varStatus="status">
					<option value="${i}"
						<c:if test="${pageNo eq i}">
							selected="selected"
						</c:if>
					>${i}</option>
				</c:forEach>
			</select> of ${noOfPages}
		</div>
		<script>
			positionPageDiv();
		</script>
	</c:if>
</div>