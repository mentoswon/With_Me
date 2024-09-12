<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 

<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>with_me</title>
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link href="${pageContext.request.contextPath}/resources/css/default.css" rel="stylesheet" type="text/css">
		<link href="${pageContext.request.contextPath}/resources/css/main.css" rel="stylesheet" type="text/css">
		<script src="${pageContext.request.contextPath}/resources/js/jquery-3.7.1.js"></script>
		<style type="text/css">
			h2 {
				font-size: 16px;
				margin-bottom: 30px;
			}
			
			.sec02 .itemList {
				padding-top: 30px;
				height: 100%;
			}
			
			.sec02 .itemList .itemWrapper {
				display: grid;
				grid-template-columns: repeat(4, 1fr);
				gap: 2rem;
			}
			
			.sec02 .itemList .itemWrapper .item {
   				width: 270px;
			}
			.sec02 .itemList .itemWrapper .item .item_image {
				margin-bottom: 20px;
				width: 100%;
				height: 230px;
				position: relative;
				overflow: hidden;
			}
			
			.sec02 .itemList .itemWrapper .item .item_image:hover .thumnail {
				transform: scale(1.1);
   				transition: transform 0.5s;
			}
			
			.sec02 .itemList .itemWrapper .item .item_image .thumnail {
				width: 100%;
				height: 100%;
				object-fit: cover;
				transform: scale(1.0);
				transition: transform 0.3s;
			}
			
			.sec02 .itemList .itemWrapper .item .item_image .like {
				position: absolute;
				top: 88%;
				right: 2%;
			    width: 25px;	
			    height: 25px;
			    background-color: transparent;
			    border: none;
			    cursor: pointer;
			}
			
			.sec02 .itemList .itemWrapper .item .item_image .like img {
				width: 100%;
				height: 100%;
				object-fit: cover;
			}
			
			.sec02 .itemList .itemWrapper .item .item_info h4 {
				font-size: 13px;	
				font-weight: normal;
				color: #bbb;
				margin-bottom: 15px;	
			}
			.sec02 .itemList .itemWrapper .item .item_info h3 {
				margin-bottom: 15px;	
				text-align: left;
				font-size: 16px;
				height: 40px;
			}
			
			.sec02 .itemList .itemWrapper .item .item_info a {
				word-wrap: break-word;
			}
			
			.sec02 .itemList .itemWrapper .item .fund_info {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 15px;
			}
			
			.sec02 .itemList .itemWrapper .item .fund_info .fund_leftWrap {
				display: flex;
				align-items: center;
			} 
			
			.sec02 .itemList .itemWrapper .item .fund_info .fund_leftWrap > .fund_rate {
				margin-right: 10px;
				color: #ffab40;
				font-weight: bold;
			}	
			
			.sec02 .itemList .itemWrapper .item .fund_info .fund_leftWrap > .fund_amt {
				color: #aaa;
				font-size: 14px;
			}
				
			.progress {
				width: 100%;
				appearance: none;
				height: 7px;
			}
			
			.progress::-webkit-progress-bar {
				background-color: #eee;
				border-radius: 3px;
			}
			
			.progress::-webkit-progress-value {
				background-color: #ffab40;
				border-radius: 3px;
			}
			
			.progress.end::-webkit-progress-value {
				background-color: #ffab40;
				border-radius: 3px;
			}
			
			.set_noti {
				text-align: center;
				width: 100%;
				border: 0.5px solid #eee;
				border-radius: 5px;
				padding: 8px 0;
				font-size: 14px;
			}
			
			.set_noti:hover {
				background-color: #ffab40;
				color: #fff;
			}
			
			.filter {
				display: inline-block;
				margin-right: 10px;
				font-size: 13px;
				cursor: pointer;
			}
			
			.active-filter {
			    font-weight: bold;
			    color: #ffab40;
			}
			
			/* Mobile Responsive CSS */ 
			@media screen and (max-width:768px) {
				.sec02 .itemList .itemWrapper {
					display: grid;
					grid-template-columns: repeat(2, 1fr);
					gap: 2rem;
				}
				
				.sec02 .itemList .itemWrapper .item .fund_info {
					font-size: 13px;
				}
				
				.sec02 .itemList .itemWrapper .item .item_image .like {
					width: 20px;
					height: 20px;
				}
			}
		</style>
		
	</head>
	<body>
		<header>
			<jsp:include page="/WEB-INF/views/inc/top.jsp"></jsp:include>
		</header>
		
		<div class="inner">
			<section class="sec02">
				<c:choose>
					<c:when test="${searchKeyword ne '' && empty projectList}">
						<%-- 목록 필터 --%>
						<ul>
							<c:choose>
								<c:when test="${param.project_category_detail eq null}">
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '전체')">전체</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '진행중')">진행 중인 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '마감')">마감한 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '오픈예정')">오픈 예정 펀딩</a></li>
								</c:when>
								<c:otherwise>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '전체')">전체</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '진행중')">진행 중인 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '마감')">마감한 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '오픈예정')">오픈 예정 펀딩</a></li>
								</c:otherwise>
							</c:choose>
						</ul>
						<p style="margin-top: 30px;">
						검색결과가 없습니다. <br><br>
						이용에 불편을 드려 죄송합니다.
						</p>
					</c:when>
					<c:when test="${searchKeyword ne ''}">
						<c:choose>
							<c:when test="${param.project_category_detail eq null}">
								<h2>${param.project_category}</h2>
							</c:when>
							<c:otherwise>
								<h2>${param.project_category} > ${param.project_category_detail}</h2>
							</c:otherwise>
						</c:choose>
						
						<%-- 목록 필터 --%>
						<ul>
							<c:choose>
								<c:when test="${param.project_category_detail eq null}">
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '전체')">전체</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '진행중')">진행 중인 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '마감')">마감한 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '', '오픈예정')">오픈 예정 펀딩</a></li>
								</c:when>
								<c:otherwise>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '전체')">전체</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '진행중')">진행 중인 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '마감')">마감한 펀딩</a> | </li>
									<li class="filter"><a href="javascript:projectList('${param.project_category}', '${param.project_category_detail}', '오픈예정')">오픈 예정 펀딩</a></li>
								</c:otherwise>
							</c:choose>
						</ul>
											
						<%-- 페이지 번호 기본값 1로 설정 --%>
						<c:set var="pageNum" value="1"/>
						<c:if test="${not empty param.pageNum}">
							<c:set var="pageNum" value="${param.pageNum}"/>
						</c:if>
						
						<div class="itemList">
							<div class="itemWrapper">
							
							<!-- 오늘 날짜 추출 -->
							<c:set var="now" value="<%=new java.util.Date()%>" />
							<c:set var="today"><fmt:formatDate value="${now}" pattern="yyyy-MM-dd" /></c:set> 
							<!-- 오늘 날짜 추출 end -->
							
							<c:forEach var="project" items="${projectList}">
								<div class="item">
									<div class="item_image">
										<a href="ProjectDetail?project_code=${project.project_code}">
											<img alt="이미지" class="thumnail" src="${pageContext.request.contextPath}/resources/upload/${project.project_image}">
										</a>
										<c:choose>
											<c:when test="${project.like_mem_email eq sId and project.like_status eq 'Y'}">
												<button class="like Btn" type="button" onclick="cancelLike('${project.project_code}', '${sId}')">
													<img alt="좋아요" class="islike" src="${pageContext.request.contextPath}/resources/image/colored_like.png">
												</button>
											</c:when>
											<c:otherwise>
												<button class="like Btn" type="button" onclick="registLike('${project.project_code}', '${sId}')">
													<img alt="좋아요" src="${pageContext.request.contextPath}/resources/image/empty_like.png">
												</button>
											</c:otherwise>
										</c:choose>
									</div>
									<div class="item_info">
										<h4><a href="OtherMemberInfo?creator_email=${project.creator_email}">${project.creator_name}</a></h4>
										<h3><a href="ProjectDetail?project_title=${project.project_title}&project_code=${project.project_code}">${project.project_title}</a></h3>
									</div>
									
									<div class="fund_info">
										<div class="fund_leftWrap">
											<%-- 펀딩률 --%>
											<fmt:parseNumber var="funding_amt" value="${project.funding_amt*1.0}" ></fmt:parseNumber>
											<fmt:parseNumber var="target_price" value="${project.target_price}" ></fmt:parseNumber>
											
											<c:set var="fund_rate" value="${funding_amt/target_price*100}"/>
											
											<c:choose>
												<c:when test="${fund_rate eq 0.0}">
													<div class="fund_rate" style="<c:if test='${project.funding_end_date < today}'> color: #575757; </c:if>" >0%</div>
												</c:when>
												<c:otherwise>
													<div class="fund_rate" style="<c:if test='${project.funding_end_date < today}'> color: #575757; </c:if>" ><fmt:formatNumber pattern="0.00">${fund_rate}</fmt:formatNumber>%</div>
												</c:otherwise>
											</c:choose>
											<%-- 펀딩률 end --%>
											
											<div class="fund_amt" style="<c:if test='${project.funding_end_date < today}'> color: #575757; </c:if>" ><fmt:formatNumber pattern="#,###">${project.funding_amt}</fmt:formatNumber> 원</div> 
										</div>
										<div class="fund_etc" style="<c:if test="${leftDay eq 0 or project.funding_start_date > today}">color:#ffab40;font-weight: bold;</c:if> <c:if test='${project.funding_end_date < today}'>font-weight: bold;</c:if>">
											<c:choose>
												<c:when test="${leftDay eq 0}">
													오늘 마감
												</c:when>
												<c:when test="${project.funding_start_date > today}">
													<fmt:formatDate value="${project.funding_start_date}" pattern="MM/dd"/>  오픈
												</c:when>
												<c:when test="${project.funding_end_date < today}">
													펀딩 마감
												</c:when>
												<c:when test="${fund_rate >= 100}">
													펀딩 성공
												</c:when>
												<c:otherwise>
												
													<!-- 남은 날짜 계산 -->
													<fmt:parseNumber value="${now.time/(1000*60*60*24)}" integerOnly="true" var="strDate"></fmt:parseNumber>
													<fmt:parseNumber value="${project.funding_end_date.time/(1000*60*60*24)}" integerOnly="true" var="endDate"></fmt:parseNumber>
													<c:set value="${endDate - strDate + 1}" var="leftDay"/>
													<!-- 남은 날짜 계산 end -->
													
													<c:out value="${leftDay}" />일 남음
												</c:otherwise>
											</c:choose>
										</div> <%-- 남은 날짜/오늘 마감/오픈 날짜/펀딩 성공 --%>
									</div>
