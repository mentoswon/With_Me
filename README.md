# With_Me



배포주소
http://c5d2403t2.itwillbs.com/with_me/

일반회원
- ID : test@naver.com
- PW : 12345
  
관리자
- ID : admin@naver.com
- PW : 12345

## 1. 프로젝트 개요

### 🐶 서비스 요약
--------------------
모두가 창작자가 되어 반려동물의 물품을 펀딩받을 수 있고 또한 후원자가 되어 물품을 후원할 수 있는 반려동물 전용 펀딩 사이트입니다.


### 🐱 개발 기간
------------------
2024.07.25 ~ 2024.09.13

|개발 환경||
|------|---|
|버전 관리|<img src="https://img.shields.io/badge/GitHub-181717?style=flat-square&logo=GitHub&logoColor=white"/>|
|개발 도구|<img src="https://img.shields.io/badge/Eclipse-2C2255?style=for-the-badge&logo=Eclipse%20IDE&logoColor=white">|
|개발 언어 및 프레임워크|<img src="https://img.shields.io/badge/java-007396?style=flat-square&logo=java&logoColor=white"/><img src="https://img.shields.io/badge/Spring-6DB33F?style=flat-square&logo=Spring&logoColor=white"/>|
|라이브러리|<img src="https://img.shields.io/badge/jQuery-0769AD?style=flat-square&logo=jQuery&logoColor=white"/><img src="https://img.shields.io/badge/MyBatis-000000?style=for-the-badge&logo=MyBatis&logoColor=white">|
|데이터베이스|<img src="https://img.shields.io/badge/MySQL-4479A1?style=flat-square&logo=MySQL&logoColor=white"/>|
|협업 도구|<img alt="Slack" src="https://img.shields.io/badge/Slack-4A154B?style=for-the-badge&logo=slack&logoColor=white" /><img src="https://img.shields.io/badge/Google%20Sheets-34A853?style=for-the-badge&logo=google-sheets&logoColor=white"/>|

### 👨‍💻 팀원
----------------
|팀장|부팀장|서기|팀원|팀원|
|------|---|---|---|---|
|<div align="center">[이해원](https://github.com/mentoswon)</div>|<div align="center">[최지민](https://github.com/codeJimin)</div>|<div align="center">[최민석](https://github.com/CHOIMINSEOK-KORR)</div>|<div align="center">[하지형](https://github.com/morehaji)</div>|<div align="center">[김성윤](https://github.com/Seong-yun-Kim)</div>|
|메인페이지<br>사용자 펀딩 후원<br>금융결제원 API<br>포트원 API<br>채팅 알림|창작자 펀딩 등록<br>금융결제원 API<br>포트원 API<br>CoolSMS API|채팅<웹소켓><br>마이페이지<br>로그인(카카오 로그인)/회원가입<br>CoolSMS API<br>상품관리(관리자)|스토어<br>포트원 API<br>이용안내 및 게시판|회원관리(관리자)<br>프로젝트 관리(관리자)<br>게시판 관리(관리자)|

## 2. 주요 기능
---------------------------------------------------------------------

|메인페이지|
|------|
|<img src="https://github.com/user-attachments/assets/77e27eee-dbd0-446f-86b4-fa1a08263fd6"  width="800" height="750"/>|
|- 메인페이지에서 프로젝트 확인과 펀딩, 스토어 랭킹을 확인가능|

|로그인|카카오 로그인|
|------|------|
|<img src="https://github.com/user-attachments/assets/18e3df31-5f66-4ab6-ab74-b5ae52bcb161"  width="400" height="350"/>|<img src="https://github.com/user-attachments/assets/8897b2f2-7a36-4143-94ec-5b1a9f134573"  width="400" height="350"/>|
|- 일반 로그인|- 카카오 REST API를 이용한 로그인|

|비밀번호 찾기|비밀번호 찾기|
|------|------|
|<img src="https://github.com/user-attachments/assets/9157810c-6165-4d9b-8afe-52459639a846"  width="400" height="350"/>|<img src="https://github.com/user-attachments/assets/81bd7275-48b1-4969-93fb-1706bee2435d"  width="400" height="350"/>|
|- 해당 아이디 비번 찾기|- Cool SMS API를 이용한 비밀번호 재설정|

|채팅(웹소켓)|
|------|
|<img src="https://github.com/user-attachments/assets/fd8dae32-a684-4d19-a611-2851b278c0d2"  width="700" height="450"/>|
|- 창작자 이름을 클릭해 상대방과 1:1 채팅을 할 수 있도록 설정<br>- 웹소켓을 이용하여 실시간으로 창작자와 문의를 할 수 있도록 구현|

