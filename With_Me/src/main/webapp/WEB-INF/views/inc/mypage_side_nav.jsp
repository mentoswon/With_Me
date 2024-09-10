<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script type="text/javascript">
function chat() {
// 	console.log("채팅창 열기: " + creatorId);
	
	var chatUrl = "/with_me/Chating"; 
//		var chatUrl = "/Chating?receiver_id=" + creatorId; 
	// encodeURIComponent 이거는 JavaScript의 내장 함수로, 
	// 문자열을 안전하게 URL에 포함할 수 있도록 특수 문자를 이스케이프(escape) 처리하여 변환해줌
	
	var popupOptions = "width=1000, height=500, scrollbars=yes, resizable=no";
	
	var chatWindow = window.open(chatUrl, "ChatWindow", popupOptions);
	
    if (chatWindow) {
        chatWindow.focus();
    } else {
        alert("팝업 창이 차단되었습니다. 팝업 차단을 해제해주세요.");
    }
}
</script>
<nav class="side_nav">
	<ul>
		<li class="depth01">
			<button type="button" class="ask" onclick="chat()" style="background-color: #FFFFFF;, border: none;">메세지</button>
		</li>
		<li class="depth01">
			<a href="QnaBoardList">나의 1:1문의</a>
		</li>
	</ul>
</nav>
