<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!-- message.jsp -->
<script type="text/javascript">
	alert("${msg}")
	if ("${url}" && "${url}" !== "") {
                window.location.href = "${url}";
            } else {
                history.back();
            }
</script>