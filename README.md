### jsp로 Web 구현하기
<br>
2019-12-20
<br>

#### 해결해야하는 부분

1. Dept, Emp 웹페이지 구현해보기
2. Crawling and Save bitcoin historical data in DB.  
select option을 통해 날짜 범위를 받으면 그 해당하는 부분만 테이블에 뿌리기  
뿌려진 데이터 차트로 표현해보기 


<br>

#### 에러사항

- include를 통해 header, footer를 분리했을시 jQuery 연동은 footer에 있기 때문에
script를 통해 jQuery를 이용할시 footer include한 곳보다 아래에서 작업해야 한다. (script작업은 무조건 맨 밑에서 하는 것이 좋다.)

- Crawling을 하는데 있어서 DB에 저장까지 문제없이 잘되다가 어느순간 IndexOutOfBoundsException 예외상황이 발생  
많은 자료를 한꺼번에 크롤링해서 그런건지 아니면 무슨 오류가 있는 건지 (해결 못함)

