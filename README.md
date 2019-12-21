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
많은 자료를 한꺼번에 크롤링해서 그런건지 아니면 무슨 오류가 있는 건지 (웹사이트에서 막아둔 건지는 모르나 대용량으로 많은 데이터를 한꺼번에 크롤링하는 것이 막힘, 길어봐야 2년정도의 데이터정도 가능한듯)  

- 새로고침하면 alert 알림표시가 뜨는데 없앨 수는 없는지(해결 못함)  

- url parameter 줄이기  
localhost/crawling/list.jsp?page=1&start=20140711&end=20191219 이런식으로 parameter를 축약함. 원래는 start의 연,월,일따로 end의 연,월,일 따로 parameter지정해서 넘기려고 하니 url이 지저분해짐 > 하나로 묶어서 parameter로 보냄  
(select option으로 넘겼기 때문에 parameter로 start, end의 연, 월, 일 따로 지정돼있음. post방식으로 넘겨서 url에는 보이지 않음.)


