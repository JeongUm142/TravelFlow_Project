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
  - 비밀번호 수정
  - 회원탈퇴
- 카테고리
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