<!-- 										<div class="fund_rate_var"></div> -->
									<c:choose>
										<c:when test="${project.funding_start_date > today}">
											<div class="set_noti" onclick="setNotiProject('${project.project_idx}')">오픈하면 알려주세요 !</div>
										</c:when>
										<c:otherwise>
											<c:choose>
												<c:when test="${project.funding_end_date < today}">
													<progress class="progress end" value="${fund_rate}" min="0" max="100"></progress>
												</c:when>
												<c:otherwise>
													<progress class="progress" value="${fund_rate}" min="0" max="100"></progress>
												</c:otherwise>
											</c:choose>
										</c:otherwise>
									</c:choose>
								</div>
							</c:forEach>
							</div>
						</div>
					</c:when>
				</c:choose>
			</section>
			
			<section id="pageList">
				<%-- 현재 페이지 번호가 1 보다 클 경우에만 가능하게 해야함 --%>
				<input type="button" value="이전" onclick="location.href='ProjectList?pageNum=${pageNum - 1}'"
						<c:if test="${pageNum <= 1}">disabled</c:if> >
				
				<%-- 계산된 페이지 번호가 저장된 PageInfo 객체를 통해 페이지 번호 출력 --%>
				<c:forEach var="i" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
					
					<c:choose>
						<c:when test="${pageNum eq i}">
							<b>${i}</b>
						</c:when>
						<c:otherwise>
							<a href="ProjectList?pageNum=${i}">${i}</a>
						</c:otherwise>
					</c:choose>
				
		<%-- 			<a href="BoardList.bo?pageNum=${i}">${i}</a> --%>
				</c:forEach>
				
				<input type="button" value="다음" onclick="location.href='ProjectList?pageNum=${pageNum + 1}'"
						<c:if test="${pageNum >= pageInfo.maxPage}">disabled</c:if>>
			</section>
		</div>
		<footer>
			<jsp:include page="/WEB-INF/views/inc/bottom.jsp"></jsp:include>
		</footer>
	</body>
	
	<script type="text/javascript">
		$(function(){
			if("${param.project_state}" == "진행중") {
				$(".filter").find($('a[href*="진행중"]')).addClass('active-filter');
			} else if("${param.project_state}" == "오픈예정") {
				$(".filter").find($('a[href*="오픈예정"]')).addClass('active-filter');
			} else if("${param.project_state}" == "마감") {
				$(".filter").find($('a[href*="마감"]')).addClass('active-filter');
			} else if("${param.project_state}" == "전체") {
				$(".filter").find($('a[href*="전체"]')).addClass('active-filter');
			}
		});
	
		// 프로젝트 필터
		function projectList(category, category_detail, state) {
			if(category_detail != "") {
				location.href="ProjectList?project_category=" + category + "&project_category_detail=" + category_detail + "&project_state=" + state;
			} else {
				location.href="ProjectList?project_category=" + category + "&project_state=" + state;
			}
		}
		
		// 프로젝트 좋아요
		function registLike(project_code, sId) {
// 				console.log("project_code : " + project_code + ", sId : " + sId);
			if(confirm("프로젝트를 좋아요 하시겠습니까?")){
				$.ajax({
					url: "RegistLike",
					type : "POST",
					async:false, // 이 한줄만 추가해주시면 됩니다.
					data:{
						"like_project_code": project_code,
						"like_mem_email": sId
					},
					dataType: "json",
					success: function (response) {
						if(response.result){
							alert("좋아한 프로젝트에 추가되었습니다.");
							location.reload();
						} else if(!response.result) {
							alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
							location.href="MemberLogin";
						}
					}
				});
			}
		}
		
		// 프로젝트 좋아요 취소
		function cancelLike(project_code, sId) {
// 				console.log("project_code : " + project_code + ", sId : " + sId);
			$.ajax({
				url: "CancelLike",
				type : "POST",
				async:false, // 이 한줄만 추가해주시면 됩니다.
				data:{
					"like_project_code": project_code,
					"like_mem_email": sId
				},
				dataType: "json",
				success: function (response) {
					if(response.result){
						alert("좋아요가 취소되었습니다.");
						location.reload();
					} else if(!response.result) {
						alert("로그인 후 이용가능합니다. \n로그인 페이지로 이동합니다.");
						location.href="MemberLogin";
					}
				}
			});
		}
		
		// 프로젝트 오픈 알림 신청 0909 추가
// 		function setNotiProject(project_idx) {
// 			alert("알림 신청이 완료되었습니다.");
// 		}
		
	</script>
</html>




















