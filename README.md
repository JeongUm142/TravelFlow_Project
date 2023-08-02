# TravelFlow_Project

# 🖥 개요  
- 23.05.02 ~ 23.05.15
- 여행커뮤니티 게시판  
- 개인프로젝트
 
# 🛠️ 개발 환경
- OS(운영체제): `MAC`
- Library (라이브러리): `Bootstrap`
- Language (언어) : `HTML5` `CSS` `Java(JavaSE-17)`
- Database (데이터베이스) : `MariaDB` `Sequel Ace`
- WAS (Web Application Server) : `Apache Tomcat9`
- IDE (통합 개발 환경) : `Eclipse(4.26.0)`

# 📌 주요 기능
- 로그인 / 로그아웃
  - 로그인 / 로그아웃 시 **Session** 생성 및 삭제
- 회원가입
  - ID 중복 검사
  - 비밀번호 확인
- 마이페이지
  - 비밀번호 수정 & 새 비밀번호 재확인
  - 회원탈퇴
- 카테고리
  - 관리자만 접근
  - 추가, 읽기, 수정, 삭제(CRUD)
  - 카테고리명 중복 검사
  - 해당 카테고리에 게시물이 없을 경우에만 삭제
- 게시글
  - 작성, 읽기, 수정, 삭제(CRUD)
  - 작성자에 한해서만 수정, 삭제
  - 카테고리별 정렬 및 페이징(**Pagination**, 숫자포함)
- 게시물 댓글
  - 작성, 읽기, 수정, 삭제(CRUD)
  - 작성자에 한해서만 수정, 삭제
- 오류 메시지
  - **URLEncoder**를 사용하여 오류 메시지 노출
  - 수정 실패 및 비밀번호 오류 메시지 노출

# 🔎미리보기
|메인화면(로그인 전)|메인화면(로그인 후)|
|--|--|
|<img width="800" alt="로그인전 " src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/9cd9e132-998b-4749-bad1-0e239ff3be44">|<img width="800" alt="로그인후" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/9543e085-f66e-42cf-afa8-39ebdfb881de">|

|회원가입|회원탈퇴|
|--|--|
|<img width="1440" alt="회원가입" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/fc462da0-2e55-40f8-8656-dd65c750c8f6">|<img width="1440" alt="회원탈퇴" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/aae392fe-9abb-4db9-8dc2-75e55d9a36e4">|

|(관리자)카테고리 리스트|(관리자)카테고리 추가|
|--|--|
|<img width="800" alt="카테고리 리스트" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/233acc81-f0f1-406f-8eb3-12045841fa5b">|<img width="800" alt="카테고리추가" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/af81945e-4830-4ef4-9db1-fc3ecaaf65ca">|

|(관리자)카테고리 수정|(관리자)카테고리 삭제|
|--|--|
|<img width="800" alt="카테고리 수정" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/944f0b8f-d5c7-4d52-b0a7-0348a6ce0d12">|<img width="800" alt="카테고리삭제" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/dd547cd5-5ecc-4028-b346-d4b39c005cf2">

|게시물 상세(댓글 포함)|게시물 추가|
|--|--|
|<img width="800" alt="댓글 상세" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/4a6697ae-19e8-428a-8152-2176ace50fa5">|<img width="800" alt="게시물추가 " src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/723039fb-a2de-4fee-8f67-b53eb31569e4">|

|게시물 수정|게시물 삭제|
|--|--|
|<img width="1434" alt="게시물수정" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/6a42f757-db56-4f11-b647-76d3be78fe91">|<img width="1440" alt="게시물삭제" src="https://github.com/JeongUm142/TravelFlow_Project/assets/133733044/c05f59b3-5cbf-4bc8-af91-87a3c6962fe5">|



